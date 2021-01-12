FUNCTION crm_if_bupa_unblk_check_w.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_TEST_MODE) TYPE  CVP_TEST_MODE
*"     VALUE(IV_PROT_OUTPUT) TYPE  CVP_PROT_OUTPUT
*"     VALUE(IV_DETAIL_LOG) TYPE  CVP_DETAIL_LOG
*"     VALUE(IT_PARTNERS_GUID) TYPE  BUP_PARTNER_GUID_T
*"     VALUE(IV_APPL) TYPE  BU_APPL_NAME OPTIONAL
*"     VALUE(IV_GUID) TYPE  GUID_16
*"  EXPORTING
*"     VALUE(ET_UNBLK_STATUS) TYPE  BUPARTNER_UNBLK_STATUSREMOTE_T
*"     VALUE(ET_MESSAGE) TYPE  BUSLOCALMSG_T
*"----------------------------------------------------------------------
*&--- Local constants and variables decleration.
  TYPES: BEGIN OF ty_partnerguid,
           partner_guid TYPE sychar32,
         END OF ty_partnerguid.

  DATA: lt_crmkunnr     TYPE TABLE OF crmkunnr,
        lt_crmlifnr     TYPE TABLE OF crmlifnr,
        lt_crmparnr     TYPE TABLE OF crmparnr,
        lt_crmparnr_all TYPE TABLE OF crmparnr,
        ls_crmkunnr     TYPE crmkunnr,
        ls_crmlifnr     TYPE crmlifnr,
        ls_crmparnr     TYPE crmparnr.

  DATA: lt_partner_guid         TYPE TABLE OF ty_partnerguid,
        ls_partner_guid         TYPE ty_partnerguid,
        ls_partners_guid        TYPE bupa_partner_guid,
        lt_unblk_partner        TYPE cvp_tt_unblock_status,
        lt_unblk_partner_status TYPE cvp_tt_unblock_status,
        ls_unblk_partner_return TYPE bupartner_unblk_status_remote,
        lt_messages             TYPE cvp_tt_eop_check_messages,
        lt1_messages            TYPE BAPIRET2_T,
        ls_message              TYPE CVP_S_EOP_CHECK_MESSAGES,
        es_message              TYPE BUSLOCALMSG,
        ls_unblk_partner        TYPE cvp_s_unblock_status.

  DATA: lv_relevant_cust TYPE boole_d,
        lv_relevant_vend TYPE boole_d.

  FIELD-SYMBOLS <es_message> TYPE BAPIRET2.

  CONSTANTS : lc_type_customer TYPE cvp_id_type VALUE '1',
              lc_type_vendor   TYPE cvp_id_type VALUE '2',
              lc_type_contact  TYPE cvp_id_type VALUE '3'.

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
*&--- Fuction existence check
  IF lv_relevant_cust IS INITIAL AND lv_relevant_vend IS INITIAL.
    EXIT.
  ENDIF.

  IF it_partners_guid IS NOT INITIAL.
    CALL FUNCTION 'FUNCTION_EXISTS'
      EXPORTING
        funcname           = 'CVP_PROCESS_UNBLOCK'    " Name of Function Module
      EXCEPTIONS
        function_not_exist = 1
        OTHERS             = 2.

    IF sy-subrc = 0 .
*&--- Fetching relevent customers,vendor and contact persons
      LOOP AT it_partners_guid INTO ls_partners_guid.
        ls_partner_guid-partner_guid = ls_partners_guid-partner_guid.
        APPEND ls_partner_guid TO lt_partner_guid.
      ENDLOOP.
      IF lv_relevant_cust IS NOT INITIAL.
        SELECT * FROM crmkunnr INTO TABLE lt_crmkunnr FOR ALL ENTRIES IN lt_partner_guid
                                                      WHERE partn_guid = lt_partner_guid-partner_guid.
        IF sy-subrc = 0.
*&--- Preparing customers
          LOOP AT lt_crmkunnr INTO ls_crmkunnr.
            ls_unblk_partner-id = ls_crmkunnr-custome_no.
            ls_unblk_partner-id_type = lc_type_customer.
            APPEND ls_unblk_partner TO lt_unblk_partner.
          ENDLOOP.
          SELECT * FROM crmparnr INTO TABLE lt_crmparnr FOR ALL ENTRIES IN lt_crmkunnr
                                                        WHERE org_guid = lt_crmkunnr-partn_guid.
          IF sy-subrc = 0.
*&--- Preparing contact persons
            APPEND LINES OF lt_crmparnr TO lt_crmparnr_all.
            LOOP AT lt_crmparnr INTO ls_crmparnr.
              ls_unblk_partner-id = ls_crmparnr-contact_no.
              ls_unblk_partner-id_type = lc_type_contact.
              APPEND ls_unblk_partner TO lt_unblk_partner.
            ENDLOOP.
          ENDIF.
        ENDIF.
      ENDIF.
      IF lv_relevant_vend IS NOT INITIAL.
        SELECT * FROM crmlifnr INTO TABLE lt_crmlifnr FOR ALL ENTRIES IN lt_partner_guid
                                                      WHERE partn_guid = lt_partner_guid-partner_guid.
        IF sy-subrc = 0.
*&--- Preparing vendors
          LOOP AT lt_crmlifnr INTO ls_crmlifnr.
            ls_unblk_partner-id = ls_crmlifnr-vendor_no.
            ls_unblk_partner-id_type = lc_type_vendor.
            APPEND ls_unblk_partner TO lt_unblk_partner.
          ENDLOOP.
          SELECT * FROM crmparnr INTO TABLE lt_crmparnr FOR ALL ENTRIES IN lt_crmlifnr
                                                        WHERE org_guid = lt_crmlifnr-partn_guid.
          IF sy-subrc = 0.
*&--- Preparing contact persons
            APPEND LINES OF lt_crmparnr TO lt_crmparnr_all.
            LOOP AT lt_crmparnr INTO ls_crmparnr.
              ls_unblk_partner-id = ls_crmparnr-contact_no.
              ls_unblk_partner-id_type = lc_type_contact.
              APPEND ls_unblk_partner TO lt_unblk_partner.
            ENDLOOP.
          ENDIF.
        ENDIF.
      ENDIF.
*&--- Passing all customers,vendors and contact persons for unblocking
      IF lt_unblk_partner IS NOT INITIAL.
        CALL FUNCTION 'CVP_PROCESS_UNBLOCK'
          EXPORTING
            iv_test_mode                = iv_test_mode
            iv_prot_output              = iv_prot_output
            iv_detail_log               = iv_detail_log
            it_unblock_partners         = lt_unblk_partner
          IMPORTING
            et_unblock_partners_results = lt_unblk_partner_status
            et_messages                 = lt_messages.

*&--- Preparing export parametes.
        LOOP AT lt_unblk_partner_status INTO ls_unblk_partner  .

          CASE ls_unblk_partner-id_type.
            WHEN lc_type_customer.
              READ TABLE lt_crmkunnr INTO ls_crmkunnr WITH KEY custome_no = ls_unblk_partner-id.
              IF sy-subrc =  0 .
                ls_unblk_partner_return-partner_guid = ls_crmkunnr-partn_guid .
                ls_unblk_partner_return-appl_name = iv_appl.
                IF  ls_unblk_partner-status = 'A' .
                  ls_unblk_partner_return-unblk_status = 'X' .
                ENDIF.
              ENDIF.

            WHEN lc_type_vendor .
              READ TABLE lt_crmlifnr INTO ls_crmlifnr WITH KEY vendor_no = ls_unblk_partner-id.
              IF sy-subrc = 0 .
                ls_unblk_partner_return-partner_guid = ls_crmlifnr-partn_guid .
                ls_unblk_partner_return-appl_name = iv_appl.
                IF ls_unblk_partner-status = 'A' .
                  ls_unblk_partner_return-unblk_status = 'X' .
                ENDIF.
              ENDIF.

            WHEN lc_type_contact .
              READ TABLE lt_crmparnr_all INTO ls_crmparnr WITH KEY contact_no = ls_unblk_partner-id.
              IF sy-subrc = 0.
                ls_unblk_partner_return-partner_guid = ls_crmparnr-org_guid.
                ls_unblk_partner_return-appl_name = iv_appl.
                IF ls_unblk_partner-status = 'A' .
                  ls_unblk_partner_return-unblk_status = 'X' .
                ENDIF.
              ENDIF.
          ENDCASE.

          READ TABLE it_partners_guid INTO ls_partners_guid  WITH KEY partner_guid = ls_unblk_partner_return-partner_guid.
          ls_unblk_partner_return-partner = ls_partners_guid-partner .
          APPEND ls_unblk_partner_return  TO et_unblk_status.
        ENDLOOP.

        LOOP AT lt_messages INTO ls_message.
          es_message-appl_name = ls_message-appl_name.
          es_message-appl_rule_variant = ls_message-appl_rule_variant.
          lt1_messages = ls_message-messages.
          LOOP AT lt1_messages ASSIGNING <es_message>.
            MOVE-CORRESPONDING <es_message> to es_message.
            APPEND es_message to et_message.
          ENDLOOP.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFUNCTION.
