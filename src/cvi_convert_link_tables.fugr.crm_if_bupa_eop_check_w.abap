FUNCTION crm_if_bupa_eop_check_w.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_EOP_RUN_MODE) TYPE  CVP_EOP_RUN_MODE
*"     VALUE(IV_TEST_MODE) TYPE  CVP_TEST_MODE
*"     VALUE(IV_VALIDATE_NXTCHK_DATE) TYPE  CVP_VALIDATE_NXTCHK_DATE
*"     VALUE(IV_CHECK_PUR_COMPL_STATUS) TYPE
*"        CVP_CHECK_PUR_COMPL_STATUS
*"     VALUE(IV_PROT_OUTPUT) TYPE  CVP_PROT_OUTPUT
*"     VALUE(IV_DETAIL_LOG) TYPE  CVP_DETAIL_LOG
*"     VALUE(IT_PARTNERS_GUID) TYPE  BUP_PARTNER_GUID_T
*"     VALUE(IT_PARTNERS_TYPE) TYPE  BUPA_PARTNER_TYPE_T
*"     VALUE(IV_APPL) TYPE  BU_APPL_NAME
*"     VALUE(IV_GUID) TYPE  GUID_16
*"  EXPORTING
*"     VALUE(ET_PUR_CMPLT_PARTNERS) TYPE  BU_SORT_LOCAL_T
*"     VALUE(ET_MESSAGES) TYPE  BUSLOCALMSG_T
*"----------------------------------------------------------------------
  TYPES:
    BEGIN OF tt_guid,
      lv_guid TYPE sychar32,
    END OF tt_guid.
  DATA: lt_kunnr                 TYPE crmkunnr_t,
        ls_kunnr                 TYPE crmkunnr,
        lt_cust_parnr            TYPE crmparnr_t,
        ls_cust_parnr            TYPE crmparnr,
        lt_lifnr                 TYPE crmlifnr_t,
        ls_lifnr                 TYPE crmlifnr,
        lt_vend_parnr            TYPE crmparnr_t,
        ls_vend_parnr            TYPE crmparnr,
        lt_eop_check_partners    TYPE cvp_tt_eop_check_partners,
        lt_eop_check_partners1   TYPE cvp_tt_eop_check_partners,
        ls_eop_check_partners    TYPE cvp_s_eop_check_partners,
        lt_cvp_tt_eop_check      TYPE cvp_tt_eop_check_partners_cpd,
        lt_sort_result_partners  TYPE cvp_tt_sort_result,
        lt_sort_result_partners1 TYPE cvp_tt_sort_result,
        ls_sort_result_partners  TYPE cvp_s_sort_result,
        lt_messages              TYPE cvp_tt_eop_check_messages,
        ls_messages              TYPE cvp_s_eop_check_messages,
        ls_sort_local            TYPE busort_local,
        ls_message               TYPE buslocalmsg,
        ls_msg                   TYPE bapiret2,
        lt_guid                  TYPE TABLE OF  tt_guid,
        ls_guid                  TYPE  tt_guid,
        ls_partners_guid         LIKE LINE OF it_partners_guid.

  DATA: lv_flag          TYPE char1,
        lv_relevant_cust TYPE boole_d,
        lv_relevant_vend TYPE boole_d.

* To Set the GUID
  CALL FUNCTION 'CRM_IF_BUPA_GUID_SET'
    EXPORTING
      im_guid = iv_guid.

* To check the Sync between BP and Customer
  CALL FUNCTION 'CRM_IF_BUPA_CHECK_STEPS'
    EXPORTING
      im_guid          = iv_guid
      iv_source_object = 'BP'
      iv_target_object = 'CUSTOMER'
    IMPORTING
      ev_relevant      = lv_relevant_cust.

* To check the Sync between BP and Vendor
  CALL FUNCTION 'CRM_IF_BUPA_CHECK_STEPS'
    EXPORTING
      im_guid          = iv_guid
      iv_source_object = 'BP'
      iv_target_object = 'VENDOR'
    IMPORTING
      ev_relevant      = lv_relevant_vend.

* To get the Customer Data from DB
  IF lv_relevant_cust IS INITIAL AND lv_relevant_vend IS INITIAL.
    EXIT.
  ENDIF.
**** Getting the GUID in 32bit format.
  LOOP AT it_partners_guid INTO ls_partners_guid.
    ls_guid-lv_guid = ls_partners_guid-partner_guid.
    APPEND ls_guid TO lt_guid.
    CLEAR: ls_guid.
  ENDLOOP.
  IF lv_relevant_cust IS NOT INITIAL AND it_partners_guid IS NOT INITIAL.

    SELECT * FROM crmkunnr INTO TABLE lt_kunnr
                           FOR ALL ENTRIES IN lt_guid
                           WHERE partn_guid = lt_guid-lv_guid.
    IF lt_kunnr IS NOT INITIAL.
      SELECT * FROM crmparnr INTO TABLE lt_cust_parnr
                             FOR ALL ENTRIES IN lt_kunnr
                             WHERE org_guid = lt_kunnr-partn_guid.
    ENDIF.
  ENDIF.

* To get the Vendor Data from DB
  IF lv_relevant_vend IS NOT INITIAL AND it_partners_guid IS NOT INITIAL.

    SELECT * FROM crmlifnr INTO TABLE lt_lifnr
                           FOR ALL ENTRIES IN lt_guid
                           WHERE partn_guid = lt_guid-lv_guid.

    IF lt_lifnr IS NOT INITIAL.
      SELECT * FROM crmparnr INTO TABLE lt_vend_parnr
                              FOR ALL ENTRIES IN lt_lifnr
                              WHERE org_guid = lt_lifnr-partn_guid.
    ENDIF.
  ENDIF.

* To check whether the FM is exist in the current system
  CALL FUNCTION 'FUNCTION_EXISTS'
    EXPORTING
      funcname           = 'CVP_PREPARE_EOP_BLOCK'
* IMPORTING
*     GROUP              =
*     INCLUDE            =
*     NAMESPACE          =
*     STR_AREA           =
    EXCEPTIONS
      function_not_exist = 1
      OTHERS             = 2.
  IF sy-subrc = 0.
**** Partners checks before calling CVP_PREPARE_EOP_BLOCK
    CALL FUNCTION 'CVP_PREPARE_EOP_CHECK'
      EXPORTING
        it_crmkunnr              = lt_kunnr
        it_crmparnr              = lt_cust_parnr
      IMPORTING
        et_cust_eop_partners     = lt_eop_check_partners
        et_cust_eop_partners_cpd = lt_cvp_tt_eop_check.

* To get the Block deatils of Customers from the current system
    IF lt_eop_check_partners IS NOT INITIAL.
      CALL FUNCTION 'CVP_PREPARE_EOP_BLOCK' DESTINATION 'NONE'
        EXPORTING
          iv_eop_run_mode           = iv_eop_run_mode
          iv_test_mode              = iv_test_mode
          iv_validate_nxtchk_date   = iv_validate_nxtchk_date
          iv_check_pur_compl_status = iv_check_pur_compl_status
          IV_PROCESS_DIRECTION      = 'CRMBP2CUST'
          iv_prot_output            = iv_prot_output
          iv_detail_log             = iv_detail_log
          it_eop_check_partners     = lt_eop_check_partners
          it_eop_check_partners_cpd = lt_cvp_tt_eop_check
        IMPORTING
          et_sort_result_partners   = lt_sort_result_partners
          et_messages               = lt_messages
*         EV_APPLOG_NUMBER          =
        .
    ENDIF.

* Mapping the data to the final table
    LOOP AT lt_sort_result_partners INTO ls_sort_result_partners.
      ls_sort_local-partner           = ls_sort_result_partners-id.

      READ TABLE lt_kunnr INTO ls_kunnr WITH KEY custome_no = ls_sort_result_partners-id.
      IF sy-subrc = 0.
        ls_sort_local-partner_guid    = ls_kunnr-partn_guid.
        lv_flag = 'X'.
      ENDIF.

      IF lv_flag IS INITIAL.
        READ TABLE lt_cust_parnr INTO ls_cust_parnr WITH KEY contact_no = ls_sort_result_partners-id.
        IF sy-subrc = 0.
          ls_sort_local-partner_guid    = ls_cust_parnr-person_gui.
        ENDIF.
      ENDIF.

      ls_sort_local-business_system   = ls_sort_result_partners-business_system.
      ls_sort_local-appl_name         = ls_sort_result_partners-appl_name.
      ls_sort_local-appl_rule_variant = ls_sort_result_partners-appl_rule_variant.
      ls_sort_local-st_ret_date       = ls_sort_result_partners-st_ret_date.
      ls_sort_local-nextchkdt         = ls_sort_result_partners-nextchkdt.
      ls_sort_local-pur_cmpl_status   = ls_sort_result_partners-pur_cmpl_status.

      APPEND ls_sort_local TO et_pur_cmplt_partners.
      CLEAR: ls_sort_local, ls_sort_result_partners, lv_flag.
    ENDLOOP.

* To collect the Error Messages
    LOOP AT lt_messages INTO ls_messages.
      ls_message-appl_name         = ls_messages-appl_name.
      ls_message-appl_rule_variant = ls_messages-appl_rule_variant.

      READ TABLE ls_messages-messages INTO ls_msg INDEX 1.
      ls_message-id = ls_msg-id.
      ls_message-field = ls_msg-field.
      ls_message-log_msg_no = ls_msg-log_msg_no.
      ls_message-message = ls_msg-message.
      ls_message-message_v1 = ls_msg-message_v1.
      ls_message-message_v2 = ls_msg-message_v2.
      ls_message-message_v3 = ls_msg-message_v3.
      ls_message-message_v4 = ls_msg-message_v4.
      ls_message-number = ls_msg-number.
      ls_message-parameter = ls_msg-parameter.
      ls_message-system = ls_msg-system.
      ls_message-row = ls_msg-row.
      ls_message-type = ls_msg-type.

      APPEND ls_message TO et_messages.
      CLEAR: ls_messages, ls_message.
    ENDLOOP.

    CLEAR: lt_cvp_tt_eop_check.
**** Partners checks before calling CVP_PREPARE_EOP_BLOCK
    CALL FUNCTION 'CVP_PREPARE_EOP_CHECK'
      EXPORTING
        it_crmlifnr              = lt_lifnr
        it_crmparnr              = lt_vend_parnr
      IMPORTING
        et_vend_eop_partners     = lt_eop_check_partners1
        et_vend_eop_partners_cpd = lt_cvp_tt_eop_check.
* To get the Block deatils of Vendors from the current system
    IF lt_eop_check_partners1 IS NOT INITIAL.
      CALL FUNCTION 'CVP_PREPARE_EOP_BLOCK' DESTINATION 'NONE'
        EXPORTING
          iv_eop_run_mode           = iv_eop_run_mode
          iv_test_mode              = iv_test_mode
          iv_validate_nxtchk_date   = iv_validate_nxtchk_date
          iv_check_pur_compl_status = iv_check_pur_compl_status
          IV_PROCESS_DIRECTION      = 'CRMBP2VEND'
          iv_prot_output            = iv_prot_output
          iv_detail_log             = iv_detail_log
          it_eop_check_partners     = lt_eop_check_partners1
          it_eop_check_partners_cpd = lt_cvp_tt_eop_check
        IMPORTING
          et_sort_result_partners   = lt_sort_result_partners1
          et_messages               = lt_messages
*         EV_APPLOG_NUMBER          =
        .
    ENDIF.

* Mapping the data to the final table
    LOOP AT lt_sort_result_partners1 INTO ls_sort_result_partners.
      ls_sort_local-partner           = ls_sort_result_partners-id.

        READ TABLE lt_lifnr INTO ls_lifnr WITH KEY vendor_no = ls_sort_result_partners-id.
        IF sy-subrc = 0.
          ls_sort_local-partner_guid    = ls_lifnr-partn_guid.
          lv_flag = 'X'.
        ENDIF.

      IF lv_flag IS INITIAL.
        READ TABLE lt_vend_parnr INTO ls_vend_parnr WITH KEY contact_no = ls_sort_result_partners-id.
        IF sy-subrc = 0.
          ls_sort_local-partner_guid    = ls_vend_parnr-person_gui.
        ENDIF.
      ENDIF.

      ls_sort_local-business_system   = ls_sort_result_partners-business_system.
      ls_sort_local-appl_name         = ls_sort_result_partners-appl_name.
      ls_sort_local-appl_rule_variant = ls_sort_result_partners-appl_rule_variant.
      ls_sort_local-st_ret_date       = ls_sort_result_partners-st_ret_date.
      ls_sort_local-nextchkdt         = ls_sort_result_partners-nextchkdt.
      ls_sort_local-pur_cmpl_status   = ls_sort_result_partners-pur_cmpl_status.

      APPEND ls_sort_local TO et_pur_cmplt_partners.
      CLEAR: ls_sort_local, ls_sort_result_partners, lv_flag.
    ENDLOOP.

* To collect the Error Messages
    LOOP AT lt_messages INTO ls_messages.
      ls_message-appl_name         = ls_messages-appl_name.
      ls_message-appl_rule_variant = ls_messages-appl_rule_variant.

      READ TABLE ls_messages-messages INTO ls_msg INDEX 1.
      ls_message-id = ls_msg-id.
      ls_message-field = ls_msg-field.
      ls_message-log_msg_no = ls_msg-log_msg_no.
      ls_message-message = ls_msg-message.
      ls_message-message_v1 = ls_msg-message_v1.
      ls_message-message_v2 = ls_msg-message_v2.
      ls_message-message_v3 = ls_msg-message_v3.
      ls_message-message_v4 = ls_msg-message_v4.
      ls_message-number = ls_msg-number.
      ls_message-parameter = ls_msg-parameter.
      ls_message-system = ls_msg-system.
      ls_message-row = ls_msg-row.
      ls_message-type = ls_msg-type.

      APPEND ls_message TO et_messages.
      CLEAR: ls_messages, ls_message.
    ENDLOOP.
  ENDIF.
ENDFUNCTION.
