FUNCTION cvi_bupa_eop_check.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IT_PARTNERS_GUID) TYPE  BUP_PARTNER_GUID_T
*"     REFERENCE(IT_PARTNERS_TYPE) TYPE  BUPA_PARTNER_TYPE_T OPTIONAL
*"     REFERENCE(IV_APPL) TYPE  BU_APPL_NAME OPTIONAL
*"  EXPORTING
*"     REFERENCE(ET_PUR_CMPLT_PARTNERS) TYPE  BU_SORT_LOCAL_T
*"     REFERENCE(ET_MESSAGES) TYPE  BUSLOCALMSG_T
*"----------------------------------------------------------------------

  DATA: lt_cust_active TYPE TABLE OF mdsc_ctrl_opt_a,
        lt_vend_active TYPE TABLE OF mdsc_ctrl_opt_a.

  DATA: lt_partner_guid TYPE bup_partner_guid_t,
        ls_partner_guid TYPE bupa_partner_guid,
        lt_customer     TYPE cvis_cust_link_t,
        ls_customer     TYPE cvi_cust_link,
        lt_vendor       TYPE cvis_vend_link_t,
        ls_vendor       TYPE cvi_vend_link,
        lt_ct_customer  TYPE cvis_cust_ct_link_t,
        ls_ct_customer  TYPE cvi_cust_ct_link,
        lt_ct_vendor    TYPE cvis_vend_ct_link_t,
        ls_ct_vendor    TYPE cvi_vend_ct_link.

  DATA: lt_sort_result_partners  TYPE cvp_tt_sort_result,
        lt_sort_result_partners1 TYPE cvp_tt_sort_result,
        ls_sort_result_partners  TYPE cvp_s_sort_result,
        ls_sort_local            TYPE busort_local,
        lt_messages              TYPE cvp_tt_eop_check_messages,
        lt_messages1             TYPE cvp_tt_eop_check_messages,
        ls_messages              TYPE cvp_s_eop_check_messages,
        ls_message               TYPE buslocalmsg,
        ls_msg                   TYPE bapiret2,
        lt_eop_check_partners    TYPE cvp_tt_eop_check_partners,
        lt_eop_check_partners1   TYPE cvp_tt_eop_check_partners,
        ls_eop_check_partners    TYPE cvp_s_eop_check_partners,
        lt_cvp_tt_eop_check      TYPE cvp_tt_eop_check_partners_cpd,
        lt_cust                  TYPE bupa_cust_tt,
        ls_cust                  TYPE bupa_cust.

  DATA: lv_intrim        TYPE char1,
        lv_ovrall        TYPE char1,
        lv_chkdat        TYPE char1,
        lv_intres        TYPE char1,
        lv_applog        TYPE boole_d,
        lv_detlog        TYPE boole_d,
        lv_tesrun        TYPE boole_d,
        lv_chkeop        TYPE char1,
        lv_flag          TYPE char1,
        lv_cust_relevant TYPE boole_d,
        lv_vend_relevant TYPE boole_d.

  DATA: lv_eop_run_mode     TYPE cvp_eop_run_mode,
        lv_test_mode        TYPE cvp_test_mode,
        lv_nxtchk_date      TYPE cvp_validate_nxtchk_date,
        lv_pur_compl_status TYPE cvp_check_pur_compl_status,
        lv_prot_output      TYPE cvp_prot_output,
        lv_detail_log       TYPE cvp_detail_log.

  DATA: lv_result       TYPE boole-boole.

  DATA: lr_cvi_ctrl_loop     TYPE REF TO cvi_ctrl_loop,
        badi_isu_obj_mapping TYPE REF TO badi_bp_isu_obj_mapping,
        oref                 TYPE REF TO cx_root.

  CONSTANTS: c_msg_id  TYPE char4 VALUE 'R111',
             c_msg_no  TYPE char3 VALUE '023',
             c_msg_typ VALUE 'I'.

*&---- To get the Sync between BP to Customer
  SELECT * FROM mdsc_ctrl_opt_a INTO TABLE lt_cust_active WHERE sync_obj_source  = 'BP'
                                                            AND sync_obj_target  = 'CUSTOMER'
                                                            AND active_indicator = 'X'.

*&---- To get the Sync between BP to Vendor
  SELECT * FROM mdsc_ctrl_opt_a INTO TABLE lt_vend_active WHERE sync_obj_source  = 'BP'
                                                            AND sync_obj_target  = 'VENDOR'
                                                            AND active_indicator = 'X'.

*To get the partner guid
  IF it_partners_guid IS NOT INITIAL.
    SELECT partner partner_guid FROM but000 INTO TABLE lt_partner_guid
                                FOR ALL ENTRIES IN it_partners_guid
                                WHERE partner = it_partners_guid-partner
                                   OR partner_guid = it_partners_guid-partner_guid.
  ENDIF.

*  To get, whether Synchronization is Active or not between BP and Customer
  CALL METHOD cvi_ctrl_loop=>get_instance
    IMPORTING
      er_object = lr_cvi_ctrl_loop.

  CALL METHOD lr_cvi_ctrl_loop->check_steps
    EXPORTING
      iv_source_object = 'BP'
      iv_target_object = 'CUSTOMER'
    IMPORTING
      ev_relevant      = lv_cust_relevant
*     es_error         =
    .

*  To get, whether Synchronization is Active or not between BP and vendor
  CALL METHOD cvi_ctrl_loop=>get_instance
    IMPORTING
      er_object = lr_cvi_ctrl_loop.

  CALL METHOD lr_cvi_ctrl_loop->check_steps
    EXPORTING
      iv_source_object = 'BP'
      iv_target_object = 'VENDOR'
    IMPORTING
      ev_relevant      = lv_vend_relevant
*     es_error         =
    .

  IF lv_cust_relevant IS NOT INITIAL OR lv_vend_relevant IS NOT INITIAL.
*To get the EOP Mode data
    CALL FUNCTION 'BUPA_PREPARE_EOP_MODE_GET'
      IMPORTING
*       EV_FILTER =
        ev_intrim = lv_intrim
        ev_ovrall = lv_ovrall
        ev_chkdat = lv_chkdat
*       ev_intres = lv_intres
        ev_applog = lv_applog
        ev_detlog = lv_detlog
        ev_tesrun = lv_tesrun
        ev_chkeop = lv_chkeop.

*Mapping the data to send it to the FM
    IF lv_intrim IS NOT INITIAL.
      lv_eop_run_mode = '1'.
    ELSEIF lv_ovrall IS NOT INITIAL.
      lv_eop_run_mode = '2'.
    ENDIF.

    lv_test_mode        = lv_tesrun.
    lv_nxtchk_date      = lv_chkdat.
    lv_pur_compl_status = lv_chkeop.

    IF lv_detlog IS INITIAL.
      lv_detail_log = '1'.
    ELSEIF lv_detlog IS NOT INITIAL.
      lv_detail_log = 'X'.
    ENDIF.

    IF lv_applog IS INITIAL.
      lv_prot_output      = ' '.
    ELSEIF lv_applog IS NOT INITIAL.
      lv_prot_output      = '1'.
    ENDIF.

*To get the Customer Numbers
    IF lt_cust_active IS NOT INITIAL .
      IF lv_cust_relevant IS NOT INITIAL AND lt_partner_guid IS NOT INITIAL.
        SELECT client partner_guid customer FROM cvi_cust_link INTO TABLE lt_customer
                                           FOR ALL ENTRIES IN lt_partner_guid
                                           WHERE partner_guid = lt_partner_guid-partner_guid.

        SELECT client partner_guid person_guid customer_cont FROM cvi_cust_ct_link INTO TABLE lt_ct_customer
                                            FOR ALL ENTRIES IN lt_partner_guid
                                            WHERE person_guid = lt_partner_guid-partner_guid.


        LOOP AT it_partners_guid INTO ls_partner_guid.

          IF lt_customer IS NOT INITIAL.
            READ TABLE lt_customer INTO ls_customer WITH KEY partner_guid = ls_partner_guid-partner_guid.
            IF sy-subrc <> 0.

              ls_message-partnerid    = ls_partner_guid-partner.
              ls_message-partner_guid = ls_partner_guid-partner_guid.

              ls_message-type = c_msg_typ.
              ls_message-id = c_msg_id.
              ls_message-number = c_msg_no.
              ls_message-message = 'No Business With this Partner'.
*    ls_message-field = ls_msg-field.
*    ls_message-log_msg_no = c_msg_no.
              ls_message-message_v1 = ls_msg-message_v1.
              ls_message-message_v2 = ls_msg-message_v2.
              ls_message-message_v3 = ls_msg-message_v3.
              ls_message-message_v4 = ls_msg-message_v4.
*    ls_message-parameter = ls_msg-parameter.
*    ls_message-system = ls_msg-system.
*    ls_message-row = ls_msg-row.

              APPEND ls_message TO et_messages.
              CLEAR: ls_message, ls_partner_guid, ls_customer.
            ENDIF.
          ENDIF.

          IF lt_ct_customer IS NOT INITIAL.
            READ TABLE lt_ct_customer INTO ls_ct_customer WITH KEY partner_guid = ls_partner_guid-partner_guid.
            IF sy-subrc <> 0.

              ls_message-partnerid    = ls_partner_guid-partner.
              ls_message-partner_guid = ls_partner_guid-partner_guid.

              ls_message-type = c_msg_typ.
              ls_message-id = c_msg_id.
              ls_message-number = c_msg_no.
              ls_message-message = 'No Business With this Partner'.
*    ls_message-field = ls_msg-field.
*    ls_message-log_msg_no = c_msg_no.
              ls_message-message_v1 = ls_msg-message_v1.
              ls_message-message_v2 = ls_msg-message_v2.
              ls_message-message_v3 = ls_msg-message_v3.
              ls_message-message_v4 = ls_msg-message_v4.
*    ls_message-parameter = ls_msg-parameter.
*    ls_message-system = ls_msg-system.
*    ls_message-row = ls_msg-row.

              APPEND ls_message TO et_messages.
              CLEAR: ls_message, ls_partner_guid, ls_ct_customer.
            ENDIF.
          ENDIF.
        ENDLOOP.

**** Partners checks before calling CVP_PREPARE_EOP_BLOCK
        CALL FUNCTION 'CVP_PREPARE_EOP_CHECK'
          EXPORTING
            it_cust_link             = lt_customer
            it_cust_ct_link          = lt_ct_customer
          IMPORTING
            et_cust_eop_partners     = lt_eop_check_partners
            et_cust_eop_partners_cpd = lt_cvp_tt_eop_check.

*To get the EOP Block data of Customers
        CALL FUNCTION 'CVP_PREPARE_EOP_BLOCK' DESTINATION 'NONE'
          EXPORTING
            iv_eop_run_mode           = lv_eop_run_mode
            iv_test_mode              = lv_test_mode
            iv_validate_nxtchk_date   = lv_nxtchk_date
            iv_check_pur_compl_status = lv_pur_compl_status
            IV_PROCESS_DIRECTION      = 'ERPBP2CUST'
            iv_prot_output            = lv_prot_output
            iv_detail_log             = lv_detail_log
            it_eop_check_partners     = lt_eop_check_partners
            it_eop_check_partners_cpd = lt_cvp_tt_eop_check
          IMPORTING
            et_sort_result_partners   = lt_sort_result_partners
            et_messages               = lt_messages.

* Mapping the data to the final table
        LOOP AT lt_sort_result_partners INTO ls_sort_result_partners.

          READ TABLE lt_customer INTO ls_customer WITH KEY customer = ls_sort_result_partners-id.
          IF sy-subrc = 0.
            ls_sort_local-partner_guid    = ls_customer-partner_guid.
            lv_flag = 'X'.

            READ TABLE it_partners_guid INTO ls_partner_guid WITH KEY partner_guid = ls_customer-partner_guid.
            IF sy-subrc = 0.
              ls_sort_local-partner           = ls_partner_guid-partner.
            ENDIF.
          ENDIF.

          IF lv_flag IS INITIAL.
            READ TABLE lt_ct_customer INTO ls_ct_customer WITH KEY customer_cont = ls_sort_result_partners-id.
            IF sy-subrc = 0.
              ls_sort_local-partner_guid    = ls_ct_customer-partner_guid.

              READ TABLE it_partners_guid INTO ls_partner_guid WITH KEY partner_guid = ls_ct_customer-partner_guid.
              IF sy-subrc = 0.
                ls_sort_local-partner           = ls_partner_guid-partner.
              ENDIF.
            ENDIF.
          ENDIF.

          ls_sort_local-business_system   = ls_sort_result_partners-business_system.
          ls_sort_local-appl_name         = ls_sort_result_partners-appl_name.
          ls_sort_local-appl_rule_variant = ls_sort_result_partners-appl_rule_variant.
          ls_sort_local-st_ret_date       = ls_sort_result_partners-st_ret_date.
          ls_sort_local-nextchkdt         = ls_sort_result_partners-nextchkdt.
          ls_sort_local-pur_cmpl_status   = ls_sort_result_partners-pur_cmpl_status.

          APPEND ls_sort_local TO et_pur_cmplt_partners.
          CLEAR: ls_sort_local, ls_sort_result_partners, lv_flag, ls_customer, ls_ct_customer, ls_partner_guid.
        ENDLOOP.

* To collect the Error Messages
        LOOP AT lt_messages INTO ls_messages.
          READ TABLE lt_customer INTO ls_customer WITH KEY customer = ls_messages-id.
          IF sy-subrc = 0.

            READ TABLE it_partners_guid INTO ls_partner_guid WITH KEY partner_guid = ls_customer-partner_guid.

            ls_message-partnerid = ls_partner_guid-partner.
            ls_message-partner_guid = ls_partner_guid-partner_guid.
          ENDIF.

          READ TABLE lt_ct_customer INTO ls_ct_customer WITH KEY customer_cont = ls_messages-id.
          IF sy-subrc = 0.

            READ TABLE it_partners_guid INTO ls_partner_guid WITH KEY partner_guid = ls_ct_customer-person_guid.

            ls_message-partnerid = ls_partner_guid-partner.
            ls_message-partner_guid = ls_partner_guid-partner_guid.
          ENDIF.

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
          CLEAR: ls_messages, ls_message, ls_customer, ls_partner_guid, ls_partner_guid.
        ENDLOOP.

        CLEAR: lv_cust_relevant.
      ENDIF.
    ELSE.
      IF lv_cust_relevant IS NOT INITIAL.
      TRY.
          GET BADI badi_isu_obj_mapping.
          CALL BADI badi_isu_obj_mapping->map_partner_to_cust
            EXPORTING
              lt_partner_guid = it_partners_guid
            IMPORTING
              lt_partner      = lt_cust.
        CATCH cx_root INTO oref.
          EXIT.
      ENDTRY.

      LOOP AT lt_cust INTO ls_cust.
        ls_customer-customer = ls_cust-kunnr.
        ls_customer-partner_guid = ls_cust-partner_guid.

        APPEND ls_customer TO lt_customer.
        CLEAR: ls_cust, ls_customer.
      ENDLOOP.

*&---- To geth EOP details
      CALL FUNCTION 'CVP_PREPARE_EOP_CHECK'
        EXPORTING
          it_cust_link             = lt_customer
        IMPORTING
          et_cust_eop_partners     = lt_eop_check_partners
          et_cust_eop_partners_cpd = lt_cvp_tt_eop_check.

*To get the EOP Block data of Customers
      CALL FUNCTION 'CVP_PREPARE_EOP_BLOCK' DESTINATION 'NONE'
        EXPORTING
          iv_eop_run_mode           = lv_eop_run_mode
          iv_test_mode              = lv_test_mode
          iv_validate_nxtchk_date   = lv_nxtchk_date
          iv_check_pur_compl_status = lv_pur_compl_status
          IV_PROCESS_DIRECTION      = 'ERPBP2CUST'
          iv_prot_output            = lv_prot_output
          iv_detail_log             = lv_detail_log
          it_eop_check_partners     = lt_eop_check_partners
          it_eop_check_partners_cpd = lt_cvp_tt_eop_check
        IMPORTING
          et_sort_result_partners   = lt_sort_result_partners
          et_messages               = lt_messages.

* Mapping the data to the final table
      LOOP AT lt_sort_result_partners INTO ls_sort_result_partners.
        ls_sort_local-partner           = ls_sort_result_partners-id.

        READ TABLE lt_customer INTO ls_customer WITH KEY customer = ls_sort_result_partners-id.
        IF sy-subrc = 0.
          ls_sort_local-partner_guid    = ls_customer-partner_guid.
          lv_flag = 'X'.

          READ TABLE it_partners_guid INTO ls_partner_guid WITH KEY partner_guid = ls_customer-partner_guid.
          IF sy-subrc = 0.
            ls_sort_local-partner           = ls_partner_guid-partner.
          ENDIF.
        ENDIF.

        IF lv_flag IS INITIAL.
          READ TABLE lt_ct_customer INTO ls_ct_customer WITH KEY customer_cont = ls_sort_result_partners-id.
          IF sy-subrc = 0.
            ls_sort_local-partner_guid    = ls_ct_customer-partner_guid.

            READ TABLE it_partners_guid INTO ls_partner_guid WITH KEY partner_guid = ls_ct_customer-partner_guid.
            IF sy-subrc = 0.
              ls_sort_local-partner           = ls_partner_guid-partner.
            ENDIF.
          ENDIF.
        ENDIF.

        ls_sort_local-business_system   = ls_sort_result_partners-business_system.
        ls_sort_local-appl_name         = ls_sort_result_partners-appl_name.
        ls_sort_local-appl_rule_variant = ls_sort_result_partners-appl_rule_variant.
        ls_sort_local-st_ret_date       = ls_sort_result_partners-st_ret_date.
        ls_sort_local-nextchkdt         = ls_sort_result_partners-nextchkdt.
        ls_sort_local-pur_cmpl_status   = ls_sort_result_partners-pur_cmpl_status.

        APPEND ls_sort_local TO et_pur_cmplt_partners.
        CLEAR: ls_sort_local, ls_sort_result_partners, lv_flag, ls_partner_guid, ls_customer, ls_ct_customer.
      ENDLOOP.

* To collect the Error Messages
      LOOP AT lt_messages INTO ls_messages.
        READ TABLE lt_customer INTO ls_customer WITH KEY customer = ls_messages-id.
        IF sy-subrc = 0.

          READ TABLE it_partners_guid INTO ls_partner_guid WITH KEY partner_guid = ls_customer-partner_guid.

          ls_message-partnerid = ls_partner_guid-partner.
          ls_message-partner_guid = ls_partner_guid-partner_guid.
        ENDIF.

        READ TABLE lt_ct_customer INTO ls_ct_customer WITH KEY customer_cont = ls_messages-id.
        IF sy-subrc = 0.

          READ TABLE it_partners_guid INTO ls_partner_guid WITH KEY partner_guid = ls_ct_customer-person_guid.

          ls_message-partnerid = ls_partner_guid-partner.
          ls_message-partner_guid = ls_partner_guid-partner_guid.
        ENDIF.

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
        CLEAR: ls_messages, ls_message, ls_customer, ls_partner_guid, ls_ct_customer.
      ENDLOOP.
      ENDIF.
    ENDIF.

***To get the Vendor Numbers
   IF lt_vend_active IS NOT INITIAL.
      IF lv_vend_relevant IS NOT INITIAL AND lt_partner_guid IS NOT INITIAL.
        SELECT client partner_guid vendor FROM cvi_vend_link INTO TABLE lt_vendor
                                           FOR ALL ENTRIES IN lt_partner_guid
                                           WHERE partner_guid = lt_partner_guid-partner_guid.


        SELECT client partner_guid person_guid vendor_cont FROM cvi_vend_ct_link INTO TABLE lt_ct_vendor
                                                FOR ALL ENTRIES IN lt_partner_guid
                                                WHERE person_guid = lt_partner_guid-partner_guid. "#EC CI_NOFIRST


        CLEAR:lv_vend_relevant.

        LOOP AT it_partners_guid INTO ls_partner_guid.
          IF lt_vendor IS NOT INITIAL.

            READ TABLE lt_vendor INTO ls_vendor WITH KEY partner_guid = ls_partner_guid-partner_guid.
            IF sy-subrc <> 0.
                ls_message-partnerid    = ls_partner_guid-partner.
                ls_message-partner_guid = ls_partner_guid-partner_guid.

                ls_message-type = c_msg_typ.
                ls_message-id = c_msg_id.
                ls_message-number = c_msg_no.
                ls_message-message = 'No Business With this Partner'.
*    ls_message-field = ls_msg-field.
*    ls_message-log_msg_no = c_msg_no.
                ls_message-message_v1 = ls_msg-message_v1.
                ls_message-message_v2 = ls_msg-message_v2.
                ls_message-message_v3 = ls_msg-message_v3.
                ls_message-message_v4 = ls_msg-message_v4.
*    ls_message-parameter = ls_msg-parameter.
*    ls_message-system = ls_msg-system.
*    ls_message-row = ls_msg-row.

                APPEND ls_message TO et_messages.
                CLEAR: ls_message, ls_partner_guid, ls_vendor.
              ENDIF.
          ENDIF.

          IF lt_ct_vendor IS NOT INITIAL.
            READ TABLE lt_ct_vendor INTO ls_ct_vendor WITH KEY partner_guid = ls_partner_guid-partner_guid.
            IF sy-subrc <> 0.
              ls_message-partnerid    = ls_partner_guid-partner.
              ls_message-partner_guid = ls_partner_guid-partner_guid.

              ls_message-type = c_msg_typ.
              ls_message-id = c_msg_id.
              ls_message-number = c_msg_no.
              ls_message-message = 'No Business With this Partner'.
*    ls_message-field = ls_msg-field.
*    ls_message-log_msg_no = c_msg_no.
              ls_message-message_v1 = ls_msg-message_v1.
              ls_message-message_v2 = ls_msg-message_v2.
              ls_message-message_v3 = ls_msg-message_v3.
              ls_message-message_v4 = ls_msg-message_v4.
*    ls_message-parameter = ls_msg-parameter.
*    ls_message-system = ls_msg-system.
*    ls_message-row = ls_msg-row.

              APPEND ls_message TO et_messages.
              CLEAR: ls_message, ls_partner_guid, ls_ct_vendor.
            ENDIF.
          ENDIF.
        ENDLOOP.

**** Partners checks before calling CVP_PREPARE_EOP_BLOCK
        CALL FUNCTION 'CVP_PREPARE_EOP_CHECK'
          EXPORTING
            it_vend_link             = lt_vendor
            it_vend_ct_link          = lt_ct_vendor
          IMPORTING
            et_vend_eop_partners     = lt_eop_check_partners1
            et_vend_eop_partners_cpd = lt_cvp_tt_eop_check.

*To get the EOP Block data of Vendors
 IF lt_eop_check_partners1[] IS NOT INITIAL OR lt_cvp_tt_eop_check[] IS NOT INITIAL.
        CALL FUNCTION 'CVP_PREPARE_EOP_BLOCK' DESTINATION 'NONE'
          EXPORTING
            iv_eop_run_mode           = lv_eop_run_mode
            iv_test_mode              = lv_test_mode
            iv_validate_nxtchk_date   = lv_nxtchk_date
            iv_check_pur_compl_status = lv_pur_compl_status
            IV_PROCESS_DIRECTION      = 'ERPBP2VEND'
            iv_prot_output            = lv_prot_output
            iv_detail_log             = lv_detail_log
            it_eop_check_partners     = lt_eop_check_partners1
            it_eop_check_partners_cpd = lt_cvp_tt_eop_check
          IMPORTING
            et_sort_result_partners   = lt_sort_result_partners1
            et_messages               = lt_messages1.

* Mapping the data to the final table
        LOOP AT lt_sort_result_partners1 INTO ls_sort_result_partners.
          ls_sort_local-partner           = ls_sort_result_partners-id.

          READ TABLE lt_vendor INTO ls_vendor WITH KEY vendor = ls_sort_result_partners-id.
          IF sy-subrc = 0.
            ls_sort_local-partner_guid    = ls_vendor-partner_guid.
            lv_flag = 'X'.

            READ TABLE it_partners_guid INTO ls_partner_guid WITH KEY partner_guid = ls_vendor-partner_guid.
            IF sy-subrc = 0.
              ls_sort_local-partner           = ls_partner_guid-partner.
            ENDIF.
          ENDIF.

          IF lv_flag IS INITIAL.
            READ TABLE lt_ct_vendor INTO ls_ct_vendor WITH KEY vendor_cont = ls_sort_result_partners-id.
            IF sy-subrc = 0.
              ls_sort_local-partner_guid    = ls_ct_vendor-partner_guid.

              READ TABLE it_partners_guid INTO ls_partner_guid WITH KEY partner_guid = ls_ct_vendor-partner_guid.
              IF sy-subrc = 0.
                ls_sort_local-partner           = ls_partner_guid-partner.
              ENDIF.
            ENDIF.
          ENDIF.

          ls_sort_local-business_system   = ls_sort_result_partners-business_system.
          ls_sort_local-appl_name         = ls_sort_result_partners-appl_name.
          ls_sort_local-appl_rule_variant = ls_sort_result_partners-appl_rule_variant.
          ls_sort_local-st_ret_date       = ls_sort_result_partners-st_ret_date.
          ls_sort_local-nextchkdt         = ls_sort_result_partners-nextchkdt.
          ls_sort_local-pur_cmpl_status   = ls_sort_result_partners-pur_cmpl_status.

          APPEND ls_sort_local TO et_pur_cmplt_partners.
          CLEAR: ls_sort_local, ls_sort_result_partners, lv_flag, ls_vendor, ls_ct_vendor, ls_partner_guid.
        ENDLOOP.

* To collect the Error Messages
        LOOP AT lt_messages1 INTO ls_messages.

          READ TABLE lt_vendor INTO ls_vendor WITH KEY vendor = ls_messages-id.
          IF sy-subrc = 0.

            READ TABLE it_partners_guid INTO ls_partner_guid WITH KEY partner_guid = ls_vendor-partner_guid.

            ls_message-partnerid = ls_partner_guid-partner.
            ls_message-partner_guid = ls_partner_guid-partner_guid.
          ENDIF.

          READ TABLE lt_ct_vendor INTO ls_ct_vendor WITH KEY vendor_cont = ls_messages-id.
          IF sy-subrc = 0.

            READ TABLE it_partners_guid INTO ls_partner_guid WITH KEY partner_guid = ls_ct_vendor-person_guid.

            ls_message-partnerid = ls_partner_guid-partner.
            ls_message-partner_guid = ls_partner_guid-partner_guid.
          ENDIF.

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
          CLEAR: ls_messages, ls_message, ls_vendor, ls_partner_guid, ls_ct_vendor.
        ENDLOOP.

        CLEAR: lt_cvp_tt_eop_check.
        ENDIF.
      ENDIF.
   ENDIF.
  ENDIF.
ENDFUNCTION.
