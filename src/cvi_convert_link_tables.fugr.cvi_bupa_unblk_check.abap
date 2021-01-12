FUNCTION cvi_bupa_unblk_check.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IT_PARTNERS_GUID) TYPE  BUP_PARTNER_GUID_T
*"     REFERENCE(IV_APPL) TYPE  BU_APPL_NAME OPTIONAL
*"  EXPORTING
*"     REFERENCE(ET_UNBLK_STATUS) TYPE  BUPARTNER_UNBLK_STATUSREMOTE_T
*"     REFERENCE(ET_MESSAGES) TYPE  BUSLOCALMSG_T
*"----------------------------------------------------------------------
  TYPES: BEGIN OF ty_cvi_link_customer,
           partner_guid TYPE cvi_cust_link-partner_guid,
           customer     TYPE cvi_cust_link-customer,
         END OF ty_cvi_link_customer.

  TYPES: BEGIN OF ty_cvi_link_vendor,
           partner_guid TYPE cvi_vend_link-partner_guid,
           vendor       TYPE cvi_vend_link-vendor,
         END OF  ty_cvi_link_vendor.

  TYPES: BEGIN OF ty_cvi_cust_ct_link,
           partner_guid  TYPE cvi_cust_ct_link-partner_guid,
           customer_cont TYPE cvi_cust_ct_link-customer_cont,
         END OF ty_cvi_cust_ct_link.

  TYPES: BEGIN OF ty_cvi_vend_ct_link,
           partner_guid TYPE cvi_vend_ct_link-partner_guid,
           vendor_cont  TYPE cvi_vend_ct_link-vendor_cont,
         END OF ty_cvi_vend_ct_link.

  DATA lt_cvi_link_customer      TYPE STANDARD TABLE OF ty_cvi_link_customer.
  DATA lt_cvi_link_vendor        TYPE STANDARD TABLE OF ty_cvi_link_vendor .
  DATA lt_cvi_cust_ct_link       TYPE STANDARD TABLE OF ty_cvi_cust_ct_link .
  DATA lt_cvi_vend_ct_link       TYPE STANDARD TABLE OF ty_cvi_vend_ct_link .
  DATA lt_unblk_partner_cust     TYPE cvp_tt_unblock_status.
  DATA lt_unblk_partner_vend     TYPE cvp_tt_unblock_status.
  DATA lt_unblk_bp_status_cust   TYPE cvp_tt_unblock_status.
  DATA lt_unblk_bp_status_vend   TYPE cvp_tt_unblock_status.
  DATA lt_unblk_partner_status   TYPE cvp_tt_unblock_status.
  DATA lt_message                TYPE cvp_tt_eop_check_messages.

  DATA ls_unblk_partner          TYPE cvp_s_unblock_status.
  DATA ls_unblk_partner_return   TYPE bupartner_unblk_status_remote .
  DATA ls_partners_guid          LIKE LINE OF it_partners_guid .

  DATA lv_active_cust        TYPE boole_d.
  DATA lv_active_vend        TYPE boole_d.
  DATA lr_cvi_ka_bp_customer TYPE REF TO cvi_ctrl_loop.
  DATA lr_cvi_ka_bp_vendor   TYPE REF TO cvi_ctrl_loop.
  DATA:lv_test_mode   TYPE cvp_test_mode,
       lv_prot_output TYPE cvp_prot_output,
       lv_detail_log  TYPE cvp_detail_log,
       lv_detlog      TYPE boole_d,
       lv_testrun     TYPE boole_d,
       lv_applog      TYPE boole_d.

  DATA :              ls_cvi_link_customer LIKE LINE OF lt_cvi_link_customer,
                      ls_cvi_link_vendor   LIKE LINE OF lt_cvi_link_vendor,
                      ls_cvi_cust_ct_link  LIKE LINE OF lt_cvi_cust_ct_link,
                      ls_cvi_vend_ct_link  LIKE LINE OF lt_cvi_vend_ct_link.

  CONSTANTS : lc_type_customer TYPE cvp_id_type VALUE '1',
              lc_type_vendor   TYPE cvp_id_type VALUE '2',
              lc_type_contact  TYPE cvp_id_type VALUE '3',
              lc_bp_to_cust    TYPE CVP_SPECIFIC_PROCESS_DIRECTION VALUE 'ERPBP2CUST',
              lc_bp_to_vend    TYPE CVP_SPECIFIC_PROCESS_DIRECTION VALUE 'ERPBP2VEND'.


  IF it_partners_guid IS NOT INITIAL.

    CALL METHOD cvi_ctrl_loop=>get_instance
      IMPORTING
        er_object = lr_cvi_ka_bp_customer.

    CALL METHOD lr_cvi_ka_bp_customer->check_steps
      EXPORTING
        iv_source_object = 'BP'
        iv_target_object = 'CUSTOMER'
      IMPORTING
        ev_relevant      = lv_active_cust
*       ES_ERROR         =
      .


    CALL METHOD cvi_ctrl_loop=>get_instance
      IMPORTING
        er_object = lr_cvi_ka_bp_vendor.

    CALL METHOD lr_cvi_ka_bp_vendor->check_steps
      EXPORTING
        iv_source_object = 'BP'
        iv_target_object = 'VENDOR'
      IMPORTING
        ev_relevant      = lv_active_vend
*       ES_ERROR         =
      .

    IF lv_active_cust IS INITIAL AND lv_active_vend IS INITIAL.
      EXIT.
    ENDIF.

    IF lv_active_cust IS NOT INITIAL.
      SELECT  partner_guid customer FROM cvi_cust_link INTO TABLE lt_cvi_link_customer
                                             FOR ALL ENTRIES IN it_partners_guid
                                             WHERE partner_guid = it_partners_guid-partner_guid.

    ENDIF.

    IF lv_active_vend IS NOT INITIAL.
      SELECT  partner_guid vendor FROM cvi_vend_link INTO TABLE lt_cvi_link_vendor
                                             FOR ALL ENTRIES IN it_partners_guid
                                             WHERE partner_guid = it_partners_guid-partner_guid.

    ENDIF.
  ENDIF.

  IF lt_cvi_link_customer IS INITIAL AND lt_cvi_link_vendor IS INITIAL .
    EXIT.
  ENDIF.

  IF lt_cvi_link_customer IS NOT INITIAL.

    SELECT  partner_guid customer_cont  FROM cvi_cust_ct_link INTO TABLE lt_cvi_cust_ct_link
                                           FOR ALL ENTRIES IN lt_cvi_link_customer
                                           WHERE  partner_guid = lt_cvi_link_customer-partner_guid.

  ENDIF.

  IF lt_cvi_link_vendor IS NOT INITIAL.

    SELECT  partner_guid vendor_cont FROM cvi_vend_ct_link  INTO TABLE lt_cvi_vend_ct_link
                                           FOR ALL ENTRIES IN lt_cvi_link_vendor
                                           WHERE  partner_guid = lt_cvi_link_vendor-partner_guid.
  ENDIF.



  LOOP AT lt_cvi_link_customer  INTO ls_cvi_link_customer.
    ls_unblk_partner-id = ls_cvi_link_customer-customer.
    ls_unblk_partner-id_type = lc_type_customer.

    APPEND ls_unblk_partner TO lt_unblk_partner_cust.
  ENDLOOP.

  LOOP AT lt_cvi_link_vendor  INTO ls_cvi_link_vendor.
    ls_unblk_partner-id = ls_cvi_link_vendor-vendor.
    ls_unblk_partner-id_type = lc_type_vendor.

    APPEND ls_unblk_partner TO lt_unblk_partner_vend.
  ENDLOOP.

  LOOP AT lt_cvi_cust_ct_link  INTO ls_cvi_cust_ct_link.
    ls_unblk_partner-id = ls_cvi_cust_ct_link-customer_cont.
    ls_unblk_partner-id_type = lc_type_contact.

    APPEND ls_unblk_partner TO lt_unblk_partner_cust.
  ENDLOOP.

  LOOP AT lt_cvi_vend_ct_link INTO ls_cvi_vend_ct_link .
    ls_unblk_partner-id =  ls_cvi_vend_ct_link-vendor_cont.
    ls_unblk_partner-id_type = lc_type_contact.

    APPEND ls_unblk_partner TO lt_unblk_partner_vend.
  ENDLOOP.

  CALL FUNCTION 'BUPA_PREPARE_EOP_MODE_GET'
    IMPORTING
      ev_detlog = lv_detlog
      ev_tesrun = lv_testrun
      ev_applog = lv_applog.


  lv_test_mode        = lv_testrun.

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

*Call unblock fm of CVI
  CALL FUNCTION 'CVP_PROCESS_UNBLOCK' DESTINATION 'NONE'
    EXPORTING
      iv_test_mode                = lv_test_mode
      IV_PROCESS_DIRECTION        = lc_bp_to_cust
      iv_prot_output              = lv_prot_output
      iv_detail_log               = lv_detail_log
      it_unblock_partners         = lt_unblk_partner_cust
    IMPORTING
      et_unblock_partners_results = lt_unblk_bp_status_cust
      et_messages                 = lt_message.

*Call unblock fm of CVI
  CALL FUNCTION 'CVP_PROCESS_UNBLOCK' DESTINATION 'NONE'
    EXPORTING
      iv_test_mode                = lv_test_mode
      IV_PROCESS_DIRECTION        = lc_bp_to_vend
      iv_prot_output              = lv_prot_output
      iv_detail_log               = lv_detail_log
      it_unblock_partners         = lt_unblk_partner_vend
    IMPORTING
      et_unblock_partners_results = lt_unblk_bp_status_vend
      et_messages                 = lt_message.

  APPEND LINES OF lt_unblk_bp_status_cust TO lt_unblk_partner_status.
  APPEND LINES OF lt_unblk_bp_status_vend TO lt_unblk_partner_status.

  LOOP AT lt_unblk_partner_status INTO ls_unblk_partner  .

    CASE ls_unblk_partner-id_type.
      WHEN lc_type_customer.
        READ TABLE lt_cvi_link_customer INTO ls_cvi_link_customer WITH KEY customer = ls_unblk_partner-id.
        IF sy-subrc =  0 .
          ls_unblk_partner_return-partner_guid = ls_cvi_link_customer-partner_guid .
          ls_unblk_partner_return-appl_name = iv_appl.
          IF  ls_unblk_partner-status = 'A' .
            ls_unblk_partner_return-unblk_status = 'X' .
          ENDIF.
        ENDIF.

      WHEN lc_type_vendor .
        READ TABLE lt_cvi_link_vendor INTO ls_cvi_link_customer WITH KEY vendor = ls_unblk_partner-id.
        IF sy-subrc = 0 .
          ls_unblk_partner_return-partner_guid = ls_cvi_link_customer-partner_guid .
          ls_unblk_partner_return-appl_name = iv_appl.
          IF ls_unblk_partner-status = 'A' .
            ls_unblk_partner_return-unblk_status = 'X' .
          ENDIF.
        ENDIF.

      WHEN lc_type_contact .
        READ TABLE lt_cvi_cust_ct_link INTO ls_cvi_cust_ct_link WITH KEY customer_cont = ls_unblk_partner-id.
        IF sy-subrc = 0.
          ls_unblk_partner_return-partner_guid = ls_cvi_cust_ct_link-partner_guid .
          ls_unblk_partner_return-appl_name = iv_appl.
          IF ls_unblk_partner-status = 'A' .
            ls_unblk_partner_return-unblk_status = 'X' .
          ENDIF.

        ELSE.
          READ TABLE lt_cvi_vend_ct_link INTO ls_cvi_vend_ct_link WITH KEY vendor_cont = ls_unblk_partner-id.
          IF sy-subrc = 0 .
            ls_unblk_partner_return-partner_guid = ls_cvi_vend_ct_link-partner_guid .
            ls_unblk_partner_return-appl_name = iv_appl.
            IF  ls_unblk_partner-status = 'A' .
              ls_unblk_partner_return-unblk_status = 'X' .
            ENDIF.
          ENDIF.
        ENDIF.
    ENDCASE.

    READ TABLE it_partners_guid INTO ls_partners_guid  WITH KEY partner_guid = ls_unblk_partner_return-partner_guid.
    ls_unblk_partner_return-partner = ls_partners_guid-partner .
    APPEND ls_unblk_partner_return  TO et_unblk_status.
  ENDLOOP.

  MOVE-CORRESPONDING lt_message TO et_messages.


ENDFUNCTION.
