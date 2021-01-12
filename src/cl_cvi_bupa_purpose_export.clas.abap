class CL_CVI_BUPA_PURPOSE_EXPORT definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_BUPA_PURPOSE_EXPORT .
protected section.
private section.
ENDCLASS.



CLASS CL_CVI_BUPA_PURPOSE_EXPORT IMPLEMENTATION.


  METHOD if_bupa_purpose_export~bupa_purcompl_export.
*&---- Local constants and variables decleration

    CONSTANTS: lc_space TYPE char1 VALUE ' ',
               lc_x     TYPE char1 VALUE 'X',
               lc_cust  TYPE char1 VALUE '1',
               lc_vend  TYPE char1 VALUE '2',
               lc_cont  TYPE char1 VALUE '3'.

    TYPES: BEGIN OF ty_knb1,
             kunnr TYPE kunnr,
             bukrs TYPE bukrs,
           END OF ty_knb1,

           BEGIN OF ty_lfb1,
             lifnr TYPE lifnr,
             bukrs TYPE bukrs,
           END OF ty_lfb1.

    DATA: lr_cvi_ctrl_loop    TYPE REF TO cvi_ctrl_loop,
          lv_cust_relevant    TYPE boole_d,
          lv_vend_relevant    TYPE boole_d,
          lt_partner_guid     TYPE bup_partner_guid_t,
          ls_partner_guid     TYPE bupa_partner_guid,
          lt_cvi_cust_link    TYPE TABLE OF cvi_cust_link,
          ls_cvi_cust_link    TYPE cvi_cust_link,
          lt_cvi_vend_link    TYPE TABLE OF cvi_vend_link,
          ls_cvi_vend_link    TYPE cvi_vend_link,
          lt_cvi_cust_ct_link TYPE TABLE OF cvi_cust_ct_link,
          ls_cvi_cust_ct_link TYPE cvi_cust_ct_link,
          lt_cvi_vend_ct_link TYPE TABLE OF cvi_vend_ct_link,
          ls_cvi_vend_ct_link TYPE cvi_vend_ct_link,
          lt_knb1             TYPE TABLE OF ty_knb1,
          ls_knb1             TYPE ty_knb1,
          lt_cvp_partners     TYPE cvp_tt_eop_partner_purcmpl_exp,
          ls_cvp_partners     TYPE cvp_s_eop_partner_purcmpl_exp,
          lt_messages         TYPE cvp_tt_messages,
          ls_messages         TYPE cvp_s_message,
          lt_lfb1             TYPE TABLE OF ty_lfb1,
          ls_lfb1             TYPE ty_lfb1,
          lt_cvi_cust_cont    TYPE TABLE OF cvi_cust_ct_link,
          ls_cvi_cust_cont    TYPE cvi_cust_ct_link,
          lt_cvi_vend_cont    TYPE TABLE OF cvi_vend_ct_link,
          ls_cvi_vend_cont    TYPE cvi_vend_ct_link,
          lt_cust             TYPE bupa_cust_tt,
          ls_cust             TYPE bupa_cust,
          lt_partner_isu      TYPE bup_partner_guid_t,
          ls_partner_isu      TYPE bupa_partner_guid,
          ls_butsort          TYPE butsort.

    DATA: lt_active_options TYPE mds_ctrls_sync_opt_act,
          ls_error          TYPE mds_ctrls_error.

    DATA: badi_isu_obj_mapping TYPE REF TO badi_bp_isu_obj_mapping,
          oref                 TYPE REF TO cx_root.


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


*---Avoiding loop call and checking synchronization is active or not.

**** determine active synchronisation steps to source object
    CALL METHOD mds_ctrl_customizing=>act_steps_sync_object_read
      EXPORTING
        iv_source_object  = 'BP'
      IMPORTING
        et_active_options = lt_active_options
        es_error          = ls_error.

    IF ls_error-is_error = 'X'.
      EXIT.
    ENDIF.

**** Check if active synchronization exist.
    READ TABLE lt_active_options  WITH KEY
                     sync_obj_source = 'BP'
                     sync_obj_target = 'CUSTOMER'
                     TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      lv_cust_relevant = 'X'.
    ENDIF.

**** Check if active synchronization exist.
    READ TABLE lt_active_options  WITH KEY
                     sync_obj_source = 'BP'
                     sync_obj_target = 'VENDOR'
                     TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      lv_vend_relevant = 'X'.
    ENDIF.

*&---- Fetching GUID for all business partners.
    IF it_butsort IS NOT INITIAL.
      SELECT partner partner_guid FROM but000 INTO TABLE lt_partner_guid
                                  FOR ALL ENTRIES IN it_butsort
                                  WHERE partner = it_butsort-partner.

      IF sy-subrc = 0.
        IF lv_cust_relevant IS NOT INITIAL OR lv_vend_relevant IS NOT INITIAL.
          IF lv_cust_relevant = lc_x.

* --------------- To get the Customer Data------------------------
*&--- Customers linked to business partners
            SELECT * FROM cvi_cust_link INTO TABLE lt_cvi_cust_link
                                        FOR ALL ENTRIES IN lt_partner_guid
                                        WHERE partner_guid = lt_partner_guid-partner_guid.
            IF sy-subrc = 0.
*&----- To Collect the Customers without Company Code (KNA1)
              LOOP AT lt_cvi_cust_link INTO ls_cvi_cust_link.
                ls_cvp_partners-id = ls_cvi_cust_link-customer.
                ls_cvp_partners-id_type = lc_cust.

                APPEND ls_cvp_partners TO lt_cvp_partners.
                CLEAR: ls_cvp_partners, ls_cvi_cust_link.
              ENDLOOP.
            ENDIF.

*&--- Contact Persons of Customers
            IF lt_cvi_cust_link IS NOT INITIAL.
              SELECT * FROM cvi_cust_ct_link INTO TABLE lt_cvi_cust_cont
                                             FOR ALL ENTRIES IN lt_cvi_cust_link
                                             WHERE partner_guid = lt_cvi_cust_link-partner_guid.
              IF sy-subrc = 0.
*&----- To Collect the Contact Persons of Customers
                LOOP AT lt_cvi_cust_cont INTO ls_cvi_cust_cont.
                  ls_cvp_partners-id = ls_cvi_cust_cont-customer_cont.
                  ls_cvp_partners-id_type = lc_cont.

                  APPEND ls_cvp_partners TO lt_cvp_partners.
                  CLEAR: ls_cvp_partners, ls_cvi_cust_cont.
                ENDLOOP.
              ENDIF.
            ENDIF.

*&--- Contact Persons linked to business partners
            SELECT * FROM cvi_cust_ct_link INTO TABLE lt_cvi_cust_ct_link
                                           FOR ALL ENTRIES IN lt_partner_guid
                                           WHERE person_guid = lt_partner_guid-partner_guid.
            IF sy-subrc = 0.
*&----- To Collect Contact Persons linked to Business Partner
              LOOP AT lt_cvi_cust_ct_link INTO ls_cvi_cust_ct_link.
                ls_cvp_partners-id = ls_cvi_cust_ct_link-customer_cont.
                ls_cvp_partners-id_type = lc_cont.

                APPEND ls_cvp_partners TO lt_cvp_partners.
                CLEAR: ls_cvi_cust_ct_link, ls_cvp_partners.
              ENDLOOP.
            ENDIF.

*&--- To get the Corresponding Company Codes of Customers
            IF lt_cvi_cust_link IS NOT INITIAL.
              SELECT kunnr bukrs FROM knb1 INTO TABLE lt_knb1
                                       FOR ALL ENTRIES IN lt_cvi_cust_link
                                       WHERE kunnr = lt_cvi_cust_link-customer
                                       AND cvp_xblck_b = ' '.
              IF sy-subrc = 0.
*&----- To collect the Customer Numbers along with Company Code (KNB1)
                LOOP AT lt_knb1 INTO ls_knb1.
                  ls_cvp_partners-id = ls_knb1-kunnr.
                  ls_cvp_partners-id_type = lc_cust.
                  ls_cvp_partners-bukrs = ls_knb1-bukrs.

                  APPEND ls_cvp_partners TO lt_cvp_partners.
                  CLEAR: ls_knb1, ls_cvp_partners.
                ENDLOOP.
              ENDIF.
            ENDIF.
          ENDIF.

* --------------- To get the Vendor Data------------------------
          IF lv_vend_relevant = lc_x.
*&--- Vendors linked to business partners
            SELECT * FROM cvi_vend_link INTO TABLE lt_cvi_vend_link
                                        FOR ALL ENTRIES IN lt_partner_guid
                                        WHERE partner_guid = lt_partner_guid-partner_guid.
            IF sy-subrc = 0.
*&----- To Collect the Vendors without Company Code (LFA1)
              LOOP AT lt_cvi_vend_link INTO ls_cvi_vend_link.
                ls_cvp_partners-id = ls_cvi_vend_link-vendor.
                ls_cvp_partners-id_type = lc_vend.

                APPEND ls_cvp_partners TO lt_cvp_partners.
                CLEAR: ls_cvp_partners, ls_cvi_vend_link.
              ENDLOOP.
            ENDIF.

*&--- Contact Persons Of Vendors
            IF lt_cvi_vend_link IS NOT INITIAL.
              SELECT * FROM cvi_vend_ct_link INTO TABLE lt_cvi_vend_cont
                                             FOR ALL ENTRIES IN lt_cvi_vend_link
                                             WHERE partner_guid = lt_cvi_vend_link-partner_guid.
              IF sy-subrc = 0.
*&----- To Collect the Contact Persons of Vendors
                LOOP AT lt_cvi_vend_cont INTO ls_cvi_vend_cont.
                  ls_cvp_partners-id = ls_cvi_vend_cont-vendor_cont.
                  ls_cvp_partners-id_type = lc_cont.

                  APPEND ls_cvp_partners TO lt_cvp_partners.
                  CLEAR: ls_cvp_partners, ls_cvi_vend_cont.
                ENDLOOP.
              ENDIF.
            ENDIF.

*&--- Contact Persons of Vendors linked to business partners
            SELECT * FROM cvi_vend_ct_link INTO TABLE lt_cvi_vend_ct_link
                                           FOR ALL ENTRIES IN lt_partner_guid
                                           WHERE person_guid = lt_partner_guid-partner_guid. "#EC CI_NOFIRST

            IF sy-subrc = 0.
*&----- To Collect Contact Persons linked to Business Partner
              LOOP AT lt_cvi_vend_ct_link INTO ls_cvi_vend_ct_link.
                ls_cvp_partners-id = ls_cvi_vend_ct_link-vendor_cont.
                ls_cvp_partners-id_type = lc_cont.

                APPEND ls_cvp_partners TO lt_cvp_partners.
                CLEAR: ls_cvi_vend_ct_link, ls_cvp_partners.
              ENDLOOP.
            ENDIF.

          ENDIF.

*&--- To get the Corresponding Company Codes of Vendors
          IF lt_cvi_vend_link IS NOT INITIAL.
            SELECT lifnr bukrs FROM lfb1 INTO TABLE lt_lfb1
                                     FOR ALL ENTRIES IN lt_cvi_vend_link
                                     WHERE lifnr = lt_cvi_vend_link-vendor
                                     AND cvp_xblck_b = ' '.

            IF sy-subrc = 0.
*&----- To collect the Vendor Numbers along with Company Code (LFB1)
              LOOP AT lt_lfb1 INTO ls_lfb1.
                ls_cvp_partners-id = ls_lfb1-lifnr.
                ls_cvp_partners-id_type = lc_vend.
                ls_cvp_partners-bukrs = ls_lfb1-bukrs.

                APPEND ls_cvp_partners TO lt_cvp_partners.
                CLEAR: ls_lfb1, ls_cvp_partners.
              ENDLOOP.
            ENDIF.
          ENDIF.

*&--- Manage master data
          IF lt_cvp_partners IS NOT INITIAL.

            CALL METHOD cvp_cl_block_partner=>block
              EXPORTING
                it_partners               = lt_cvp_partners
                IV_UPD_TASK_MODE          = 'X'
                IV_CHECK_PURPOSE_COMPLETE = 'X'
              IMPORTING
                et_messages               = lt_messages
              EXCEPTIONS
                initial_partner           = 1
                no_blocking_authorisation = 2
                OTHERS                    = 3.

*&--- Updating error massages
            IF lt_messages IS NOT INITIAL.
              LOOP AT lt_messages INTO ls_messages.
                APPEND LINES OF ls_messages-messages TO ct_return.
                CLEAR ls_messages.
              ENDLOOP.
            ENDIF.
          ENDIF.

        ELSE.

          LOOP AT lt_partner_guid INTO ls_partner_guid.
            ls_partner_isu-partner      = ls_partner_guid-partner.
            ls_partner_isu-partner_guid = ls_partner_guid-partner_guid.

            APPEND ls_partner_isu TO lt_partner_isu.
            CLEAR: ls_partner_guid, ls_partner_isu.
          ENDLOOP.

          TRY.
              GET BADI badi_isu_obj_mapping.
              CALL BADI badi_isu_obj_mapping->map_partner_to_cust
                EXPORTING
                  lt_partner_guid = lt_partner_isu
                IMPORTING
                  lt_partner      = lt_cust.
            CATCH cx_root INTO oref.
              EXIT.
          ENDTRY.

          SELECT kunnr bukrs FROM knb1 INTO TABLE lt_knb1
                                       FOR ALL ENTRIES IN lt_cust
                                       WHERE kunnr = lt_cust-kunnr
                                         AND cvp_xblck_b = ' '.

          LOOP AT lt_cust INTO ls_cust.
            ls_cvp_partners-id = ls_cust-kunnr.
            ls_cvp_partners-id_type = lc_cust.

            READ TABLE lt_knb1 INTO ls_knb1 WITH KEY kunnr = ls_cust-kunnr.
            IF sy-subrc = 0.
              ls_cvp_partners-bukrs = ls_knb1-bukrs.
            ENDIF.

            APPEND ls_cvp_partners TO lt_cvp_partners.
            CLEAR: ls_cust, ls_cvp_partners.
          ENDLOOP.

*&--- Manage master data
          IF lt_cvp_partners IS NOT INITIAL.

            CALL METHOD cvp_cl_block_partner=>block
              EXPORTING
                it_partners               = lt_cvp_partners
                IV_UPD_TASK_MODE          = 'X'
                IV_CHECK_PURPOSE_COMPLETE = 'X'
              IMPORTING
                et_messages               = lt_messages
              EXCEPTIONS
                initial_partner           = 1
                no_blocking_authorisation = 2
                OTHERS                    = 3.

*&--- Updating error massages
            IF lt_messages IS NOT INITIAL.
              LOOP AT lt_messages INTO ls_messages.
                APPEND LINES OF ls_messages-messages TO ct_return.
                CLEAR ls_messages.
              ENDLOOP.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
  ENDMETHOD.


  METHOD if_bupa_purpose_export~bupa_purreset_export.

*&---- Local constants and variables decleration
    CONSTANTS: lc_space TYPE char1 VALUE ' ',
               lc_x     TYPE char1 VALUE 'X',
               lc_cust  TYPE char1 VALUE '1',
               lc_vend  TYPE char1 VALUE '2',
               lc_cont  TYPE char1 VALUE '3'.

    DATA: lr_cvi_ctrl_loop    TYPE REF TO cvi_ctrl_loop,
          lv_cust_relevant    TYPE boole_d,
          lv_vend_relevant    TYPE boole_d,
          lt_partner_guid     TYPE bup_partner_guid_t,
          ls_partner_guid     TYPE bupa_partner_guid,
          lt_cvi_cust_link    TYPE TABLE OF cvi_cust_link,
          lt_cvi_cust_ct_link TYPE TABLE OF cvi_cust_ct_link,
          ls_cvi_cust_link    TYPE cvi_cust_link,
          ls_cvi_cust_ct_link TYPE cvi_cust_ct_link,
          lt_cvi_vend_link    TYPE TABLE OF cvi_vend_link,
          lt_cvi_vend_ct_link TYPE TABLE OF cvi_vend_ct_link,
          ls_cvi_vend_link    TYPE cvi_vend_link,
          ls_cvi_vend_ct_link TYPE cvi_vend_ct_link,
          lt_cust             TYPE bupa_cust_tt,
          ls_cust             TYPE bupa_cust,
          lt_partner_isu      TYPE bup_partner_guid_t,
          ls_partner_isu      TYPE bupa_partner_guid,
          ls_butsort          TYPE butsort.

    DATA: badi_isu_obj_mapping TYPE REF TO badi_bp_isu_obj_mapping,
          oref                 TYPE REF TO cx_root.

    DATA: lt_partners	 TYPE cvp_tt_eop_partner_purcmpl_exp,
          ls_partners  LIKE LINE OF lt_partners,
          lt_customers TYPE cvp_tt_bukrs_kunnr,
          lt_vendors   TYPE cvp_tt_bukrs_lifnr,
          ls_customers TYPE cvp_s_bukrs_kunnr,
          ls_vendors   TYPE cvp_s_bukrs_lifnr,
          lt_messages  TYPE cvp_tt_messages,
          ls_messages  LIKE LINE OF lt_messages.

    DATA: lt_active_options TYPE mds_ctrls_sync_opt_act,
          lv_relevant       TYPE boole_d,
          ls_error          TYPE mds_ctrls_error.

*---Avoiding loop call and checking synchronization is active or not.

**** determine active synchronisation steps to source object
    CALL METHOD mds_ctrl_customizing=>act_steps_sync_object_read
      EXPORTING
        iv_source_object  = 'BP'
      IMPORTING
        et_active_options = lt_active_options
        es_error          = ls_error.

    IF ls_error-is_error = 'X'.
      EXIT.
    ENDIF.

**** Check if active synchronization exist.
    READ TABLE lt_active_options  WITH KEY
                     sync_obj_source = 'BP'
                     sync_obj_target = 'CUSTOMER'
                     TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      lv_cust_relevant = 'X'.
    ENDIF.

**** Check if active synchronization exist.
    READ TABLE lt_active_options  WITH KEY
                     sync_obj_source = 'BP'
                     sync_obj_target = 'VENDOR'
                     TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      lv_vend_relevant = 'X'.
    ENDIF.

    IF it_partners IS NOT INITIAL.
*&---- Fetching GUID for all business partners.
      SELECT partner partner_guid FROM but000 INTO TABLE lt_partner_guid
                                  FOR ALL ENTRIES IN it_partners
                                  WHERE partner = it_partners-partner.
      IF sy-subrc = 0.
        IF lv_cust_relevant IS NOT INITIAL OR lv_vend_relevant IS NOT INITIAL.
*----------------------------------------------------------------------*
*  Preparing customers and their contact persons data for unblocking   *
*----------------------------------------------------------------------*
          IF lv_cust_relevant = 'X'.
*&--- Fetching customers linked to business partners
            SELECT * FROM cvi_cust_link INTO TABLE lt_cvi_cust_link
                                        FOR ALL ENTRIES IN lt_partner_guid
                                        WHERE partner_guid = lt_partner_guid-partner_guid.
            IF sy-subrc = 0.
*&--- Fetching blocked customers with company data
              SELECT bukrs kunnr FROM knb1 INTO TABLE lt_customers FOR ALL ENTRIES IN lt_cvi_cust_link
                                                                   WHERE kunnr = lt_cvi_cust_link-customer
                                                                   AND cvp_xblck_b = 'X'.

              IF sy-subrc = 0.
                LOOP AT lt_customers INTO ls_customers.
                  ls_partners-id = ls_customers-kunnr.
                  ls_partners-id_type = lc_cust.
                  ls_partners-bukrs = ls_customers-bukrs.
                  APPEND ls_partners TO lt_partners.
                ENDLOOP.
              ENDIF.
*&--- Getting contact persons linked to customers
              SELECT * FROM cvi_cust_ct_link INTO TABLE lt_cvi_cust_ct_link FOR ALL ENTRIES IN lt_cvi_cust_link
                                                                            WHERE partner_guid = lt_cvi_cust_link-partner_guid.
              IF sy-subrc = 0.
                LOOP AT lt_cvi_cust_ct_link INTO ls_cvi_cust_ct_link.
                  ls_partners-id = ls_cvi_cust_ct_link-customer_cont.
                  ls_partners-id_type = lc_cont.
                  APPEND ls_partners TO lt_partners.
                ENDLOOP.
              ENDIF.
*&--- Getting customers without company code.
              LOOP AT lt_cvi_cust_link INTO ls_cvi_cust_link.
                READ TABLE lt_customers TRANSPORTING NO FIELDS WITH KEY kunnr = ls_cvi_cust_link-customer.
                IF sy-subrc <> 0.
                  ls_partners-id = ls_cvi_cust_link-customer.
                  ls_partners-id_type = lc_cust.
                  APPEND ls_partners TO lt_partners.
                ENDIF.
              ENDLOOP.
            ENDIF.
*&--- Checking customer contact persons only
            SELECT * FROM cvi_cust_ct_link INTO TABLE lt_cvi_cust_ct_link FOR ALL ENTRIES IN lt_partner_guid
                                                                          WHERE partner_guid = lt_partner_guid-partner_guid.
            IF sy-subrc = 0.
              LOOP AT lt_cvi_cust_ct_link INTO ls_cvi_cust_ct_link.
                ls_partners-id = ls_cvi_cust_ct_link-customer_cont.
                ls_partners-id_type = lc_cont.
                APPEND ls_partners TO lt_partners.
              ENDLOOP.
            ENDIF.
          ENDIF.
*----------------------------------------------------------------------*
*  Preparing vendors and their contact persons data for unblocking     *
*----------------------------------------------------------------------*
          IF lv_vend_relevant = 'X'.
*&--- Fetching vendors linked to business partners
            SELECT * FROM cvi_vend_link INTO TABLE lt_cvi_vend_link
                                        FOR ALL ENTRIES IN lt_partner_guid
                                        WHERE partner_guid = lt_partner_guid-partner_guid.
            IF sy-subrc = 0.
*&--- Fetching blocked vendors with company data
              SELECT bukrs lifnr FROM lfb1 INTO TABLE lt_vendors FOR ALL ENTRIES IN lt_cvi_vend_link
                                                                   WHERE lifnr = lt_cvi_vend_link-vendor
                                                                   AND cvp_xblck_b = 'X'.

              IF sy-subrc = 0.
                LOOP AT lt_vendors INTO ls_vendors.
                  ls_partners-id = ls_vendors-lifnr.
                  ls_partners-id_type = lc_vend.
                  ls_partners-bukrs = ls_vendors-bukrs.
                  APPEND ls_partners TO lt_partners.
                ENDLOOP.
              ENDIF.
*&--- Getting contact persons linked to vendors
              SELECT * FROM cvi_vend_ct_link INTO TABLE lt_cvi_vend_ct_link FOR ALL ENTRIES IN lt_cvi_vend_link
                                                                            WHERE partner_guid = lt_cvi_vend_link-partner_guid.
              IF sy-subrc = 0.
                LOOP AT lt_cvi_vend_ct_link INTO ls_cvi_vend_ct_link.
                  ls_partners-id = ls_cvi_vend_ct_link-vendor_cont.
                  ls_partners-id_type = lc_cont.
                  APPEND ls_partners TO lt_partners.
                ENDLOOP.
              ENDIF.
*&--- Getting vendors without company code.
              LOOP AT lt_cvi_vend_link INTO ls_cvi_vend_link.
                READ TABLE lt_vendors TRANSPORTING NO FIELDS WITH KEY lifnr = ls_cvi_vend_link-vendor.
                IF sy-subrc <> 0.
                  ls_partners-id = ls_cvi_vend_link-vendor.
                  ls_partners-id_type = lc_vend.
                  APPEND ls_partners TO lt_partners.
                ENDIF.
              ENDLOOP.
            ENDIF.
*&--- Checking vendor contact persons only
            SELECT * FROM cvi_vend_ct_link INTO TABLE lt_cvi_vend_ct_link FOR ALL ENTRIES IN lt_partner_guid
                                                                          WHERE partner_guid = lt_partner_guid-partner_guid.
            IF sy-subrc = 0.
              LOOP AT lt_cvi_vend_ct_link INTO ls_cvi_vend_ct_link.
                ls_partners-id = ls_cvi_vend_ct_link-vendor_cont.
                ls_partners-id_type = lc_cont.
                APPEND ls_partners TO lt_partners.
              ENDLOOP.
            ENDIF.
          ENDIF.
*&---- Unblocking customers,vendors and contact persons
          CALL METHOD cvp_cl_block_partner=>unblock
            EXPORTING
              it_partners                 = lt_partners
              IV_UPD_TASK_MODE            = 'X'
            IMPORTING
              et_messages                 = lt_messages
            EXCEPTIONS
              initial_partner             = 1
              no_unblocking_authorisation = 2
              OTHERS                      = 3.
          IF sy-subrc <> 0.
*         Implement suitable error handling here
          ENDIF.
          LOOP AT lt_messages INTO ls_messages.
            IF ls_messages-return IS NOT INITIAL.
              APPEND ls_messages-return TO ct_return.
            ENDIF.
            IF ls_messages-messages IS NOT INITIAL.
              APPEND LINES OF ls_messages-messages TO ct_return.
            ENDIF.
          ENDLOOP.

        ELSE.

          LOOP AT lt_partner_guid INTO ls_partner_guid.
            ls_partner_isu-partner      = ls_partner_guid-partner.
            ls_partner_isu-partner_guid = ls_partner_guid-partner_guid.

            APPEND ls_partner_isu TO lt_partner_isu.
            CLEAR: ls_partner_guid, ls_partner_isu.
          ENDLOOP.

*&&&&------ Get the linked customers
          TRY.
              GET BADI badi_isu_obj_mapping.
              CALL BADI badi_isu_obj_mapping->map_partner_to_cust
                EXPORTING
                  lt_partner_guid = lt_partner_isu
                IMPORTING
                  lt_partner      = lt_cust.
            CATCH cx_root INTO oref.
              EXIT.
          ENDTRY.

*&&&&------ Get the Company Code of the Customer
          SELECT kunnr bukrs FROM knb1 INTO TABLE lt_customers
                                       FOR ALL ENTRIES IN lt_cust
                                       WHERE kunnr = lt_cust-kunnr
                                         AND cvp_xblck_b = 'X'.

          LOOP AT lt_cust INTO ls_cust.
            ls_partners-id = ls_cust-kunnr.
            ls_partners-id_type = lc_cust.

            READ TABLE lt_customers INTO ls_customers WITH KEY kunnr = ls_cust-kunnr.
            IF sy-subrc = 0.
              ls_partners-bukrs = ls_customers-bukrs.
            ENDIF.

            APPEND ls_partners TO lt_partners.
            CLEAR: ls_cust, ls_partners.
          ENDLOOP.

*&---- Unblocking customers,vendors and contact persons
          IF lt_partners IS NOT INITIAL.
            CALL METHOD cvp_cl_block_partner=>unblock
              EXPORTING
                it_partners                 = lt_partners
                IV_UPD_TASK_MODE            = 'X'
              IMPORTING
                et_messages                 = lt_messages
              EXCEPTIONS
                initial_partner             = 1
                no_unblocking_authorisation = 2
                OTHERS                      = 3.
            IF sy-subrc <> 0.
*         Implement suitable error handling here
            ENDIF.
            LOOP AT lt_messages INTO ls_messages.
              IF ls_messages-return IS NOT INITIAL.
                APPEND ls_messages-return TO ct_return.
              ENDIF.
              IF ls_messages-messages IS NOT INITIAL.
                APPEND LINES OF ls_messages-messages TO ct_return.
              ENDIF.
            ENDLOOP.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
