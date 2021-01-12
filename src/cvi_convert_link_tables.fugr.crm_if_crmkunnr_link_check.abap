FUNCTION crm_if_crmkunnr_link_check.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  CHANGING
*"     VALUE(CT_PARTNER) TYPE  BUP_PARTNER_GUID_T
*"----------------------------------------------------------------------

  TYPES: BEGIN OF ty_guid,
           partner      TYPE kunnr,
           partner_guid TYPE sychar32,
         END OF ty_guid.

   TYPES : BEGIN OF ty_but000,
            partner TYPE bu_partner,
            partner_guid TYPE BU_PARTNER_GUID,
           END OF ty_but000.

  DATA: lt_guid TYPE TABLE OF ty_guid,
        ls_guid TYPE ty_guid,

        lt_guid1 TYPE TABLE OF ty_but000,
        ls_guid1 TYPE ty_but000,

        lt_but000 TYPE TABLE OF ty_but000,
        ls_but000 TYPE ty_but000.

  DATA : lt_crmkunnr  TYPE TABLE OF crmkunnr,
         ls_crmkunnr  TYPE crmkunnr,
         lt_crmlifnr  TYPE TABLE OF crmlifnr,
         ls_crmlifnr  TYPE crmlifnr,
         lt_crmparnr  TYPE TABLE OF crmparnr,
         ls_crmparnr  TYPE crmparnr,
         lt_crm_guid  TYPE TABLE OF crmkunnr,
         ls_crm_guid  TYPE crmkunnr,
         ls_partner   LIKE LINE OF ct_partner,
         lt_partner_t TYPE bup_partner_guid_t,
         ls_partner_t TYPE bupa_partner_guid.

  DATA: lv_cust_not_found TYPE char1,
        lv_vend_not_found TYPE char1,
        lv_cont_not_found TYPE char1,
        lv_but000_not_found TYPE char1.

  LOOP AT ct_partner INTO ls_partner.
    ls_guid-partner = ls_partner-partner.
    ls_guid-partner_guid = ls_partner-partner_guid.

    ls_guid1-partner = ls_partner-partner.
    ls_guid1-partner_guid = ls_partner-partner_guid.

    APPEND ls_guid TO lt_guid.
    APPEND ls_guid1 TO lt_guid1.
    CLEAR: ls_partner,ls_guid,ls_guid1.
  ENDLOOP.

  CLEAR ct_partner.
  IF lt_guid IS NOT INITIAL.
    SELECT * FROM crmkunnr INTO TABLE lt_crmkunnr
                                   FOR ALL ENTRIES IN lt_guid
                                   WHERE partn_guid = lt_guid-partner_guid.

  SELECT * FROM crmlifnr INTO TABLE lt_crmlifnr
                         FOR ALL ENTRIES IN lt_guid
                         WHERE partn_guid = lt_guid-partner_guid.

  SELECT * FROM crmparnr INTO TABLE lt_crmparnr
                         FOR ALL ENTRIES IN lt_guid
                         WHERE person_gui = lt_guid-partner_guid.

  ENDIF.

  IF lt_guid1 IS NOT INITIAL.
    SELECT partner partner_guid FROM BUT000 INTO TABLE lt_but000
                         FOR ALL ENTRIES IN lt_guid1
                         WHERE partner_guid = lt_guid1-partner_guid.
  ENDIF.

  LOOP AT lt_guid INTO ls_guid.

    READ TABLE lt_crmkunnr INTO ls_crmkunnr WITH KEY partn_guid = ls_guid-partner_guid.
    IF sy-subrc <> 0.
      lv_cust_not_found = 'X'.
    ENDIF.

    READ TABLE lt_crmlifnr INTO ls_crmlifnr WITH KEY partn_guid = ls_guid-partner_guid.
    IF sy-subrc <> 0.
      lv_vend_not_found = 'X'.
    ENDIF.

    READ TABLE lt_crmparnr INTO ls_crmparnr WITH KEY person_gui = ls_guid-partner_guid.
    IF sy-subrc <> 0.
      lv_cont_not_found = 'X'.
    ENDIF.

    READ TABLE lt_but000 INTO ls_but000 WITH KEY partner_guid = ls_guid-partner_guid.
    IF sy-subrc <> 0.
      lv_but000_not_found = 'X'.
    ENDIF.

    IF lv_cust_not_found IS NOT INITIAL AND lv_vend_not_found IS NOT INITIAL
      AND lv_cont_not_found IS NOT INITIAL AND lv_but000_not_found IS NOT INITIAL.
      ls_partner_t-partner = ls_guid-partner.
      ls_partner_t-partner_guid = ls_guid-partner_guid.
      APPEND ls_partner_t TO ct_partner.

      CLEAR: ls_guid,ls_partner_t, lv_cust_not_found, lv_vend_not_found,
             lv_cont_not_found, lv_but000_not_found.
    ENDIF.
  ENDLOOP.
ENDFUNCTION.
