class CVI_VMD_EOP_CHECK definition
  public
  create public .

public section.

  interfaces CVP_IF_CONST_DCPLD_I1 .
  interfaces CVP_IF_APPL_EOP_CHECK .
  interfaces CVP_IF_CONSTANTS .

  data GV_EOP_RUN_MODE type CVP_EOP_RUN_MODE .
  data GV_TEST_MODE type CVP_TEST_MODE .
  data GV_VALIDATE_NXTCHK_DATE type CVP_VALIDATE_NXTCHK_DATE .
  data GV_CHECK_PUR_COMPL_STATUS type CVP_CHECK_PUR_COMPL_STATUS .
  data GV_DETAIL_LOG type CVP_DETAIL_LOG .
  constants GC_X type CHAR1 value 'X'. "#EC NOTEXT
  data GT_PUR_CMPLT_PARTNERS_FINAL type BU_BUTSORT_MAINT_T .
  data GV_APPL type CVP_APPL_NAME .
  data GV_PROT_OUTPUT type CVP_PROT_OUTPUT .
  constants GC_TASK_FINAL_SET type CHAR9 value 'FINAL_SET'. "#EC NOTEXT
  constants GC_SPACE type CHAR1 value ' '. "#EC NOTEXT
  constants GC_DELETE type CHAR1 value 'D'. "#EC NOTEXT
protected section.
private section.
ENDCLASS.



CLASS CVI_VMD_EOP_CHECK IMPLEMENTATION.


  method CVP_IF_APPL_EOP_CHECK~CHECK_CPD_PARTNERS.
*
  endmethod.


  METHOD cvp_if_appl_eop_check~check_partners.
*---Local varibles and constants decleration
    CONSTANTS: lc_x TYPE char1 VALUE 'X'.

    TYPES: BEGIN OF ty_vendor_cont,
             vendor_cont TYPE parnr,
           END OF ty_vendor_cont.

    DATA: lr_cvi_ctrl_loop       TYPE REF TO cvi_ctrl_loop,
          lt_cvi_vend_ct_link    TYPE TABLE OF cvi_vend_ct_link,
          lt_cvi_vend_dct_link   TYPE TABLE OF cvi_vend_ct_link,
          lt_cvi_cust_link       TYPE TABLE OF cvi_cust_link,
          lt_cvi_vend_link       TYPE cvis_vend_link_t,
          ls_cvi_vend_link       LIKE LINE OF lt_cvi_vend_link,
          ls_cvi_vend_ct_link    LIKE LINE OF lt_cvi_vend_ct_link,
          ls_cvi_cust_link       LIKE LINE OF lt_cvi_cust_link,
          lt_partner_guid        TYPE bup_partner_guid_t,
          lt_partner_guid_all    TYPE bup_partnerguid_t,
          ls_partner_guid_all    TYPE bup_partnerguid_s,
          ls_partner_guid        LIKE LINE OF lt_partner_guid,
          lt_partner             TYPE bu_partner_t,
          lv_intrim              TYPE char1,
          lv_ovrall              TYPE char1,
          lv_detlog              TYPE char1,
          lv_applog              TYPE char1,
          ls_eop_check_partners1 TYPE cvp_s_eop_check_partners,
          lt_vendor_cont         TYPE TABLE OF ty_vendor_cont,
          ls_vendor_cont         TYPE ty_vendor_cont,
          lt_vend_type2          TYPE CVP_TT_EOP_CHECK_PARTNERS.

    DATA: lt_bal_msg      TYPE ty_t_bal_msg,
          lt_cvi_messages TYPE buslocalmsg_t,
          ls_cvi_messages TYPE buslocalmsg,
          lv_relevant     TYPE boole_d,
          lv_relevant1    TYPE boole_d.

    DATA: lt_eop_check_partners   TYPE cvp_tt_eop_check_partners,
          lt_messages             TYPE cvp_tt_eop_check_messages,
          ls_messages             TYPE cvp_s_eop_check_messages,
          ls_bapiret2             TYPE bapiret2,
          lt_sort_result_partners TYPE cvp_tt_sort_result.

    DATA: lt_pur_cmplt_partners   TYPE bu_butsort_maint_t,
          lt_cvp_tt_eop_check     TYPE cvp_tt_eop_check_partners_cpd,
          ls_pur_cmplt_partners   LIKE LINE OF lt_pur_cmplt_partners,
          ls_sort_result_partners LIKE LINE OF et_sort_result_partners,
          ls_eop_check_partners   LIKE LINE OF it_eop_check_partners.

    DATA: lv_own_logical_system   TYPE tbdls-logsys.

    DATA: lv_index                TYPE i.

    FIELD-SYMBOLS : <fs_messages> TYPE cvp_s_eop_check_messages.

*---Avoiding loop call and checking synchronization is active or not.
    CALL METHOD cvi_ctrl_loop=>get_instance
      IMPORTING
        er_object = lr_cvi_ctrl_loop.

    lr_cvi_ctrl_loop->check_steps(
      EXPORTING
        iv_source_object = 'VENDOR'    " Source Synchronization Object
        iv_target_object =  'BP'   " Target Synchronization Object
      IMPORTING
        ev_relevant      = lv_relevant    " Relevant
*        es_error         =     " Message Structure of the Controller
    ).

*&---- Checking EOP check done for BP to Customer or not.
*    CALL METHOD lr_cvi_ctrl_loop->check_steps
*      EXPORTING
*        iv_source_object = 'BP'
*        iv_target_object = 'CUSTOMER'
*      IMPORTING
*        ev_relevant      = lv_relevant1.

    IF lv_relevant = 'X'.

      LOOP AT it_eop_check_partners INTO ls_eop_check_partners.
        IF ls_eop_check_partners-ID_TYPE = 2.
            APPEND ls_eop_check_partners to lt_vend_type2.
        ENDIF.
      ENDLOOP.

*----Executing blocking module by passing business partners.
      IF it_eop_check_partners IS NOT INITIAL.
       IF lt_vend_type2 IS NOT INITIAL.
*--- Fetching Business partners linked to vendors
        SELECT * FROM cvi_vend_link INTO TABLE lt_cvi_vend_link
                                    FOR ALL ENTRIES IN lt_vend_type2"it_eop_check_partners
                                    WHERE vendor = lt_vend_type2-id.
        IF sy-subrc = 0.
          LOOP AT lt_cvi_vend_link INTO ls_cvi_vend_link.
            ls_partner_guid_all-partner_guid = ls_cvi_vend_link-partner_guid.
            APPEND ls_partner_guid_all TO lt_partner_guid_all.
          ENDLOOP.
*--- Fetching customers linked to vendors
*          SELECT * FROM cvi_cust_link INTO TABLE lt_cvi_cust_link
*                                 FOR ALL ENTRIES IN lt_cvi_vend_link
*                                 WHERE partner_guid = lt_cvi_vend_link-partner_guid.
*          IF sy-subrc = 0 AND lv_relevant1 = 'X'.
***** Partners checks before calling CVP_PREPARE_EOP_BLOCK
*            CALL FUNCTION 'CVP_PREPARE_EOP_CHECK'
*              EXPORTING
*                it_cust_link             = lt_cvi_cust_link
*              IMPORTING
*                et_cust_eop_partners     = lt_eop_check_partners
*                et_cust_eop_partners_cpd = lt_cvp_tt_eop_check.
*          ENDIF.
*---- Fetching vendor contact persons.
          SELECT * FROM cvi_vend_ct_link INTO TABLE lt_cvi_vend_ct_link
                                      FOR ALL ENTRIES IN lt_cvi_vend_link
                                      WHERE partner_guid = lt_cvi_vend_link-partner_guid.
          IF sy-subrc = 0.
            LOOP AT lt_cvi_vend_ct_link INTO ls_cvi_vend_ct_link.
              ls_partner_guid_all-partner_guid = ls_cvi_vend_ct_link-person_guid.
              APPEND ls_partner_guid_all TO lt_partner_guid_all.
              CLEAR: ls_cvi_vend_ct_link,ls_partner_guid_all.
            ENDLOOP.
          ENDIF.
        ENDIF.

*&---- Conversion from CHAR to NUMC
*        LOOP AT it_eop_check_partners INTO ls_eop_check_partners1.
        LOOP AT lt_vend_type2 INTO ls_eop_check_partners1.
          READ TABLE lt_cvi_vend_link TRANSPORTING NO FIELDS WITH KEY vendor = ls_eop_check_partners1-id.
          IF sy-subrc <> 0.
            READ TABLE lt_cvi_vend_ct_link TRANSPORTING NO FIELDS WITH KEY vendor_cont = ls_eop_check_partners1-id.
            IF sy-subrc <> 0.
              CALL FUNCTION 'CHAR_NUMC_CONVERSION'
                EXPORTING
                  input   = ls_eop_check_partners1-id
                IMPORTING
                  numcstr = ls_vendor_cont-vendor_cont.

              APPEND ls_vendor_cont TO lt_vendor_cont.
              CLEAR: ls_eop_check_partners1, ls_vendor_cont.
            ENDIF.
          ENDIF.
        ENDLOOP.

      IF lt_vendor_cont[] IS NOT INITIAL.
*&---- Getting Business Partnerd of Contact Person
        SELECT * FROM cvi_vend_ct_link
           INTO TABLE lt_cvi_vend_dct_link
          FOR ALL ENTRIES IN lt_vendor_cont
          WHERE vendor_cont = lt_vendor_cont-vendor_cont. "#EC CI_NOFIELD.
        IF sy-subrc = 0.
          LOOP AT lt_cvi_vend_dct_link INTO ls_cvi_vend_ct_link.
            ls_partner_guid_all-partner_guid = ls_cvi_vend_ct_link-person_guid.

            APPEND ls_partner_guid_all TO lt_partner_guid_all.
            CLEAR: ls_partner_guid_all.

            ls_cvi_vend_link-vendor = ls_cvi_vend_ct_link-vendor_cont.
            ls_cvi_vend_link-partner_guid = ls_cvi_vend_ct_link-person_guid.
            APPEND ls_cvi_vend_link TO lt_cvi_vend_link.
            CLEAR: ls_cvi_vend_link.
          ENDLOOP.
        ENDIF.
      ENDIF.

*---- Updating 'SORT' result for the vendors which are not linked to Business partners
        IF lt_cvi_vend_link IS INITIAL AND lt_cvi_vend_dct_link IS INITIAL.
*&--- Getting own logical system
          CALL FUNCTION 'OWN_LOGICAL_SYSTEM_GET'
            IMPORTING
              own_logical_system             = lv_own_logical_system   " Name of own logical system
            EXCEPTIONS
              own_logical_system_not_defined = 1
              OTHERS                         = 2.
          IF sy-subrc <> 0.
*           MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
          ENDIF.

*          LOOP AT it_eop_check_partners INTO ls_eop_check_partners.
          LOOP AT lt_vend_type2 INTO ls_eop_check_partners.
            ls_sort_result_partners-id = ls_eop_check_partners-id.
            ls_sort_result_partners-id_type = ls_eop_check_partners-id_type.
            ls_sort_result_partners-bukrs = ls_eop_check_partners-bukrs.
            ls_sort_result_partners-vkorg = ls_eop_check_partners-vkorg.
            IF iv_appl IS NOT INITIAL.
              ls_sort_result_partners-appl_name = iv_appl.
            ELSE.
              ls_sort_result_partners-appl_name = 'CVI'.
            ENDIF.
            ls_sort_result_partners-business_system = lv_own_logical_system.
            ls_sort_result_partners-pur_cmpl_status = '1'.
            APPEND ls_sort_result_partners TO et_sort_result_partners.
            CLEAR ls_sort_result_partners.
          ENDLOOP.

          EXIT.
        ENDIF.

      IF lt_partner_guid_all[] IS NOT INITIAL.
*---- Fetching business partners related to vendors
        SELECT partner partner_guid FROM but000 INTO TABLE lt_partner_guid
                                    FOR ALL ENTRIES IN lt_partner_guid_all
                                    WHERE partner_guid = lt_partner_guid_all-partner_guid.
        IF sy-subrc = 0.
*--- Moving only business partners without GUID
          MOVE lt_partner_guid TO lt_partner.

*          IF lt_eop_check_partners IS NOT INITIAL AND lv_relevant1 = 'X'.
*
**--- Fetching customer EOP check result.
*            CALL FUNCTION 'CVP_PREPARE_EOP_BLOCK' DESTINATION 'NONE'
*              EXPORTING
*                iv_eop_run_mode           = gv_eop_run_mode
*                iv_test_mode              = gv_test_mode
*                iv_validate_nxtchk_date   = gv_validate_nxtchk_date
*                iv_check_pur_compl_status = gv_check_pur_compl_status
*                iv_prot_output            = gv_prot_output
*                iv_detail_log             = gv_detail_log
*                it_eop_check_partners     = lt_eop_check_partners
*                it_eop_check_partners_cpd = lt_cvp_tt_eop_check
*              IMPORTING
*                et_sort_result_partners   = lt_sort_result_partners
*                et_messages               = lt_messages
**               EV_APPLOG_NUMBER          =
*              .
*
*            LOOP AT lt_sort_result_partners INTO ls_sort_result_partners.
*              READ TABLE lt_cvi_cust_link INTO ls_cvi_cust_link WITH KEY customer = ls_sort_result_partners-id.
*              IF sy-subrc = 0.
*                READ TABLE lt_cvi_vend_link INTO ls_cvi_vend_link WITH KEY partner_guid = ls_cvi_cust_link-partner_guid.
*                IF sy-subrc = 0.
*                  READ TABLE it_eop_check_partners INTO ls_eop_check_partners WITH KEY id = ls_cvi_vend_link-vendor.
*                  IF sy-subrc = 0.
*                    ls_sort_result_partners-id = ls_eop_check_partners-id.
*                    ls_sort_result_partners-id_type = ls_eop_check_partners-id_type.
*                    ls_sort_result_partners-bukrs = ls_eop_check_partners-bukrs.
*                    ls_sort_result_partners-vkorg = ls_eop_check_partners-vkorg.
*                    APPEND ls_sort_result_partners TO et_sort_result_partners.
*                    CLEAR: ls_sort_result_partners.
*                  ENDIF.
*                ENDIF.
*              ENDIF.
*            ENDLOOP.
**&--- Updating result log messages
*            LOOP AT lt_messages ASSIGNING <fs_messages>.
*              READ TABLE lt_cvi_cust_link INTO ls_cvi_cust_link WITH KEY customer = <fs_messages>-id.
*              IF sy-subrc = 0.
*                READ TABLE lt_cvi_vend_link INTO ls_cvi_vend_link WITH KEY partner_guid = ls_cvi_cust_link-partner_guid.
*                IF sy-subrc = 0.
*                  READ TABLE it_eop_check_partners INTO ls_eop_check_partners WITH KEY id = ls_cvi_vend_link-vendor.
*                  IF sy-subrc = 0.
*                    <fs_messages>-id = ls_eop_check_partners-id.
*                    <fs_messages>-id_type = ls_eop_check_partners-id_type.
*                    <fs_messages>-bukrs = ls_eop_check_partners-bukrs.
*                    <fs_messages>-vkorg = ls_eop_check_partners-vkorg.
*                  ENDIF.
*                ENDIF.
*              ENDIF.
*            ENDLOOP.
*            APPEND LINES OF lt_messages TO et_messages.
*          ENDIF.

*---Initialization of local variables
    IF gv_eop_run_mode = '1'.
      lv_intrim = lc_x.
    ELSEIF gv_eop_run_mode = '2'.
      lv_ovrall = lc_x.
    ENDIF.

    IF gv_detail_log = '1'.
      lv_detlog = ' '.
    ELSEIF gv_detail_log = 'X'.
      lv_detlog = 'X'.
    ENDIF.

    IF gv_prot_output = ' '.
      lv_applog = ' '.
    ELSEIF gv_prot_output = '1'.
      lv_applog = 'X'.
    ELSEIF gv_prot_output = '2'.
      lv_applog = 'X'.
    ENDIF.

*---- Setting CVI control flag.
          CALL FUNCTION 'BUPA_CVI_CTRL_FLAG_SET'.

*-----Getting 'SORT' result for the business partners.
          CALL FUNCTION 'BUPA_PREPARE_EOP_BLOCK'
            EXPORTING
              i_partnr                   = lt_partner
*             I_FILTER                   =
              i_intrim                   = lv_intrim
              i_ovrall                   = lv_ovrall
              i_chkdat                   = gv_validate_nxtchk_date
*             I_INTRES                   =
              i_applog                   = lv_applog
              i_detlog                   = lv_detlog
              i_tesrun                   = gv_test_mode
              i_chkeop                   = gv_check_pur_compl_status
*             I_BLOCKS                   =
            IMPORTING
*             e_bal_msg                  = lt_bal_msg
              e_pur_cmplt_partners_final = lt_pur_cmplt_partners
              e_cvi_messages             = lt_cvi_messages.

          gt_pur_cmplt_partners_final = lt_pur_cmplt_partners.
*----- Sorting vendor link and vendor contact persons link table.
          SORT: lt_cvi_vend_link,
                lt_cvi_vend_ct_link
                ASCENDING BY partner_guid.
          SORT: lt_partner_guid,lt_pur_cmplt_partners
                ASCENDING BY partner.
          SORT: lt_cvi_messages ASCENDING BY partnerid.
*----- Updating 'SORT' information after EOP Check.
*          LOOP AT it_eop_check_partners INTO ls_eop_check_partners.
          LOOP AT lt_vend_type2 INTO ls_eop_check_partners.
            READ TABLE lt_cvi_vend_link INTO ls_cvi_vend_link WITH KEY vendor = ls_eop_check_partners-id.
            IF sy-subrc = 0.
*---- Updating 'SORT' result for the vendors which are linked to Business partners
              READ TABLE lt_partner_guid INTO ls_partner_guid WITH KEY partner_guid = ls_cvi_vend_link-partner_guid.
              IF sy-subrc = 0.
                READ TABLE lt_pur_cmplt_partners TRANSPORTING NO FIELDS WITH KEY partner = ls_partner_guid-partner BINARY SEARCH.
                IF sy-subrc = 0.
                  lv_index = sy-tabix.
                  LOOP AT lt_pur_cmplt_partners INTO ls_pur_cmplt_partners FROM lv_index.
                    IF ls_pur_cmplt_partners-partner <> ls_partner_guid-partner.
                      EXIT.
                    ENDIF.
                    ls_sort_result_partners-id = ls_eop_check_partners-id.
                    ls_sort_result_partners-id_type = ls_eop_check_partners-id_type.
                    ls_sort_result_partners-bukrs = ls_eop_check_partners-bukrs.
                    ls_sort_result_partners-vkorg = ls_eop_check_partners-vkorg.
                    ls_sort_result_partners-appl_name = ls_pur_cmplt_partners-appl_name.
                    ls_sort_result_partners-appl_rule_variant = ls_pur_cmplt_partners-appl_rule_variant.
                    ls_sort_result_partners-business_system = ls_pur_cmplt_partners-business_system.
                    ls_sort_result_partners-nextchkdt = ls_pur_cmplt_partners-nextchkdt.
                    ls_sort_result_partners-pur_cmpl_status = ls_pur_cmplt_partners-pur_cmpl_status.
                    ls_sort_result_partners-st_ret_date = ls_pur_cmplt_partners-st_ret_date.
                    APPEND ls_sort_result_partners TO et_sort_result_partners.
                    CLEAR: ls_sort_result_partners.
                  ENDLOOP.
                ENDIF.
*----- Updating contact persons 'SORT' result.
                READ TABLE lt_cvi_vend_ct_link TRANSPORTING NO FIELDS WITH KEY partner_guid = ls_partner_guid-partner_guid BINARY SEARCH.
                IF sy-subrc = 0.
                  lv_index = sy-tabix.
                  LOOP AT lt_cvi_vend_ct_link INTO ls_cvi_vend_ct_link FROM lv_index.
                    IF ls_cvi_vend_link-partner_guid <> ls_cvi_vend_ct_link-partner_guid.
                      EXIT.
                    ENDIF.
                    READ TABLE lt_pur_cmplt_partners INTO ls_pur_cmplt_partners WITH KEY partner = ls_partner_guid-partner.
                    IF sy-subrc = 0.
                      ls_sort_result_partners-id = ls_eop_check_partners-id.
                      ls_sort_result_partners-id_type = ls_eop_check_partners-id_type.
                      ls_sort_result_partners-bukrs = ls_eop_check_partners-bukrs.
                      ls_sort_result_partners-vkorg = ls_eop_check_partners-vkorg.
                      ls_sort_result_partners-appl_name = ls_pur_cmplt_partners-appl_name.
                      ls_sort_result_partners-appl_rule_variant = ls_pur_cmplt_partners-appl_rule_variant.
                      ls_sort_result_partners-business_system = ls_pur_cmplt_partners-business_system.
                      ls_sort_result_partners-nextchkdt = ls_pur_cmplt_partners-nextchkdt.
                      ls_sort_result_partners-pur_cmpl_status = ls_pur_cmplt_partners-pur_cmpl_status.
                      ls_sort_result_partners-st_ret_date = ls_pur_cmplt_partners-st_ret_date.
                      APPEND ls_sort_result_partners TO et_sort_result_partners.
                      CLEAR: ls_sort_result_partners.
                    ENDIF.
                  ENDLOOP.
                ENDIF.
*&--- Updating result log messages
                READ TABLE lt_cvi_messages TRANSPORTING NO FIELDS WITH KEY partnerid = ls_partner_guid-partner BINARY SEARCH.
                IF sy-subrc = 0.
                  lv_index = sy-tabix.
                  LOOP AT lt_cvi_messages INTO ls_cvi_messages FROM lv_index.
                    IF ls_cvi_messages-partnerid <> ls_partner_guid-partner.
                      EXIT.
                    ENDIF.
                    ls_messages-id = ls_eop_check_partners-id.
                    ls_messages-id_type = ls_eop_check_partners-id_type.
                    ls_messages-bukrs = ls_eop_check_partners-bukrs.
                    ls_messages-vkorg = ls_eop_check_partners-vkorg.
                    ls_messages-appl_name = ls_cvi_messages-appl_name.
                    ls_messages-appl_rule_variant = ls_cvi_messages-appl_rule_variant.
                    MOVE-CORRESPONDING ls_cvi_messages TO ls_bapiret2.
                    APPEND ls_bapiret2 TO ls_messages-messages.
                    APPEND ls_messages TO et_messages.
                  ENDLOOP.
                ENDIF.
              ENDIF.
            ELSE.
*&--- Getting own logical system
              CALL FUNCTION 'OWN_LOGICAL_SYSTEM_GET'
                IMPORTING
                  own_logical_system             = lv_own_logical_system   " Name of own logical system
                EXCEPTIONS
                  own_logical_system_not_defined = 1
                  OTHERS                         = 2.
              IF sy-subrc <> 0.
*           MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
              ENDIF.
*---- Updating 'SORT' result for the vendors which are not linked to Business partners
              ls_sort_result_partners-id = ls_eop_check_partners-id.
              ls_sort_result_partners-id_type = ls_eop_check_partners-id_type.
              ls_sort_result_partners-bukrs = ls_eop_check_partners-bukrs.
              ls_sort_result_partners-vkorg = ls_eop_check_partners-vkorg.
              IF iv_appl IS NOT INITIAL.
                ls_sort_result_partners-appl_name = iv_appl.
              ELSE.
                ls_sort_result_partners-appl_name = 'CVI'.
              ENDIF.
              ls_sort_result_partners-business_system = lv_own_logical_system.
              ls_sort_result_partners-pur_cmpl_status = '1'.
              APPEND ls_sort_result_partners TO et_sort_result_partners.
              CLEAR ls_sort_result_partners.
            ENDIF.
          ENDLOOP.
        ENDIF.
       ENDIF.
       ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  method CVP_IF_APPL_EOP_CHECK~FINALIZE.
*
  endmethod.


  method CVP_IF_APPL_EOP_CHECK~FINALIZE_UNBLOCK.
*
  endmethod.


  METHOD cvp_if_appl_eop_check~initialize.
*--- Initialising global variables.
    gv_appl = iv_appl.
*    gv_check_pur_compl_status = iv_check_pur_compl_status.
     IF iv_check_pur_compl_status = 'X'.
      gv_check_pur_compl_status = ' '.
    ELSE.
     gv_check_pur_compl_status = 'X'.
    ENDIF.
    gv_detail_log = iv_detail_log.
    gv_eop_run_mode = iv_eop_run_mode.
    gv_test_mode = iv_test_mode.
    gv_validate_nxtchk_date = iv_validate_nxtchk_date.
    gv_prot_output = iv_prot_output.
  ENDMETHOD.


  METHOD cvp_if_appl_eop_check~initialize_unblock.
*&----- Initialize global variables for unblocking
    gv_appl = iv_appl.
    gv_test_mode = iv_test_mode.
    gv_prot_output = iv_prot_output.
    gv_detail_log = iv_detail_log.
  ENDMETHOD.


  METHOD cvp_if_appl_eop_check~partners_prep_purcmpl_reset.

    DATA: lr_cvi_ctrl_loop    TYPE REF TO cvi_ctrl_loop,
          lt_cvi_vend_link    TYPE TABLE OF cvi_vend_link,
          lt_cvi_vend_ct_link TYPE TABLE OF cvi_vend_ct_link,
          lt_cvi_cust_link    TYPE TABLE OF cvi_cust_link,
          ls_cvi_vend_link    LIKE LINE OF lt_cvi_vend_link,
          ls_cvi_vend_ct_link LIKE LINE OF lt_cvi_vend_ct_link,
          ls_cvi_cust_link    LIKE LINE OF lt_cvi_cust_link,
          lt_partner_guid     TYPE bup_partner_guid_t,
          lt_partner_guid_all TYPE bup_partnerguid_t,
          ls_partner_guid_all TYPE bup_partnerguid_s,
          ls_partner_guid     LIKE LINE OF lt_partner_guid,
          lt_partner          TYPE bu_partner_t.

    DATA: lt_bal_msg  TYPE ty_t_bal_msg,
          lt_messages TYPE cvp_tt_eop_check_messages,
          ls_messages LIKE LINE OF lt_messages,
          ls_bapiret2 TYPE bapiret2,
          lv_relevant TYPE boole_d.

    DATA: lt_unblk_cust_partners      TYPE cvp_tt_unblock_status,
          lt_unblk_cust_partn_results TYPE cvp_tt_unblock_status,
          lt_unblk_partn_results      TYPE bupartner_unblk_statusremote_t,
          lt_cvi_messages             TYPE buslocalmsg_t,
          ls_cvi_messages             TYPE buslocalmsg,
          ls_unblk_cust_partn_results LIKE LINE OF lt_unblk_cust_partn_results,
          ls_unblk_partn_results      LIKE LINE OF lt_unblk_partn_results,
          ls_unblk_cust_partners      LIKE LINE OF lt_unblk_cust_partners,
          ls_partners                 LIKE LINE OF it_partners,
          ls_unblk_partners           LIKE LINE OF et_partners.

    DATA: lv_index                TYPE i.

    FIELD-SYMBOLS: <fs_messages> TYPE cvp_s_eop_check_messages.
*---Avoiding loop call and checking synchronization is active or not.
    CALL METHOD cvi_ctrl_loop=>get_instance
      IMPORTING
        er_object = lr_cvi_ctrl_loop.

    lr_cvi_ctrl_loop->check_steps(
      EXPORTING
        iv_source_object = 'VENDOR'    " Source Synchronization Object
        iv_target_object =  'BP'   " Target Synchronization Object
      IMPORTING
        ev_relevant      = lv_relevant    " Relevant
*        es_error         =     " Message Structure of the Controller
    ).

    IF lv_relevant = 'X' AND it_partners IS NOT INITIAL.
*--- Fetching Business partners linked to vendors
      SELECT * FROM cvi_vend_link INTO TABLE lt_cvi_vend_link
                                  FOR ALL ENTRIES IN it_partners
                                  WHERE vendor = it_partners-id.
      IF sy-subrc = 0.
        LOOP AT lt_cvi_vend_link INTO ls_cvi_vend_link.
          ls_partner_guid_all-partner_guid = ls_cvi_vend_link-partner_guid.
          APPEND ls_partner_guid_all TO lt_partner_guid_all.
        ENDLOOP.
*--- Fetching customers linked to vendors
*        SELECT * FROM cvi_cust_link INTO TABLE lt_cvi_cust_link
*                               FOR ALL ENTRIES IN lt_cvi_vend_link
*                               WHERE partner_guid = lt_cvi_vend_link-partner_guid.
*        IF sy-subrc = 0.
*          LOOP AT lt_cvi_cust_link INTO ls_cvi_cust_link.
*            ls_unblk_cust_partners-id = ls_cvi_cust_link-customer.
*            ls_unblk_cust_partners-id_type = '1'.
*            APPEND ls_unblk_cust_partners TO lt_unblk_cust_partners.
*            CLEAR: ls_cvi_cust_link,ls_unblk_cust_partners.
*          ENDLOOP.
*        ENDIF.
*---- Fetching vendor contact persons.
        SELECT * FROM cvi_vend_ct_link INTO TABLE lt_cvi_vend_ct_link
                                    FOR ALL ENTRIES IN lt_cvi_vend_link
                                    WHERE partner_guid = lt_cvi_vend_link-partner_guid.
        IF sy-subrc = 0.
          LOOP AT lt_cvi_vend_ct_link INTO ls_cvi_vend_ct_link.
            ls_partner_guid_all-partner_guid = ls_cvi_vend_ct_link-person_guid.
            APPEND ls_partner_guid_all TO lt_partner_guid_all.
          ENDLOOP.
        ENDIF.
*---- Fetching business partners related to vendors
        SELECT partner partner_guid FROM but000 INTO TABLE lt_partner_guid
                                    FOR ALL ENTRIES IN lt_partner_guid_all
                                    WHERE partner_guid = lt_partner_guid_all-partner_guid.
        IF sy-subrc = 0.
*--- Moving only business partners without GUID
          MOVE lt_partner_guid TO lt_partner.
*          IF lt_unblk_cust_partn_results IS NOT INITIAL.
*            CALL FUNCTION 'CVP_PROCESS_UNBLOCK'
*              EXPORTING
*                iv_test_mode                = gv_test_mode
*                iv_prot_output              = gv_prot_output
*                iv_detail_log               = gv_detail_log
*                it_unblock_partners         = lt_unblk_cust_partners
*              IMPORTING
*                et_unblock_partners_results = lt_unblk_cust_partn_results
*                et_messages                 = lt_messages.
*
*            LOOP AT lt_unblk_cust_partn_results INTO ls_unblk_cust_partn_results.
*              READ TABLE lt_cvi_cust_link INTO ls_cvi_cust_link WITH KEY customer = ls_unblk_cust_partn_results-id.
*              IF sy-subrc = 0.
*                READ TABLE lt_cvi_vend_link INTO ls_cvi_vend_link WITH KEY partner_guid = ls_cvi_cust_link-partner_guid.
*                IF sy-subrc = 0.
*                  READ TABLE it_partners INTO ls_partners WITH KEY id = ls_cvi_vend_link-vendor.
*                  IF sy-subrc = 0.
*                    ls_unblk_partners-id = ls_partners-id.
*                    ls_unblk_partners-id_type = ls_partners-id_type.
*                    ls_unblk_partners-bukrs = ls_partners-bukrs.
*                    ls_unblk_partners-vkorg = ls_partners-vkorg.
*                    ls_unblk_partners-status = ls_unblk_cust_partn_results-status.
*                    APPEND ls_unblk_partners TO et_partners.
*                    CLEAR: ls_unblk_partners.
*                  ENDIF.
*                ENDIF.
*              ENDIF.
*            ENDLOOP.
**&--- Updating result log messages
*            LOOP AT lt_messages ASSIGNING <fs_messages>.
*              READ TABLE lt_cvi_cust_link INTO ls_cvi_cust_link WITH KEY customer = <fs_messages>-id.
*              IF sy-subrc = 0.
*                READ TABLE lt_cvi_vend_link INTO ls_cvi_vend_link WITH KEY partner_guid = ls_cvi_cust_link-partner_guid.
*                IF sy-subrc = 0.
*                  READ TABLE it_partners INTO ls_partners WITH KEY id = ls_cvi_vend_link-vendor.
*                  IF sy-subrc = 0.
*                    <fs_messages>-id = ls_partners-id.
*                    <fs_messages>-id_type = ls_partners-id_type.
*                    <fs_messages>-bukrs = ls_partners-bukrs.
*                    <fs_messages>-vkorg = ls_partners-vkorg.
*                  ENDIF.
*                ENDIF.
*              ENDIF.
*            ENDLOOP.
*            APPEND LINES OF lt_messages TO et_messages.
*          ENDIF.

          CALL FUNCTION 'BUPA_PREPARE_EOP_UNBLOCK'
            EXPORTING
              i_partner         = lt_partner
            IMPORTING
              e_partner_unblock = lt_unblk_partn_results
              e_cvi_messages    = lt_cvi_messages.

          SORT lt_unblk_partn_results ASCENDING BY partner.
          SORT lt_cvi_messages ASCENDING BY partnerid.
*&---- Updating unblock status for the vendors which are linked to Business partners
          LOOP AT lt_unblk_partn_results INTO ls_unblk_partn_results.
            READ TABLE lt_cvi_vend_link INTO ls_cvi_vend_link WITH KEY partner_guid = ls_unblk_partn_results-partner_guid.
            IF sy-subrc = 0.
              READ TABLE it_partners INTO ls_partners WITH KEY id = ls_cvi_vend_link-vendor.
              IF sy-subrc = 0.
                ls_unblk_partners-id = ls_partners-id.
                ls_unblk_partners-id_type = ls_partners-id_type.
                ls_unblk_partners-bukrs = ls_partners-bukrs.
                ls_unblk_partners-vkorg = ls_partners-vkorg.
                IF ls_unblk_partn_results-unblk_status = 'X'.
                  ls_unblk_partners-status =  'A'.
                ELSE.
                  ls_unblk_partners-status =  'R'.
                ENDIF.
                APPEND ls_unblk_partners TO et_partners.
                CLEAR: ls_unblk_partners.
*&--- Updating messages.
                READ TABLE lt_cvi_messages TRANSPORTING NO FIELDS WITH KEY partnerid = ls_unblk_partn_results-partner BINARY SEARCH.
                IF sy-subrc = 0.
                  lv_index = sy-tabix.
                  LOOP AT lt_cvi_messages INTO ls_cvi_messages FROM lv_index.
                    IF ls_cvi_messages-partnerid <> ls_unblk_partn_results-partner.
                      EXIT.
                    ENDIF.
                    ls_messages-id = ls_partners-id.
                    ls_messages-id_type = ls_partners-id_type.
                    ls_messages-bukrs = ls_partners-bukrs.
                    ls_messages-vkorg = ls_partners-vkorg.
                    ls_messages-appl_name = ls_cvi_messages-appl_name.
                    ls_messages-appl_rule_variant = ls_cvi_messages-appl_rule_variant.
                    MOVE-CORRESPONDING ls_cvi_messages TO ls_bapiret2.
                    APPEND ls_bapiret2 TO ls_messages-messages.
                    APPEND ls_messages TO et_messages.
                  ENDLOOP.
                ENDIF.
              ENDIF.
            ELSE.
              READ TABLE lt_cvi_vend_ct_link INTO ls_cvi_vend_ct_link WITH KEY person_guid = ls_unblk_partn_results-partner_guid.
              IF sy-subrc = 0.
                READ TABLE lt_cvi_vend_link INTO ls_cvi_vend_link WITH KEY partner_guid = ls_cvi_vend_ct_link-partner_guid.
                IF sy-subrc = 0.
                  READ TABLE it_partners INTO ls_partners WITH KEY id = ls_cvi_vend_link-vendor.
                  IF sy-subrc = 0.
                    ls_unblk_partners-id = ls_partners-id.
                    ls_unblk_partners-id_type = ls_partners-id_type.
                    ls_unblk_partners-bukrs = ls_partners-bukrs.
                    ls_unblk_partners-vkorg = ls_partners-vkorg.
                    IF ls_unblk_partn_results-unblk_status = 'X'.
                      ls_unblk_partners-status =  'A'.
                    ELSE.
                      ls_unblk_partners-status =  'R'.
                    ENDIF.
                    APPEND ls_unblk_partners TO et_partners.
                    CLEAR: ls_unblk_partners.
*&--- Updating messages.
                    READ TABLE lt_cvi_messages TRANSPORTING NO FIELDS WITH KEY partnerid = ls_unblk_partn_results-partner BINARY SEARCH.
                    IF sy-subrc = 0.
                      lv_index = sy-tabix.
                      LOOP AT lt_cvi_messages INTO ls_cvi_messages FROM lv_index.
                        IF ls_cvi_messages-partnerid <> ls_unblk_partn_results-partner.
                          EXIT.
                        ENDIF.
                        ls_messages-id = ls_partners-id.
                        ls_messages-id_type = ls_partners-id_type.
                        ls_messages-bukrs = ls_partners-bukrs.
                        ls_messages-vkorg = ls_partners-vkorg.
                        ls_messages-appl_name = ls_cvi_messages-appl_name.
                        ls_messages-appl_rule_variant = ls_cvi_messages-appl_rule_variant.
                        MOVE-CORRESPONDING ls_cvi_messages TO ls_bapiret2.
                        APPEND ls_bapiret2 TO ls_messages-messages.
                        APPEND ls_messages TO et_messages.
                      ENDLOOP.
                    ENDIF.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ELSE.
*&---- Updating unblock status for the vendors which are not linked to Business partners
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD cvp_if_appl_eop_check~partners_purcmpl_export.

    DATA: lt_cvi_vend_link        TYPE TABLE OF cvi_vend_link,
          lt_cvi_vend_ct_link     TYPE TABLE OF cvi_vend_ct_link,
          ls_cvi_vend_link        LIKE LINE OF lt_cvi_vend_link,
          ls_cvi_vend_ct_link     LIKE LINE OF lt_cvi_vend_ct_link,
          lt_partner_guid         TYPE bup_partner_guid_t,
          lt_partner_guid_all     TYPE bup_partnerguid_t,
          ls_partner_guid_all     TYPE bup_partnerguid_s,
          lt_partner              TYPE bu_partner_t,
          lt_regsys               TYPE TABLE OF butregsys_remote,
          lt_bubutsort_maint_guid TYPE bubutsort_maint_guid_t,
          ls_bubutsort_maint_guid TYPE bubutsort_maint_guid,
          ls_pur_cmplt_partners     TYPE LINE OF bu_butsort_t,
          lt_pur_cmplt_partners     TYPE bu_butsort_t,
          lt_pur_cmplt_partners_final TYPE BU_BUTSORT_MAINT_T,
          ls_pur_cmplt_partners_final LIKE LINE OF   lt_pur_cmplt_partners_final,
          lv_check_only_external_data  TYPE boole-boole,
          lc_final         TYPE char1 VALUE 'F',
          lv_timestamp                 TYPE timestamp,
          lt_return                    TYPE bus_bapiret2_t,
          lr_cvi_ctrl_loop            TYPE REF TO cvi_ctrl_loop,
          lv_relevant             TYPE boole_d.

    DATA: lit_output    TYPE business_partner_eopcompl__tab,
          lwa_output    TYPE LINE OF business_partner_eopcompl__tab,
*          it_output     TYPE ababusiness_partner_eopcompl,
          lv_proxyclass TYPE srt_wsp_dt_obj_name,
          lv_query      TYPE REF TO if_srt_public_query_handler,
          lt_log_port   TYPE srt_lp_names,
          ls_log_port   LIKE LINE OF lt_log_port,
          lo_proxy      TYPE REF TO co_ababusiness_partner_eopcomp,
          lo_sys        TYPE REF TO cx_ai_system_fault,
         lt_business_partner_compl_req  TYPE BUPA_PURPOSE_COMPLETE_INPUT,
         lt_business_partner_compl_res TYPE BUPA_PURPOSE_COMPLETE_OUTPUT,
         ls_bp_partner_compl_msg TYPE LINE OF BUSLOCALMSG_TAB,
         ls_messages_compl          TYPE LINE OF BUSLOCALMSG_T,
         lit_business_partner_compl_req TYPE BUBUTSORT_MAINT_GUID_TAB,
         ls_business_partner_compl_req  TYPE LINE OF BUBUTSORT_MAINT_GUID_TAB.

  DATA :  lv_success                  TYPE boole-boole,
          lt_messages3                 TYPE buslocalmsg_t,
          ls_messages3                 TYPE BUSLOCALMSG,
          lt_messages1                TYPE bapiret2_t,
          ls_messages1                TYPE bapiret2,
          es_messages                 TYPE CVP_S_EOP_CHECK_MESSAGES,
          lv_rbsuccess                TYPE boole-boole,
          lv_rfcdes                   TYPE bu_rfcdest,
          lt_regsys_temp              TYPE STANDARD TABLE OF butregsys_remote,
          lt_resetbp                  TYPE bup_partner_guid_t,
          ls_resetbp                  TYPE LINE OF bup_partner_guid_t,
          lo_root                     TYPE REF TO cx_root,
          lc_error                    TYPE char1 VALUE 'E',
          lc_msgid                    TYPE char4 VALUE 'R111',
          ls_bapiret2                 TYPE bapiret2.


    DATA: lt_messages TYPE cvp_tt_eop_check_messages,
          ls_messages TYPE cvp_s_eop_check_messages,

          lt_purexp_temp TYPE TABLE OF CVP_S_EOP_PARTNER_PURCMPL_EXP,
          ls_purexp_temp TYPE CVP_S_EOP_PARTNER_PURCMPL_EXP.

   DATA: badi_purpose_export   TYPE REF TO bupa_purpose_export,
          oref                 TYPE REF TO cx_root.

    FIELD-SYMBOLS: <fs_pur_cmplt_partners_final> LIKE LINE OF gt_pur_cmplt_partners_final,
                   <fs_partnerguid>              LIKE LINE OF lt_partner_guid,
                   <fs_regsys>                   LIKE LINE OF lt_regsys,
                   <fs_partner> LIKE LINE OF lt_partner.

    LOOP AT it_eop_partner_purcmpl_exp INTO ls_purexp_temp.
     IF ls_purexp_temp-BUKRS IS INITIAL AND
        ls_purexp_temp-VKORG IS INITIAL AND
        ls_purexp_temp-ID_TYPE = '2'.
        append ls_purexp_temp to lt_purexp_temp.
     ENDIF.
    ENDLOOP.

*----Executing blocking module by passing business partners.
IF  gv_test_mode IS INITIAL.
*    IF it_eop_partner_purcmpl_exp IS NOT INITIAL.
    IF lt_purexp_temp IS NOT INITIAL.

*---Avoiding loop call and checking synchronization is active or not.
    CALL METHOD cvi_ctrl_loop=>get_instance
      IMPORTING
        er_object = lr_cvi_ctrl_loop.

    lr_cvi_ctrl_loop->check_steps(
      EXPORTING
        iv_source_object = 'VENDOR'    " Source Synchronization Object
        iv_target_object =  'BP'   " Target Synchronization Object
      IMPORTING
        ev_relevant      = lv_relevant
        ).

  IF lv_relevant = 'X'.
*--- Fetching Business partners linked to vendors
      SELECT * FROM cvi_vend_link INTO TABLE lt_cvi_vend_link
                                  FOR ALL ENTRIES IN lt_purexp_temp"it_eop_partner_purcmpl_exp
                                  WHERE vendor = lt_purexp_temp-id."it_eop_partner_purcmpl_exp-id.
      IF sy-subrc = 0.
        LOOP AT lt_cvi_vend_link INTO ls_cvi_vend_link.
          ls_partner_guid_all-partner_guid = ls_cvi_vend_link-partner_guid.
          APPEND ls_partner_guid_all TO lt_partner_guid_all.
        ENDLOOP.
*---- Fetching vendor contact persons.
        SELECT * FROM cvi_vend_ct_link INTO TABLE lt_cvi_vend_ct_link
                                    FOR ALL ENTRIES IN lt_cvi_vend_link
                                    WHERE partner_guid = lt_cvi_vend_link-partner_guid.
        IF sy-subrc = 0.
          LOOP AT lt_cvi_vend_ct_link INTO ls_cvi_vend_ct_link.
            ls_partner_guid_all-partner_guid = ls_cvi_vend_ct_link-person_guid.
            APPEND ls_partner_guid_all TO lt_partner_guid_all.
          ENDLOOP.
        ENDIF.
*---- Fetching business partners related to vendors
        SELECT partner partner_guid FROM but000 INTO TABLE lt_partner_guid
                                    FOR ALL ENTRIES IN lt_partner_guid_all
                                    WHERE partner_guid = lt_partner_guid_all-partner_guid.
        IF sy-subrc = 0.
*--- Moving only business partners without GUID
          MOVE lt_partner_guid TO lt_partner.

*&---- Get all the registered systems
          CALL FUNCTION 'BUPA_EOP_REGSYS'
            EXPORTING
              IV_REPL_TYPE       = 'CV->BP'
            TABLES
              et_eopsys = lt_regsys.

*&---- Set the XPCPT and XDELE to 'X'
          CALL FUNCTION 'BUPA_XPCPT_SET'
            EXPORTING
              it_partners = lt_partner
              status      = gc_x.


        CLEAR lt_pur_cmplt_partners_final.

           lt_pur_cmplt_partners_final = gt_pur_cmplt_partners_final.

             CLEAR ls_pur_cmplt_partners_final.
              ls_pur_cmplt_partners_final-status = 'F'.

       LOOP AT lt_partner ASSIGNING <fs_partner>.

              MODIFY lt_pur_cmplt_partners_final FROM ls_pur_cmplt_partners_final
                                                 TRANSPORTING status
                                                 WHERE partner = <fs_partner>-partner.
       ENDLOOP.
*&---- Update SORT table with the values generated
          CALL FUNCTION 'BUPA_SORT_CHANGE_DETAIL'
            EXPORTING
              it_sort = lt_pur_cmplt_partners_final.

*&---- Update all the connected systems
          IF lt_regsys IS NOT INITIAL.
            CLEAR lt_bubutsort_maint_guid.
            LOOP AT gt_pur_cmplt_partners_final ASSIGNING <fs_pur_cmplt_partners_final>.
              READ TABLE lt_partner_guid WITH KEY partner = <fs_pur_cmplt_partners_final>-partner
                                        ASSIGNING <fs_partnerguid>.
              IF sy-subrc = 0.
              ls_bubutsort_maint_guid-partner_guid = <fs_partnerguid>-partner_guid.
              ENDIF.
              MOVE-CORRESPONDING <fs_pur_cmplt_partners_final> TO ls_bubutsort_maint_guid.
              APPEND ls_bubutsort_maint_guid TO lt_bubutsort_maint_guid.
              CLEAR ls_bubutsort_maint_guid.
            ENDLOOP.

            LOOP AT lt_regsys ASSIGNING <fs_regsys>.
              CALL FUNCTION 'BUPA_PURPOSE_COMPLETE'" STARTING NEW TASK task_final_set
                DESTINATION <fs_regsys>-rfcdes
                EXPORTING
                  IT_SORT          = lt_bubutsort_maint_guid
               IMPORTING
                 EV_SUCCESS       = lv_rbsuccess
                 ET_MESSAGE       = lt_messages3
                        .

              LOOP AT lt_messages3 into ls_messages3.
                CLEAR : ls_messages1 ,es_messages, lt_messages1[].
                REFRESH: lt_messages1[].
                ls_messages1-type        = ls_messages3-type.
                ls_messages1-id          = ls_messages3-id.
                ls_messages1-number      = ls_messages3-number.
                ls_messages1-message_v1  = ls_messages3-message_v1.
                ls_messages1-message_v2  = ls_messages3-message_v2.
                ls_messages1-message_v3  = ls_messages3-message_v3.
                ls_messages1-message_v4  = ls_messages3-message_v4.
                append ls_messages1 to lt_messages1 .

               es_messages-messages[] = lt_messages1[] .
               append es_messages to et_messages .
             ENDLOOP.
                IF lv_rbsuccess = ' '.
                  lv_rfcdes = <fs_regsys>-rfcdes.
                  EXIT.
                ELSE.
                  APPEND <fs_regsys> TO lt_regsys_temp.
                ENDIF.
*              CALL FUNCTION 'BUPA_PURPOSE_COMPLETE' STARTING NEW TASK gc_task_final_set
*                DESTINATION <fs_regsys>-rfcdes
*                EXPORTING
*                  it_sort = lt_bubutsort_maint_guid.
            ENDLOOP.

*&---- Update all all connected systems using XI
*****************Proxy Call***********************************
        CLEAR lit_output.
        LOOP AT lt_bubutsort_maint_guid INTO ls_bubutsort_maint_guid.
          MOVE-CORRESPONDING ls_bubutsort_maint_guid TO ls_business_partner_compl_req.
          APPEND ls_business_partner_compl_req TO lit_business_partner_compl_req.
        ENDLOOP.
        lt_business_partner_compl_req-it_sort-item = lit_business_partner_compl_req.

        lv_proxyclass = 'CO_ABABUSINESS_PARTNER_EOPCOMP'.

        CALL METHOD cl_srt_public_factory=>get_query_handler
          RECEIVING
            query = lv_query.
*&---- get all logical ports of the corresponding proxy
        CALL METHOD lv_query->get_lp_names
          EXPORTING
            proxy_name = lv_proxyclass
          RECEIVING
            lp_names   = lt_log_port.
        LOOP AT lt_log_port INTO ls_log_port.
          TRY.
*&---- Create instance of proxy
              CREATE OBJECT lo_proxy EXPORTING logical_port_name = ls_log_port..

*&---- Set XI Message Queue id
              CALL METHOD lo_proxy->ababusiness_partner_eopcomplou
                EXPORTING
                  output = lt_business_partner_compl_req
                IMPORTING
                  input  = lt_business_partner_compl_res.
            CATCH cx_ai_system_fault INTO lo_sys.
          ENDTRY.
************Assigning Proxy object to local object
        LOOP AT lt_business_partner_compl_res-et_message-item INTO ls_bp_partner_compl_msg.
          MOVE-CORRESPONDING ls_bp_partner_compl_msg TO ls_messages_compl.
          APPEND ls_messages_compl TO lt_messages3.
        ENDLOOP.

           lv_rbsuccess = lt_business_partner_compl_res-ev_success.

              LOOP AT lt_messages3 into ls_messages3.
                CLEAR : ls_messages1 ,es_messages, lt_messages1[].
                REFRESH: lt_messages1[].
                ls_messages1-type        = ls_messages3-type.
                ls_messages1-id          = ls_messages3-id.
                ls_messages1-number      = ls_messages3-number.
                ls_messages1-message_v1  = ls_messages3-message_v1.
                ls_messages1-message_v2  = ls_messages3-message_v2.
                ls_messages1-message_v3  = ls_messages3-message_v3.
                ls_messages1-message_v4  = ls_messages3-message_v4.
                append ls_messages1 to lt_messages1 .

               es_messages-messages[] = lt_messages1[] .
               append es_messages to et_messages .
             ENDLOOP.

        ENDLOOP.
************************Proxy call**************************
        IF lv_rbsuccess = ' '.

          CALL FUNCTION 'BUPA_XPCPT_SET'
            EXPORTING
              it_partners = lt_partner
              status      = ' '.

          LOOP AT lt_bubutsort_maint_guid INTO ls_bubutsort_maint_guid  .
            MOVE-CORRESPONDING ls_bubutsort_maint_guid TO ls_resetbp.
            APPEND ls_resetbp TO lt_resetbp.
          ENDLOOP.

          LOOP AT lt_regsys_temp ASSIGNING <fs_regsys>.
            TRY .
                CALL FUNCTION 'BUPA_PURPOSE_RESET' "STARTING NEW TASK task_final_set
                  DESTINATION <fs_regsys>-rfcdes
                  EXPORTING
                    it_partner = lt_resetbp
                  EXCEPTIONS
                     OTHERS    =    4.
              IF sy-subrc = 4.
                ls_messages1-id          = sy-msgid.
                ls_messages1-number      = sy-msgno.
                ls_messages1-message_v1  = sy-msgv1.
                ls_messages1-message_v2  = sy-msgv2.

                APPEND ls_messages1 To lt_messages1 .
                es_messages-messages[] = lt_messages1[] .
                APPEND es_messages To et_messages .
              ENDIF.

              CATCH cx_root INTO lo_root.
                ls_messages1-type       = lc_error.
                ls_messages1-id         = lc_msgid.
                ls_messages1-number     = 055.
                ls_messages1-message_v1 = <fs_regsys>-rfcdes.
                ls_messages1-message_v2 = 'BUPA_PURPOSE_RESET'.

                APPEND ls_messages1 To lt_messages1 .
                es_messages-messages[] = lt_messages1[] .
                APPEND es_messages To et_messages .
                RETURN.
            ENDTRY.
          ENDLOOP.


**&------ Write log for error
          LOOP AT lt_bubutsort_maint_guid INTO ls_bubutsort_maint_guid.
            ls_messages1-type       = lc_error.
            ls_messages1-id         = lc_msgid.
            ls_messages1-number     = 053.
            ls_messages1-message_v1 = ls_bubutsort_maint_guid-partner.
            ls_messages1-message_v2 = lv_rfcdes.
            ls_messages1-message_v3 = ls_bubutsort_maint_guid-appl_name.
            APPEND ls_messages1 To lt_messages1 .
            es_messages-messages[] = lt_messages1[] .
            APPEND es_messages To et_messages .
          ENDLOOP.
        ENDIF.
        ENDIF.

        ENDIF.
      ENDIF.
*&---- Check whether Export BADI implementation active
          TRY.
              GET BADI badi_purpose_export.

            CATCH cx_badi_not_implemented. "no active implementation
          ENDTRY.

          IF badi_purpose_export IS NOT INITIAL.
*&---- Check if the FS_CHECKMODE is "ON"
            CALL FUNCTION 'BUPA_GET_FLAG_EXTERN_DATACHECK'
              IMPORTING
                ev_check_only_external_data = lv_check_only_external_data.

*&---- Loop for passing the data to Application specific structure
            LOOP AT lt_pur_cmplt_partners_final ASSIGNING <fs_pur_cmplt_partners_final>
                                                WHERE status = lc_final.
              MOVE-CORRESPONDING <fs_pur_cmplt_partners_final> TO ls_pur_cmplt_partners.
              APPEND ls_pur_cmplt_partners TO lt_pur_cmplt_partners.
            ENDLOOP.

*&---- Send SORT to other application
            GET TIME STAMP FIELD lv_timestamp.
            CALL BADI badi_purpose_export->bupa_purcompl_export
              EXPORTING
                iv_timestamp_bus = lv_timestamp
                iv_checkmode     = lv_check_only_external_data
                it_butsort       = lt_pur_cmplt_partners
              CHANGING
                ct_return        = lt_return.

              LOOP AT lt_return  INTO ls_bapiret2 .
                ls_messages1-type       = ls_bapiret2-type.
                ls_messages1-id         = ls_bapiret2-id.
                ls_messages1-number     = ls_bapiret2-number.
                ls_messages1-message_v1 = ls_bapiret2-message_v1.
                ls_messages1-message_v2 = ls_bapiret2-message_v2.
                ls_messages1-message_v3 = ls_bapiret2-message_v3.
                ls_messages1-message_v4 = ls_bapiret2-message_v4.

                APPEND ls_messages1 To lt_messages1 .
                es_messages-messages[] = lt_messages1[] .
                APPEND es_messages To et_messages .
             ENDLOOP.
          ENDIF.
       ENDIF.
        ENDIF.
  ENDIF.
  ENDMETHOD.


  METHOD cvp_if_appl_eop_check~partners_purcmpl_reset.
*&---Local variables and constants decleration
    CONSTANTS: lc_task_final_reset TYPE char11 VALUE 'FINAL_RESET'.

    DATA: lt_cvi_vend_link        TYPE TABLE OF cvi_vend_link,
          lt_cvi_vend_ct_link     TYPE TABLE OF cvi_vend_ct_link,
          ls_cvi_vend_link        LIKE LINE OF lt_cvi_vend_link,
          ls_cvi_vend_ct_link     LIKE LINE OF lt_cvi_vend_ct_link,
          lt_partner_guid         TYPE bup_partner_guid_t,
          lt_partner_guid_all     TYPE bup_partnerguid_t,
          ls_partner_guid_all     TYPE bup_partnerguid_s,
          lt_partner              TYPE bu_partner_t,
          lt_regsys               TYPE TABLE OF butregsys_remote,
          lt_bubutsort_maint_guid TYPE bubutsort_maint_guid_t,
          ls_bubutsort_maint_guid TYPE bubutsort_maint_guid,
          lt_partnerguid_reset    TYPE bup_partner_guid_t,
          ls_partnerguid_reset    TYPE LINE OF bup_partner_guid_t,
          lwa_reset               TYPE LINE OF business_partner_eopreset__tab,
          lit_reset               TYPE business_partner_eopreset__tab,
          it_reset                TYPE ababusiness_partner_eopreset,
          lo_rproxy               TYPE REF TO co_ababusiness_partner_eoprese,
          lt_log_port             TYPE srt_lp_names,
          ls_log_port             LIKE LINE OF lt_log_port,
          lv_proxyclass           TYPE srt_wsp_dt_obj_name,
          lo_sys                  TYPE REF TO cx_ai_system_fault,
          lv_query                TYPE REF TO if_srt_public_query_handler.

    DATA: lt_pur_cmplt_partners_final TYPE bu_butsort_maint_t,
          ls_pur_cmplt_partners_final TYPE bubutsort_maint.

    FIELD-SYMBOLS: <fs_partner>     TYPE LINE OF bu_partner_t,
                   <fs_partnerguid> LIKE LINE OF lt_partner_guid,
                   <fs_regsys>      LIKE LINE OF lt_regsys.

*----Executing unblocking module by passing business partners.
IF  gv_test_mode IS INITIAL.
    IF it_partners IS NOT INITIAL.
*--- Fetching Business partners linked to vendors
      SELECT * FROM cvi_vend_link INTO TABLE lt_cvi_vend_link
                                  FOR ALL ENTRIES IN it_partners
                                  WHERE vendor = it_partners-id.
      IF sy-subrc = 0.
        LOOP AT lt_cvi_vend_link INTO ls_cvi_vend_link.
          ls_partner_guid_all-partner_guid = ls_cvi_vend_link-partner_guid.
          APPEND ls_partner_guid_all TO lt_partner_guid_all.
        ENDLOOP.
*---- Fetching vendor contact persons.
        SELECT * FROM cvi_vend_ct_link INTO TABLE lt_cvi_vend_ct_link
                                    FOR ALL ENTRIES IN lt_cvi_vend_link
                                    WHERE partner_guid = lt_cvi_vend_link-partner_guid.
        IF sy-subrc = 0.
          LOOP AT lt_cvi_vend_ct_link INTO ls_cvi_vend_ct_link.
            ls_partner_guid_all-partner_guid = ls_cvi_vend_ct_link-person_guid.
            APPEND ls_partner_guid_all TO lt_partner_guid_all.
          ENDLOOP.
        ENDIF.
        SELECT partner partner_guid FROM but000 INTO TABLE lt_partner_guid
                                    FOR ALL ENTRIES IN lt_partner_guid_all
                                    WHERE partner_guid = lt_partner_guid_all-partner_guid.
        IF sy-subrc = 0.
*--- Moving only business partners without GUID
          MOVE lt_partner_guid TO lt_partner.

*&---- Get all the registered systems
          CALL FUNCTION 'BUPA_EOP_REGSYS'
            EXPORTING
              IV_REPL_TYPE       = 'CV->BP'
            TABLES
              et_eopsys = lt_regsys.

*&---- Set the XPCPT and XDELE to <Space>
          CALL FUNCTION 'BUPA_XPCPT_SET'
            EXPORTING
              it_partners = lt_partner
              status      = gc_space.

          LOOP AT lt_partner ASSIGNING <fs_partner>.
            ls_pur_cmplt_partners_final-partner = <fs_partner>-partner.
            ls_pur_cmplt_partners_final-task = gc_delete.
            APPEND ls_pur_cmplt_partners_final TO lt_pur_cmplt_partners_final.
          ENDLOOP.

* Delete SORT information for partners which are unblocked now
*    CALL FUNCTION 'BUPA_SORT_CHANGE_DETAIL'
*      EXPORTING
*        it_sort = lt_pur_cmplt_partners_final.

*&---- Get all the registered systems
          CALL FUNCTION 'BUPA_EOP_REGSYS'
            EXPORTING
              IV_REPL_TYPE       = 'CV->BP'
            TABLES
              et_eopsys = lt_regsys.

*&---- Update all the connected systems
          IF lt_regsys IS NOT INITIAL.
            LOOP AT lt_partner ASSIGNING <fs_partner>.
              READ TABLE lt_partner_guid WITH KEY partner = <fs_partner>-partner ASSIGNING <fs_partnerguid>.
              IF sy-subrc = 0.
                ls_partnerguid_reset-partner_guid = <fs_partnerguid>-partner_guid.
              ENDIF.
              MOVE-CORRESPONDING <fs_partner> TO ls_partnerguid_reset.
              APPEND ls_partnerguid_reset TO lt_partnerguid_reset.
            ENDLOOP.

            LOOP AT lt_regsys ASSIGNING <fs_regsys>.
              CALL FUNCTION 'BUPA_PURPOSE_RESET' STARTING NEW TASK lc_task_final_reset DESTINATION <fs_regsys>-rfcdes
                EXPORTING
                  it_partner = lt_partnerguid_reset.
            ENDLOOP.
          ENDIF.
******************Proxy Call**********************
          LOOP AT lt_partnerguid_reset INTO ls_partnerguid_reset.
            MOVE-CORRESPONDING ls_partnerguid_reset TO lwa_reset.
            APPEND lwa_reset TO lit_reset.
          ENDLOOP.
          it_reset-ababusiness_partner_eopreset-partner_reset = lit_reset.

          lv_proxyclass = 'CO_ABABUSINESS_PARTNER_EOPRESE'.
          CALL METHOD cl_srt_public_factory=>get_query_handler
            RECEIVING
              query = lv_query.
*&----  get all logical ports of the corresponding proxy
          CALL METHOD lv_query->get_lp_names
            EXPORTING
              proxy_name = lv_proxyclass
            RECEIVING
              lp_names   = lt_log_port.

          LOOP AT lt_log_port INTO ls_log_port.
            TRY.
                CREATE OBJECT lo_rproxy EXPORTING logical_port_name = ls_log_port.
                CALL METHOD lo_rproxy->ababusiness_partner_eopreset_o
                  EXPORTING
                    output = it_reset.
                COMMIT WORK AND WAIT.
              CATCH cx_ai_system_fault INTO lo_sys.
            ENDTRY.
          ENDLOOP.
        ENDIF.
      ENDIF.
    ENDIF.
 ENDIF.
  ENDMETHOD.
ENDCLASS.
