class CL_CVI_PRECHK definition
  public
  final
  create public .

public section.

  class-methods GET_LOG_DATA
    importing
      !IM_FILTER type IF_CVI_PRECHK=>TY_LOG_GEN_SELECTION
    exporting
      !EX_DATA type IF_CVI_PRECHK=>TT_CVI_PRECHK_MIG .
  class-methods DELETE_LOG_DATA
    importing
      !IM_RUNID type CVI_PRECHK_RUNID
    exporting
      !EX_SUBRC type SY-SUBRC .
  class-methods PROCESS_SELECTION_DATA
    importing
      !IM_GEN_SELECTION type IF_CVI_PRECHK=>TY_GENERAL_SELECTION
      !IM_SCENARIO type IF_CVI_PRECHK=>TY_SCENARIO_SELECTION
    exporting
      !EX_RETURN type BAPIRET2
      !EX_PRECHK_HEADER type CVI_PRECHK
    exceptions
      RUNID_ID_ERROR .
  class-methods GET_CURRENT_RUN_STATUS
    changing
      !CH_RUNID_STATUS type IF_CVI_PRECHK=>TT_RUINID_STATUS .
  class-methods PPF_BEFORE_CALL
    exporting
      !EX_START_RFC type SAP_BOOL
    changing
      !CH_PPF_DATA type ref to IF_CVI_PRECHK=>TY_PPF_PARAM
      !CT_RFCDATA type SPTA_T_INDXTAB .
  class-methods PPF_IN_CALL
    changing
      !CT_RFC_DATA type SPTA_T_INDXTAB .
  class-methods PPF_AFTER_CALL
    importing
      !IT_RFC_DATA type SPTA_T_INDXTAB .
  class-methods GET_RESULT_DATA
    importing
      !IM_RUNID type CVI_PRECHK_RUNID
    exporting
      !EX_DATA type IF_CVI_PRECHK=>TT_ALV_RESULT_TAB .
  class-methods GET_SCENARIOS
    importing
      !IM_RUNID type CVI_PRECHK_RUNID
    exporting
      !EX_SCENARIO type IF_CVI_PRECHK=>TY_SCENARIO_SELECTION .
  class-methods VALIDATE_ALL_DATA
    importing
      !IS_SELECTION_PARAM type IF_CVI_PRECHK=>TY_PPF_PARAM
      !IV_OBJTYPE type CVI_PRECHK_OBJTYPE
    exporting
      !ET_ERROR type IF_CVI_PRECHK=>TT_PRECHK_ERROR .
  class-methods GET_ADDRESS
    importing
      !IS_SELECTION_PARAM type IF_CVI_PRECHK=>TY_PPF_PARAM
      !IV_OBJTYPE type CVI_PRECHK_OBJTYPE .
  class-methods VALIDATE_SELECTION_INPUT
    importing
      !IM_GEN_SELECTION type IF_CVI_PRECHK=>TY_GENERAL_SELECTION
      !IM_SCENARIO type IF_CVI_PRECHK=>TY_SCENARIO_SELECTION
    exporting
      !EX_RETURN type BAPIRET2 .
  class-methods UPDATE_PRECHK_STATUS
    importing
      !P_TASK type CLIKE .
protected section.
private section.

  class-data:
    gt_lfbk TYPE STANDARD TABLE OF lfbk .
  class-data:
    gt_knbk TYPE STANDARD TABLE OF knbk .
  class-data:
    gt_t005 TYPE TABLE OF t005 .
  class-data:
    gt_t077d TYPE TABLE OF t077d .
  class-data:
    gt_t077k TYPE TABLE OF t077k .
  class-data:
    gt_tsad3 TYPE HASHED TABLE OF tsad3 WITH UNIQUE KEY title .
  class-data GT_TZONE type CVI_PRECHK_TZONE_TT .
  class-data:
    gt_nriv TYPE SORTED TABLE OF nriv WITH UNIQUE KEY object nrrangenr .
  class-data:
    gt_tfktaxnumtype TYPE HASHED TABLE OF tfktaxnumtype WITH UNIQUE KEY taxtype .
  class-data GT_ADDRESS type TTY_ADRC .
  class-data GV_RUNID type CVI_PRECHK_RUNID .
  class-data GV_RECORD_CNT type INT4 .
  class-data GV_ISTYPE type BU_ISTYPE .
  class-data:
    gt_knas TYPE STANDARD TABLE OF knas .
  class-data:
    gt_lfas TYPE STANDARD TABLE OF lfas .

  class-methods EXECUTE_ADDRESS_CHECK
    importing
      !IV_OBJECTID type CVI_PRECHK_CVNUM
      !IV_OBJTYPE type CVI_PRECHK_OBJTYPE
      !IS_ADDRESS type ADRC
    changing
      !CT_ERROR type IF_CVI_PRECHK=>TT_PRECHK_ERROR .
  class-methods GENERATE_RUNID
    exporting
      !EX_RUNID type CVI_PRECHK_RUNID
    exceptions
      NO_INTERVAL_MAINTAINED
      NUMBER_GENERATION_ERROR .
  class-methods EXECUTE_EMAIL_CHECK
    importing
      !IV_OBJECTID type CVI_PRECHK_CVNUM
      !IV_OBJTYPE type CVI_PRECHK_OBJTYPE
      !IS_ADDRESS type ADRC
    changing
      !CT_ERROR type IF_CVI_PRECHK=>TT_PRECHK_ERROR .
  class-methods INSERT_ERROR_REC
    importing
      !IM_ERROR_REC type IF_CVI_PRECHK=>TT_PRECHK_ERROR .
  class-methods GET_DATA_FOR_VALIDATION
    importing
      !IS_SELECTION_PARAM type IF_CVI_PRECHK=>TY_PPF_PARAM .
  class-methods GET_BANK_DATA
    importing
      !IS_SELECTION_PARAM type IF_CVI_PRECHK=>TY_PPF_PARAM
      !IV_OBJTYPE type CVI_PRECHK_OBJTYPE .
  class-methods EXECUTE_NUMBER_RANGE_CHECK
    importing
      !IV_OBJECTID type CVI_PRECHK_CVNUM
      !IV_OBJTYPE type CVI_PRECHK_OBJTYPE
      !IV_ACCOUNT_GROUP type CHAR4
      !IV_NROBJECT type NROBJ
    changing
      !CT_ERROR type IF_CVI_PRECHK=>TT_PRECHK_ERROR .
  class-methods EXECUTE_BANK_CHECK
    importing
      !IV_OBJECTID type CVI_PRECHK_CVNUM
      !IV_OBJTYPE type CVI_PRECHK_OBJTYPE
    changing
      !CT_ERROR type IF_CVI_PRECHK=>TT_PRECHK_ERROR .
  class-methods EXECUTE_TAX_TYPE_CHECK
    importing
      !IS_SELECTION_PARAM type IF_CVI_PRECHK=>TY_PRECHK_MASTER_DATA
      !IV_OBJTYPE type CVI_PRECHK_OBJTYPE
    changing
      !CT_ERROR type IF_CVI_PRECHK=>TT_PRECHK_ERROR .
  class-methods EXECUTE_TAX_JUR_CHECK
    importing
      !IV_OBJECTID type CVI_PRECHK_CVNUM
      !IV_OBJTYPE type CVI_PRECHK_OBJTYPE
      !IV_TXJCD type TXJCD
      !IS_ADDRESS type ADRC
    changing
      !CT_ERROR type IF_CVI_PRECHK=>TT_PRECHK_ERROR .
  class-methods EXECUTE_POSTCODE_CHECK
    importing
      !IV_OBJECTID type CVI_PRECHK_CVNUM
      !IV_OBJTYPE type CVI_PRECHK_OBJTYPE
      !IS_ADDRESS type ADRC
    changing
      !CT_ERROR type IF_CVI_PRECHK=>TT_PRECHK_ERROR .
  class-methods EXECUTE_TRANSZONE_CHECK
    importing
      !IV_OBJECTID type CVI_PRECHK_CVNUM
      !IV_OBJTYPE type CVI_PRECHK_OBJTYPE
      !IS_ADDRESS type ADRC
      !IS_MASTER_DATA type IF_CVI_PRECHK=>TY_PRECHK_MASTER_DATA
    changing
      !CT_ERROR type IF_CVI_PRECHK=>TT_PRECHK_ERROR .
  class-methods EXECUTE_INDUSTRY_CHECK
    importing
      !IV_OBJECTID type CVI_PRECHK_CVNUM
      !IV_OBJTYPE type CVI_PRECHK_OBJTYPE
      !IV_INDUSTRY_SECTOR type BRSCH
    changing
      !CT_ERROR type IF_CVI_PRECHK=>TT_PRECHK_ERROR .
ENDCLASS.



CLASS CL_CVI_PRECHK IMPLEMENTATION.


  METHOD delete_log_data.
    DATA: lv_cvnum TYPE cvi_prechk_cvnum.

    CLEAR ex_subrc.
    "Selecting to check a case-> Header having an entry but details table has no entry. Eg., In-complete error run.
    SELECT SINGLE cv_num INTO lv_cvnum FROM cvi_prechk_det WHERE runid = im_runid ##WARN_OK. "Selecting single to check the existence of records only
    IF sy-subrc = 0.
      DELETE FROM cvi_prechk_det WHERE runid = im_runid.
      IF sy-subrc <> 0.
        ex_subrc = sy-subrc.
        RETURN.
      ENDIF.
    ENDIF.

    DELETE FROM CVI_PRECHK WHERE runid = im_runid.
    ex_subrc = sy-subrc.
  ENDMETHOD.


  METHOD execute_address_check.
    DATA : ls_error        TYPE cvi_prechk_det,
           ls_t005         TYPE t005,
           ls_adrc_struc   TYPE adrc_struc,
           ls_tsad3        TYPE tsad3,
           lt_errmess      TYPE TABLE OF addr_error,
           ls_errmess      TYPE addr_error.

    CONSTANTS lc_max_length TYPE i VALUE 40.
    CONSTANTS lc_max_length_Street TYPE i VALUE 60.

    ls_error-cv_num = iv_objectid.
    ls_error-runid = gv_runid.
*    ls_error-mandt = sy-mandt.
    ls_error-scen_fieldcheck = '06'.

    READ TABLE gt_t005 INTO ls_t005 WITH KEY land1 = is_address-country.
    IF sy-subrc = 0.
      MOVE-CORRESPONDING is_address TO ls_adrc_struc.
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
        ls_error-fieldname = ls_errmess-fieldname.
        ls_error-msg_id = ls_errmess-msg_id.
        ls_error-msg_number = ls_errmess-msg_number.
        ls_error-value = is_address-nation.
        MESSAGE ID ls_errmess-msg_id TYPE ls_errmess-msg_type NUMBER ls_errmess-msg_number WITH ls_errmess-msg_var1 ls_errmess-msg_var2 ls_errmess-msg_var3
                                          ls_errmess-msg_var4 INTO ls_error-message.
        INSERT ls_error INTO TABLE ct_error.
      ENDLOOP.

      "The changes done in ADDR_REGIONAL_DATA_CHECK is not required for further processing.
*      MOVE-CORRESPONDING ls_adrc_struc TO is_address.

      IF is_address-title IS NOT INITIAL. " for Person "Mr./Mrs. and for Organisation Others set of title.
        READ TABLE gt_tsad3 INTO ls_tsad3 WITH TABLE KEY title = is_address-title.
        IF sy-subrc = 0 AND ls_tsad3-person = 'X' AND ls_tsad3-xgroup = 'X' AND ls_tsad3-organizatn = ''.
          IF 1 = 2.
            MESSAGE e019(cvi_prechk) WITH is_address-title.
          ENDIF.
          MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 019 WITH is_address-title INTO ls_error-message.
          ls_error-msg_id = sy-msgid.
          ls_error-msg_number = sy-msgno.
          ls_error-fieldname = 'ADRC-TITLE'.
          ls_error-value = is_address-title.
          INSERT ls_error INTO TABLE ct_error.
        ENDIF.
      ENDIF.

      clear ls_error-fieldname.
      " The below fields, length of more than lc_max_length characters are not allowed.
      ls_error-msg_id = 'AM'.
      ls_error-msg_number = '228'.
      IF strlen( is_address-name1 ) > lc_max_length.
        ls_error-fieldname = 'ADRC-NAME1'.
        ls_error-value = is_address-name1.
        IF 1 = 2.
          MESSAGE e018(cvi_prechk) WITH ls_error-fieldname.
        ENDIF.
        MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 018 WITH ls_error-fieldname INTO ls_error-message.
        INSERT ls_error INTO TABLE ct_error.
      ENDIF.
      IF strlen( is_address-name2 ) > lc_max_length.
        ls_error-fieldname = 'ADRC-NAME2'.
        ls_error-value = is_address-name2.
        IF 1 = 2.
          MESSAGE e018(cvi_prechk) WITH ls_error-fieldname.
        ENDIF.
        MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 018 WITH ls_error-fieldname INTO ls_error-message.
        INSERT ls_error INTO TABLE ct_error.
      ENDIF.
      IF strlen( is_address-name3 ) > lc_max_length.
        ls_error-fieldname = 'ADRC-NAME3'.
        ls_error-value =  is_address-name2.
        IF 1 = 2.
          MESSAGE e018(cvi_prechk) WITH ls_error-fieldname.
        ENDIF.
        MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 018 WITH ls_error-fieldname INTO ls_error-message.
        INSERT ls_error INTO TABLE ct_error.
      ENDIF.
      IF strlen( is_address-name4 ) > lc_max_length.
        ls_error-fieldname = 'ADRC-NAME4'.
        ls_error-value = is_address-name4.
        IF 1 = 2.
          MESSAGE e018(cvi_prechk) WITH ls_error-fieldname.
        ENDIF.
        MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 018 WITH ls_error-fieldname INTO ls_error-message.
        INSERT ls_error INTO TABLE ct_error.
      ENDIF.
      IF strlen( is_address-street ) > lc_max_length_Street.
        ls_error-fieldname = 'ADRC-STREET'.
        ls_error-value = is_address-street.
        IF 1 = 2.
          MESSAGE e018(cvi_prechk) WITH ls_error-fieldname.
        ENDIF.
        MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 018 WITH ls_error-fieldname INTO ls_error-message.
        INSERT ls_error INTO TABLE ct_error.
      ENDIF.
      IF strlen( is_address-city1 ) > lc_max_length.
        ls_error-fieldname = 'ADRC-CITY1'.
        ls_error-value = is_address-city1.
        IF 1 = 2.
          MESSAGE e018(cvi_prechk) WITH ls_error-fieldname.
        ENDIF.
        MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 018 WITH ls_error-fieldname INTO ls_error-message.
        INSERT ls_error INTO TABLE ct_error.
      ENDIF.
      IF strlen( is_address-city2 ) > lc_max_length.
        ls_error-fieldname = 'ADRC-CITY2'.
        ls_error-value = is_address-city2.
        IF 1 = 2.
          MESSAGE e018(cvi_prechk) WITH ls_error-fieldname.
        ENDIF.
        MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 018 WITH ls_error-fieldname INTO ls_error-message.
        INSERT ls_error INTO TABLE ct_error.
      ENDIF.
      IF strlen( is_address-str_suppl1 ) > lc_max_length.
        ls_error-fieldname = 'STR_SUPPL1'.
        ls_error-value = is_address-str_suppl1.
        IF 1 = 2.
          MESSAGE e018(cvi_prechk) WITH ls_error-fieldname.
        ENDIF.
        MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 018 WITH ls_error-fieldname INTO ls_error-message.
        INSERT ls_error INTO TABLE ct_error.
      ENDIF.
      IF strlen( is_address-str_suppl2 ) > lc_max_length.
        ls_error-fieldname = 'STR_SUPPL2'.
        ls_error-value = is_address-str_suppl2.
        IF 1 = 2.
          MESSAGE e018(cvi_prechk) WITH ls_error-fieldname.
        ENDIF.
        MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 018 WITH ls_error-fieldname INTO ls_error-message.
        INSERT ls_error INTO TABLE ct_error.
      ENDIF.
      IF strlen( is_address-str_suppl3 ) > lc_max_length.
        ls_error-fieldname = 'STR_SUPPL3'.
        ls_error-value = is_address-str_suppl3.
        IF 1 = 2.
          MESSAGE e018(cvi_prechk) WITH ls_error-fieldname.
        ENDIF.
        MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 018 WITH ls_error-fieldname INTO ls_error-message.
        INSERT ls_error INTO TABLE ct_error.
      ENDIF.
      IF strlen( is_address-location ) > lc_max_length.
        ls_error-fieldname = 'LOCATION'.
        ls_error-value = is_address-location.
        IF 1 = 2.
          MESSAGE e018(cvi_prechk) WITH ls_error-fieldname.
        ENDIF.
        MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 018 WITH ls_error-fieldname INTO ls_error-message.
        INSERT ls_error INTO TABLE ct_error.
      ENDIF.

    ENDIF.
  ENDMETHOD.


  METHOD execute_bank_check.

    TYPES: BEGIN OF ty_bank_detail,
             bank_country     TYPE lfbk-banks,
             bank_number      TYPE lfbk-bankl,
             bank_account     TYPE lfbk-bankn,
             bank_control_key TYPE lfbk-bkont,
           END OF ty_bank_detail.
    DATA:ls_knbk        TYPE knbk,
         ls_bnka             TYPE bnka,
         ls_lfbk             TYPE lfbk,
         ls_error            TYPE cvi_prechk_det,
         lv_tabname     TYPE tabname,
         lv_fieldname   TYPE fieldname,
         lv_bank        TYPE tiban-banks,
         ls_bank_detail TYPE ty_bank_detail.

    CLEAR : ls_bank_detail, lv_tabname, ls_error, lv_fieldname.
    "Fill the data based on customer/vendor.
    IF iv_objtype = if_cvi_prechk=>gc_objtype_cust.
      READ TABLE gt_knbk INTO ls_knbk WITH KEY kunnr = iv_objectid.
      IF sy-subrc = 0.
        ls_bank_detail-bank_country = ls_knbk-banks.
        ls_bank_detail-bank_number = ls_knbk-bankl.
        ls_bank_detail-bank_account = ls_knbk-bankn.
        ls_bank_detail-bank_control_key = ls_knbk-bkont.
        lv_tabname = 'KNBK'.
      ENDIF.
    ELSEIF iv_objtype = if_cvi_prechk=>gc_objtype_vend.
      READ TABLE gt_lfbk INTO ls_lfbk WITH KEY lifnr = iv_objectid.
      IF sy-subrc = 0.
        ls_bank_detail-bank_country = ls_lfbk-banks.
        ls_bank_detail-bank_number = ls_lfbk-bankl.
        ls_bank_detail-bank_account = ls_lfbk-bankn.
        ls_bank_detail-bank_control_key = ls_lfbk-bkont.
        lv_tabname = 'LFBK'.
      ENDIF.
    ENDIF.

    ls_error-cv_num = iv_objectid.
    ls_error-runid = gv_runid.
    ls_error-scen_fieldcheck = '07'.
*    ls_error-mandt = sy-mandt.

    IF ls_lfbk IS NOT INITIAL OR ls_knbk IS NOT INITIAL.
      "For Customer two checks.
      IF iv_objtype = if_cvi_prechk=>gc_objtype_cust.
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
          IF 1 = 2.
            MESSAGE e016(cvi_prechk) WITH ls_bank_detail-bank_country ls_bank_detail-bank_country.
          ENDIF.
          MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 016 WITH ls_bank_detail-bank_country ls_bank_detail-bank_country INTO ls_error-message.
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
            IF 1 = 2.
              MESSAGE e011(cvi_prechk) WITH ls_bank_detail-bank_number ls_bank_detail-bank_account ls_bank_detail-bank_country.
            ENDIF.
            MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 011 WITH ls_bank_detail-bank_number ls_bank_detail-bank_account ls_bank_detail-bank_country INTO ls_error-message.
          CONCATENATE lv_tabname '-BANKN' INTO lv_fieldname.
          ls_error-fieldname = lv_fieldname.
            ls_error-value = ls_bank_detail-bank_account.
          INSERT ls_error INTO TABLE ct_error.
        ENDIF.
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
        IF sy-msgv2 IS NOT INITIAL.
          IF 1 = 2.
            MESSAGE e012(cvi_prechk) WITH ls_bank_detail-bank_number sy-msgv2.
          ENDIF.
          MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 012 WITH ls_bank_detail-bank_number sy-msgv2 INTO ls_error-message.
        ELSE.
          IF 1 = 2.
            MESSAGE e011(cvi_prechk) WITH ls_bank_detail-bank_number ls_bank_detail-bank_account ls_bank_detail-bank_country.
          ENDIF.
          MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 011 WITH ls_bank_detail-bank_number ls_bank_detail-bank_account ls_bank_detail-bank_country INTO ls_error-message.
        ENDIF.
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
          IF 1 = 2.
            MESSAGE e013(cvi_prechk) WITH ls_bank_detail-bank_country.
          ENDIF.
          MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 013 WITH ls_bank_detail-bank_country INTO ls_error-message.
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
          IF sy-msgv2 IS NOT INITIAL AND sy-msgv3 <> ls_bank_detail-bank_number.
            IF 1 = 2.
              MESSAGE e012(cvi_prechk) WITH ls_bank_detail-bank_number sy-msgv2.
            ENDIF.
            MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 012 WITH ls_bank_detail-bank_number sy-msgv2 INTO ls_error-message.
          ELSE.
            IF 1 = 2.
              MESSAGE e011(cvi_prechk) WITH ls_bank_detail-bank_number ls_bank_detail-bank_account ls_bank_detail-bank_country.
            ENDIF.
            MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 011 WITH ls_bank_detail-bank_number ls_bank_detail-bank_account ls_bank_detail-bank_country INTO ls_error-message.
          ENDIF.
              CONCATENATE lv_tabname '-BANKN' INTO lv_fieldname.
              ls_error-fieldname = lv_fieldname.
          ls_error-value = ls_bank_detail-bank_number.
              INSERT ls_error INTO TABLE ct_error.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD execute_email_check.
    DATA: lt_smtp_addr   TYPE TABLE OF adr6-smtp_addr,
          lv_smtp_addr   TYPE adr6-smtp_addr,
          lv_addr_length TYPE i,
          lv_char        TYPE c,
          ls_error       TYPE cvi_prechk_det,
          ls_unstruct    TYPE sx_address.

    IF is_address IS NOT INITIAL.
      CLEAR: ls_error, lt_smtp_addr.
      ls_error-cv_num = iv_objectid.
      ls_error-runid = gv_runid.
      ls_error-scen_fieldcheck = '02'.
      ls_error-fieldname = 'ADR6-SMTP_ADDR'.

      SELECT smtp_addr FROM adr6 INTO TABLE lt_smtp_addr WHERE addrnumber = is_address-addrnumber. " get the email address from adr6.
      LOOP AT lt_smtp_addr INTO lv_smtp_addr.
        lv_addr_length = strlen( lv_smtp_addr ) - 1.
        lv_char = lv_smtp_addr+lv_addr_length.
        IF lv_char = ';'.
          IF 1 = 2.
            MESSAGE e030(cvi_prechk) WITH lv_smtp_addr.
          ENDIF.
          MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 030 WITH lv_smtp_addr INTO ls_error-message.
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
            IF 1 = 2.
              MESSAGE e030(cvi_prechk) WITH lv_smtp_addr.
            ENDIF.
            MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 030 WITH lv_smtp_addr INTO ls_error-message.
            ls_error-value = lv_smtp_addr.
            INSERT ls_error INTO TABLE ct_error.
          ENDIF.
        ENDIF.
      ENDLOOP.

    ENDIF.
  ENDMETHOD.


  METHOD execute_industry_check.

    DATA:lv_brsch TYPE tp038m2-brsch,
         ls_error   TYPE cvi_prechk_det.

*   Perform the execution of checks for Industry regions
    IF iv_industry_sector IS NOT INITIAL AND gv_istype IS NOT INITIAL.
      SELECT SINGLE brsch FROM tp038m2
                          INTO lv_brsch
                           WHERE brsch  = iv_industry_sector
                             AND istype = gv_istype.
        IF sy-subrc <> 0.
          CLEAR ls_error.
          ls_error-cv_num = iv_objectid.
        IF 1 = 2.
          MESSAGE e031(cvi_prechk) WITH iv_industry_sector.
        ENDIF.
        MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 031 WITH iv_industry_sector INTO ls_error-message.
        ls_error-msg_id = if_cvi_prechk=>gc_message_class.
        ls_error-msg_number = '031'.
          ls_error-runid = gv_runid.
          ls_error-scen_fieldcheck = '08'.
          ls_error-fieldname = 'INDUSTRY'.
          ls_error-value = iv_industry_sector.
          APPEND ls_error TO ct_error.
      ENDIF.
    ENDIF.


  ENDMETHOD.


  METHOD execute_number_range_check.
    DATA: lv_numkr TYPE numkr,
          ls_nriv    TYPE nriv,
          ls_error TYPE cvi_prechk_det,
          ls_t077d TYPE t077d,
          ls_t077k TYPE t077k.

    CLEAR lv_numkr.
    IF iv_objtype EQ if_cvi_prechk=>gc_objtype_cust.
      READ TABLE gt_t077d INTO ls_t077d WITH KEY ktokd = iv_account_group TRANSPORTING numkr.
      IF sy-subrc EQ 0.
        lv_numkr = ls_t077d-numkr.
      ENDIF.
    ELSEIF iv_objtype EQ if_cvi_prechk=>gc_objtype_vend.
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
*          ls_error-mandt = sy-mandt.
          ls_error-msg_id = 'R1'.
          ls_error-msg_number = '099'.
          ls_error-runid = gv_runid.
          ls_error-scen_fieldcheck = '09'.
        IF iv_objtype  = if_cvi_prechk=>gc_objtype_cust.
          IF 1 = 2.
            MESSAGE e024(cvi_prechk) WITH iv_objectid ls_nriv-fromnumber ls_nriv-tonumber.
          ENDIF.
          MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 024 WITH iv_objectid ls_nriv-fromnumber ls_nriv-tonumber INTO ls_error-message.
        ELSEIF iv_objtype = if_cvi_prechk=>gc_objtype_vend.
          IF 1 = 2.
            MESSAGE e025(cvi_prechk) WITH iv_objectid ls_nriv-fromnumber ls_nriv-tonumber.
          ENDIF.
          MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 025 WITH iv_objectid ls_nriv-fromnumber ls_nriv-tonumber INTO ls_error-message.
        ENDIF.
        INSERT ls_error INTO TABLE ct_error.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD execute_postcode_check.
    DATA : ls_error          TYPE cvi_prechk_det,
           ls_postal_address TYPE adrs_post.


    IF is_address-addrnumber IS NOT INITIAL.
      CLEAR ls_postal_address.
      MOVE-CORRESPONDING is_address TO ls_postal_address.

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
        ls_error-runid = gv_runid.
*        ls_error-mandt = sy-mandt.
        ls_error-msg_id = sy-msgid.
        ls_error-msg_number = sy-msgno.
        ls_error-scen_fieldcheck = '04'.
        CASE sy-subrc.
          WHEN 01.
            ls_error-fieldname = 'ADRC-COUNTRY'.
            IF 1 = 2.
              MESSAGE e014(cvi_prechk) WITH ls_postal_address-country ls_postal_address-country.
            ENDIF.
            MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 014 WITH ls_postal_address-country ls_postal_address-country INTO ls_error-message.
            ls_error-value = ls_postal_address-country.
          WHEN 02.
            ls_error-fieldname = 'REGION'.
            IF 1 = 2.
              MESSAGE e014(cvi_prechk) WITH ls_postal_address-region ls_postal_address-country.
            ENDIF.
            MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 014 WITH ls_postal_address-region ls_postal_address-country INTO ls_error-message.
            ls_error-value = ls_postal_address-region.
          WHEN 03.
            ls_error-fieldname = 'ADRC-POST_CODE1'.
            IF 1 = 2.
              MESSAGE e014(cvi_prechk) WITH ls_postal_address-post_code1 ls_postal_address-country.
            ENDIF.
            MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 014 WITH ls_postal_address-post_code1 ls_postal_address-country INTO ls_error-message.
            ls_error-value = ls_postal_address-post_code1.
          WHEN 04.
            ls_error-fieldname = 'ADRC-POST_CODE2'.
            IF 1 = 2.
              MESSAGE e014(cvi_prechk) WITH ls_postal_address-post_code2 ls_postal_address-country.
            ENDIF.
            MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 014 WITH ls_postal_address-post_code2 ls_postal_address-country INTO ls_error-message.
            ls_error-value = ls_postal_address-post_code2.
          WHEN 05.
            ls_error-fieldname = 'ADRC-POST_CODE3'.
            IF 1 = 2.
              MESSAGE e014(cvi_prechk) WITH ls_postal_address-post_code3 ls_postal_address-country.
            ENDIF.
            MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 014 WITH ls_postal_address-post_code3 ls_postal_address-country INTO ls_error-message.
            ls_error-value = ls_postal_address-post_code3.
          WHEN 06.
            ls_error-fieldname = 'ADRC-PO_BOX'.
            IF 1 = 2.
              MESSAGE e015(cvi_prechk) WITH 'PO_BOX' ls_postal_address-country.
            ENDIF.
            MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 015 WITH 'PO_BOX' ls_postal_address-country INTO ls_error-message.
            ls_error-value = ls_postal_address-po_box.
          WHEN 07.
            ls_error-fieldname = 'ADRC-POST_CODE2'.
            IF 1 = 2.
              MESSAGE e015(cvi_prechk) WITH 'POSTL_COD2' ls_postal_address-country.
            ENDIF.
            MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 015 WITH 'POST_CODE2' ls_postal_address-country INTO ls_error-message.
            ls_error-value = ls_postal_address-post_code2.
          WHEN 08.
            ls_error-fieldname = 'ADRC-POST_CODE1'.
            IF 1 = 2.
              MESSAGE e015(cvi_prechk) WITH 'POSTL_COD1' ls_postal_address-country.
            ENDIF.
            MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 015 WITH 'POST_CODE1' ls_postal_address-country INTO ls_error-message.
            ls_error-value = ls_postal_address-post_code1.
          WHEN 09.
            ls_error-fieldname = 'ADRC-PO_BOX_CTY'.
            IF 1 = 2.
              MESSAGE e015(cvi_prechk) WITH 'ADRC-PO_BOX_CTY' ls_postal_address-country.
            ENDIF.
            MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 015 WITH 'PO_BOX_CTY' ls_postal_address-country INTO ls_error-message.
            ls_error-value = ls_postal_address-po_box_cty.
          WHEN 10.
            ls_error-fieldname = 'ADRC-PO_BOX_REG'.
            IF 1 = 2.
              MESSAGE e014(cvi_prechk) WITH ls_postal_address-po_box_reg ls_postal_address-country.
            ENDIF.
            MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 014 WITH ls_postal_address-po_box_reg ls_postal_address-country INTO ls_error-message.
            ls_error-value = ls_postal_address-po_box_reg.
          WHEN 11.
            ls_error-fieldname = 'ADRC-POBOX_CTY'.
            IF 1 = 2.
              MESSAGE e014(cvi_prechk) WITH ls_postal_address-po_box_cty ls_postal_address-country.
            ENDIF.
            MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 014 WITH ls_postal_address-po_box_cty ls_postal_address-country INTO ls_error-message.
            ls_error-value = ls_postal_address-po_box_cty.
          WHEN 12.
            ls_error-fieldname = 'ADRC-PO_W_O_NO'.
            IF 1 = 2.
              MESSAGE e017(cvi_prechk) WITH 'PO_W_O_NO'.
            ENDIF.
            MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 017 WITH 'PO_W_O_NO' INTO ls_error-message.
            ls_error-value = ls_postal_address-po_box_lobby.
          WHEN OTHERS.
        ENDCASE.

        INSERT ls_error INTO TABLE ct_error.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD execute_tax_jur_check.
    DATA: ls_error     TYPE cvi_prechk_det.

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
        IF iv_objtype EQ if_cvi_prechk=>gc_objtype_cust.
            ls_error-fieldname = 'KNA1-TXJCD'.
          ELSE.
            ls_error-fieldname = 'LFA1-TXJCD'.
          ENDIF.
        IF sy-subrc = 3.
          IF 1 = 2.
            MESSAGE e027(cvi_prechk) WITH iv_txjcd.
          ENDIF.
          MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 027 WITH iv_txjcd INTO ls_error-message.
        ELSE.
          IF 1 = 2.
            MESSAGE e026(cvi_prechk) WITH iv_txjcd is_address-country.
          ENDIF.
          MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 026 WITH iv_txjcd is_address-country INTO ls_error-message.
        ENDIF.
        ls_error-cv_num = iv_objectid.
*          ls_error-mandt = sy-mandt.
          ls_error-runid = gv_runid.
          ls_error-scen_fieldcheck = '05'.
          ls_error-value = iv_txjcd.
          INSERT ls_error INTO TABLE ct_error.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD execute_tax_type_check.

    DATA:ls_error       TYPE cvi_prechk_det,
         lv_table       TYPE tabname,
         lv_tax_chk TYPE tfktaxnumtype-taxtype,
         ls_knas        TYPE knas,
         ls_lfas        TYPE lfas.

    CONSTANTS: lc_msg_class_old TYPE string VALUE 'FKBPTAX', "Additional msg class for tax type from RIG report
               lc_msg_no_old    TYPE string VALUE '033'. "Additional msg class for tax type from RIG report


*   Execute Checks all Tax type categories
    CLEAR: ls_error.
    ls_error-cv_num = is_selection_param-cvnum.
      ls_error-runid = gv_runid.
      ls_error-scen_fieldcheck = '01'.
    IF iv_objtype = if_cvi_prechk=>gc_objtype_cust.
        lv_table = 'KNA1'.
    ELSEIF iv_objtype = if_cvi_prechk=>gc_objtype_vend.
        lv_table = 'LFA1'.
      ENDIF.
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
        IF 1 = 2.
          MESSAGE e009(cvi_prechk) WITH is_selection_param-stceg is_selection_param-land1.
        ENDIF.
        MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 009 WITH is_selection_param-stceg is_selection_param-land1 INTO ls_error-message.
        INSERT ls_error INTO TABLE ct_error.
      ENDIF.

      IF iv_objtype = if_cvi_prechk=>gc_objtype_cust.
        READ TABLE gt_knas INTO ls_knas WITH KEY kunnr = is_selection_param-cvnum.
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
            IF 1 = 2.
              MESSAGE e009(cvi_prechk) WITH ls_knas-stceg ls_knas-land1 .
            ENDIF.
            MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 009 WITH ls_knas-stceg ls_knas-land1 INTO ls_error-message.
            INSERT ls_error INTO TABLE ct_error.
          ENDIF.
        ENDIF.
      ELSEIF iv_objtype = if_cvi_prechk=>gc_objtype_vend.
        READ TABLE gt_lfas INTO ls_lfas WITH KEY lifnr = is_selection_param-cvnum.
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
            IF 1 = 2.
              MESSAGE e009(cvi_prechk) WITH ls_lfas-stceg ls_lfas-land1.
            ENDIF.
            MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 009 WITH ls_lfas-stceg ls_lfas-land1 INTO ls_error-message.
          INSERT ls_error INTO TABLE ct_error.
        ENDIF.
      ENDIF.
      ENDIF.


* tax type check table TFKTAXNUMTYPE
      IF is_selection_param-stcdt IS INITIAL.
        CONCATENATE is_selection_param-land1 '0' INTO lv_tax_chk.
        READ TABLE gt_tfktaxnumtype WITH TABLE KEY taxtype = lv_tax_chk TRANSPORTING NO FIELDS.
        IF sy-subrc <> 0.
          ls_error-msg_id = lc_msg_class_old .
          ls_error-msg_number = lc_msg_no_old.
          CONCATENATE lv_table '-LAND1' INTO ls_error-fieldname.
          ls_error-value = lv_tax_chk.
          IF 1 = 2.
            MESSAGE e010(cvi_prechk) WITH lv_tax_chk is_selection_param-land1.
          ENDIF.
          MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 010 WITH lv_tax_chk is_selection_param-land1 INTO ls_error-message.
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
        IF 1 = 2.
          MESSAGE e032(cvi_prechk) WITH  '1' is_selection_param-stcd1 is_selection_param-land1.
        ENDIF.
        MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 032 WITH  '1' is_selection_param-stcd1 is_selection_param-land1 INTO ls_error-message.
        INSERT ls_error INTO TABLE ct_error.
      ENDIF.
* tax type check table TFKTAXNUMTYPE

      IF is_selection_param-stcdt IS INITIAL.
        CONCATENATE is_selection_param-land1 '1' INTO lv_tax_chk.
        READ TABLE gt_tfktaxnumtype WITH TABLE KEY taxtype = lv_tax_chk TRANSPORTING NO FIELDS.
        IF sy-subrc <> 0.
          ls_error-msg_id = lc_msg_class_old.
          ls_error-msg_number = lc_msg_no_old.
          CONCATENATE lv_table '-LAND1' INTO ls_error-fieldname.
          ls_error-value = lv_tax_chk.
          IF 1 = 2.
            MESSAGE e010(cvi_prechk) WITH lv_tax_chk is_selection_param-land1.
          ENDIF.
          MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 010 WITH lv_tax_chk is_selection_param-land1 INTO ls_error-message.
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
        IF 1 = 2.
          MESSAGE e032(cvi_prechk) WITH  '2' is_selection_param-stcd2 is_selection_param-land1.
        ENDIF.
        MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 032 WITH  '2' is_selection_param-stcd2 is_selection_param-land1 INTO ls_error-message.
        INSERT ls_error INTO TABLE ct_error.
      ENDIF.
*
** tax type check table TFKTAXNUMTYPE

      IF is_selection_param-stcdt IS INITIAL.
        CONCATENATE is_selection_param-land1 '2' INTO lv_tax_chk.
        READ TABLE gt_tfktaxnumtype WITH TABLE KEY taxtype = lv_tax_chk TRANSPORTING NO FIELDS.
        IF sy-subrc <> 0.
          ls_error-msg_id = lc_msg_class_old.
          ls_error-msg_number = lc_msg_no_old.
          CONCATENATE lv_table '-LAND1' INTO ls_error-fieldname.
          ls_error-value = lv_tax_chk.
          IF 1 = 2.
            MESSAGE e010(cvi_prechk) WITH lv_tax_chk is_selection_param-land1.
          ENDIF.
          MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 010 WITH lv_tax_chk is_selection_param-land1 INTO ls_error-message.
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
        IF 1 = 2.
          MESSAGE e032(cvi_prechk) WITH '3' is_selection_param-stcd3 is_selection_param-land1.
        ENDIF.
        MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 032 WITH '3' is_selection_param-stcd3 is_selection_param-land1 INTO ls_error-message.
        INSERT ls_error INTO TABLE ct_error.
      ENDIF.
* tax type check table TFKTAXNUMTYPE

      IF is_selection_param-stcdt IS INITIAL.
        CONCATENATE is_selection_param-land1 '3' INTO lv_tax_chk.
        READ TABLE gt_tfktaxnumtype WITH TABLE KEY taxtype = lv_tax_chk TRANSPORTING NO FIELDS.
        IF sy-subrc <> 0.
          ls_error-msg_id = lc_msg_class_old.
          ls_error-msg_number = lc_msg_no_old.
          CONCATENATE lv_table '-LAND1' INTO ls_error-fieldname.
          ls_error-value = lv_tax_chk.
          IF 1 = 2.
            MESSAGE e010(cvi_prechk) WITH lv_tax_chk is_selection_param-land1 .
          ENDIF.
          MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 010 WITH lv_tax_chk is_selection_param-land1 INTO ls_error-message.
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
        IF 1 = 2.
          MESSAGE e032(cvi_prechk) WITH  '4' is_selection_param-stcd4 is_selection_param-land1.
        ENDIF.
        MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 032 WITH  '4' is_selection_param-stcd4 is_selection_param-land1 INTO ls_error-message.
        INSERT ls_error INTO TABLE ct_error.
      ENDIF.

* tax type check table TFKTAXNUMTYPE
      IF is_selection_param-stcdt IS INITIAL.
        CONCATENATE is_selection_param-land1 '4' INTO lv_tax_chk.
        READ TABLE gt_tfktaxnumtype WITH TABLE KEY taxtype = lv_tax_chk TRANSPORTING NO FIELDS.
        IF sy-subrc <> 0.
          ls_error-msg_id = lc_msg_class_old.
          ls_error-msg_number = lc_msg_no_old.
          CONCATENATE lv_table '-LAND1' INTO ls_error-fieldname.
          ls_error-value = lv_tax_chk.
          IF 1 = 2.
            MESSAGE e010(cvi_prechk) WITH lv_tax_chk is_selection_param-land1 .
          ENDIF.
          MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 010 WITH lv_tax_chk is_selection_param-land1 INTO ls_error-message.
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
        IF 1 = 2.
          MESSAGE e032(cvi_prechk) WITH  '5' is_selection_param-stcd5 is_selection_param-land1.
        ENDIF.
        MESSAGE ID if_cvi_prechk=>gc_message_class TYPE sy-msgty NUMBER 032 WITH  '5' is_selection_param-stcd5 is_selection_param-land1 INTO ls_error-message.
        INSERT ls_error INTO TABLE ct_error.
      ENDIF.

* tax type check table TFKTAXNUMTYPE
      IF is_selection_param-stcdt IS INITIAL.
        CONCATENATE is_selection_param-land1 '5' INTO lv_tax_chk.
        READ TABLE gt_tfktaxnumtype WITH TABLE KEY taxtype = lv_tax_chk TRANSPORTING NO FIELDS.
        IF sy-subrc <> 0.
          ls_error-msg_id = lc_msg_class_old.
          ls_error-msg_number = lc_msg_no_old.
          CONCATENATE lv_table '-LAND1' INTO ls_error-fieldname.
          ls_error-value = lv_tax_chk.
          IF 1 = 2.
            MESSAGE e010(cvi_prechk) WITH lv_tax_chk is_selection_param-land1.
          ENDIF.
          MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 010 WITH lv_tax_chk is_selection_param-land1 INTO ls_error-message.
          INSERT ls_error INTO TABLE ct_error.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD execute_transzone_check.

    DATA: lv_fausa TYPE fausa_077d,
          ls_error TYPE cvi_prechk_det,
          ls_t077d TYPE t077d,
          ls_t077k TYPE t077k.

    IF is_address-transpzone IS INITIAL.
      CLEAR lv_fausa.
      IF iv_objtype EQ if_cvi_prechk=>gc_objtype_cust.
        READ TABLE gt_t077d INTO ls_t077d WITH KEY ktokd = is_master_data-acc_group TRANSPORTING fausa.
        IF sy-subrc EQ 0.
          lv_fausa = ls_t077d-fausa.
        ENDIF.
      ELSEIF iv_objtype EQ if_cvi_prechk=>gc_objtype_vend.
        READ TABLE gt_t077k INTO ls_t077k WITH KEY ktokk = is_master_data-acc_group TRANSPORTING fausa.
        IF sy-subrc EQ 0.
          lv_fausa = ls_t077k-fausa.
        ENDIF.
      ENDIF.

      IF lv_fausa IS NOT INITIAL AND ls_t077d-fausa+24(1) = '+'. "Transportzone is mandatory
        CLEAR ls_error.
        ls_error-cv_num = iv_objectid.
        IF 1 = 2.
          MESSAGE e028(cvi_prechk).
        ENDIF.
        MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 028 INTO ls_error-message.
        ls_error-msg_id = '00'.
        ls_error-msg_number = '055'.
        ls_error-runid = gv_runid.
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
        IF 1 = 2.
          MESSAGE e029(cvi_prechk) WITH is_address-transpzone  is_master_data-land1 .
        ENDIF.
        MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 029 WITH is_address-transpzone  is_master_data-land1 INTO ls_error-message.
        ls_error-msg_id = 'AM'.
        ls_error-msg_number = '129'.
        ls_error-runid = gv_runid.
        ls_error-scen_fieldcheck = '03'.
        ls_error-fieldname = 'ADRC-TRANSPZONE'.
        ls_error-value = is_address-transpzone.
        APPEND ls_error TO ct_error.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD generate_runid.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      NR_RANGE_NR                   = '01'
      OBJECT                        = 'CVI_PRECHK'
   IMPORTING
     NUMBER                        = ex_runid
   EXCEPTIONS
     INTERVAL_NOT_FOUND            = 1
     NUMBER_RANGE_NOT_INTERN       = 2
     OBJECT_NOT_FOUND              = 3
     QUANTITY_IS_0                 = 4
     QUANTITY_IS_NOT_1             = 5
     INTERVAL_OVERFLOW             = 6
     BUFFER_OVERFLOW               = 7
      OTHERS                  = 8.
  IF sy-subrc <> 0.
    CASE sy-subrc.
      WHEN 1.
          IF 1 = 2.
            MESSAGE e040(cvi_prechk) WITH '01' 'CVI_PRECHK'.
          ENDIF.
          MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 040 WITH '01' 'CVI_PRECHK' RAISING no_interval_maintained.
        WHEN OTHERS.
          IF 1 = 2.
            MESSAGE e041(cvi_prechk).
          ENDIF.
          MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 041 RAISING number_generation_error.
    ENDCASE.
  ENDIF.
  ENDMETHOD.


  METHOD get_address.

    "To be filled only for records of corresponding task in parallel processing.
    CLEAR: gt_address, gt_tsad3.
    CHECK is_selection_param-chk_data IS NOT INITIAL.
    SELECT  addrnumber,
            post_code1,
            post_code2,
            post_code3,
            po_box,
            po_box_reg,
            po_box_cty,
            po_box_num,
            po_box_loc,
            deli_serv_type,
            transpzone,
            title,
            name1,
            name2,
            name3,
            name4,
            street,
            city1,
            city2,
            str_suppl1,
            str_suppl2,
            str_suppl3,
            location,
            country,
            region,
            taxjurcode
              FROM adrc INTO CORRESPONDING FIELDS OF TABLE @gt_address
              FOR ALL ENTRIES IN @is_selection_param-chk_data WHERE addrnumber = @is_selection_param-chk_data-adrnr.


    IF is_selection_param-scen-addr_ind EQ abap_true AND gt_address IS NOT INITIAL.
      SELECT * FROM tsad3 INTO TABLE @gt_tsad3 FOR ALL ENTRIES IN @gt_address WHERE title = @gt_address-title .
    ENDIF.

  ENDMETHOD.


  METHOD get_bank_data.

    "To be filled only for records of corresponding task in parallel processing.
    CLEAR: gt_knbk, gt_knas, gt_lfbk, gt_lfas.
    IF iv_objtype = if_cvi_prechk=>gc_objtype_cust.
      IF is_selection_param-scen-bank_ind IS NOT INITIAL.
        SELECT kunnr, banks, bankn, bkont, bankl FROM knbk INTO CORRESPONDING FIELDS OF TABLE @gt_knbk
          FOR ALL ENTRIES IN @is_selection_param-chk_data
           WHERE kunnr = @is_selection_param-chk_data-cvnum.
      ENDIF.
      IF is_selection_param-scen-taxcode_ind IS NOT INITIAL.
      SELECT kunnr, land1, stceg FROM knas INTO CORRESPONDING FIELDS OF TABLE @gt_knas
        FOR ALL ENTRIES IN @is_selection_param-chk_data
         WHERE kunnr = @is_selection_param-chk_data-cvnum.
      ENDIF.
    ELSEIF iv_objtype = if_cvi_prechk=>gc_objtype_vend.
      IF is_selection_param-scen-bank_ind IS NOT INITIAL.
      SELECT lifnr, banks, bankn, bkont, bankl FROM lfbk INTO CORRESPONDING FIELDS OF TABLE @gt_lfbk FOR ALL ENTRIES IN @is_selection_param-chk_data
         WHERE lifnr = @is_selection_param-chk_data-cvnum.
      ENDIF.
      IF is_selection_param-scen-taxcode_ind IS NOT INITIAL.
      SELECT lifnr, land1, stceg FROM lfas INTO CORRESPONDING FIELDS OF TABLE @gt_lfas
        FOR ALL ENTRIES IN @is_selection_param-chk_data
         WHERE lifnr = @is_selection_param-chk_data-cvnum.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_current_run_status.

    IF ch_runid_status IS NOT INITIAL.
      SELECT runid,status FROM cvi_prechk INTO TABLE @ch_runid_status
                          FOR ALL ENTRIES IN @ch_runid_status
                          WHERE runid = @ch_runid_status-runid.
    ENDIF.

  ENDMETHOD.


  METHOD get_data_for_validation.

    DATA lv_object TYPE nrobj.

    CLEAR: gt_t005, gt_t077d, gt_t077k, gt_tzone, gt_nriv, gt_tfktaxnumtype, gv_istype.

    IF is_selection_param-scen-addr_ind EQ abap_true.
      SELECT land1 intca FROM t005 INTO CORRESPONDING FIELDS OF TABLE gt_t005.
    ENDIF.

    IF is_selection_param-scen-numrng_ind EQ abap_true OR is_selection_param-scen-tzone_ind EQ abap_true.
      IF is_selection_param-objtype EQ if_cvi_prechk=>gc_objtype_cust.
*        SELECT ktokd numkr fausa FROM t077d INTO CORRESPONDING FIELDS OF TABLE gt_t077d FOR ALL ENTRIES IN is_selection_param-chk_data WHERE ktokd = is_selection_param-chk_data-acc_group.
        SELECT ktokd numkr fausa FROM t077d INTO CORRESPONDING FIELDS OF TABLE gt_t077d.
      ELSEIF   is_selection_param-objtype EQ if_cvi_prechk=>gc_objtype_vend.
*        SELECT ktokd numkr fausa FROM t077k INTO CORRESPONDING FIELDS OF TABLE gt_t077k FOR ALL ENTRIES IN is_selection_param-chk_data WHERE ktokk = is_selection_param-chk_data-acc_group.
        SELECT ktokk numkr fausa FROM t077k INTO CORRESPONDING FIELDS OF TABLE gt_t077k.
      ENDIF.
    ENDIF.

    IF is_selection_param-scen-tzone_ind EQ abap_true.
      SELECT land1 zone1 FROM tzone INTO CORRESPONDING FIELDS OF TABLE gt_tzone.
    ENDIF.

    IF is_selection_param-scen-numrng_ind EQ abap_true.
      IF is_selection_param-objtype EQ if_cvi_prechk=>gc_objtype_cust.
        lv_object = if_cvi_prechk=>gc_debitor.
      ELSEIF   is_selection_param-objtype EQ if_cvi_prechk=>gc_objtype_vend.
        lv_object = if_cvi_prechk=>gc_kredebitor.
      ENDIF.
      SELECT object nrrangenr fromnumber tonumber FROM nriv
                                                  INTO CORRESPONDING FIELDS OF TABLE gt_nriv
                                                  WHERE object = lv_object.
    ENDIF.

    IF is_selection_param-scen-taxcode_ind EQ abap_true.
      SELECT taxtype FROM tfktaxnumtype INTO CORRESPONDING FIELDS OF TABLE gt_tfktaxnumtype.
    ENDIF.

    "For industry check.
    IF is_selection_param-scen-indus_ind EQ abap_true.
      SELECT SINGLE istype FROM tb038 INTO gv_istype WHERE istdef = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD get_log_data.
    DATA:lt_status TYPE RANGE OF cvi_prechk_status.

    CLEAR ex_data.
    IF im_filter-status IS NOT INITIAL.
      lt_status = VALUE #( ( sign = 'I'
                              option = 'EQ'
                              low = im_filter-status ) ).
    ENDIF.

    IF im_filter IS NOT INITIAL.
        SELECT * FROM CVI_PRECHK INTO TABLE ex_data WHERE run_on IN im_filter-date_rn
          AND status IN lt_status.
    ENDIF.
  ENDMETHOD.


  METHOD get_result_data.

    CLEAR ex_data.
    SELECT cv_num scen_fieldcheck fieldname value message
             FROM cvi_prechk_det INTO TABLE ex_data
                                 WHERE runid = im_runid.

  ENDMETHOD.


  METHOD get_scenarios.

    CHECK im_runid IS NOT INITIAL.

    CLEAR ex_scenario.

    SELECT SINGLE taxcode_ind
                  email_ind
                  tzone_ind
                  addr_ind
                  pcode_ind
                  bank_ind
                  taxjur_ind
                  indus_ind
                  numrng_ind
                  FROM CVI_PRECHK
                  INTO ex_scenario
                  WHERE runid = im_runid.

  ENDMETHOD.


  METHOD insert_error_rec.

    "Check whether the importing parameter is not initial
    CHECK im_error_rec IS NOT INITIAL.

    "Insert all the error records to table cvi_prechk_det
    INSERT cvi_prechk_det FROM TABLE im_error_rec.


  ENDMETHOD.


  METHOD ppf_after_call.
    DATA:ls_task_data    TYPE IF_CVI_PRECHK=>ty_ppf_param.


    "Unpack RFC output
    CLEAR ls_task_data.
    CALL FUNCTION 'SPTA_INDX_PACKAGE_DECODE'
      EXPORTING
        indxtab = it_rfc_data
      IMPORTING
        data    = ls_task_data.

    "To insert the error records to table
    IF ls_task_data-error IS NOT INITIAL.
      insert_error_rec(
        EXPORTING
          im_error_rec = ls_task_data-error ).
    ENDIF.

  ENDMETHOD.


  METHOD ppf_before_call.

    DATA: ls_task_data TYPE IF_CVI_PRECHK=>ty_ppf_param.

    FIELD-SYMBOLS: <ls_ppf_param> TYPE IF_CVI_PRECHK=>ty_ppf_param.

    "Assign the importing data reference CH_PPF_DATA to a local variable
    ASSIGN ch_ppf_data->* TO <ls_ppf_param>.

    CHECK <ls_ppf_param> IS ASSIGNED.

    "From LS_PPF_PARAM take only IF_CVI_PRECHK->PACKAGE_SIZE no of records into another table “ls_task_data”
    "and delete the records from CH_PPF_DATA
    CLEAR ls_task_data.
    ls_task_data-error = <ls_ppf_param>-error.
    ls_task_data-objtype = <ls_ppf_param>-objtype.
    ls_task_data-runid = <ls_ppf_param>-runid.
    ls_task_data-scen = <ls_ppf_param>-scen.

    "Take only package size records (10,000) and delete the same from ppf parameter.
    APPEND LINES OF <ls_ppf_param>-chk_data FROM 1 TO IF_CVI_PRECHK=>package_size TO ls_task_data-chk_data.
    DELETE <ls_ppf_param>-chk_data FROM 1 TO IF_CVI_PRECHK=>package_size.

    "If there is any data, then call the below FM
    IF ls_task_data-chk_data IS NOT INITIAL.
      CALL FUNCTION 'SPTA_INDX_PACKAGE_ENCODE'
        EXPORTING
          data    = ls_task_data
        IMPORTING
          indxtab = ct_rfcdata.
      ex_start_rfc = 'X'.
    ELSE.
      ex_start_rfc = ''.
    ENDIF.
  ENDMETHOD.


  METHOD ppf_in_call.
    DATA: ls_task_data TYPE IF_CVI_PRECHK=>ty_ppf_param,
          lt_error     TYPE IF_CVI_PRECHK=>tt_prechk_error.

    "Decoding the current batch of records
    CLEAR: ls_task_data, lt_error.
    CALL FUNCTION 'SPTA_INDX_PACKAGE_DECODE'
      EXPORTING
        indxtab = ct_rfc_data
      IMPORTING
        data    = ls_task_data.

    "Validate the current batch
    CALL METHOD cl_cvi_prechk=>validate_all_data
      EXPORTING
        is_selection_param = ls_task_data
        iv_objtype         = ls_task_data-objtype
      IMPORTING
        et_error           = lt_error.

    "Appending the error records into task data.
    IF lt_error IS NOT INITIAL.
      ls_task_data-error = lt_error.
    ENDIF.


* Repack output data for AFTER_RFC form
    CALL FUNCTION 'SPTA_INDX_PACKAGE_ENCODE'
      EXPORTING
        data    = ls_task_data
      IMPORTING
        indxtab = ct_rfc_data.


  ENDMETHOD.


  METHOD process_selection_data.

    DATA: lv_runid        TYPE cvi_prechk_runid,
          ls_cvi_prechk TYPE CVI_PRECHK,
          lt_objid_rn type CVI_PRECHK_CVNUM_RTT,
          lt_cv_group type CVI_PRECHK_CVGRP_RTT,
          lv_taskid     TYPE string,
          lv_message    TYPE string.

    "Generate Run id.
    CALL METHOD cl_cvi_prechk=>generate_runid
      IMPORTING
        ex_runid                = lv_runid
      EXCEPTIONS
        no_interval_maintained  = 1                " Interval not maintained for Number Range object
        number_generation_error = 2                " Error while generating Number
        OTHERS                  = 3.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 RAISING runid_id_error.
    ENDIF.

    "Make entry of the run in CVI_PRECHK master table before processing the data.
    CLEAR ls_cvi_prechk.
    MOVE-CORRESPONDING im_scenario TO ls_cvi_prechk. "For scenario indicators
*    ls_cvi_prechk-mandt = sy-mandt.
    ls_cvi_prechk-runid = lv_runid.
    ls_cvi_prechk-run_desc = im_gen_selection-run_description.
    ls_cvi_prechk-objectype = im_gen_selection-objtype.
    ls_cvi_prechk-status = '01'. "In process
    ls_cvi_prechk-run_by = sy-uname.
    ls_cvi_prechk-run_on = sy-datum.
    ls_cvi_prechk-rec_count = gv_record_cnt.
    INSERT INTO CVI_PRECHK VALUES ls_cvi_prechk.

    "Needed for foreground result display.
    ex_prechk_header = ls_cvi_prechk.

    lt_objid_rn = im_gen_selection-objid_rn.
    lt_cv_group = im_gen_selection-cv_group.
    IF im_gen_selection-bgmode EQ abap_true.
      "Background mode.
      lv_taskid = lv_runid.
      CALL FUNCTION 'CVI_PRECHK_PPF_TASK' STARTING NEW TASK lv_taskid
        CALLING update_prechk_status ON END OF TASK
        EXPORTING
          iv_runid         = lv_runid
          iv_objtype       = im_gen_selection-objtype
          ir_objid_range   = lt_objid_rn
          ir_cvgroup_range = lt_cv_group
          iv_server_group  = im_gen_selection-server_group
          is_scenario           = im_scenario
        EXCEPTIONS
          communication_failure = 1
          system_failure        = 2
          OTHERS                = 3.
      IF sy-subrc NE 0.
        MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 008 INTO lv_message.
        UPDATE cvi_prechk SET status = '03' error_msg = lv_message WHERE runid = lv_runid. "03 - Error
      ENDIF.
    ELSE.
      "Foreground mode.
      CALL FUNCTION 'CVI_PRECHK_PPF_TASK'
        EXPORTING
          iv_runid         = lv_runid
          iv_objtype       = im_gen_selection-objtype
          ir_objid_range   = lt_objid_rn
          ir_cvgroup_range = lt_cv_group
          iv_server_group  = im_gen_selection-server_group
          is_scenario      = im_scenario
        IMPORTING
          ex_return        = ex_return.

      IF ex_return IS INITIAL.
        UPDATE CVI_PRECHK SET status = '02' WHERE runid = lv_runid. "02 - completed.
      ELSE.
        UPDATE CVI_PRECHK SET status = '03' error_msg = ex_return-message WHERE runid = lv_runid. "03 - Error
      ENDIF.

    ENDIF.


  ENDMETHOD.


  METHOD update_prechk_status.

    DATA lx_return TYPE bapiret2.

    "Receive results from the RFC FM
    RECEIVE RESULTS FROM FUNCTION 'CVI_PRECHK_PPF_TASK'
      IMPORTING ex_return = lx_return
    EXCEPTIONS
      communication_failure = 1
      system_failure = 2
      OTHERS = 3.

    IF sy-subrc NE 0.
      MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 008 INTO lx_return-message.
    ENDIF.

    "p_task will contain the runid as the task name is run id.
    IF lx_return IS INITIAL.
      UPDATE CVI_PRECHK SET status = '02' WHERE runid = p_task. "Completed
    ELSE.
      UPDATE CVI_PRECHK SET status = '03' error_msg = lx_return-message WHERE runid = p_task. "Error - Incomplete
    ENDIF.
  ENDMETHOD.


  METHOD validate_all_data.

    DATA: lt_kunnr    TYPE TABLE OF kna1-kunnr,
          lt_lifnr    TYPE TABLE OF lfa1-lifnr,
          lv_nrobject      TYPE NROBJ,
          ls_address       TYPE adrc,
          lo_custom_prechk TYPE REF TO cvi_custom_prechk,
          lt_error         TYPE if_cvi_prechk=>tt_prechk_error.

    FIELD-SYMBOLS <ls_chk_data> TYPE if_cvi_prechk=>ty_prechk_master_data.

    CLEAR: lt_kunnr, lt_lifnr.

    CHECK is_selection_param-chk_data IS NOT INITIAL.

    CALL METHOD get_data_for_validation
      EXPORTING
        is_selection_param = is_selection_param.

      CALL METHOD get_address
        EXPORTING
        is_selection_param = is_selection_param
          iv_objtype         = iv_objtype.                 " Business Object type - Customer or Vendor

      CALL METHOD get_bank_data
        EXPORTING
        is_selection_param = is_selection_param
        iv_objtype         = iv_objtype.                 " Business Object type - Customer or Vendor

    "Runid is required to raise each error message.
    gv_runid = is_selection_param-runid.


    LOOP AT is_selection_param-chk_data ASSIGNING <ls_chk_data>.
      IF is_selection_param-scen-bank_ind IS NOT INITIAL.
        "Bank data checks.
        CALL METHOD execute_bank_check
          EXPORTING
            iv_objectid = <ls_chk_data>-cvnum                 " Customer/Vendor Number
            iv_objtype  = iv_objtype                 " Business Object type - Customer or Vendor
          CHANGING
            ct_error    = et_error.                 " Precheck to identify errors
      ENDIF.
      CLEAR ls_address.
      READ TABLE gt_address INTO ls_address WITH KEY addrnumber = <ls_chk_data>-adrnr.
      IF sy-subrc = 0.
        IF is_selection_param-scen-addr_ind IS NOT INITIAL.
          "Address data checks
          CALL METHOD execute_address_check
            EXPORTING
              iv_objectid = <ls_chk_data>-cvnum                 " Customer/Vendor Number
              iv_objtype  = iv_objtype
              is_address  = ls_address                 " Addresses (Business Address Services)
            CHANGING
              ct_error    = et_error.                 " Precheck to identify errors
        ENDIF.
        IF is_selection_param-scen-pcode_ind IS NOT INITIAL.
          "Postal code checks.
          CALL METHOD execute_postcode_check
            EXPORTING
              iv_objectid = <ls_chk_data>-cvnum                 " Customer/Vendor Number
              iv_objtype  = iv_objtype
              is_address  = ls_address                 " Addresses (Business Address Services)
            CHANGING
              ct_error    = et_error.                 " Precheck to identify errors
        ENDIF.
        IF is_selection_param-scen-email_ind IS NOT INITIAL.
          "Email field check
          CALL METHOD execute_email_check
            EXPORTING
              iv_objectid = <ls_chk_data>-cvnum                " Customer/Vendor Number
              iv_objtype  = iv_objtype                " Business Object type - Customer or Vendor
              is_address  = ls_address                " Addresses (Business Address Services)
            CHANGING
              ct_error    = et_error.                " Precheck to identify errors
        ENDIF.
        IF is_selection_param-scen-taxjur_ind IS NOT INITIAL.
          "Tax jurisdiction code checks
          CALL METHOD execute_tax_jur_check
            EXPORTING
              iv_objectid = <ls_chk_data>-cvnum                " Customer/Vendor Number
              iv_objtype  = iv_objtype                " Business Object type - Customer or Vendor
              iv_txjcd    = <ls_chk_data>-txjcd                " Tax Jurisdiction
              is_address  = ls_address                " Addresses (Business Address Services)
            CHANGING
              ct_error    = et_error.                " Precheck to identify errors
        ENDIF.
        IF is_selection_param-scen-tzone_ind IS NOT INITIAL.
          "Transportation zone checks
          CALL METHOD execute_transzone_check
            EXPORTING
              iv_objectid    = <ls_chk_data>-cvnum                 " Customer/Vendor Number
              iv_objtype     = iv_objtype                 " Business Object type - Customer or Vendor
              is_address     = ls_address                 " Addresses (Business Address Services)
              is_master_data = <ls_chk_data>
            CHANGING
              ct_error       = et_error.                 " Precheck to identify errors
        ENDIF.
      ENDIF.

      IF is_selection_param-scen-indus_ind IS NOT INITIAL.
        "Industry assignment checks
        CALL METHOD execute_industry_check
          EXPORTING
            iv_objectid        = <ls_chk_data>-cvnum                " Customer/Vendor Number
            iv_objtype         = iv_objtype                " Business Object type - Customer or Vendor
            iv_industry_sector = <ls_chk_data>-brsch                " Industry key
          CHANGING
            ct_error           = et_error.                " Precheck to identify errors
      ENDIF.

      IF is_selection_param-scen-taxcode_ind IS NOT INITIAL.
        "Tax code checks
        CALL METHOD execute_tax_type_check
          EXPORTING
            is_selection_param = <ls_chk_data>                 " Fields for Pre-checking Master Data
            iv_objtype        = iv_objtype                 " Business Object type - Customer or Vendor
          CHANGING
            ct_error          = et_error.                 " Precheck to identify errors
      ENDIF.

      IF is_selection_param-scen-numrng_ind IS NOT INITIAL.
        IF iv_objtype = if_cvi_prechk=>gc_objtype_cust.
          lv_nrobject = if_cvi_prechk=>gc_debitor.
        ELSEIF iv_objtype = if_cvi_prechk=>gc_objtype_vend.
          lv_nrobject = if_cvi_prechk=>gc_kredebitor.
        ENDIF.
        "Number range checks
        CALL METHOD execute_number_range_check
          EXPORTING
            iv_objectid      = <ls_chk_data>-cvnum              " Customer/Vendor Number
            iv_objtype       = iv_objtype                " Business Object type - Customer or Vendor
            iv_account_group = <ls_chk_data>-acc_group                 " Undefined range (can be used for patch levels)
            iv_nrobject      = lv_nrobject                " TYPE TO BE CHANGED TO NROBJECT
          CHANGING
            ct_error         = et_error.                " Precheck to identify errors

      ENDIF.

      "For BADI call. Adding in existing loop to avoid extra loop if badi for custom checks is implemented.
      IF iv_objtype EQ if_cvi_prechk=>gc_objtype_cust.
        APPEND <ls_chk_data>-cvnum TO lt_kunnr.
      ELSEIF iv_objtype EQ if_cvi_prechk=>gc_objtype_vend.
        APPEND <ls_chk_data>-cvnum TO lt_lifnr.
      ENDIF.

    ENDLOOP.

    "Call BADI for additional custom checks
    TRY.
        GET BADI lo_custom_prechk.
        IF lo_custom_prechk IS BOUND.
          CALL BADI lo_custom_prechk->execute_custom_check
            EXPORTING
              it_customer = lt_kunnr                " Table type for kna1-kunnr
              it_vendor   = lt_lifnr               " Table type for lfa1-lifnr
            IMPORTING
              ct_error    = lt_error.               " Precheck to identify errors
          IF lt_error IS NOT INITIAL.
            APPEND LINES OF lt_error TO et_error.
          ENDIF.
        ENDIF.
      CATCH cx_badi_not_implemented ##NO_HANDLER. "BADI is not mandatory to implement
    ENDTRY.
  ENDMETHOD.


  METHOD validate_selection_input.


    IF im_gen_selection-objtype EQ if_cvi_prechk=>gc_objtype_cust.

      SELECT COUNT(*) FROM kna1 INTO gv_record_cnt WHERE kunnr IN im_gen_selection-objid_rn AND ktokd IN im_gen_selection-cv_group
                                                   AND kunnr NOT IN ( SELECT customer FROM cvi_cust_link where customer IN im_gen_selection-objid_rn ).

    ELSEIF im_gen_selection-objtype EQ if_cvi_prechk=>gc_objtype_vend.

      SELECT COUNT(*) FROM lfa1 INTO gv_record_cnt WHERE lifnr IN im_gen_selection-objid_rn AND ktokk IN im_gen_selection-cv_group
                                                   AND lifnr NOT IN ( SELECT vendor FROM cvi_vend_link where vendor IN im_gen_selection-objid_rn ).

    ENDIF.

    IF gv_record_cnt > IF_CVI_PRECHK=>max_record_process.
      "Throw an error message, not supporting more than 10000000(1 million) per run.
      IF 1 = 2.
        MESSAGE e004(cvi_prechk) WITH if_cvi_prechk=>max_record_process.
      ENDIF.
      CLEAR ex_return.
      ex_return-type = 'E'.
      ex_return-id = if_cvi_prechk=>gc_message_class.
      ex_return-number = '004'.
      ex_return-message_v1 = if_cvi_prechk=>max_record_process.
      MESSAGE ID ex_return-id TYPE ex_return-type NUMBER ex_return-number WITH if_cvi_prechk=>max_record_process INTO ex_return-message.
      RETURN.
    ELSEIF gv_record_cnt EQ 0.
      "If the selection parameters return 0 records.
      IF 1 = 2.
        MESSAGE e033(CVI_PRECHK).
      ENDIF.
      CLEAR ex_return.
      ex_return-type = 'E'.
      ex_return-id = if_cvi_prechk=>gc_message_class.
      ex_return-number = '033'.
      MESSAGE ID ex_return-id TYPE ex_return-type NUMBER ex_return-number INTO ex_return-message.
      RETURN.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
