class CVI_CMD_EOP_CHECK definition
  public
  create public .

public section.

  interfaces CVP_IF_CONST_DCPLD_I1 .
  interfaces CVP_IF_APPL_EOP_CHECK .
  interfaces CVP_IF_CONSTANTS .

  data GV_EOP_RUN_MODE type CVP_EOP_RUN_MODE .
  data GV_TEST_MODE type CVP_TEST_MODE .
  data GV_DETAIL_LOG type CVP_DETAIL_LOG .
  data GV_VALIDATE_NXTCHK_DATE type CVP_VALIDATE_NXTCHK_DATE .
  data GV_CHECK_PUR_COMPL_STATUS type CVP_CHECK_PUR_COMPL_STATUS .
  data GV_PROT_OUTPUT type CVP_PROT_OUTPUT .
  data GV_PUR_CMPLT_PARTNERS_FINAL type BU_BUTSORT_MAINT_T .
  constants TASK_FINAL_SET type CHAR9 value 'FINAL_SET'. "#EC NOTEXT
  constants LC_X type CHAR1 value 'X'. "#EC NOTEXT
  constants LC_DELETE type CHAR1 value 'D'. "#EC NOTEXT
  data GV_APPL type CVP_APPL_NAME .
protected section.
private section.
ENDCLASS.



CLASS CVI_CMD_EOP_CHECK IMPLEMENTATION.


  method CVP_IF_APPL_EOP_CHECK~CHECK_CPD_PARTNERS.
  endmethod.


  METHOD cvp_if_appl_eop_check~check_partners.

*&---- Structure declaration
    TYPES : BEGIN OF ty_partner,
              partner      TYPE bu_partner,
              partner_guid TYPE bu_partner_guid,
            END OF ty_partner,

            BEGIN OF ty_partner_guid,
              partner_guid TYPE bu_partner_guid,
            END OF ty_partner_guid,

            BEGIN OF ty_customer_cont,
              customer_cont TYPE parnr,
            END OF ty_customer_cont.


*&---- Variable declaration
    DATA: lr_cvi_ctrl_loop            TYPE REF TO cvi_ctrl_loop,
          lt_cvi_cust_link            TYPE TABLE OF cvi_cust_link,
          lt_partner                  TYPE TABLE OF ty_partner,
          lt_cust_ct_link             TYPE TABLE OF cvi_cust_ct_link,
          lt_cust_dct_link            TYPE TABLE OF cvi_cust_ct_link,
          lt_partner_guid             TYPE TABLE OF ty_partner_guid,
          lt_cvi_vend_link            TYPE cvis_vend_link_t, "cvi_vend_link,
          ls_partner_guid             TYPE ty_partner_guid,
          ls_cust_ct_link             TYPE cvi_cust_ct_link,
          lt_eop_check_partners       TYPE cvp_tt_eop_check_partners,
          lt_sort_result              TYPE cvp_tt_sort_result,
          ls_sort_result              TYPE cvp_s_sort_result,
*          ls_eop_check_partners       TYPE cvp_tt_eop_check_partners,
          ls_cvi_cust_link            TYPE cvi_cust_link,
          ls_cvi_vend_link            TYPE cvi_vend_link,
          ls_partner                  TYPE ty_partner,
          lv_intrim                   TYPE char1,
          lv_ovrall                   TYPE char1,
          lv_detlog                   TYPE char1,
          lv_applog                   TYPE char1,
          lv_tesrun                   TYPE char1,
          lt_bal_msg                  TYPE ty_t_bal_msg,
          ls_eop_check_partners       TYPE cvp_s_eop_check_partners,
          ls_sort_result_partners     TYPE cvp_s_sort_result,
          lt_pur_cmplt_partners_final TYPE bu_butsort_maint_t,
          ls_pur_cmplt_partners_final TYPE bubutsort_maint,
          lv_relevant                 TYPE boole_d,
          lv_relevant1                TYPE boole_d,
          lt_partners                 TYPE bu_partner_t,
          lt_message                  TYPE cvp_tt_eop_check_messages,
          ls_message                  TYPE cvp_s_eop_check_messages,
          lt_cvi_messages             TYPE buslocalmsg_t,
          ls_cvi_messages             TYPE buslocalmsg,
          ls_bapiret2                 TYPE bapiret2,
          lt_eop_check_partners_cpd   TYPE cvp_tt_eop_check_partners_cpd,
          lt_customer_cont            TYPE TABLE OF ty_customer_cont,
          ls_customer_cont            TYPE ty_customer_cont,
          lt_cust_to_bp_active        TYPE TABLE OF mdsc_ctrl_opt_a,
          lt_cust                     TYPE bupa_cust_tt,
          ls_cust                     TYPE bupa_cust,
          lt_cust_type1               TYPE CVP_TT_EOP_CHECK_PARTNERS.

    DATA: lv_own_logical_system       TYPE tbdls-logsys.

    DATA: badi_isu_obj_mapping TYPE REF TO badi_bp_isu_obj_mapping,
          oref                 TYPE REF TO cx_root.

*&---- To get the Sync between BP to Customer
    SELECT * FROM mdsc_ctrl_opt_a INTO TABLE lt_cust_to_bp_active WHERE sync_obj_source  = 'CUSTOMER'
                                                              AND sync_obj_target  = 'BP'
                                                              AND active_indicator = 'X'.

*&---- Checking EOP check done for CUSTOMER to BP or not.
    CALL METHOD cvi_ctrl_loop=>get_instance
      IMPORTING
        er_object = lr_cvi_ctrl_loop.

    CALL METHOD lr_cvi_ctrl_loop->check_steps
      EXPORTING
        iv_source_object = 'CUSTOMER'
        iv_target_object = 'BP'
      IMPORTING
        ev_relevant      = lv_relevant
*       es_error         =
      .

    IF lv_relevant = 'X'.
*&---- Initialize the mode of execution
      IF gv_eop_run_mode = '1'.
        lv_intrim = 'X'.
      ELSEIF gv_eop_run_mode = '2'.
        lv_ovrall = 'X'.
      ENDIF.

      IF gv_detail_log = '1'.
        lv_detlog = ' '.
      ELSEIF gv_detail_log = 'X'.
        lv_detlog = 'X '.
      ENDIF.

      IF gv_prot_output = ' '.
        lv_applog = ' '.
      ELSEIF gv_prot_output = '1'.
        lv_applog = 'X'.
      ELSEIF gv_prot_output = '2'.
        lv_applog = 'X'.
      ENDIF.

      LOOP AT it_eop_check_partners INTO ls_eop_check_partners.
        IF ls_eop_check_partners-ID_TYPE = 1 AND ls_eop_check_partners-bukrs IS INITIAL. "to block bp only if customer is blocked at general level
            APPEND ls_eop_check_partners to lt_cust_type1.
        ENDIF.
      ENDLOOP.

*&---- EOP check not done for BP to CUSTOMER
      IF lt_cust_to_bp_active IS NOT INITIAL.
        IF it_eop_check_partners IS  NOT INITIAL.

*&---- Getting Business Partner linked to Customer
         IF lt_cust_type1 IS NOT INITIAL.
          SELECT * FROM cvi_cust_link
            INTO TABLE lt_cvi_cust_link
            FOR ALL ENTRIES IN lt_cust_type1"it_eop_check_partners
            WHERE customer = lt_cust_type1-id."it_eop_check_partners-id.
          IF sy-subrc = 0.

            LOOP AT lt_cvi_cust_link INTO ls_cvi_cust_link.
              ls_partner_guid-partner_guid = ls_cvi_cust_link-partner_guid.
              APPEND ls_partner_guid TO lt_partner_guid.
              CLEAR ls_partner_guid.
            ENDLOOP.

*&---- Getting Business Partner linked to Contact Person of the Customer
            SELECT * FROM cvi_cust_ct_link
              INTO TABLE lt_cust_ct_link
              FOR ALL ENTRIES IN lt_cvi_cust_link
              WHERE partner_guid = lt_cvi_cust_link-partner_guid.
            IF sy-subrc = 0.
              LOOP AT lt_cust_ct_link INTO ls_cust_ct_link.
                ls_partner_guid-partner_guid = ls_cust_ct_link-person_guid.
                APPEND ls_partner_guid TO lt_partner_guid.
                CLEAR ls_partner_guid.
              ENDLOOP.
            ENDIF.
          ENDIF.

*&---- Conversion from Char to NUMC
*          LOOP AT it_eop_check_partners INTO ls_eop_check_partners.
          LOOP AT lt_cust_type1 INTO ls_eop_check_partners.
            CALL FUNCTION 'CHAR_NUMC_CONVERSION'
              EXPORTING
                input   = ls_eop_check_partners-id
              IMPORTING
                numcstr = ls_customer_cont-customer_cont.

            APPEND ls_customer_cont TO lt_customer_cont.
            CLEAR: ls_eop_check_partners, ls_customer_cont.
          ENDLOOP.

*&---- Getting Business Partner to Contact Person
          SELECT * FROM cvi_cust_ct_link
            INTO TABLE lt_cust_dct_link
            FOR ALL ENTRIES IN lt_customer_cont
            WHERE customer_cont = lt_customer_cont-customer_cont.
          IF sy-subrc = 0.
            LOOP AT lt_cust_dct_link INTO ls_cust_ct_link.
              ls_partner_guid-partner_guid = ls_cust_ct_link-person_guid.
              APPEND ls_partner_guid TO lt_partner_guid.
              CLEAR ls_partner_guid.
            ENDLOOP.
          ENDIF.

*&---- No BP releted to CUSTOMER found
          IF lt_cvi_cust_link IS INITIAL AND lt_cust_dct_link IS INITIAL.
*&--- Getting own logical system
            CALL FUNCTION 'OWN_LOGICAL_SYSTEM_GET'
              IMPORTING
                own_logical_system             = lv_own_logical_system
              EXCEPTIONS
                own_logical_system_not_defined = 1
                OTHERS                         = 2.
            IF sy-subrc <> 0.
* Implement suitable error handling here
            ENDIF.

*            LOOP AT it_eop_check_partners INTO ls_eop_check_partners.
             LOOP AT lt_cust_type1  INTO ls_eop_check_partners.
              ls_sort_result_partners-id = ls_eop_check_partners-id.
              ls_sort_result_partners-id_type = ls_eop_check_partners-id_type.
              ls_sort_result_partners-bukrs = ls_eop_check_partners-bukrs.
              ls_sort_result_partners-vkorg =  ls_eop_check_partners-vkorg.
              IF iv_appl IS NOT INITIAL.
                ls_sort_result_partners-appl_name = iv_appl.
              ELSE.
                ls_sort_result_partners-appl_name = 'CVI'.
              ENDIF.
              ls_sort_result_partners-business_system = lv_own_logical_system.
              ls_sort_result_partners-pur_cmpl_status = '1'.
              APPEND ls_sort_result_partners TO et_sort_result_partners.
              CLEAR ls_sort_result_partners.
              CLEAR ls_eop_check_partners.
            ENDLOOP.

            EXIT.
          ENDIF.

       IF lt_partner_guid[] IS NOT INITIAL.
*&---- Getting Business partner number with respect to BP GUID
          SELECT partner partner_guid FROM but000
            INTO TABLE lt_partner
            FOR ALL ENTRIES IN lt_partner_guid
            WHERE partner_guid = lt_partner_guid-partner_guid.
          IF sy-subrc = 0.
****IF lt_cvi_cust_link is NOT INITIAL.
*****&---- Finding corresponding Vendor related to the Business Partner of Customer
****          SELECT * FROM cvi_vend_link
****            INTO TABLE lt_cvi_vend_link
****            FOR ALL ENTRIES IN lt_cvi_cust_link
****            WHERE partner_guid = lt_cvi_cust_link-partner_guid.
****          IF  sy-subrc = 0.
********          LOOP AT lt_cvi_vend_link INTO ls_cvi_vend_link.
********            ls_eop_check_partners-id = ls_cvi_vend_link-vendor.
********            ls_eop_check_partners-id_type = '2'.
********
********            APPEND ls_eop_check_partners TO lt_eop_check_partners.
********            CLEAR: ls_cvi_vend_link, ls_eop_check_partners.
********          ENDLOOP.
*****&---- Checking EOP check done for BP to Vendor or not.
****            CALL METHOD lr_cvi_ctrl_loop->check_steps
****              EXPORTING
****                iv_source_object = 'BP'
****                iv_target_object = 'VENDOR'
****              IMPORTING
****                ev_relevant      = lv_relevant1.
****
****            IF lv_relevant1 = 'X'.
******** Partners checks before calling CVP_PREPARE_EOP_BLOCK
****              CALL FUNCTION 'CVP_PREPARE_EOP_CHECK'
****                EXPORTING
****                  it_vend_link             = lt_cvi_vend_link
****                IMPORTING
****                  et_vend_eop_partners     = lt_eop_check_partners
****                  et_vend_eop_partners_cpd = lt_eop_check_partners_cpd.
****
******** Calling EOP check for Vendor.
****              CALL FUNCTION 'CVP_PREPARE_EOP_BLOCK' DESTINATION 'NONE'
****                EXPORTING
****                  iv_eop_run_mode           = gv_eop_run_mode
****                  iv_test_mode              = gv_test_mode
****                  iv_validate_nxtchk_date   = gv_validate_nxtchk_date
****                  iv_check_pur_compl_status = gv_check_pur_compl_status
****                  iv_prot_output            = gv_prot_output
****                  iv_detail_log             = gv_detail_log
****                  it_eop_check_partners     = lt_eop_check_partners
****                  it_eop_check_partners_cpd = lt_eop_check_partners_cpd
****                IMPORTING
****                  et_sort_result_partners   = lt_sort_result
****                  et_messages               = lt_message
*****                 EV_APPLOG_NUMBER          =
****                .
****
****              LOOP AT lt_sort_result INTO ls_sort_result.
****
****                READ TABLE lt_cvi_vend_link
****                INTO ls_cvi_vend_link
****                WITH KEY vendor = ls_sort_result-id.
****                IF sy-subrc = 0.
****                  READ TABLE lt_cvi_cust_link
****                  INTO ls_cvi_cust_link
****                  WITH KEY partner_guid = ls_cvi_vend_link-partner_guid.
****                  IF sy-subrc = 0.
****                    ls_sort_result_partners-id                = ls_cvi_cust_link-customer.
****                    ls_sort_result_partners-id_type           = ls_sort_result-id_type.
****                    ls_sort_result_partners-bukrs             = ls_sort_result-bukrs.
****                    ls_sort_result_partners-vkorg             = ls_sort_result-vkorg.
****                    ls_sort_result_partners-business_system   = ls_sort_result-business_system.
****                    ls_sort_result_partners-appl_name         = ls_sort_result-appl_name.
****                    ls_sort_result_partners-appl_rule_variant = ls_sort_result-appl_rule_variant.
****                    ls_sort_result_partners-st_ret_date       = ls_sort_result-st_ret_date.
****                    ls_sort_result_partners-nextchkdt         = ls_sort_result-nextchkdt.
****                    ls_sort_result_partners-pur_cmpl_status   = ls_sort_result-pur_cmpl_status.
****                    APPEND ls_sort_result_partners TO et_sort_result_partners.
****                    CLEAR: ls_sort_result_partners,ls_cvi_vend_link, ls_sort_result, ls_cvi_cust_link.
****                  ENDIF.
****                ENDIF.
****              ENDLOOP.
****            ENDIF.
****          ENDIF.
****ENDIF.

*&---- Setting global varible for identification
*&---- of calling function  BUPA_PREPARE_EOP_BLOCK
*&---- from CVI.
            CALL FUNCTION 'BUPA_CVI_CTRL_FLAG_SET'.
            MOVE lt_partner TO lt_partners.
*&---- Blocking the business partner
            CALL FUNCTION 'BUPA_PREPARE_EOP_BLOCK'
              EXPORTING
                i_partnr                   = lt_partners
*               I_FILTER                   =
                i_intrim                   = lv_intrim
                i_ovrall                   = lv_ovrall
                i_chkdat                   = gv_validate_nxtchk_date
*               I_INTRES                   =
                i_applog                   = lv_applog
                i_detlog                   = lv_detlog
                i_tesrun                   = gv_test_mode
                I_CHKEOP                   = gv_check_pur_compl_status
*               I_BLOCKS                   =
              IMPORTING
                e_bal_msg                  = lt_bal_msg
                e_pur_cmplt_partners_final = lt_pur_cmplt_partners_final
                e_cvi_messages             = lt_cvi_messages.

            IF sy-subrc = 0.

              gv_pur_cmplt_partners_final = lt_pur_cmplt_partners_final.
**** Adding the Customer detail of the contact person
              LOOP AT lt_cust_dct_link INTO ls_cust_ct_link.
                ls_cvi_cust_link-customer = ls_cust_ct_link-customer_cont.
                ls_cvi_cust_link-partner_guid = ls_cust_ct_link-person_guid.
                APPEND ls_cvi_cust_link TO lt_cvi_cust_link.
                CLEAR: ls_cvi_cust_link.
              ENDLOOP.
*&---- Mapping SORT result to exporting Parameter.
              LOOP AT lt_pur_cmplt_partners_final INTO ls_pur_cmplt_partners_final.

*&---- Read GUID of respective BP
                READ TABLE lt_partner
                     INTO  ls_partner
                     WITH KEY partner = ls_pur_cmplt_partners_final-partner.
*&---- Reading customer with respect to GUID.
                READ TABLE lt_cvi_cust_link
                     INTO ls_cvi_cust_link
                     WITH KEY partner_guid = ls_partner-partner_guid.
                IF sy-subrc = 0.
*                  READ TABLE lt_cust_type1 "it_eop_check_partners
*                    INTO ls_eop_check_partners
*                    WITH KEY id = ls_cvi_cust_link-customer.
                  LOOP AT lt_cust_type1 INTO ls_eop_check_partners WHERE id = ls_cvi_cust_link-customer.
                    ls_sort_result_partners-id                = ls_eop_check_partners-id.
                    ls_sort_result_partners-id_type           = ls_eop_check_partners-id_type.
                    ls_sort_result_partners-bukrs             = ls_eop_check_partners-bukrs.
                    ls_sort_result_partners-vkorg             = ls_eop_check_partners-vkorg.
                    ls_sort_result_partners-business_system   = ls_pur_cmplt_partners_final-business_system.
                    ls_sort_result_partners-appl_name         = ls_pur_cmplt_partners_final-appl_name.
                    ls_sort_result_partners-appl_rule_variant = ls_pur_cmplt_partners_final-appl_rule_variant.
                    ls_sort_result_partners-st_ret_date       = ls_pur_cmplt_partners_final-st_ret_date.
                    ls_sort_result_partners-nextchkdt         = ls_pur_cmplt_partners_final-nextchkdt.
                    ls_sort_result_partners-pur_cmpl_status   = ls_pur_cmplt_partners_final-pur_cmpl_status.
                    APPEND ls_sort_result_partners TO et_sort_result_partners.
                  ENDLOOP.
                    CLEAR: ls_sort_result_partners, ls_eop_check_partners, ls_pur_cmplt_partners_final.
                    CLEAR: ls_partner, ls_cvi_cust_link.
                ELSE.
*&---- Read contact person GUID with respect to BP
                  READ TABLE lt_cust_ct_link
                    INTO ls_cust_ct_link
                    WITH KEY person_guid = ls_partner-partner_guid.
*&---- Read customer GUID with respect to contact person GUID
                  READ TABLE lt_cvi_cust_link
                  INTO ls_cvi_cust_link
                  WITH KEY partner_guid = ls_cust_ct_link-partner_guid.
*&--- Read importing data of the customer.
*                  READ TABLE lt_cust_type1 "it_eop_check_partners
*                    INTO ls_eop_check_partners
*                    WITH KEY id = ls_cvi_cust_link-customer.
                  LOOP AT lt_cust_type1 INTO ls_eop_check_partners WHERE id = ls_cvi_cust_link-customer.
                  ls_sort_result_partners-id                = ls_eop_check_partners-id.
                  ls_sort_result_partners-id_type           = ls_eop_check_partners-id_type.
                  ls_sort_result_partners-bukrs             = ls_eop_check_partners-bukrs.
                  ls_sort_result_partners-vkorg             = ls_eop_check_partners-vkorg.
                  ls_sort_result_partners-business_system   = ls_pur_cmplt_partners_final-business_system.
                  ls_sort_result_partners-appl_name         = ls_pur_cmplt_partners_final-appl_name.
                  ls_sort_result_partners-appl_rule_variant = ls_pur_cmplt_partners_final-appl_rule_variant.
                  ls_sort_result_partners-st_ret_date       = ls_pur_cmplt_partners_final-st_ret_date.
                  ls_sort_result_partners-nextchkdt         = ls_pur_cmplt_partners_final-nextchkdt.
                  ls_sort_result_partners-pur_cmpl_status   = ls_pur_cmplt_partners_final-pur_cmpl_status.
                  APPEND ls_sort_result_partners TO et_sort_result_partners.
                  ENDLOOP.
                  CLEAR: ls_sort_result_partners, ls_eop_check_partners, ls_pur_cmplt_partners_final.
                  CLEAR: ls_partner, ls_cvi_cust_link, ls_cust_ct_link.
                ENDIF.
              ENDLOOP.

*&---- Mapping message to output.
              LOOP AT lt_cvi_messages INTO ls_cvi_messages.
*&---- Read GUID of respective BP
                READ TABLE lt_partner
                     INTO  ls_partner
                     WITH KEY partner = ls_cvi_messages-partnerid.
*&---- Reading customer with respect to GUID.
                READ TABLE lt_cvi_cust_link
                     INTO ls_cvi_cust_link
                     WITH KEY partner_guid = ls_partner-partner_guid.
                IF sy-subrc = 0.
                  READ TABLE lt_cust_type1 "it_eop_check_partners
                    INTO ls_eop_check_partners
                    WITH KEY id = ls_cvi_cust_link-customer.
                  ls_message-appl_name = ls_cvi_messages-appl_name.
                  ls_message-appl_rule_variant = ls_cvi_messages-appl_rule_variant.
                  ls_message-bukrs = ls_eop_check_partners-bukrs.
                  ls_message-id = ls_eop_check_partners-id.
                  ls_message-id_type = ls_eop_check_partners-id_type.
                  ls_message-vkorg = ls_eop_check_partners-vkorg.
                  MOVE-CORRESPONDING  ls_cvi_messages TO ls_bapiret2.
                  APPEND ls_bapiret2 TO ls_message-messages.
                  APPEND ls_message TO lt_message.
                  CLEAR: ls_message, ls_eop_check_partners, ls_cvi_cust_link, ls_partner, ls_cvi_messages.
                ELSE.
*&---- Read contact person GUID with respect to BP
                  READ TABLE lt_cust_ct_link
                    INTO ls_cust_ct_link
                    WITH KEY person_guid = ls_partner-partner_guid.
*&---- Read customer GUID with respect to contact person GUID
                  READ TABLE lt_cvi_cust_link
                  INTO ls_cvi_cust_link
                  WITH KEY partner_guid = ls_cust_ct_link-partner_guid.
*&--- Read importing data of the customer.
                  READ TABLE lt_cust_type1 "it_eop_check_partners
                    INTO ls_eop_check_partners
                    WITH KEY id = ls_cvi_cust_link-customer.
                  ls_message-appl_name = ls_cvi_messages-appl_name.
                  ls_message-appl_rule_variant = ls_cvi_messages-appl_rule_variant.
                  ls_message-bukrs = ls_eop_check_partners-bukrs.
                  ls_message-id = ls_eop_check_partners-id.
                  ls_message-id_type = ls_eop_check_partners-id_type.
                  ls_message-vkorg = ls_eop_check_partners-vkorg.
                  MOVE-CORRESPONDING  ls_cvi_messages TO ls_bapiret2.
                  APPEND ls_bapiret2 TO ls_message-messages.
                  APPEND ls_message TO lt_message.
                  CLEAR: ls_message, ls_eop_check_partners, ls_cvi_cust_link, ls_partner, ls_cvi_messages,ls_cust_ct_link.
                ENDIF.
              ENDLOOP.
              APPEND LINES OF lt_message TO et_messages.
            ENDIF.
          ENDIF.
       ENDIF.

*&---- Few CUSTOMER for which No BP are there
*          LOOP AT it_eop_check_partners INTO ls_eop_check_partners.
          LOOP AT lt_cust_type1 INTO ls_eop_check_partners.
            READ TABLE lt_cvi_cust_link
                 INTO ls_cvi_cust_link
                 WITH KEY  customer = ls_eop_check_partners-id.
            IF sy-subrc <> 0.
*&--- Getting own logical system
              CALL FUNCTION 'OWN_LOGICAL_SYSTEM_GET'
                IMPORTING
                  own_logical_system             = lv_own_logical_system
                EXCEPTIONS
                  own_logical_system_not_defined = 1
                  OTHERS                         = 2.
              IF sy-subrc <> 0.
* Implement suitable error handling here
              ENDIF.

              ls_sort_result_partners-id      = ls_eop_check_partners-id.
              ls_sort_result_partners-id_type = ls_eop_check_partners-id_type.
              ls_sort_result_partners-bukrs   = ls_eop_check_partners-bukrs.
              ls_sort_result_partners-vkorg   = ls_eop_check_partners-vkorg.
              IF iv_appl IS NOT INITIAL.
                ls_sort_result_partners-appl_name = iv_appl.
              ELSE.
                ls_sort_result_partners-appl_name = 'CVI'.
              ENDIF.
              ls_sort_result_partners-business_system = lv_own_logical_system.
              ls_sort_result_partners-pur_cmpl_status = '1'.
              APPEND ls_sort_result_partners TO et_sort_result_partners.
              CLEAR ls_sort_result_partners.
              CLEAR ls_eop_check_partners.
            ENDIF.
          ENDLOOP.
        ENDIF.
       ENDIF.
      ELSE.
        TRY.
            GET BADI badi_isu_obj_mapping.
            CALL BADI badi_isu_obj_mapping->map_cust_to_partner
              EXPORTING
                it_eop_check_partners = lt_cust_type1 " it_eop_check_partners
              IMPORTING
                lt_partner            = lt_cust.

          CATCH cx_root INTO oref.
            EXIT.
        ENDTRY.

        LOOP AT lt_cust INTO ls_cust.
          ls_partner-partner = ls_cust-partner.
          ls_partner-partner_guid = ls_cust-partner_guid.

          APPEND ls_partner TO lt_partner.
          CLEAR: ls_partner, ls_cust.
        ENDLOOP.

*&---- Setting global varible for identification
*&---- of calling function  BUPA_PREPARE_EOP_BLOCK
*&---- from CVI.
        CALL FUNCTION 'BUPA_CVI_CTRL_FLAG_SET'.
        MOVE lt_partner TO lt_partners.
*&---- Blocking the business partner
        CALL FUNCTION 'BUPA_PREPARE_EOP_BLOCK'
          EXPORTING
            i_partnr                   = lt_partners
*           I_FILTER                   =
            i_intrim                   = lv_intrim
            i_ovrall                   = lv_ovrall
            i_chkdat                   = gv_validate_nxtchk_date
*           I_INTRES                   =
            i_applog                   = lv_applog
            i_detlog                   = lv_detlog
            i_tesrun                   = gv_test_mode
            I_CHKEOP                   = gv_check_pur_compl_status
*           I_BLOCKS                   =
          IMPORTING
            e_bal_msg                  = lt_bal_msg
            e_pur_cmplt_partners_final = lt_pur_cmplt_partners_final
            e_cvi_messages             = lt_cvi_messages.

        IF sy-subrc = 0.

          gv_pur_cmplt_partners_final = lt_pur_cmplt_partners_final.

*&---- Mapping SORT result to exporting Parameter.
          LOOP AT lt_pur_cmplt_partners_final INTO ls_pur_cmplt_partners_final.

*&---- Read GUID of respective BP
            READ TABLE lt_partner
                 INTO  ls_partner
                 WITH KEY partner = ls_pur_cmplt_partners_final-partner.
*&---- Reading customer with respect to GUID.
            READ TABLE lt_cust
                 INTO ls_cust
                 WITH KEY partner_guid = ls_partner-partner_guid.
            IF sy-subrc = 0.
*              READ TABLE lt_cust_type1 "it_eop_check_partners
*                INTO ls_eop_check_partners
*                WITH KEY id = ls_cust-kunnr.
              LOOP AT lt_cust_type1 INTO ls_eop_check_partners WHERE id = ls_cust-kunnr.
                ls_sort_result_partners-id                = ls_eop_check_partners-id.
                ls_sort_result_partners-id_type           = ls_eop_check_partners-id_type.
                ls_sort_result_partners-bukrs             = ls_eop_check_partners-bukrs.
                ls_sort_result_partners-vkorg             = ls_eop_check_partners-vkorg.
                ls_sort_result_partners-business_system   = ls_pur_cmplt_partners_final-business_system.
                ls_sort_result_partners-appl_name         = ls_pur_cmplt_partners_final-appl_name.
                ls_sort_result_partners-appl_rule_variant = ls_pur_cmplt_partners_final-appl_rule_variant.
                ls_sort_result_partners-st_ret_date       = ls_pur_cmplt_partners_final-st_ret_date.
                ls_sort_result_partners-nextchkdt         = ls_pur_cmplt_partners_final-nextchkdt.
                ls_sort_result_partners-pur_cmpl_status   = ls_pur_cmplt_partners_final-pur_cmpl_status.
                APPEND ls_sort_result_partners TO et_sort_result_partners.
              ENDLOOP.
                CLEAR: ls_sort_result_partners, ls_eop_check_partners, ls_pur_cmplt_partners_final.
                CLEAR: ls_partner, ls_cvi_cust_link.
            ENDIF.
          ENDLOOP.

*&---- Mapping message to output.
          LOOP AT lt_cvi_messages INTO ls_cvi_messages.
*&---- Read GUID of respective BP
            READ TABLE lt_partner
                 INTO  ls_partner
                 WITH KEY partner = ls_cvi_messages-partnerid.
*&---- Reading customer with respect to GUID.
            READ TABLE lt_cust
                 INTO ls_cust
                 WITH KEY partner_guid = ls_partner-partner_guid.
            IF sy-subrc = 0.
              READ TABLE lt_cust_type1 " it_eop_check_partners
                INTO ls_eop_check_partners
                WITH KEY id = ls_cust-kunnr.
              ls_message-appl_name = ls_cvi_messages-appl_name.
              ls_message-appl_rule_variant = ls_cvi_messages-appl_rule_variant.
              ls_message-bukrs = ls_eop_check_partners-bukrs.
              ls_message-id = ls_eop_check_partners-id.
              ls_message-id_type = ls_eop_check_partners-id_type.
              ls_message-vkorg = ls_eop_check_partners-vkorg.
              MOVE-CORRESPONDING  ls_cvi_messages TO ls_bapiret2.
              APPEND ls_bapiret2 TO ls_message-messages.
              APPEND ls_message TO lt_message.
              CLEAR: ls_message, ls_eop_check_partners, ls_cvi_cust_link, ls_partner, ls_cvi_messages.
            ENDIF.
          ENDLOOP.
          APPEND LINES OF lt_message TO et_messages.
        ENDIF.
*      ENDIF.

*&---- Few CUSTOMER for which No BP are there
*        LOOP AT it_eop_check_partners INTO ls_eop_check_partners.
        LOOP AT lt_cust_type1 INTO ls_eop_check_partners.
          READ TABLE lt_cust
               INTO ls_cust
               WITH KEY  kunnr = ls_eop_check_partners-id.
          IF sy-subrc <> 0.
*&--- Getting own logical system
            CALL FUNCTION 'OWN_LOGICAL_SYSTEM_GET'
              IMPORTING
                own_logical_system             = lv_own_logical_system
              EXCEPTIONS
                own_logical_system_not_defined = 1
                OTHERS                         = 2.
            IF sy-subrc <> 0.
* Implement suitable error handling here
            ENDIF.

            ls_sort_result_partners-id      = ls_eop_check_partners-id.
            ls_sort_result_partners-id_type = ls_eop_check_partners-id_type.
            ls_sort_result_partners-bukrs   = ls_eop_check_partners-bukrs.
            ls_sort_result_partners-vkorg   = ls_eop_check_partners-vkorg.
            IF iv_appl IS NOT INITIAL.
              ls_sort_result_partners-appl_name = iv_appl.
            ELSE.
              ls_sort_result_partners-appl_name = 'CVI'.
            ENDIF.
            ls_sort_result_partners-business_system = lv_own_logical_system.
            ls_sort_result_partners-pur_cmpl_status = '1'.
            APPEND ls_sort_result_partners TO et_sort_result_partners.
            CLEAR ls_sort_result_partners.
            CLEAR ls_eop_check_partners.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  method CVP_IF_APPL_EOP_CHECK~FINALIZE.
  endmethod.


  method CVP_IF_APPL_EOP_CHECK~FINALIZE_UNBLOCK.
  endmethod.


  METHOD cvp_if_appl_eop_check~initialize.
*&---- Global variable declarations
    gv_eop_run_mode = iv_eop_run_mode.
    gv_test_mode = iv_test_mode.
    gv_detail_log = iv_detail_log.
    gv_validate_nxtchk_date = iv_validate_nxtchk_date.
*    gv_check_pur_compl_status = iv_check_pur_compl_status.
    IF iv_check_pur_compl_status = 'X'.
      gv_check_pur_compl_status = ' '.
    ELSE.
     gv_check_pur_compl_status = 'X'.
    ENDIF.
    gv_prot_output = iv_prot_output.
  ENDMETHOD.


  method CVP_IF_APPL_EOP_CHECK~INITIALIZE_UNBLOCK.
*&---- Global variable declarations
    gv_appl         = iv_appl.
    gv_test_mode    = iv_test_mode.
    gv_detail_log   = iv_detail_log.
    gv_prot_output  = iv_prot_output.
  endmethod.


  METHOD cvp_if_appl_eop_check~partners_prep_purcmpl_reset.
*&---- Structure declaration
    TYPES : BEGIN OF ty_partner,
              partner      TYPE bu_partner,
              partner_guid TYPE bu_partner_guid,
            END OF ty_partner,

            BEGIN OF ty_partner_guid,
              partner_guid TYPE bu_partner_guid,
            END OF ty_partner_guid.


*&---- Variable declaration
    DATA: lr_cvi_ctrl_loop            TYPE REF TO cvi_ctrl_loop,
          lt_cvi_cust_link            TYPE TABLE OF cvi_cust_link,
          lt_cvi_vend_link            TYPE TABLE OF cvi_vend_link,
          lt_partner                  TYPE TABLE OF ty_partner,
          lt_cust_ct_link             TYPE TABLE OF cvi_cust_ct_link,
          lt_partner_guid             TYPE TABLE OF ty_partner_guid,
          ls_partner_guid             TYPE ty_partner_guid,
          ls_cust_ct_link             TYPE cvi_cust_ct_link,
          lt_unblk_check_vendor       TYPE cvp_tt_unblock_status,
          ls_unblk_check_vendor       TYPE cvp_s_unblock_status,
          lt_sort_result              TYPE cvp_tt_sort_result,
          ls_sort_result              TYPE cvp_s_sort_result,
          ls_eop_check_partners       TYPE cvp_s_eop_partner_purcmpl_exp,
          ls_cvi_cust_link            TYPE cvi_cust_link,
          ls_cvi_vend_link            TYPE cvi_vend_link,
          ls_partner                  TYPE ty_partner,
          lv_intrim                   TYPE char1,
          lv_ovrall                   TYPE char1,
          lv_detlog                   TYPE char1,
          lv_tesrun                   TYPE char1,
          lt_bal_msg                  TYPE ty_t_bal_msg,
          ls_bal_msg                  TYPE bal_s_msg,
          ls_unlock_check_vendor      TYPE cvp_s_unblock_status,
          ls_sort_result_partners     TYPE cvp_s_unblock_status,
          lt_unblock_partners_final   TYPE cvp_tt_unblock_status,
          ls_unblock_partners_final   TYPE cvp_s_unblock_status,
          lt_messages                 TYPE cvp_tt_eop_check_messages,
          ls_messages                 TYPE cvp_s_eop_check_messages,
          ls_pur_cmplt_partners_final TYPE bupartner_unblk_status_remote,
          lt_pur_cmplt_partners_final TYPE bupartner_unblk_statusremote_t,
          ls_unblk_partner            TYPE cvp_s_unblock_status,
          lv_relevant                 TYPE boole_d,
          lt_partners                 TYPE bu_partner_t,
          lt_message                  TYPE cvp_tt_eop_check_messages,
          ls_message                  TYPE cvp_s_eop_check_messages,
          lt_cvi_messages             TYPE  buslocalmsg_t,
          ls_cvi_messages             TYPE  buslocalmsg,
          ls_bapiret2                 TYPE  bapiret2.

*&---- Checking EOP check done for BP to CUSTOMER or not.
    CALL METHOD cvi_ctrl_loop=>get_instance
      IMPORTING
        er_object = lr_cvi_ctrl_loop.

    CALL METHOD lr_cvi_ctrl_loop->check_steps
      EXPORTING
        iv_source_object = 'CUSTOMER'
        iv_target_object = 'BP'
      IMPORTING
        ev_relevant      = lv_relevant
*       es_error         =
      .

*&---- EOP check not done for BP to CUSTOMER.
    IF lv_relevant = 'X' AND it_partners IS NOT INITIAL.

*&---- Getting Business Partner linked to Customer.
      SELECT *  FROM cvi_cust_link
                INTO TABLE lt_cvi_cust_link
                FOR ALL ENTRIES IN it_partners
                WHERE customer = it_partners-id.
      IF sy-subrc = 0.
        LOOP AT lt_cvi_cust_link INTO ls_cvi_cust_link.
          ls_partner_guid-partner_guid = ls_cvi_cust_link-partner_guid.
          APPEND ls_partner_guid TO lt_partner_guid.
          CLEAR ls_partner_guid.
        ENDLOOP.

*&---- Getting Business Partner link to contact person of the Customer.
        SELECT * FROM cvi_cust_ct_link
          INTO TABLE lt_cust_ct_link
          FOR ALL ENTRIES IN lt_cvi_cust_link
          WHERE partner_guid = lt_cvi_cust_link-partner_guid.

        IF sy-subrc = 0.
          LOOP AT lt_cust_ct_link INTO ls_cust_ct_link.
            ls_partner_guid-partner_guid = ls_cust_ct_link-person_guid.
            APPEND ls_partner_guid TO lt_partner_guid.
            CLEAR ls_partner_guid.
          ENDLOOP.
        ENDIF.

*&---- Getting Business partner with respect to BP GUID
        SELECT partner partner_guid FROM but000
          INTO TABLE lt_partner
          FOR ALL ENTRIES IN lt_partner_guid
          WHERE partner_guid = lt_partner_guid-partner_guid.
        IF sy-subrc = 0.

*****&---- Finding Vendor related to the Customer
****          SELECT * FROM cvi_vend_link
****            INTO TABLE lt_cvi_vend_link
****            FOR ALL ENTRIES IN lt_cvi_cust_link
****            WHERE partner_guid = lt_cvi_cust_link-partner_guid.
****          IF  sy-subrc = 0.
****            LOOP AT lt_cvi_vend_link INTO ls_cvi_vend_link.
****              ls_unblk_check_vendor-id = ls_cvi_vend_link-vendor.
****              ls_unblk_check_vendor-id_type = '2'.
****
****              APPEND ls_unblk_check_vendor TO lt_unblk_check_vendor.
****              CLEAR: ls_cvi_vend_link, ls_unblk_check_vendor.
****            ENDLOOP.
****
****            CALL FUNCTION 'CVP_PROCESS_UNBLOCK'
****              EXPORTING
****                iv_test_mode                = gv_test_mode
****                iv_prot_output              = gv_prot_output
****                iv_detail_log               = gv_detail_log
****                it_unblock_partners         = lt_unblk_check_vendor
****              IMPORTING
****                et_unblock_partners_results = lt_unblock_partners_final
****                et_messages                 = lt_messages.
****
****            IF sy-subrc = 0.
****              LOOP AT lt_unblock_partners_final INTO ls_unblock_partners_final.
*****
****                READ TABLE lt_cvi_vend_link
****                INTO ls_cvi_vend_link
****                WITH KEY vendor = ls_unblock_partners_final-id.
****                IF sy-subrc = 0.
****                  READ TABLE lt_cvi_cust_link
****                  INTO ls_cvi_cust_link
****                  WITH KEY partner_guid = ls_cvi_vend_link-partner_guid.
****                  IF sy-subrc = 0.
****                    ls_sort_result_partners-id                = ls_cvi_cust_link-customer.
****                    ls_sort_result_partners-id_type           = ls_unblock_partners_final-id_type.
****                    ls_sort_result_partners-bukrs             = ls_unblock_partners_final-bukrs.
****                    ls_sort_result_partners-vkorg             = ls_unblock_partners_final-vkorg.
****                    ls_sort_result_partners-status            = ls_unblock_partners_final-status.
****                    APPEND ls_sort_result_partners TO et_partners.
****                    CLEAR: ls_sort_result_partners, ls_cvi_vend_link, ls_cvi_cust_link,ls_unblock_partners_final.
****                  ENDIF.
****                ENDIF.
****              ENDLOOP.
****            ENDIF.
****          ENDIF.

          MOVE lt_partner TO lt_partners.
*&---- Getting the unblock request of related BP.
          CALL FUNCTION 'BUPA_PREPARE_EOP_UNBLOCK'
            EXPORTING
              i_partner         = lt_partners
            IMPORTING
              e_partner_unblock = lt_pur_cmplt_partners_final
              e_cvi_messages    = lt_cvi_messages.
          IF sy-subrc = 0.

*&---- Mapping SORT result to exporting Parameter.
            LOOP AT lt_pur_cmplt_partners_final INTO ls_pur_cmplt_partners_final.

*&---- Read GUID of respective BP
              READ TABLE lt_partner
                   INTO  ls_partner
                   WITH KEY partner = ls_pur_cmplt_partners_final-partner.
*&---- Reading customer with respect to GUID.
              READ TABLE lt_cvi_cust_link
                   INTO ls_cvi_cust_link
                   WITH KEY partner_guid = ls_partner-partner_guid.
              IF sy-subrc = 0.
                READ TABLE it_partners
                  INTO ls_eop_check_partners
                  WITH KEY id = ls_cvi_cust_link-customer.
                IF sy-subrc = 0.
                  ls_unblk_partner-id                = ls_eop_check_partners-id.
                  ls_unblk_partner-id_type           = ls_eop_check_partners-id_type.
                  ls_unblk_partner-bukrs             = ls_eop_check_partners-bukrs.
                  ls_unblk_partner-vkorg             = ls_eop_check_partners-vkorg.
                  IF ls_pur_cmplt_partners_final-unblk_status = 'X' .
                    ls_unblk_partner-status = 'A'.
                  ELSE.
                    ls_unblk_partner-status = 'R'.
                  ENDIF.
                  APPEND ls_unblk_partner TO et_partners.
                  CLEAR ls_sort_result_partners.
                  CLEAR ls_eop_check_partners.
                  CLEAR ls_pur_cmplt_partners_final.
                  CLEAR: ls_partner, ls_cust_ct_link,ls_cvi_cust_link.
                ENDIF.
              ELSE.
*&---- Read contact person GUID with respect to BP
                READ TABLE lt_cust_ct_link
                  INTO ls_cust_ct_link
                  WITH KEY person_guid = ls_partner-partner_guid.
*&---- Read customer GUID with respect to contact person GUID
                READ TABLE lt_cvi_cust_link
                INTO ls_cvi_cust_link
                WITH KEY partner_guid = ls_cust_ct_link-partner_guid.
*&--- Read importing data of the customer.
                READ TABLE it_partners
                   INTO ls_eop_check_partners
                   WITH KEY id = ls_cvi_cust_link-customer.
                IF sy-subrc = 0.
                  ls_unblk_partner-id                = ls_eop_check_partners-id.
                  ls_unblk_partner-id_type           = ls_eop_check_partners-id_type.
                  ls_unblk_partner-bukrs             = ls_eop_check_partners-bukrs.
                  ls_unblk_partner-vkorg             = ls_eop_check_partners-vkorg.
                  IF ls_pur_cmplt_partners_final-unblk_status = 'X' .
                    ls_unblk_partner-status = 'A'.
                  ELSE.
                    ls_unblk_partner-status = 'R'.
                  ENDIF.
                  APPEND ls_unblk_partner TO et_partners.
                  CLEAR: ls_sort_result_partners, ls_eop_check_partners,ls_pur_cmplt_partners_final.
                  CLEAR: ls_partner, ls_cust_ct_link,ls_cvi_cust_link.
                ENDIF.
              ENDIF.
            ENDLOOP.

*&---- Mapping message to output.
            LOOP AT lt_cvi_messages INTO ls_cvi_messages.
*&---- Read GUID of respective BP
              READ TABLE lt_partner
                   INTO  ls_partner
                   WITH KEY partner = ls_cvi_messages-partnerid.
*&---- Reading customer with respect to GUID.
              READ TABLE lt_cvi_cust_link
                   INTO ls_cvi_cust_link
                   WITH KEY partner_guid = ls_partner-partner_guid.
              IF sy-subrc = 0.
                READ TABLE it_partners
                  INTO ls_eop_check_partners
                  WITH KEY id = ls_cvi_cust_link-customer.
                ls_message-appl_name = ls_cvi_messages-appl_name.
                ls_message-appl_rule_variant = ls_cvi_messages-appl_rule_variant.
                ls_message-bukrs = ls_eop_check_partners-bukrs.
                ls_message-id = ls_eop_check_partners-id.
                ls_message-id_type = ls_eop_check_partners-id_type.
                ls_message-vkorg = ls_eop_check_partners-vkorg.
                MOVE-CORRESPONDING  ls_cvi_messages TO ls_bapiret2.
                APPEND ls_bapiret2 TO ls_message-messages.
                APPEND ls_message TO lt_message.
                CLEAR: ls_partner, ls_cvi_cust_link,ls_eop_check_partners, ls_message, ls_cvi_messages.
              ELSE.
*&---- Read contact person GUID with respect to BP
                READ TABLE lt_cust_ct_link
                  INTO ls_cust_ct_link
                  WITH KEY person_guid = ls_partner-partner_guid.
*&---- Read customer GUID with respect to contact person GUID
                READ TABLE lt_cvi_cust_link
                INTO ls_cvi_cust_link
                WITH KEY partner_guid = ls_cust_ct_link-partner_guid.
*&--- Read importing data of the customer.
                READ TABLE it_partners
                  INTO ls_eop_check_partners
                  WITH KEY id = ls_cvi_cust_link-customer.
                ls_message-appl_name = ls_cvi_messages-appl_name.
                ls_message-appl_rule_variant = ls_cvi_messages-appl_rule_variant.
                ls_message-bukrs = ls_eop_check_partners-bukrs.
                ls_message-id = ls_eop_check_partners-id.
                ls_message-id_type = ls_eop_check_partners-id_type.
                ls_message-vkorg = ls_eop_check_partners-vkorg.
                MOVE-CORRESPONDING  ls_cvi_messages TO ls_bapiret2.
                APPEND ls_bapiret2 TO ls_message-messages.
                APPEND ls_message TO lt_message.
                CLEAR: ls_partner, ls_cvi_cust_link,ls_eop_check_partners, ls_message, ls_cvi_messages, ls_cust_ct_link.
              ENDIF.
            ENDLOOP.
            APPEND LINES OF lt_messages TO et_messages.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD cvp_if_appl_eop_check~partners_purcmpl_export.
*&---- Structure declaration
    TYPES : BEGIN OF ty_partner,
              partner      TYPE bu_partner,
              partner_guid TYPE bu_partner_guid,
            END OF ty_partner,

            BEGIN OF ty_partner_guid,
              partner_guid TYPE bu_partner_guid,
            END OF ty_partner_guid.

*&---- Variable declaration
    DATA: lt_cvi_cust_link        TYPE TABLE OF cvi_cust_link,
          lt_cust_ct_link         TYPE TABLE OF cvi_cust_ct_link,
          lt_partner_guid         TYPE TABLE OF ty_partner_guid,
          lt_partner              TYPE TABLE OF ty_partner,
          lt_bubutsort_maint_guid TYPE bubutsort_maint_guid_t,
          ls_bubutsort_maint_guid TYPE bubutsort_maint_guid,
          ls_partner              TYPE ty_partner,
          ls_cust_ct_link         TYPE cvi_cust_ct_link,
          ls_cvi_cust_link        TYPE cvi_cust_link,
          ls_partner_guid         TYPE ty_partner_guid,
          lv_proxyclass           TYPE srt_wsp_dt_obj_name,
          lt_regsys               TYPE TABLE OF butregsys_remote,
          ls_eop_check_partners   TYPE cvp_s_eop_check_partners,
          lo_sys                  TYPE REF TO cx_ai_system_fault,
          lwa_protocol            TYPE REF TO if_wsprotocol_async_messaging,
          ltp_xiqueue             TYPE prx_scnt VALUE '',
          lt_business_partner_compl_req  TYPE BUPA_PURPOSE_COMPLETE_INPUT,
         lt_business_partner_compl_res TYPE BUPA_PURPOSE_COMPLETE_OUTPUT,
         ls_bp_partner_compl_msg TYPE LINE OF BUSLOCALMSG_TAB,
         ls_messages_compl          TYPE LINE OF BUSLOCALMSG_T,
         lit_business_partner_compl_req TYPE BUBUTSORT_MAINT_GUID_TAB,
         ls_business_partner_compl_req  TYPE LINE OF BUBUTSORT_MAINT_GUID_TAB,
          lwa_interim             TYPE LINE OF business_partner_eopinteri_tab,
          lit_interim             TYPE business_partner_eopinteri_tab,
          it_interim              TYPE ababusiness_partner_eopinterim,
          lo_iproxy               TYPE REF TO co_ababusiness_partner_eopinte,
          lwa_remote              TYPE LINE OF business_partner_eopremote_tab,
          lit_remote              TYPE business_partner_eopremote_tab,
          it_remote               TYPE ababusiness_partner_eopremote,
          lo_remproxy             TYPE REF TO co_ababusiness_partner_eopremo,
          lv_query                TYPE REF TO if_srt_public_query_handler,
          lt_log_port             TYPE srt_lp_names,
          ls_log_port             LIKE LINE OF lt_log_port,
          it_reminfo              TYPE ababusiness_partner_response_e,
          wa_reminfo1             TYPE LINE OF business_partner_response_tab1,
          wa_reminfo2             TYPE LINE OF business_partner_response__tab,
          ls_messages_remote      TYPE LINE OF busremotemsg_t,
          lwa_output              TYPE LINE OF business_partner_eopcompl__tab,
          lit_output              TYPE business_partner_eopcompl__tab,
          it_output               TYPE ababusiness_partner_eopcompl,
          lo_proxy                TYPE REF TO co_ababusiness_partner_eopcomp,
          lwa_reset               TYPE LINE OF business_partner_eopreset__tab,
          lit_reset               TYPE business_partner_eopreset__tab,
          it_reset                TYPE ababusiness_partner_eopreset,
          lo_rproxy               TYPE REF TO co_ababusiness_partner_eoprese,
          lt_partners             TYPE bu_partner_t,
          lt_cust_type1           TYPE CVP_TT_EOP_CHECK_PARTNERS,
          lt_cust_to_bp_active    TYPE TABLE OF mdsc_ctrl_opt_a,
          lv_relevant             TYPE boole_d,
          lt_cust                 TYPE bupa_cust_tt,
          ls_cust                 TYPE bupa_cust,
          ls_pur_cmplt_partners     TYPE LINE OF bu_butsort_t,
          lt_pur_cmplt_partners     TYPE bu_butsort_t,
          lt_pur_cmplt_partners_final TYPE BU_BUTSORT_MAINT_T,
          ls_pur_cmplt_partners_final LIKE LINE OF  lt_pur_cmplt_partners_final,
          lv_check_only_external_data  TYPE boole-boole,
          lc_final         TYPE char1 VALUE 'F',
          lv_timestamp                 TYPE timestamp,
          lt_return                    TYPE bus_bapiret2_t,
          lr_cvi_ctrl_loop            TYPE REF TO cvi_ctrl_loop,

          lt_purexp_temp              TYPE TABLE OF CVP_S_EOP_PARTNER_PURCMPL_EXP,
          ls_purexp_temp              TYPE CVP_S_EOP_PARTNER_PURCMPL_EXP,
          lv_rbsuccess                TYPE boole-boole,
          lv_rfcdes                   TYPE bu_rfcdest,
          lt_regsys_temp              TYPE STANDARD TABLE OF butregsys_remote,
          lt_resetbp                  TYPE bup_partner_guid_t,
          ls_resetbp                  TYPE LINE OF bup_partner_guid_t,
          lo_root                     TYPE REF TO cx_root,
          lc_error                    TYPE char1 VALUE 'E',
          lc_msgid                    TYPE char4 VALUE 'R111',
          lt_messages                 TYPE buslocalmsg_t,
          ls_messages                 TYPE BUSLOCALMSG,
          lt_messages1                TYPE bapiret2_t,
          ls_messages1                TYPE bapiret2,
          es_messages                 TYPE CVP_S_EOP_CHECK_MESSAGES,
          ls_bapiret2                  TYPE bapiret2.



  DATA: badi_isu_obj_mapping TYPE REF TO badi_bp_isu_obj_mapping,
         badi_purpose_export         TYPE REF TO bupa_purpose_export,
          oref                 TYPE REF TO cx_root.


*&---- Field symbol declaration
    FIELD-SYMBOLS:
      <fs_pur_cmplt_partners_final> LIKE LINE OF gv_pur_cmplt_partners_final,
      <fs_partnerguid>              LIKE LINE OF lt_partner,
      <fs_regsys>                   LIKE LINE OF lt_regsys,
      <fs_partners>                 LIKE LINE OF lt_partners.


    LOOP AT it_eop_partner_purcmpl_exp INTO ls_purexp_temp.
     IF ls_purexp_temp-BUKRS IS INITIAL AND
        ls_purexp_temp-VKORG IS INITIAL AND
        ls_purexp_temp-ID_TYPE = '1'.
        append ls_purexp_temp to lt_purexp_temp.
     ENDIF.
    ENDLOOP.

IF gv_test_mode IS INITIAL.
*    IF it_eop_partner_purcmpl_exp IS NOT INITIAL.
    IF lt_purexp_temp IS NOT INITIAL.

*&---- Checking blocking is  done for CUSTOMER to BP or not.
    CALL METHOD cvi_ctrl_loop=>get_instance
      IMPORTING
        er_object = lr_cvi_ctrl_loop.

    CALL METHOD lr_cvi_ctrl_loop->check_steps
      EXPORTING
        iv_source_object = 'CUSTOMER'
        iv_target_object = 'BP'
      IMPORTING
        ev_relevant      = lv_relevant
*       es_error         =
      .

    IF lv_relevant = 'X'.

*&---- To get the Sync between BP to Customer
    SELECT * FROM mdsc_ctrl_opt_a INTO TABLE lt_cust_to_bp_active WHERE sync_obj_source  = 'CUSTOMER'
                                                              AND sync_obj_target  = 'BP'
                                                              AND active_indicator = 'X'.


    IF lt_cust_to_bp_active IS NOT INITIAL.
*&---- Getting linked Business Partner
      SELECT * FROM cvi_cust_link
        INTO TABLE lt_cvi_cust_link
        FOR ALL ENTRIES IN lt_purexp_temp"it_eop_partner_purcmpl_exp
        WHERE customer = lt_purexp_temp-id."it_eop_partner_purcmpl_exp-id.
      IF sy-subrc = 0.

        SELECT * FROM cvi_cust_ct_link
          INTO TABLE lt_cust_ct_link
          FOR ALL ENTRIES IN lt_cvi_cust_link
          WHERE partner_guid = lt_cvi_cust_link-partner_guid.
        IF sy-subrc = 0.
          LOOP AT lt_cust_ct_link INTO ls_cust_ct_link.
            ls_partner_guid-partner_guid = ls_cust_ct_link-person_guid.
            APPEND ls_partner_guid TO lt_partner_guid.
            CLEAR ls_partner_guid.
          ENDLOOP.
        ENDIF.

        LOOP AT lt_cvi_cust_link INTO ls_cvi_cust_link.
          ls_partner_guid-partner_guid = ls_cvi_cust_link-partner_guid.
          APPEND ls_partner_guid TO lt_partner_guid.
          CLEAR ls_partner_guid.
        ENDLOOP.
*&---- Getting Linked Business partner number
        SELECT partner partner_guid FROM but000
          INTO TABLE lt_partner
          FOR ALL ENTRIES IN lt_partner_guid
          WHERE partner_guid = lt_partner_guid-partner_guid.
        IF sy-subrc = 0.

*&---- Get all the registered systems
          CLEAR lt_regsys.
          CALL FUNCTION 'BUPA_EOP_REGSYS'
            EXPORTING
              IV_REPL_TYPE       = 'CV->BP'
            TABLES
              et_eopsys = lt_regsys.

*&---- Set the XPCPT and XDELE to 'X'
          MOVE lt_partner TO lt_partners.
          CALL FUNCTION 'BUPA_XPCPT_SET'
            EXPORTING
              it_partners = lt_partners
              status      = lc_x.


        CLEAR lt_pur_cmplt_partners_final.

           lt_pur_cmplt_partners_final = gv_pur_cmplt_partners_final.

             CLEAR ls_pur_cmplt_partners_final.
              ls_pur_cmplt_partners_final-status = 'F'.

       LOOP AT lt_partners ASSIGNING <fs_partners>.

              MODIFY lt_pur_cmplt_partners_final FROM ls_pur_cmplt_partners_final
                                                 TRANSPORTING status
                                                 WHERE partner = <fs_partners>-partner.
       ENDLOOP.

*&---- Update SORT table with the values generated
          CALL FUNCTION 'BUPA_SORT_CHANGE_DETAIL'
            EXPORTING
              it_sort = lt_pur_cmplt_partners_final.

*&---- Update all the connected systems
          IF lt_regsys IS NOT INITIAL.
            CLEAR lt_bubutsort_maint_guid.
            LOOP AT gv_pur_cmplt_partners_final ASSIGNING <fs_pur_cmplt_partners_final>.
              READ TABLE lt_partner WITH KEY partner = <fs_pur_cmplt_partners_final>-partner
                                        ASSIGNING <fs_partnerguid>.
              IF sy-subrc = 0.
              MOVE-CORRESPONDING <fs_pur_cmplt_partners_final> TO ls_bubutsort_maint_guid.
              ls_bubutsort_maint_guid-partner_guid = <fs_partnerguid>-partner_guid.
              APPEND ls_bubutsort_maint_guid TO lt_bubutsort_maint_guid.
              CLEAR ls_bubutsort_maint_guid.
              ENDIF.
            ENDLOOP.

            LOOP AT lt_regsys ASSIGNING <fs_regsys>.
*              *************************starting new task
              CALL FUNCTION 'BUPA_PURPOSE_COMPLETE'" STARTING NEW TASK task_final_set
                DESTINATION <fs_regsys>-rfcdes
                EXPORTING
                  IT_SORT          = lt_bubutsort_maint_guid
               IMPORTING
                 EV_SUCCESS       = lv_rbsuccess
                 ET_MESSAGE       = lt_messages
                        .

              LOOP AT lt_messages into ls_messages.
                CLEAR : ls_messages1 ,es_messages, lt_messages1[].
                REFRESH: lt_messages1[].
                ls_messages1-type        = ls_messages-type.
                ls_messages1-id          = ls_messages-id.
                ls_messages1-number      = ls_messages-number.
                ls_messages1-message_v1  = ls_messages-message_v1.
                ls_messages1-message_v2  = ls_messages-message_v2.
                ls_messages1-message_v3  = ls_messages-message_v3.
                ls_messages1-message_v4  = ls_messages-message_v4.
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
*              CALL FUNCTION 'BUPA_PURPOSE_COMPLETE' STARTING NEW TASK task_final_set
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
          APPEND ls_messages_compl TO lt_messages.
        ENDLOOP.

           lv_rbsuccess = lt_business_partner_compl_res-ev_success.

             LOOP AT lt_messages into ls_messages.
                CLEAR : ls_messages1 ,es_messages, lt_messages1[].
                REFRESH: lt_messages1[].
                ls_messages1-type        = ls_messages-type.
                ls_messages1-id          = ls_messages-id.
                ls_messages1-number      = ls_messages-number.
                ls_messages1-message_v1  = ls_messages-message_v1.
                ls_messages1-message_v2  = ls_messages-message_v2.
                ls_messages1-message_v3  = ls_messages-message_v3.
                ls_messages1-message_v4  = ls_messages-message_v4.
                append ls_messages1 to lt_messages1 .

               es_messages-messages[] = lt_messages1[] .
               append es_messages to et_messages .
             ENDLOOP.
        ENDLOOP.
************************Proxy call**************************
        IF lv_rbsuccess = ' '.

          CALL FUNCTION 'BUPA_XPCPT_SET'
            EXPORTING
              it_partners = lt_partners
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
  ELSE.
     TRY.
*       LOOP AT it_eop_partner_purcmpl_exp INTO ls_eop_check_partners.
       LOOP AT lt_purexp_temp INTO ls_eop_check_partners.
          IF ls_eop_check_partners-ID_TYPE = 1.
            APPEND ls_eop_check_partners to lt_cust_type1.
          ENDIF.
        ENDLOOP.

            GET BADI badi_isu_obj_mapping.
            CALL BADI badi_isu_obj_mapping->map_cust_to_partner
              EXPORTING
                it_eop_check_partners = lt_cust_type1  " it_eop_check_partners
              IMPORTING
                lt_partner            = lt_cust.

          CATCH cx_root INTO oref.
            EXIT.
        ENDTRY.

        LOOP AT lt_cust INTO ls_cust.
          ls_partner-partner = ls_cust-partner.
          ls_partner-partner_guid = ls_cust-partner_guid.

          APPEND ls_partner TO lt_partner.
          CLEAR: ls_partner, ls_cust.
        ENDLOOP.

*&---- Get all the registered systems
          CLEAR lt_regsys.
          CALL FUNCTION 'BUPA_EOP_REGSYS'
            EXPORTING
              IV_REPL_TYPE       = 'CV->BP'
            TABLES
              et_eopsys = lt_regsys.

*&---- Set the XPCPT and XDELE to 'X'
          MOVE lt_partner TO lt_partners.
          CALL FUNCTION 'BUPA_XPCPT_SET'
            EXPORTING
              it_partners = lt_partners
              status      = lc_x.

      CLEAR lt_pur_cmplt_partners_final.

           lt_pur_cmplt_partners_final = gv_pur_cmplt_partners_final.

             CLEAR ls_pur_cmplt_partners_final.
              ls_pur_cmplt_partners_final-status = 'F'.

       LOOP AT lt_partners ASSIGNING <fs_partners>.

              MODIFY lt_pur_cmplt_partners_final FROM ls_pur_cmplt_partners_final
                                                 TRANSPORTING status
                                                 WHERE partner = <fs_partners>-partner.
       ENDLOOP.

*&---- Update SORT table with the values generated
          CALL FUNCTION 'BUPA_SORT_CHANGE_DETAIL'
            EXPORTING
              it_sort = lt_pur_cmplt_partners_final.

*&---- Update all the connected systems
          IF lt_regsys IS NOT INITIAL.
            CLEAR lt_bubutsort_maint_guid.
            LOOP AT gv_pur_cmplt_partners_final ASSIGNING <fs_pur_cmplt_partners_final>.
              READ TABLE lt_partner WITH KEY partner = <fs_pur_cmplt_partners_final>-partner
                                        ASSIGNING <fs_partnerguid>.
              IF sy-subrc = 0.
              MOVE-CORRESPONDING <fs_pur_cmplt_partners_final> TO ls_bubutsort_maint_guid.
              ls_bubutsort_maint_guid-partner_guid = <fs_partnerguid>-partner_guid.
              APPEND ls_bubutsort_maint_guid TO lt_bubutsort_maint_guid.
              CLEAR ls_bubutsort_maint_guid.
              ENDIF.
            ENDLOOP.

*            LOOP AT lt_regsys ASSIGNING <fs_regsys>.
*              CALL FUNCTION 'BUPA_PURPOSE_COMPLETE' STARTING NEW TASK task_final_set
*                DESTINATION <fs_regsys>-rfcdes
*                EXPORTING
*                  it_sort = lt_bubutsort_maint_guid.
*            ENDLOOP.
            LOOP AT lt_regsys ASSIGNING <fs_regsys>.
*              *************************starting new task
              CALL FUNCTION 'BUPA_PURPOSE_COMPLETE'" STARTING NEW TASK task_final_set
                DESTINATION <fs_regsys>-rfcdes
                EXPORTING
                  IT_SORT          = lt_bubutsort_maint_guid
               IMPORTING
                 EV_SUCCESS       = lv_rbsuccess
                 ET_MESSAGE       = lt_messages
                        .

              LOOP AT lt_messages into ls_messages.
                CLEAR : ls_messages1 ,es_messages, lt_messages1[].
                REFRESH: lt_messages1[].
                ls_messages1-type        = ls_messages-type.
                ls_messages1-id          = ls_messages-id.
                ls_messages1-number      = ls_messages-number.
                ls_messages1-message_v1  = ls_messages-message_v1.
                ls_messages1-message_v2  = ls_messages-message_v2.
                ls_messages1-message_v3  = ls_messages-message_v3.
                ls_messages1-message_v4  = ls_messages-message_v4.
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
*              CALL FUNCTION 'BUPA_PURPOSE_COMPLETE' STARTING NEW TASK task_final_set
*                DESTINATION <fs_regsys>-rfcdes
*                EXPORTING
*                  it_sort = lt_bubutsort_maint_guid.
            ENDLOOP.
        IF lv_rbsuccess = ' '.

          CALL FUNCTION 'BUPA_XPCPT_SET'
            EXPORTING
              it_partners = lt_partners
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

*&---- Variable declaration
    CONSTANTS:
      lc_space         TYPE char1  VALUE '',
      task_final_reset TYPE char11 VALUE 'FINAL_RESET'.

    DATA: lt_cvi_cust_link            TYPE TABLE OF cvi_cust_link,
          lt_cust_ct_link             TYPE TABLE OF cvi_cust_ct_link,
          ls_cust_ct_link             TYPE cvi_cust_ct_link,
          ls_cvi_cust_link            TYPE cvi_cust_link,
          lt_partner                  TYPE bu_partner_t,
          lt_pur_cmplt_partners_final TYPE bu_butsort_maint_t,
          ls_pur_cmplt_partners_final TYPE bubutsort_maint,
          lt_regsys                   TYPE TABLE OF butregsys_remote,
          lt_partner_guid             TYPE bup_partner_guid_t,
          lt_partner_guid_all         TYPE bup_partnerguid_t,
          ls_partner_guid_all         TYPE bup_partnerguid_s,
          ls_partner_guid             TYPE bupa_partner_guid,

          lt_partnerguid_reset        TYPE bup_partner_guid_t,
          ls_partnerguid_reset        TYPE LINE OF bup_partner_guid_t,
          lwa_reset                   TYPE LINE OF business_partner_eopreset__tab,
          lit_reset                   TYPE business_partner_eopreset__tab,
          it_reset                    TYPE ababusiness_partner_eopreset,
          lo_rproxy                   TYPE REF TO co_ababusiness_partner_eoprese,
          lt_log_port                 TYPE srt_lp_names,
          ls_log_port                 LIKE LINE OF lt_log_port,
          lv_proxyclass               TYPE srt_wsp_dt_obj_name,
          lo_sys                      TYPE REF TO cx_ai_system_fault,
          lv_query                    TYPE REF TO if_srt_public_query_handler.

    FIELD-SYMBOLS:              <fs_partner>     TYPE LINE OF bu_partner_t,
                                <fs_partnerguid> LIKE LINE OF lt_partner_guid,
                                <fs_regsys>      LIKE LINE OF lt_regsys.

IF  gv_test_mode IS INITIAL.
    IF it_partners IS NOT INITIAL.
*&---- Getting Business Partner linked to customer.
      SELECT * FROM cvi_cust_link
        INTO TABLE lt_cvi_cust_link
        FOR ALL ENTRIES IN it_partners
        WHERE customer = it_partners-id.
      IF sy-subrc = 0.
        LOOP AT lt_cvi_cust_link INTO ls_cvi_cust_link.
          ls_partner_guid_all-partner_guid = ls_cvi_cust_link-partner_guid.
          APPEND ls_partner_guid_all TO lt_partner_guid_all.
          CLEAR ls_partner_guid_all.
        ENDLOOP.
*&---- Getting Business partner link to contact person of customer.
        SELECT * FROM cvi_cust_ct_link
          INTO TABLE lt_cust_ct_link
          FOR ALL ENTRIES IN lt_cvi_cust_link
          WHERE partner_guid = lt_cvi_cust_link-partner_guid.
        IF sy-subrc = 0.
          LOOP AT lt_cust_ct_link INTO ls_cust_ct_link.
            ls_partner_guid_all-partner_guid = ls_cust_ct_link-person_guid.
            APPEND ls_partner_guid_all TO lt_partner_guid_all.
            CLEAR ls_partner_guid_all.
          ENDLOOP.
        ENDIF.


*&---- Getting Business partner with respect to BP GUID.
        SELECT partner partner_guid  FROM but000
          INTO TABLE lt_partner_guid
          FOR ALL ENTRIES IN lt_partner_guid_all
          WHERE partner_guid = lt_partner_guid_all-partner_guid.
        IF sy-subrc = 0.
          move lt_partner_guid to lt_partner.
*&---- Set the XPCPT and XDELE to <Space>
          CALL FUNCTION 'BUPA_XPCPT_SET'
            EXPORTING
              it_partners = lt_partner
              status      = lc_space.

          LOOP AT lt_partner ASSIGNING <fs_partner>.
            ls_pur_cmplt_partners_final-partner = <fs_partner>-partner.
            ls_pur_cmplt_partners_final-task = lc_delete.
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
              MOVE-CORRESPONDING <fs_partner> TO ls_partnerguid_reset.
              ls_partnerguid_reset-partner_guid = <fs_partnerguid>-partner_guid.
              APPEND ls_partnerguid_reset TO lt_partnerguid_reset.
              ENDIF.
            ENDLOOP.

            LOOP AT lt_regsys ASSIGNING <fs_regsys>.
              CALL FUNCTION 'BUPA_PURPOSE_RESET' STARTING NEW TASK task_final_reset DESTINATION <fs_regsys>-rfcdes
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
