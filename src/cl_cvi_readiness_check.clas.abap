class CL_CVI_READINESS_CHECK definition
  public
  final
  create public .

public section.

  types:
    BEGIN OF ty_rc_business_check_errcount,
        totalcount  TYPE int4,  " total number of customer/vendor in system
        contactpers TYPE int4,
        unsynccount TYPE int4,  " Unconverted BP(cvi_cust_link,cvi_vend_link)
        taxcode     TYPE int4,
        email       TYPE int4,
        transzone   TYPE int4,
        postalcode  TYPE int4,
        taxjurd     TYPE int4,
        address     TYPE int4,
        bank        TYPE int4,
        industry    TYPE int4,
        numrange    TYPE int4,
        Accgroup    TYPE int4,
        unsynccontact TYPE int4, " total number of unsynchronized contact persons
        totalerrors   TYPE int4, " total number of inconsistencies in the system (in business checks)
      END OF ty_rc_business_check_errcount .
  types:
    BEGIN OF ty_rc_custom_fields,
        tabname      TYPE tabname,
        append_count TYPE int4,
        field_count  TYPE int4,
      END OF ty_rc_custom_fields .
  types:
    tt_rc_custom_fields TYPE STANDARD TABLE OF ty_rc_custom_fields .
  types:
    tt_rangetab_kunnr TYPE RANGE OF kunnr .
  types:
    tt_rangetab_lifnr TYPE RANGE OF lifnr .
  types:
    tt_ext_append_range TYPE RANGE OF ddappendnm .
  types:
    tt_ext_field_range TYPE RANGE OF  fieldname .

  class-methods PROCESS_RC_DATA
    exporting
      !ES_ERRCOUNT_CUSTOMER type TY_RC_BUSINESS_CHECK_ERRCOUNT
      !ES_ERRCOUNT_VENDOR type TY_RC_BUSINESS_CHECK_ERRCOUNT
      !ET_CUSTOMFIELDCOUNT_CUSTOMER type TT_RC_CUSTOM_FIELDS
      !ET_CUSTOMFIELDCOUNT_VENDOR type TT_RC_CUSTOM_FIELDS .
  class-methods PREPARE_XML
    importing
      !IS_ERRCOUNT_CUSTOMER type TY_RC_BUSINESS_CHECK_ERRCOUNT
      !IS_ERRCOUNT_VENDOR type TY_RC_BUSINESS_CHECK_ERRCOUNT
      !IT_CUSTOMFIELDCOUNT_CUSTOMER type TT_RC_CUSTOM_FIELDS
      !IT_CUSTOMFIELDCOUNT_VENDOR type TT_RC_CUSTOM_FIELDS
    exporting
      !ES_XML type STRING
    raising
      CX_TRANSFORMATION_ERROR
      CX_SY_CONVERSION_CODEPAGE
      CX_SY_CODEPAGE_CONVERTER_INIT
      CX_PARAMETER_INVALID_TYPE
      CX_PARAMETER_INVALID_RANGE .
  class-methods PREPARE_XSL
    exporting
      !ES_XSL type STRING .
protected section.
private section.

  types:
    BEGIN OF ty_rc_master_data,
      cvnum     TYPE char10,
      acc_group TYPE char4,
      brsch     TYPE brsch,
      land1     TYPE land1_gp,
      adrnr     TYPE adrnr,
      txjcd     TYPE txjcd,
      stceg     TYPE stceg,
      stcdt     TYPE j_1atoid,  "STCDT type not available in the system
      stcd1     TYPE stcd1,
      stcd2     TYPE stcd2,
      stcd3     TYPE stcd3,
      stcd4     TYPE stcd4,
      stcd5     TYPE stcd5,
      stkzn     TYPE stkzn,
      stkzu     TYPE stkzu,
      regio     TYPE regio,
    END OF ty_rc_master_data .
  types:
    tt_rc_master_data TYPE STANDARD TABLE OF ty_rc_master_data WITH KEY cvnum .
  types:
    BEGIN OF ty_rc_master_error,
      cv_num          TYPE char10,
      scen_fieldcheck TYPE char2,
      fieldname       TYPE fieldname,
      value           TYPE sxda_fvalu,
      msg_id          TYPE symsgid,
      msg_number      TYPE symsgno,
    END OF ty_rc_master_error .
  types:
    tt_rc_master_error TYPE STANDARD TABLE OF ty_rc_master_error WITH DEFAULT KEY .
  types:
    BEGIN OF ty_rc_business_check,
      taxcode    TYPE tt_rc_master_error,
      email      TYPE tt_rc_master_error,
      transzone  TYPE tt_rc_master_error,
      postalcode TYPE tt_rc_master_error,
      taxjurd    TYPE tt_rc_master_error,
      address    TYPE tt_rc_master_error,
      bank       TYPE tt_rc_master_error,
      industry   TYPE tt_rc_master_error,
      numrange   TYPE tt_rc_master_error,
*      accgroup   TYPE tt_rc_master_error,
    END OF ty_rc_business_check .
  types:
    BEGIN OF ty_t005,
      land1 TYPE t005-land1,
      intca TYPE t005-intca,
    END OF ty_t005 .
  types:
    BEGIN OF ty_t077d,
      ktokd TYPE t077d-ktokd,
      fausa TYPE t077d-fausa,
      numkr TYPE t077d-numkr,
      xcpds type t077d-xcpds,
    END OF ty_t077d .
  types:
    BEGIN OF ty_t077k,
      ktokk TYPE t077k-ktokk,
      numkr TYPE t077k-numkr,
      fausa TYPE t077k-fausa,
      xcpds type t077k-xcpds,
    END OF ty_t077k .

  class-data:
    gt_lfbk TYPE STANDARD TABLE OF lfbk .
  class-data:
    gt_knbk TYPE STANDARD TABLE OF knbk .
  class-data:
    gt_t005 TYPE SORTED TABLE OF ty_t005 WITH UNIQUE KEY land1 .
  class-data:
    gt_t077d TYPE SORTED TABLE OF ty_t077d WITH UNIQUE KEY ktokd .
  class-data:
    gt_t077k TYPE SORTED TABLE OF ty_t077k WITH UNIQUE KEY ktokk .
  class-data:
    gt_tsad3 TYPE HASHED TABLE OF tsad3 WITH UNIQUE KEY title .
  class-data:
    gt_tzone TYPE STANDARD TABLE OF tzone .
  class-data:
    gt_nriv TYPE SORTED TABLE OF nriv WITH UNIQUE KEY object nrrangenr .
  class-data:
    gt_tfktaxnumtype TYPE HASHED TABLE OF tfktaxnumtype WITH UNIQUE KEY taxtype .
  class-data:
    gt_tfktaxnumtype_c TYPE HASHED TABLE OF tfktaxnumtype WITH UNIQUE KEY taxtype .
  class-data GV_ISTYPE type BU_ISTYPE .
  constants GC_DEBITOR type NROBJ value 'DEBITOR' ##NO_TEXT.
  constants GC_KREDEBITOR type NROBJ value 'KREDITOR' ##NO_TEXT.
  class-data:
    gt_address TYPE STANDARD TABLE OF adrc .
  class-data:
    gt_knas TYPE STANDARD TABLE OF knas .
  class-data:
    gt_lfas TYPE STANDARD TABLE OF lfas .
  constants GC_OBJTYPE_CUST type CHAR1 value 'C' ##NO_TEXT.
  constants GC_OBJTYPE_VEND type CHAR1 value 'V' ##NO_TEXT.
  constants GC_PACKAGE_SIZE type INT4 value 10000 ##NO_TEXT.
  class-data GV_SKIP_OTA_ADRCHK type BOOLEAN .

  class-methods GET_CUSTOM_FIELDS_INFO
    exporting
      !ET_CUSTOMFIELDCOUNT_CUSTOMER type TT_RC_CUSTOM_FIELDS
      !ET_CUSTOMFIELDCOUNT_VENDOR type TT_RC_CUSTOM_FIELDS .
  class-methods VALIDATE_DATA
    importing
      !IT_CHK_DATA type TT_RC_MASTER_DATA
      !IV_OBJTYPE type CHAR1
    exporting
      !ES_RC_BUSINESS_CHECK type TY_RC_BUSINESS_CHECK .
  class-methods GET_DATA_FOR_VALIDATION
    importing
      !IV_OBJTYPE type CHAR1 .
  class-methods GET_ADDRESS
    importing
      !IT_CHK_DATA type TT_RC_MASTER_DATA .
  class-methods GET_BANK_DATA
    importing
      !IT_CHK_DATA type TT_RC_MASTER_DATA
      !IV_OBJTYPE type CHAR1 .
  class-methods EXECUTE_BANK_CHECK
    importing
      !IV_OBJECTID type CHAR10
      !IV_OBJTYPE type CHAR1
    changing
      !CT_ERROR type TT_RC_MASTER_ERROR .
  class-methods EXECUTE_ADDRESS_CHECK
    importing
      !IV_OBJECTID type CHAR10
      !IS_ADDRESS type ADRC
    changing
      !CT_ERROR type TT_RC_MASTER_ERROR .
  class-methods EXECUTE_POSTCODE_CHECK
    importing
      !IV_OBJECTID type CHAR10
      !IS_ADDRESS type ADRC
    changing
      !CT_ERROR type TT_RC_MASTER_ERROR .
  class-methods EXECUTE_EMAIL_CHECK
    importing
      !IV_OBJECTID type CHAR10
      !IS_ADDRESS type ADRC
    changing
      !CT_ERROR type TT_RC_MASTER_ERROR .
  class-methods EXECUTE_TAX_JUR_CHECK
    importing
      !IV_OBJECTID type CHAR10
      !IV_OBJTYPE type CHAR1
      !IV_TXJCD type TXJCD
      !IS_ADDRESS type ADRC
    changing
      !CT_ERROR type TT_RC_MASTER_ERROR .
  class-methods EXECUTE_TRANSZONE_CHECK
    importing
      !IV_OBJECTID type CHAR10
      !IV_OBJTYPE type CHAR1
      !IS_ADDRESS type ADRC
      !IS_MASTER_DATA type TY_RC_MASTER_DATA
    changing
      !CT_ERROR type TT_RC_MASTER_ERROR .
  class-methods EXECUTE_INDUSTRY_CHECK
    importing
      !IV_OBJECTID type CHAR10
      !IV_INDUSTRY_SECTOR type BRSCH
    changing
      !CT_ERROR type TT_RC_MASTER_ERROR .
  class-methods EXECUTE_TAX_TYPE_CHECK
    importing
      !IS_SELECTION_PARAM type TY_RC_MASTER_DATA
      !IV_OBJTYPE type CHAR1
    changing
      !CT_ERROR type TT_RC_MASTER_ERROR .
  class-methods EXECUTE_NUMBER_RANGE_CHECK
    importing
      !IV_OBJECTID type CHAR10
      !IV_OBJTYPE type CHAR1
      !IV_ACCOUNT_GROUP type CHAR4
      !IV_NROBJECT type NROBJ
    changing
      !CT_ERROR type TT_RC_MASTER_ERROR .
  class-methods PREPARE_CUSTOM_RANGE
    exporting
      !ET_CUSTOM_RANGE_APPEND type TT_EXT_APPEND_RANGE
      !ET_CUSTOM_RANGE_FIELDS type TT_EXT_FIELD_RANGE .
ENDCLASS.



CLASS CL_CVI_READINESS_CHECK IMPLEMENTATION.


  method EXECUTE_ADDRESS_CHECK.

    DATA : ls_error      TYPE ty_rc_master_error,
           ls_t005       TYPE t005,
           ls_adrc_struc TYPE adrc_struc,
           ls_tsad3      TYPE tsad3,
           lt_errmess    TYPE TABLE OF addr_error,
           ls_errmess    TYPE addr_error.

     CONSTANTS lc_max_length TYPE i VALUE 40.
     CONSTANTS lc_max_length_Street TYPE i VALUE 60.

    ls_error-cv_num = iv_objectid.
    ls_error-scen_fieldcheck = '06'.

    READ TABLE gt_t005 INTO ls_t005 WITH KEY land1 = is_address-country BINARY SEARCH.
    IF sy-subrc = 0.
      MOVE-CORRESPONDING is_address TO ls_adrc_struc ##ENH_OK.
      CALL FUNCTION 'ADDR_REGIONAL_DATA_CHECK'
        EXPORTING
          x_adrc_struc     = ls_adrc_struc
          x_dialog_allowed = space
          x_accept_error   = 'X'
          x_t005           = ls_t005
          iv_nation        = is_address-nation
        IMPORTING
          y_adrc_struc     = ls_adrc_struc
*         Y_RETCODE        = lv_returncode_e
        TABLES
          error_table      = lt_errmess.

      LOOP AT lt_errmess INTO ls_errmess WHERE msg_type CA 'EAX'.
        ls_error-msg_id = ls_errmess-msg_id.
        ls_error-msg_number = ls_errmess-msg_number.
        ls_error-fieldname = ls_errmess-fieldname.
        ls_error-value = is_address-nation.
        INSERT ls_error INTO TABLE ct_error.
      ENDLOOP.

      "The changes done in ADDR_REGIONAL_DATA_CHECK is not required for further processing.
*      MOVE-CORRESPONDING ls_adrc_struc TO is_address.

      IF is_address-title IS NOT INITIAL. " for Person "Mr./Mrs. and for Organisation Others set of title.
        READ TABLE gt_tsad3 INTO ls_tsad3 WITH TABLE KEY title = is_address-title.
        IF sy-subrc = 0 AND ls_tsad3-person = 'X' AND ls_tsad3-xgroup = 'X' AND ls_tsad3-organizatn = ''.
          ls_error-msg_id = sy-msgid.
          ls_error-msg_number = sy-msgno.
          ls_error-fieldname = 'ADRC-TITLE'.
          ls_error-value = is_address-title.
          INSERT ls_error INTO TABLE ct_error.
        ENDIF.
      ENDIF.


      " The below fields, length of more than lc_max_length characters are not allowed.
      ls_error-msg_id = 'AM'.
      ls_error-msg_number = '228'.
      IF strlen( is_address-name1 ) > lc_max_length.
        ls_error-fieldname = 'ADRC-NAME1'.
        ls_error-value = is_address-name1.
        INSERT ls_error INTO TABLE ct_error.
      ENDIF.
      IF strlen( is_address-name2 ) > lc_max_length.
        ls_error-fieldname = 'ADRC-NAME2'.
        ls_error-value = is_address-name2.
        INSERT ls_error INTO TABLE ct_error.
      ENDIF.
      IF strlen( is_address-name3 ) > lc_max_length.
        ls_error-fieldname = 'ADRC-NAME3'.
        ls_error-value =  is_address-name2.
        INSERT ls_error INTO TABLE ct_error.
      ENDIF.
      IF strlen( is_address-name4 ) > lc_max_length.
        ls_error-fieldname = 'ADRC-NAME4'.
        ls_error-value = is_address-name4.
        INSERT ls_error INTO TABLE ct_error.
      ENDIF.
      IF strlen( is_address-street ) > lc_max_length_Street..
        ls_error-fieldname = 'ADRC-STREET'.
        ls_error-value = is_address-street.
        INSERT ls_error INTO TABLE ct_error.
      ENDIF.
      IF strlen( is_address-city1 ) > lc_max_length.
        ls_error-fieldname = 'ADRC-CITY1'.
        ls_error-value = is_address-city1.
        INSERT ls_error INTO TABLE ct_error.
      ENDIF.
      IF strlen( is_address-city2 ) > lc_max_length.
        ls_error-fieldname = 'ADRC-CITY2'.
        ls_error-value = is_address-city2.
        INSERT ls_error INTO TABLE ct_error.
      ENDIF.
      IF strlen( is_address-str_suppl1 ) > lc_max_length.
        ls_error-fieldname = 'STR_SUPPL1'.
        ls_error-value = is_address-str_suppl1.
        INSERT ls_error INTO TABLE ct_error.
      ENDIF.
      IF strlen( is_address-str_suppl2 ) > lc_max_length.
        ls_error-fieldname = 'STR_SUPPL2'.
        ls_error-value = is_address-str_suppl2.
        INSERT ls_error INTO TABLE ct_error.
      ENDIF.
      IF strlen( is_address-str_suppl3 ) > lc_max_length.
        ls_error-fieldname = 'STR_SUPPL3'.
        ls_error-value = is_address-str_suppl3.
        INSERT ls_error INTO TABLE ct_error.
      ENDIF.
      IF strlen( is_address-location ) > lc_max_length.
        ls_error-fieldname = 'LOCATION'.
        ls_error-value = is_address-location.
        INSERT ls_error INTO TABLE ct_error.
      ENDIF.

    ENDIF.
  endmethod.


  METHOD execute_bank_check.

    TYPES: BEGIN OF ty_bank_detail,
             bank_country     TYPE lfbk-banks,
             bank_number      TYPE lfbk-bankl,
             bank_account     TYPE lfbk-bankn,
             bank_control_key TYPE lfbk-bkont,
           END OF ty_bank_detail.
    DATA:ls_knbk        TYPE knbk,
         ls_bnka        TYPE bnka,
         ls_lfbk        TYPE lfbk,
         ls_error       TYPE ty_rc_master_error,
         lv_tabname     TYPE tabname,
         lv_fieldname   TYPE fieldname,
         lv_bank        TYPE tiban-banks,
         ls_bank_detail TYPE ty_bank_detail.

    CLEAR : ls_bank_detail, lv_tabname, ls_error, lv_fieldname.
    "Fill the data based on customer/vendor.
    ls_error-cv_num = iv_objectid.
    ls_error-scen_fieldcheck = '07'..

*    IF ls_lfbk IS NOT INITIAL OR ls_knbk IS NOT INITIAL.
    "For Customer two checks.
      IF iv_objtype = gc_objtype_cust.
      lv_tabname = 'KNBK'.
      LOOP AT gt_knbk INTO ls_knbk WHERE kunnr = iv_objectid.
        ls_bank_detail-bank_country = ls_knbk-banks.
        ls_bank_detail-bank_number = ls_knbk-bankl.
        ls_bank_detail-bank_account = ls_knbk-bankn.
        ls_bank_detail-bank_control_key = ls_knbk-bkont.
        CLEAR ls_bnka.
        CALL FUNCTION 'READ_BANK_ADDRESS'
          EXPORTING
            bank_country = ls_bank_detail-bank_country
            bank_number  = ls_bank_detail-bank_number
          IMPORTING
            bnka_wa      = ls_bnka
          EXCEPTIONS
            not_found    = 1
            OTHERS       = 2.
        IF sy-subrc <> 0.
          ls_error-msg_id = sy-msgid.
          ls_error-msg_number = sy-msgno.
          CONCATENATE lv_tabname '-BANKL' INTO lv_fieldname.
          ls_error-fieldname = lv_fieldname.
          ls_error-value = ls_bank_detail-bank_number.
          INSERT ls_error INTO TABLE ct_error.
        ENDIF.

      IF sy-subrc = 0 AND ls_bnka-xpgro IS NOT INITIAL.
          CALL FUNCTION 'CHECK_END_BANK_ADDRESS'
            EXPORTING
              bank_account     = ls_bank_detail-bank_account
              bank_control_key = ls_bank_detail-bank_control_key
              bank_country     = ls_bank_detail-bank_country
              bank_number      = ls_bank_detail-bank_number
              bank_xpgro       = ls_bnka-xpgro
            EXCEPTIONS
              not_valid        = 1
              OTHERS           = 2.
          IF sy-subrc <> 0 AND sy-msgty <> 'W'.
            ls_error-msg_id = sy-msgid.
            ls_error-msg_number = sy-msgno.
            CONCATENATE lv_tabname '-BANKN' INTO lv_fieldname.
            ls_error-fieldname = lv_fieldname.
            ls_error-value = ls_bank_detail-bank_account.
            INSERT ls_error INTO TABLE ct_error.
          ENDIF.
        ENDIF.
        "Below checks common for customer and vendor.
        CALL FUNCTION 'BANK_NUMBER_CHECK'
          EXPORTING
            bank_account = ls_bank_detail-bank_account
            bank_country = ls_bank_detail-bank_country
            bank_number  = ls_bank_detail-bank_number
          EXCEPTIONS
            not_valid    = 1
            OTHERS       = 2.
        IF sy-subrc <> 0 AND sy-msgty <> 'W'.
          ls_error-msg_id = sy-msgid.
          ls_error-msg_number = sy-msgno.
          CONCATENATE lv_tabname '-BANKL' INTO lv_fieldname.
          ls_error-fieldname = lv_fieldname.
          ls_error-value = ls_bank_detail-bank_number.
          INSERT ls_error INTO TABLE ct_error.
        ENDIF.

        IF ls_bank_detail-bank_account IS INITIAL. " IBAN bank data.
          SELECT SINGLE banks FROM tiban INTO lv_bank WHERE banks = ls_bank_detail-bank_country  AND bankl = ls_bank_detail-bank_number AND tabname = lv_tabname AND tabkey = iv_objectid ##WARN_OK. "Select to check the presence only
          IF sy-subrc <> 0.
            ls_error-msg_id = 'AR'.
            ls_error-msg_number = '141'.
            CONCATENATE lv_tabname '-BANKN' INTO lv_fieldname.
            ls_error-fieldname = lv_fieldname.
            ls_error-value = ls_bank_detail-bank_account.
            INSERT ls_error INTO TABLE ct_error.
          ENDIF.
        ELSE.
          CALL FUNCTION 'BANK_ACCOUNT_CHECK'
            EXPORTING
              bank_account     = ls_bank_detail-bank_account
              bank_control_key = ls_bank_detail-bank_control_key  "important for countries Brazil, France, Spain, Portugal, and Italy
              bank_country     = ls_bank_detail-bank_country
              bank_number      = ls_bank_detail-bank_number
            EXCEPTIONS
              not_valid        = 1
              OTHERS           = 2.
          IF sy-subrc <> 0 AND sy-msgty <> 'W'.
            ls_error-msg_id = sy-msgid.
            ls_error-msg_number = sy-msgno.
            CONCATENATE lv_tabname '-BANKN' INTO lv_fieldname.
            ls_error-fieldname = lv_fieldname.
            ls_error-value = ls_bank_detail-bank_number.
            INSERT ls_error INTO TABLE ct_error.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDIF.

    IF iv_objtype = gc_objtype_vend." Vendor Bank Data Check
      lv_tabname = 'LFBK'.
      LOOP AT gt_lfbk INTO ls_lfbk WHERE lifnr = iv_objectid.
        ls_bank_detail-bank_country = ls_lfbk-banks.
        ls_bank_detail-bank_number = ls_lfbk-bankl.
        ls_bank_detail-bank_account = ls_lfbk-bankn.
        ls_bank_detail-bank_control_key = ls_lfbk-bkont.

      "Below checks common for customer and vendor.
      CALL FUNCTION 'BANK_NUMBER_CHECK'
        EXPORTING
          bank_account = ls_bank_detail-bank_account
          bank_country = ls_bank_detail-bank_country
          bank_number  = ls_bank_detail-bank_number
        EXCEPTIONS
          not_valid    = 1
          OTHERS       = 2.
      IF sy-subrc <> 0 AND sy-msgty <> 'W'.
        ls_error-msg_id = sy-msgid.
        ls_error-msg_number = sy-msgno.
        CONCATENATE lv_tabname '-BANKL' INTO lv_fieldname.
        ls_error-fieldname = lv_fieldname.
        ls_error-value = ls_bank_detail-bank_number.
        INSERT ls_error INTO TABLE ct_error.
      ENDIF.

      IF ls_bank_detail-bank_account IS INITIAL. " IBAN bank data.
        SELECT SINGLE banks FROM tiban INTO lv_bank WHERE banks = ls_bank_detail-bank_country  AND bankl = ls_bank_detail-bank_number AND tabname = lv_tabname AND tabkey = iv_objectid ##WARN_OK. "Select to check the presence only
        IF sy-subrc <> 0.
          ls_error-msg_id = 'AR'.
          ls_error-msg_number = '141'.
            ls_error-fieldname = lv_fieldname.
          ls_error-value = ls_bank_detail-bank_account.
          INSERT ls_error INTO TABLE ct_error.
        ENDIF.
      ELSE.
        CALL FUNCTION 'BANK_ACCOUNT_CHECK'
          EXPORTING
            bank_account     = ls_bank_detail-bank_account
            bank_control_key = ls_bank_detail-bank_control_key  "important for countries Brazil, France, Spain, Portugal, and Italy
            bank_country     = ls_bank_detail-bank_country
            bank_number      = ls_bank_detail-bank_number
          EXCEPTIONS
            not_valid        = 1
            OTHERS           = 2.
        IF sy-subrc <> 0 AND sy-msgty <> 'W'.
          ls_error-msg_id = sy-msgid.
          ls_error-msg_number = sy-msgno.
          CONCATENATE lv_tabname '-BANKN' INTO lv_fieldname.
          ls_error-fieldname = lv_fieldname.
          ls_error-value = ls_bank_detail-bank_number.
          INSERT ls_error INTO TABLE ct_error.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDIF."End of Bank Chcek for Vendor

  ENDMETHOD.


  METHOD execute_email_check.
    DATA: lt_smtp_addr   TYPE TABLE OF adr6-smtp_addr,
          lv_smtp_addr   TYPE adr6-smtp_addr,
          lv_addr_length TYPE i,
          lv_char        TYPE c,
          ls_error       TYPE ty_rc_master_error,
          ls_unstruct    TYPE sx_address.

    IF is_address IS NOT INITIAL.
      CLEAR: ls_error, lt_smtp_addr.
      ls_error-cv_num = iv_objectid.
      ls_error-scen_fieldcheck = '02'.
      ls_error-fieldname = 'ADR6-SMTP_ADDR'.

      SELECT smtp_addr FROM adr6 INTO TABLE lt_smtp_addr WHERE addrnumber = is_address-addrnumber. " get the email address from adr6.
      LOOP AT lt_smtp_addr INTO lv_smtp_addr.
        CHECK lv_smtp_addr IS NOT INITIAL.
        lv_addr_length = strlen( lv_smtp_addr ) - 1.
        lv_char = lv_smtp_addr+lv_addr_length.
        IF lv_char = ';'.
*          MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 030 WITH lv_smtp_addr INTO ls_error-message.
          ls_error-msg_id = sy-msgid.
          ls_error-msg_number = sy-msgno.
          ls_error-value = lv_smtp_addr.
          INSERT ls_error INTO TABLE ct_error.
        ELSE.
          CLEAR ls_unstruct.
          ls_unstruct-type = 'INT'.
          ls_unstruct-address = lv_smtp_addr.
          CALL FUNCTION 'SX_INTERNET_ADDRESS_TO_NORMAL'
            EXPORTING
              address_unstruct   = ls_unstruct
              complete_address   = 'X'
            EXCEPTIONS
              error_address_type = 1
              error_address      = 2.
          IF sy-subrc <> 0.
            ls_error-msg_id = sy-msgid.
            ls_error-msg_number = sy-msgno.
*            MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 030 WITH lv_smtp_addr INTO ls_error-message.
            ls_error-value = lv_smtp_addr.
            INSERT ls_error INTO TABLE ct_error.
          ENDIF.
        ENDIF.
      ENDLOOP.

    ENDIF.
  ENDMETHOD.


  method EXECUTE_INDUSTRY_CHECK.

    DATA:lv_brsch TYPE tp038m2-brsch,
         ls_error TYPE ty_rc_master_error.

*   Perform the execution of checks for Industry regions
    IF iv_industry_sector IS NOT INITIAL AND gv_istype IS NOT INITIAL.
      SELECT SINGLE brsch FROM tp038m2
                          INTO lv_brsch
                         WHERE brsch  = iv_industry_sector
                           AND istype = gv_istype.
      IF sy-subrc <> 0.
        CLEAR ls_error.
        ls_error-cv_num = iv_objectid.
*        MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 031 WITH iv_industry_sector INTO ls_error-message.
*        ls_error-msg_id = if_cvi_prechk=>gc_message_class.
" for the below issue, we need message class, so we use CVI_MAPPING message class for count purpose. " this is not the right message class for the below issue.
        " we shouldn't use message class is CVI_PRECHK whcih we cant use here due to decouling the object.
        ls_error-msg_id = 'CVI_MAPPING'.
*        ls_error-msg_number = '031'.
        ls_error-msg_number = '000'.
        ls_error-scen_fieldcheck = '08'.
        ls_error-fieldname = 'INDUSTRY'.
        ls_error-value = iv_industry_sector.
        APPEND ls_error TO ct_error.
      ENDIF.
    ENDIF.

  endmethod.


  method EXECUTE_NUMBER_RANGE_CHECK.

    DATA: lv_numkr TYPE numkr,
          ls_nriv  TYPE nriv,
          ls_error TYPE ty_rc_master_error,
          ls_t077d TYPE ty_t077d,
          ls_t077k TYPE ty_t077k.

    CLEAR lv_numkr.
    IF iv_objtype EQ gc_objtype_cust.
      READ TABLE gt_t077d INTO ls_t077d WITH KEY ktokd = iv_account_group TRANSPORTING numkr.
      IF sy-subrc EQ 0.
        lv_numkr = ls_t077d-numkr.
      ENDIF.
    ELSEIF iv_objtype EQ gc_objtype_vend.
      READ TABLE gt_t077k INTO ls_t077k WITH KEY ktokk = iv_account_group TRANSPORTING numkr.
      IF sy-subrc EQ 0.
        lv_numkr = ls_t077k-numkr.
      ENDIF.
    ENDIF.

    IF lv_numkr IS NOT INITIAL.
      READ TABLE gt_nriv INTO ls_nriv WITH TABLE KEY object = iv_nrobject nrrangenr = lv_numkr.
      IF sy-subrc = 0 AND iv_objectid IS NOT INITIAL AND ( iv_objectid < ls_nriv-fromnumber OR iv_objectid > ls_nriv-tonumber ).
        CLEAR ls_error.
        ls_error-cv_num = iv_objectid.
        ls_error-fieldname = 'NUMBERRANGE'.
        ls_error-value = iv_objectid.
        ls_error-msg_id = 'R1'.
        ls_error-msg_number = '099'.
        ls_error-scen_fieldcheck = '09'.
*        IF iv_objtype  = gc_objtype_cust.
**          MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 024 WITH iv_objectid ls_nriv-fromnumber ls_nriv-tonumber INTO ls_error-message.
*        ELSEIF iv_objtype = gc_objtype_vend.
**           MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 025 WITH iv_objectid ls_nriv-fromnumber ls_nriv-tonumber INTO ls_error-message.
*        ENDIF.
        INSERT ls_error INTO TABLE ct_error.
      ENDIF.
    ENDIF.

  endmethod.


  method EXECUTE_POSTCODE_CHECK.
    DATA : ls_error          TYPE ty_rc_master_error,
           ls_postal_address TYPE adrs_post.

    IF is_address-addrnumber IS NOT INITIAL.
      CLEAR ls_postal_address.
      MOVE-CORRESPONDING is_address TO ls_postal_address ##ENH_OK.

      CALL FUNCTION 'ADDR_POSTAL_CODE_CHECK'
        EXPORTING
          country                        = ls_postal_address-country
          postal_address                 = ls_postal_address
        EXCEPTIONS
          country_not_valid              = 01
          region_not_valid               = 02
          postal_code_city_not_valid     = 03
          postal_code_po_box_not_valid   = 04
          postal_code_company_not_valid  = 05
          po_box_missing                 = 06
          postal_code_po_box_missing     = 07
          postal_code_missing            = 08
          postal_code_pobox_comp_missing = 09
          po_box_region_not_valid        = 10
          po_box_country_not_valid       = 11
          pobox_and_poboxnum_filled      = 12
          OTHERS                         = 99.
      IF sy-subrc <> 0.
        CLEAR ls_error.
        ls_error-cv_num = iv_objectid.
        ls_error-msg_id = sy-msgid.
        ls_error-msg_number = sy-msgno.
        ls_error-scen_fieldcheck = '04'.

         CASE sy-subrc.
          WHEN 01.
            ls_error-fieldname = 'ADRC-COUNTRY'.
*            MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 014 WITH ls_postal_address-country ls_postal_address-country INTO ls_error-message.
            ls_error-value = ls_postal_address-country.
          WHEN 02.
            ls_error-fieldname = 'REGION'.
*            MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 014 WITH ls_postal_address-region ls_postal_address-country INTO ls_error-message.
            ls_error-value = ls_postal_address-region.
          WHEN 03.
            ls_error-fieldname = 'ADRC-POST_CODE1'.
*            MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 014 WITH ls_postal_address-post_code1 ls_postal_address-country INTO ls_error-message.
            ls_error-value = ls_postal_address-post_code1.
          WHEN 04.
            ls_error-fieldname = 'ADRC-POST_CODE2'.
*            MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 014 WITH ls_postal_address-post_code2 ls_postal_address-country INTO ls_error-message.
            ls_error-value = ls_postal_address-post_code2.
          WHEN 05.
            ls_error-fieldname = 'ADRC-POST_CODE3'.
*            MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 014 WITH ls_postal_address-post_code3 ls_postal_address-country INTO ls_error-message.
            ls_error-value = ls_postal_address-post_code3.
          WHEN 06.
            ls_error-fieldname = 'ADRC-PO_BOX'.
*            MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 015 WITH 'PO_BOX' ls_postal_address-country INTO ls_error-message.
            ls_error-value = ls_postal_address-po_box.
          WHEN 07.
            ls_error-fieldname = 'ADRC-POST_CODE2'.
*            MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 015 WITH 'POST_CODE2' ls_postal_address-country INTO ls_error-message.
            ls_error-value = ls_postal_address-post_code2.
          WHEN 08.
            ls_error-fieldname = 'ADRC-POST_CODE1'.
*            MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 015 WITH 'POST_CODE1' ls_postal_address-country INTO ls_error-message.
            ls_error-value = ls_postal_address-post_code1.
          WHEN 09.
            ls_error-fieldname = 'ADRC-PO_BOX_CTY'.
*            MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 015 WITH 'PO_BOX_CTY' ls_postal_address-country INTO ls_error-message.
            ls_error-value = ls_postal_address-po_box_cty.
          WHEN 10.
            ls_error-fieldname = 'ADRC-PO_BOX_REG'.
*            MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 014 WITH ls_postal_address-po_box_reg ls_postal_address-country INTO ls_error-message.
            ls_error-value = ls_postal_address-po_box_reg.
          WHEN 11.
            ls_error-fieldname = 'ADRC-POBOX_CTY'.
*            MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 014 WITH ls_postal_address-po_box_cty ls_postal_address-country INTO ls_error-message.
            ls_error-value = ls_postal_address-po_box_cty.
          WHEN 12.
            ls_error-fieldname = 'ADRC-PO_W_O_NO'.
*            MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 017 WITH 'PO_W_O_NO' INTO ls_error-message.
            ls_error-value = ls_postal_address-po_box_lobby.
          WHEN OTHERS.
        ENDCASE.

        INSERT ls_error INTO TABLE ct_error.
      ENDIF.
    ENDIF.

  endmethod.


  METHOD execute_tax_jur_check.

    DATA: ls_error     TYPE ty_rc_master_error.

    IF is_address-addrnumber IS NOT INITIAL AND iv_txjcd IS NOT INITIAL.
      CALL FUNCTION 'TAX_TXJCD_DETERMINE_CHECK'
        EXPORTING
          im_country        = is_address-country
          im_region         = is_address-region
          im_zipcode        = is_address-post_code1
          im_city           = is_address-city1
          im_county         = is_address-city2
          im_taxjurcode     = is_address-taxjurcode
          im_no_dialog      = 'X'
        EXCEPTIONS
          rfcdest_not_found = 3
          OTHERS            = 1.
      IF sy-subrc <> 0.
        ls_error-msg_id = sy-msgid.
        ls_error-msg_number = sy-msgno.
        IF iv_objtype EQ gc_objtype_cust.
          ls_error-fieldname = 'KNA1-TXJCD'.
        ELSE.
          ls_error-fieldname = 'LFA1-TXJCD'.
        ENDIF.
*        IF sy-subrc = 3.
*           MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 027 WITH iv_txjcd INTO ls_error-message.
*        ELSE.
*
*          MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 026 WITH iv_txjcd is_address-country INTO ls_error-message.
*        ENDIF.
        ls_error-cv_num = iv_objectid.
        ls_error-scen_fieldcheck = '05'.
        ls_error-value = iv_txjcd.
        INSERT ls_error INTO TABLE ct_error.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD execute_tax_type_check.

    DATA:ls_error   TYPE ty_rc_master_error,
         lv_table   TYPE tabname,
         lv_table_01   TYPE tabname,
         lv_tax_chk TYPE tfktaxnumtype-taxtype,
         ls_knas    TYPE knas,
         ls_lfas    TYPE lfas.

*    CONSTANTS: lc_msg_class_old TYPE string VALUE 'FKBPTAX', "Additional msg class for tax type from RIG report
*               lc_msg_no_old    TYPE string VALUE '033'. "Additional msg class for tax type from RIG report

* for the below check, we need some message class, that's why we are using cvi_mapping class.
    CONSTANTS: lc_msg_class_old TYPE string VALUE 'CVI_MAPPING',
               lc_msg_no_old    TYPE string VALUE '000'.

*   Execute Checks all Tax type categories
    CLEAR: ls_error.
    ls_error-cv_num = is_selection_param-cvnum.
    ls_error-scen_fieldcheck = '01'.

    IF iv_objtype = gc_objtype_cust.
      lv_table = 'KNA1'.
    ELSEIF iv_objtype = gc_objtype_vend.
      lv_table = 'LFA1'.
    ENDIF.
    lv_table_01 = 'TFKTAXNUMTYPE_C'.
    IF is_selection_param-stceg IS NOT INITIAL.  " Check for country which is not an EU member.
      CALL FUNCTION 'EU_TAX_NUMBER_CHECK'
        EXPORTING
          country       = is_selection_param-land1
          eu_tax_number = is_selection_param-stceg
*         PARTNER       =
        EXCEPTIONS
          not_valid     = 1
          OTHERS        = 2.
      IF sy-subrc <> 0.
        ls_error-msg_id = sy-msgid.
        ls_error-msg_number = sy-msgno.
        CONCATENATE lv_table '-STCEG' INTO ls_error-fieldname.
        ls_error-value = is_selection_param-stceg.
*        MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 009 WITH is_selection_param-stceg is_selection_param-land1 INTO ls_error-message.
        INSERT ls_error INTO TABLE ct_error.
      ENDIF.

      IF iv_objtype = gc_objtype_cust.
        SORT gt_knas BY kunnr.
        READ TABLE gt_knas INTO ls_knas WITH KEY kunnr = is_selection_param-cvnum BINARY SEARCH.
        IF sy-subrc = 0.
          CALL FUNCTION 'EU_TAX_NUMBER_CHECK'
            EXPORTING
              country       = ls_knas-land1
              eu_tax_number = ls_knas-stceg
*             PARTNER       =
            EXCEPTIONS
              not_valid     = 1
              OTHERS        = 2.
          IF sy-subrc <> 0.
            ls_error-msg_id = sy-msgid.
            ls_error-msg_number = sy-msgno.
            ls_error-fieldname = 'KNAS-STCEG'.
            ls_error-value = ls_knas-stceg.
*            MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 009 WITH ls_knas-stceg ls_knas-land1 INTO ls_error-message.
            INSERT ls_error INTO TABLE ct_error.
          ENDIF.
        ENDIF.
      ELSEIF iv_objtype = gc_objtype_vend.
        SORT gt_lfas BY lifnr.
        READ TABLE gt_lfas INTO ls_lfas WITH KEY lifnr = is_selection_param-cvnum BINARY SEARCH.
        IF sy-subrc = 0.
          CALL FUNCTION 'EU_TAX_NUMBER_CHECK'
            EXPORTING
              country       = ls_lfas-land1
              eu_tax_number = ls_lfas-stceg
*             PARTNER       =
            EXCEPTIONS
              not_valid     = 1
              OTHERS        = 2.
          IF sy-subrc <> 0.
            ls_error-msg_id = sy-msgid.
            ls_error-msg_number = sy-msgno.
            ls_error-fieldname = 'LFAS-STCEG'.
            ls_error-value = ls_lfas-stceg.
*            MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 009 WITH ls_lfas-stceg ls_lfas-land1 INTO ls_error-message.
            INSERT ls_error INTO TABLE ct_error.
          ENDIF.
        ENDIF.
      ENDIF.

* tax type check table TFKTAXNUMTYPE
      IF is_selection_param-stcdt IS INITIAL.
        CONCATENATE is_selection_param-land1 '0' INTO lv_tax_chk.
        READ TABLE gt_tfktaxnumtype_c WITH TABLE KEY taxtype = lv_tax_chk TRANSPORTING NO FIELDS.
        IF sy-subrc <> 0.
          ls_error-msg_id = lc_msg_class_old .
          ls_error-msg_number = lc_msg_no_old.
          CONCATENATE lv_table_01 '-TAXTYPE' INTO ls_error-fieldname.
          ls_error-value = lv_tax_chk.
*          MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 010 WITH lv_tax_chk is_selection_param-land1 INTO ls_error-message.
          INSERT ls_error INTO TABLE ct_error.
        ENDIF.
      ENDIF.
    ENDIF.

****  Tax Number STCD1-STCD5 Check
    IF is_selection_param-stcd1 <> space.
      CALL FUNCTION 'TAX_NUMBER_CHECK'
        EXPORTING
          country             = is_selection_param-land1
          natural_person_flag = is_selection_param-stkzn
          region              = is_selection_param-regio
          stkzu               = is_selection_param-stkzu
          tax_code_1          = is_selection_param-stcd1
        EXCEPTIONS
          not_valid           = 1
          different_fprcd     = 2  " Not handle due to not raised inside the FM.
          OTHERS              = 3.

      IF sy-subrc <> 0.
        ls_error-msg_id = sy-msgid.
        ls_error-msg_number = sy-msgno.
        ls_error-value = is_selection_param-stcd1.
        CONCATENATE lv_table '-STCD1' INTO ls_error-fieldname.
*        MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 032 WITH  '1' is_selection_param-stcd1 is_selection_param-land1 INTO ls_error-message.
        INSERT ls_error INTO TABLE ct_error.
      ENDIF.

* tax type check table TFKTAXNUMTYPE

      IF is_selection_param-stcdt IS INITIAL.
        CONCATENATE is_selection_param-land1 '1' INTO lv_tax_chk.
        READ TABLE gt_tfktaxnumtype_c WITH TABLE KEY taxtype = lv_tax_chk TRANSPORTING NO FIELDS.
        IF sy-subrc <> 0.
          ls_error-msg_id = lc_msg_class_old.
          ls_error-msg_number = lc_msg_no_old.
          CONCATENATE lv_table_01 '-TAXTYPE' INTO ls_error-fieldname.
          ls_error-value = lv_tax_chk.
*          MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 010 WITH lv_tax_chk is_selection_param-land1 INTO ls_error-message.
          INSERT ls_error INTO TABLE ct_error.
        ENDIF.
      ENDIF.
    ENDIF.


    IF is_selection_param-stcd2 <> space.
      CALL FUNCTION 'TAX_NUMBER_CHECK'
        EXPORTING
          country             = is_selection_param-land1
          natural_person_flag = is_selection_param-stkzn
          region              = is_selection_param-regio
          stkzu               = is_selection_param-stkzu
          tax_code_2          = is_selection_param-stcd2
        EXCEPTIONS
          not_valid           = 1
          different_fprcd     = 2  " Not handle due to not raised inside the FM.
          OTHERS              = 3.

      IF sy-subrc <> 0.
        ls_error-msg_id = sy-msgid.
        ls_error-msg_number = sy-msgno.
        ls_error-value = is_selection_param-stcd2.
        CONCATENATE lv_table '-STCD2' INTO ls_error-fieldname.
*         MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 032 WITH  '2' is_selection_param-stcd2 is_selection_param-land1 INTO ls_error-message.
        INSERT ls_error INTO TABLE ct_error.
      ENDIF.
*
** tax type check table TFKTAXNUMTYPE

      IF is_selection_param-stcdt IS INITIAL.
        CONCATENATE is_selection_param-land1 '2' INTO lv_tax_chk.
        READ TABLE gt_tfktaxnumtype_c WITH TABLE KEY taxtype = lv_tax_chk TRANSPORTING NO FIELDS.
        IF sy-subrc <> 0.
          ls_error-msg_id = lc_msg_class_old.
          ls_error-msg_number = lc_msg_no_old.
          CONCATENATE lv_table_01 '-TAXTYPE' INTO ls_error-fieldname.
          ls_error-value = lv_tax_chk.
*          MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 010 WITH lv_tax_chk is_selection_param-land1 INTO ls_error-message.
          INSERT ls_error INTO TABLE ct_error.
        ENDIF.
      ENDIF.
    ENDIF.

    IF is_selection_param-stcd3 <> space.
      CALL FUNCTION 'TAX_NUMBER_CHECK'
        EXPORTING
          country             = is_selection_param-land1
          natural_person_flag = is_selection_param-stkzn
          region              = is_selection_param-regio
          stkzu               = is_selection_param-stkzu
          tax_code_3          = is_selection_param-stcd3
        EXCEPTIONS
          not_valid           = 1
          different_fprcd     = 2  " Not handle due to not raised inside the FM.
          OTHERS              = 3.

      IF sy-subrc <> 0.
        ls_error-msg_id = sy-msgid.
        ls_error-msg_number = sy-msgno.
        ls_error-value = is_selection_param-stcd3.
        CONCATENATE lv_table '-STCD3' INTO ls_error-fieldname.
*        MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 032 WITH '3' is_selection_param-stcd3 is_selection_param-land1 INTO ls_error-message.
        INSERT ls_error INTO TABLE ct_error.
      ENDIF.
* tax type check table TFKTAXNUMTYPE
      IF is_selection_param-stcdt IS INITIAL.
        CONCATENATE is_selection_param-land1 '3' INTO lv_tax_chk.
        READ TABLE gt_tfktaxnumtype_c WITH TABLE KEY taxtype = lv_tax_chk TRANSPORTING NO FIELDS.
        IF sy-subrc <> 0.
          ls_error-msg_id = lc_msg_class_old.
          ls_error-msg_number = lc_msg_no_old.
          CONCATENATE lv_table_01 '-TAXTYPE' INTO ls_error-fieldname.
          ls_error-value = lv_tax_chk.
*          MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 010 WITH lv_tax_chk is_selection_param-land1 INTO ls_error-message.
          INSERT ls_error INTO TABLE ct_error.
        ENDIF.
      ENDIF.
    ENDIF.


    IF is_selection_param-stcd4 <> space.
      CALL FUNCTION 'TAX_NUMBER_CHECK'
        EXPORTING
          country             = is_selection_param-land1
          natural_person_flag = is_selection_param-stkzn
          region              = is_selection_param-regio
          stkzu               = is_selection_param-stkzu
          tax_code_4          = is_selection_param-stcd4
        EXCEPTIONS
          not_valid           = 1
          different_fprcd     = 2  " Not handle due to not raised inside the FM.
          OTHERS              = 3.

      IF sy-subrc <> 0.
        ls_error-msg_id = sy-msgid.
        ls_error-msg_number = sy-msgno.
        ls_error-value = is_selection_param-stcd4.
        CONCATENATE lv_table '-STCD4' INTO ls_error-fieldname.
*        MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 032 WITH  '4' is_selection_param-stcd4 is_selection_param-land1 INTO ls_error-message.
        INSERT ls_error INTO TABLE ct_error.
      ENDIF.

* tax type check table TFKTAXNUMTYPE
      IF is_selection_param-stcdt IS INITIAL.
        CONCATENATE is_selection_param-land1 '4' INTO lv_tax_chk.
        READ TABLE gt_tfktaxnumtype_c WITH TABLE KEY taxtype = lv_tax_chk TRANSPORTING NO FIELDS.
        IF sy-subrc <> 0.
          ls_error-msg_id = lc_msg_class_old.
          ls_error-msg_number = lc_msg_no_old.
          CONCATENATE lv_table_01 '-TAXTYPE' INTO ls_error-fieldname.
          ls_error-value = lv_tax_chk.
*          MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 010 WITH lv_tax_chk is_selection_param-land1 INTO ls_error-message.
          INSERT ls_error INTO TABLE ct_error.
        ENDIF.
      ENDIF.
    ENDIF.


    IF is_selection_param-stcd5 <> space.
      CALL FUNCTION 'TAX_NUMBER_CHECK'
        EXPORTING
          country             = is_selection_param-land1
          natural_person_flag = is_selection_param-stkzn
          region              = is_selection_param-regio
          stkzu               = is_selection_param-stkzu
          tax_code_5          = is_selection_param-stcd5
        EXCEPTIONS
          not_valid           = 1
          different_fprcd     = 2  " Not handle due to not raised inside the FM.
          OTHERS              = 3.

      IF sy-subrc <> 0.
        ls_error-msg_id = sy-msgid.
        ls_error-msg_number = sy-msgno.
        ls_error-value = is_selection_param-stcd5.
        CONCATENATE lv_table '-STCD5' INTO ls_error-fieldname.
*        MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 032 WITH  '5' is_selection_param-stcd5 is_selection_param-land1 INTO ls_error-message.
        INSERT ls_error INTO TABLE ct_error.
      ENDIF.

* tax type check table TFKTAXNUMTYPE
      IF is_selection_param-stcdt IS INITIAL.
        CONCATENATE is_selection_param-land1 '5' INTO lv_tax_chk.
        READ TABLE gt_tfktaxnumtype_c WITH TABLE KEY taxtype = lv_tax_chk TRANSPORTING NO FIELDS.
        IF sy-subrc <> 0.
          ls_error-msg_id = lc_msg_class_old.
          ls_error-msg_number = lc_msg_no_old.
          CONCATENATE lv_table_01 '-TAXTYPE' INTO ls_error-fieldname.
          ls_error-value = lv_tax_chk.
*          MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 010 WITH lv_tax_chk is_selection_param-land1 INTO ls_error-message.
          INSERT ls_error INTO TABLE ct_error.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  method EXECUTE_TRANSZONE_CHECK.

    DATA: lv_fausa TYPE fausa_077d,
          ls_error TYPE ty_rc_master_error,
          ls_t077d TYPE ty_t077d,
          ls_t077k TYPE ty_t077k.

    IF is_address-transpzone IS INITIAL.
      CLEAR lv_fausa.
      IF iv_objtype EQ gc_objtype_cust.
        READ TABLE gt_t077d INTO ls_t077d WITH KEY ktokd = is_master_data-acc_group BINARY SEARCH TRANSPORTING fausa.
        IF sy-subrc EQ 0.
          lv_fausa = ls_t077d-fausa.
        ENDIF.
      ELSEIF iv_objtype EQ gc_objtype_vend.
        READ TABLE gt_t077k INTO ls_t077k WITH KEY ktokk = is_master_data-acc_group BINARY SEARCH TRANSPORTING fausa.
        IF sy-subrc EQ 0.
          lv_fausa = ls_t077k-fausa.
        ENDIF.
      ENDIF.

      IF lv_fausa IS NOT INITIAL AND ls_t077d-fausa+24(1) = '+'. "Transportzone is mandatory
        CLEAR ls_error.
        ls_error-cv_num = iv_objectid.
*        MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 028 INTO ls_error-message.
        ls_error-msg_id = '00'.
        ls_error-msg_number = '055'.
        ls_error-scen_fieldcheck = '03'.
        ls_error-fieldname = 'ADRC-TRANSPZONE'.
        ls_error-value = ''.
        APPEND ls_error TO ct_error.
      ENDIF.
    ELSE.
      READ TABLE gt_tzone WITH KEY land1 = is_master_data-land1 zone1 = is_address-transpzone TRANSPORTING NO FIELDS.
      IF sy-subrc <> 0.
        "The transport zone Z000000001 is not defined for country DE
        CLEAR ls_error.
        ls_error-cv_num = iv_objectid.
*        MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 029 WITH is_address-transpzone  is_master_data-land1 INTO ls_error-message.
        ls_error-msg_id = 'AM'.
        ls_error-msg_number = '129'.
        ls_error-scen_fieldcheck = '03'.
        ls_error-fieldname = 'ADRC-TRANSPZONE'.
        ls_error-value = is_address-transpzone.
        APPEND ls_error TO ct_error.
      ENDIF.
    ENDIF.

  endmethod.


  method GET_ADDRESS.

    CLEAR: gt_address, gt_tsad3.

    CHECK it_chk_data IS NOT INITIAL.
    SELECT  addrnumber
*            date_from
*            nation
            post_code1
            post_code2
            post_code3
            po_box
            po_box_reg
            po_box_cty
            po_box_num
            po_box_loc
            deli_serv_type
            transpzone
            title
            name1
            name2
            name3
            name4
            street
            city1
            city2
            str_suppl1
            str_suppl2
            str_suppl3
            location
            country
            region
            taxjurcode
            INTO CORRESPONDING FIELDS OF TABLE gt_address
              FROM adrc
              FOR ALL ENTRIES IN it_chk_data WHERE addrnumber = it_chk_data-adrnr.

    IF gt_address IS NOT INITIAL.
      SELECT * FROM tsad3 INTO TABLE gt_tsad3 FOR ALL ENTRIES IN gt_address WHERE title = gt_address-title.
    ENDIF.

  endmethod.


  METHOD get_bank_data.

    CLEAR: gt_knbk, gt_knas, gt_lfbk, gt_lfas.
    CHECK it_chk_data IS NOT INITIAL.

*****     Customer related Data
    IF iv_objtype = gc_objtype_cust.
      SELECT kunnr banks bankn bkont bankl INTO CORRESPONDING FIELDS OF TABLE gt_knbk FROM knbk FOR ALL ENTRIES IN it_chk_data
             WHERE kunnr = it_chk_data-cvnum.

*      SELECT kunnr land1 stceg INTO CORRESPONDING FIELDS OF TABLE gt_knas FROM knas FOR ALL ENTRIES IN it_chk_data
*             WHERE kunnr = it_chk_data-cvnum.
        SELECT * INTO TABLE gt_knas FROM knas FOR ALL ENTRIES IN it_chk_data
             WHERE kunnr = it_chk_data-cvnum.

    ELSEIF iv_objtype = gc_objtype_vend.
******   Vendor related Data
      SELECT lifnr banks bankn bkont bankl INTO CORRESPONDING FIELDS OF TABLE gt_lfbk FROM lfbk FOR ALL ENTRIES IN it_chk_data
             WHERE lifnr = it_chk_data-cvnum.                .

*      SELECT lifnr land1 stceg INTO CORRESPONDING FIELDS OF TABLE gt_lfas FROM lfas FOR ALL ENTRIES IN it_chk_data
*             WHERE lifnr = it_chk_data-cvnum.
      SELECT * INTO TABLE gt_lfas FROM lfas FOR ALL ENTRIES IN it_chk_data
             WHERE lifnr = it_chk_data-cvnum.

    ENDIF.
  ENDMETHOD.


  METHOD get_custom_fields_info.
    DATA: lv_text                TYPE string,
          lo_type_descr          TYPE REF TO cl_abap_typedescr,
          lo_stru_descr          TYPE REF TO cl_abap_structdescr,
          lt_fields              TYPE abap_component_view_tab,
          lt_appends             TYPE STANDARD TABLE OF dcappends,
          lt_custom_append_range TYPE tt_ext_append_range,
          lt_custom_fields_range TYPE tt_ext_field_range.

    FIELD-SYMBOLS: <ls_custom_data> TYPE ty_rc_custom_fields,
                   <lv_tabname>     TYPE tt_rc_custom_fields.
*    Tables to be considered
*      Customer: KNA1, KNVV, KNB1
*      vendor:   LFA1, LFB1, LFM1
*    build data to be processed
    APPEND INITIAL LINE TO et_customfieldcount_customer ASSIGNING <ls_custom_data>.
    <ls_custom_data>-tabname = 'KNA1'.
    APPEND INITIAL LINE TO et_customfieldcount_customer ASSIGNING <ls_custom_data>.
    <ls_custom_data>-tabname = 'KNB1'.
    APPEND INITIAL LINE TO et_customfieldcount_customer ASSIGNING <ls_custom_data>.
    <ls_custom_data>-tabname = 'KNBK'.
    APPEND INITIAL LINE TO et_customfieldcount_customer ASSIGNING <ls_custom_data>.
    <ls_custom_data>-tabname = 'KNVP'.
    APPEND INITIAL LINE TO et_customfieldcount_customer ASSIGNING <ls_custom_data>.
    <ls_custom_data>-tabname = 'KNVV'.

    APPEND INITIAL LINE TO et_customfieldcount_vendor ASSIGNING <ls_custom_data>.
    <ls_custom_data>-tabname = 'LFA1'.
    APPEND INITIAL LINE TO et_customfieldcount_vendor ASSIGNING <ls_custom_data>.
    <ls_custom_data>-tabname = 'LFB1'.
    APPEND INITIAL LINE TO et_customfieldcount_vendor ASSIGNING <ls_custom_data>.
    <ls_custom_data>-tabname = 'LFBK'.
    APPEND INITIAL LINE TO et_customfieldcount_vendor ASSIGNING <ls_custom_data>.
    <ls_custom_data>-tabname = 'LFM1'.
    APPEND INITIAL LINE TO et_customfieldcount_vendor ASSIGNING <ls_custom_data>.
    <ls_custom_data>-tabname = 'LFM2'.
    UNASSIGN <ls_custom_data>.
* process data for customer
*       get the range table
    CALL METHOD prepare_custom_range
      IMPORTING
        et_custom_range_append = lt_custom_append_range
        et_custom_range_fields = lt_custom_fields_range.
    DO 2 TIMES.
      CLEAR lv_text.
      IF sy-index = 1.
        ASSIGN et_customfieldcount_customer TO <lv_tabname>.
        CONCATENATE TEXT-009 TEXT-003 INTO lv_text SEPARATED BY space.
        REPLACE ':' INTO lv_text WITH space.
        MESSAGE i001(00) WITH lv_text.
      ELSE.
        ASSIGN et_customfieldcount_vendor TO <lv_tabname>.
        CONCATENATE TEXT-009 TEXT-004 INTO lv_text SEPARATED BY space.
        REPLACE ':' INTO lv_text WITH space.
        MESSAGE i001(00) WITH lv_text.
      ENDIF.
      LOOP AT <lv_tabname> ASSIGNING <ls_custom_data>.
        CLEAR: lt_appends, lt_fields.
        CALL FUNCTION 'DDUT_APPENDS_GET'
          EXPORTING
            tabname       = <ls_custom_data>-tabname
          TABLES
            append_tab    = lt_appends
          EXCEPTIONS
            illegal_input = 1
            OTHERS        = 2.
        IF sy-subrc = 0.
          DELETE lt_appends WHERE appendname NOT IN lt_custom_append_range.
          <ls_custom_data>-append_count = lines( lt_appends ).
        ENDIF.
*     get the custom fields
        lo_type_descr = cl_abap_typedescr=>describe_by_name( <ls_custom_data>-tabname ).
        CHECK lo_type_descr IS BOUND.
        lo_stru_descr ?= lo_type_descr.
        lt_fields = lo_stru_descr->get_included_view( ).
        DELETE lt_fields WHERE name NOT IN lt_custom_fields_range.
        <ls_custom_data>-field_count = lines( lt_fields ).
*       add info messages
        CLEAR lv_text.
        CONCATENATE TEXT-007 <ls_custom_data>-tabname INTO lv_text SEPARATED BY space.
        MESSAGE i001(00) WITH lv_text ' :' <ls_custom_data>-append_count.
        CLEAR lv_text.
        CONCATENATE TEXT-008 <ls_custom_data>-tabname INTO lv_text SEPARATED BY space.
        MESSAGE i001(00) WITH lv_text ' :' <ls_custom_data>-field_count.
      ENDLOOP.
    ENDDO.

  ENDMETHOD.


  METHOD get_data_for_validation.

    DATA: lv_object TYPE nrobj,
          ls_cvi_prechk_sup TYPE cvi_prechk_sup.

    IF gt_t005 IS INITIAL.
*      SELECT land1 intca FROM t005 INTO CORRESPONDING FIELDS OF TABLE gt_t005.
       SELECT land1 intca FROM t005 INTO TABLE gt_t005.
    ENDIF.

    IF iv_objtype EQ gc_objtype_cust AND gt_t077d IS INITIAL.
*      SELECT ktokd numkr fausa FROM t077d INTO CORRESPONDING FIELDS OF TABLE gt_t077d.
      SELECT ktokd fausa numkr xcpds FROM t077d INTO TABLE gt_t077d.
    ELSEIF iv_objtype EQ gc_objtype_vend AND gt_t077k IS INITIAL.
*      SELECT ktokk numkr fausa FROM t077k INTO CORRESPONDING FIELDS OF TABLE gt_t077k.
      SELECT ktokk numkr fausa xcpds FROM t077k INTO TABLE gt_t077k.
    ENDIF.
    IF gt_tzone IS INITIAL.
*      SELECT land1 zone1 FROM tzone INTO CORRESPONDING FIELDS OF TABLE gt_tzone.
      SELECT * FROM tzone INTO TABLE gt_tzone.
    ENDIF.

    IF gt_tfktaxnumtype IS INITIAL.
      SELECT taxtype FROM tfktaxnumtype INTO CORRESPONDING FIELDS OF TABLE gt_tfktaxnumtype.
      SELECT taxtype FROM tfktaxnumtype_c INTO CORRESPONDING FIELDS OF TABLE gt_tfktaxnumtype_c.
    ENDIF.

    IF gv_istype IS INITIAL.
      SELECT SINGLE istype FROM tb038 INTO gv_istype WHERE istdef = abap_true ##WARN_OK.
    ENDIF.

    IF iv_objtype EQ gc_objtype_cust.
      lv_object = gc_debitor.
    ELSEIF   iv_objtype EQ gc_objtype_vend.
      lv_object = gc_kredebitor.
    ENDIF.
    SELECT object nrrangenr fromnumber tonumber FROM nriv
                                                INTO CORRESPONDING FIELDS OF TABLE gt_nriv
                                                WHERE object = lv_object.
    " CPD Account Group handling set this gv_skip_ota_adrchk flag by checking the customizing table cvi_prechk_sup
    SELECT SINGLE * FROM cvi_prechk_sup
                    INTO ls_cvi_prechk_sup
                    WHERE check_type = 10.
    IF sy-subrc = 0 AND ls_cvi_prechk_sup-checked = abap_true.
      gv_skip_ota_adrchk = abap_true.
    ELSE.
      gv_skip_ota_adrchk = abap_false.
    ENDIF.

  ENDMETHOD.


  METHOD prepare_custom_range.
    DATA:ls_ext_append_range TYPE LINE OF tt_ext_append_range,
         ls_ext_field_range  TYPE LINE OF tt_ext_field_range.

    CLEAR: et_custom_range_fields, et_custom_range_append.
* create range table for appends, appends can be created using Z/Y
    ls_ext_append_range-sign = 'I'.
    ls_ext_append_range-option = 'CP'.
    ls_ext_append_range-low = 'Y*'.
    APPEND ls_ext_append_range TO et_custom_range_append.

    CLEAR ls_ext_append_range.

    ls_ext_append_range-sign = 'I'.
    ls_ext_append_range-option = 'CP'.
    ls_ext_append_range-low = 'Z*'.
    APPEND ls_ext_append_range TO et_custom_range_append.

* Customer fields will be in YY/ZZ namespace.
    ls_ext_field_range-sign = 'I'.
    ls_ext_field_range-option = 'CP'.
    ls_ext_field_range-low = 'YY*'.
    APPEND ls_ext_field_range TO et_custom_range_fields.

    CLEAR ls_ext_field_range.

    ls_ext_field_range-sign = 'I'.
    ls_ext_field_range-option = 'CP'.
    ls_ext_field_range-low = 'ZZ*'.
    APPEND ls_ext_field_range TO et_custom_range_fields.
  ENDMETHOD.


  METHOD prepare_xml.

    DATA: lt_trans_param    TYPE abap_trans_srcbind_tab,
          ls_xml_str        TYPE string,
          ls_xml_xstr       TYPE xstring,
          lv_xsl_stylesheet TYPE string,
          lv_xml_substr     TYPE string,
          lv_offset         TYPE i.
    DATA: lr_conv                 TYPE REF TO cl_abap_conv_in_ce,
          lx_st_match_elem        TYPE REF TO cx_st_match_element,
          lx_st_match_attr        TYPE REF TO cx_st_match_attribute,
          lx_st_match_text        TYPE REF TO cx_st_match_text,
          lx_xslt_deserial        TYPE REF TO cx_xslt_deserialization_error,
          lx_xslt_runtime         TYPE REF TO cx_xslt_runtime_error,
          lx_xslt_format          TYPE REF TO cx_xslt_format_error,
          lx_abap_call            TYPE REF TO cx_xslt_abap_call_error,
          lx_invalid_trans        TYPE REF TO cx_invalid_transformation,
          lx_xslt_st              TYPE REF TO cx_st_error,
          lx_transformation_error TYPE REF TO cx_transformation_error,
          lx_invalid_range        TYPE REF TO cx_parameter_invalid_range,
          lx_converter_error      TYPE REF TO cx_sy_codepage_converter_init,
          lx_conv_codepage        TYPE REF TO cx_sy_conversion_codepage,
          lx_invalid_type         TYPE REF TO cx_parameter_invalid_type.
    Data: lv_info TYPE string.

    FIELD-SYMBOLS:
           <ls_trans_param> LIKE LINE OF lt_trans_param.

    CONSTANTS : lc_customer TYPE string VALUE 'CUSTOMER',
                lc_vendor   TYPE string VALUE 'VENDOR'.

    IF is_errcount_customer IS NOT INITIAL.
      APPEND INITIAL LINE TO lt_trans_param ASSIGNING <ls_trans_param>.
      <ls_trans_param>-name = lc_customer.
      GET REFERENCE OF is_errcount_customer INTO <ls_trans_param>-value.
    ENDIF.

    IF is_errcount_vendor IS NOT INITIAL.
      APPEND INITIAL LINE TO lt_trans_param ASSIGNING <ls_trans_param>.
      <ls_trans_param>-name = lc_vendor.
      GET REFERENCE OF is_errcount_vendor INTO <ls_trans_param>-value.
    ENDIF.

    IF it_customfieldcount_customer IS NOT INITIAL.
      APPEND INITIAL LINE TO lt_trans_param ASSIGNING <ls_trans_param>.
      <ls_trans_param>-name = lc_customer.
      GET REFERENCE OF it_customfieldcount_customer INTO <ls_trans_param>-value.
    ENDIF.

    IF it_customfieldcount_vendor IS NOT INITIAL.
      APPEND INITIAL LINE TO lt_trans_param ASSIGNING <ls_trans_param>.
      <ls_trans_param>-name = lc_vendor.
      GET REFERENCE OF it_customfieldcount_vendor INTO <ls_trans_param>-value.
    ENDIF.
    TRY .
        CALL TRANSFORMATION id SOURCE (lt_trans_param)
                            RESULT XML ls_xml_xstr.
      CATCH cx_st_match_element INTO lx_st_match_elem.
        lx_transformation_error = lx_st_match_elem.
      CATCH cx_st_match_attribute INTO lx_st_match_attr.
        lx_transformation_error = lx_st_match_attr.
      CATCH  cx_st_match_text INTO lx_st_match_text.
        lx_transformation_error = lx_st_match_text.
      CATCH cx_xslt_deserialization_error INTO lx_xslt_deserial.
        lx_transformation_error = lx_xslt_deserial.
      CATCH cx_xslt_runtime_error INTO lx_xslt_runtime.
        lx_transformation_error = lx_xslt_runtime.
      CATCH cx_xslt_format_error  INTO lx_xslt_format.
        lx_transformation_error = lx_xslt_format.
      CATCH cx_xslt_abap_call_error INTO lx_abap_call.
        lx_transformation_error = lx_abap_call.
      CATCH cx_st_error INTO lx_xslt_st.
        lx_transformation_error = lx_xslt_st.
      CATCH cx_invalid_transformation INTO lx_invalid_trans.
        lx_transformation_error = lx_invalid_trans.
    ENDTRY.

    IF lx_transformation_error IS BOUND.
       lv_info = lx_transformation_error->get_text( ).
      MESSAGE Lv_info TYPE 'I'.
      RAISE EXCEPTION lx_transformation_error.
    ENDIF.


    TRY .
        lr_conv = cl_abap_conv_in_ce=>create(
                 encoding    = 'UTF-8'
                 input       =  ls_xml_xstr
               ).
      CATCH cx_parameter_invalid_range INTO lx_invalid_range.    " Parameter with invalid value range
        Clear Lv_info.
        lv_info = lx_invalid_range->get_text( ).
        MESSAGE lv_info TYPE 'I'.
        RAISE EXCEPTION lx_invalid_range.
      CATCH cx_sy_codepage_converter_init INTO lx_converter_error. " System Exception for Code Page Converter Initialization
        CLEAR Lv_info.
        Lv_info = lx_converter_error->get_text( ).
        MESSAGE Lv_info TYPE 'I'.
        RAISE EXCEPTION lx_converter_error.
    ENDTRY.
    TRY .
        lr_conv->read(
        IMPORTING
          data =   ls_xml_str               " Data Object To Be Read
      ).
      CATCH cx_sy_conversion_codepage INTO lx_conv_codepage.     " System exception in character set conversion
        clear lv_info.
        lv_info = lx_conv_codepage->get_text( ).
        MESSAGE lv_info TYPE 'I'.
        RAISE EXCEPTION lx_conv_codepage.
      CATCH cx_sy_codepage_converter_init INTO lx_converter_error. " System Exception for Code Page Converter Initialization
        clear lv_info.
        lv_info = lx_converter_error->get_text( ).
        MESSAGE Lv_info TYPE 'I'.
        RAISE EXCEPTION lx_converter_error.
      CATCH cx_parameter_invalid_type INTO lx_invalid_type.     " Parameter with Invalid Type
        Clear lv_info.
        lv_info = lx_invalid_type->get_text( ).
        MESSAGE lv_info TYPE 'I'.
        RAISE EXCEPTION lx_invalid_type.
      CATCH cx_parameter_invalid_range INTO lx_invalid_range.    " Parameter with invalid value range
        clear lv_info.
        lv_info =  lx_invalid_range->get_text( ).
        MESSAGE lv_info TYPE 'I'.
        RAISE EXCEPTION lx_invalid_range.
    ENDTRY.

    lv_xsl_stylesheet = '><?xml-stylesheet type="text/xsl" href="bpcc.xsl"?' ##NO_TEXT.

    FIND FIRST OCCURRENCE OF '>' IN ls_xml_str MATCH OFFSET lv_offset.
    IF sy-subrc = 0.
      lv_xml_substr = ls_xml_str(lv_offset).
      CONCATENATE lv_xml_substr lv_xsl_stylesheet ls_xml_str+lv_offset INTO ls_xml_str.
    ENDIF.

    es_xml = ls_xml_str.

  ENDMETHOD.


  METHOD prepare_xsl.

    CONCATENATE
    '<?xml version="1.0" encoding="UTF-8"?>'

    '<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:asx="http://www.sap.com/abapxml">'

     '<xsl:output method="html"/>'
     '<xsl:template match="/asx:abap/asx:values">'
     '<html>'
      '<head>'
        '<title>SAP Readiness Check</title>'
        '<link rel="stylesheet" type="text/css" href="style.css"/>'
        '<style>'
          '* {box-sizing: border-box;}'
          '.header { padding: 15px; text-align: left; font-weight:bold; column-width:120px; }' ##NO_TEXT
          '.cust{ width: 50%; float: left;  padding: 15px; text-align: center; }'
          '.vend{ width: 50%; float: left; padding: 15px; text-align: center; }'
          'table, th, td{ border: 1px solid black;  border-collapse: collapse; width: 60%; text-align: left;  padding: 4px; font-weight:normal; }'
          '.additional{ padding-top: 15px;  text-align: center; }'
          'h2,h4{ padding: 0px; margin: 0px; }'
          '.main-header{ padding: 15px; text-align: center; font-weight:bold; }'
        '</style>'
        '</head>'
      '<body>'
        '<div class="main-header"> '
          '<h1>SAP Readiness Check</h1>'
          '<h2>Business Partner</h2>'
        '</div>'
        '<div class="cust">'
          '<h2>Customer Master</h2>'
          '<p></p>'
          '<h4>Total count of Customers: <xsl:value-of select="CUSTOMER/TOTALCOUNT"/></h4>'
          '<h4>Total count of Contact Persons: <xsl:value-of select="CUSTOMER/CONTACTPERS"/></h4>'
          '<h4>Total count of Account Groups: <xsl:value-of select="CUSTOMER/ACCGROUP"/></h4>'
          '<h4>Total count of Unsynchronized Customers: <xsl:value-of select="CUSTOMER/UNSYNCCOUNT"/></h4>'
          '<h4>Total count of Unsynchronized Contact Persons: <xsl:value-of select="CUSTOMER/UNSYNCCONTACT"/></h4>'
          '<h4>Total count of Inconsistencies: <xsl:value-of select="CUSTOMER/TOTALERRORS"/></h4>'
          '<p></p>'
          '<table  align="center">'
            '<tr>'
              '<th class="header">Business Check</th>'
              '<th class="header">Count of Errors</th>'
            '</tr>'

            '<tr>'
              '<th>Tax Code</th>'
              '<td>'
                '<xsl:value-of select="CUSTOMER/TAXCODE"/>'
              '</td>'
            '</tr>'
            '<tr>'
              '<th>Email</th>'
              '<td>'
                '<xsl:value-of select="CUSTOMER/EMAIL"/>'
              '</td>'
            '</tr>'
            '<tr>'
              '<th>Transport Zone</th>'
              '<td>'
                '<xsl:value-of select="CUSTOMER/TRANSZONE"/>'
              '</td>'
            '</tr>'
            '<tr>'
              '<th>Postal Code</th>'
              '<td>'
                '<xsl:value-of select="CUSTOMER/POSTALCODE"/>'
              '</td>'
            '</tr>'
            '<tr>'
              '<th>Tax Jurisdiction</th>'
              '<td>'
                '<xsl:value-of select="CUSTOMER/TAXJURD"/>'
              '</td>'
            '</tr>'
            '<tr>'
              '<th>Address</th>'
              '<td>'
                '<xsl:value-of select="CUSTOMER/ADDRESS"/>'
              '</td>'
            '</tr>'
            '<tr>'
              '<th>Bank</th>'
              '<td>'
                '<xsl:value-of select="CUSTOMER/BANK"/>'
              '</td>'
            '</tr>'
            '<tr>'
              '<th>Industry</th>'
              '<td>'
                '<xsl:value-of select="CUSTOMER/INDUSTRY"/>'
              '</td>'
            '</tr>'
            '<tr>'
              '<th>Number Range</th>'
              '<td>'
                '<xsl:value-of select="CUSTOMER/NUMRANGE"/>'
              '</td>'
            '</tr>'
          '</table>'
        '</div>'
        '<div class="vend">'
          '<h2>Vendor Master </h2>'
          '<p></p>'
          '<h4>Total count of Vendors: <xsl:value-of select="VENDOR/TOTALCOUNT"/></h4>'
          '<h4>Total count of Contact Persons: <xsl:value-of select="VENDOR/CONTACTPERS"/></h4>'
          '<h4>Total count of Account Groups : <xsl:value-of select="VENDOR/ACCGROUP"/></h4>'
          '<h4>Total count of Unsynchronized Vendors: <xsl:value-of select="VENDOR/UNSYNCCOUNT"/></h4>'
          '<h4>Total count of Unsynchronized Contact Persons: <xsl:value-of select="VENDOR/UNSYNCCONTACT"/></h4>'
          '<h4>Total count of Inconsistencies: <xsl:value-of select="VENDOR/TOTALERRORS"/></h4>'
          '<p></p>'
          '<table  align="center">'
            '<tr>'
              '<th class="header">Business Check</th>'
              '<th class="header">Count of Errors</th>'
            '</tr>'
            '<tr>'
              '<th>Tax Code</th>'
              '<td>'
                '<xsl:value-of select="VENDOR/TAXCODE"/>'
              '</td>'
            '</tr>'
            '<tr>'
              '<th>Email</th>'
              '<td>'
                '<xsl:value-of select="VENDOR/EMAIL"/>'
              '</td>'
            '</tr>'
            '<tr>'
              '<th>Transport Zone</th>'
              '<td>'
                '<xsl:value-of select="VENDOR/TRANSZONE"/>'
              '</td>'
            '</tr>'
            '<tr>'
              '<th>Postal Code</th>'
              '<td>'
                '<xsl:value-of select="VENDOR/POSTALCODE"/>'
              '</td>'
            '</tr>'
            '<tr>'
              '<th>Tax Jurisdiction</th>'
              '<td>'
                '<xsl:value-of select="VENDOR/TAXJURD"/>'
              '</td>'
            '</tr>'
            '<tr>'
              '<th>Address</th>'
              '<td>'
                '<xsl:value-of select="VENDOR/ADDRESS"/>'
              '</td>'
            '</tr>'
            '<tr>'
              '<th>Bank</th>'
              '<td>'
                '<xsl:value-of select="VENDOR/BANK"/>'
              '</td>'
            '</tr>'
            '<tr>'
              '<th>Industry</th>'
              '<td>'
                '<xsl:value-of select="VENDOR/INDUSTRY"/>'
              '</td>'
            '</tr>'
            '<tr>'
              '<th>Number Range</th>'
              '<td>'
                '<xsl:value-of select="VENDOR/NUMRANGE"/>'
              '</td>'
            '</tr>'
          '</table>'
        '</div>'
        '<div class="additional">'
          '<h2>Information about Custom Fields</h2>'
        '</div>'
        '<div class="cust">'
          '<h2>Customer Tables</h2>'
          '<p></p>'
          '<table align="center" >'
            '<tr>'
              '<th class="header">Tables</th>'
              '<th class="header">Count of Append</th>'
              '<th class="header">Count of Fields</th>'
            '</tr>'
            '<xsl:for-each select="CUSTOMER/item">'
              '<tr>'
                '<td>'
                  '<xsl:value-of select="TABNAME"/>'
                '</td>'
                '<td>'
                  '<xsl:value-of select="APPEND_COUNT"/>'
                '</td>'
                '<td>'
                  '<xsl:value-of select="FIELD_COUNT"/>'
                '</td>'
              '</tr>'
            '</xsl:for-each>'
          '</table>'
        '</div>'
        '<div class="vend">'
          '<h2>Vendor Tables</h2>'
          '<p></p>'
          '<table align="center" >'
            '<tr>'
              '<th class="header">Tables</th>'
              '<th class="header">Count of Append</th>'
              '<th class="header">Count of Fields</th>'
            '</tr>'
            '<xsl:for-each select="VENDOR/item">'
              '<tr>'
                '<td>'
                  '<xsl:value-of select="TABNAME"/>'
                '</td>'
                '<td>'
                  '<xsl:value-of select="APPEND_COUNT"/>'
                '</td>'
                '<td>'
                  '<xsl:value-of select="FIELD_COUNT"/>'
                '</td>'
              '</tr>'
            '</xsl:for-each>'
          '</table>'
        '</div>'
        '</body>'
    '</html>'
  '</xsl:template>'
'</xsl:stylesheet> '

  INTO es_xsl.
  ENDMETHOD.


  METHOD process_rc_data.
    DATA: l_c1                 TYPE cursor,
          lv_check_name_s      TYPE string,
          lv_check_name_d      TYPE string,
          lv_objtype           TYPE char1,
          lv_count             TYPE int4,
          lv_text              TYPE string,
          lv_objname           TYPE string,
          ls_rc_business_check TYPE ty_rc_business_check,
          lt_chk_data          TYPE tt_rc_master_data,
          lo_type_descr        TYPE REF TO cl_abap_typedescr,
          lo_stru_descr        TYPE REF TO cl_abap_structdescr,
          lt_comp_name         TYPE cl_abap_structdescr=>component_table,
          lt_rangetab_cust     TYPE tt_rangetab_kunnr,
          lt_rangetab_vend     TYPE tt_rangetab_lifnr,
          lv_cond              TYPE char10,
          lines                TYPE int4,
          ls_chk_data          TYPE ty_rc_master_data.
    FIELD-SYMBOLS: <ls_comp_name>   LIKE LINE OF lt_comp_name,
                   <lt_errors>      TYPE INDEX TABLE,
                   <lv_error_count> TYPE any.

    CLEAR: es_errcount_customer, es_errcount_vendor, et_customfieldcount_customer, et_customfieldcount_vendor.
*   customer
    SELECT COUNT(*) FROM kna1 INTO es_errcount_customer-totalcount "#EC CI_NOWHERE
    .
    SELECT COUNT(*) FROM knvk INTO es_errcount_customer-contactpers WHERE kunnr NE space "#EC CI_NOFIELD
    .
    SELECT COUNT(*) FROM cvi_cust_ct_link INTO lv_count. "#EC CI_NOWHERE
    es_errcount_customer-unsynccontact = es_errcount_customer-contactpers - lv_count.
    CLEAR lv_count.
*   vendor
    SELECT COUNT(*) FROM lfa1 INTO es_errcount_vendor-totalcount "#EC CI_NOWHERE
    .
    SELECT COUNT(*) FROM knvk INTO es_errcount_vendor-contactpers WHERE lifnr NE space "#EC CI_NOFIELD
    .
    SELECT COUNT(*) FROM cvi_vend_ct_link INTO lv_count. "#EC CI_NOWHERE
    es_errcount_vendor-unsynccontact = es_errcount_vendor-contactpers - lv_count.
    CLEAR lv_count.

*   Account Group
    Select Count(*) FROM T077d INTO  es_errcount_Customer-accgroup."#EC CI_BYPASS
    Select Count(*) FROM T077k INTO  es_errcount_vendor-accgroup."#EC CI_BYPASS

*   OPEN/CLOSE File cursor could not be used, as the cursor gets closed after the first iteration.
*   This could possibly happen due to any issue caused in the underlying validate FM's.
*   It could be due to any RAISE exception triggered in the FM.

*   Hence, we have followed the below approach:-
*   1. SELECT the data in packages of size 10K.
*   2. We keep track of the last customer / vendor fetched in the current iteration (LV_COND).
*   3. We use the lV_COND value to fetch the next package size of 10K.
*   4. This is performed in an endless LOOP until all the data in the customer/vendor has been processed.


    CLEAR: lv_objtype, lv_cond.
    lv_objtype = gc_objtype_cust.
    DO.
            SELECT
            kunnr AS cvnum adrnr brsch land1 txjcd stceg stcdt ktokd AS acc_group
            stcd1 stcd2 stcd3 stcd4 stcd5 stkzn stkzu regio
  FROM kna1                                             "#EC CI_NOFIELD
  INTO CORRESPONDING FIELDS OF TABLE lt_chk_data
        UP TO gc_package_size ROWS
  WHERE kunnr NOT IN ( SELECT customer FROM cvi_cust_link ) "#EC CI_NOWHERE
        AND kunnr GT lv_cond ORDER BY cvnum ASCENDING.

      IF sy-subrc = 0.
        CALL METHOD cl_cvi_readiness_check=>validate_data
          EXPORTING
            it_chk_data          = lt_chk_data
            iv_objtype           = lv_objtype    " obj type
          IMPORTING
            es_rc_business_check = ls_rc_business_check.
*     collect the count
        es_errcount_customer-unsynccount = es_errcount_customer-unsynccount + lines( lt_chk_data ).
        DESCRIBE TABLE lt_chk_data LINES lines.
        READ TABLE lt_chk_data INDEX lines INTO ls_chk_data .
        IF sy-subrc = 0.
          lv_cond = ls_chk_data-cvnum.
        ENDIF.
        IF lt_comp_name IS INITIAL.
          lo_type_descr = cl_abap_typedescr=>describe_by_data( ls_rc_business_check ).
          CHECK lo_type_descr IS BOUND.
          lo_stru_descr ?= lo_type_descr.
          lt_comp_name = lo_stru_descr->get_components( ).
        ENDIF.
        LOOP AT lt_comp_name ASSIGNING <ls_comp_name>.
          CLEAR lv_count.
          CONCATENATE 'es_errcount_customer-' <ls_comp_name>-name INTO lv_check_name_d.
          CONCATENATE 'ls_rc_business_check-' <ls_comp_name>-name INTO lv_check_name_s.
          ASSIGN (lv_check_name_s) TO <lt_errors>.
          CHECK <lt_errors> IS ASSIGNED.
          ASSIGN (lv_check_name_d) TO <lv_error_count>.
          CHECK <lv_error_count> IS ASSIGNED.
          DESCRIBE TABLE <lt_errors> LINES lv_count.
          <lv_error_count> = <lv_error_count> + lv_count.
          es_errcount_customer-totalerrors = es_errcount_customer-totalerrors + lv_count.
        ENDLOOP.
      ELSE.
        EXIT. " No record, Exit
      ENDIF.
      CLEAR: ls_rc_business_check, lt_chk_data.
    ENDDO.

    CLEAR: lv_objtype, lv_cond, lt_comp_name .
*    Process vendor data
*    Package size 10,000 records per select
        lv_objtype = gc_objtype_vend.
    DO.
          SELECT
               lifnr AS cvnum adrnr brsch land1 txjcd stceg stcdt ktokk AS acc_group
               stcd1 stcd2 stcd3 stcd4 stcd5 stkzn stkzu regio
    FROM lfa1                                           "#EC CI_NOFIELD
    INTO CORRESPONDING FIELDS OF TABLE lt_chk_data
        UP TO gc_package_size ROWS
    WHERE lifnr NOT IN ( SELECT vendor FROM cvi_vend_link ) "#EC CI_NOWHERE
        AND lifnr GT lv_cond ORDER BY lifnr ASCENDING.
      .
        IF sy-subrc = 0.
          CALL METHOD cl_cvi_readiness_check=>validate_data
            EXPORTING
              it_chk_data          = lt_chk_data
              iv_objtype           = lv_objtype    " obj type
            IMPORTING
              es_rc_business_check = ls_rc_business_check.
*     collect the count
        es_errcount_vendor-unsynccount = es_errcount_vendor-unsynccount + lines( lt_chk_data ).
        DESCRIBE TABLE lt_chk_data LINES lines.
        READ TABLE lt_chk_data INDEX lines INTO ls_chk_data .
        IF sy-subrc = 0.
          lv_cond = ls_chk_data-cvnum.
          ENDIF.
          IF lt_comp_name IS INITIAL.
            lo_type_descr = cl_abap_typedescr=>describe_by_data( ls_rc_business_check ).
            CHECK lo_type_descr IS BOUND.
            lo_stru_descr ?= lo_type_descr.
            lt_comp_name = lo_stru_descr->get_components( ).
          ENDIF.
          LOOP AT lt_comp_name ASSIGNING <ls_comp_name>.
            CLEAR lv_count.
          CONCATENATE 'es_errcount_vendor-' <ls_comp_name>-name INTO lv_check_name_d.
            CONCATENATE 'ls_rc_business_check-' <ls_comp_name>-name INTO lv_check_name_s.
            ASSIGN (lv_check_name_s) TO <lt_errors>.
            CHECK <lt_errors> IS ASSIGNED.
            ASSIGN (lv_check_name_d) TO <lv_error_count>.
            CHECK <lv_error_count> IS ASSIGNED.
            DESCRIBE TABLE <lt_errors> LINES lv_count.
            <lv_error_count> = <lv_error_count> + lv_count.
          es_errcount_vendor-totalerrors = es_errcount_vendor-totalerrors + lv_count.
          ENDLOOP.
        ELSE.
        EXIT.
        ENDIF.
        CLEAR: ls_rc_business_check, lt_chk_data.
    ENDDO.

*     Write info messages in the spool
    DO 2 TIMES.
      IF sy-index = 1.
        lv_objtype = gc_objtype_cust.
      ELSEIF sy-index = 2.
        lv_objtype = gc_objtype_vend.
      ENDIF.
      UNASSIGN: <ls_comp_name>.
      CLEAR: lv_check_name_d.
      IF lv_objtype = gc_objtype_cust.
        CONCATENATE TEXT-002 TEXT-003 INTO lv_text SEPARATED BY space.
        MESSAGE i001(00) WITH lv_text es_errcount_customer-totalcount .
        CLEAR lv_text.
        CONCATENATE TEXT-002 TEXT-005 INTO lv_text SEPARATED BY space.
        MESSAGE i001(00) WITH lv_text es_errcount_customer-unsynccount.
        CONCATENATE TEXT-002 TEXT-010 INTO lv_text SEPARATED BY space.
        MESSAGE i001(00) WITH lv_text es_errcount_customer-unsynccontact.
        CONCATENATE TEXT-002 TEXT-012 INTO lv_text SEPARATED BY space.
        MESSAGE i001(00) WITH lv_text es_errcount_customer-totalerrors.
      ELSE.
        CLEAR lv_text.
        CONCATENATE TEXT-002 TEXT-004 INTO lv_text SEPARATED BY space.
        MESSAGE i001(00) WITH lv_text es_errcount_vendor-totalcount.
        CLEAR lv_text.
        CONCATENATE TEXT-002 TEXT-006 INTO lv_text SEPARATED BY space.
        MESSAGE i001(00) WITH lv_text es_errcount_vendor-unsynccount.
        CONCATENATE TEXT-002 TEXT-011 INTO lv_text SEPARATED BY space.
        MESSAGE i001(00) WITH lv_text es_errcount_vendor-unsynccontact.
        CONCATENATE TEXT-002 TEXT-013 INTO lv_text SEPARATED BY space.
        MESSAGE i001(00) WITH lv_text es_errcount_vendor-totalcount.
      ENDIF.
      LOOP AT lt_comp_name ASSIGNING <ls_comp_name>.
        CLEAR lv_text.
        IF lv_objtype = gc_objtype_cust.
          CONCATENATE 'es_errcount_customer-' <ls_comp_name>-name INTO lv_check_name_d.
          lv_objname = TEXT-003.
        ELSEIF lv_objtype = gc_objtype_vend.
          CONCATENATE 'es_errcount_vendor-' <ls_comp_name>-name INTO lv_check_name_d.
          lv_objname = TEXT-004.
        ENDIF.
        REPLACE ':' IN lv_objname WITH space.
        CONCATENATE TEXT-001 lv_objname <ls_comp_name>-name INTO lv_text SEPARATED BY space.
        MESSAGE i001(00) WITH lv_text ' :' (lv_check_name_d).
      ENDLOOP.
    ENDDO.

    IF lv_objtype = gc_objtype_cust.
        lo_type_descr = cl_abap_typedescr=>describe_by_data( es_errcount_customer ).
      ELSE.
        lo_type_descr = cl_abap_typedescr=>describe_by_data( es_errcount_vendor ).
      ENDIF.
      CHECK lo_type_descr IS BOUND.
      lo_stru_descr ?= lo_type_descr.
      lt_comp_name = lo_stru_descr->get_components( ).
*   Get custom fields and appends information for customer and vendor
    CALL METHOD cl_cvi_readiness_check=>get_custom_fields_info
      IMPORTING
        et_customfieldcount_customer = et_customfieldcount_customer
        et_customfieldcount_vendor   = et_customfieldcount_vendor.
  ENDMETHOD.


  METHOD validate_data.
    data lv_tabix type sy-tabix.
    DATA: lv_nrobject TYPE nrobj,
          ls_address  TYPE adrc,
          lv_xcpds    TYPE xcpds.

    FIELD-SYMBOLS: <ls_chk_data> TYPE ty_rc_master_data.
    FIELD-SYMBOLS: <ls_t077d> TYPE ty_t077d.
    FIELD-SYMBOLS: <ls_t077k> TYPE ty_t077k.

    CLEAR: es_rc_business_check.

    CHECK it_chk_data IS NOT INITIAL.

    CALL METHOD get_data_for_validation
      EXPORTING
        iv_objtype = iv_objtype.

    CALL METHOD get_address
      EXPORTING
        it_chk_data = it_chk_data.

    CALL METHOD get_bank_data
      EXPORTING
        it_chk_data = it_chk_data
        iv_objtype  = iv_objtype.

    SORT gt_address BY addrnumber.

    LOOP AT it_chk_data ASSIGNING <ls_chk_data>.

      CALL METHOD execute_bank_check
        EXPORTING
          iv_objectid = <ls_chk_data>-cvnum                 " Customer/Vendor Number
          iv_objtype  = iv_objtype                 " Business Object type - Customer or Vendor
        CHANGING
          ct_error    = es_rc_business_check-bank. "lt_error.

      READ TABLE gt_address TRANSPORTING NO FIELDS WITH KEY addrnumber = <ls_chk_data>-adrnr BINARY SEARCH.
      IF sy-subrc = 0.
      lv_tabix = sy-tabix.
        IF iv_objtype = if_cvi_prechk=>gc_objtype_cust.
          READ TABLE gt_t077d ASSIGNING <ls_t077d> WITH KEY ktokd = <ls_chk_data>-acc_group.
          IF sy-subrc = 0.
            lv_xcpds = <ls_t077d>-xcpds.
          ENDIF.
        ELSEIF iv_objtype = if_cvi_prechk=>gc_objtype_vend.
          READ TABLE gt_t077k ASSIGNING <ls_t077k> WITH KEY ktokk = <ls_chk_data>-acc_group.
          IF sy-subrc = 0.
            lv_xcpds = <ls_t077k>-xcpds.
          ENDIF.
        ENDIF.
        LOOP AT gt_address INTO ls_address FROM lv_tabix .
        if ls_address-addrnumber <> <ls_chk_data>-adrnr.
          exit.
         ENDIF.
*      IF sy-subrc = 0.
          "Skip the address check for CPD relevant customer and vendor
          IF NOT ( gv_skip_ota_adrchk = abap_true AND lv_xcpds = abap_true ).
            "Address data checks
        CALL METHOD execute_address_check
          EXPORTING
            iv_objectid = <ls_chk_data>-cvnum                 " Customer/Vendor Number
            is_address  = ls_address                 " Addresses (Business Address Services)
          CHANGING
            ct_error    = es_rc_business_check-address. "lt_error.

        "Postal code checks.
        CALL METHOD execute_postcode_check
          EXPORTING
            iv_objectid = <ls_chk_data>-cvnum                 " Customer/Vendor Number
            is_address  = ls_address                 " Addresses (Business Address Services)
          CHANGING
            ct_error    = es_rc_business_check-postalcode. "lt_error.

            "Tax jurisdiction code checks
        CALL METHOD execute_tax_jur_check
          EXPORTING
            iv_objectid = <ls_chk_data>-cvnum                " Customer/Vendor Number
            iv_objtype  = iv_objtype                " Business Object type - Customer or Vendor
            iv_txjcd    = <ls_chk_data>-txjcd                " Tax Jurisdiction
            is_address  = ls_address                " Addresses (Business Address Services)
          CHANGING
            ct_error    = es_rc_business_check-taxjurd. "lt_error.
          ENDIF.
          "Email field check
          CALL METHOD execute_email_check
            EXPORTING
              iv_objectid = <ls_chk_data>-cvnum                " Customer/Vendor Number
              is_address  = ls_address                " Addresses (Business Address Services)
            CHANGING
              ct_error    = es_rc_business_check-email. "lt_error.

        "Transportation zone checks
        CALL METHOD execute_transzone_check
          EXPORTING
            iv_objectid    = <ls_chk_data>-cvnum                 " Customer/Vendor Number
            iv_objtype     = iv_objtype                 " Business Object type - Customer or Vendor
            is_address     = ls_address                 " Addresses (Business Address Services)
            is_master_data = <ls_chk_data>
          CHANGING
            ct_error       = es_rc_business_check-transzone. "lt_error.
*      ENDIF.
        endloop.
        ENDIF.

      "Industry assignment checks
      CALL METHOD execute_industry_check
        EXPORTING
          iv_objectid        = <ls_chk_data>-cvnum                " Customer/Vendor Number
          iv_industry_sector = <ls_chk_data>-brsch                " Industry key
        CHANGING
          ct_error           = es_rc_business_check-industry. "lt_error.

      "Tax code checks
      CALL METHOD execute_tax_type_check
        EXPORTING
          is_selection_param = <ls_chk_data>                 " Fields for Pre-checking Master Data
          iv_objtype         = iv_objtype                 " Business Object type - Customer or Vendor
        CHANGING
          ct_error           = es_rc_business_check-taxcode. "lt_error.

      IF iv_objtype = gc_objtype_cust.
        lv_nrobject = gc_debitor.
      ELSEIF iv_objtype = gc_objtype_vend.
        lv_nrobject = gc_kredebitor.
      ENDIF.
      "Number range checks
      CALL METHOD execute_number_range_check
        EXPORTING
          iv_objectid      = <ls_chk_data>-cvnum              " Customer/Vendor Number
          iv_objtype       = iv_objtype                " Business Object type - Customer or Vendor
          iv_account_group = <ls_chk_data>-acc_group                 " Undefined range (can be used for patch levels)
          iv_nrobject      = lv_nrobject                " TYPE TO BE CHANGED TO NROBJECT
        CHANGING
          ct_error         = es_rc_business_check-numrange. "lt_error.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
