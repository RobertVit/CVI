class CL_S4_CHECKS_BP definition
  public
  final
  create public .

public section.

  types TY_RETURN_CODE type I .
  types:
    BEGIN OF ty_preprocessing_check_result,
        software_component    TYPE dlvunit,
        check_id              TYPE c LENGTH 40,   "to be chosen as needed
        description           TYPE c LENGTH 255,  " must contain the SAP note that describes the check, provides further information and how to deal with possible problems.
        return_code           TYPE ty_return_code,
        application_component TYPE ufps_posid,    " Application component for BCP customer incident, if the customer has to open a ticket with questions about the check.
      END   OF ty_preprocessing_check_result .
  types:
    tt_preprocessing_check_results TYPE STANDARD TABLE OF ty_preprocessing_check_result .
  types:
    BEGIN OF ty_sw_component,
        sw_component TYPE dlvunit,
      END   OF ty_sw_component .
  types:
    tt_sw_components TYPE STANDARD TABLE OF ty_sw_component .
  types:
    BEGIN OF ty_release_info,
        sw_component         TYPE dlvunit,
        sw_component_release TYPE saprelease,
        sw_component_sp      TYPE sappatchlv,
      END   OF ty_release_info .
  types:
    tt_release_info TYPE STANDARD TABLE OF ty_release_info .

  constants:
    BEGIN OF co_return_code,
        success  TYPE ty_return_code VALUE 0,
        warning  TYPE ty_return_code VALUE 4,
        error    TYPE ty_return_code VALUE 8,
        abortion TYPE ty_return_code VALUE 12,
      END   OF co_return_code .
  class-data GV_KNA1 type C .
  class-data GV_LFA1 type C .
  class-data GV_KNA1_CVI_MAPPING type C .
  class-data GV_LFA1_CVI_MAPPING type C .
  class-data GV_KNA1_AC_BPROLE type C .
  class-data GV_LFA1_AC_BPROLE type C .
  class-data GV_LFA1_VEND_MAPPING type C .
  class-data GV_KNA1_VALUE_MAPPING type C .
  class-data S_CURSOR type CURSOR .
  class-data S_CURSOR_LFA1 type CURSOR .
  class-data S_CURSOR_KNA1_AC type CURSOR .
  class-data S_CURSOR_LFA1_AC type CURSOR .
  class-data S_CURSOR_KNA1_MAPPING type CURSOR .
  class-data S_CURSOR_LFA1_MAPPING type CURSOR .
  class-data S_CURSOR_KNA1_VAL_MAP type CURSOR .
  class-data S_CURSOR_LFA1_VEND_MAP type CURSOR .
  class-data S_CURSOR_KNVK type CURSOR .
  class-data S_CURSOR_RETAIL type CURSOR .
  class-data GV_RETAIL type C .
  class-data S_CURSOR_RETAIL_VEND type CURSOR .
  class-data GV_RETAIL_VEND type C .

  class-methods GET_SUPPORTED_SW_COMPONENTS
    exporting
      !ET_SW_COMPONENTS type TT_SW_COMPONENTS .
  class-methods IS_SW_COMPONENT_USED
    importing
      !IV_SW_COMPONENT type DLVUNIT
    exporting
      !EV_IS_USED type ABAP_BOOL .
  class-methods GET_PREPROCESSING_CHECK_RESULT
    importing
      !IT_SW_COMPONENTS type TT_SW_COMPONENTS
    exporting
      !ET_CHECK_RESULTS type TT_PREPROCESSING_CHECK_RESULTS .
  class-methods GET_MINIMUM_TARGET_RELEASE
    importing
      !IT_SW_COMPONENTS type TT_SW_COMPONENTS
    exporting
      !ET_RELEASE_INFO type TT_RELEASE_INFO .
  class-methods GET_RESULTS
    exporting
      !ET_CHECK_RESULTS type TT_PREPROCESSING_CHECK_RESULTS .
protected section.
private section.

  types:
    BEGIN OF ty_table,
        table_name          TYPE tabname,
*        view_name           TYPE viewname,
*        is_aggregate        TYPE abap_bool,
*        is_fully_replaced   TYPE abap_bool,
*        is_rel_for_stor_loc TYPE abap_bool,
*        is_redirected       TYPE abap_bool,
*        is_document_table   TYPE abap_bool,
*        is_document_header  TYPE abap_bool,
*        is_stock_in_transit TYPE abap_bool,
      END OF ty_table .
  types:
    tt_table TYPE STANDARD TABLE OF ty_table WITH KEY table_name .

  constants:
    begin of co_supported_sw_components,
        sap_appl type dlvunit value 'SAP_APPL_LO_MD_BP',
      end   of co_supported_sw_components .
  class-data GV_PACKAGE_SIZE type I .
  class-data GT_TABLES type TT_TABLE .
  class-data GV_MSEG_TABLE_NAME type TABNAME .

  class-methods CHECK_BP_ROLE_AC
    changing
      !CT_CHECK_RESULTS type TT_PREPROCESSING_CHECK_RESULTS .
  class-methods CHECK_AC_BPROLE
    changing
      !CT_CHECK_RESULTS type TT_PREPROCESSING_CHECK_RESULTS .
  class-methods PROCESS_DB_EXCEPTION
    importing
      !IX_EXCEPTION type ref to CX_SY_OPEN_SQL_ERROR
      !IV_CHECK_ID type TY_PREPROCESSING_CHECK_RESULT-CHECK_ID
    changing
      !CT_CHECK_RESULTS type TT_PREPROCESSING_CHECK_RESULTS .
  class-methods CHECK_CVI_MAPPING
    changing
      !CT_CHECK_RESULTS type TT_PREPROCESSING_CHECK_RESULTS .
  class-methods CHECK_VALUE_MAPPING
    changing
      !CT_CHECK_RESULTS type TT_PREPROCESSING_CHECK_RESULTS .
  class-methods CHECK_VEND_VALUE_MAPPING
    changing
      !CT_CHECK_RESULTS type TT_PREPROCESSING_CHECK_RESULTS .
  class-methods CHECK_CONTACT_PERSON_MAPPING
    changing
      !CT_CHECK_RESULTS type TT_PREPROCESSING_CHECK_RESULTS .
  class-methods CHECK_POST_VALUE_MAPPING
    changing
      !CT_CHECK_RESULTS type TT_PREPROCESSING_CHECK_RESULTS .
  class-methods CHECK_CUST_PART_OF_RETAIL_SITE
    importing
      !IT_KEYS type CMDS_KNA1_T optional
      !IT_KNA1 type CMDS_KNA1_T optional
    exporting
      !ET_PART_OF_SITE type CMDS_CUSTOMER_NUMBERS_S_T .
  class-methods CHECK_VEND_PART_OF_RETAIL_SITE
    importing
      !IT_KEYS type VMDS_LFA1_T optional
      !IT_LFA1 type VMDS_LFA1_T optional
    exporting
      !ET_PART_OF_SITE type VMDS_VENDOR_NUMBERS_S_T .
ENDCLASS.



CLASS CL_S4_CHECKS_BP IMPLEMENTATION.


METHOD check_ac_bprole.
  DATA : ls_table LIKE LINE OF gt_tables.
  DATA : lt_kna1 TYPE STANDARD TABLE OF kna1.
  DATA : ls_kna1 LIKE LINE OF lt_kna1.
  DATA : lt_cviv_cust_to_bp1 TYPE STANDARD TABLE OF cvic_cust_to_bp1.
  DATA : ls_cviv_cust LIKE LINE OF  lt_cviv_cust_to_bp1 .
  DATA : lt_cviv_vend_to_bp1 TYPE STANDARD TABLE OF cvic_vend_to_bp1.
  DATA : ls_cviv_vend_to_bp1 LIKE LINE OF lt_cviv_vend_to_bp1 .
  DATA : ls_check_result TYPE ty_preprocessing_check_result.
  DATA : lt_lfa1 TYPE STANDARD TABLE OF lfa1.
  DATA : ls_lfa1 LIKE LINE OF lt_lfa1.
  DATA : lx_open_sql_error TYPE REF TO cx_sy_open_sql_error .
  ls_check_result-software_component    = 'SAP_APPL'.
  ls_check_result-check_id              = 'CHK_BP_AC'.
  ls_check_result-application_component = 'LO-MD-BP'.
  ls_check_result-description = 'CHK_BP_AC - Every account group a BP Grouping must be available'.


  DATA : lt_keys TYPE  cmds_kna1_t."cmds_customer_numbers_t .
  DATA : ls_key LIKE LINE OF lt_keys.
  DATA : lt_kna1_temp TYPE cmds_kna1_t.
  DATA : ls_kna1_temp LIKE LINE OF lt_kna1_temp.
  DATA : lt_kna1_key  TYPE cmds_customer_numbers_s_t.
  DATA : ls_kna1_key LIKE LINE OF lt_kna1_key.

  DATA : lt_keys_vend TYPE vmds_lfa1_t. "vmds_vendor_numbers_t .
  DATA : ls_key_vend LIKE LINE OF lt_keys_vend.
  DATA : lt_lfa1_temp TYPE vmds_lfa1_t.
  DATA : ls_lfa1_temp LIKE LINE OF lt_lfa1_temp.
  DATA : lt_lfa1_key  TYPE vmds_vendor_numbers_s_t.
  DATA : ls_lfa1_key LIKE LINE OF lt_lfa1_key.


  DATA : p_psize TYPE integer VALUE '1000'.  " Package size

  TRY.
      IF s_cursor_kna1_ac IS INITIAL.
        OPEN CURSOR: s_cursor_kna1_ac FOR
*        SELECT DISTINCT * FROM kna1 AS a CLIENT SPECIFIED
*                WHERE ktokd IS NOT NULL AND ktokd NOT IN ( SELECT account_group FROM  cvic_cust_to_bp1 AS b  CLIENT SPECIFIED WHERE a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ. " mandt kunnr ktokd

        SELECT DISTINCT * FROM kna1 AS a CLIENT SPECIFIED
            WHERE ktokd IS NOT NULL AND ktokd NOT IN ( SELECT account_group FROM  cvic_cust_to_bp1 AS b  CLIENT SPECIFIED WHERE a~mandt = b~client and a~ktokd = b~account_group ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ. " mandt kunnr ktokd

      ENDIF.

      DO.
        FETCH NEXT CURSOR s_cursor_kna1_ac INTO TABLE lt_kna1 PACKAGE SIZE p_psize.
        IF sy-subrc NE 0 .
          CLOSE CURSOR s_cursor_kna1_ac.
          gv_kna1_ac_bprole = 'X'.
          EXIT .
        ELSE.
          SORT lt_kna1 BY mandt kunnr .
          LOOP AT lt_kna1 INTO ls_kna1.
            ls_key-mandt = ls_kna1-mandt.
            ls_key-kunnr = ls_kna1-kunnr .
            APPEND ls_key TO lt_keys.
            MOVE-CORRESPONDING ls_kna1 TO ls_kna1_temp.
            APPEND ls_kna1 TO lt_kna1_temp.
            CLEAR ls_key.
            CLEAR ls_kna1_temp.
            CLEAR ls_kna1.
          ENDLOOP.
        ENDIF.
*   endif.

        CALL METHOD check_cust_part_of_retail_site
          EXPORTING
            it_keys         = lt_keys
            it_kna1         = lt_kna1_temp
          IMPORTING
            et_part_of_site = lt_kna1_key.


        SORT lt_kna1 BY ktokd mandt.
        DELETE ADJACENT DUPLICATES FROM lt_kna1 COMPARING ktokd mandt.

        LOOP AT lt_kna1 INTO ls_kna1.
          READ TABLE lt_kna1_key INTO ls_kna1_key WITH KEY kunnr = ls_kna1-kunnr.
          IF sy-subrc = 0.
            DELETE TABLE lt_kna1 FROM ls_kna1.
          ENDIF.
          CLEAR ls_kna1.
          CLEAR ls_kna1_key.
        ENDLOOP.


        LOOP AT lt_kna1 INTO ls_kna1 WHERE ktokd IS NOT INITIAL.
          CONCATENATE ls_kna1-ktokd  'Customer account group is not maintained in table' 'CVIC_CUST_TO_BP1 in client' ls_kna1-mandt ' kindly refer note 2210486'   INTO ls_check_result-description IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT
          ls_check_result-return_code =  co_return_code-warning.
          APPEND ls_check_result TO ct_check_results.
*          clear ls_check_result.
        ENDLOOP.
        REFRESH lt_kna1.
        REFRESH lt_kna1_temp.
        REFRESH lt_kna1_key.
        REFRESH lt_keys.

        FREE: lt_kna1, lt_kna1_temp, lt_kna1_key, lt_keys.

      ENDDO.



      DATA : p_psize_lfa1 TYPE integer VALUE '1000'.  " Package size


      IF s_cursor_lfa1_ac IS INITIAL.
        OPEN CURSOR: s_cursor_lfa1_ac FOR
*        SELECT DISTINCT * FROM lfa1 AS a CLIENT SPECIFIED
*                               WHERE  ktokk IS NOT NULL  AND ktokk NOT IN ( SELECT account_group FROM  cvic_vend_to_bp1 AS b CLIENT SPECIFIED WHERE a~mandt = b~client ). "#EC CI_NOWHERE "#ECCI_BUFFSUBQ. "mandt lifnr ktokk

        SELECT DISTINCT * FROM lfa1 AS a CLIENT SPECIFIED
           WHERE ktokk IS NOT NULL  AND ktokk NOT IN ( SELECT account_group FROM  cvic_vend_to_bp1 AS b CLIENT SPECIFIED WHERE a~mandt = b~client and a~ktokk = b~account_group ). "#EC CI_NOWHERE "#ECCI_BUFFSUBQ. "mandt lifnr ktokk

      ENDIF.
      DO.
        FETCH NEXT CURSOR s_cursor_lfa1_ac INTO TABLE lt_lfa1 PACKAGE SIZE p_psize_lfa1.
        IF sy-subrc NE 0 .
          CLOSE CURSOR s_cursor_lfa1_ac.
          gv_lfa1_ac_bprole = 'X'.
          EXIT .
        ELSE.
          SORT lt_lfa1 BY mandt lifnr .
          LOOP AT lt_lfa1 INTO ls_lfa1.
            ls_key_vend-mandt = ls_lfa1-mandt.
            ls_key_vend-lifnr = ls_lfa1-lifnr .
            APPEND ls_key_vend TO lt_keys_vend.
            MOVE-CORRESPONDING ls_lfa1 TO ls_lfa1_temp.
            APPEND ls_lfa1 TO lt_lfa1_temp.
            CLEAR ls_key_vend.
            CLEAR ls_lfa1_temp.
            CLEAR ls_lfa1.
          ENDLOOP.
        ENDIF.
*  endif.



        CALL METHOD check_vend_part_of_retail_site
          EXPORTING
            it_keys         = lt_keys_vend
            it_lfa1         = lt_lfa1_temp
          IMPORTING
            et_part_of_site = lt_lfa1_key.

*
*        REFRESH lt_lfa1_temp.
*        REFRESH lt_lfa1.



        SORT lt_lfa1 BY mandt ktokk.
        DELETE ADJACENT DUPLICATES FROM lt_lfa1 COMPARING mandt ktokk .


        LOOP AT lt_lfa1 INTO ls_lfa1.
          READ TABLE lt_lfa1_key INTO ls_lfa1_key WITH KEY lifnr = ls_lfa1-lifnr.
          IF sy-subrc = 0.
            DELETE TABLE lt_lfa1 FROM ls_lfa1.
          ENDIF.
          CLEAR ls_lfa1.
          CLEAR ls_lfa1_key.
        ENDLOOP.


        LOOP AT lt_lfa1 INTO ls_lfa1 WHERE ktokk IS NOT INITIAL.
            CONCATENATE ls_lfa1-ktokk  'Vendor account group is not maintained in table' 'CVIC_VEND_TO_BP1' ls_lfa1-mandt 'kindly refer note 2210486'   INTO ls_check_result-description IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT
            ls_check_result-return_code =  co_return_code-warning.
            APPEND ls_check_result TO ct_check_results.
*            clear ls_check_result.

        ENDLOOP.

        REFRESH lt_lfa1.
        REFRESH lt_lfa1_temp.
        REFRESH lt_lfa1_key.
        REFRESH lt_keys_vend.

        FREE: lt_lfa1, lt_lfa1_temp, lt_lfa1_key, lt_keys_vend.

      ENDDO.



    CATCH cx_sy_open_sql_error INTO lx_open_sql_error.
      process_db_exception(
        EXPORTING
          ix_exception     = lx_open_sql_error
          iv_check_id      = 'CHK_BP_AC'
        CHANGING
          ct_check_results = ct_check_results ).
  ENDTRY.

*  CLEAR : ls_table,
*        ls_kna1,
*        ls_cviv_cust,
*        ls_cviv_vend_to_bp1,
*        ls_check_result,
*        ls_lfa1,
*        lx_open_sql_error,
*        ls_key,
*        ls_kna1_temp,
*        ls_kna1_key,
*        ls_key_vend,
*        ls_lfa1_temp,
*        ls_lfa1_key.
*
*  REFRESH : lt_kna1,
*            lt_cviv_cust_to_bp1,
*            lt_cviv_vend_to_bp1,
*            lt_lfa1,
*            lt_keys,
*            lt_kna1_temp,
*            lt_kna1_key,
*            lt_keys_vend,
*            lt_lfa1_temp,
*            lt_lfa1_key.

ENDMETHOD.


METHOD check_bp_role_ac.
  DATA : ls_table LIKE LINE OF gt_tables.
  DATA : lt_kna1 TYPE STANDARD TABLE OF kna1.
  DATA : ls_kna1 LIKE LINE OF lt_kna1.
  DATA : lt_cviv_cust_to_bp2 TYPE STANDARD TABLE OF cvic_cust_to_bp2.
  DATA : ls_cviv_cust LIKE LINE OF  lt_cviv_cust_to_bp2 .
  DATA : lt_cviv_vend_to_bp2 TYPE STANDARD TABLE OF cvic_vend_to_bp2.
  DATA : ls_cviv_vend_to_bp2 LIKE LINE OF lt_cviv_vend_to_bp2 .
  DATA : ls_check_result TYPE ty_preprocessing_check_result.
  DATA : lt_lfa1 TYPE STANDARD TABLE OF lfa1.
  DATA : ls_lfa1 LIKE LINE OF lt_lfa1.
  DATA: lx_open_sql_error TYPE REF TO cx_sy_open_sql_error.
  ls_check_result-software_component    = 'SAP_APPL'.
  ls_check_result-check_id              = 'CHK_BP_ROLE'.
  ls_check_result-application_component = 'LO-MD-BP'.
  ls_check_result-description = 'CHK_BP_ROLE - BP roles are assigned to account groups'.



  DATA : lt_keys TYPE cmds_kna1_t. "cmds_customer_numbers_t .
  DATA : ls_key LIKE LINE OF lt_keys.
  DATA : lt_kna1_temp TYPE cmds_kna1_t.
  DATA : ls_kna1_temp LIKE LINE OF lt_kna1_temp.
  DATA : lt_kna1_key  TYPE cmds_customer_numbers_s_t.
  DATA : ls_kna1_key LIKE LINE OF lt_kna1_key.

  DATA : lt_keys_vend TYPE  vmds_lfa1_t. "vmds_vendor_numbers_t .
  DATA : ls_key_vend LIKE LINE OF lt_keys_vend.
  DATA : lt_lfa1_temp TYPE vmds_lfa1_t.
  DATA : ls_lfa1_temp LIKE LINE OF lt_lfa1_temp.
  DATA : lt_lfa1_key  TYPE vmds_vendor_numbers_s_t.
  DATA : ls_lfa1_key LIKE LINE OF lt_lfa1_key.


  DATA : p_psize TYPE integer VALUE '1000'.  " Package size
  TRY.

      IF s_cursor IS INITIAL.
        OPEN CURSOR: s_cursor FOR
*        SELECT DISTINCT * FROM kna1 AS a CLIENT SPECIFIED
*            WHERE ktokd IS NOT NULL AND ktokd NOT IN ( SELECT  account_group  FROM cvic_cust_to_bp2 AS b CLIENT SPECIFIED WHERE a~mandt = b~client  ). "#EC CI_NOWHERE "#EC CI_BUFFSUB endif. "mandt kunnr ktokd

        SELECT DISTINCT * FROM kna1 AS a CLIENT SPECIFIED
           WHERE ktokd IS NOT NULL AND ktokd NOT IN ( SELECT account_group FROM cvic_cust_to_bp2 AS b CLIENT SPECIFIED WHERE a~mandt = b~client AND a~ktokd = b~account_group ). "#EC CI_NOWHERE "#EC CI_BUFFSUB endif. "mandt kunnr ktokd

      ENDIF.

      DO.
        FETCH NEXT CURSOR s_cursor INTO TABLE lt_kna1 PACKAGE SIZE p_psize.
        IF sy-subrc NE 0 .
          CLOSE CURSOR s_cursor.
          gv_kna1 = 'X'.
          EXIT .
        ELSE.
          SORT lt_kna1 BY mandt kunnr.
          LOOP AT lt_kna1 INTO ls_kna1.
            ls_key-mandt = ls_kna1-mandt.
            ls_key-kunnr = ls_kna1-kunnr .
            APPEND ls_key TO lt_keys.
            MOVE-CORRESPONDING ls_kna1 TO ls_kna1_temp.
            APPEND ls_kna1 TO lt_kna1_temp.
            CLEAR ls_key.
            CLEAR ls_kna1_temp.
            CLEAR ls_kna1.
          ENDLOOP.
        ENDIF.


        CALL METHOD check_cust_part_of_retail_site
          EXPORTING
            it_keys         = lt_keys
            it_kna1         = lt_kna1_temp
          IMPORTING
            et_part_of_site = lt_kna1_key.


        SORT lt_kna1 BY  mandt ktokd.
        DELETE ADJACENT DUPLICATES FROM lt_kna1 COMPARING  mandt ktokd.

        LOOP AT lt_kna1 INTO ls_kna1.
          READ TABLE lt_kna1_key INTO ls_kna1_key WITH KEY kunnr = ls_kna1-kunnr.
          IF sy-subrc = 0 .
            DELETE TABLE lt_kna1 FROM ls_kna1.
          ENDIF.
          CLEAR ls_kna1.
          CLEAR ls_kna1_key.
        ENDLOOP.

        LOOP AT lt_kna1 INTO ls_kna1 WHERE ktokd IS NOT INITIAL.
          CONCATENATE ls_kna1-ktokd  'Customer Account group is not maintained in table' 'CVIC_CUST_TO_BP2 in client' ls_kna1-mandt  'kindly refer note 2210486'    INTO ls_check_result-description IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT
          ls_check_result-return_code =  co_return_code-warning.
          APPEND ls_check_result TO ct_check_results.
        ENDLOOP.

        REFRESH lt_kna1.
        REFRESH lt_kna1_temp.
        REFRESH lt_kna1_key.
        REFRESH lt_keys.

        free: lt_kna1, lt_kna1_temp, lt_kna1_key, lt_keys.


      ENDDO.


      DATA : p_psize_lfa1 TYPE integer VALUE '1000'.  " Package size

      IF s_cursor_lfa1 IS INITIAL.
        OPEN CURSOR: s_cursor_lfa1 FOR
*        SELECT DISTINCT * FROM lfa1 AS a CLIENT SPECIFIED
*         WHERE ktokk IS NOT NULL  AND ktokk  NOT IN ( SELECT  account_group  FROM cvic_vend_to_bp2 AS b CLIENT SPECIFIED  WHERE a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ. " mandt lifnr ktokk

        SELECT DISTINCT * FROM lfa1 AS a CLIENT SPECIFIED
           WHERE ktokk IS NOT NULL AND ktokk NOT IN ( SELECT account_group FROM cvic_vend_to_bp2 AS b CLIENT SPECIFIED WHERE a~mandt = b~client AND a~ktokk = b~account_group ). "#EC CI_NOWHERE "#EC CI_BUFFSUB endif. "mandt kunnr ktokd

      ENDIF.
      DO.
        FETCH NEXT CURSOR s_cursor_lfa1 INTO TABLE lt_lfa1 PACKAGE SIZE p_psize_lfa1.
        IF sy-subrc NE 0 .
          CLOSE CURSOR s_cursor_lfa1.
          gv_lfa1 = 'X'.
          EXIT .
        ELSE.
          SORT lt_lfa1 BY mandt lifnr.
          LOOP AT lt_lfa1 INTO ls_lfa1.
            ls_key_vend-mandt = ls_lfa1-mandt.
            ls_key_vend-lifnr = ls_lfa1-lifnr .
            APPEND ls_key_vend TO lt_keys_vend.
            MOVE-CORRESPONDING ls_lfa1 TO ls_lfa1_temp.
            APPEND ls_lfa1 TO lt_lfa1_temp.
            CLEAR ls_key_vend.
            CLEAR ls_lfa1_temp.
            CLEAR ls_lfa1.
          ENDLOOP.
        ENDIF.



        CALL METHOD check_vend_part_of_retail_site
          EXPORTING
            it_keys         = lt_keys_vend
            it_lfa1         = lt_lfa1_temp
          IMPORTING
            et_part_of_site = lt_lfa1_key.



        SORT lt_lfa1 BY mandt ktokk.
        DELETE ADJACENT DUPLICATES FROM lt_lfa1 COMPARING mandt ktokk.


        LOOP AT lt_lfa1 INTO ls_lfa1.
          READ TABLE lt_lfa1_key INTO ls_lfa1_key WITH KEY lifnr = ls_lfa1-lifnr.
          IF sy-subrc = 0.
            DELETE TABLE lt_lfa1 FROM ls_lfa1.
          ENDIF.
          CLEAR ls_lfa1.
          CLEAR ls_lfa1_key.
        ENDLOOP.



        LOOP AT lt_lfa1 INTO ls_lfa1 WHERE ktokk IS NOT INITIAL.
          CONCATENATE ls_lfa1-ktokk  'Vendor Account Group is not maintained in table' 'CVIC_VEND_TO_BP2 in client' ls_lfa1-mandt 'kindly refer note 2210486'   INTO ls_check_result-description IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT
          ls_check_result-return_code =  co_return_code-warning.
          APPEND ls_check_result TO ct_check_results.
        ENDLOOP.


        REFRESH lt_lfa1.
        REFRESH lt_lfa1_temp.
        REFRESH lt_lfa1_key.
        REFRESH lt_keys_vend.

        FREE: lt_lfa1, lt_lfa1_temp, lt_lfa1_key, lt_keys_vend.

      ENDDO.




    CATCH cx_sy_open_sql_error INTO lx_open_sql_error.
      process_db_exception(
        EXPORTING
          ix_exception     = lx_open_sql_error
          iv_check_id      = 'CHK_BP_ROLE'
        CHANGING
          ct_check_results = ct_check_results ).
  ENDTRY.


  CLEAR : ls_kna1,
          ls_table,
          ls_cviv_cust,
          ls_cviv_vend_to_bp2,
          ls_check_result,
          ls_check_result,
          ls_lfa1,
          lx_open_sql_error,
          ls_key,
          ls_kna1_temp,
          ls_kna1_key,
          ls_key_vend,
          ls_lfa1_temp,
          ls_lfa1_key
          .

  REFRESH : lt_kna1,
              lt_cviv_cust_to_bp2,
              lt_cviv_vend_to_bp2,
              lt_lfa1,
              lt_keys,
              lt_kna1_temp,
              lt_kna1_key,
              lt_keys_vend,
              lt_lfa1_temp,
              lt_lfa1_key.

  FREE : lt_kna1,
            lt_cviv_cust_to_bp2,
            lt_cviv_vend_to_bp2,
            lt_lfa1,
            lt_keys,
            lt_kna1_temp,
            lt_kna1_key,
            lt_keys_vend,
            lt_lfa1_temp,
            lt_lfa1_key.


ENDMETHOD.


  method check_contact_person_mapping.
    data : lt_knvk type standard table of knvk.
    data : ls_knvk like line of lt_knvk.
    data : lt_lfa1 type standard table of lfa1.
    data : ls_lfa1 like line of lt_lfa1.

    data : lt_cust_link type standard table of cvi_cust_link.
    data : ls_cust_link like line of lt_cust_link.
    data : lt_vend_link type standard table of cvi_vend_link.
    data : ls_vend_link like line of lt_vend_link.
    data : ls_check_result like line of ct_check_results.
    data :lx_open_sql_error type ref to cx_sy_open_sql_error.
    data : table_name type tabname.
    data : lv_status type as4local.
    data : lv_subrc type sy-subrc .
    data : lv_cust_count type integer value 1.
    data : lv_vend_count type integer value 1.


    data : lt_keys type cmds_kna1_t. "cmds_customer_numbers_t .
    data : ls_key like line of lt_keys.
    data : lt_kna1_temp type cmds_kna1_t.
    data : ls_kna1_temp like line of lt_kna1_temp.
    data : lt_kna1_key  type cmds_customer_numbers_s_t.
    data : ls_kna1_key like line of lt_kna1_key.


    data : lt_keys_vend type vmds_lfa1_t. "vmds_vendor_numbers_t .
    data : ls_key_vend like line of lt_keys_vend.
    data : lt_lfa1_temp type vmds_lfa1_t.
    data : ls_lfa1_temp like line of lt_lfa1_temp.
    data : lt_lfa1_key  type vmds_vendor_numbers_s_t.
    data : ls_lfa1_key like line of lt_lfa1_key.



    data :lt_knvk_temp type cmds_knvk_t.   "cmds_customer_numbers_s_t
    data :ls_knvk_temp like line of lt_knvk_temp.
    data : lt_knvk_key type cmds_customer_numbers_s_t.
    data : ls_knvk_key  like line of lt_knvk_key.
    data : lt_kna1 type standard table of kna1.
    data : ls_kna1 like line of lt_kna1.
    data : ls_kna1_consm like line of lt_kna1.

    ls_check_result-software_component    = 'SAP_APPL'.
    ls_check_result-check_id              = 'CHK_CONT_MAP'.
    ls_check_result-application_component = 'LO-MD-BP'.
    ls_check_result-description           = 'CHK_CONT_MAP - Check for contact person mapping'.

    try.

        table_name = 'CVI_CUST_CT_LINK' .

        call function 'DD_EXIST_TABLE'
          exporting
            tabname      = table_name
            status       = 'M'
          importing
            subrc        = lv_subrc
          exceptions
            wrong_status = 1
            others       = 2.
        if sy-subrc <> 0.
* Implement suitable error handling here
        endif.
        if lv_subrc = 0.

          data : s_cursor_knvk4 type cursor.
          data : lv_cursor_kna1 type cursor.

          data : p_psize_knvk4 type integer value '1000'.
          data :p_psize_kna1 type integer value '1000'.



          if s_cursor_knvk4 is initial.
            open cursor : s_cursor_knvk4  for
*           SELECT * FROM knvk AS a CLIENT SPECIFIED  WHERE kunnr IS NOT NULL AND parnr NOT IN ( SELECT customer_cont FROM (table_name) AS b CLIENT SPECIFIED WHERE a~mandt = b~client  ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

*            SELECT * FROM knvk AS a CLIENT SPECIFIED
*                WHERE kunnr IS NOT NULL AND parnr NOT IN ( SELECT customer_cont FROM (table_name) AS b CLIENT SPECIFIED WHERE a~mandt = b~client and a~parnr = b~customer_cont ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

            select * from knvk as a client specified
            where kunnr ne ''
            and lifnr eq '' and
            parnr not in ( select customer_cont from (table_name) as b client specified where a~mandt = b~client and a~parnr = b~customer_cont ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.


          endif.


          do.
            fetch next cursor  s_cursor_knvk4  into table lt_knvk package size p_psize_knvk4.


            if sy-subrc ne 0.
              close cursor s_cursor_knvk4.
              exit .
            else.
              "changes

              sort lt_knvk by mandt kunnr.
              select distinct * from kna1 client specified into corresponding fields of table
                lt_kna1_temp  for all entries in lt_knvk where kunnr = lt_knvk-kunnr and mandt = lt_knvk-mandt.

* SORT lt_kna1_temp by mandt kunnr.

              loop at lt_kna1_temp into ls_kna1_temp.
                move-corresponding ls_kna1_temp to ls_key.
                append ls_key to lt_keys.
              endloop.

            endif.
*
*              LOOP AT lt_knvk INTO ls_knvk WHERE kunnr IS NOT INITIAL .
*                if lv_cust_count le 1000.
*                CONCATENATE ls_knvk-parnr 'is not mainatined in table'  'CVI_CUST_CT_LINK in client' ls_knvk-mandt  ' kindly refer note 2210486'   INTO ls_check_result-description IN CHARACTER MODE. "#EC NOTEXT
*                ls_check_result-return_code =  co_return_code-abortion.
*                APPEND ls_check_result TO ct_check_results.
*                lv_cust_count = lv_cust_count + 1.
*                endif.
*            clear ls_check_result.
*              ENDLOOP.





            call method check_cust_part_of_retail_site
              exporting
                it_keys         = lt_keys
                it_kna1         = lt_kna1_temp
              importing
                et_part_of_site = lt_kna1_key.


            loop at lt_knvk into ls_knvk.
              read table lt_kna1_key into ls_kna1_key with key kunnr = ls_knvk-kunnr .
              if sy-subrc = 0.
                delete table lt_knvk from ls_knvk.
              endif.
              clear ls_knvk.
              clear ls_knvk_key.
            endloop.


            loop at lt_knvk into ls_knvk where parnr is not initial .
              if lv_cust_count le 1000.
                read table lt_kna1_temp into ls_kna1_consm with key kunnr = ls_knvk-kunnr.
                if ls_kna1_consm-dear6 is INITIAL.
                  concatenate ls_knvk-parnr 'is not mainatined in table'  'CVI_CUST_CT_LINK in client' ls_knvk-mandt  ' kindly refer note 2210486'   into ls_check_result-description in character mode. "#EC NOTEXT
                  ls_check_result-return_code =  co_return_code-abortion.
                  append ls_check_result to ct_check_results.
                else.
                  concatenate ls_knvk-parnr 'is not mainatined in table'  'CVI_CUST_CT_LINK in client' ls_knvk-mandt  ' kindly refer note 2210486'   into ls_check_result-description in character mode. "#EC NOTEXT
                  ls_check_result-return_code =  co_return_code-warning.
                  append ls_check_result to ct_check_results.
                endif.
                lv_cust_count = lv_cust_count + 1.
              endif.
*              clear ls_check_result.
            endloop.
            refresh lt_knvk.
            refresh lt_knvk_key.
            refresh lt_knvk_temp.
            refresh lt_keys.

            free : lt_knvk,lt_knvk_key,lt_knvk_temp,lt_keys.
            refresh  lt_kna1.
            refresh  lt_kna1_key.
            refresh  lt_kna1_temp.
            refresh lt_keys.
*          clear lv_cust_count.

            free: lt_kna1, lt_kna1_key, lt_kna1_temp, lt_keys.

            clear lv_cust_count.
          enddo.

        endif.


        clear table_name.

        table_name = 'CVI_VEND_CT_LINK' .
        call function 'DD_EXIST_TABLE'
          exporting
            tabname      = table_name
            status       = 'M'
          importing
            subrc        = lv_subrc
          exceptions
            wrong_status = 1
            others       = 2.
        if sy-subrc <> 0.
* Implement suitable error handling here
        endif.
        if lv_subrc = 0.
          data : s_cursor_knvk5 type cursor.
          data : p_psize_knvk5 type integer value '1000'.
          data : lv_cursor_lfa1 type cursor.
          data : p_psize_lfa1 type integer value '1000'.

          if s_cursor_knvk5 is initial.
            open cursor : s_cursor_knvk5  for
*            SELECT * FROM knvk AS a CLIENT SPECIFIED
*                                                WHERE lifnr IS NOT NULL AND parnr NOT IN ( SELECT vendor_cont FROM (table_name) AS b CLIENT SPECIFIED WHERE a~mandt = b~client  ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
*
*            SELECT * FROM knvk AS a CLIENT SPECIFIED
*                WHERE lifnr IS NOT NULL AND parnr NOT IN ( SELECT vendor_cont FROM (table_name) AS b CLIENT SPECIFIED WHERE a~mandt = b~client and a~parnr = b~vendor_cont ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

            select * from knvk as a client specified
            where kunnr eq ''
            and lifnr ne '' and
            parnr not in ( select vendor_cont from (table_name) as b client specified where a~mandt = b~client and a~parnr = b~vendor_cont ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

          endif.


          do.
**              FETCH NEXT CURSOR  s_cursor_knvk5  INTO TABLE lt_knvk PACKAGE SIZE p_psize_knvk5.
**              IF sy-subrc NE 0.
**                CLOSE CURSOR s_cursor_knvk5.
**                EXIT .
**              ELSE.
**
**                LOOP AT lt_knvk INTO ls_knvk WHERE lifnr IS NOT INITIAL.
**                  if lv_vend_count le 1000.
**                    CONCATENATE ls_knvk-parnr 'is not mainatined in table'  'CVI_VEND_CT_LINK in client'  ls_knvk-mandt  ' kindly refer note 2210486' INTO ls_check_result-description IN CHARACTER MODE. "#EC NOTEXT
**                    ls_check_result-return_code =  co_return_code-abortion.
**                    APPEND ls_check_result TO ct_check_results.
**                    lv_vend_count = lv_vend_count + 1.
**                  endif.
***            clear ls_check_result.
**                ENDLOOP.
**              ENDIF.
**              REFRESH lt_knvk.
**              FREE lt_knvk.
**              clear lv_vend_count.



            fetch next cursor  s_cursor_knvk5  into table lt_knvk package size p_psize_knvk5.
            if sy-subrc ne 0.
              close cursor s_cursor_knvk5.
              exit .
            else.

              "changes
              sort lt_knvk by mandt lifnr.

              select distinct * from lfa1 client specified into corresponding fields of table
  lt_lfa1_temp  for all entries in lt_knvk where lifnr = lt_knvk-lifnr and mandt = lt_knvk-mandt.


              loop at lt_lfa1_temp into ls_lfa1_temp.
                move-corresponding ls_lfa1_temp to ls_key_vend.
                append ls_key_vend to lt_keys_vend.
              endloop.


            endif.
*
*              LOOP AT lt_knvk INTO ls_knvk WHERE kunnr IS NOT INITIAL .
*                if lv_cust_count le 1000.
*                CONCATENATE ls_knvk-parnr 'is not mainatined in table'  'CVI_CUST_CT_LINK in client' ls_knvk-mandt  ' kindly refer note 2210486'   INTO ls_check_result-description IN CHARACTER MODE. "#EC NOTEXT
*                ls_check_result-return_code =  co_return_code-abortion.
*                APPEND ls_check_result TO ct_check_results.
*                lv_cust_count = lv_cust_count + 1.
*                endif.
*            clear ls_check_result.
*              ENDLOOP.




            call method check_vend_part_of_retail_site
              exporting
                it_keys         = lt_keys_vend
                it_lfa1         = lt_lfa1_temp
              importing
                et_part_of_site = lt_lfa1_key.



            loop at lt_knvk into ls_knvk.
              read table lt_lfa1_key into ls_lfa1_key with key lifnr = ls_knvk-lifnr.
              if sy-subrc = 0.
                delete table lt_knvk from ls_knvk.
              endif.
              clear ls_knvk.
              clear ls_knvk_key.
            endloop.


            loop at lt_knvk into ls_knvk where parnr is not initial .
              if lv_vend_count le 1000.
                concatenate ls_knvk-parnr 'is not mainatined in table'  'CVI_VEND_CT_LINK in client' ls_knvk-mandt  ' kindly refer note 2210486'   into ls_check_result-description in character mode. "#EC NOTEXT
                ls_check_result-return_code =  co_return_code-abortion.
                append ls_check_result to ct_check_results.
                lv_vend_count = lv_vend_count + 1.
              endif.
*              clear ls_check_result.
            endloop.

            refresh lt_knvk.
            refresh lt_knvk_key.
            refresh lt_knvk_temp.
            refresh  lt_lfa1.
            refresh  lt_lfa1_key.
            refresh  lt_lfa1_temp.

*          clear lv_cust_count.
            free : lt_knvk,lt_knvk_key,lt_knvk_temp,lt_keys_vend.
            free: lt_lfa1, lt_lfa1_key, lt_lfa1_temp.

            clear lv_vend_count.

          enddo.


        endif.
      catch cx_sy_open_sql_error into lx_open_sql_error.
        process_db_exception(
          exporting
            ix_exception     = lx_open_sql_error
            iv_check_id      = 'CHK_CONT_MAP'
          changing
            ct_check_results = ct_check_results ).
    endtry.
  endmethod.


METHOD check_cust_part_of_retail_site.

  DATA:
    lt_werks_in         TYPE cvis_werks_t,
    lt_kna1_temp        TYPE STANDARD TABLE OF kna1,
    lt_retail_sites     TYPE cvis_werks_t,
    lt_candidates       TYPE cmds_customer_plant_t,
    lt_potential_sites  TYPE cmds_customer_plant_t,
    ls_potential_sites  TYPE cmds_customer_plant,
    ls_customer_number  TYPE cmds_customer_number.


  DATA : p_psize1 TYPE integer VALUE '1000'.  " Package size
  DATA : ls_kna1 LIKE LINE OF lt_kna1_temp.
  DATA : ls_kna1_new LIKE LINE OF lt_kna1_temp.
  DATA : ls_cust_plant TYPE cmds_customer_plant.
  DATA : lt_keys TYPE cmds_kna1_t.
  DATA : ls_key LIKE LINE OF lt_keys.
  DATA : lv_count TYPE i.

  FIELD-SYMBOLS:
    <ls_kna1>          TYPE kna1,
    <ls_cust_plant>    TYPE cmds_customer_plant.

* first, process the table with the structure
  LOOP AT it_kna1 ASSIGNING <ls_kna1>
        WHERE NOT werks IS INITIAL.
* kna1 sentences with field werks filled are possible retail sites
    INSERT <ls_kna1>-werks INTO TABLE lt_werks_in.
    ls_potential_sites-kunnr = <ls_kna1>-kunnr.
    ls_potential_sites-werks = <ls_kna1>-werks.
    APPEND ls_potential_sites TO lt_potential_sites.
  ENDLOOP.

* now process the keys which are passed over
  IF NOT it_keys[] IS INITIAL.
*    CALL METHOD cmd_ei_api_check=>get_customer_with_plant
*      EXPORTING
*        it_keys       = it_keys
*      IMPORTING
*        et_candidates = lt_candidates.

* SELECT kunnr werks FROM kna1 CLIENT SPECIFIED INTO CORRESPONDING FIELDS OF TABLE lt_candidates FOR ALL ENTRIES IN it_keys WHERE kunnr = it_keys-kunnr AND NOT werks = space.
*lt_keys = it_keys.

    CLEAR lv_count.
    LOOP AT it_keys INTO ls_key.
      APPEND ls_key TO lt_keys.
      DESCRIBE TABLE lt_keys LINES lv_count.
      IF lv_count  >= p_psize1.
        IF lt_keys IS NOT INITIAL.
*          SELECT kunnr werks FROM kna1 CLIENT SPECIFIED INTO CORRESPONDING FIELDS OF TABLE lt_kna1_temp  FOR ALL ENTRIES IN lt_keys WHERE kunnr = lt_keys-kunnr AND NOT werks = space.
          loop at it_kna1 into ls_kna1_new where not werks eq space. "werks is not initial.
          read table lt_keys with key kunnr = ls_kna1_new-kunnr transporting no fields  .
            if sy-subrc = 0.
*            if ls_kna1_new-werks ne space and ls_kna1_new-kunnr is not initial.
*              ls_kna1_new-kunnr = it_kna1-kunnr.
*              ls_kna1_new-kunnr = it_kna1-kunnr.
              append ls_kna1_new to lt_kna1_temp.
              clear ls_kna1_new.
*              endif.
              endif.
          endloop.
        ENDIF.
        "proces your task
        LOOP AT lt_kna1_temp INTO ls_kna1 .
          ls_cust_plant-kunnr = ls_kna1-kunnr.
          ls_cust_plant-werks = ls_kna1-werks.
          APPEND ls_cust_plant TO lt_candidates.
          CLEAR ls_cust_plant.
        ENDLOOP.
        SORT lt_candidates BY kunnr werks.

        LOOP AT lt_candidates ASSIGNING <ls_cust_plant>.
          APPEND <ls_cust_plant> TO lt_potential_sites.
          INSERT <ls_cust_plant>-werks INTO TABLE lt_werks_in.
        ENDLOOP.
        REFRESH lt_candidates.
        REFRESH lt_kna1_temp.
        REFRESH lt_keys.
        free : lt_candidates , lt_kna1_temp , lt_keys.
      ENDIF.

    ENDLOOP.

  ENDIF.




  IF lt_keys IS NOT INITIAL.
    SELECT mandt kunnr werks FROM kna1 as a  CLIENT SPECIFIED INTO CORRESPONDING FIELDS OF TABLE lt_kna1_temp
      FOR ALL ENTRIES IN lt_keys WHERE kunnr = lt_keys-kunnr AND NOT werks = space  and a~MANDT = lt_keys-mandt.
    "proces your task
    LOOP AT lt_kna1_temp INTO ls_kna1 .
      ls_cust_plant-kunnr = ls_kna1-kunnr.
      ls_cust_plant-werks = ls_kna1-werks.
*      ls_cust_plant-mandt = ls_kna1-mandt.
      APPEND ls_cust_plant TO lt_candidates.
      CLEAR ls_cust_plant.
    ENDLOOP.

    SORT lt_candidates BY kunnr werks.

    LOOP AT lt_candidates ASSIGNING <ls_cust_plant>.
      APPEND <ls_cust_plant> TO lt_potential_sites.
      INSERT <ls_cust_plant>-werks INTO TABLE lt_werks_in.
    ENDLOOP.
    REFRESH lt_candidates.
    REFRESH lt_kna1_temp.
    REFRESH lt_keys.
    free : lt_candidates , lt_kna1_temp , lt_keys.
  ENDIF.
*commented to resolve time consuming during fetch of records.
*    IF s_cursor_retail IS INITIAL.
*      OPEN CURSOR: s_cursor_retail FOR
*      SELECT kunnr werks FROM kna1 CLIENT SPECIFIED
*      FOR ALL ENTRIES IN it_keys WHERE kunnr = it_keys-kunnr AND NOT werks = space. "#EC CI_NOWHERE "#EC CI_BUFFSUB endif. "mandt kunnr ktokd
*    ENDIF.
*    DO.
*      FETCH NEXT CURSOR s_cursor_retail INTO TABLE lt_kna1_temp PACKAGE SIZE p_psize1.
*      IF sy-subrc NE 0 .
*        CLOSE CURSOR s_cursor_retail.
*        gv_retail = 'X'.
*        EXIT .
*      ELSE.
*
*        loop at lt_kna1_temp into ls_kna1 .
*          ls_cust_plant-kunnr = ls_kna1-kunnr.
*          ls_cust_plant-werks = ls_kna1-werks.
*          append ls_cust_plant to lt_candidates.
*          clear ls_cust_plant.
*        endloop.
*        SORT lt_candidates BY kunnr werks.
*      ENDIF.
*      LOOP AT lt_candidates ASSIGNING <ls_cust_plant>.
*        APPEND <ls_cust_plant> TO lt_potential_sites.
*        INSERT <ls_cust_plant>-werks INTO TABLE lt_werks_in.
*      ENDLOOP.
*      refresh lt_candidates.
*      refresh lt_kna1_temp.
*    ENDDO.
*  ENDIF.
* end of comment


  IF NOT lt_werks_in[] IS INITIAL.
* get the retail sites
*    CALL METHOD cvi_ei_api=>filter_out_retail_plants
*      EXPORTING
*        it_werks       = lt_werks_in
*      IMPORTING
*        et_retail_part = lt_retail_sites.

*  CHECK NOT it_werks[] IS INITIAL.

    SELECT werks FROM t001w
       CLIENT SPECIFIED
       INTO TABLE lt_retail_sites
       FOR ALL ENTRIES IN lt_werks_in
       WHERE werks = lt_werks_in-table_line
                 AND NOT vlfkz = space.

  ENDIF.

* Table lt_retail_sites picks up every customer which is part of
* a retail site.
* If lt_retail_sites is empty ==> no customer is part of a retail site.
  CHECK NOT lt_retail_sites[] IS INITIAL.

  IF     NOT it_keys[] IS INITIAL
     AND NOT it_kna1[] IS INITIAL.
* if both input tables are used for determine the potential sites, it
* should be checked if there are duplicates found.
    SORT lt_potential_sites BY kunnr werks.
    DELETE ADJACENT DUPLICATES FROM lt_potential_sites.
  ENDIF.

  LOOP AT lt_potential_sites ASSIGNING <ls_cust_plant>.
    READ TABLE lt_retail_sites
           WITH TABLE KEY table_line = <ls_cust_plant>-werks
           TRANSPORTING NO FIELDS.

    IF sy-subrc = 0.
* customer is part of a retail site
      ls_customer_number-kunnr = <ls_cust_plant>-kunnr.
      INSERT ls_customer_number INTO TABLE et_part_of_site.
    ENDIF.
  ENDLOOP.




ENDMETHOD.


  method check_cvi_mapping.
    data : lt_kna1 type standard table of kna1.
    data : ls_kna1 like line of lt_kna1.
    data : lt_lfa1 type standard table of lfa1.
    data : ls_lfa1 like line of lt_lfa1.
    data : lt_cust_link type standard table of cvi_cust_link.
    data : ls_cust_link like line of lt_cust_link.
    data : lt_vend_link type standard table of cvi_vend_link.
    data : ls_vend_link like line of   lt_vend_link.
    data : ls_check_result like line of ct_check_results.
    data : lx_open_sql_error type ref to cx_sy_open_sql_error.


    data : lt_keys type cmds_kna1_t. "cmds_customer_numbers_t .
    data : ls_key like line of lt_keys.
    data : lt_kna1_temp type cmds_kna1_t.
    data : ls_kna1_temp like line of lt_kna1_temp.
    data : lt_kna1_key  type cmds_customer_numbers_s_t.
    data : ls_kna1_key like line of lt_kna1_key.


    data : lt_keys_vend type vmds_lfa1_t. "vmds_vendor_numbers_t .
    data : ls_key_vend like line of lt_keys_vend.
    data : lt_lfa1_temp type vmds_lfa1_t.
    data : ls_lfa1_temp like line of lt_lfa1_temp.
    data : lt_lfa1_key  type vmds_vendor_numbers_s_t.
    data : ls_lfa1_key like line of lt_lfa1_key.
    data : lv_cursor_kna1 type cursor.

*    Data : lv_cust_count type integer value 1.
*    Data : lv_vend_count type integer value 1.



    ls_check_result-software_component    = 'SAP_APPL'.
    ls_check_result-check_id              = 'CVI_MAPPING'.
    ls_check_result-application_component = 'LO-MD-BP'.
    ls_check_result-description = 'CVI_MAPPING - Customer/Vendor Mapping'.




*    select * from kna1 client specified  into corresponding fields of table lt_kna1.
*    sort lt_kna1 by mandt kunnr.
*    loop at lt_kna1 into ls_kna1.
*      ls_key-kunnr = ls_kna1-kunnr .
*      append ls_key to lt_keys.
*      move-corresponding ls_kna1 to ls_kna1_temp.
*      append ls_kna1 to lt_kna1_temp.
*      clear ls_key.
*      clear ls_kna1_temp.
*      clear ls_kna1.
*    endloop.

    data : p_psize_kna1 type integer value '1000'.  " Package size
*  DATA : lv_cursor_kna1 TYPE cursor.
*if gv_kna1_cvi_mapping is not initial.

    try.
        if lv_cursor_kna1 is initial.
          open cursor: lv_cursor_kna1 for
*          SELECT * FROM kna1 AS a CLIENT SPECIFIED WHERE LIfnr = '' and  kunnr NOT IN ( SELECT customer FROM cvi_cust_link AS b CLIENT SPECIFIED WHERE a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

          select * from kna1 as a client specified where lifnr = '' and  kunnr not in ( select customer from cvi_cust_link as b client specified where a~mandt = b~client and a~kunnr = b~customer ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

        endif.

        do.
          fetch next cursor lv_cursor_kna1 into table lt_kna1 package size p_psize_kna1.
          if sy-subrc ne 0 .
            close cursor lv_cursor_kna1.
            gv_kna1_cvi_mapping = 'X'.
            exit .
          else.
            sort lt_kna1 by mandt kunnr.
            loop at lt_kna1 into ls_kna1.

              ls_key-mandt = ls_kna1-mandt.
              ls_key-kunnr = ls_kna1-kunnr .

              append ls_key to lt_keys.
              move-corresponding ls_kna1 to ls_kna1_temp.
              append ls_kna1 to lt_kna1_temp.
              clear ls_key.
              clear ls_kna1_temp.
              clear ls_kna1.
            endloop.
          endif.
*    endif.


          call method check_cust_part_of_retail_site
            exporting
              it_keys         = lt_keys
              it_kna1         = lt_kna1_temp
            importing
              et_part_of_site = lt_kna1_key.


          loop at lt_kna1 into ls_kna1.
            read table lt_kna1_key into ls_kna1_key with key kunnr = ls_kna1-kunnr.
            if sy-subrc = 0.
              delete table lt_kna1 from ls_kna1.
            endif.
            clear ls_kna1.
            clear ls_kna1_key.
          endloop.




          loop at lt_kna1 into ls_kna1 where kunnr is not initial.
*            if lv_cust_count le 1000.
            if ls_kna1-dear6 is initial.
              concatenate ls_kna1-kunnr  'is not having CVI mapping check the table'  'CVI_CUST_LINK in client' ls_kna1-mandt ' kindly refer note 2210486'   into ls_check_result-description in character mode separated by space. "#EC NOTEXT
              ls_check_result-return_code =  co_return_code-abortion.
              append ls_check_result to ct_check_results.
            else.
              concatenate ls_kna1-kunnr  'is not having CVI mapping check the table'  'CVI_CUST_LINK in client' ls_kna1-mandt ' kindly refer note 2210486'   into ls_check_result-description in character mode separated by space. "#EC NOTEXT
              ls_check_result-return_code =  co_return_code-warning.
              append ls_check_result to ct_check_results.
            endif.
*            lv_cust_count = lv_cust_count + 1.
*            endif.
*          clear ls_check_result.
          endloop.

          refresh  lt_kna1.
          refresh  lt_kna1_key.
          refresh  lt_kna1_temp.
          refresh lt_keys.
*          clear lv_cust_count.

          free: lt_kna1, lt_kna1_key, lt_kna1_temp, lt_keys.

        enddo.

**
*    select * from lfa1 client specified  into corresponding fields of table lt_lfa1.
*    sort lt_lfa1 by mandt lifnr.
*    loop at lt_lfa1 into ls_lfa1.
*      ls_key_vend-lifnr = ls_lfa1-kunnr .
*      append ls_key_vend to lt_keys_vend.
*      move-corresponding ls_lfa1 to ls_lfa1_temp.
*      append ls_lfa1 to lt_lfa1_temp.
*      clear ls_key_vend.
*      clear ls_lfa1_temp.
*      clear ls_lfa1.
*    endloop.


        data : p_psize_lfa1 type integer value '1000'.  " Package size
*  DATA : s_cursor_lfa1_mapping TYPE cursor.
*  if gv_lfa1_cvi_mapping is not initial.
        if s_cursor_lfa1_mapping is initial.
          open cursor: s_cursor_lfa1_mapping for
*          SELECT * FROM lfa1 AS a CLIENT SPECIFIED
*          WHERE kunnr = '' and lifnr NOT IN ( SELECT vendor FROM cvi_vend_link AS b CLIENT SPECIFIED WHERE a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

          select * from lfa1 as a client specified
             where kunnr = '' and lifnr not in ( select vendor from cvi_vend_link as b client specified where a~mandt = b~client and a~lifnr = b~vendor ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

        endif.

        do.
          fetch next cursor s_cursor_lfa1_mapping into table lt_lfa1 package size p_psize_lfa1.
          if sy-subrc ne 0 .
            close cursor s_cursor_lfa1_mapping.
            gv_lfa1_cvi_mapping = 'X'.
            exit .
          else.
            sort lt_lfa1 by mandt lifnr.
            loop at lt_lfa1 into ls_lfa1.
              ls_key_vend-mandt = ls_lfa1-mandt.
              ls_key_vend-lifnr = ls_lfa1-lifnr .
              append ls_key_vend to lt_keys_vend.
              move-corresponding ls_lfa1 to ls_lfa1_temp.
              append ls_lfa1 to lt_lfa1_temp.
              clear ls_key_vend.
              clear ls_lfa1_temp.
              clear ls_lfa1.
            endloop.

          endif.
*    endif.



          call method check_vend_part_of_retail_site
            exporting
              it_keys         = lt_keys_vend
              it_lfa1         = lt_lfa1_temp
            importing
              et_part_of_site = lt_lfa1_key.


          loop at lt_lfa1 into ls_lfa1.
            read table lt_lfa1_key into ls_lfa1_key with key lifnr = ls_lfa1-lifnr.
            if sy-subrc = 0.
              delete table lt_lfa1 from ls_lfa1.
            endif.
            clear ls_lfa1.
            clear ls_lfa1_key.
          endloop.

          loop at lt_lfa1 into ls_lfa1 where lifnr is not initial.
*            if lv_vend_count le 1000.
            concatenate ls_lfa1-lifnr 'is not having CVI mapping check the table'  'CVI_VEND_LINK in client' ls_lfa1-mandt ' kindly refer note 2210486'  into ls_check_result-description in character mode separated by space. "#EC NOTEXT
            ls_check_result-return_code =  co_return_code-abortion.
            append ls_check_result to ct_check_results.
*            lv_vend_count = lv_vend_count + 1.
*            endif.
*          clear ls_check_result.
          endloop.


          refresh  lt_lfa1.
          refresh  lt_lfa1_key.
          refresh  lt_lfa1_temp.
          refresh lt_keys_vend.
*          clear lv_vend_count.
          free : lt_lfa1 , lt_lfa1_key , lt_lfa1_temp , lt_keys_vend.

        enddo.

      catch cx_sy_open_sql_error into lx_open_sql_error.
        process_db_exception(
          exporting
            ix_exception     = lx_open_sql_error
            iv_check_id      = 'CVI_MAPPING'
          changing
            ct_check_results = ct_check_results ).
    endtry.


    clear : ls_kna1,
            ls_lfa1,
            ls_cust_link,
            ls_vend_link,
            ls_check_result,
            ls_key,ls_kna1_temp,
            ls_kna1_key,
            ls_key_vend,
            ls_lfa1_temp,
            ls_lfa1_key,
            lx_open_sql_error.

    refresh : lt_kna1,
              lt_lfa1,
              lt_cust_link,
              lt_vend_link,
              lt_keys,
              lt_kna1_temp,
              lt_kna1_key,
              lt_keys_vend,
              lt_lfa1_temp,
              lt_lfa1_key.

    free : lt_kna1,
              lt_lfa1,
              lt_cust_link,
              lt_vend_link,
              lt_keys,
              lt_kna1_temp,
              lt_kna1_key,
              lt_keys_vend,
              lt_lfa1_temp,
              lt_lfa1_key.



  endmethod.


  method check_post_value_mapping.
    data : lt_but051 type table of but051.
    data : ls_but051 like line of lt_but051.
    data : lt_but000 type table of but000.
    data : ls_but000 like line of lt_but000.
    data : lt_but0is type table of but0is.
    data : ls_but0is like line of lt_but0is.
    data : lt_cvic_cp1_link type table of cvic_cp1_link.
    data : ls_cviv_cp1_link like line of  lt_cvic_cp1_link.
    data : ls_map_contact type cvic_map_contact.
    data :ls_cvic_cp1_link like line of lt_cvic_cp1_link.
    data : lt_cvic_cp2_link type table of cvic_cp2_link.
    data : ls_cvic_cp2_link like line of lt_cvic_cp2_link.
    data : lt_cvic_cp3_link type table of cvic_cp3_link.
    data : ls_cvic_cp3_link like line of lt_cvic_cp3_link.
    data : lt_cvic_cp4_link type table of cvic_cp4_link.
    data : ls_cvic_cp4_link like line of lt_cvic_cp4_link.
    data: lt_cvic_marst_link  type standard table of cvic_marst_link .
    data: ls_cvic_marst_link  like line of lt_cvic_marst_link .
    data : lt_cvic_legform_lnk type standard table of cvic_legform_lnk.
    data: ls_cvic_legform_lnk like line of lt_cvic_legform_lnk.
    data : lt_payment type standard table of but0cc.
    data : ls_payment like line of lt_payment.
    data : lt_payment_master type standard table of pca_master.
    data : ls_payment_master like line of lt_payment_master.
    data: lt_cvic_ccid_link type standard table of cvic_ccid_link.
    data : ls_cvic_ccid_link like line of lt_cvic_ccid_link.
    data : ls_check_result like line of ct_check_results.
    data : lt_tp038m2  type standard table of tp038m2 .
    data : ls_tp038m2  like line of lt_tp038m2 .
    data :lt_but100_vend type standard table of but100.
    data :lt_but100  type standard table of but100.
    data : lt_but000_bp type standard table of but000.

    data: lx_open_sql_error type ref to cx_sy_open_sql_error.
    ls_check_result-software_component    = 'SAP_APPL'.
    ls_check_result-check_id              = 'CHK_POST_CON_ASSIGNMENT'.
    ls_check_result-application_component = 'LO-MD-BP'.
    ls_check_result-description            = 'CHK_POST_CON_ASSIGNMENT - Post check for contact person assignment'.

    try.

*
        data : lt_tb910 type standard table of tb910.
        data : ls_tb910 like line of lt_tb910.
        data : lt_tb912 type standard table of tb912.
        data : ls_tb912 like line of lt_tb912 .
        data : lt_tb914 type standard table of tb914.
        data : ls_tb914 like line of lt_tb914 .
        data : lt_tb916 type standard table of tb916 .
        data : ls_tb916 like line of lt_tb916.
        data : lt_tb027  type standard table of tb027.
        data : ls_tb027 like line of lt_tb027.
        data : lt_tb019 type standard table of tb019.
        data : ls_tb019 like line of lt_tb019.
        data : lt_tb038a type standard table of tb038a.
        data : ls_tb038a like line of lt_tb038a.
        data : lt_tb033 type standard table of tb033.
        data : ls_tb033 like line of lt_tb033.

*b.  Assign Department Numbers for Contact Person
        select distinct * from tb910 as a client specified into corresponding fields of table lt_tb910 where
          abtnr not in ( select abtnr from cvic_cp1_link as b client specified  where  a~client = b~client  and a~abtnr = b~abtnr ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
        if sy-subrc = 0.
          loop at  lt_tb910 into ls_tb910 where abtnr is not initial  .
            concatenate ls_tb910-abtnr 'Department not maintained in table' 'CVIC_CP1_LINK in client' ls_tb910-client 'kindly refer note 2210486' into ls_check_result-description in character mode. "#EC NOTEXT
            ls_check_result-return_code =  co_return_code-warning.

            append ls_check_result to ct_check_results.
*            clear ls_check_result.
            clear ls_tb910.
          endloop.

        endif.

* Assign for department functions

        select distinct * from tb912 as a client specified  into corresponding fields of table lt_tb912 where
          pafkt not in ( select gp_pafkt from cvic_cp2_link as b client specified  where a~client = b~client  and a~pafkt = b~gp_pafkt    ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
        if sy-subrc = 0.
          loop at  lt_tb912 into ls_tb912 where pafkt is not initial  .
            concatenate ls_tb912-pafkt 'Function not maintained in table' 'CVIC_CP2_LINK in client' ls_tb912-client 'kindly refer note 2210486'   into ls_check_result-description in character mode. "#EC NOTEXT
            ls_check_result-return_code =  co_return_code-warning.
            append ls_check_result to ct_check_results.
*            clear ls_check_result.
            clear ls_tb912.
          endloop.

        endif.


*  Authority
        select distinct * from tb914 as a client specified  into corresponding fields of table lt_tb914 where
           paauth not in ( select paauth from cvic_cp3_link as b client specified where a~client = b~client and a~paauth = b~paauth  ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
        if sy-subrc =  0.
          loop at  lt_tb914 into ls_tb914 where paauth is not initial  .
            concatenate ls_tb914-paauth 'Authority not mainatined in table' 'CVIC_CP3_LINK in client' ls_tb914-client ' kindly refer note 2210486'   into ls_check_result-description in character mode. "#EC NOTEXT
            ls_check_result-return_code =  co_return_code-warning.
            append ls_check_result to ct_check_results.
*            clear ls_check_result.
            clear ls_tb914.
          endloop.

        endif.


*  VIP Indicator

        select distinct * from tb916 as a  client specified  into corresponding fields of table lt_tb916 where
          pavip not in ( select pavip from cvic_cp4_link as b client specified where a~client = b~client and a~pavip = b~pavip ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
        if sy-subrc =  0.
          loop at  lt_tb916 into ls_tb916 where pavip is not initial  .

            concatenate ls_tb916-pavip 'VIP Indicator not mainatined in table' 'CVIC_CP4_LINK in client' ls_tb916-client 'kindly refer note 2210486'   into ls_check_result-description in character mode. "#EC NOTEXT

            ls_check_result-return_code =  co_return_code-warning.
            append ls_check_result to ct_check_results.
*            clear ls_check_result.
            clear ls_tb914.
          endloop.

        endif.


*  Martial status

        select distinct * from tb027  as a client specified  into corresponding fields of table lt_tb027 where
          marst not in ( select marst from cvic_marst_link as b client specified  where a~client = b~client  and a~marst = b~marst ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
        if sy-subrc =  0.
          loop at  lt_tb027 into ls_tb027 where marst is not initial  .
            concatenate ls_tb027-marst 'Marital Status not mainatined in table' 'CVIC_MARST_LINK in client'  ls_tb027-client 'kindly refer note 2210486'   into ls_check_result-description in character mode. "#EC NOTEXT

            ls_check_result-return_code =  co_return_code-warning.
            append ls_check_result to ct_check_results.
*            clear ls_check_result.
            clear ls_tb027.
          endloop.
*

        endif.


*  Legal form

        select distinct * from tb019 as a client specified  into corresponding fields of table lt_tb019 where
          legal_enty not in ( select legal_enty from cvic_legform_lnk as b  client specified where a~client = b~client and a~legal_enty = b~legal_enty ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
        if sy-subrc = 0.
          loop at  lt_tb019 into ls_tb019 where legal_enty is not initial  .
            concatenate ls_tb019-legal_enty 'Legal form not maintained in table' 'CVIC_LEGFORM_LNK in client' ls_tb019-client 'kindly refer note 2210486'   into ls_check_result-description in character mode. "#EC NOTEXT

            ls_check_result-return_code =  co_return_code-warning.
            append ls_check_result to ct_check_results.
*            clear ls_check_result.
            clear ls_tb019.
          endloop.
*
        endif.


*    Industries

*  incoming industry

        select distinct * from  tb038a as a client specified  into corresponding fields of table lt_tb038a
          where istype not in  ( select istype from  tp038m2 as b client specified  where a~client = b~client and a~istype = b~istype  )
          and  ind_sector not in ( select ind_sector from tp038m2 as c client specified where a~client = c~client and a~ind_sector = c~ind_sector  )  . "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

        if sy-subrc = 0.
          loop at  lt_tb038a into ls_tb038a where istype is not initial and ind_sector is not initial .
            concatenate 'For Industry Sector' ls_tb038a-ind_sector 'and for Industry system' ls_tb038a-istype  'Industry Not maintained in table TP038M2 in client'  ls_tb038a-client  ' kindly refer note 2210486'   into ls_check_result-description in
character mode.
            ls_check_result-return_code =  co_return_code-warning.
            append ls_check_result to ct_check_results.
*            clear ls_check_result.
            clear ls_tb038a.
          endloop.
        endif.

* outgoing industry
        select distinct * from  tb038a as a client specified  into corresponding fields of table lt_tb038a
          where istype not in ( select istype from  tp038m1 as b client specified where a~client = b~client and a~istype = b~istype   )
          and  ind_sector not in ( select ind_sector from tp038m1 as c  client specified where a~client = c~client and a~ind_sector = c~ind_sector  ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

        if sy-subrc = 0.
          loop at  lt_tb038a into ls_tb038a where istype is not initial and ind_sector is not initial .
            concatenate 'For Industry Sector' ls_tb038a-ind_sector 'and for Industry system' ls_tb038a-istype  'Industry Not maintained in table TP038M1 in client'  ls_tb038a-client  ' kindly refer note 2210486'   into ls_check_result-description in
character mode.                                             "#EC NOTEXT

            ls_check_result-return_code =  co_return_code-warning.
            append ls_check_result to ct_check_results.
*            clear ls_check_result.
            clear ls_tb038a.
          endloop.
        endif.

*payment card


        select distinct * from  tb033 as a client specified  into corresponding fields of table lt_tb033
          where ccins not in ( select PCID_BP from cvic_ccid_link   as b  client specified where a~mandt = b~client  and a~ccins = b~pcid_bp ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

        if sy-subrc = 0.
          loop at lt_tb033 into ls_tb033 where ccins is not initial .

            concatenate ls_tb033-ccins 'payment Card type not maintained in table' 'CVIC_CCID_LINK in client' ls_tb033-mandt  'kindly refer note 2210486'   into ls_check_result-description in character mode. "#EC NOTEXT

            ls_check_result-return_code =  co_return_code-warning.
            append ls_check_result to ct_check_results.
*            clear ls_check_result.
            clear ls_tb019.
          endloop.
        endif.





      catch cx_sy_open_sql_error into lx_open_sql_error.
        process_db_exception(
          exporting
            ix_exception     = lx_open_sql_error
            iv_check_id      = 'CHK_POST_CON_ASSIGNMENT'
          changing
            ct_check_results = ct_check_results ).
    endtry.


  endmethod.


  METHOD check_value_mapping.
    DATA : lt_knvk TYPE TABLE OF knvk.
    DATA : ls_knvk LIKE LINE OF lt_knvk.
    DATA : lt_kna1 TYPE TABLE OF kna1.
    DATA : ls_kna1 LIKE LINE OF lt_kna1.
    DATA : lt_cvic_cp1_link TYPE TABLE OF cvic_cp1_link.
    DATA : ls_cviv_cp1_link LIKE LINE OF  lt_cvic_cp1_link.
    DATA : ls_map_contact TYPE cvic_map_contact.
    DATA :ls_cvic_cp1_link LIKE LINE OF lt_cvic_cp1_link.
    DATA : lt_cvic_cp2_link TYPE TABLE OF cvic_cp2_link.
    DATA : ls_cvic_cp2_link LIKE LINE OF lt_cvic_cp2_link.
    DATA : lt_cvic_cp3_link TYPE TABLE OF cvic_cp3_link.
    DATA : ls_cvic_cp3_link LIKE LINE OF lt_cvic_cp3_link.
    DATA : lt_cvic_cp4_link TYPE TABLE OF cvic_cp4_link.
    DATA : ls_cvic_cp4_link LIKE LINE OF lt_cvic_cp4_link.
    DATA: lt_cvic_marst_link  TYPE STANDARD TABLE OF cvic_marst_link .
    DATA: ls_cvic_marst_link  LIKE LINE OF lt_cvic_marst_link .
    DATA : lt_cvic_legform_lnk TYPE STANDARD TABLE OF cvic_legform_lnk.
    DATA: ls_cvic_legform_lnk LIKE LINE OF lt_cvic_legform_lnk.
    DATA : lt_payment TYPE STANDARD TABLE OF vckun.
    DATA : ls_payment LIKE LINE OF lt_payment.
    DATA: lt_cvic_ccid_link TYPE STANDARD TABLE OF cvic_ccid_link.
    DATA : ls_cvic_ccid_link LIKE LINE OF lt_cvic_ccid_link.
    DATA : ls_check_result LIKE LINE OF ct_check_results.
    DATA : lt_tp038m2  TYPE STANDARD TABLE OF tp038m2 .
    DATA : ls_tp038m2  LIKE LINE OF lt_tp038m2 .
    DATA: lx_open_sql_error TYPE REF TO cx_sy_open_sql_error.
    ls_check_result-software_component    = 'SAP_APPL'.
    ls_check_result-check_id              = 'CHK_CON_ASSIGNMENT'.
    ls_check_result-application_component = 'LO-MD-BP'.
    ls_check_result-description = 'CHK_CON_ASSIGNMENT - Check contact person assignment'.


    DATA : lt_keys TYPE cmds_kna1_t.
    Data : lt_keys_chk_value TYPE cmds_customer_numbers_t .
    DATA : ls_keys_chk_value like line of lt_keys_chk_value.
    DATA : ls_key LIKE LINE OF lt_keys.
    DATA : lt_kna1_temp TYPE cmds_kna1_t.
    DATA : ls_kna1_temp LIKE LINE OF lt_kna1_temp.
    DATA : lt_kna1_key  TYPE cmds_customer_numbers_s_t.
    DATA : ls_kna1_key LIKE LINE OF lt_kna1_key.

    DATA : lt_keys_vend TYPE   vmds_lfa1_t. "vmds_vendor_numbers_t .
    DATA : ls_key_vend LIKE LINE OF lt_keys_vend.
    DATA : lt_lfa1_temp TYPE vmds_lfa1_t.
    DATA : ls_lfa1_temp LIKE LINE OF lt_lfa1_temp.
    DATA : lt_lfa1_key  TYPE vmds_vendor_numbers_s_t.
    DATA : ls_lfa1_key LIKE LINE OF lt_lfa1_key.

*    select * from kna1 client specified into corresponding fields of table lt_kna1.
*    sort lt_kna1 by mandt kunnr.
*    loop at lt_kna1 into ls_kna1.
*      ls_key-kunnr = ls_kna1-kunnr .
*      append ls_key to lt_keys.
*      move-corresponding ls_kna1 to ls_kna1_temp.
*      append ls_kna1 to lt_kna1_temp.
*      clear ls_key.
*      clear ls_kna1_temp.
*      clear ls_kna1.
*    endloop.







    TRY.


*        a.  Activate Assignment of Contact Persons
        SELECT SINGLE * FROM cvic_map_contact CLIENT SPECIFIED  INTO ls_map_contact . "#EC CI_NOWHERE
        IF ls_map_contact-map_contact IS INITIAL.
          CONCATENATE 'Contact person Assignment not activated and not maintained in table' 'CVIC_MAP_CONTACT in client' ls_map_contact-client 'kindly refer note 2210486'  INTO ls_check_result-description IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT
          ls_check_result-return_code =  co_return_code-warning.
          APPEND ls_check_result TO ct_check_results.
        ENDIF.
*        clear ls_check_result.

*b.	Assign Department Numbers for Contact Person
        DATA : p_psize_knvk TYPE integer VALUE '1000'.  " Package size

        IF s_cursor_knvk IS INITIAL.
          OPEN CURSOR : s_cursor_knvk FOR
*          SELECT DISTINCT * FROM knvk AS a CLIENT SPECIFIED
*                                    WHERE abtnr IS NOT NULL AND abtnr NOT IN ( SELECT abtnr FROM cvic_cp1_link AS b CLIENT SPECIFIED WHERE a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

          SELECT DISTINCT * FROM knvk AS a CLIENT SPECIFIED
             WHERE abtnr IS NOT NULL AND abtnr NOT IN ( SELECT abtnr FROM cvic_cp1_link AS b CLIENT SPECIFIED WHERE a~mandt = b~client and a~abtnr = b~abtnr ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

        ENDIF.



        DO.
        FETCH NEXT CURSOR s_cursor_knvk  INTO TABLE lt_knvk PACKAGE SIZE p_psize_knvk.
          IF sy-subrc NE 0 .
            CLOSE CURSOR s_cursor_knvk.
            EXIT .
          ELSE.

            LOOP AT  lt_knvk INTO ls_knvk WHERE abtnr IS NOT INITIAL  .
              CONCATENATE ls_knvk-abtnr 'Department not maintained in table' 'CVIC_CP1_LINK in client' ls_knvk-mandt 'kindly refer note 2210486'  INTO ls_check_result-description IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT
              ls_check_result-return_code =  co_return_code-warning.
              APPEND ls_check_result TO ct_check_results.
*          clear ls_check_result.
              CLEAR ls_knvk.
            ENDLOOP.

            REFRESH lt_knvk.
            free lt_knvk.
          ENDIF.
        ENDDO.




*c.	Assign Functions of Contact Person
        DATA : s_cursor_knvk6 TYPE cursor.
        DATA : p_psize_knvk6 TYPE integer VALUE '1000'.


        IF s_cursor_knvk6 IS INITIAL.
          OPEN CURSOR : s_cursor_knvk6 FOR
*          SELECT DISTINCT * FROM knvk AS a CLIENT SPECIFIED
*                                                 WHERE pafkt IS NOT NULL AND pafkt NOT IN ( SELECT pafkt FROM cvic_cp2_link AS b CLIENT SPECIFIED WHERE a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

          SELECT DISTINCT * FROM knvk AS a CLIENT SPECIFIED
             WHERE pafkt IS NOT NULL AND pafkt NOT IN ( SELECT pafkt FROM cvic_cp2_link AS b CLIENT SPECIFIED WHERE a~mandt = b~client and a~pafkt = b~pafkt ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.


        ENDIF.

        DO.
          FETCH NEXT CURSOR s_cursor_knvk6  INTO TABLE lt_knvk PACKAGE SIZE p_psize_knvk6.
          IF sy-subrc NE 0 .
            CLOSE CURSOR s_cursor_knvk6.
            EXIT .
          ELSE.
            LOOP AT lt_knvk INTO ls_knvk WHERE pafkt IS NOT INITIAL.
              CONCATENATE ls_knvk-pafkt 'Function not maintained in table' 'CVIC_CP2_LINK in client' ls_knvk-mandt 'kindly refer note 2210486' INTO ls_check_result-description IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT
              ls_check_result-return_code =  co_return_code-warning.
              APPEND ls_check_result TO ct_check_results.
*          clear ls_check_result.
              CLEAR ls_knvk.
            ENDLOOP.

            REFRESH lt_knvk.
            free lt_knvk.
          ENDIF.
        ENDDO.

*b  Assign Authority of Contact Person

        DATA : s_cursor_knvk1 TYPE cursor.
        DATA : p_psize_knvk1 TYPE integer VALUE '1000'.

        IF s_cursor_knvk1 IS INITIAL.
          OPEN CURSOR : s_cursor_knvk1 FOR
*          SELECT DISTINCT * FROM knvk AS a CLIENT SPECIFIED
*                                                                     WHERE parvo IS NOT NULL AND parvo  NOT IN ( SELECT parvo FROM cvic_cp3_link AS b CLIENT SPECIFIED WHERE a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

          SELECT DISTINCT * FROM knvk AS a CLIENT SPECIFIED
             WHERE parvo IS NOT NULL AND parvo  NOT IN ( SELECT parvo FROM cvic_cp3_link AS b CLIENT SPECIFIED WHERE a~mandt = b~client and a~parvo = b~parvo ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

        ENDIF.


        DO.
         FETCH NEXT CURSOR s_cursor_knvk1  INTO TABLE lt_knvk PACKAGE SIZE p_psize_knvk1.
          IF sy-subrc NE 0 .
            CLOSE CURSOR s_cursor_knvk1.
            EXIT .
          ELSE.


            LOOP AT lt_knvk INTO ls_knvk WHERE parvo IS NOT INITIAL.
              CONCATENATE ls_knvk-parvo 'Authority not mainatined in table' 'CVIC_CP3_LINK in client' ls_knvk-mandt  'kindly refer note 2210486' INTO ls_check_result-description IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT
              ls_check_result-return_code =  co_return_code-warning.
              APPEND ls_check_result TO ct_check_results.

*          clear ls_check_result.
              CLEAR ls_knvk.
            ENDLOOP.
            REFRESH lt_knvk.
            free lt_knvk.
          ENDIF.
        ENDDO.

*e.	Assign VIP Indicator for Contact Person

        DATA : s_cursor_knvk2 TYPE cursor.
        DATA : p_psize_knvk2 TYPE integer VALUE '1000'.

        IF s_cursor_knvk2 IS INITIAL.
          OPEN CURSOR : s_cursor_knvk2 FOR
*          SELECT DISTINCT * FROM knvk AS a CLIENT SPECIFIED
*                                                     WHERE pavip IS NOT NULL AND pavip  NOT IN ( SELECT pavip FROM cvic_cp4_link AS b CLIENT SPECIFIED WHERE a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

          SELECT DISTINCT * FROM knvk AS a CLIENT SPECIFIED
             WHERE pavip IS NOT NULL AND pavip NOT IN ( SELECT pavip FROM cvic_cp4_link AS b CLIENT SPECIFIED WHERE a~mandt = b~client and a~pavip = b~pavip ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.


        ENDIF.

        DO.
         FETCH NEXT CURSOR s_cursor_knvk2  INTO TABLE lt_knvk PACKAGE SIZE p_psize_knvk2.
          IF sy-subrc NE 0 .
            CLOSE CURSOR s_cursor_knvk2.
            EXIT .
          ELSE.

            LOOP AT lt_knvk INTO ls_knvk WHERE pavip IS NOT INITIAL.
              CONCATENATE ls_knvk-pavip 'VIP Indicator not mainatined in table' 'CVIC_CP4_LINK in client' 'kindly refer note 2210486' ls_knvk-mandt  INTO ls_check_result-description IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT
              ls_check_result-return_code =  co_return_code-warning.
              APPEND ls_check_result TO ct_check_results.
*          clear ls_check_result.
              CLEAR ls_knvk.
            ENDLOOP.
            REFRESH lt_knvk.
            FREE lt_knvk.
          ENDIF.
        ENDDO.
*f.	Assign Marital Status


        DATA : s_cursor_knvk3 TYPE cursor.
        DATA : p_psize_knvk3 TYPE integer VALUE '1000'.

        IF s_cursor_knvk3 IS INITIAL.
          OPEN CURSOR : s_cursor_knvk3 FOR
*          SELECT DISTINCT * FROM knvk AS a  CLIENT SPECIFIED
*                                        WHERE famst IS NOT NULL AND famst NOT IN ( SELECT famst FROM  cvic_marst_link AS b CLIENT SPECIFIED WHERE a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ

          SELECT DISTINCT * FROM knvk AS a  CLIENT SPECIFIED
             WHERE famst IS NOT NULL AND famst NOT IN ( SELECT famst FROM  cvic_marst_link AS b CLIENT SPECIFIED WHERE a~mandt = b~client and a~famst = b~famst ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ

        ENDIF.

        DO.
         FETCH NEXT CURSOR s_cursor_knvk3  INTO TABLE lt_knvk PACKAGE SIZE p_psize_knvk3.
          IF sy-subrc NE 0 .
            CLOSE CURSOR s_cursor_knvk3.
            EXIT .
          ELSE.
            LOOP AT lt_knvk INTO ls_knvk WHERE famst IS NOT INITIAL.
              CONCATENATE ls_knvk-famst 'Marital Status not mainatined in table' 'CVIC_MARST_LINK in client' ls_knvk-mandt 'kindly refer note 2210486' INTO ls_check_result-description IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT
              ls_check_result-return_code =  co_return_code-warning.
              APPEND ls_check_result TO ct_check_results.
*          clear ls_check_result.
            ENDLOOP.
            REFRESH lt_knvk.
            FREE lt_knvk.
          ENDIF.
        ENDDO.

        DATA : p_psize_kna1 TYPE integer VALUE '1000'.  " Package size
        DATA : p_psize_kna1_1 TYPE integer VALUE '1000'.
        IF s_cursor_kna1_val_map IS INITIAL.
          OPEN CURSOR: s_cursor_kna1_val_map FOR
*          SELECT DISTINCT * FROM kna1 AS a CLIENT SPECIFIED  WHERE gform IS NOT NULL AND gform  NOT IN
*               ( SELECT gform  FROM  cvic_legform_lnk AS b CLIENT SPECIFIED WHERE a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

          SELECT DISTINCT * FROM kna1 AS a CLIENT SPECIFIED
             WHERE gform IS NOT NULL AND gform  NOT IN ( SELECT gform  FROM  cvic_legform_lnk AS b CLIENT SPECIFIED WHERE a~mandt = b~client and a~gform = b~gform ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

        ENDIF.
        DO.
          FETCH NEXT CURSOR s_cursor_kna1_val_map INTO TABLE lt_kna1 PACKAGE SIZE p_psize_kna1.
          IF sy-subrc NE 0 .
            CLOSE CURSOR s_cursor_kna1_val_map.
            gv_kna1_value_mapping = 'X'.
            EXIT .
          ELSE.
            SORT lt_kna1 BY mandt kunnr.
            LOOP AT lt_kna1 INTO ls_kna1.
              ls_key-kunnr = ls_kna1-kunnr .
              ls_key-mandt = ls_kna1-mandt.
              APPEND ls_key TO lt_keys.
              MOVE-CORRESPONDING ls_kna1 TO ls_kna1_temp.
              APPEND ls_kna1 TO lt_kna1_temp.
              CLEAR ls_key.
              CLEAR ls_kna1_temp.
              CLEAR ls_kna1.
            ENDLOOP.
          ENDIF.
*    endif.

          CALL METHOD check_cust_part_of_retail_site
            EXPORTING
              it_keys         = lt_keys
              it_kna1         = lt_kna1_temp
            IMPORTING
              et_part_of_site = lt_kna1_key.

          LOOP AT lt_kna1 INTO ls_kna1.
            READ TABLE lt_kna1_key INTO ls_kna1_key WITH KEY kunnr = ls_kna1-kunnr.
            IF sy-subrc = 0.
              DELETE TABLE lt_kna1 FROM ls_kna1.
            ENDIF.
            CLEAR ls_kna1.
            CLEAR ls_kna1_key.
          ENDLOOP.

*b.	Assign Legal Form to Legal Status

          LOOP AT lt_kna1 INTO ls_kna1 WHERE gform IS NOT INITIAL.
            CONCATENATE ls_kna1-gform 'Legal form not maintained in table' 'CVIC_LEGFORM_LNK in client' ls_kna1-mandt 'kindly refer note 2210486'  INTO ls_check_result-description IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT
            ls_check_result-return_code =  co_return_code-warning.
            APPEND ls_check_result TO ct_check_results.

*          clear ls_check_result.
            CLEAR ls_kna1.
          ENDLOOP.
          REFRESH lt_kna1.
          REFRESH lt_kna1_temp.
          REFRESH lt_kna1_key.
          REFRESH lt_keys.

          FREE: lt_kna1, lt_kna1_temp, lt_kna1_key, lt_keys.

        ENDDO.

* c  Assign Industries
* Incoming industry



*        DATA : p_psize_kna1_1 TYPE integer VALUE '1000'.
        CLEAR s_cursor_kna1_ac.
        IF s_cursor_kna1_ac IS INITIAL.
          OPEN CURSOR: s_cursor_kna1_ac FOR
*          SELECT DISTINCT * FROM kna1 AS a CLIENT SPECIFIED  WHERE brsch IS NOT NULL AND brsch NOT IN ( SELECT brsch FROM tp038m2 AS b CLIENT SPECIFIED WHERE a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

          SELECT DISTINCT * FROM kna1 AS a CLIENT SPECIFIED  WHERE brsch IS NOT NULL AND brsch NOT IN ( SELECT brsch FROM tp038m2 AS b CLIENT SPECIFIED WHERE a~mandt = b~client and a~brsch = b~brsch ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

        ENDIF.
        DO.
          FETCH NEXT CURSOR s_cursor_kna1_ac INTO TABLE lt_kna1 PACKAGE SIZE p_psize_kna1_1.
          IF sy-subrc NE 0 .
            CLOSE CURSOR s_cursor_kna1_ac.
            gv_kna1_value_mapping = 'X'.
            EXIT .
          ELSE.
            SORT lt_kna1 BY mandt kunnr .
            LOOP AT lt_kna1 INTO ls_kna1.
              ls_key-kunnr = ls_kna1-kunnr .
              ls_key-mandt = ls_kna1-mandt.
              APPEND ls_key TO lt_keys.
              MOVE-CORRESPONDING ls_kna1 TO ls_kna1_temp.
              APPEND ls_kna1 TO lt_kna1_temp.
              CLEAR ls_key.
              CLEAR ls_kna1_temp.
              CLEAR ls_kna1.
            ENDLOOP.
          ENDIF.
*    endif.

          CALL METHOD check_cust_part_of_retail_site
            EXPORTING
              it_keys         = lt_keys
              it_kna1         = lt_kna1_temp
            IMPORTING
              et_part_of_site = lt_kna1_key.



*        select distinct * from kna1 as a client specified into corresponding fields of table lt_kna1  where brsch is not null and brsch not in ( select brsch from tp038m2 as b client specified where a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
          LOOP AT lt_kna1 INTO ls_kna1.
            READ TABLE lt_kna1_key INTO ls_kna1_key WITH KEY kunnr = ls_kna1-kunnr.
            IF sy-subrc = 0.
              DELETE TABLE lt_kna1 FROM ls_kna1.
            ENDIF.
            CLEAR ls_kna1.
            CLEAR ls_kna1_key.
          ENDLOOP.

          LOOP AT lt_kna1 INTO ls_kna1 WHERE brsch IS NOT INITIAL .
            CONCATENATE ls_kna1-brsch 'Industry Not maintained in table ' 'TP038M2 in client'  ls_kna1-mandt 'kindly refer note 2210486' INTO ls_check_result-description IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT
            ls_check_result-return_code =  co_return_code-warning.
            APPEND ls_check_result TO ct_check_results.

*          clear ls_check_result.
          ENDLOOP.

          REFRESH lt_kna1.
          REFRESH lt_kna1_temp.
          REFRESH lt_kna1_key.
          REFRESH lt_keys.

          FREE: lt_kna1, lt_kna1_temp, lt_kna1_key, lt_keys.

        ENDDO.
* Outgoing Industry


        DATA : p_psize_kna1_2 TYPE integer VALUE '1000'.
        DATA : s_cursor_kna1_2 TYPE cursor.
        CLEAR s_cursor_kna1_2.
        IF s_cursor_kna1_2 IS INITIAL.
          OPEN CURSOR: s_cursor_kna1_2 FOR
*          SELECT DISTINCT * FROM kna1 AS a  CLIENT SPECIFIED
*            WHERE  brsch IS NOT NULL AND brsch NOT IN ( SELECT brsch FROM tp038m1 AS b CLIENT SPECIFIED  WHERE a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ

          SELECT DISTINCT * FROM kna1 AS a  CLIENT SPECIFIED
             WHERE  brsch IS NOT NULL AND brsch NOT IN ( SELECT brsch FROM tp038m1 AS b CLIENT SPECIFIED  WHERE a~mandt = b~client and a~brsch = b~brsch ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ

        ENDIF.

        DO.
          FETCH NEXT CURSOR s_cursor_kna1_2 INTO TABLE lt_kna1 PACKAGE SIZE p_psize_kna1_2.
          IF sy-subrc NE 0 .
            CLOSE CURSOR s_cursor_kna1_2.
*            gv_kna1_value_mapping = 'X'.
            EXIT .
          ELSE.
            SORT lt_kna1 BY mandt kunnr .
            LOOP AT lt_kna1 INTO ls_kna1.
              ls_keys_chk_value-kunnr = ls_kna1-kunnr .
              APPEND ls_keys_chk_value TO lt_keys_chk_value.
              MOVE-CORRESPONDING ls_kna1 TO ls_kna1_temp.
              APPEND ls_kna1 TO lt_kna1_temp.
              CLEAR ls_key.
              CLEAR ls_kna1_temp.
              CLEAR ls_kna1.
            ENDLOOP.
          ENDIF.


          LOOP AT lt_kna1 INTO ls_kna1.
            READ TABLE lt_kna1_key INTO ls_kna1_key WITH KEY kunnr = ls_kna1-kunnr.
            IF sy-subrc = 0.
              DELETE TABLE lt_kna1 FROM ls_kna1.
            ENDIF.
            CLEAR ls_kna1.
            CLEAR ls_kna1_key.
          ENDLOOP.

          LOOP AT lt_kna1 INTO ls_kna1 WHERE brsch IS NOT INITIAL .
            CONCATENATE ls_kna1-brsch 'Industry Not maintained in table ' 'TP038M1 in client' ls_kna1-mandt 'kindly refer note 2210486' INTO ls_check_result-description IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT
            ls_check_result-return_code =  co_return_code-warning.
            APPEND ls_check_result TO ct_check_results.

*          clear ls_check_result.
          ENDLOOP.

          REFRESH lt_kna1.
          REFRESH lt_kna1_key.
          REFRESH lt_kna1_temp.

          FREE: lt_kna1, lt_kna1_key, lt_kna1_temp.

        ENDDO.
*	d Assign Payment Cards

*        SELECT DISTINCT  * FROM vckun AS a  CLIENT SPECIFIED INTO CORRESPONDING FIELDS OF TABLE lt_payment WHERE ccins IS NOT NULL AND
*                  ccins NOT IN ( SELECT ccins FROM cvic_ccid_link AS b CLIENT SPECIFIED WHERE a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ


        SELECT DISTINCT  * FROM vckun AS a  CLIENT SPECIFIED INTO CORRESPONDING FIELDS OF TABLE lt_payment WHERE ccins IS NOT NULL AND
                  ccins NOT IN ( SELECT ccins FROM cvic_ccid_link AS b CLIENT SPECIFIED WHERE a~mandt = b~client and a~ccins = b~ccins ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ

        LOOP AT lt_payment INTO ls_payment WHERE ccins IS NOT INITIAL.

          CONCATENATE ls_payment-ccins 'payment Card type not maintained in table' 'CVIC_CCID_LINK in client' ls_payment-mandt  'kindly refer note 2210486' INTO ls_check_result-description IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT
          ls_check_result-return_code =  co_return_code-warning.
          APPEND ls_check_result TO ct_check_results.

*          clear ls_check_result.
          CLEAR ls_payment.

        ENDLOOP.

      CATCH cx_sy_open_sql_error INTO lx_open_sql_error.
        process_db_exception(
          EXPORTING
            ix_exception     = lx_open_sql_error
            iv_check_id      = 'CHK_CON_ASSIGNMENT'
          CHANGING
            ct_check_results = ct_check_results ).

    ENDTRY.





  ENDMETHOD.


METHOD check_vend_part_of_retail_site.
*=

  DATA:
    lt_werks_in         TYPE cvis_werks_t,
    lt_lfa1_temp        TYPE STANDARD TABLE OF lfa1,
    lt_retail_sites     TYPE cvis_werks_t,
    lt_candidates       TYPE vmds_vendor_plant_t,
    lt_potential_sites  TYPE vmds_vendor_plant_t,
    ls_potential_sites  TYPE vmds_vendor_plant,
    ls_vendor_number    TYPE vmds_vendor_number.

  DATA : p_psize1 TYPE integer VALUE '1000'.  " Package size
  DATA : ls_lfa1 LIKE LINE OF lt_lfa1_temp.
  DATA : ls_lfa1_new LIKE LINE OF lt_lfa1_temp.

  DATA : ls_vend_plant TYPE vmds_vendor_plant.
  DATA : lv_count TYPE i.
  DATA : lt_keys TYPE  vmds_lfa1_t ."vmds_vendor_numbers_t .
  DATA : ls_key LIKE  LINE OF lt_keys.


  FIELD-SYMBOLS:
    <ls_lfa1>          TYPE lfa1,
    <ls_vend_plant>    TYPE vmds_vendor_plant.

* first, process the table with the structure
  LOOP AT it_lfa1 ASSIGNING <ls_lfa1>
        WHERE NOT werks IS INITIAL.
* lfa1 sentences with field werks filled are possible retail sites
    INSERT <ls_lfa1>-werks INTO TABLE lt_werks_in.
    ls_potential_sites-lifnr = <ls_lfa1>-lifnr.
    ls_potential_sites-werks = <ls_lfa1>-werks.
    APPEND ls_potential_sites TO lt_potential_sites.
  ENDLOOP.

* now process the keys which are passed over
  IF NOT it_keys[] IS INITIAL.
*    CALL METHOD vmd_ei_api_check=>get_vendor_with_plant
*      EXPORTING
*        it_keys       = it_keys
*      IMPORTING
*        et_candidates = lt_candidates.

*SELECT lifnr werks FROM lfa1
*     INTO CORRESPONDING FIELDS OF TABLE et_candidates
*     FOR ALL ENTRIES IN it_keys
*                     WHERE lifnr = it_keys-lifnr
*                       AND NOT werks = space.


    CLEAR lv_count.
    LOOP AT it_keys INTO ls_key.
      APPEND ls_key TO lt_keys.
      DESCRIBE TABLE lt_keys LINES lv_count.
      IF lv_count  >= p_psize1.
        IF lt_keys IS NOT INITIAL.
*          SELECT lifnr werks FROM lfa1 CLIENT SPECIFIED INTO CORRESPONDING FIELDS OF TABLE lt_lfa1_temp  FOR ALL ENTRIES IN lt_keys WHERE lifnr = lt_keys-lifnr AND NOT werks = space.

        loop at it_lfa1 into ls_lfa1_new where not werks eq space.
        read table lt_keys with key lifnr = ls_lfa1_new-lifnr transporting no fields  .
            if sy-subrc = 0.
              append ls_lfa1_new to lt_lfa1_temp.
              clear ls_lfa1_new.
              endif.
          endloop.



        ENDIF.
        "proces your task
        LOOP AT lt_lfa1_temp INTO ls_lfa1 .
          ls_vend_plant-lifnr = ls_lfa1-lifnr.
          ls_vend_plant-werks = ls_lfa1-werks.
          APPEND ls_vend_plant TO lt_candidates.
          CLEAR ls_vend_plant.
        ENDLOOP.
        SORT lt_candidates BY lifnr werks.

        LOOP AT lt_candidates ASSIGNING <ls_vend_plant>.
          APPEND <ls_vend_plant> TO lt_potential_sites.
          INSERT <ls_vend_plant>-werks INTO TABLE lt_werks_in.
        ENDLOOP.
        REFRESH lt_candidates.
        REFRESH lt_lfa1_temp.
        REFRESH lt_keys.
        free : lt_candidates , lt_lfa1_temp , lt_keys.
      ENDIF.

    ENDLOOP.

  ENDIF.




  IF lt_keys IS NOT INITIAL.
    SELECT mandt lifnr werks FROM lfa1 as a CLIENT SPECIFIED INTO CORRESPONDING FIELDS OF TABLE lt_lfa1_temp  FOR ALL ENTRIES IN lt_keys WHERE lifnr = lt_keys-lifnr AND NOT werks = space  and a~MANDT = lt_keys-MANDT.
    "proces your task
    LOOP AT lt_lfa1_temp INTO ls_lfa1 .
      ls_vend_plant-lifnr = ls_lfa1-lifnr.
      ls_vend_plant-werks = ls_lfa1-werks.
      APPEND ls_vend_plant TO lt_candidates.
      CLEAR ls_vend_plant.
    ENDLOOP.
    SORT lt_candidates BY lifnr werks.

    LOOP AT lt_candidates ASSIGNING <ls_vend_plant>.
      APPEND <ls_vend_plant> TO lt_potential_sites.
      INSERT <ls_vend_plant>-werks INTO TABLE lt_werks_in.
    ENDLOOP.
    REFRESH lt_candidates.
    REFRESH lt_lfa1_temp.
    REFRESH lt_keys.
    free : lt_candidates , lt_lfa1_temp , lt_keys.
  ENDIF.
*commented to resolve time consuming during fetch of records.

*IF s_cursor_retail_vend IS INITIAL.
*      OPEN CURSOR: s_cursor_retail_vend FOR
*      SELECT lifnr werks FROM lfa1 CLIENT SPECIFIED
*      FOR ALL ENTRIES IN it_keys WHERE lifnr = it_keys-lifnr AND NOT werks = space. "#EC CI_NOWHERE "#EC CI_BUFFSUB endif. "mandt kunnr ktokd
*    ENDIF.
*    DO.
*      FETCH NEXT CURSOR s_cursor_retail_vend INTO TABLE lt_lfa1_temp PACKAGE SIZE p_psize1.
*      IF sy-subrc NE 0 .
*        CLOSE CURSOR s_cursor_retail_vend.
*        gv_retail_vend = 'X'.
*        EXIT .
*      ELSE.
*
*        loop at lt_lfa1_temp into ls_lfa1 .
*          ls_vend_plant-lifnr = ls_lfa1-lifnr.
*          ls_vend_plant-werks = ls_lfa1-werks.
*          append ls_vend_plant to lt_candidates.
*          clear ls_vend_plant.
*        endloop.
*        SORT lt_candidates BY lifnr werks.
*      ENDIF.
*     LOOP AT lt_candidates ASSIGNING <ls_vend_plant>.
*       APPEND <ls_vend_plant> TO lt_potential_sites.
*       INSERT <ls_vend_plant>-werks INTO TABLE lt_werks_in.
*     ENDLOOP.
*      refresh lt_candidates.
*      refresh lt_lfa1_temp.
*    ENDDO.
* ENDIF.
*   End of comment

  IF NOT lt_werks_in[] IS INITIAL.
* get the retail sites
*    CALL METHOD cvi_ei_api=>filter_out_retail_plants
*      EXPORTING
*        it_werks       = lt_werks_in
*      IMPORTING
*        et_retail_part = lt_retail_sites.

    SELECT werks FROM t001w
       CLIENT SPECIFIED
       INTO TABLE lt_retail_sites
       FOR ALL ENTRIES IN lt_werks_in
       WHERE werks = lt_werks_in-table_line
                 AND NOT vlfkz = space.

  ENDIF.

* Table lt_retail_sites picks up every vendor which is part of
* a retail site.
* If lt_retail_sites is empty ==> no vendor is part of a retail site.
  CHECK NOT lt_retail_sites[] IS INITIAL.

  IF     NOT it_keys[] IS INITIAL
     AND NOT it_lfa1[] IS INITIAL.
* if both input tables are used for determine the potential sites, it
* should be checked if there are duplicates found.
    SORT lt_potential_sites BY lifnr werks.
    DELETE ADJACENT DUPLICATES FROM lt_potential_sites.
  ENDIF.

  LOOP AT lt_potential_sites ASSIGNING <ls_vend_plant>.
    READ TABLE lt_retail_sites
           WITH TABLE KEY table_line = <ls_vend_plant>-werks
           TRANSPORTING NO FIELDS.

    IF sy-subrc = 0.
* vendor is part of a retail site
      ls_vendor_number-lifnr = <ls_vend_plant>-lifnr.
      INSERT ls_vendor_number INTO TABLE et_part_of_site.
    ENDIF.
  ENDLOOP.

ENDMETHOD.


  METHOD check_vend_value_mapping.
    DATA : lt_lfa1 TYPE STANDARD TABLE OF lfa1.
    DATA : ls_lfa1 LIKE LINE OF lt_lfa1.
    DATA : lt_tp038m2  TYPE STANDARD TABLE OF tp038m2 .
    DATA : ls_tp038m2  LIKE LINE OF lt_tp038m2 .
    DATA : ls_check_result LIKE LINE OF ct_check_results.
    DATA :lx_open_sql_error TYPE REF TO cx_sy_open_sql_error.

    ls_check_result-software_component    = 'SAP_APPL'.
    ls_check_result-check_id              = 'CHK_VEND_MAP'.
    ls_check_result-application_component = 'LO-MD-BP'.
    ls_check_result-description           = 'CHK_VEND_MAP - Vendor Value mapping'.



    DATA : lt_keys_vend TYPE  vmds_lfa1_t."vmds_vendor_numbers_t .
    DATA : ls_key_vend LIKE LINE OF lt_keys_vend.
    DATA : lt_lfa1_temp TYPE vmds_lfa1_t.
    DATA : ls_lfa1_temp LIKE LINE OF lt_lfa1_temp.
    DATA : lt_lfa1_key  TYPE vmds_vendor_numbers_s_t.
    DATA : ls_lfa1_key LIKE LINE OF lt_lfa1_key.



*    select * from lfa1 client specified into corresponding fields of table lt_lfa1.
*    sort lt_lfa1 by mandt lifnr.
*    loop at lt_lfa1 into ls_lfa1.
*      ls_key_vend-lifnr = ls_lfa1-kunnr .
*      append ls_key_vend to lt_keys_vend.
*      move-corresponding ls_lfa1 to ls_lfa1_temp.
*      append ls_lfa1 to lt_lfa1_temp.
*      clear ls_key_vend.
*      clear ls_lfa1_temp.
*      clear ls_lfa1.
*    endloop.

    DATA : p_psize_lfa1 TYPE integer VALUE '1000'.  " Package size
*  DATA : s_cursor_lfa1_vend_map TYPE cursor.

*if gv_lfa1_vend_mapping is not initial.

    TRY.
        IF s_cursor_lfa1_vend_map IS INITIAL.
          OPEN CURSOR: s_cursor_lfa1_vend_map FOR
*          SELECT * FROM lfa1 AS a CLIENT SPECIFIED  WHERE  brsch IS NOT NULL AND brsch NOT IN ( SELECT brsch FROM tp038m2 AS b CLIENT SPECIFIED WHERE a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

          SELECT mandt lifnr brsch FROM lfa1 AS a CLIENT SPECIFIED  WHERE  brsch IS NOT NULL AND brsch NOT IN ( SELECT brsch FROM tp038m2 AS b CLIENT SPECIFIED WHERE a~mandt = b~client and a~brsch = b~brsch ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

        ENDIF.
        DO.
          FETCH NEXT CURSOR s_cursor_lfa1_vend_map INTO CORRESPONDING FIELDS OF TABLE  lt_lfa1 PACKAGE SIZE p_psize_lfa1.
          IF sy-subrc NE 0 .
            CLOSE CURSOR s_cursor_lfa1_vend_map.
            gv_lfa1_vend_mapping = 'X'.
            EXIT .
          ELSE.
            SORT lt_lfa1 BY mandt lifnr .

            LOOP AT lt_lfa1 INTO ls_lfa1.
              ls_key_vend-mandt = ls_lfa1-mandt .
              ls_key_vend-lifnr = ls_lfa1-lifnr .
              APPEND ls_key_vend TO lt_keys_vend.
              MOVE-CORRESPONDING ls_lfa1 TO ls_lfa1_temp.
              APPEND ls_lfa1 TO lt_lfa1_temp.
              CLEAR ls_key_vend.
              CLEAR ls_lfa1_temp.
              CLEAR ls_lfa1.
            ENDLOOP.

          ENDIF.
*  endif.

          CALL METHOD check_vend_part_of_retail_site
            EXPORTING
              it_keys         = lt_keys_vend
              it_lfa1         = lt_lfa1_temp
            IMPORTING
              et_part_of_site = lt_lfa1_key.


*      Incoming industry


          LOOP AT lt_lfa1 INTO ls_lfa1.
            READ TABLE lt_lfa1_key INTO ls_lfa1_key WITH KEY lifnr = ls_lfa1-lifnr.
            IF sy-subrc = 0.
              DELETE TABLE lt_lfa1 FROM ls_lfa1.
            ENDIF.
            CLEAR ls_lfa1.
            CLEAR ls_lfa1_key.
          ENDLOOP.

          LOOP AT  lt_lfa1  INTO ls_lfa1 WHERE brsch IS NOT INITIAL.
            CONCATENATE ls_lfa1-brsch 'Industry not maintained in table' 'TP038M2 in client' ls_lfa1-mandt  'kindly refer note 2210486' INTO ls_check_result-description IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT
            ls_check_result-return_code =  co_return_code-warning.
            APPEND ls_check_result TO ct_check_results.
*          clear ls_check_result.
          ENDLOOP.

          REFRESH lt_lfa1.
          REFRESH lt_lfa1_key.
          REFRESH lt_lfa1_temp.
          REFRESH lt_keys_vend.

          FREE: lt_lfa1, lt_lfa1_key, lt_lfa1_temp, lt_keys_vend.

        ENDDO.






*     outgoing Industry

        CLEAR s_cursor_lfa1.
        DATA : p_psize_lfa1_1.

        IF s_cursor_lfa1 IS INITIAL.
          OPEN CURSOR: s_cursor_lfa1 FOR
*           SELECT * FROM lfa1 AS a CLIENT SPECIFIED WHERE  brsch IS NOT NULL AND brsch NOT IN ( SELECT brsch FROM tp038m1 AS b CLIENT SPECIFIED WHERE  a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

          SELECT  mandt lifnr brsch FROM lfa1 AS a CLIENT SPECIFIED WHERE  brsch IS NOT NULL AND brsch NOT IN ( SELECT brsch FROM tp038m1 AS b CLIENT SPECIFIED WHERE  a~mandt = b~client and a~brsch = b~brsch ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

        ENDIF.
        DO.
          FETCH NEXT CURSOR s_cursor_lfa1 INTO CORRESPONDING FIELDS OF TABLE  lt_lfa1 PACKAGE SIZE p_psize_lfa1_1.
          IF sy-subrc NE 0 .
            CLOSE CURSOR s_cursor_lfa1.
            gv_lfa1_vend_mapping = 'X'.
            EXIT .
          ELSE.
            SORT lt_lfa1 BY mandt lifnr .

            LOOP AT lt_lfa1 INTO ls_lfa1.
              ls_key_vend-mandt = ls_lfa1-mandt.
              ls_key_vend-lifnr = ls_lfa1-lifnr .
              APPEND ls_key_vend TO lt_keys_vend.
              MOVE-CORRESPONDING ls_lfa1 TO ls_lfa1_temp.
              APPEND ls_lfa1 TO lt_lfa1_temp.
              CLEAR ls_key_vend.
              CLEAR ls_lfa1_temp.
              CLEAR ls_lfa1.
            ENDLOOP.

          ENDIF.
*  endif.

          CALL METHOD check_vend_part_of_retail_site
            EXPORTING
              it_keys         = lt_keys_vend
              it_lfa1         = lt_lfa1_temp
            IMPORTING
              et_part_of_site = lt_lfa1_key.





*            SELECT * FROM lfa1 AS a CLIENT SPECIFIED INTO CORRESPONDING FIELDS OF TABLE lt_lfa1  WHERE  brsch IS NOT NULL AND brsch NOT IN ( SELECT brsch FROM tp038m1 AS b CLIENT SPECIFIED WHERE  a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
          LOOP AT lt_lfa1 INTO ls_lfa1.
            READ TABLE lt_lfa1_key INTO ls_lfa1_key WITH KEY lifnr = ls_lfa1-lifnr.
            IF sy-subrc = 0.
              DELETE TABLE lt_lfa1 FROM ls_lfa1.
            ENDIF.
            CLEAR ls_lfa1.
            CLEAR ls_lfa1_key.
          ENDLOOP.

          LOOP AT  lt_lfa1  INTO ls_lfa1 WHERE brsch IS NOT INITIAL.
            CONCATENATE ls_lfa1-brsch 'Industry not maintained in table' 'TP038M1 in client'  'kindly refer note 2210486' ls_lfa1-mandt INTO ls_check_result-description IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT
            ls_check_result-return_code =  co_return_code-warning.
            APPEND ls_check_result TO ct_check_results.
*          clear ls_check_result.
          ENDLOOP.
          REFRESH lt_lfa1.
          REFRESH lt_lfa1_temp.
          REFRESH lt_lfa1_key.
          REFRESH lt_keys_vend.

          FREE: lt_lfa1, lt_lfa1_temp, lt_lfa1_key, lt_keys_vend.

        ENDDO.

      CATCH cx_sy_open_sql_error INTO lx_open_sql_error.
        process_db_exception(
          EXPORTING
            ix_exception     = lx_open_sql_error
            iv_check_id      = 'CHK_VEND_MAP'
          CHANGING
            ct_check_results = ct_check_results ).
    ENDTRY.

    CLEAR : ls_lfa1,
        ls_tp038m2,
        ls_check_result,
        lx_open_sql_error,
        ls_key_vend,
        ls_lfa1_temp,
        ls_lfa1_key.

    REFRESH : lt_lfa1,
              lt_tp038m2,
              lt_keys_vend,
              lt_lfa1_temp,
              lt_lfa1_key.

    FREE: lt_lfa1,
              lt_tp038m2,
              lt_keys_vend,
              lt_lfa1_temp,
              lt_lfa1_key.

  ENDMETHOD.


method GET_MINIMUM_TARGET_RELEASE.
        CLEAR et_release_info.

    DATA ls_sw_component TYPE ty_sw_component.              "#EC NEEDED
    DATA ls_release_info TYPE ty_release_info.
    LOOP AT it_sw_components INTO ls_sw_component WHERE sw_component = 'SAP_APPL'.
      ls_release_info-sw_component  = 'S4CORE'.
      ls_release_info-sw_component_release = '100'.
      ls_release_info-sw_component_sp = '0000'.
      APPEND ls_release_info TO et_release_info   .
    ENDLOOP.
  endmethod.


method get_preprocessing_check_result.
  data: lt_check_results type tt_preprocessing_check_results.
  data : ls_check_result like line of lt_check_results.

  refresh: et_check_results.

   gv_kna1 = ''.
   gv_lfa1 = ''.
   gv_kna1_cvi_mapping = ''.
   gv_lfa1_cvi_mapping = ''.
   gv_kna1_ac_bprole = ''.
   gv_lfa1_ac_bprole = ''.
   gv_lfa1_vend_mapping = ''.
   gv_kna1_value_mapping = ''.
   gv_retail = ''.
   gv_retail_vend = ''.



  call method check_bp_role_ac
    changing
      ct_check_results = lt_check_results.

  if lt_check_results is not initial.
    read table lt_check_results into ls_check_result index 1.
    if sy-subrc = 0.
      concatenate 'Some of the customer or vendor account groups are not maintained' ' kindly refer note 2210486' into ls_check_result-description separated by space.
      append ls_check_result to et_check_results.
    endif.
  endif.

  refresh lt_check_results.

  call method check_ac_bprole
    changing
      ct_check_results = lt_check_results.

  if lt_check_results is not initial.
    read table lt_check_results into ls_check_result index 1.
    if sy-subrc = 0.
      concatenate 'Some of the customer or vendor account groups are not assigned to any roles' ' kindly refer note 2210486' into ls_check_result-description separated by space.
      append ls_check_result to et_check_results.
    endif.
  endif.

  refresh lt_check_results.

  call method check_cvi_mapping
    changing
      ct_check_results = lt_check_results.

  if lt_check_results is not initial.
    read table lt_check_results into ls_check_result index 1.
    if sy-subrc = 0.
      concatenate 'Some of the customer or vendor numbers are not mapped ' 'kindly refer note 2210486' into ls_check_result-description separated by space.
      append ls_check_result to et_check_results.
    endif.
  endif.

  refresh lt_check_results.


  call method check_value_mapping
    changing
      ct_check_results = lt_check_results.
  if lt_check_results is not initial.
    read table lt_check_results into ls_check_result index 1.
    if sy-subrc = 0.
      concatenate 'Some of the customer value mapping is not maintained' 'kindly refer note 2210486' into ls_check_result-description separated by space.

      append ls_check_result to et_check_results.
    endif.
  endif.

  refresh lt_check_results.

  call method check_vend_value_mapping
    changing
      ct_check_results = lt_check_results.

  if lt_check_results is not initial.
    read table lt_check_results into ls_check_result index 1.
    if sy-subrc = 0.
      concatenate 'Some of the vendor value mapping is not maintained' 'kindly refer note 2210486' into ls_check_result-description separated by space.
      append ls_check_result to et_check_results.
    endif.
  endif.

  refresh lt_check_results.
  call method check_contact_person_mapping
    changing
      ct_check_results = lt_check_results.

  if lt_check_results is not initial.
    read table lt_check_results into ls_check_result index 1.
    if sy-subrc = 0.
      concatenate 'Some of the customers are not having contact person mapping' 'kindly refer note 2210486' into ls_check_result-description separated by space.
      append ls_check_result to et_check_results.
    endif.
  endif.
  refresh lt_check_results.

  call method check_post_value_mapping
    changing
      ct_check_results = lt_check_results.
  read table lt_check_results into ls_check_result index 1.
  if sy-subrc = 0.
    concatenate 'Some of the post value mapping for customer and vendor are not maintained ' 'kindly refer note 2210486' into ls_check_result-description separated by space.
    append ls_check_result to et_check_results.
  endif.

*if gv_kna1 = 'X' and
*   gv_lfa1 = 'X' and
*   gv_kna1_cvi_mapping = 'X' and
*   gv_lfa1_cvi_mapping = 'X' and
*   gv_kna1_ac_bprole = 'X' and
*   gv_lfa1_ac_bprole = 'X' and
*   gv_lfa1_vend_mapping = 'X' and
*   gv_kna1_value_mapping = 'X'.
*  EXIT.
*endif.

* gv_pack + 1000.



*close cursor : S_CURSOR,
*S_CURSOR_LFA1,
*S_CURSOR_KNA1_AC,
*S_CURSOR_LFA1_AC,
*S_CURSOR_KNA1_MAPPING,
*S_CURSOR_LFA1_MAPPING,
*S_CURSOR_KNA1_VAL_MAP,
*S_CURSOR_LFA1_VEND_MAP.

sort et_check_results by SOFTWARE_COMPONENT check_id  description return_code application_component.
delete ADJACENT DUPLICATES FROM    et_check_results COMPARING SOFTWARE_COMPONENT check_id  description return_code application_component.

endmethod.


method GET_RESULTS.
  REFRESH: et_check_results.

  CALL METHOD check_bp_role_ac
    CHANGING
      ct_check_results = et_check_results.

  CALL METHOD check_ac_bprole
    CHANGING
      ct_check_results = et_check_results.

  CALL METHOD check_cvi_mapping
    CHANGING
      ct_check_results = et_check_results.


  CALL METHOD check_value_mapping
    CHANGING
      ct_check_results = et_check_results.

  CALL METHOD check_vend_value_mapping
    CHANGING
      ct_check_results = et_check_results.

  CALL METHOD check_contact_person_mapping
    CHANGING
      ct_check_results = et_check_results.
  CALL METHOD check_post_value_mapping
    CHANGING
      ct_check_results = et_check_results.



sort et_check_results by check_id  description.
delete ADJACENT DUPLICATES FROM    et_check_results COMPARING check_id  description.
endmethod.


method GET_SUPPORTED_SW_COMPONENTS.
 data: ls_sw_component type ty_sw_component.

    refresh: et_sw_components.

    ls_sw_component-sw_component = co_supported_sw_components-sap_appl.
    append ls_sw_component to et_sw_components.

  endmethod.


method IS_SW_COMPONENT_USED.

    clear: ev_is_used.

    if iv_sw_component = co_supported_sw_components-sap_appl.

        ev_is_used = 'X'.

    else.

        ev_is_used = SPACE.

    endif.

  endmethod.


  method PROCESS_DB_EXCEPTION.
        DATA ls_check_result TYPE ty_preprocessing_check_result.
    ls_check_result-software_component    = 'SAP_APPL'.
    ls_check_result-check_id              = iv_check_id.
    ls_check_result-application_component = 'LO-MD-BP'.

    ls_check_result-description = ix_exception->get_text( ).
    CONCATENATE `Error during database access: ` ls_check_result-description INTO ls_check_result-description IN CHARACTER MODE. "#EC NOTEXT
    ls_check_result-return_code =  co_return_code-error.
    APPEND ls_check_result TO ct_check_results.
  endmethod.
ENDCLASS.
