FUNCTION crm_if_bupa_purpose_export_w .
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_TIMESTAMP_BUS) TYPE  TIMESTAMP
*"     VALUE(IV_CHECKMODE) TYPE  BOOLE_D
*"     VALUE(IV_BLK_UNBLK_FLAG) TYPE  BLK_UNBLK_FLAG
*"     VALUE(IT_PARTNERS_GUID) TYPE  BU_PARTNERGUID_T
*"  CHANGING
*"     VALUE(CT_RETURN) TYPE  BUS_BAPIRET2_T
*"  EXCEPTIONS
*"      INITIAL_PARTNER
*"----------------------------------------------------------------------

*&---- Local constants and variables decleration
  CONSTANTS: lc_space TYPE char1 VALUE ' ',
             lc_x     TYPE char1 VALUE 'X',
             lc_b     TYPE blk_unblk_flag VALUE 'B',
             lc_u     TYPE blk_unblk_flag VALUE 'U',
             lc_cust  TYPE char1 VALUE '1',
             lc_vend  TYPE char1 VALUE '2',
             lc_cont  TYPE char1 VALUE '3'.

  TYPES: BEGIN OF ty_partnerguid,
           partner_guid TYPE  sychar32,
         END OF ty_partnerguid.

  DATA: lv_cust_relevant  TYPE boole_d,
        lv_vend_relevant  TYPE boole_d,
        lt_partner_guid   TYPE TABLE OF ty_partnerguid,
        ls_partner_guid   TYPE ty_partnerguid,
        ls_partners_guid  LIKE LINE OF it_partners_guid,
        lt_crmkunnr       TYPE TABLE OF crmkunnr,
        lt_crmlifnr       TYPE TABLE OF crmlifnr,
        lt_crmparnr       TYPE TABLE OF crmparnr,
        ls_crmkunnr       TYPE crmkunnr,
        ls_crmlifnr       TYPE crmlifnr,
        ls_crmparnr       TYPE crmparnr.
*        lt_cvi_vend_ct_link TYPE TABLE OF cvi_vend_ct_link,
*        ls_cvi_vend_ct_link TYPE cvi_vend_ct_link.

  DATA: lt_partners	      TYPE cvp_tt_eop_partner_purcmpl_exp,
        ls_partners       LIKE LINE OF lt_partners,
        lt_customers      TYPE cvp_tt_bukrs_kunnr,
        lt_vendors        TYPE cvp_tt_bukrs_lifnr,
        ls_customers      TYPE cvp_s_bukrs_kunnr,
        ls_vendors        TYPE cvp_s_bukrs_lifnr,
        lt_messages       TYPE cvp_tt_messages,
        ls_messages       LIKE LINE OF lt_messages.

*&--- Converting partners guid to customer guid format
  LOOP AT it_partners_guid INTO ls_partners_guid.
    ls_partner_guid-partner_guid = ls_partners_guid-partner_guid.
    APPEND ls_partner_guid TO lt_partner_guid.
  ENDLOOP.

  IF lt_partner_guid IS NOT INITIAL.
*----------------------------------------------------------------------*
*  Preparing customers and their contact persons data for unblocking   *
*----------------------------------------------------------------------*
*      IF lv_cust_relevant = 'X'.
*&--- Fetching customers linked to business partners
      SELECT * FROM crmkunnr INTO TABLE lt_crmkunnr
                                  FOR ALL ENTRIES IN lt_partner_guid
                                  WHERE partn_guid = lt_partner_guid-partner_guid.
      IF sy-subrc = 0.
*&--- Fetching blocked customers with company data
        IF iv_blk_unblk_flag = lc_b.
          SELECT bukrs kunnr FROM knb1 INTO TABLE lt_customers FOR ALL ENTRIES IN lt_crmkunnr
                                                               WHERE kunnr = lt_crmkunnr-custome_no
                                                               AND cvp_xblck_b = ' '.
        ELSEIF iv_blk_unblk_flag = lc_u.
          SELECT bukrs kunnr FROM knb1 INTO TABLE lt_customers FOR ALL ENTRIES IN lt_crmkunnr
                                                               WHERE kunnr = lt_crmkunnr-custome_no
                                                               AND cvp_xblck_b = 'X'.
        ENDIF.

        IF sy-subrc = 0.
          LOOP AT lt_customers INTO ls_customers.
            ls_partners-id = ls_customers-kunnr.
            ls_partners-id_type = lc_cust.
            ls_partners-bukrs = ls_customers-bukrs.
            APPEND ls_partners TO lt_partners.
          ENDLOOP.
        ENDIF.
*&--- Getting contact persons linked to customers
        SELECT * FROM crmparnr INTO TABLE lt_crmparnr FOR ALL ENTRIES IN lt_crmkunnr
                                                                      WHERE org_guid = lt_crmkunnr-partn_guid.
        IF sy-subrc = 0.
          LOOP AT lt_crmparnr INTO ls_crmparnr.
            ls_partners-id = ls_crmparnr-contact_no.
            ls_partners-id_type = lc_cont.
            APPEND ls_partners TO lt_partners.
          ENDLOOP.
        ENDIF.
*&--- Getting customers without company code.
        LOOP AT lt_crmkunnr INTO ls_crmkunnr.
          READ TABLE lt_customers TRANSPORTING NO FIELDS WITH KEY kunnr = ls_crmkunnr-custome_no.
          IF sy-subrc <> 0.
            ls_partners-id = ls_crmkunnr-custome_no.
            ls_partners-id_type = lc_cust.
            APPEND ls_partners TO lt_partners.
          ENDIF.
        ENDLOOP.
      ENDIF.
*      ENDIF.
*----------------------------------------------------------------------*
*  Preparing vendors and their contact persons data for unblocking     *
*----------------------------------------------------------------------*
*      IF lv_vend_relevant = 'X'.
*&--- Fetching vendors linked to business partners
      SELECT * FROM crmlifnr INTO TABLE lt_crmlifnr
                                  FOR ALL ENTRIES IN lt_partner_guid
                                  WHERE partn_guid = lt_partner_guid-partner_guid.
      IF sy-subrc = 0.
*&--- Fetching blocked vendors with company data
        IF iv_blk_unblk_flag = lc_b.
          SELECT bukrs lifnr FROM lfb1 INTO TABLE lt_vendors FOR ALL ENTRIES IN lt_crmlifnr
                                                               WHERE lifnr = lt_crmlifnr-vendor_no
                                                               AND cvp_xblck_b = ' '.
        ELSEIF iv_blk_unblk_flag = lc_u.
          SELECT bukrs lifnr FROM lfb1 INTO TABLE lt_vendors FOR ALL ENTRIES IN lt_crmlifnr
                                                               WHERE lifnr = lt_crmlifnr-vendor_no
                                                               AND cvp_xblck_b = 'X'.
        ENDIF.
        IF sy-subrc = 0.
          LOOP AT lt_vendors INTO ls_vendors.
            ls_partners-id = ls_vendors-lifnr.
            ls_partners-id_type = lc_vend.
            ls_partners-bukrs = ls_vendors-bukrs.
            APPEND ls_partners TO lt_partners.
          ENDLOOP.
        ENDIF.
*&--- Getting contact persons linked to vendors
        SELECT * FROM crmparnr INTO TABLE lt_crmparnr FOR ALL ENTRIES IN lt_crmlifnr
                                                                      WHERE org_guid = lt_crmlifnr-partn_guid.
        IF sy-subrc = 0.
          LOOP AT lt_crmparnr INTO ls_crmparnr.
            ls_partners-id = ls_crmparnr-contact_no.
            ls_partners-id_type = lc_cont.
            APPEND ls_partners TO lt_partners.
          ENDLOOP.
        ENDIF.
*&--- Getting vendors without company code.
        LOOP AT lt_crmlifnr INTO ls_crmlifnr.
          READ TABLE lt_vendors TRANSPORTING NO FIELDS WITH KEY lifnr = ls_crmlifnr-vendor_no.
          IF sy-subrc <> 0.
            ls_partners-id = ls_crmlifnr-vendor_no.
            ls_partners-id_type = lc_vend.
            APPEND ls_partners TO lt_partners.
          ENDIF.
        ENDLOOP.
      ENDIF.
*      ENDIF.

*      IF lv_vend_relevant = 'X' OR lv_cust_relevant = 'X'.
*&--- Checking contact persons only
      SELECT * FROM crmparnr INTO TABLE lt_crmparnr FOR ALL ENTRIES IN lt_partner_guid
                                                                    WHERE org_guid = lt_partner_guid-partner_guid.
      IF sy-subrc = 0.
        LOOP AT lt_crmparnr INTO ls_crmparnr.
          ls_partners-id = ls_crmparnr-contact_no.
          ls_partners-id_type = lc_cont.
          APPEND ls_partners TO lt_partners.
        ENDLOOP.
      ENDIF.
*      ENDIF.

      IF iv_blk_unblk_flag = lc_b.
*&---- Blocking customers,vendors and contact persons
        CALL METHOD cvp_cl_block_partner=>block
          EXPORTING
            it_partners               = lt_partners     " Master data IDs for blocking export interface
          IMPORTING
            et_messages               = lt_messages    " Result Log messages
          EXCEPTIONS
            initial_partner           = 1
            no_blocking_authorisation = 2
            OTHERS                    = 3.
        IF sy-subrc <> 0.
*         MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        ENDIF.
      ELSEIF iv_blk_unblk_flag = lc_u.
*&---- Unblocking customers,vendors and contact persons
        CALL METHOD cvp_cl_block_partner=>unblock
          EXPORTING
            it_partners                 = lt_partners   " Master data IDs for blocking export interface
          IMPORTING
            et_messages                 = lt_messages   " Result Log messages
          EXCEPTIONS
            initial_partner             = 1
            no_unblocking_authorisation = 2
            OTHERS                      = 3.
        IF sy-subrc <> 0.
*         MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        ENDIF.
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
    RAISE initial_partner.
  ENDIF.
ENDFUNCTION.
