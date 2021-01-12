class CRM_IF_VMD_EOP_CHECK definition
  public
  create public .

public section.

  interfaces CVP_IF_APPL_EOP_CHECK .
  interfaces CVP_IF_CONSTANTS .
  interfaces CVP_IF_CONST_DCPLD_I1 .

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

  data GV_CRM_CONNECTED type BOOLE_D .
ENDCLASS.



CLASS CRM_IF_VMD_EOP_CHECK IMPLEMENTATION.


  method CVP_IF_APPL_EOP_CHECK~CHECK_CPD_PARTNERS.
  endmethod.


  METHOD cvp_if_appl_eop_check~check_partners.
*---Local constants and varibles decleration

    CONSTANTS: lc_fm TYPE rs38l_fnam VALUE 'BUPA_PREPARE_EOP_BLOCK_WF'.

    TYPES: BEGIN OF ty_crmlifnr,
             vendor_no  TYPE lifnr,
             partn_guid TYPE bu_partner_guid,
           END OF ty_crmlifnr,

           BEGIN OF ty_crmkunnr,
             custome_no TYPE kunnr,
             partn_guid TYPE bu_partner_guid,
           END OF ty_crmkunnr,

           BEGIN OF ty_crmparnr,
             contact_no TYPE kunnr,
             org_guid   TYPE bu_partner_guid,
             person_gui TYPE bu_partner_guid,
           END OF ty_crmparnr,

           BEGIN OF ty_contact_no,
             contact_no TYPE parnr,
           END OF ty_contact_no.

    DATA: lr_cvi_ctrl_loop     TYPE REF TO cvi_ctrl_loop,
          lt_crm_vend          TYPE TABLE OF crmlifnr,
          lt_crmlifnr          TYPE TABLE OF ty_crmlifnr,
          lt_crm_cont          TYPE TABLE OF crmparnr,
          lt_cont              TYPE TABLE OF crmparnr,
          lt_crmparnr          TYPE TABLE OF ty_crmparnr,
          lt_crmkunnr          TYPE TABLE OF ty_crmkunnr,
          lt_crm_cust          TYPE crmkunnr_t,
          ls_crmlifnr          LIKE LINE OF lt_crmlifnr,
          ls_crm_vend          LIKE LINE OF lt_crm_vend,
          ls_crmparnr          LIKE LINE OF lt_crmparnr,
          ls_crm_cont          LIKE LINE OF lt_crm_cont,
          ls_crmkunnr          LIKE LINE OF lt_crmkunnr,
          ls_crm_cust          LIKE LINE OF lt_crm_cust,
          ls_crmrfcpar         TYPE crmrfcpar,
          lt_but000_partn_guid TYPE bup_partner_guid_t,
          ls_but000_partn_guid TYPE bupa_partner_guid,
          lt_partners_guid     TYPE bup_partner_guid_t,
          lt_partner_guid      TYPE bup_partner_guid_t,
          lt_partner_guid_all  TYPE bup_partnerguid_t,
          ls_partner_guid_all  TYPE bup_partnerguid_s,
          ls_partner_guid      LIKE LINE OF lt_partner_guid,
          lt_partner           TYPE bu_partner_t,
          lv_intrim            TYPE char1,
          lv_ovrall            TYPE char1,
          lv_detlog            TYPE char1,
          lv_applog            TYPE char1,
          lt_regsys            TYPE STANDARD TABLE OF butregsys_remote,
          ls_regsys            TYPE  butregsys_remote,
          lt_contact_no        TYPE TABLE OF ty_contact_no,
          ls_contact_no        TYPE ty_contact_no.

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

    DATA: lt_pur_cmplt_partners     TYPE bu_butsort_maint_t,
          lt_eop_check_partners_cpd TYPE cvp_tt_eop_check_partners_cpd,
          ls_pur_cmplt_partners     LIKE LINE OF lt_pur_cmplt_partners,
          ls_sort_result_partners   LIKE LINE OF et_sort_result_partners,
          ls_eop_check_partners     LIKE LINE OF it_eop_check_partners,
          ls_eop_check_partners1    LIKE LINE OF it_eop_check_partners.

    DATA: lv_own_logical_system     TYPE tbdls-logsys.

    DATA: lv_index TYPE i,
          lv_guid  TYPE  guid_16.

    FIELD-SYMBOLS : <fs_messages> TYPE cvp_s_eop_check_messages.

*   Only if the CRM system is connected to this ECC system, then continue further processing in the class!
    CHECK gv_crm_connected IS NOT INITIAL.

*---Avoiding loop call and checking synchronization is active or not.
    CALL FUNCTION 'CRM_IF_BUPA_GUID_GET'
      IMPORTING
        ex_guid = lv_guid.

    CALL METHOD crm_if_loops_ctrl=>check_steps
      EXPORTING
        iv_source_object = 'VENDOR'
        iv_target_object = 'BP'
        iv_guid          = lv_guid
      IMPORTING
        ev_relevant      = lv_relevant
*       es_error         =
      .

****&---- Checking EOP check done for BP to CUSTOMER or not.
*    CALL METHOD crm_if_loops_ctrl=>check_steps
*      EXPORTING
*        iv_source_object = 'BP'
*        iv_target_object = 'CUSTOMER'
*        iv_guid          = lv_guid
*      IMPORTING
*        ev_relevant      = lv_relevant1
**       es_error         =
    .
    IF lv_relevant = 'X' AND it_eop_check_partners IS NOT INITIAL.
*----Executing blocking module by passing business partners.
      SELECT vendor_no partn_guid FROM crmlifnr INTO TABLE lt_crm_vend
                                   FOR ALL ENTRIES IN it_eop_check_partners
                                   WHERE vendor_no = it_eop_check_partners-id.
      IF sy-subrc = 0.
        LOOP AT lt_crm_vend INTO ls_crm_vend.
          ls_crmlifnr-vendor_no = ls_crm_vend-vendor_no.
          ls_crmlifnr-partn_guid = ls_crm_vend-partn_guid.
          ls_partner_guid-partner_guid = ls_crm_vend-partn_guid.
          APPEND ls_crmlifnr TO lt_crmlifnr.

          MOVE ls_crm_vend-partn_guid TO ls_partner_guid-partner_guid.
          APPEND ls_partner_guid TO lt_partners_guid.
          CLEAR ls_partner_guid.

        ENDLOOP.
*--- Fetching customers linked to bp
*        SELECT custome_no partn_guid FROM crmkunnr INTO TABLE lt_crm_cust
*                                     FOR ALL ENTRIES IN lt_crm_vend
*                                     WHERE partn_guid = lt_crm_vend-partn_guid.
*        IF sy-subrc = 0 AND lv_relevant1 = 'X'.
**          LOOP AT lt_crm_cust INTO ls_crm_cust.
**            ls_crmkunnr-custome_no = ls_crm_cust-custome_no.
**            ls_crmkunnr-partn_guid = ls_crm_cust-partn_guid.
**            ls_eop_check_partners-id = ls_crm_cust-custome_no.
**            ls_eop_check_partners-id_type = '1'.
**            APPEND ls_crmkunnr TO lt_crmkunnr.
**            APPEND ls_eop_check_partners TO lt_eop_check_partners.
**          ENDLOOP.
*          LOOP AT lt_crm_cust INTO ls_crm_cust.
*            MOVE ls_crm_cust-partn_guid to ls_partner_guid-partner_guid.
*            APPEND ls_partner_guid to lt_partner_guid.
*            CLEAR ls_partner_guid.
*          ENDLOOP.
***** Partners checks before calling CVP_PREPARE_EOP_BLOCK
*          CALL FUNCTION 'CVP_PREPARE_EOP_CHECK'
*            EXPORTING
*              it_crmkunnr              = lt_crm_cust
*            IMPORTING
*              et_cust_eop_partners     = lt_eop_check_partners
*              et_cust_eop_partners_cpd = lt_eop_check_partners_cpd.
*        ENDIF.
*---- Fetching vendor contact persons.
        SELECT client contact_no org_guid person_gui FROM crmparnr INTO TABLE lt_crm_cont
                                                     FOR ALL ENTRIES IN lt_crm_vend
                                                     WHERE org_guid = lt_crm_vend-partn_guid.
        IF sy-subrc = 0.
          LOOP AT lt_crm_cont INTO ls_crm_cont.
            ls_crmparnr-contact_no = ls_crm_cont-contact_no.
            ls_crmparnr-org_guid = ls_crm_cont-org_guid.
            ls_crmparnr-person_gui = ls_crm_cont-person_gui.
            ls_partner_guid-partner_guid = ls_crm_cont-person_gui.
            APPEND ls_crmparnr TO lt_crmparnr.

            MOVE ls_crm_cont-person_gui TO ls_partner_guid-partner_guid.
            APPEND ls_partner_guid TO lt_partners_guid.
            CLEAR ls_partner_guid.

          ENDLOOP.
        ENDIF.
      ENDIF.

*&---- Conversion from CHAR to NUMC
      LOOP AT it_eop_check_partners INTO ls_eop_check_partners.
        READ TABLE lt_crm_vend TRANSPORTING NO FIELDS WITH KEY vendor_no = ls_eop_check_partners-id.
        IF sy-subrc <> 0.
          READ TABLE lt_crm_cont TRANSPORTING NO FIELDS WITH KEY contact_no = ls_eop_check_partners-id.
          IF sy-subrc <> 0.
            CALL FUNCTION 'CHAR_NUMC_CONVERSION'
              EXPORTING
                input   = ls_eop_check_partners-id
              IMPORTING
                numcstr = ls_contact_no-contact_no.

            APPEND ls_contact_no TO lt_contact_no.
            CLEAR: ls_eop_check_partners, ls_contact_no.
          ENDIF.
        ENDIF.
      ENDLOOP.

    IF lt_contact_no[] IS NOT INITIAL.
*---- Fetching contact persons of Business Partners.
      SELECT * FROM crmparnr INTO TABLE lt_cont
                     FOR ALL ENTRIES IN lt_contact_no
                     WHERE contact_no = lt_contact_no-contact_no.
      IF sy-subrc = 0.
        LOOP AT lt_cont INTO ls_crm_cont.
          ls_crmparnr-contact_no = ls_crm_cont-contact_no.
          ls_crmparnr-org_guid = ls_crm_cont-org_guid.
          ls_crmparnr-person_gui = ls_crm_cont-person_gui.
          ls_partner_guid-partner_guid = ls_crm_cont-person_gui.
          APPEND ls_crmparnr TO lt_crmparnr.

          ls_crmlifnr-vendor_no = ls_crm_cont-contact_no.
          ls_crmlifnr-partn_guid = ls_crm_cont-person_gui.
          APPEND ls_crmlifnr TO lt_crmlifnr.
          CLEAR: ls_crmlifnr.

          MOVE ls_crm_cont-person_gui TO ls_partner_guid-partner_guid.
          APPEND ls_partner_guid TO lt_partner_guid.
          CLEAR ls_partner_guid.
        ENDLOOP.
      ENDIF.
    ENDIF.

*---- Updating 'SORT' result for the vendors which are not linked to Business partners
      IF lt_crm_vend IS INITIAL AND lt_cont IS INITIAL.
*&---- Getting own logical system
        CALL FUNCTION 'OWN_LOGICAL_SYSTEM_GET'
          IMPORTING
            own_logical_system             = lv_own_logical_system    " Name of own logical system
          EXCEPTIONS
            own_logical_system_not_defined = 1
            OTHERS                         = 2.
        IF sy-subrc <> 0.
*         MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        ENDIF.

        LOOP AT it_eop_check_partners INTO ls_eop_check_partners.
          ls_sort_result_partners-id = ls_eop_check_partners-id.
          ls_sort_result_partners-id_type = ls_eop_check_partners-id_type.
          ls_sort_result_partners-bukrs = ls_eop_check_partners-bukrs.
          ls_sort_result_partners-vkorg = ls_eop_check_partners-vkorg.
          IF iv_appl IS NOT INITIAL.
            ls_sort_result_partners-appl_name = iv_appl.
          ELSE.
            ls_sort_result_partners-appl_name = 'CRM_IF'.
          ENDIF.
          ls_sort_result_partners-business_system = lv_own_logical_system.
          ls_sort_result_partners-pur_cmpl_status = '1'.
          APPEND ls_sort_result_partners TO et_sort_result_partners.
          CLEAR ls_sort_result_partners.
        ENDLOOP.

        EXIT.
      ENDIF.

*---- Fetching business partners related to vendors
*      SELECT partner partner_guid FROM but000 INTO TABLE lt_partner_guid
*                                  FOR ALL ENTRIES IN lt_partner_guid_all
*                                  WHERE partner_guid = lt_partner_guid_all-partner_guid.
*      IF sy-subrc = 0.
*--- Moving only business partners without GUID

*        IF lt_eop_check_partners IS NOT INITIAL AND lv_relevant1 = 'X'.
**--- Fetching customer EOP check result.
*          CALL FUNCTION 'CVP_PREPARE_EOP_BLOCK' DESTINATION 'NONE'
*            EXPORTING
*              iv_eop_run_mode           = gv_eop_run_mode
*              iv_test_mode              = gv_test_mode
*              iv_validate_nxtchk_date   = gv_validate_nxtchk_date
*              iv_check_pur_compl_status = gv_check_pur_compl_status
*              iv_prot_output            = gv_prot_output
*              iv_detail_log             = gv_detail_log
*              it_eop_check_partners     = lt_eop_check_partners
*              it_eop_check_partners_cpd = lt_eop_check_partners_cpd
*            IMPORTING
*              et_sort_result_partners   = lt_sort_result_partners
*              et_messages               = lt_messages
**             EV_APPLOG_NUMBER          =
*            .
*          LOOP AT lt_sort_result_partners INTO ls_sort_result_partners.
*            READ TABLE lt_crmkunnr INTO ls_crmkunnr WITH KEY custome_no = ls_sort_result_partners-id.
*            IF sy-subrc = 0.
*              READ TABLE lt_crmlifnr INTO ls_crmlifnr WITH KEY partn_guid = ls_crmkunnr-partn_guid.
*              IF sy-subrc = 0.
*                READ TABLE it_eop_check_partners INTO ls_eop_check_partners WITH KEY id = ls_crmlifnr-vendor_no.
*                IF sy-subrc = 0.
*                  ls_sort_result_partners-id = ls_eop_check_partners-id.
*                  ls_sort_result_partners-id_type = ls_eop_check_partners-id_type.
*                  ls_sort_result_partners-bukrs = ls_eop_check_partners-bukrs.
*                  ls_sort_result_partners-vkorg = ls_eop_check_partners-vkorg.
*                  APPEND ls_sort_result_partners TO et_sort_result_partners.
*                  CLEAR: ls_sort_result_partners.
*                ENDIF.
*              ENDIF.
*            ENDIF.
*          ENDLOOP.
**&--- Updating result log messages
*          LOOP AT lt_messages ASSIGNING <fs_messages>.
*            READ TABLE lt_crmkunnr INTO ls_crmkunnr WITH KEY custome_no = <fs_messages>-id.
*            IF sy-subrc = 0.
*              READ TABLE lt_crmlifnr INTO ls_crmlifnr WITH KEY partn_guid = ls_crmkunnr-partn_guid.
*              IF sy-subrc = 0.
*                READ TABLE it_eop_check_partners INTO ls_eop_check_partners WITH KEY id = ls_crmlifnr-vendor_no.
*                IF sy-subrc = 0.
*                  <fs_messages>-id = ls_eop_check_partners-id.
*                  <fs_messages>-id_type = ls_eop_check_partners-id_type.
*                  <fs_messages>-bukrs = ls_eop_check_partners-bukrs.
*                  <fs_messages>-vkorg = ls_eop_check_partners-vkorg.
*                ENDIF.
*              ENDIF.
*            ENDIF.
*          ENDLOOP.
*          APPEND LINES OF lt_messages TO et_messages.
*        ENDIF.
*&---- Getting RFC information
      CALL FUNCTION 'BUPA_EOP_REGSYS'
        EXPORTING
          IV_REPL_TYPE       = 'CV->BP'
        TABLES
          et_eopsys = lt_regsys.

*---Initialization of local variables
    IF gv_eop_run_mode = '1'.
      lv_intrim = 'X'.
    ELSEIF gv_eop_run_mode = '2'.
      lv_ovrall = 'X'.
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

**** Call FM in all remote system
      LOOP AT lt_regsys INTO ls_regsys WHERE rfcdes IS NOT INITIAL.
**** Check whether FM exist in remot system or not.
        CALL FUNCTION 'FUNCTION_EXISTS' DESTINATION ls_regsys-rfcdes
          EXPORTING
            funcname           = lc_fm     " Name of Function Module
          EXCEPTIONS
            function_not_exist = 1
            OTHERS             = 2.

        IF sy-subrc = 0 AND gv_eop_run_mode = '2'.
*-----Getting 'SORT' result for business partners.
          CALL FUNCTION lc_fm DESTINATION ls_regsys-rfcdes
            EXPORTING
*             i_partnr                   = lt_partner
*             I_FILTER                   =
              i_intrim                   = lv_intrim
              i_ovrall                   = lv_ovrall
              i_chkdat                   = gv_validate_nxtchk_date
*             I_INTRES                   =
              I_APPLOG                   = lv_applog
              I_DETLOG                   = lv_detlog
              i_tesrun                   = gv_test_mode
              i_chkeop                   = gv_check_pur_compl_status
*             I_BLOCKS                   =
              i_guid                     = lv_guid
              i_partner_guid             = lt_partners_guid
            IMPORTING
              e_partner_guid             = lt_partner_guid
*             e_bal_msg                  = lt_bal_msg
              e_pur_cmplt_partners_final = lt_pur_cmplt_partners
              e_cvi_messages             = lt_cvi_messages.

*&--- Storing results to update SORT table
          gt_pur_cmplt_partners_final = lt_pur_cmplt_partners.

*----- Sorting vendor link and vendor contact persons link table.
          SORT: lt_crmlifnr ASCENDING BY partn_guid.
          SORT: lt_crmparnr ASCENDING BY org_guid.
          SORT: lt_pur_cmplt_partners,
                lt_partner_guid ASCENDING BY partner.
          SORT: lt_cvi_messages ASCENDING BY partnerid.

*----- Updating 'SORT' information after EOP Check.
          LOOP AT it_eop_check_partners INTO ls_eop_check_partners.
            READ TABLE lt_crmlifnr INTO ls_crmlifnr WITH KEY vendor_no = ls_eop_check_partners-id.
            IF sy-subrc = 0.
*---- Updating 'SORT' result for the vendors which are linked to Business partners
              READ TABLE lt_partner_guid INTO ls_partner_guid WITH KEY partner_guid = ls_crmlifnr-partn_guid.
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
                READ TABLE lt_crmparnr TRANSPORTING NO FIELDS WITH KEY org_guid = ls_partner_guid-partner_guid BINARY SEARCH.
                IF sy-subrc = 0.
                  lv_index = sy-tabix.
                  LOOP AT lt_crmparnr INTO ls_crmparnr FROM lv_index.
                    IF ls_crmlifnr-partn_guid <> ls_crmparnr-org_guid.
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
*&---- Getting own logical system
              CALL FUNCTION 'OWN_LOGICAL_SYSTEM_GET'
                IMPORTING
                  own_logical_system             = lv_own_logical_system    " Name of own logical system
                EXCEPTIONS
                  own_logical_system_not_defined = 1
                  OTHERS                         = 2.
              IF sy-subrc <> 0.
*         MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
              ENDIF.
*---- Updating 'SORT' result for the vendors which are not linked to Business partners
              ls_sort_result_partners-id = ls_eop_check_partners-id.
              ls_sort_result_partners-id_type = ls_eop_check_partners-id_type.
              ls_sort_result_partners-bukrs = ls_eop_check_partners-bukrs.
              ls_sort_result_partners-vkorg = ls_eop_check_partners-vkorg.
              IF iv_appl IS NOT INITIAL.
                ls_sort_result_partners-appl_name = iv_appl.
              ELSE.
                ls_sort_result_partners-appl_name = 'CRM_IF'.
              ENDIF.
              ls_sort_result_partners-business_system = lv_own_logical_system.
              ls_sort_result_partners-pur_cmpl_status = '1'.
              APPEND ls_sort_result_partners TO et_sort_result_partners.
              CLEAR ls_sort_result_partners.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDLOOP.
*      ENDIF.
    ENDIF.
  ENDMETHOD.


  method CVP_IF_APPL_EOP_CHECK~FINALIZE.
  endmethod.


  method CVP_IF_APPL_EOP_CHECK~FINALIZE_UNBLOCK.
  endmethod.


  method CVP_IF_APPL_EOP_CHECK~INITIALIZE.
  DATA ls_crmconsum TYPE crmconsum.
*--- Initialising global variables.
    IF iv_check_pur_compl_status = 'X'.
      gv_check_pur_compl_status = ' '.
    ELSE.
     gv_check_pur_compl_status = 'X'.
    ENDIF.
    gv_detail_log = iv_detail_log.
    gv_eop_run_mode = iv_eop_run_mode.
    gv_test_mode = iv_test_mode.
    gv_validate_nxtchk_date = iv_validate_nxtchk_date.

*   Check if CRM is connected to this ECC system
    SELECT SINGLE * FROM crmconsum INTO ls_crmconsum WHERE consumer = 'CRM' AND aktiv = abap_true.
     IF sy-subrc = 0.
       gv_crm_connected = abap_true.
     ELSE.
       gv_crm_connected = abap_false.
     ENDIF.

  endmethod.


  method CVP_IF_APPL_EOP_CHECK~INITIALIZE_UNBLOCK.
  DATA ls_crmconsum TYPE crmconsum.
*&----- Initialize global variables for unblocking
    gv_appl = iv_appl.
    gv_test_mode = iv_test_mode.
    gv_prot_output = iv_prot_output.
    gv_detail_log = iv_detail_log.

*   Check if CRM is connected to this ECC system
    SELECT SINGLE * FROM crmconsum INTO ls_crmconsum WHERE consumer = 'CRM' AND aktiv = abap_true.
     IF sy-subrc = 0.
       gv_crm_connected = abap_true.
     ELSE.
       gv_crm_connected = abap_false.
     ENDIF.

  endmethod.


  METHOD cvp_if_appl_eop_check~partners_prep_purcmpl_reset.
*---Local constants and varibles decleration

    CONSTANTS: lc_fm TYPE rs38l_fnam VALUE 'BUPA_PREPARE_EOP_UNBLOCK_WF'.

    TYPES: BEGIN OF ty_crmlifnr,
             vendor_no  TYPE lifnr,
             partn_guid TYPE bu_partner_guid,
           END OF ty_crmlifnr,

           BEGIN OF ty_crmkunnr,
             custome_no TYPE kunnr,
             partn_guid TYPE bu_partner_guid,
           END OF ty_crmkunnr,

           BEGIN OF ty_crmparnr,
             contact_no TYPE kunnr,
             org_guid   TYPE bu_partner_guid,
             person_gui TYPE bu_partner_guid,
           END OF ty_crmparnr.

    DATA: lr_cvi_ctrl_loop    TYPE REF TO cvi_ctrl_loop,
          lt_crm_vend         TYPE TABLE OF crmlifnr,
          lt_crmlifnr         TYPE TABLE OF ty_crmlifnr,
          lt_crm_cont         TYPE TABLE OF crmparnr,
          lt_crmparnr         TYPE TABLE OF ty_crmparnr,
          lt_crm_cust         TYPE TABLE OF crmkunnr,
          lt_crmkunnr         TYPE TABLE OF ty_crmkunnr,
          ls_crmlifnr         LIKE LINE OF lt_crmlifnr,
          ls_crm_vend         LIKE LINE OF lt_crm_vend,
          ls_crmparnr         LIKE LINE OF lt_crmparnr,
          ls_crm_cont         LIKE LINE OF lt_crm_cont,
          ls_crmkunnr         LIKE LINE OF lt_crmkunnr,
          ls_crm_cust         LIKE LINE OF lt_crm_cust,
          ls_crmrfcpar        TYPE crmrfcpar,
          lt_partners_guid    TYPE bup_partner_guid_t,
          lt_partner_guid     TYPE bup_partner_guid_t,
          lt_partner_guid_all TYPE bup_partnerguid_t,
          ls_partner_guid_all TYPE bup_partnerguid_s,
          ls_partner_guid     LIKE LINE OF lt_partner_guid,
          lt_partner          TYPE bu_partner_t,
          lv_intrim           TYPE char1,
          lv_ovrall           TYPE char1,
          lt_regsys           TYPE STANDARD TABLE OF butregsys_remote,
          ls_regsys           TYPE  butregsys_remote.

    DATA: lt_unblk_cust_partners      TYPE cvp_tt_unblock_status,
          lt_unblk_cust_partn_results TYPE cvp_tt_unblock_status,
          lt_unblk_partn_results      TYPE bupartner_unblk_statusremote_t,
          ls_unblk_cust_partn_results LIKE LINE OF lt_unblk_cust_partn_results,
          ls_unblk_partn_results      LIKE LINE OF lt_unblk_partn_results,
          ls_unblk_cust_partners      LIKE LINE OF lt_unblk_cust_partners,
          ls_partners                 LIKE LINE OF it_partners,
          ls_unblk_partners           LIKE LINE OF et_partners.

    DATA: lt_bal_msg      TYPE ty_t_bal_msg,
          lt_cvi_messages TYPE buslocalmsg_t,
          ls_cvi_messages TYPE buslocalmsg,
          lv_relevant     TYPE boole_d.

    DATA: lt_messages TYPE cvp_tt_eop_check_messages,
          ls_messages TYPE cvp_s_eop_check_messages,
          ls_bapiret2 TYPE bapiret2.


    DATA: lv_index TYPE i,
          lv_guid  TYPE  guid_16.

    FIELD-SYMBOLS : <fs_messages> TYPE cvp_s_eop_check_messages.

*   Only if the CRM system is connected to this ECC system, then continue further processing in the class!
    CHECK gv_crm_connected IS NOT INITIAL.

*---Initialization of local variables
    IF gv_eop_run_mode = '1'.
      lv_intrim = 'X'.
    ELSEIF gv_eop_run_mode = '2'.
      lv_ovrall = 'X'.
    ENDIF.

*---Avoiding loop call and checking synchronization is active or not.
    CALL FUNCTION 'CRM_IF_BUPA_GUID_GET'
      IMPORTING
        ex_guid = lv_guid.

    CALL METHOD crm_if_loops_ctrl=>check_steps
      EXPORTING
        iv_source_object = 'VENDOR'
        iv_target_object = 'BP'
        iv_guid          = lv_guid
      IMPORTING
        ev_relevant      = lv_relevant
*       es_error         =
      .

    IF lv_relevant = 'X' AND it_partners IS NOT INITIAL.
*----Executing blocking module by passing business partners.
      SELECT vendor_no partn_guid FROM crmlifnr INTO TABLE lt_crm_vend
                                   FOR ALL ENTRIES IN it_partners
                                   WHERE vendor_no = it_partners-id.
      IF sy-subrc = 0.
        LOOP AT lt_crm_vend INTO ls_crm_vend.
          ls_crmlifnr-vendor_no = ls_crm_vend-vendor_no.
          ls_crmlifnr-partn_guid = ls_crm_vend-partn_guid.
          ls_partner_guid-partner_guid = ls_crm_vend-partn_guid.
          APPEND ls_crmlifnr TO lt_crmlifnr.
          APPEND ls_partner_guid TO lt_partners_guid.
        ENDLOOP.
*--- Fetching customers linked to bp
*        SELECT custome_no partn_guid FROM crmkunnr INTO TABLE lt_crm_cust
*                                     FOR ALL ENTRIES IN lt_crm_vend
*                                     WHERE partn_guid = lt_crm_vend-partn_guid.
*        IF sy-subrc = 0.
*          LOOP AT lt_crm_cust INTO ls_crm_cust.
*            ls_crmkunnr-custome_no = ls_crm_cust-custome_no.
*            ls_crmkunnr-partn_guid = ls_crm_cust-partn_guid.
*            ls_unblk_cust_partners-id = ls_crm_cust-custome_no.
*            ls_unblk_cust_partners-id_type = '1'.
*            APPEND ls_crmkunnr TO lt_crmkunnr.
*            APPEND ls_unblk_cust_partners TO lt_unblk_cust_partners.
*          ENDLOOP.
*        ENDIF.
*---- Fetching vendor contact persons.
        SELECT client contact_no org_guid person_gui FROM crmparnr INTO TABLE lt_crm_cont
                                                     FOR ALL ENTRIES IN lt_crm_vend
                                                     WHERE org_guid = lt_crm_vend-partn_guid.
        IF sy-subrc = 0.
          LOOP AT lt_crm_cont INTO ls_crm_cont.
            ls_crmparnr-contact_no = ls_crm_cont-contact_no.
            ls_crmparnr-org_guid = ls_crm_cont-org_guid.
            ls_crmparnr-person_gui = ls_crm_cont-person_gui.
            ls_partner_guid-partner_guid = ls_crm_cont-person_gui.
            APPEND ls_crmparnr TO lt_crmparnr.
            APPEND ls_partner_guid TO lt_partners_guid.
          ENDLOOP.
        ENDIF.
*---- Fetching business partners related to vendors
*        SELECT partner partner_guid FROM but000 INTO TABLE lt_partner_guid
*                                    FOR ALL ENTRIES IN lt_partner_guid_all
*                                    WHERE partner_guid = lt_partner_guid_all-partner_guid.
        IF lt_partners_guid IS NOT INITIAL.
*--- Moving only business partners without GUID
*          lt_partner = lt_partner_guid.

*          CLEAR: lv_relevant.
****&---- Checking EOP check done for BP to CUSTOMER or not.
*          CALL METHOD crm_if_loops_ctrl=>check_steps
*            EXPORTING
*              iv_source_object = 'BP'
*              iv_target_object = 'CUSTOMER'
*              iv_guid          = lv_guid
*            IMPORTING
*              ev_relevant      = lv_relevant
**             es_error         =
*            .
*          IF lt_unblk_cust_partners IS NOT INITIAL AND lv_relevant = 'X'.
**--- Fetching customer EOP check result.
*            CALL FUNCTION 'CVP_PROCESS_UNBLOCK'
*              EXPORTING
*                iv_test_mode                = gv_test_mode   " Test mode
*                iv_prot_output              = gv_prot_output   " EoP Check: Output of Object Logs
*                iv_detail_log               = gv_detail_log   " EoP Check: Detail Log
*                it_unblock_partners         = lt_unblk_cust_partners   " Master data IDs for blocking
*              IMPORTING
*                et_unblock_partners_results = lt_unblk_cust_partn_results    " SORT information after EOP check
*                et_messages                 = lt_messages.    " Result Log Messages after EOP check
*            .
*            LOOP AT lt_unblk_cust_partn_results INTO ls_unblk_cust_partn_results.
*              READ TABLE lt_crmkunnr INTO ls_crmkunnr WITH KEY custome_no = ls_unblk_cust_partn_results-id.
*              IF sy-subrc = 0.
*                READ TABLE lt_crmlifnr INTO ls_crmlifnr WITH KEY partn_guid = ls_crmkunnr-partn_guid.
*                IF sy-subrc = 0.
*                  READ TABLE it_partners INTO ls_partners WITH KEY id = ls_crmlifnr-vendor_no.
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
*              READ TABLE lt_crmkunnr INTO ls_crmkunnr WITH KEY custome_no = <fs_messages>-id.
*              IF sy-subrc = 0.
*                READ TABLE lt_crmlifnr INTO ls_crmlifnr WITH KEY partn_guid = ls_crmkunnr-partn_guid.
*                IF sy-subrc = 0.
*                  READ TABLE it_partners INTO ls_partners WITH KEY id = ls_crmlifnr-vendor_no.
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
*&---- Getting RFC information
          CALL FUNCTION 'BUPA_EOP_REGSYS'
            EXPORTING
              IV_REPL_TYPE       = 'CV->BP'
            TABLES
              et_eopsys = lt_regsys.


**** Call FM in all remote system
          LOOP AT lt_regsys INTO ls_regsys WHERE rfcdes IS NOT INITIAL.
**** Check whether FM exist in remot system or not.
            CALL FUNCTION 'FUNCTION_EXISTS' DESTINATION ls_regsys-rfcdes
              EXPORTING
                funcname           = lc_fm     " Name of Function Module
              EXCEPTIONS
                function_not_exist = 1
                OTHERS             = 2.

            IF sy-subrc = 0.
*-----Getting 'SORT' result for business partners.
              CALL FUNCTION lc_fm DESTINATION ls_regsys-rfcdes
                EXPORTING
*                 i_partner         = lt_partner
                  i_guid            = lv_guid
                  i_partner_guid    = lt_partners_guid
                IMPORTING
                  e_partner_guid    = lt_partner_guid
                  e_partner_unblock = lt_unblk_partn_results
                  e_cvi_messages    = lt_cvi_messages.


              SORT lt_unblk_partn_results ASCENDING BY partner.
              SORT lt_cvi_messages ASCENDING BY partnerid.
*&---- Updating unblock status for the vendors which are linked to Business partners
              LOOP AT lt_unblk_partn_results INTO ls_unblk_partn_results.
                READ TABLE lt_crmlifnr INTO ls_crmlifnr WITH KEY partn_guid = ls_unblk_partn_results-partner_guid.
                IF sy-subrc = 0.
                  READ TABLE it_partners INTO ls_partners WITH KEY id = ls_crmlifnr-vendor_no.
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
                  READ TABLE lt_crmparnr INTO ls_crmparnr WITH KEY person_gui = ls_unblk_partn_results-partner_guid.
                  IF sy-subrc = 0.
                    READ TABLE lt_crmlifnr INTO ls_crmlifnr WITH KEY partn_guid = ls_crmparnr-org_guid.
                    IF sy-subrc = 0.
                      READ TABLE it_partners INTO ls_partners WITH KEY id = ls_crmlifnr-vendor_no.
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
          ENDLOOP.
        ENDIF.
      ELSE.
*&---- Updating unblock status for the vendors which are not linked to Business partners
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD cvp_if_appl_eop_check~partners_purcmpl_export.

    DATA: lt_crmlifnr             TYPE TABLE OF crmlifnr,
          lt_crmparnr             TYPE TABLE OF crmparnr,
          ls_crmlifnr             LIKE LINE OF lt_crmlifnr,
          ls_crmparnr             LIKE LINE OF lt_crmparnr,
          lt_partner_guid         TYPE bup_partner_guid_t,
          ls_partner_guid         LIKE LINE OF lt_partner_guid,
          lt_partner_guid_all     TYPE bup_partnerguid_t,
          ls_partner_guid_all     TYPE bup_partnerguid_s,
          lt_partner              TYPE bu_partner_t,
          lt_regsys               TYPE TABLE OF butregsys_remote,
          ls_regsys               LIKE LINE OF lt_regsys,
          lt_bubutsort_maint_guid TYPE bubutsort_maint_guid_t,
          ls_bubutsort_maint_guid TYPE bubutsort_maint_guid.

    DATA: lt_messages TYPE cvp_tt_eop_check_messages,
          ls_messages TYPE cvp_s_eop_check_messages,

          lt_purexp_temp TYPE TABLE OF CVP_S_EOP_PARTNER_PURCMPL_EXP,
          ls_purexp_temp TYPE CVP_S_EOP_PARTNER_PURCMPL_EXP.


    FIELD-SYMBOLS: <fs_pur_cmplt_partners_final> LIKE LINE OF gt_pur_cmplt_partners_final,
                   <fs_partnerguid>              LIKE LINE OF lt_partner_guid.

*   Only if the CRM system is connected to this ECC system, then continue further processing in the class!
    CHECK gv_crm_connected IS NOT INITIAL.

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
*--- Fetching Business partners linked to vendors
      SELECT * FROM crmlifnr INTO TABLE lt_crmlifnr
                                  FOR ALL ENTRIES IN lt_purexp_temp"it_eop_partner_purcmpl_exp
                                  WHERE vendor_no = lt_purexp_temp-id."it_eop_partner_purcmpl_exp-id.
      IF sy-subrc = 0.
        LOOP AT lt_crmlifnr INTO ls_crmlifnr.
          ls_partner_guid_all-partner_guid = ls_crmlifnr-partn_guid.
          APPEND ls_partner_guid_all TO lt_partner_guid_all.
        ENDLOOP.
*---- Fetching vendor contact persons.
        SELECT * FROM crmparnr INTO TABLE lt_crmparnr
                                    FOR ALL ENTRIES IN lt_crmlifnr
                                    WHERE org_guid = lt_crmlifnr-partn_guid.
        IF sy-subrc = 0.
          LOOP AT lt_crmparnr INTO ls_crmparnr.
            ls_partner_guid_all-partner_guid = ls_crmparnr-person_gui.
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
          CLEAR: ls_partner_guid_all,
          lt_partner_guid_all.
          LOOP AT lt_partner_guid INTO ls_partner_guid.
            ls_partner_guid_all-partner_guid = ls_partner_guid-partner_guid.
            APPEND ls_partner_guid_all TO lt_partner_guid_all.
          ENDLOOP..
*&---- Get all the registered systems
          CALL FUNCTION 'BUPA_EOP_REGSYS'
            EXPORTING
              IV_REPL_TYPE       = 'CV->BP'
            TABLES
              et_eopsys = lt_regsys.

*&---- Update all the connected systems
          IF lt_regsys IS NOT INITIAL.
            CLEAR lt_bubutsort_maint_guid.
            LOOP AT gt_pur_cmplt_partners_final ASSIGNING <fs_pur_cmplt_partners_final>.
              READ TABLE lt_partner_guid WITH KEY partner = <fs_pur_cmplt_partners_final>-partner
                                        ASSIGNING <fs_partnerguid>.
              MOVE-CORRESPONDING <fs_pur_cmplt_partners_final> TO ls_bubutsort_maint_guid.
              ls_bubutsort_maint_guid-partner_guid = <fs_partnerguid>-partner_guid.
              APPEND ls_bubutsort_maint_guid TO lt_bubutsort_maint_guid.
              CLEAR ls_bubutsort_maint_guid.
            ENDLOOP.
*&--- Blocking the partners in cnnected systems.
            LOOP AT lt_regsys INTO ls_regsys WHERE rfcdes IS NOT INITIAL.

              CALL FUNCTION 'FUNCTION_EXISTS' DESTINATION ls_regsys-rfcdes
                EXPORTING
                  funcname           = 'CRM_IF_BUP_PURPOSE_SETTING'
                EXCEPTIONS
                  function_not_exist = 1
                  OTHERS             = 2.

              IF sy-subrc = 0.
                CALL FUNCTION 'CRM_IF_BUP_PURPOSE_SETTING' DESTINATION ls_regsys-rfcdes
                  EXPORTING
*                   it_partner      = lt_partner
                    it_partner_guid = lt_partner_guid_all
                    it_sort         = lt_bubutsort_maint_guid
*             IMPORTING
*                   E_CVI_MESSAGES  =
                  .
              ENDIF.
            ENDLOOP.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
  ENDMETHOD.


  METHOD cvp_if_appl_eop_check~partners_purcmpl_reset.

    DATA: lt_crmlifnr         TYPE TABLE OF crmlifnr,
          lt_crmparnr         TYPE TABLE OF crmparnr,
          ls_crmlifnr         LIKE LINE OF lt_crmlifnr,
          ls_crmparnr         LIKE LINE OF lt_crmparnr,
          lt_partner_guid     TYPE bup_partner_guid_t,
          ls_partner_guid     LIKE LINE OF lt_partner_guid,
          lt_partner_guid_all TYPE bup_partnerguid_t,
          ls_partner_guid_all TYPE bup_partnerguid_s,
          lt_partner          TYPE bu_partner_t,
          lt_regsys           TYPE TABLE OF butregsys_remote,
          ls_regsys           LIKE LINE OF lt_regsys.

*   Only if the CRM system is connected to this ECC system, then continue further processing in the class!
    CHECK gv_crm_connected IS NOT INITIAL.

*----Executing blocking module by passing business partners.
IF  gv_test_mode IS INITIAL.
    IF it_partners IS NOT INITIAL.
*--- Fetching Business partners linked to vendors
      SELECT * FROM crmlifnr INTO TABLE lt_crmlifnr
                                  FOR ALL ENTRIES IN it_partners
                                  WHERE vendor_no = it_partners-id.
      IF sy-subrc = 0.
        LOOP AT lt_crmlifnr INTO ls_crmlifnr.
          ls_partner_guid_all-partner_guid = ls_crmlifnr-partn_guid.
          APPEND ls_partner_guid_all TO lt_partner_guid_all.
        ENDLOOP.
*---- Fetching vendor contact persons.
        SELECT * FROM crmparnr INTO TABLE lt_crmparnr
                                    FOR ALL ENTRIES IN lt_crmlifnr
                                    WHERE org_guid = lt_crmlifnr-partn_guid.
        IF sy-subrc = 0.
          LOOP AT lt_crmparnr INTO ls_crmparnr.
            ls_partner_guid_all-partner_guid = ls_crmparnr-person_gui.
            APPEND ls_partner_guid_all TO lt_partner_guid_all.
          ENDLOOP.
        ENDIF.
*---- Fetching business partners related to vendors
        SELECT partner partner_guid FROM but000 INTO TABLE lt_partner_guid
                                    FOR ALL ENTRIES IN lt_partner_guid_all
                                    WHERE partner_guid = lt_partner_guid_all-partner_guid.
        IF sy-subrc = 0.
*&---- Get all the registered systems
          CALL FUNCTION 'BUPA_EOP_REGSYS'
            EXPORTING
              IV_REPL_TYPE       = 'CV->BP'
            TABLES
              et_eopsys = lt_regsys.

*&---- Update all the connected systems
          IF lt_regsys IS NOT INITIAL.
*&--- Blocking the partners in cnnected systems.
            LOOP AT lt_regsys INTO ls_regsys WHERE rfcdes IS NOT INITIAL.
              CALL FUNCTION 'FUNCTION_EXISTS' DESTINATION ls_regsys-rfcdes
                EXPORTING
                  funcname           = 'CRM_IF_BUP_PURPOSE_RESETTING'
                EXCEPTIONS
                  function_not_exist = 1
                  OTHERS             = 2.
              IF sy-subrc = 0.

                CALL FUNCTION 'CRM_IF_BUP_PURPOSE_RESETTING' DESTINATION ls_regsys-rfcdes
                  EXPORTING
                    it_partner_guid = lt_partner_guid
*                IMPORTING
*                   e_cvi_messages  =
                  .
              ENDIF.
            ENDLOOP.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
  ENDMETHOD.
ENDCLASS.
