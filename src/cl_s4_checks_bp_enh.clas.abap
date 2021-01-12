class CL_S4_CHECKS_BP_ENH definition
  public
  final
  create public .

public section.

  types:
    BEGIN OF ts_nriv_res.
        INCLUDE TYPE nriv.
    TYPES src_fromnr TYPE nriv-fromnumber.
    TYPES src_tonr TYPE nriv-tonumber.
    TYPES depd_object TYPE nriv-object.
    TYPES depd_nr TYPE nriv-nrrangenr.
    TYPES depd_fromnr TYPE nriv-fromnumber.
    TYPES depd_tonr TYPE nriv-tonumber.
    TYPES depd_nrlevel TYPE nrlevel.
    TYPES percent TYPE p12_perc.
    types nr_new type xflag.
    TYPES  END OF ts_nriv_res .
  types:
    tt_nriv_res TYPE TABLE OF ts_nriv_res .
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
    BEGIN OF account_gp,
        ac_gp(60) TYPE c,
*         bp_gp     type bu_group,
*         s_no(1)   type c,
      END OF account_gp .
  types:
    BEGIN OF taxtype,
        tax_type(4) TYPE c,
      END OF taxtype .
  types:
    tt_account_gp TYPE STANDARD TABLE OF account_gp .
  types:
    tt_taxtype TYPE STANDARD TABLE OF taxtype .
  types:
    BEGIN OF partner,
    partner TYPE bu_partner,
    RLTYP TYPE BU_PARTNERROLE,
    END OF partner .
  types:
    tt_partner TYPE STANDARD TABLE OF partner .
  types:
    BEGIN OF department,
        dept(6) TYPE c,

*         desc(20)   type c,
*         dept_check type c,
      END OF department .
  types:
    tt_department TYPE STANDARD TABLE OF department .
  types:
    BEGIN OF function,
        fn(4) TYPE c,
      END OF function .
  types:
    BEGIN OF authority,
        auth(1) TYPE c,
      END OF authority .
  types:
    BEGIN OF vip,
        vip_in(1) TYPE c,
      END OF vip .
  types:
    BEGIN OF marital,
        mstat(1) TYPE c,
      END OF marital .
  types:
    BEGIN OF legal,
        legal(2) TYPE c,
      END OF legal .
  types:
    BEGIN OF payment,
        pcard(4) TYPE c,
      END OF payment .
  types:
    BEGIN OF cp,
        cp_assign(1) TYPE c,
*    TYPES :color_line(4) TYPE c,          " Line color
*           color_cell    TYPE lvc_t_scol, " Cell color
    END of cp .
  types:
    BEGIN OF industry,
        indkey(4) TYPE c,
      END OF industry .
  types:
    tt_function TYPE STANDARD TABLE OF function .
  types:
    tt_authority TYPE STANDARD TABLE OF authority .
  types:
    tt_vip TYPE STANDARD TABLE OF vip .
  types:
    tt_marital TYPE STANDARD TABLE OF marital .
  types:
    tt_legal TYPE STANDARD TABLE OF legal .
  types:
    tt_payment TYPE STANDARD TABLE OF payment .
  types:
    tt_cp_assign TYPE STANDARD TABLE OF cp .
  types:
    tt_industry TYPE STANDARD TABLE OF industry .
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
  types:
    BEGIN OF abtnr_st,
        abtnr(4) TYPE c,
*        TYPES :color_line(4) TYPE c,          " Line color
*           color_cell    TYPE lvc_t_scol,
      END OF abtnr_st .
  types:
    BEGIN OF pafkt_st,
        pafkt(4) TYPE c,
      END OF pafkt_st .
  types:
    BEGIN OF bu_paauth_st,
        bu_paauth(1) TYPE c,
      END OF bu_paauth_st .
  types:
    BEGIN OF pavip_st,
        pavip(1) TYPE c,
      END OF pavip_st .
  types:
    BEGIN OF bu_marst_st,
        bu_marst(1) TYPE c,
      END OF bu_marst_st .
  types:
    BEGIN OF bu_legenty_st,
        bu_legenty(2) TYPE c,
      END OF bu_legenty_st .
  types:
    BEGIN OF ccins_st,
        ccins(4) TYPE c,
      END OF ccins_st .
  types:
    tt_tb910 TYPE STANDARD TABLE OF abtnr_st .
  types:
    tt_tb912 TYPE STANDARD TABLE OF pafkt_st .
  types:
    tt_tb914 TYPE STANDARD TABLE OF bu_paauth_st .
  types:
    tt_tb916 TYPE STANDARD TABLE OF pavip_st .
  types:
    tt_tb027 TYPE STANDARD TABLE OF bu_marst_st .
  types:
    tt_tb019 TYPE STANDARD TABLE OF bu_legenty_st .
  types:
    tt_tb033 TYPE STANDARD TABLE OF ccins_st .
  types:
    BEGIN OF gs_tb038a,
        istype     TYPE bu_istype,
        ind_sector TYPE bu_ind_sector,
      END OF gs_tb038a .
  types:
    tt_tb038a TYPE STANDARD TABLE OF gs_tb038a .

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
  class-data S_CURSOR_LFBK type CURSOR .
  class-data S_CURSOR_RETAIL type CURSOR .
  class-data GV_RETAIL type C .
  class-data S_CURSOR_RETAIL_VEND type CURSOR .
  class-data GV_RETAIL_VEND type C .
  class-data GV_SITE type CHAR1 .

  class-methods CHECK_TAX_CATEGORY
    exporting
      !CT_TAXTYPE type TT_TAXTYPE
    changing
      !CT_CHECK_RESULTS type TT_PREPROCESSING_CHECK_RESULTS .
  class-methods GET_SUPPORTED_SW_COMPONENTS
    exporting
      !ET_SW_COMPONENTS type TT_SW_COMPONENTS .
  class-methods IS_SW_COMPONENT_USED
    importing
      !IV_SW_COMPONENT type DLVUNIT
    exporting
      !EV_IS_USED type ABAP_BOOL .
  class-methods GET_MINIMUM_TARGET_RELEASE
    importing
      !IT_SW_COMPONENTS type TT_SW_COMPONENTS
    exporting
      !ET_RELEASE_INFO type TT_RELEASE_INFO .
  class-methods GET_PREPROCESSING_CHECK_RESULT
    importing
      !IT_SW_COMPONENTS type TT_SW_COMPONENTS
    exporting
      !ET_CHECK_RESULTS type TT_PREPROCESSING_CHECK_RESULTS .
  class-methods GET_RESULTS
    exporting
      !ET_CHECK_RESULTS type TT_PREPROCESSING_CHECK_RESULTS .
  class-methods CHECK_AC_BPROLE
    importing
      !IV_FLAG type C optional
      !IV_NO type I optional
    exporting
      !CT_ACCOUNT_GP type TT_ACCOUNT_GP
    changing
      !CT_CHECK_RESULTS type TT_PREPROCESSING_CHECK_RESULTS .
  class-methods CHECK_BP_ROLE_AC
    importing
      !IV_FLAG type C optional
      !IV_NO type I optional
    exporting
      !CT_ACCOUNT_GP type TT_ACCOUNT_GP
    changing
      !CT_CHECK_RESULTS type TT_PREPROCESSING_CHECK_RESULTS .
  class-methods CHECK_VALUE_MAPPING
    importing
      !IV_NO type I optional
    exporting
      !CT_DEPARTMENT type TT_DEPARTMENT
      !CT_FUNCTION type TT_FUNCTION
      !CT_AUTHORITY type TT_AUTHORITY
      !CT_PCARD type TT_PAYMENT
      !CT_MARITAL type TT_MARITAL
      !CT_VIP type TT_VIP
      !CT_LEGAL type TT_LEGAL
      !CT_CP_ASSIGN type TT_CP_ASSIGN
      !CT_INDUSTRY_IN type TT_INDUSTRY
      !CT_INDUSTRY_OUT type TT_INDUSTRY
    changing
      !CT_CHECK_RESULTS type TT_PREPROCESSING_CHECK_RESULTS .
  class-methods CHECK_POST_VALUE_MAPPING
    importing
      !IV_FLAG type C optional
    exporting
      !CT_TB910 type TT_TB910
      !CT_TB912 type TT_TB912
      !CT_TB914 type TT_TB914
      !CT_TB916 type TT_TB916
      !CT_TB027 type TT_TB027
      !CT_TB019 type TT_TB019
      !CT_TB038A type TT_TB038A
      !CT_TB033 type TT_TB033
      !CT_TB038A_OUT type TT_TB038A
    changing
      !CT_CHECK_RESULTS type TT_PREPROCESSING_CHECK_RESULTS .
  class-methods CHECK_VEND_VALUE_MAPPING
    importing
      !IV_NO type I optional
    exporting
      !CT_INDUSTRY_IN type TT_INDUSTRY
      !CT_INDUSTRY_OUT type TT_INDUSTRY
    changing
      !CT_CHECK_RESULTS type TT_PREPROCESSING_CHECK_RESULTS .
  class-methods CHECK_CVI_MAPPING
    importing
      !IV_CUST_FROM type KUNNR optional
      !IV_CUST_TO type KUNNR optional
      !IV_VEND_FROM type LIFNR optional
      !IV_VEND_TO type LIFNR optional
      !IV_NO type I optional
    exporting
      !ET_CUST type KNA1_KEY_T
      !ET_VEND type LFA1_KEY_T
    changing
      !CT_CHECK_RESULTS type TT_PREPROCESSING_CHECK_RESULTS .
  class-methods CHECK_CONTACT_PERSON_MAPPING
    importing
      !IV_NO type I optional
    exporting
      !ET_CUST_CONT type KNA1_KEY_T
      !ET_VEND_CONT type LFA1_KEY_T
    changing
      !CT_CHECK_RESULTS type TT_PREPROCESSING_CHECK_RESULTS .
  class-methods CHECK_CUSTOMER
    exporting
      !ET1_KNA1 type CVIS_KNA1_T
      !ET1_KNBK type KNBK_T
      !ET1_KNA1_IND type CVIS_KNA1_T
    changing
      !C_CHANGE type FLAG .
  class-methods CHECK_SUPPLIER
    exporting
      !ET_LFA1 type CVIS_LFA1_T
      !ET_LFBK type LFBK_T
      !ET_LFA1_IND type CVIS_LFA1_T
    changing
      !C_CHANGE_1 type FLAG optional .
  class-methods GET_BPS_WITH_UNSUPP_ROLES
    exporting
      !ET_PARTNERS type TT_PARTNER
    changing
      !CT_CHECK_RESULTS type TT_PREPROCESSING_CHECK_RESULTS optional .
  class-methods GET_ALL_CVI_NRIV_FILTER
    importing
      !IV_BP_IND type XFLAG
      !IV_REV_IND type XFLAG
    exporting
      !ET_SRC_ALPHA_NRIV type NRIV_TT
      !ET_DPD_ALPHA_NRIV type NRIV_TT
      !ET_SRC_NRIV type NRIV_TT
      !ET_DPD_NRIV type NRIV_TT
    exceptions
      WRONG_NRIV_FORMAT .
  class-methods COMPARE_NRIV
    importing
      !IV_ACT_IND type XFLAG
      !IT_SOURCE_NRIV type NRIV_TT
      !IT_DEPENDENT_NRIV type NRIV_TT
    exporting
      !ET_OVERLAPPING_NRIV type TT_NRIV_RES
      !ET_NO_OVERLAPPING_NRIV type TT_NRIV_RES .
  class-methods DETERMINE_NEW_NRIV
    importing
      !IV_ACT_IND type XFLAG
      !IV_ALPHA_IND type XFLAG optional
      !IT_OVERLAPPING_NRIV type TT_NRIV_RES
      !IT_NO_OVERLAPPING_NRIV type TT_NRIV_RES
    changing
      !CV_NR_FACTOR type P12_PERC optional
      !CT_NEW_NRIV type TT_NRIV_RES
    exceptions
      INVALID_NUMBER
      EXCEEDS_NUMBER
      WRONG_START_LIMIT .
  class-methods COMP_DETM_ALPHA_NEW_CMN_NRIV
    importing
      !IT_NEW_REQU_NRIV type NRIV_TT
      !IV_BP_IND type XFLAG
    exporting
      !ET_NEW_CMN_NRIV type NRIV_TT
    exceptions
      INVALID_NR .
  class-methods COMPARE_DETM_NEW_CMN_NRIV
    importing
      !IT_NEW_REQU_NRIV type NRIV_TT
      !IV_BP_IND type XFLAG
    exporting
      !ET_NEW_CMN_NRIV type NRIV_TT
    exceptions
      INVALID_NR .
  class-methods COMPARE_ALPHA_NRIV
    importing
      !IV_ACT_IND type XFLAG
      !IT_SOURCE_NRIV type NRIV_TT
      !IT_DEPENDENT_NRIV type NRIV_TT
    exporting
      !ET_NUM_INTV type TT_NRIV_RES
      !ET_OVERLAPPING_NRIV type TT_NRIV_RES
      !ET_NO_OVERLAPPING_NRIV type TT_NRIV_RES
      !ET_NUM_ALPHA_INTV type TT_NRIV_RES
    exceptions
      INVALID_NR_FORMAT .
  class-methods CONVERT_NUM_TOALPHA_NRIV
    importing
      !IT_NUMBER_NRIV type TT_NRIV_RES
    exporting
      !ET_ALPHA_NRIV type TT_NRIV_RES
    exceptions
      INTERVAL_NOT_FOUND .
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
  types:
    BEGIN OF ty_alpha,
        code1 TYPE char1,
        code2 TYPE num2,
      END OF ty_alpha .
  types:
    tt_alpha TYPE STANDARD TABLE OF ty_alpha .
  types:
    BEGIN OF ty_cvi_nriv ,
             id      TYPE i,
             cvi_sub TYPE nriv_tt,
             alpha_cvi_sub type nriv_tt,
           END OF ty_cvi_nriv .
  types:
    tt_cvi_nriv type TABLE OF ty_cvi_nriv .

  class-data ACT_OBJECT type TNRO-OBJECT .
  constants:
    begin of co_supported_sw_components,
        sap_appl type dlvunit value 'SAP_APPL_LO_MD_BP',
      end   of co_supported_sw_components .
  class-data GV_PACKAGE_SIZE type I .
  class-data GT_TABLES type TT_TABLE .
  class-data GV_MSEG_TABLE_NAME type TABNAME .
  class-data BNRIV type BNRIV .
  class-data GT_ALPHA type TT_ALPHA .
  class-data LOCAL type C value 'L' ##NO_TEXT.
  class-data PROCESS type C value 'P' ##NO_TEXT.
  class-data SHADOW type C value 'S' ##NO_TEXT.
  class-data GS_TNRO type TNRO .
  class-data:
    GC_CHARNUM(36) type C value '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ' ##NO_TEXT.

  class-methods PROCESS_DB_EXCEPTION
    importing
      !IX_EXCEPTION type ref to CX_SY_OPEN_SQL_ERROR
      !IV_CHECK_ID type TY_PREPROCESSING_CHECK_RESULT-CHECK_ID
    changing
      !CT_CHECK_RESULTS type TT_PREPROCESSING_CHECK_RESULTS .
  class-methods CHECK_CUST_PART_OF_RETAIL_SITE
    importing
      !IT_KEYS type CMDS_CUSTOMER_NUMBERS_T optional
      !IT_KNA1 type CMDS_KNA1_T optional
    exporting
      !ET_PART_OF_SITE type CMDS_CUSTOMER_NUMBERS_S_T .
  class-methods GET_CUST_SUPP_DETAILS
    importing
      !IV_NO type I
      !IV_FLAG type CHAR1
    exporting
      !ET_KNA1 type CVIS_KNA1_T
      !ET_LFA1 type CVIS_LFA1_T
      !ET_KNBK type KNBK_KEY_T
      !ET_LFBK type LFBK_KEY_T .
  class-methods CHECK_VEND_PART_OF_RETAIL_SITE
    importing
      !IT_KEYS type VMDS_VENDOR_NUMBERS_T optional
      !IT_LFA1 type VMDS_LFA1_T optional
    exporting
      !ET_PART_OF_SITE type VMDS_VENDOR_NUMBERS_S_T .
  class-methods SELECT_TNRO
    importing
      !IV_OBJECT type INRI-OBJECT
    exceptions
      OBJECT_NOT_FOUND .
  class-methods CHECK_NRIV
    importing
      !IV_RANGE_NR type INRI-NRRANGENR
      !IV_FROMNUMBER type NUMC10
      !IV_TONUMBER type NUMC10
      !IV_OBJECT type INRI-OBJECT
      !IV_ACTTONUM type CHAR1
      !IV_EXT_NRIV type CHAR1 optional
      !IV_SRC_FROMNUMBER type CHAR20 optional
      !IV_SRC_TONUMBER type CHAR20 optional
      !IV_SRC_NRLEVEL type NRLEVEL
    exporting
      !EV_OVERLPERCENT type P12_PERC
      !EV_RETURN type INRI-RETURNCODE
    exceptions
      INTERVAL_NOT_FOUND .
  class-methods CALC_NUMERIC_NEW_NRIV
    importing
      !IV_NR_FACTOR type P12_PERC
      !IV_DELTA type NRLEVEL optional
      !IS_ACT_NR type TS_NRIV_RES
      !IS_NEXT_NR type TS_NRIV_RES
    changing
      !CS_NEW_NR type TS_NRIV_RES
    exceptions
      EXCEEDS_NUMBER .
  class-methods CALC_NEW_NRIV
    importing
      !IV_ACT_IND type XFLAG
      !IV_NR_FACTOR type P12_PERC
      !IS_ACT_NR type TS_NRIV_RES
      !IV_ALPHA_IND type XFLAG
      !IS_NEXT_NR type TS_NRIV_RES
      !IS_OV_NR type TS_NRIV_RES
    changing
      !CS_NEW_NR type TS_NRIV_RES
    exceptions
      EXCEEDS_NUMBER .
  class-methods CHECK_DETM_RANGE
    exporting
      !ET_ALPHA_NRIV type NRIV_TT
    changing
      !CT_NRIV type NRIV_TT
    exceptions
      WRONG_NRIV_FORMAT .
  class-methods CONVERT_NUM_TOALPHA
    importing
      !IV_NUMERIC type CHAR20
    changing
      !CV_ALPHA type CHAR20
    exceptions
      INVALID_NUMBER
      OVERFLOW .
  class-methods CONVERT_ALPHA_TONUM
    importing
      !IV_ALPHA type CHAR20
      !IT_ALPHA type TT_ALPHA
    changing
      !CV_NUMERIC type NRLEVEL .
  class-methods CALC_BASE36_2DIGIT
    importing
      !IT_ALPHA type TT_ALPHA
      !IV_ALPHA_IND type CHAR1
    exporting
      !CV_NEW type NUM2 .
  class-methods CALC_ALPHA_NEW_NRIV
    importing
      !IV_NR_FACTOR type P12_PERC
      !IS_ACT_NR type TS_NRIV_RES
      !IS_NEXT_NR type TS_NRIV_RES
      !IV_DELTA type NRLEVEL
    changing
      !CS_NEW_NR type TS_NRIV_RES
    exceptions
      EXCEEDS_NUMBER .
  class-methods CHECK_ALPHA_NRIV
    importing
      !IV_DEPD_FROMNUMBER type NRLEVEL
      !IV_SOURCE_FROMNUMBER type NRLEVEL
      !IV_DEPD_TONUMBER type NRLEVEL
      !IV_SOURCE_TONUMBER type NRLEVEL
    exporting
      !EV_OVERLPERCENT type P12_PERC
      !EV_RETURN type INRI-RETURNCODE
    exceptions
      INTERVAL_NOT_FOUND .
  class-methods CONVERT_ALPHA_TONUM_NRIV
    importing
      !IT_ALPHA_NRIV type NRIV_TT
    exporting
      !ET_NUMBER_NRIV type TT_NRIV_RES
    exceptions
      INVALID_NR_FORMAT .
  class-methods GET_ALL_CVI_NRIV
    importing
      !IV_BP_IND type XFLAG
      !IV_NUM_IND type XFLAG optional
    exporting
      !ET_CVI_NRIV type TT_CVI_NRIV
    exceptions
      WRONG_NRIV_FORMAT .
ENDCLASS.



CLASS CL_S4_CHECKS_BP_ENH IMPLEMENTATION.


  METHOD calc_alpha_new_nriv.

    DATA:
      lv_fromnumber TYPE  nrlevel,
      lv_tonumber   TYPE  nrlevel,
      lv_char       TYPE char20.

    lv_fromnumber = is_act_nr-tonumber + 1.
    lv_char =   lv_fromnumber.

    CL_S4_CHECKS_BP_ENH=>convert_num_toalpha(
          EXPORTING    iv_numeric     = lv_char
          CHANGING     cv_alpha       = lv_char
          EXCEPTIONS  invalid_number = 1 OTHERS         = 2 ).
    IF sy-subrc <> 0.
      RAISE exceeds_number.
    ENDIF.

*Determine next alpha start number
    IF lv_char(1) CO '0123456789'.
      lv_char(1) = 'A'.

      CL_S4_CHECKS_BP_ENH=>convert_alpha_tonum(
       EXPORTING
         iv_alpha   =  lv_char
         it_alpha   = gt_alpha
       CHANGING
         cv_numeric = lv_fromnumber ).
    ENDIF.

*    lv_tonumber = is_act_nr-tonumber  +  ( ( iv_delta ) * iv_nr_factor ).

    lv_tonumber = lv_fromnumber  +  ( ( iv_delta + 1 ) * iv_nr_factor ).

    lv_char =   lv_tonumber.

    CL_S4_CHECKS_BP_ENH=>convert_num_toalpha(
          EXPORTING    iv_numeric     = lv_char
          CHANGING     cv_alpha       = lv_char
          EXCEPTIONS  invalid_number = 1 OTHERS         = 2 ).
    IF sy-subrc <> 0.
      RAISE exceeds_number.
    ENDIF.

*Determine next alpha start number
    IF lv_char(1) CO '0123456789'.
      lv_char(1) = 'A'.

      CL_S4_CHECKS_BP_ENH=>convert_alpha_tonum(
       EXPORTING
         iv_alpha   =  lv_char
         it_alpha   = gt_alpha
       CHANGING
         cv_numeric = lv_tonumber ).
*     else.
*         if lv_char(1) >=
*    ENDIF.
    ENDIF.

    IF lv_tonumber > 3656158440062975.
      RAISE exceeds_number.
    ENDIF.



    IF is_next_nr IS NOT INITIAL.
      IF  lv_tonumber > is_act_nr-tonumber  AND  lv_fromnumber > is_act_nr-fromnumber
        AND lv_tonumber  <  is_next_nr-tonumber AND  lv_fromnumber <  is_next_nr-fromnumber.
        MOVE lv_fromnumber TO cs_new_nr-fromnumber.
        MOVE lv_tonumber TO cs_new_nr-tonumber.
      ELSE.
        CLEAR cs_new_nr.
      ENDIF.
    ELSE.
      MOVE lv_fromnumber TO cs_new_nr-fromnumber.
      MOVE lv_tonumber TO cs_new_nr-tonumber.
    ENDIF.

  ENDMETHOD.


  METHOD CALC_BASE36_2DIGIT.

    DATA: ls_alpha LIKE LINE OF it_alpha.

*read the mapping table and get the 2 digit code.
    READ TABLE it_alpha INTO ls_alpha WITH KEY code1 = iv_alpha_ind .
    IF sy-subrc = 0.
      IF ls_alpha-code2 < 10.
        cv_new = ls_alpha-code2+1(1).
      ELSE.
        cv_new = ls_alpha-code2.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD calc_new_nriv.


    DATA: lv_delta            TYPE nrlevel.

    IF iv_act_ind = abap_true.
      IF is_ov_nr-depd_nrlevel > 0.
        lv_delta =  is_ov_nr-depd_nrlevel -  is_ov_nr-depd_fromnr.
      ELSE.
        lv_delta = 1.
      ENDIF.
    ELSE.
      lv_delta =  is_ov_nr-depd_tonr -  is_ov_nr-depd_fromnr.
    ENDIF.


    IF iv_alpha_ind = abap_false.
      CL_S4_CHECKS_BP_ENH=>calc_numeric_new_nriv(   EXPORTING  iv_nr_factor = iv_nr_factor iv_delta = lv_delta is_act_nr   = is_act_nr is_next_nr = is_next_nr
          CHANGING  cs_new_nr = cs_new_nr
          EXCEPTIONS  exceeds_number  = 1   OTHERS          = 2 ).

    ELSE.
      CL_S4_CHECKS_BP_ENH=>calc_alpha_new_nriv(
         EXPORTING  iv_nr_factor = iv_nr_factor iv_delta = lv_delta is_act_nr   = is_act_nr is_next_nr = is_next_nr
         CHANGING cs_new_nr = cs_new_nr
         EXCEPTIONS   exceeds_number   = 1 OTHERS          = 2 ).
    ENDIF.

    IF sy-subrc <> 0.
      RAISE exceeds_number.
    ENDIF.

  ENDMETHOD.


  METHOD calc_numeric_new_nriv.

    DATA:
      lv_fromnumber   TYPE  numc10,
      lv_tonumber20   TYPE  nrlevel,
      lv_tonumber     TYPE  numc10.

    lv_fromnumber = is_act_nr-tonumber + 1.
    lv_tonumber20 = is_act_nr-tonumber +  ( ( iv_delta + 1 ) * iv_nr_factor ).
*    lv_tonumber20 = is_act_nr-tonumber +  ( ( iv_delta ) * iv_nr_factor ).

    IF lv_tonumber20 > 9999999999.
      RAISE exceeds_number.
    ELSE.
      lv_tonumber =   lv_tonumber20.
    ENDIF.
    IF is_next_nr IS NOT INITIAL.
      IF  lv_tonumber > is_act_nr-tonumber  AND  lv_fromnumber > is_act_nr-fromnumber
        AND lv_tonumber  <  is_next_nr-tonumber AND  lv_fromnumber <  is_next_nr-fromnumber.
        MOVE lv_fromnumber TO cs_new_nr-fromnumber.
        MOVE lv_tonumber TO cs_new_nr-tonumber.
      ELSE.
        CLEAR cs_new_nr.
      ENDIF.
    ELSE.
      MOVE lv_fromnumber TO cs_new_nr-fromnumber.
      MOVE lv_tonumber TO cs_new_nr-tonumber.
    ENDIF.

  ENDMETHOD.


method check_ac_bprole.
  data : ls_table like line of gt_tables.
  data : lt_kna1 type standard table of kna1.
  data : ls_kna1 like line of lt_kna1.
  data : lt_cviv_cust_to_bp1 type standard table of cvic_cust_to_bp1.
  data : ls_cviv_cust like line of  lt_cviv_cust_to_bp1 .
  data : lt_cviv_vend_to_bp1 type standard table of cvic_vend_to_bp1.
  data : ls_cviv_vend_to_bp1 like line of lt_cviv_vend_to_bp1 .
  data : ls_check_result type ty_preprocessing_check_result.
  data : lt_lfa1 type standard table of lfa1.
  data : ls_lfa1 like line of lt_lfa1.
  data : lx_open_sql_error type ref to cx_sy_open_sql_error .
  ls_check_result-software_component    = 'SAP_APPL'.
  ls_check_result-check_id              = 'CHK_BP_AC'.
  ls_check_result-application_component = 'LO-MD-BP'.
  ls_check_result-description = 'CHK_BP_AC - Every account group a BP Grouping must be available'.


  data : lt_keys type  cmds_customer_numbers_t .
  data : ls_key like line of lt_keys.
  data : lt_kna1_temp type cmds_kna1_t.
  data : ls_kna1_temp like line of lt_kna1_temp.
  data : lt_kna1_key  type cmds_customer_numbers_s_t.
  data : ls_kna1_key like line of lt_kna1_key.

  data : lt_keys_vend type  vmds_vendor_numbers_t .
  data : ls_key_vend like line of lt_keys_vend.
  data : lt_lfa1_temp type vmds_lfa1_t.
  data : ls_lfa1_temp like line of lt_lfa1_temp.
  data : lt_lfa1_key  type vmds_vendor_numbers_s_t.
  data : ls_lfa1_key like line of lt_lfa1_key.

  data: ls_account_gp like line of ct_account_gp.

  data : p_psize type integer value '1000'.  " Package size

  try.
      if s_cursor_kna1_ac is initial.
        IF  iv_no IS INITIAL.
          OPEN CURSOR: s_cursor_kna1_ac FOR  SELECT DISTINCT * FROM kna1
                  WHERE ktokd IS NOT NULL AND ktokd NOT IN ( SELECT account_group FROM  cvic_cust_to_bp1    ). "#EC CI_NOFIELD #EC CI_NOWHERE "#EC CI_BUFFSUBQ. " mandt kunnr ktokd  client specified where a~mandt = b~client
        ELSE.
          OPEN CURSOR: s_cursor_kna1_ac FOR  SELECT DISTINCT * FROM kna1 UP TO iv_no ROWS
                  WHERE ktokd IS NOT NULL AND ktokd NOT IN ( SELECT account_group FROM  cvic_cust_to_bp1    ). "#EC CI_NOFIELD #EC CI_NOWHERE "#EC CI_BUFFSUBQ. " mandt kunnr ktokd  client specified where a~mandt = b~client
        ENDIF.
      endif.

      do.
        fetch next cursor s_cursor_kna1_ac into table lt_kna1 package size p_psize.
        if sy-subrc ne 0 .
          close cursor s_cursor_kna1_ac.
          gv_kna1_ac_bprole = 'X'.
          exit .
        else.
          sort lt_kna1 by mandt kunnr .
          loop at lt_kna1 into ls_kna1.
            ls_key-kunnr = ls_kna1-kunnr .
            append ls_key to lt_keys.
            move-corresponding ls_kna1 to ls_kna1_temp.
            append ls_kna1 to lt_kna1_temp.
            clear ls_key.
            clear ls_kna1_temp.
            clear ls_kna1.
          endloop.
        endif.
*   endif.

        call method check_cust_part_of_retail_site
          exporting
            it_keys         = lt_keys
            it_kna1         = lt_kna1_temp
          importing
            et_part_of_site = lt_kna1_key.



        SORT lt_kna1 BY ktokd mandt.
        DELETE ADJACENT DUPLICATES FROM lt_kna1 COMPARING ktokd mandt.
        IF gv_site IS  INITIAL.
        loop at lt_kna1 into ls_kna1.
          read table lt_kna1_key into ls_kna1_key with key kunnr = ls_kna1-kunnr.
          if sy-subrc = 0.
            delete table lt_kna1 from ls_kna1.
          endif.
          clear ls_kna1.
          clear ls_kna1_key.
        endloop.

        ELSE.
          lt_kna1 = lt_kna1_key.
        ENDIF.



        loop at lt_kna1 into ls_kna1 where ktokd is not initial.
          concatenate ls_kna1-ktokd  'Customer account group is not maintained in table' 'CVIC_CUST_TO_BP1 in client' ls_kna1-mandt ' kindly refer note 2210486'   into ls_check_result-description in character mode separated by space. "#EC NOTEXT
          ls_check_result-return_code =  co_return_code-warning.
          append ls_check_result to ct_check_results.
*          clear ls_check_result.
          if iv_flag = 'c'.
            ls_account_gp-ac_gp = ls_kna1-ktokd.
            append ls_account_gp to ct_account_gp.
          endif.
        endloop.
        refresh lt_kna1.
        refresh lt_kna1_temp.
        refresh lt_kna1_key.
        refresh lt_keys.


      enddo.



      data : p_psize_lfa1 type integer value '1000'.  " Package size


      if s_cursor_lfa1_ac is initial.
        IF iv_no IS INITIAL.
          OPEN CURSOR: s_cursor_lfa1_ac FOR  SELECT DISTINCT * FROM lfa1
                                 WHERE  ktokk IS NOT NULL  AND ktokk NOT IN ( SELECT account_group FROM  cvic_vend_to_bp1  ). "#EC CI_NOFIELD #EC CI_NOWHERE "#EC CI_BUFFSUBQ.
        ELSE.
          OPEN CURSOR: s_cursor_lfa1_ac FOR  SELECT DISTINCT * FROM lfa1 UP TO iv_no ROWS
                               WHERE  ktokk IS NOT NULL  AND ktokk NOT IN ( SELECT account_group FROM  cvic_vend_to_bp1  ). "#EC CI_NOFIELD #EC CI_NOWHERE "#EC CI_BUFFSUBQ.

        ENDIF.
      ENDIF.
      do.
        fetch next cursor s_cursor_lfa1_ac into table lt_lfa1 package size p_psize_lfa1.
        if sy-subrc ne 0 .
          close cursor s_cursor_lfa1_ac.
          gv_lfa1_ac_bprole = 'X'.
          exit .
        else.
          sort lt_lfa1 by mandt lifnr .
          loop at lt_lfa1 into ls_lfa1.
            ls_key_vend-lifnr = ls_lfa1-lifnr .
            append ls_key_vend to lt_keys_vend.
            move-corresponding ls_lfa1 to ls_lfa1_temp.
            append ls_lfa1 to lt_lfa1_temp.
            clear ls_key_vend.
            clear ls_lfa1_temp.
            clear ls_lfa1.
          endloop.
        endif.
*  endif.



        call method check_vend_part_of_retail_site
          exporting
            it_keys         = lt_keys_vend
            it_lfa1         = lt_lfa1_temp
          importing
            et_part_of_site = lt_lfa1_key.


*        refresh lt_lfa1_temp.
*        refresh lt_lfa1.



        sort lt_lfa1 by ktokk mandt.
        delete adjacent duplicates from lt_lfa1 comparing ktokk mandt.

        IF gv_site IS INITIAL.
        loop at lt_lfa1 into ls_lfa1.
          read table lt_lfa1_key into ls_lfa1_key with key lifnr = ls_lfa1-lifnr.
          if sy-subrc = 0.
            delete table lt_lfa1 from ls_lfa1.
          endif.
          clear ls_lfa1.
          clear ls_lfa1_key.
        endloop.
        ELSE.
          lt_lfa1 = lt_lfa1_key.
        ENDIF.

        loop at lt_lfa1 into ls_lfa1 where ktokk is not initial.
*          if sy-subrc <> 0.
            concatenate ls_lfa1-ktokk  'Vendor account group is not maintained in table' 'CVIC_VEND_TO_BP1' ls_lfa1-mandt 'kindly refer note 2210486'   into ls_check_result-description in character mode separated by space. "#EC NOTEXT
            ls_check_result-return_code =  co_return_code-warning.
            append ls_check_result to ct_check_results.
*            clear ls_check_result.
            if iv_flag = 'v'.
              ls_account_gp-ac_gp = ls_lfa1-ktokk.
              append ls_account_gp to ct_account_gp.
            endif.
*          endif.

        endloop.

        refresh lt_lfa1.
        refresh lt_lfa1_temp.
        refresh lt_lfa1_key.
        refresh lt_keys_vend.

      enddo.



    catch cx_sy_open_sql_error into lx_open_sql_error.
      process_db_exception(
        exporting
          ix_exception     = lx_open_sql_error
          iv_check_id      = 'CHK_BP_AC'
        changing
          ct_check_results = ct_check_results ).
  endtry.

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

endmethod.


  METHOD check_alpha_nriv.


    DATA: lv_nriv_fromnumber TYPE nrlevel,
          lv_fromnumber      TYPE nrlevel,
          lv_tonumber        TYPE nrlevel,
          lv_delta           TYPE nrlevel.


** data for numeric check
*    DATA: c_num_with_blank(11) TYPE c VALUE '0123456789 ',
*          c_num(10)            TYPE c VALUE '0123456789',
*          length_fromnr(2)     TYPE n,
*          length_tonr(2)       TYPE n.

*    FIELD-SYMBOLS: <from> TYPE any,
*                   <to>   TYPE any.
*------ Overlapping check -  four use cases
*  1.   |----------| (Source)
*  1.1 |------------|
*  2.  |----------| (Source)
*  2.1       |-------|
* 3.       |----------| (Source)
* 3.1    |------|
*4.    |-----------| (Source)
* 4.1    |------|
    IF iv_depd_fromnumber <= iv_source_fromnumber  AND
           iv_depd_tonumber >=   iv_source_tonumber OR
              iv_depd_fromnumber >= iv_source_fromnumber
        AND iv_depd_fromnumber <= iv_source_tonumber OR
        iv_depd_tonumber >= iv_source_fromnumber
        AND iv_depd_tonumber <= iv_source_tonumber.

* Change border
      IF iv_depd_fromnumber < iv_source_fromnumber.
        lv_fromnumber = iv_source_fromnumber.
      ELSE.
        lv_fromnumber = iv_depd_fromnumber.
      ENDIF.

      IF iv_depd_tonumber > iv_source_tonumber.
        lv_tonumber = iv_source_tonumber.
      ELSE.
        lv_tonumber = iv_depd_tonumber.
      ENDIF.

*    IF  iv_source_fromnumber <= iv_depd_fromnumber  and
*         iv_source_tonumber >=   iv_depd_tonumber or
*        iv_source_fromnumber >= iv_depd_fromnumber
*      AND iv_source_fromnumber <= iv_depd_tonumber OR
*      iv_source_tonumber >= iv_depd_fromnumber
*      AND iv_source_tonumber <= iv_depd_tonumber.
**Change border
*      IF iv_source_fromnumber < lv_nriv_fromnumber.
*        lv_fromnumber = lv_nriv_fromnumber.
*      ELSE.
*        lv_fromnumber = iv_source_fromnumber.
*      ENDIF.
*
*
*      IF iv_source_tonumber > iv_depd_tonumber.
*        lv_tonumber = iv_depd_tonumber.
*      ELSE.
*        lv_tonumber = iv_source_tonumber.
*      ENDIF.

      lv_delta = abs( lv_tonumber - lv_fromnumber  ).
      ev_overlpercent = ( lv_delta / abs( iv_source_tonumber - iv_source_fromnumber  ) ) * 100 .

*   NUMBER inside range
      ev_return = space.
    ELSE.
*   NUMBER outside range
      ev_return = 'X'.
    ENDIF.
  ENDMETHOD.


METHOD CHECK_BP_ROLE_AC.
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



  DATA : lt_keys TYPE  cmds_customer_numbers_t .
  DATA : ls_key LIKE LINE OF lt_keys.
  DATA : lt_kna1_temp TYPE cmds_kna1_t.
  DATA : ls_kna1_temp LIKE LINE OF lt_kna1_temp.
  DATA : lt_kna1_key  TYPE cmds_customer_numbers_s_t.
  DATA : ls_kna1_key LIKE LINE OF lt_kna1_key.

  DATA : lt_keys_vend TYPE  vmds_vendor_numbers_t .
  DATA : ls_key_vend LIKE LINE OF lt_keys_vend.
  DATA : lt_lfa1_temp TYPE vmds_lfa1_t.
  DATA : ls_lfa1_temp LIKE LINE OF lt_lfa1_temp.
  DATA : lt_lfa1_key  TYPE vmds_vendor_numbers_s_t.
  DATA : ls_lfa1_key LIKE LINE OF lt_lfa1_key.

*  DATA: ct_account_gp type table of account_gp.
  data: ls_account_gp like line of ct_account_gp.

  DATA : p_psize TYPE integer VALUE '1000'.  " Package size
  TRY.

      IF s_cursor IS INITIAL.
*        OPEN CURSOR: s_cursor FOR SELECT DISTINCT * FROM kna1 AS a CLIENT SPECIFIED
*            WHERE ktokd IS NOT NULL AND ktokd NOT IN ( SELECT  account_group  FROM cvic_cust_to_bp2 AS b
*            CLIENT SPECIFIED WHERE a~mandt = b~client  ). "#EC CI_NOWHERE "#EC CI_BUFFSUB endif. "mandt kunnr ktokd
         if iv_no is INITIAL.
         OPEN CURSOR: s_cursor FOR SELECT DISTINCT * FROM kna1
            WHERE ktokd IS NOT NULL
           AND ktokd NOT IN ( SELECT  account_group  FROM cvic_cust_to_bp2  ). "#EC CI_NOFIELD #EC CI_NOWHERE "#EC CI_BUFFSUBQ.
        else.
            OPEN CURSOR: s_cursor FOR SELECT DISTINCT * FROM kna1 UP TO iv_no ROWS
            WHERE ktokd IS NOT NULL
           AND ktokd NOT IN ( SELECT  account_group  FROM cvic_cust_to_bp2  ). "#EC CI_NOFIELD #EC CI_NOWHERE "#EC CI_BUFFSUBQ.
        endif.

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

 if gv_site is INITIAL.
        LOOP AT lt_kna1 INTO ls_kna1.
          READ TABLE lt_kna1_key INTO ls_kna1_key WITH KEY kunnr = ls_kna1-kunnr.
          IF sy-subrc = 0 .
            DELETE TABLE lt_kna1 FROM ls_kna1.
          ENDIF.
          CLEAR ls_kna1.
          CLEAR ls_kna1_key.
        ENDLOOP.

  else.
    lt_kna1 = lt_kna1_key.
  endif.

        LOOP AT lt_kna1 INTO ls_kna1 WHERE ktokd IS NOT INITIAL.
          CONCATENATE ls_kna1-ktokd  'Customer Account group is not maintained in table' 'CVIC_CUST_TO_BP2 in client' ls_kna1-mandt  'kindly refer note 2210486'    INTO ls_check_result-description IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT
          ls_check_result-return_code =  co_return_code-warning.
          APPEND ls_check_result TO ct_check_results.
          if iv_flag = 'c'.
            ls_account_gp-ac_gp = ls_kna1-ktokd.
            append ls_account_gp to ct_account_gp.
          endif.
        ENDLOOP.

        REFRESH lt_kna1.
        REFRESH lt_kna1_temp.
        REFRESH lt_kna1_key.
        REFRESH lt_keys.


      ENDDO.


      DATA : p_psize_lfa1 TYPE integer VALUE '1000'.  " Package size

      IF s_cursor_lfa1 IS INITIAL.
*        OPEN CURSOR: s_cursor_lfa1 FOR SELECT DISTINCT * FROM lfa1 AS a CLIENT SPECIFIED
*         WHERE ktokk IS NOT NULL  AND ktokk  NOT IN ( SELECT  account_group  FROM cvic_vend_to_bp2 AS b CLIENT SPECIFIED  WHERE a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ. " mandt lifnr ktokk
       if iv_no is INITIAL.
       OPEN CURSOR: s_cursor_lfa1 FOR SELECT DISTINCT * FROM lfa1
         WHERE ktokk IS NOT NULL
         AND ktokk  NOT IN ( SELECT  account_group  FROM cvic_vend_to_bp2  ). "#EC CI_NOFIELD #EC CI_NOWHERE "#EC CI_BUFFSUBQ. " mandt lifnr ktokk CLIENT SPECIFIED  WHERE a~mandt = b~client
       else.
         OPEN CURSOR: s_cursor_lfa1 FOR SELECT DISTINCT * FROM lfa1 UP TO iv_no ROWS
         WHERE ktokk IS NOT NULL
         AND ktokk  NOT IN ( SELECT  account_group  FROM cvic_vend_to_bp2  ). "#EC CI_NOFIELD #EC CI_NOWHERE "#EC CI_BUFFSUBQ. " mandt lifnr ktokk CLIENT SPECIFIED  WHERE a~mandt = b~client

         endif.
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
if gv_site is INITIAL.

        LOOP AT lt_lfa1 INTO ls_lfa1.
          READ TABLE lt_lfa1_key INTO ls_lfa1_key WITH KEY lifnr = ls_lfa1-lifnr.
          IF sy-subrc = 0.
            DELETE TABLE lt_lfa1 FROM ls_lfa1.
          ENDIF.
          CLEAR ls_lfa1.
          CLEAR ls_lfa1_key.
        ENDLOOP.

else.
  lt_lfa1 = lt_lfa1_key.
endif.

        LOOP AT lt_lfa1 INTO ls_lfa1 WHERE ktokk IS NOT INITIAL.
          CONCATENATE ls_lfa1-ktokk  'Vendor Account Group is not maintained in table' 'CVIC_VEND_TO_BP2 in client' ls_lfa1-mandt 'kindly refer note 2210486'   INTO ls_check_result-description IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT
          ls_check_result-return_code =  co_return_code-warning.
          APPEND ls_check_result TO ct_check_results.
          if iv_flag = 'v'.
            ls_account_gp-ac_gp = ls_lfa1-ktokk.
            append ls_account_gp to ct_account_gp.
          endif.
        ENDLOOP.


        REFRESH lt_lfa1.
        REFRESH lt_lfa1_temp.
        REFRESH lt_lfa1_key.
        REFRESH lt_keys_vend.


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


ENDMETHOD.


  METHOD CHECK_CONTACT_PERSON_MAPPING.
    DATA : lt_knvk TYPE STANDARD TABLE OF knvk.
    DATA : ls_knvk LIKE LINE OF lt_knvk.
    DATA : lt_lfa1 TYPE STANDARD TABLE OF lfa1.
    DATA : ls_lfa1 LIKE LINE OF lt_lfa1.
    DATA : lt_cust_link TYPE STANDARD TABLE OF cvi_cust_link.
    DATA : ls_cust_link LIKE LINE OF lt_cust_link.
    DATA : lt_vend_link TYPE STANDARD TABLE OF cvi_vend_link.
    DATA : ls_vend_link LIKE LINE OF lt_vend_link.
    DATA : ls_check_result LIKE LINE OF ct_check_results.
    DATA :lx_open_sql_error TYPE REF TO cx_sy_open_sql_error.
    DATA : table_name TYPE tabname.
    DATA : lv_status TYPE as4local.
    DATA : lv_subrc TYPE sy-subrc .
    DATA : ls_kna1_key type KNA1_KEY_S.
    DATA : ls_lfa1_key type lfa1_key_s.


    ls_check_result-software_component    = 'SAP_APPL'.
    ls_check_result-check_id              = 'CHK_CONT_MAP'.
    ls_check_result-application_component = 'LO-MD-BP'.
    ls_check_result-description           = 'CHK_CONT_MAP - Check for contact person mapping'.

    TRY.

        table_name = 'CVI_CUST_CT_LINK' .

        CALL FUNCTION 'DD_EXIST_TABLE'
          EXPORTING
            tabname      = table_name
            status       = 'M'
          IMPORTING
            subrc        = lv_subrc
          EXCEPTIONS
            wrong_status = 1
            OTHERS       = 2.
        IF sy-subrc <> 0.
* Implement suitable error handling here
        ENDIF.
        IF lv_subrc = 0.

          DATA : s_cursor_knvk4 TYPE cursor.
          DATA : p_psize_knvk4 TYPE integer VALUE '1000'.

          IF s_cursor_knvk4 IS INITIAL.
            if iv_no is INITIAL.
           OPEN CURSOR : s_cursor_knvk4  FOR   SELECT * FROM knvk AS a  WHERE kunnr NE ' ' AND parnr NOT IN ( SELECT customer_cont FROM (table_name) AS b  WHERE  a~parnr = b~customer_cont  ). "#EC CI_NOFIELD #EC CI_NOWHERE "#EC CI_BUFFSUBQ.
            ELSE.
              OPEN CURSOR : s_cursor_knvk4  FOR   SELECT * FROM knvk AS a UP TO iv_no ROWS WHERE kunnr NE ' ' AND parnr
              NOT IN ( SELECT customer_cont FROM (table_name) AS b  WHERE  a~parnr = b~customer_cont  ). "#EC CI_NOFIELD #EC CI_NOWHERE "#EC CI_BUFFSUBQ.
            endif.
          ENDIF.


          DO.
          FETCH NEXT CURSOR  s_cursor_knvk4  INTO TABLE lt_knvk PACKAGE SIZE p_psize_knvk4.
            IF sy-subrc NE 0.
              CLOSE CURSOR s_cursor_knvk4.
              EXIT .
            ELSE.

              LOOP AT lt_knvk INTO ls_knvk WHERE kunnr IS NOT INITIAL .
                CONCATENATE ls_knvk-parnr 'is not mainatined in table'  'CVI_CUST_CT_LINK in client' ls_knvk-mandt  ' kindly refer note 2210486'   INTO ls_check_result-description IN CHARACTER MODE. "#EC NOTEXT
                ls_check_result-return_code =  co_return_code-abortion.
                APPEND ls_check_result TO ct_check_results.
                move ls_knvk-kunnr to  ls_kna1_key-kunnr .
                append ls_kna1_key to et_cust_cont.
                clear ls_kna1_key.

*            clear ls_check_result.
              ENDLOOP.
              sort et_cust_cont by kunnr.
              delete ADJACENT DUPLICATES FROM et_cust_cont.
            ENDIF.
            REFRESH lt_knvk.

          ENDDO.

        ENDIF.


        CLEAR table_name.

        table_name = 'CVI_VEND_CT_LINK' .
        CALL FUNCTION 'DD_EXIST_TABLE'
          EXPORTING
            tabname      = table_name
            status       = 'M'
          IMPORTING
            subrc        = lv_subrc
          EXCEPTIONS
            wrong_status = 1
            OTHERS       = 2.
        IF sy-subrc <> 0.
* Implement suitable error handling here
        ENDIF.
        IF lv_subrc = 0.
          DATA : s_cursor_knvk5 TYPE cursor.
          DATA : p_psize_knvk5 TYPE integer VALUE '1000'.

          IF s_cursor_knvk5 IS INITIAL.
            if iv_no is INITIAL.
            OPEN CURSOR : s_cursor_knvk5  FOR   SELECT * FROM knvk AS a
                                                WHERE lifnr NE ' ' AND parnr NOT IN ( SELECT vendor_cont FROM (table_name) AS b WHERE a~parnr = b~vendor_cont  ). "#EC CI_NOFIELD #EC CI_NOWHERE "#EC CI_BUFFSUBQ.
           else.
           OPEN CURSOR : s_cursor_knvk5  FOR   SELECT * FROM knvk AS a UP TO iv_no ROWS
                                                WHERE lifnr NE ' ' AND parnr NOT IN ( SELECT vendor_cont FROM (table_name) AS b WHERE a~parnr = b~vendor_cont  ). "#EC CI_NOFIELD #EC CI_NOWHERE "#EC CI_BUFFSUBQ.

           endif.
          ENDIF.


          DO.
           FETCH NEXT CURSOR  s_cursor_knvk5  INTO TABLE lt_knvk PACKAGE SIZE p_psize_knvk5.
            IF sy-subrc NE 0.
              CLOSE CURSOR s_cursor_knvk5.
              EXIT .
            ELSE.

              LOOP AT lt_knvk INTO ls_knvk WHERE lifnr IS NOT INITIAL.
                CONCATENATE ls_knvk-parnr 'is not mainatined in table'  'CVI_VEND_CT_LINK in client'  ls_knvk-mandt  ' kindly refer note 2210486' INTO ls_check_result-description IN CHARACTER MODE. "#EC NOTEXT
                ls_check_result-return_code =  co_return_code-abortion.
                APPEND ls_check_result TO ct_check_results.
               move ls_knvk-lifnr to  ls_lfa1_key-lifnr.
                append ls_lfa1_key to et_vend_cont.
                clear ls_lfa1_key.
*            clear ls_check_result.
              ENDLOOP.
              sort et_vend_cont by lifnr.
              delete ADJACENT DUPLICATES FROM et_vend_cont.
            ENDIF.
            REFRESH lt_knvk.

          ENDDO.


        ENDIF.
      CATCH cx_sy_open_sql_error INTO lx_open_sql_error.
        process_db_exception(
          EXPORTING
            ix_exception     = lx_open_sql_error
            iv_check_id      = 'CHK_CONT_MAP'
          CHANGING
            ct_check_results = ct_check_results ).
    ENDTRY.
  ENDMETHOD.


method check_customer.
*  DATA: lt_knbk type STANDARD TABLE OF knbk,
*        lt1_knbk type STANDARD TABLE OF knbk,
*      ls_knbk like LINE OF lt_knbk,
*      lt_kna1 type STANDARD TABLE OF kna1,
*      lt1_kna1 type STANDARD TABLE OF kna1,
*      ls_kna1 like LINE OF lt_kna1.

  data: lt_knbk type knbk_key_t,
      lt1_knbk type knbk_key_t,
    ls_knbk like line of lt_knbk,
    lt_kna1 type cvis_kna1_t,
    lt1_kna1 type cvis_kna1_t,
    lt1_kna1_ind type cvis_kna1_t,
    ls_kna1 like line of lt_kna1.

  data: lt_lfa1 type  cvis_lfa1_t,
        lt1_lfa1 type lfa1_key_t,
        ls_lfa1 like line of lt_lfa1,
        lt_lfbk type lfbk_key_t,
        lt1_lfbk type cmds_knbk_t,
        ls_lfbk like line of  lt_lfbk.

  data: iv_no type i.
  data: cl_ref type ref to cl_s4_checks_bp_enh.

  refresh lt_knbk.
*refresh lt1_knbk.
  refresh lt_kna1.
  refresh lt_lfbk.
*refresh lt1_lfbk.
  refresh lt_lfa1.
  clear: ls_kna1, ls_lfa1,ls_knbk,ls_lfbk.

*SELECT * FROM KNA1 INTO TABLE LT_KNA1 where KUNNR <> ' '.
*SELECT * FROM LFA1 INTO TABLE LT_LFA1 where LIFNR <> ' '.
*select * from KNBK into table lt_knbk where kunnr <> ' '.
*select * from LFBK into table lt_lfbk where lifnr <> ' '.
*************************
  create object cl_ref.
  cl_ref->get_cust_supp_details( exporting iv_flag = 'C' iv_no = iv_no importing et_kna1 = lt_kna1 et_lfa1 = lt_lfa1 et_knbk = lt_knbk et_lfbk = lt_lfbk ).
***********************
  sort lt_kna1 by kunnr.

  loop at lt_kna1 into ls_kna1.
    read table lt_lfa1 into ls_lfa1 with key lifnr = ls_kna1-lifnr.
    if sy-subrc = 0.
      if ls_kna1-stcd1 ne ls_lfa1-stcd1 or ls_kna1-stcd2 ne ls_lfa1-stcd2 or ls_kna1-stkzu ne ls_lfa1-stkzu or ls_kna1-stceg ne ls_lfa1-stceg.
        append ls_kna1 to lt1_kna1.
        c_change = 'X'.
      endif.
      if ls_kna1-brsch ne ls_lfa1-brsch
        or ls_kna1-bbbnr ne ls_lfa1-bbbnr or ls_kna1-bbsnr ne ls_lfa1-bbsnr or ls_kna1-bubkz ne ls_lfa1-bubkz or ls_kna1-vbund ne ls_lfa1-vbund.
        append ls_kna1 to lt1_kna1_ind.
        c_change = 'X'.
      endif.
    endif.
  endloop.
  et1_kna1 = lt1_kna1.
  et1_kna1_ind = lt1_kna1_ind.
  sort lt_knbk by kunnr.
  loop at lt_kna1 into ls_kna1.
    read table lt_knbk into ls_knbk with key kunnr = ls_kna1-kunnr.
    if sy-subrc eq 0.
      read table lt_lfbk into ls_lfbk with key lifnr = ls_kna1-lifnr.
      if sy-subrc eq 0.
        if ls_knbk-banks ne ls_lfbk-banks or ls_knbk-bankl ne ls_lfbk-bankl or ls_knbk-bankn ne ls_lfbk-bankn.
          append ls_knbk to lt1_knbk.
          c_change = 'X'.
        endif.
      endif.
    endif.
  endloop.
  et1_knbk = lt1_knbk.

endmethod.


METHOD CHECK_CUST_PART_OF_RETAIL_SITE.

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
  DATA : lt_keys TYPE cmds_customer_numbers_t.
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
      ENDIF.

    ENDLOOP.

  ENDIF.




  IF lt_keys IS NOT INITIAL.
    SELECT kunnr werks FROM kna1 CLIENT SPECIFIED INTO CORRESPONDING FIELDS OF TABLE lt_kna1_temp  FOR ALL ENTRIES IN lt_keys WHERE kunnr = lt_keys-kunnr AND NOT werks = space. "#EC CI_NOFIRST
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


  METHOD CHECK_CVI_MAPPING.
    DATA : lt_kna1 TYPE STANDARD TABLE OF kna1.
    DATA : ls_kna1 LIKE LINE OF lt_kna1.
    DATA : lt_lfa1 TYPE STANDARD TABLE OF lfa1.
    DATA : ls_lfa1 LIKE LINE OF lt_lfa1.
    DATA : lt_cust_link TYPE STANDARD TABLE OF cvi_cust_link.
    DATA : ls_cust_link LIKE LINE OF lt_cust_link.
    DATA : lt_vend_link TYPE STANDARD TABLE OF cvi_vend_link.
    DATA : ls_vend_link LIKE LINE OF   lt_vend_link.
    DATA : ls_check_result LIKE LINE OF ct_check_results.
    DATA : lx_open_sql_error TYPE REF TO cx_sy_open_sql_error.


    DATA : lt_keys TYPE  cmds_customer_numbers_t .
    DATA : ls_key LIKE LINE OF lt_keys.
    DATA : lt_kna1_temp TYPE cmds_kna1_t.
    DATA : ls_kna1_temp LIKE LINE OF lt_kna1_temp.
    DATA : lt_kna1_key  TYPE cmds_customer_numbers_s_t.
    DATA : ls_kna1_key LIKE LINE OF lt_kna1_key.
    DATA : ls_kna1key LIKE LINE OF et_cust.
    DATA : ls_lfa1key LIKE LINE OF et_vend.


    DATA : lt_keys_vend TYPE  vmds_vendor_numbers_t .
    DATA : ls_key_vend LIKE LINE OF lt_keys_vend.
    DATA : lt_lfa1_temp TYPE vmds_lfa1_t.
    DATA : ls_lfa1_temp LIKE LINE OF lt_lfa1_temp.
    DATA : lt_lfa1_key  TYPE vmds_vendor_numbers_s_t.
    DATA : ls_lfa1_key LIKE LINE OF lt_lfa1_key.
    DATA : lv_cursor_kna1 TYPE cursor.
    DATA : lv_cust_from TYPE  kna1-kunnr.
    DATA : lv_cust_to TYPE kna1-kunnr.
    TYPES: ty_r_kunnr TYPE RANGE OF kna1-kunnr.

    DATA : ls_cust TYPE LINE OF ty_r_kunnr.
    DATA : lt_cust LIKE TABLE OF ls_cust.

    DATA : lv_vend_from TYPE  lfa1-lifnr.
    DATA : lv_vend_to TYPE lfa1-lifnr.
    TYPES: ty_r_lifnr TYPE RANGE OF lfa1-lifnr.

    DATA : ls_vend TYPE LINE OF ty_r_lifnr.
    DATA : lt_vend LIKE TABLE OF ls_vend.
*   DATA : lt_cust TYPE TABLE OF ty_r_kunnr.


    ls_check_result-software_component    = 'SAP_APPL'.
    ls_check_result-check_id              = 'CVI_MAPPING'.
    ls_check_result-application_component = 'LO-MD-BP'.
    ls_check_result-description = 'CVI_MAPPING - Customer/Vendor Mapping'.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = iv_cust_from
      IMPORTING
        output = lv_cust_from.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = iv_cust_to
      IMPORTING
        output = lv_cust_to.

    IF lv_cust_to IS INITIAL .
      ls_cust-option = 'EQ'.
    ELSE.
      ls_cust-option = 'BT'.
    ENDIF.
    IF lv_cust_from CA '*' .
      ls_cust-option = 'CP'.
    ENDIF.
    ls_cust-sign = 'I'.
    ls_cust-low = lv_cust_from.
    ls_cust-high = lv_cust_to.
    APPEND ls_cust TO lt_cust.
    CLEAR ls_cust.

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

    DATA : p_psize_kna1 TYPE integer VALUE '1000'.  " Package size
*  DATA : lv_cursor_kna1 TYPE cursor.
*if gv_kna1_cvi_mapping is not initial.

    TRY.
        IF lv_cursor_kna1 IS INITIAL AND iv_cust_from IS INITIAL AND iv_cust_to IS INITIAL .
          IF iv_no IS INITIAL.
            OPEN CURSOR: lv_cursor_kna1 FOR  SELECT * FROM kna1  AS a WHERE lifnr = '' AND kunnr NOT IN ( SELECT customer FROM cvi_cust_link AS b WHERE a~kunnr = b~customer  ). "#EC CI_NOFIELD #EC CI_NOWHERE "#EC CI_BUFFSUBQ
          ELSE.
            OPEN CURSOR: lv_cursor_kna1 FOR  SELECT * FROM kna1 AS a UP TO iv_no ROWS  WHERE kunnr NOT IN ( SELECT customer FROM cvi_cust_link AS b WHERE a~kunnr = b~customer  ) AND lifnr = ''. ""#EC CI_NOFIELD #EC CI_NOWHERE "#EC CI_BUFFSUBQ
          ENDIF.
        ENDIF.

        IF lv_cursor_kna1 IS INITIAL AND iv_cust_from IS NOT INITIAL OR iv_cust_to IS NOT INITIAL .
*         if  iv_no is INITIAL.
          OPEN CURSOR: lv_cursor_kna1 FOR  SELECT * FROM kna1  AS a WHERE lifnr = '' AND  ( ( kunnr IN lt_cust ) AND  kunnr  NOT IN
            ( SELECT customer FROM cvi_cust_link AS b WHERE a~kunnr = b~customer ) ). "#EC CI_NOFIELD #EC CI_NOWHERE "#EC CI_BUFFSUBQ.
*         else.
*          OPEN CURSOR: lv_cursor_kna1 FOR  SELECT * FROM kna1  as a UP TO iv_no ROWS WHERE LIfnr = '' and  ( ( kunnr in lt_cust ) and  kunnr  NOT IN
*            ( SELECT customer FROM cvi_cust_link AS b WHERE a~mandt = b~client ) ).  "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
*          endif.
        ENDIF.




        DO.
          FETCH NEXT CURSOR lv_cursor_kna1 INTO TABLE lt_kna1 PACKAGE SIZE p_psize_kna1.
          IF sy-subrc NE 0 .
            CLOSE CURSOR lv_cursor_kna1.
            gv_kna1_cvi_mapping = 'X'.
            EXIT .
          ELSE.
            SORT lt_kna1 BY mandt kunnr.
            IF iv_cust_from IS NOT INITIAL OR iv_cust_to IS NOT INITIAL .
              LOOP AT lt_kna1 INTO ls_kna1 WHERE kunnr BETWEEN iv_cust_from AND iv_cust_to.
                ls_key-kunnr = ls_kna1-kunnr .
                APPEND ls_key TO lt_keys.
                MOVE-CORRESPONDING ls_kna1 TO ls_kna1_temp.
                APPEND ls_kna1 TO lt_kna1_temp.
                CLEAR ls_key.
                CLEAR ls_kna1_temp.
                CLEAR ls_kna1.
              ENDLOOP.
            ELSE.
              LOOP AT lt_kna1 INTO ls_kna1.
              ls_key-kunnr = ls_kna1-kunnr .
              APPEND ls_key TO lt_keys.
              MOVE-CORRESPONDING ls_kna1 TO ls_kna1_temp.
              APPEND ls_kna1 TO lt_kna1_temp.
              CLEAR ls_key.
              CLEAR ls_kna1_temp.
              CLEAR ls_kna1.
            ENDLOOP.
          ENDIF.
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




          LOOP AT lt_kna1 INTO ls_kna1 WHERE kunnr IS NOT INITIAL.
            CONCATENATE ls_kna1-kunnr  'is not having CVI mapping check the table'  'CVI_CUST_LINK in client' ls_kna1-mandt ' kindly refer note 2210486'   INTO ls_check_result-description IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT
            ls_check_result-return_code =  co_return_code-abortion.
            APPEND ls_check_result TO ct_check_results.
            MOVE  ls_kna1-kunnr TO ls_kna1key-kunnr.

            APPEND ls_kna1key TO et_cust.
            CLEAR ls_kna1key.
*          clear ls_check_result.
          ENDLOOP.

          REFRESH  lt_kna1.
          REFRESH  lt_kna1_key.
          REFRESH  lt_kna1_temp.
          REFRESH lt_keys.

        ENDDO.

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

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = iv_vend_from
          IMPORTING
            output = lv_vend_from.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = iv_vend_to
          IMPORTING
            output = lv_vend_to.

        IF lv_vend_to IS INITIAL .
          ls_vend-option = 'EQ'.
        ELSE.
          ls_vend-option = 'BT'.
        ENDIF.
        IF lv_vend_from CA '*' .
          ls_vend-option = 'CP'.
        ENDIF.
        ls_vend-sign = 'I'.
        ls_vend-low = lv_vend_from.
        ls_vend-high = lv_vend_to.
        APPEND ls_vend TO lt_vend.
        CLEAR ls_vend.
        DATA : p_psize_lfa1 TYPE integer VALUE '1000'.  " Package size
*  DATA : s_cursor_lfa1_mapping TYPE cursor.
*  if gv_lfa1_cvi_mapping is not initial.
        IF s_cursor_lfa1_mapping IS INITIAL AND iv_vend_from IS INITIAL AND iv_vend_to IS INITIAL.
          IF iv_no IS INITIAL.
            OPEN CURSOR: s_cursor_lfa1_mapping FOR SELECT * FROM lfa1 AS a
            WHERE kunnr = '' AND lifnr NOT IN ( SELECT vendor FROM cvi_vend_link AS b CLIENT SPECIFIED WHERE a~lifnr = b~vendor ). "#EC CI_NOFIRST "#EC CI_NOFIELD #EC CI_NOWHERE "#EC CI_BUFFSUBQ.
          ELSE.
            OPEN CURSOR: s_cursor_lfa1_mapping FOR SELECT * FROM lfa1 AS a UP TO iv_no ROWS
             WHERE kunnr = '' AND lifnr NOT IN ( SELECT vendor FROM cvi_vend_link AS b CLIENT SPECIFIED WHERE a~lifnr = b~vendor ). "#EC CI_NOFIRST "#EC CI_NOFIELD #EC CI_NOWHERE "#EC CI_BUFFSUBQ.
          ENDIF.
        ENDIF.

        IF s_cursor_lfa1_mapping IS INITIAL AND iv_vend_from IS NOT INITIAL OR iv_vend_to IS NOT INITIAL .
*         if  iv_no is INITIAL.
          OPEN CURSOR: s_cursor_lfa1_mapping FOR  SELECT * FROM lfa1  AS a WHERE kunnr = '' AND  ( ( lifnr IN lt_vend ) AND  lifnr  NOT IN
            ( SELECT vendor FROM cvi_vend_link AS b WHERE a~lifnr = b~vendor ) ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
*        else.
*             OPEN CURSOR: s_cursor_lfa1_mapping FOR  SELECT * FROM lfa1  as a  UP TO iv_no ROWS WHERE kunnr = '' and  ( ( lifnr in lt_vend ) and  lifnr  NOT IN
*            ( SELECT vendor FROM cvi_vend_link AS b WHERE a~mandt = b~client ) ).  "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
*          endif.
        ENDIF.


        DO.
          FETCH NEXT CURSOR s_cursor_lfa1_mapping INTO TABLE lt_lfa1 PACKAGE SIZE p_psize_lfa1.
          IF sy-subrc NE 0 .
            CLOSE CURSOR s_cursor_lfa1_mapping.
            gv_lfa1_cvi_mapping = 'X'.
            EXIT .
          ELSE.
            SORT lt_lfa1 BY mandt Lifnr.
            IF iv_vend_from IS NOT INITIAL OR iv_vend_to IS NOT INITIAL.
              LOOP AT lt_lfa1 INTO ls_lfa1 WHERE lifnr BETWEEN iv_vend_from AND iv_vend_to.
                ls_key_vend-lifnr = ls_lfa1-lifnr .
                APPEND ls_key_vend TO lt_keys_vend.
                MOVE-CORRESPONDING ls_lfa1 TO ls_lfa1_temp.
                APPEND ls_lfa1 TO lt_lfa1_temp.
                CLEAR ls_key_vend.
                CLEAR ls_lfa1_temp.
                CLEAR ls_lfa1.
              ENDLOOP.
            ELSE.
              LOOP AT lt_lfa1 INTO ls_lfa1 .
              ls_key_vend-lifnr = ls_lfa1-lifnr .
              APPEND ls_key_vend TO lt_keys_vend.
              MOVE-CORRESPONDING ls_lfa1 TO ls_lfa1_temp.
              APPEND ls_lfa1 TO lt_lfa1_temp.
              CLEAR ls_key_vend.
              CLEAR ls_lfa1_temp.
              CLEAR ls_lfa1.
            ENDLOOP.
            ENDIF.

          ENDIF.
*    endif.



          CALL METHOD check_vend_part_of_retail_site
            EXPORTING
              it_keys         = lt_keys_vend
              it_lfa1         = lt_lfa1_temp
            IMPORTING
              et_part_of_site = lt_lfa1_key.


          LOOP AT lt_lfa1 INTO ls_lfa1.
            READ TABLE lt_lfa1_key INTO ls_lfa1_key WITH KEY lifnr = ls_lfa1-lifnr.
            IF sy-subrc = 0.
              DELETE TABLE lt_lfa1 FROM ls_lfa1.
            ENDIF.
            CLEAR ls_lfa1.
            CLEAR ls_lfa1_key.
          ENDLOOP.

          LOOP AT lt_lfa1 INTO ls_lfa1 WHERE lifnr IS NOT INITIAL.
            CONCATENATE ls_lfa1-lifnr 'is not having CVI mapping check the table'  'CVI_VEND_LINK in client' ls_lfa1-mandt ' kindly refer note 2210486'  INTO ls_check_result-description IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT
            ls_check_result-return_code =  co_return_code-abortion.
            APPEND ls_check_result TO ct_check_results.
            MOVE  ls_lfa1-lifnr TO ls_lfa1key-lifnr.
            APPEND ls_lfa1key TO et_vend.
            CLEAR ls_lfa1key.
*          clear ls_check_result.
          ENDLOOP.





          REFRESH  lt_lfa1.
          REFRESH  lt_lfa1_key.
          REFRESH  lt_lfa1_temp.
          REFRESH lt_keys_vend.


        ENDDO.

      CATCH cx_sy_open_sql_error INTO lx_open_sql_error.
        process_db_exception(
          EXPORTING
            ix_exception     = lx_open_sql_error
            iv_check_id      = 'CVI_MAPPING'
          CHANGING
            ct_check_results = ct_check_results ).
    ENDTRY.


    CLEAR : ls_kna1,
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

    REFRESH : lt_kna1,
              lt_lfa1,
              lt_cust_link,
              lt_vend_link,
              lt_keys,
              lt_kna1_temp,
              lt_kna1_key,
              lt_keys_vend,
              lt_lfa1_temp,
              lt_lfa1_key.

  ENDMETHOD.


  METHOD check_detm_range.

    DATA: lv_tabix    TYPE sy-tabix,
          lv_cnt_from TYPE i,
          lv_cnt_to   TYPE i.

    FIELD-SYMBOLS <fs_nriv> TYPE  nriv.


* Check   Alphanumeric number ranges
    LOOP AT ct_nriv ASSIGNING <fs_nriv> WHERE nrrangenr IS NOT INITIAL.
      lv_tabix = sy-tabix.

      IF  <fs_nriv>-fromnumber  CA sy-abcde OR <fs_nriv>-tonumber CA sy-abcde.
        APPEND  <fs_nriv> TO et_alpha_nriv.
        DELETE ct_nriv  INDEX lv_tabix.

      ENDIF.

      IF <fs_nriv>-fromnumber IS ASSIGNED AND <fs_nriv>-tonumber  IS ASSIGNED.
        lv_cnt_from = strlen( <fs_nriv>-fromnumber ).
        lv_cnt_to = strlen( <fs_nriv>-tonumber ).
        IF lv_cnt_from > 10 OR lv_cnt_to > 10.
          raise wrong_nriv_format.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD check_nriv.


    DATA: lv_found           TYPE boolean,
          lv_subrc           TYPE sy-subrc,
          lv_nriv_fromnumber TYPE numc10,
          lv_nriv_tonumber   TYPE numc10,
          lv_fromnumber     TYPE nrlevel,
          lv_tonumber        TYPE nrlevel,
          lv_delta           TYPE nrlevel,
          ls_nriv            TYPE nriv.

*    FIELD-SYMBOLS: <from> TYPE any,
*                   <to>   TYPE any.

    IF iv_src_fromnumber IS INITIAL.

* for ascii check in fm NUMBER_CHECK
      CLASS cl_abap_char_utilities DEFINITION LOAD.

* Nummernkreisobjekt nur lesen, wenn OBJECT vom zuletzt gelesenen
* Objekt abweicht.
      IF act_object = space OR act_object <> iv_object.
        select_tnro( iv_object = iv_object ).
      ENDIF.


* Fehlerschalter des Puffers initialisieren
*    Die Pufferversion ist aktiv
*    NrKreisIntervall im Puffer lesen
*    Schnittstelle der C-Routine versorgen
      CLEAR bnriv.
      bnriv-client     = sy-mandt.
      bnriv-object     = iv_object.
      bnriv-nrrangenr  = iv_range_nr.
*  IF tnro-yearind = abap_false.
*    bnriv-toyear = '0000'.
*  ELSE.
*    bnriv-toyear = toyear.
*  ENDIF.
* Intervall im Puffer lesen
      CALL 'ThNoRead' ID 'BNRIV' FIELD bnriv.             "#EC CI_CCALL
      lv_subrc = sy-subrc.
      lv_found = abap_false.
      CASE lv_subrc.
        WHEN 0.
          ls_nriv = bnriv.
          lv_found = abap_true.
        WHEN 4.
          MESSAGE e751(nr) RAISING interval_not_found
                       WITH iv_object iv_range_nr .
        WHEN OTHERS.
*      PERFORM thnocall.
      ENDCASE.

      IF lv_found = abap_false.
*   Die Pufferversion ist nicht aktiv oder es wurde bereits
*   ein Fehler im Puffer oder NrKreisServer festgestellt.
*    IF tnro-yearind = space.
*     Nummernkreise sind jahresunabhängig
        SELECT SINGLE * FROM  nriv
                        INTO  ls_nriv
                        WHERE object    = iv_object
*                        AND subobject = subobject
                          AND nrrangenr = iv_range_nr
                          AND toyear    = '0000'.
        IF sy-subrc <> 0.
          MESSAGE e751(nr) RAISING interval_not_found
                       WITH iv_object iv_range_nr.
        ENDIF.
      ENDIF.
    ELSE.
      CLEAR ls_nriv.
      ls_nriv-fromnumber = iv_src_fromnumber.
      ls_nriv-tonumber =  iv_src_tonumber.
      ls_nriv-object = iv_object.
      ls_nriv-nrrangenr = iv_range_nr.
      ls_nriv-nrlevel = iv_src_nrlevel.
    ENDIF.

    lv_nriv_fromnumber =  ls_nriv-fromnumber.
    IF iv_acttonum = abap_true.
      lv_nriv_tonumber = ls_nriv-nrlevel.
    ELSE.
      lv_nriv_tonumber =  ls_nriv-tonumber.
    ENDIF.

*------ Overlapping check
    IF iv_tonumber < 1 OR lv_nriv_tonumber < 1.
      ev_return = abap_true.
      RETURN.
    ENDIF.
*------ Overlapping check -  four use cases
*  1.   |----------| (NRIV)
*  1.1 |------------|
*  2.  |----------| (NRIV)
*  2.1       |-------|
* 3.       |----------| (NRIV)
* 3.1    |------|
*4.    |-----------| (NRIV)
* 4.1    |------|

    IF iv_fromnumber <= lv_nriv_fromnumber  AND
         iv_tonumber >=   lv_nriv_tonumber OR
            iv_fromnumber >= lv_nriv_fromnumber
      AND iv_fromnumber <= lv_nriv_tonumber OR
      iv_tonumber >= lv_nriv_fromnumber
      AND iv_tonumber <= lv_nriv_tonumber.

* Change border
      IF iv_fromnumber < lv_nriv_fromnumber.
        lv_fromnumber = lv_nriv_fromnumber.
      ELSE.
        lv_fromnumber = iv_fromnumber.
      ENDIF.

      IF iv_tonumber > lv_nriv_tonumber.
        lv_tonumber = lv_nriv_tonumber.
      ELSE.
        lv_tonumber = iv_tonumber.
      ENDIF.

      lv_delta = abs( lv_tonumber - lv_fromnumber  ).

* Determine overlapping percentage between source(ls_nriv delta) and dep number range delta
      ev_overlpercent = ( lv_delta / abs( lv_nriv_tonumber - lv_nriv_fromnumber  ) ) * 100 .

*   NUMBER inside range
      ev_return = space.
    ELSE.
*   NUMBER outside range
      ev_return = abap_true.
    ENDIF.
  ENDMETHOD.


  method CHECK_POST_VALUE_MAPPING.
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
        select distinct * from tb910 as a into corresponding fields of table lt_tb910 where abtnr not in
          ( select GP_ABTNR from cvic_cp1_link as b where  a~client = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
        if sy-subrc = 0.
          loop at  lt_tb910 into ls_tb910 where abtnr is not initial  .
            concatenate ls_tb910-abtnr 'Department not maintained in table' 'CVIC_CP1_LINK in client' ls_tb910-client 'kindly refer note 2210486' into ls_check_result-description in character mode. "#EC NOTEXT
            ls_check_result-return_code =  co_return_code-warning.

            append ls_check_result to ct_check_results.
            if ls_tb910-client = sy-mandt.
            append ls_tb910-abtnr to ct_tb910.
            endif.
            clear ls_tb910.
          endloop.

        endif.

* Assign for department functions

        select distinct * from tb912 as a into corresponding fields of table lt_tb912 where pafkt not in
          ( select GP_PAFKT from cvic_cp2_link as b where a~client = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
        if sy-subrc = 0.
          loop at  lt_tb912 into ls_tb912 where pafkt is not initial  .
            concatenate ls_tb912-pafkt 'Function not maintained in table' 'CVIC_CP2_LINK in client' ls_tb912-client 'kindly refer note 2210486'   into ls_check_result-description in character mode. "#EC NOTEXT
            ls_check_result-return_code =  co_return_code-warning.
            append ls_check_result to ct_check_results.
            if ls_tb912-client = sy-mandt.
            append ls_tb912-pafkt to ct_tb912.
            ENDIF.
            clear ls_tb912.
          endloop.

        endif.


*  Authority
        select distinct * from tb914 as a into corresponding fields of table lt_tb914 where paauth not in
          ( select paauth from cvic_cp3_link as b where a~client = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
        if sy-subrc =  0.
          loop at  lt_tb914 into ls_tb914 where paauth is not initial  .
            concatenate ls_tb914-paauth 'Authority not mainatined in table' 'CVIC_CP3_LINK in client' ls_tb914-client ' kindly refer note 2210486'   into ls_check_result-description in character mode. "#EC NOTEXT
            ls_check_result-return_code =  co_return_code-warning.
            append ls_check_result to ct_check_results.
            if ls_tb914-client = sy-mandt.
            append ls_tb914-paauth to ct_tb914.
            endif.
            clear ls_tb914.
          endloop.

        endif.


*  VIP Indicator

        select distinct * from tb916 as a into corresponding fields of table lt_tb916 where pavip not in
          ( select GP_PAVIP from cvic_cp4_link as b where a~client = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
        if sy-subrc =  0.
          loop at  lt_tb916 into ls_tb916 where pavip is not initial  .

            concatenate ls_tb916-pavip 'VIP Indicator not mainatined in table' 'CVIC_CP4_LINK in client' ls_tb916-client 'kindly refer note 2210486'   into ls_check_result-description in character mode. "#EC NOTEXT

            ls_check_result-return_code =  co_return_code-warning.
            append ls_check_result to ct_check_results.
            if ls_tb916-client = sy-mandt..
            append ls_tb916-pavip to ct_tb916.
            ENDIF.
            clear ls_tb916.
          endloop.

        endif.


*  Martial status

        select distinct * from tb027  as a into corresponding fields of table lt_tb027 where marst not in
          ( select marst from cvic_marst_link as b where a~client = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
        if sy-subrc =  0.
          loop at  lt_tb027 into ls_tb027 where marst is not initial  .
            concatenate ls_tb027-marst 'Marital Status not mainatined in table' 'CVIC_MARST_LINK in client'  ls_tb027-client 'kindly refer note 2210486'   into ls_check_result-description in character mode. "#EC NOTEXT

            ls_check_result-return_code =  co_return_code-warning.
            append ls_check_result to ct_check_results.
            if ls_tb027-client = sy-mandt.
            append ls_tb027-marst to ct_tb027.
            endif.
            clear ls_tb027.
          endloop.
*

        endif.


*  Legal form

        select distinct * from tb019 as a into corresponding fields of table lt_tb019 where legal_enty not in
          ( select legal_enty from cvic_legform_lnk as b where a~client = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
        if sy-subrc = 0.
          loop at  lt_tb019 into ls_tb019 where legal_enty is not initial  .
            concatenate ls_tb019-legal_enty 'Legal form not maintained in table' 'CVIC_LEGFORM_LNK in client' ls_tb019-client 'kindly refer note 2210486'   into ls_check_result-description in character mode. "#EC NOTEXT

            ls_check_result-return_code =  co_return_code-warning.
            append ls_check_result to ct_check_results.
            if ls_tb019-client = sy-mandt.
            append ls_tb019-legal_enty to ct_tb019.
            endif.
            clear ls_tb019.
          endloop.
*
        endif.


*    Industries

**  incoming industry
*
data : cs_tb038a LIKE LINE OF ct_tb038a.
data : cs_tb038a_out LIKE LINE OF ct_tb038a_out.

        select distinct * from  tb038a as a into corresponding fields of table lt_tb038a
          where istype not in  ( select istype from  tp038m2 as b where a~client = b~client )
          and  ind_sector not in ( select ind_sector from tp038m2 as c where a~client = c~client )  . "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

        if sy-subrc = 0.
          loop at  lt_tb038a into ls_tb038a where istype is not initial and ind_sector is not initial .
            concatenate ls_tb019-legal_enty 'Legal form not maintained in table' 'CVIC_LEGFORM_LNK in client' ls_tb038a-client 'kindly refer note 2210486'   into ls_check_result-description in character mode. "#EC NOTEXT
            ls_check_result-return_code =  co_return_code-warning.
            append ls_check_result to ct_check_results.
            cs_tb038a-istype = ls_tb038a-istype.
            cs_tb038a-ind_sector = ls_tb038a-ind_sector.
            append cs_tb038a to ct_tb038a.
            clear ls_tb038a.
            clear cs_tb038a.
          endloop.
        endif.

* outgoing industry
        select distinct * from  tb038a as a into corresponding fields of table lt_tb038a where istype not in ( select istype from  tp038m1 as b where a~client = b~client )
                                                                                     and  ind_sector not in ( select ind_sector from tp038m1 as c where a~client = c~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

        if sy-subrc = 0.
          loop at  lt_tb038a into ls_tb038a where istype is not initial and ind_sector is not initial .
            concatenate 'For Industry Sector' ls_tb038a-ind_sector 'and for Industry system' ls_tb038a-istype  'Industry Not maintained in table TP038M2 in client'  ls_tb038a-client  ' kindly refer note 2210486'   into ls_check_result-description in
character mode.                                             "#EC NOTEXT

            ls_check_result-return_code =  co_return_code-warning.
            append ls_check_result to ct_check_results.
            cs_tb038a_out-istype = ls_tb038a-istype.
            cs_tb038a_out-ind_sector = ls_tb038a-ind_sector.
            append cs_tb038a_out to ct_tb038a_out.
            clear ls_tb038a.
            clear cs_tb038a_out.
          endloop.
        endif.

*payment card


        select distinct * from  tb033 as a into corresponding fields of table lt_tb033 where ccins not in
          ( select PCID_BP from cvic_ccid_link   as b  where a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

        if sy-subrc = 0.
          loop at lt_tb033 into ls_tb033 where ccins is not initial .

            concatenate ls_tb033-ccins 'payment Card type not maintained in table' 'CVIC_CCID_LINK in client' ls_tb033-mandt  'kindly refer note 2210486'   into ls_check_result-description in character mode. "#EC NOTEXT

            ls_check_result-return_code =  co_return_code-warning.

            append ls_check_result to ct_check_results.

             if ls_tb033-mandt = sy-mandt.
            append ls_tb033-ccins to ct_tb033.
            endif.
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


method check_supplier.
*  DATA: lt_knbk type STANDARD TABLE OF knbk,
*        lt1_knbk type STANDARD TABLE OF knbk,
*      ls_knbk like LINE OF lt_knbk,
*      lt_kna1 type STANDARD TABLE OF kna1,
*      lt1_kna1 type STANDARD TABLE OF kna1,
*      ls_kna1 like LINE OF lt_kna1.
*
*DATA: lt_lfa1 type STANDARD TABLE OF LFA1,
*      lt1_lfa1 type STANDARD TABLE OF LFA1,
*      ls_lfa1 like LINE OF lt_lfa1,
*      lt_lfbk type STANDARD TABLE OF lfbk,
*      lt1_lfbk type STANDARD TABLE OF lfbk,
*      ls_lfbk like LINE OF lt_lfbk.

  data: lt_knbk type knbk_key_t,
       lt1_knbk type knbk_key_t,
     ls_knbk like line of lt_knbk,
     lt_kna1 type cvis_kna1_t,
     lt1_kna1 type cvis_kna1_t,
     ls_kna1 like line of lt_kna1.

  data: lt_lfa1 type  cvis_lfa1_t,
        lt1_lfa1 type lfa1_key_t,
        lt1_lfa1_ind type lfa1_key_t,
        ls_lfa1 like line of lt_lfa1,
        lt_lfbk type lfbk_key_t,
        lt1_lfbk type vmds_lfbk_t,
        ls_lfbk like line of  lt_lfbk.
  data: cl_ref type ref to cl_s4_checks_bp_enh.
  data: iv_no type i.

  refresh lt_knbk.
  refresh lt1_knbk.
  refresh lt_kna1.
  refresh lt_lfbk.
  refresh lt1_lfbk.
  refresh lt_lfa1.
  clear: ls_kna1, ls_lfa1,ls_knbk,ls_lfbk.

*SELECT * FROM KNA1 INTO TABLE LT_KNA1 where KUNNR <> ' '.
*SELECT * FROM LFA1 INTO TABLE LT_LFA1 where LIFNR <> ' '.
*select * from KNBK into table lt_knbk where kunnr <> ' '.
*select * from LFBK into table lt_lfbk where lifnr <> ' '.
  create object cl_ref.
  cl_ref->get_cust_supp_details( exporting iv_flag ='S' iv_no = iv_no importing et_kna1 = lt_kna1 et_lfa1 = lt_lfa1 et_knbk = lt_knbk et_lfbk = lt_lfbk ).

  loop at lt_lfa1 into ls_lfa1.
    read table lt_kna1 into ls_kna1 with key kunnr = ls_lfa1-kunnr.
    if sy-subrc = 0.
      if ls_kna1-stcd1 ne ls_lfa1-stcd1 or ls_kna1-stcd2 ne ls_lfa1-stcd2 or ls_kna1-stkzu ne ls_lfa1-stkzu or ls_kna1-stceg ne ls_lfa1-stceg.
        append ls_lfa1 to lt1_lfa1.
        c_change_1 = 'Y'.
      endif.
      if ls_kna1-brsch ne ls_lfa1-brsch
        or ls_kna1-bbbnr ne ls_lfa1-bbbnr or ls_kna1-bbsnr ne ls_lfa1-bbsnr or ls_kna1-bubkz ne ls_lfa1-bubkz or ls_kna1-vbund ne ls_lfa1-vbund.
        append ls_lfa1 to lt1_lfa1_ind.
        c_change_1 = 'Y'.
      endif.
    endif.
  endloop.
  et_lfa1 = lt1_lfa1.
  et_lfa1_ind = lt1_lfa1_ind.

  loop at lt_kna1 into ls_kna1.
    read table lt_lfbk into ls_lfbk with key lifnr = ls_kna1-lifnr.
    if sy-subrc eq 0.
      read table lt_knbk into ls_knbk with key kunnr = ls_kna1-kunnr.
      if sy-subrc eq 0.
        if ls_knbk-banks ne ls_lfbk-banks or ls_knbk-bankl ne ls_lfbk-bankl or ls_knbk-bankn ne ls_lfbk-bankn.
          append ls_lfbk to lt1_lfbk.
          c_change_1 = 'Y'.
        endif.
      endif.
    endif.
  endloop.
  et_lfbk = lt1_lfbk.
endmethod.


  method CHECK_TAX_CATEGORY.
    data : lt_DFKKBPTAXNUM TYPE STANDARD TABLE OF DFKKBPTAXNUM,
           ls_DFKKBPTAXNUM like line of lt_DFKKBPTAXNUM.

    data :  lt_TFKTAXNUMTYPE TYPE STANDARD TABLE OF TFKTAXNUMTYPE,
            ls_TFKTAXNUMTYPE like line of lt_TFKTAXNUMTYPE.
    DATA : ls_check_result TYPE ty_preprocessing_check_result.
    data : ls_taxtype like line of ct_taxtype.


        DATA: lx_open_sql_error TYPE REF TO cx_sy_open_sql_error.
  ls_check_result-software_component    = 'SAP_APPL'.
  ls_check_result-check_id              = 'CHK_TAX_TYPE'.
  ls_check_result-application_component = 'LO-MD-BP'.
  ls_check_result-description = 'CHK_TAX_TYPE Tax category is not maintained'.


    refresh lt_TFKTAXNUMTYPE.
    refresh lt_DFKKBPTAXNUM.
    clear : ls_DFKKBPTAXNUM,ls_TFKTAXNUMTYPE.


    select * from dfkkbptaxnum into table lt_dfkkbptaxnum."#EC CI_NOWHERE where taxtype <> ' '.
      IF sy-subrc = 0.
        delete lt_dfkkbptaxnum where TAXTYPE = ' '.
      ENDIF.
    select * from tfktaxnumtype into table lt_tfktaxnumtype."#EC CI_NOWHERE where taxtype <> ' '.
       IF sy-subrc = 0.
        delete lt_tfktaxnumtype where TAXTYPE = ' '.
      ENDIF.
try.
      loop at lt_DFKKBPTAXNUM into ls_DFKKBPTAXNUM.
        read table lt_TFKTAXNUMTYPE into ls_TFKTAXNUMTYPE with key taxtype = ls_DFKKBPTAXNUM-taxtype.
        if sy-subrc <> 0.
          CONCATENATE ls_DFKKBPTAXNUM-taxtype  'Tax Category is not maintained in table' 'TFKTAXNUMTYPE in client' ls_TFKTAXNUMTYPE-client INTO ls_check_result-description IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT
          ls_check_result-return_code =  co_return_code-warning.
          APPEND ls_check_result TO ct_check_results.
           ls_taxtype-tax_type = ls_DFKKBPTAXNUM-taxtype.
          append ls_taxtype to ct_taxtype.
        endif.
     endloop.

      catch cx_sy_open_sql_error into lx_open_sql_error.
      process_db_exception(
        EXPORTING
          ix_exception     = lx_open_sql_error
          iv_check_id      = 'CHK_TAX_TYPE'
        CHANGING
          ct_check_results = ct_check_results ).
    endtry.
  endmethod.


  METHOD CHECK_VALUE_MAPPING.

DATA:lt_knvk TYPE TABLE OF knvk,
    ls_knvk LIKE LINE OF lt_knvk,
    lt_kna1 TYPE TABLE OF kna1,
    ls_kna1 LIKE LINE OF lt_kna1,
    lt_cvic_cp1_link TYPE TABLE OF cvic_cp1_link,
    ls_cviv_cp1_link LIKE LINE OF  lt_cvic_cp1_link,
    ls_map_contact TYPE cvic_map_contact,
    ls_cvic_cp1_link LIKE LINE OF lt_cvic_cp1_link,
    lt_cvic_cp2_link TYPE TABLE OF cvic_cp2_link,
    ls_cvic_cp2_link LIKE LINE OF lt_cvic_cp2_link,
    lt_cvic_cp3_link TYPE TABLE OF cvic_cp3_link,
    ls_cvic_cp3_link LIKE LINE OF lt_cvic_cp3_link,
    lt_cvic_cp4_link TYPE TABLE OF cvic_cp4_link,
    ls_cvic_cp4_link LIKE LINE OF lt_cvic_cp4_link,
    lt_cvic_marst_link  TYPE STANDARD TABLE OF cvic_marst_link,
    ls_cvic_marst_link  LIKE LINE OF lt_cvic_marst_link,
    lt_cvic_legform_lnk TYPE STANDARD TABLE OF cvic_legform_lnk,
    ls_cvic_legform_lnk LIKE LINE OF lt_cvic_legform_lnk,
    lt_payment TYPE STANDARD TABLE OF vckun,
    ls_payment LIKE LINE OF lt_payment,
    lt_cvic_ccid_link TYPE STANDARD TABLE OF cvic_ccid_link,
    ls_cvic_ccid_link LIKE LINE OF lt_cvic_ccid_link,
    ls_check_result LIKE LINE OF ct_check_results,
    lt_tp038m2  TYPE STANDARD TABLE OF tp038m2,
    ls_tp038m2  LIKE LINE OF lt_tp038m2,
    lx_open_sql_error TYPE REF TO cx_sy_open_sql_error.
    ls_check_result-software_component    = 'SAP_APPL'.
    ls_check_result-check_id              = 'CHK_CON_ASSIGNMENT'.
    ls_check_result-application_component = 'LO-MD-BP'.
    ls_check_result-description = 'CHK_CON_ASSIGNMENT - Check contact person assignment'.


    DATA : lt_keys TYPE  cmds_customer_numbers_t .
    DATA : ls_key LIKE LINE OF lt_keys.
    DATA : lt_kna1_temp TYPE cmds_kna1_t.
    DATA : ls_kna1_temp LIKE LINE OF lt_kna1_temp.
    DATA : lt_kna1_key  TYPE cmds_customer_numbers_s_t.
    DATA : ls_kna1_key LIKE LINE OF lt_kna1_key.

    DATA : lt_keys_vend TYPE  vmds_vendor_numbers_t .
    DATA : ls_key_vend LIKE LINE OF lt_keys_vend.
    DATA : lt_lfa1_temp TYPE vmds_lfa1_t.
    DATA : ls_lfa1_temp LIKE LINE OF lt_lfa1_temp.
    DATA : lt_lfa1_key  TYPE vmds_vendor_numbers_s_t.
    DATA : ls_lfa1_key LIKE LINE OF lt_lfa1_key.

 data: ls_department like line of ct_department,
       ls_function like line of ct_function,
        ls_authority like line of ct_authority,
         ls_pcard like line of ct_pcard,
          ls_marital like line of ct_marital,
           ls_vip like line of ct_vip,
            ls_legal like line of ct_legal  ,
            ls_cp_assign like line of ct_cp_assign,
            ls_industry_in like line of ct_industry_in,
            ls_industry_out like line of ct_industry_out
             .



    TRY.

*        a.  Activate Assignment of Contact Persons
        SELECT SINGLE * FROM cvic_map_contact  INTO ls_map_contact . "#EC CI_NOWHERE  CLIENT SPECIFIED
        IF ls_map_contact-map_contact IS INITIAL.
          CONCATENATE 'Contact person Assignment not activated and not maintained in table' 'CVIC_MAP_CONTACT in client' ls_map_contact-client 'kindly refer note 2210486'  INTO ls_check_result-description IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT
          ls_check_result-return_code =  co_return_code-warning.
          APPEND ls_check_result TO ct_check_results.
          ls_cp_assign-cp_assign = ls_map_contact-map_contact.
            append ls_cp_assign to ct_cp_assign.
        ENDIF.
*        clear ls_check_result.

*b.	Assign Department Numbers for Contact Person
        DATA : p_psize_knvk TYPE integer VALUE '1000'.  " Package size

        IF s_cursor_knvk IS INITIAL.
          IF  iv_no IS INITIAL.
            OPEN CURSOR : s_cursor_knvk FOR SELECT DISTINCT * FROM knvk "AS a CLIENT SPECIFIED
                                      WHERE abtnr IS NOT NULL AND abtnr NOT IN ( SELECT abtnr FROM cvic_cp1_link   ). "#EC CI_NOFIELD #EC CI_NOWHERE "#EC CI_BUFFSUBQ.CLIENT SPECIFIED WHERE a~mandt = b~client AS b
          ELSE.
            OPEN CURSOR : s_cursor_knvk FOR SELECT DISTINCT * FROM knvk UP TO  iv_no ROWS  "AS a CLIENT SPECIFIED
                                       WHERE abtnr IS NOT NULL AND abtnr NOT IN ( SELECT abtnr FROM cvic_cp1_link ) . "#EC CI_NOFIELD #EC CI_NOWHERE "#EC CI_BUFFSUBQ.CLIENT SPECIFIED WHERE a~mandt = b~client AS b


          ENDIF.
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
               ls_department-dept = ls_knvk-abtnr.
            append ls_department to ct_department.
*          clear ls_check_result.
              CLEAR ls_knvk.
            ENDLOOP.

            REFRESH lt_knvk.
          ENDIF.
        ENDDO.




*c.	Assign Functions of Contact Person
        DATA : s_cursor_knvk6 TYPE cursor.
        DATA : p_psize_knvk6 TYPE integer VALUE '1000'.


        IF s_cursor_knvk6 IS INITIAL.
          IF iv_no IS INITIAL.
            OPEN CURSOR : s_cursor_knvk6 FOR SELECT DISTINCT * FROM knvk "AS a CLIENT SPECIFIED
                                                   WHERE pafkt IS NOT NULL AND pafkt NOT IN ( SELECT pafkt FROM cvic_cp2_link  ). "#EC CI_NOFIELD  #EC CI_NOWHERE "#EC CI_BUFFSUBQ.CLIENT SPECIFIED WHERE a~mandt = b~client AS b
          ELSE.
            OPEN CURSOR : s_cursor_knvk6 FOR SELECT DISTINCT * FROM knvk UP TO iv_no ROWS "AS a CLIENT SPECIFIED
                                                   WHERE pafkt IS NOT NULL AND pafkt NOT IN ( SELECT pafkt FROM cvic_cp2_link  ). "#EC CI_NOFIELD  #EC CI_NOWHERE "#EC CI_BUFFSUBQ.CLIENT SPECIFIED WHERE a~mandt = b~client AS b
          ENDIF.
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
               ls_function-fn = ls_knvk-pafkt.
            append ls_function to ct_function.
*          clear ls_check_result.
              CLEAR ls_knvk.
            ENDLOOP.

            REFRESH lt_knvk.
          ENDIF.
        ENDDO.

*b  Assign Authority of Contact Person

        DATA : s_cursor_knvk1 TYPE cursor.
        DATA : p_psize_knvk1 TYPE integer VALUE '1000'.

        IF s_cursor_knvk1 IS INITIAL.
          IF iv_no IS INITIAL.
            OPEN CURSOR : s_cursor_knvk1 FOR  SELECT DISTINCT * FROM knvk "AS a CLIENT SPECIFIED
*                                                                       WHERE parvo IS NOT NULL AND parvo  NOT IN ( SELECT parvo FROM cvic_cp3_link   ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.CLIENT SPECIFIED WHERE a~mandt = b~client AS b
                                            WHERE parvo IS NOT NULL AND parvo  NOT IN ( SELECT tvpv~parvo FROM cvic_cp3_link JOIN tvpv on cvic_cp3_link~parvo = tvpv~parvo ). "#EC CI_NOFIELD "#EC CI_BUFFJOIN "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
            "CLIENT SPECIFIED WHERE a~mandt= b~client AS b
          ELSE.
            OPEN CURSOR : s_cursor_knvk1 FOR  SELECT DISTINCT * FROM knvk  UP TO iv_no ROWS "AS a CLIENT SPECIFIED
                                          WHERE parvo IS NOT NULL AND parvo  NOT IN ( SELECT tvpv~parvo FROM cvic_cp3_link JOIN tvpv on cvic_cp3_link~parvo = tvpv~parvo  ). "#EC CI_NOFIELD "#EC CI_BUFFJOIN "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
            "CLIENT SPECIFIED WHERE a~mandt= b~client AS b

          ENDIF.
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
 ls_authority-auth = ls_knvk-parvo.
            append ls_authority to ct_authority.
*          clear ls_check_result.
              CLEAR ls_knvk.
            ENDLOOP.
            REFRESH lt_knvk.
          ENDIF.
        ENDDO.

*e.	Assign VIP Indicator for Contact Person

        DATA : s_cursor_knvk2 TYPE cursor.
        DATA : p_psize_knvk2 TYPE integer VALUE '1000'.

        IF s_cursor_knvk2 IS INITIAL.
          IF iv_no IS INITIAL.
            OPEN CURSOR : s_cursor_knvk2 FOR SELECT DISTINCT * FROM knvk " AS a CLIENT SPECIFIED
                                                       WHERE pavip IS NOT NULL AND pavip  NOT IN
                                                       ( SELECT tvip~pavip FROM cvic_cp4_link JOIN tvip ON cvic_cp4_link~pavip = tvip~pavip ). "#EC CI_NOFIELD "#EC CI_BUFFJOIN "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.CLIENT SPECIFIED WHERE a~mandt = b~client AS b
          ELSE.
            OPEN CURSOR : s_cursor_knvk2 FOR SELECT DISTINCT * FROM knvk  UP TO iv_no ROWS " AS a CLIENT SPECIFIED
                                                      WHERE pavip IS NOT NULL AND pavip  NOT IN
                                                      ( SELECT tvip~pavip FROM cvic_cp4_link JOIN tvip ON cvic_cp4_link~pavip = tvip~pavip ). "#EC CI_NOFIELD "#EC CI_BUFFJOIN "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.CLIENT SPECIFIED WHERE a~mandt = b~client AS b

          ENDIF.
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
               ls_vip-vip_in = ls_knvk-pavip.
            append ls_vip to ct_vip.
*          clear ls_check_result.
              CLEAR ls_knvk.
            ENDLOOP.
            REFRESH lt_knvk.
          ENDIF.
        ENDDO.
*f.	Assign Marital Status


        DATA : s_cursor_knvk3 TYPE cursor.
        DATA : p_psize_knvk3 TYPE integer VALUE '1000'.

        IF s_cursor_knvk3 IS INITIAL.
          IF iv_no IS INITIAL.
            OPEN CURSOR : s_cursor_knvk3 FOR  SELECT DISTINCT * FROM knvk "AS a  CLIENT SPECIFIED
                                          WHERE famst IS NOT NULL AND famst NOT IN
                                          ( SELECT famst FROM  cvic_marst_link   ). "#EC CI_NOFIELD #EC CI_NOWHERE "#EC CI_BUFFSUBQCLIENT SPECIFIED WHERE a~mandt = b~client AS b
          ELSE.
            OPEN CURSOR : s_cursor_knvk3 FOR  SELECT DISTINCT * FROM knvk UP TO iv_no ROWS "AS a  CLIENT SPECIFIED
                                        WHERE famst IS NOT NULL AND famst NOT IN ( SELECT famst FROM  cvic_marst_link   ). "#EC CI_NOFIELD #EC CI_NOWHERE "#EC CI_BUFFSUBQCLIENT SPECIFIED WHERE a~mandt = b~client AS b

          ENDIF.
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
               ls_marital-mstat = ls_knvk-famst.
            append ls_marital to ct_marital.
*          clear ls_check_result.
            ENDLOOP.
            REFRESH lt_knvk.
          ENDIF.
        ENDDO.

        DATA : p_psize_kna1 TYPE integer VALUE '1000'.  " Package size
        DATA : p_psize_kna1_1 TYPE integer VALUE '1000'.
        IF s_cursor_kna1_val_map IS INITIAL.
          IF iv_no IS INITIAL.
            OPEN CURSOR: s_cursor_kna1_val_map FOR  SELECT DISTINCT * FROM kna1 "AS a CLIENT SPECIFIED
             WHERE gform IS NOT NULL AND gform  NOT IN
                 ( SELECT tvgf~gform  FROM  cvic_legform_lnk JOIN tvgf on cvic_legform_lnk~gform = tvgf~gform ). "#EC CI_NOFIELD "#EC CI_BUFFJOIN "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.CLIENT SPECIFIED WHERE a~mandt = b~client AS b
          ELSE.
            OPEN CURSOR: s_cursor_kna1_val_map FOR  SELECT DISTINCT * FROM kna1 UP TO iv_no ROWS "AS a CLIENT SPECIFIED
            WHERE gform IS NOT NULL AND gform  NOT IN
                ( SELECT tvgf~gform  FROM  cvic_legform_lnk JOIN tvgf on cvic_legform_lnk~gform = tvgf~gform ). "#EC CI_NOFIELD "#EC CI_BUFFJOIN "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.CLIENT SPECIFIED WHERE a~mandt = b~client AS b

          ENDIF.
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

          IF gv_site IS INITIAL.

            LOOP AT lt_kna1 INTO ls_kna1.
            READ TABLE lt_kna1_key INTO ls_kna1_key WITH KEY kunnr = ls_kna1-kunnr.
            IF sy-subrc = 0.
              DELETE TABLE lt_kna1 FROM ls_kna1.
            ENDIF.
            CLEAR ls_kna1.
            CLEAR ls_kna1_key.
          ENDLOOP.
          ELSE.
            lt_kna1 = lt_kna1_key.
          ENDIF.

*b.	Assign Legal Form to Legal Status

          LOOP AT lt_kna1 INTO ls_kna1 WHERE gform IS NOT INITIAL.
            CONCATENATE ls_kna1-gform 'Legal form not maintained in table' 'CVIC_LEGFORM_LNK in client' ls_kna1-mandt 'kindly refer note 2210486'  INTO ls_check_result-description IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT
            ls_check_result-return_code =  co_return_code-warning.
            APPEND ls_check_result TO ct_check_results.
 ls_legal-legal = ls_kna1-gform.
            append ls_legal to ct_legal.
*          clear ls_check_result.
            CLEAR ls_kna1.
          ENDLOOP.
          REFRESH lt_kna1.
          REFRESH lt_kna1_temp.
          REFRESH lt_kna1_key.
          REFRESH lt_keys.

        ENDDO.

* c  Assign Industries
* Incoming industry



*        DATA : p_psize_kna1_1 TYPE integer VALUE '1000'.
        CLEAR s_cursor_kna1_ac.
        IF s_cursor_kna1_ac IS INITIAL.
          IF iv_no IS INITIAL.
            OPEN CURSOR: s_cursor_kna1_ac FOR  SELECT DISTINCT * FROM kna1 "AS a CLIENT SPECIFIED
            WHERE brsch IS NOT NULL AND brsch NOT IN ( SELECT brsch FROM tp038m2   ). "#EC CI_NOFIELD #EC CI_NOWHERE "#EC CI_BUFFSUBQ.CLIENT SPECIFIED WHERE a~mandt = b~client AS b
          ELSE.
            OPEN CURSOR: s_cursor_kna1_ac FOR  SELECT DISTINCT * FROM kna1  UP TO iv_no ROWS "AS a CLIENT SPECIFIED
            WHERE brsch IS NOT NULL AND brsch NOT IN ( SELECT brsch FROM tp038m2   ). "#EC CI_NOFIELD #EC CI_NOWHERE "#EC CI_BUFFSUBQ.CLIENT SPECIFIED WHERE a~mandt = b~client AS b

          ENDIF.
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
          IF gv_site IS INITIAL.
            LOOP AT lt_kna1 INTO ls_kna1.
            READ TABLE lt_kna1_key INTO ls_kna1_key WITH KEY kunnr = ls_kna1-kunnr.
            IF sy-subrc = 0.
              DELETE TABLE lt_kna1 FROM ls_kna1.
            ENDIF.
            CLEAR ls_kna1.
            CLEAR ls_kna1_key.
          ENDLOOP.
          ELSE.
            lt_kna1 = lt_kna1_key.
          ENDIF.
          LOOP AT lt_kna1 INTO ls_kna1 WHERE brsch IS NOT INITIAL .
            CONCATENATE ls_kna1-brsch 'Industry Not maintained in table ' 'TP038M2 in client'  ls_kna1-mandt 'kindly refer note 2210486' INTO ls_check_result-description IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT
            ls_check_result-return_code =  co_return_code-warning.
            APPEND ls_check_result TO ct_check_results.
            ls_industry_in-indkey = ls_kna1-brsch.
            append ls_industry_in to ct_industry_in.
*          clear ls_check_result.
          ENDLOOP.

          REFRESH lt_kna1.
          REFRESH lt_kna1_temp.
          REFRESH lt_kna1_key.
          REFRESH lt_keys.

        ENDDO.
* Outgoing Industry


        DATA : p_psize_kna1_2 TYPE integer VALUE '1000'.
        DATA : s_cursor_kna1_2 TYPE cursor.
        CLEAR s_cursor_kna1_2.
        IF s_cursor_kna1_2 IS INITIAL.
          IF iv_no IS INITIAL.
            OPEN CURSOR: s_cursor_kna1_2 FOR  SELECT DISTINCT * FROM kna1 "AS a  CLIENT SPECIFIED
              WHERE  brsch IS NOT NULL AND brsch NOT IN ( SELECT brsch FROM tp038m1   ). "#EC CI_NOFIELD #EC CI_NOWHERE "#EC CI_BUFFSUBQCLIENT SPECIFIED  WHERE a~mandt = b~client AS b
          ELSE.
            OPEN CURSOR: s_cursor_kna1_2 FOR  SELECT DISTINCT * FROM kna1 UP TO iv_no ROWS "AS a  CLIENT SPECIFIED
         WHERE  brsch IS NOT NULL AND brsch NOT IN ( SELECT brsch FROM tp038m1   ). "#EC CI_NOFIELD #EC CI_NOWHERE "#EC CI_BUFFSUBQCLIENT SPECIFIED  WHERE a~mandt = b~client AS b

          ENDIF.
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

          IF gv_site IS INITIAL.
          LOOP AT lt_kna1 INTO ls_kna1.
            READ TABLE lt_kna1_key INTO ls_kna1_key WITH KEY kunnr = ls_kna1-kunnr.
            IF sy-subrc = 0.
              DELETE TABLE lt_kna1 FROM ls_kna1.
            ENDIF.
            CLEAR ls_kna1.
            CLEAR ls_kna1_key.
          ENDLOOP.
          ELSE.
            lt_kna1 = lt_kna1_key.
          ENDIF.
          LOOP AT lt_kna1 INTO ls_kna1 WHERE brsch IS NOT INITIAL .
            CONCATENATE ls_kna1-brsch 'Industry Not maintained in table ' 'TP038M1 in client' ls_kna1-mandt 'kindly refer note 2210486' INTO ls_check_result-description IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT
            ls_check_result-return_code =  co_return_code-warning.
            APPEND ls_check_result TO ct_check_results.
            ls_industry_out-indkey = ls_kna1-brsch.
            append ls_industry_out to ct_industry_out.
*          clear ls_check_result.
          ENDLOOP.

          REFRESH lt_kna1.
          REFRESH lt_kna1_key.
          REFRESH lt_kna1_temp.

        ENDDO.
*	d Assign Payment Cards

        SELECT DISTINCT  * FROM vckun INTO CORRESPONDING FIELDS OF TABLE lt_payment WHERE ccins IS NOT NULL AND
                  ccins NOT IN ( SELECT ccins FROM cvic_ccid_link   ). "#EC CI_NOFIELD #EC CI_NOWHERE "#EC CI_BUFFSUBQ CLIENT SPECIFIED WHERE a~mandt = b~client AS b  AS a  CLIENT SPECIFIED

        LOOP AT lt_payment INTO ls_payment WHERE ccins IS NOT INITIAL.

          CONCATENATE ls_payment-ccins 'payment Card type not maintained in table' 'CVIC_CCID_LINK in client' ls_payment-mandt  'kindly refer note 2210486' INTO ls_check_result-description IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT
          ls_check_result-return_code =  co_return_code-warning.
          APPEND ls_check_result TO ct_check_results.
 ls_pcard-pcard = ls_payment-ccins.
            append ls_pcard to ct_pcard.
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


METHOD CHECK_VEND_PART_OF_RETAIL_SITE.
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
  DATA : lt_keys TYPE  vmds_vendor_numbers_t .
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
      ENDIF.

    ENDLOOP.

  ENDIF.




  IF lt_keys IS NOT INITIAL.
    SELECT lifnr werks FROM lfa1 CLIENT SPECIFIED INTO CORRESPONDING FIELDS OF TABLE lt_lfa1_temp  FOR ALL ENTRIES IN lt_keys WHERE lifnr = lt_keys-lifnr AND NOT werks = space. "#EC CI_NOFIRST
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


  METHOD CHECK_VEND_VALUE_MAPPING.
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



    DATA : lt_keys_vend TYPE  vmds_vendor_numbers_t .
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
data :   ls_industry_in like line of ct_industry_in,
            ls_industry_out like line of ct_industry_out
             .
    DATA : p_psize_lfa1 TYPE integer VALUE '1000'.  " Package size
*  DATA : s_cursor_lfa1_vend_map TYPE cursor.

*if gv_lfa1_vend_mapping is not initial.

    TRY.
        IF s_cursor_lfa1_vend_map IS INITIAL.
          if iv_no is INITIAL.
          OPEN CURSOR: s_cursor_lfa1_vend_map FOR SELECT * FROM lfa1 WHERE  brsch IS NOT NULL AND brsch
          NOT IN ( SELECT brsch FROM tp038m2  ). "#EC CI_NOFIELD #EC CI_NOWHERE "#EC CI_BUFFSUBQ. CLIENT SPECIFIED WHERE a~mandt = b~client  AS a CLIENT SPECIFIED  AS b
          else.
        OPEN CURSOR: s_cursor_lfa1_vend_map FOR SELECT * FROM lfa1  UP TO iv_no ROWS WHERE  brsch
        IS NOT NULL AND brsch NOT IN ( SELECT brsch FROM tp038m2  )."#EC CI_NOFIELD #EC CI_NOWHERE "#EC CI_BUFFSUBQ. CLIENT SPECIFIED WHERE a~mandt = b~client  AS a CLIENT


          endif.
        ENDIF.
        DO.
          FETCH NEXT CURSOR s_cursor_lfa1_vend_map INTO TABLE lt_lfa1 PACKAGE SIZE p_psize_lfa1.
          IF sy-subrc NE 0 .
            CLOSE CURSOR s_cursor_lfa1_vend_map.
            gv_lfa1_vend_mapping = 'X'.
            EXIT .
          ELSE.
            SORT lt_lfa1 BY mandt lifnr .

            LOOP AT lt_lfa1 INTO ls_lfa1.
              ls_key_vend-lifnr = ls_lfa1-kunnr .
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
  if gv_site is INITIAL.

          LOOP AT lt_lfa1 INTO ls_lfa1.
            READ TABLE lt_lfa1_key INTO ls_lfa1_key WITH KEY lifnr = ls_lfa1-lifnr.
            IF sy-subrc = 0.
              DELETE TABLE lt_lfa1 FROM ls_lfa1.
            ENDIF.
            CLEAR ls_lfa1.
            CLEAR ls_lfa1_key.
          ENDLOOP.
else.
  lt_lfa1 = lt_lfa1_key.
endif.
          LOOP AT  lt_lfa1  INTO ls_lfa1 WHERE brsch IS NOT INITIAL.
            CONCATENATE ls_lfa1-brsch 'Industry not maintained in table' 'TP038M2 in client' ls_lfa1-mandt  'kindly refer note 2210486' INTO ls_check_result-description IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT
            ls_check_result-return_code =  co_return_code-warning.
            APPEND ls_check_result TO ct_check_results.
                 ls_industry_in-indkey = ls_lfa1-brsch.
            append ls_industry_in to ct_industry_in.
*          clear ls_check_result.
          ENDLOOP.

          REFRESH lt_lfa1.
          REFRESH lt_lfa1_key.
          REFRESH lt_lfa1_temp.
          REFRESH lt_keys_vend.


        ENDDO.






*     outgoing Industry

        CLEAR s_cursor_lfa1.
        DATA : p_psize_lfa1_1.

        IF s_cursor_lfa1 IS INITIAL.
          if iv_no is INITIAL.
          OPEN CURSOR: s_cursor_lfa1 FOR SELECT * FROM lfa1  WHERE  brsch IS NOT NULL AND brsch NOT IN ( SELECT brsch FROM tp038m1   ). "#EC CI_NOFIELD #EC CI_NOWHERE "#EC CI_BUFFSUBQ. CLIENT SPECIFIED WHERE  a~mandt = b~client AS a CLIENT SPECIFIED AS b
          ELSE.
          OPEN CURSOR: s_cursor_lfa1 FOR SELECT * FROM lfa1  WHERE  brsch IS NOT NULL AND brsch NOT IN ( SELECT brsch FROM tp038m1   ). "#EC CI_NOFIELD #EC CI_NOWHERE "#EC CI_BUFFSUBQ. CLIENT SPECIFIED WHERE  a~mandt = b~client AS a CLIENT SPECIFIED AS b
          endif.
        ENDIF.
        DO.
          FETCH NEXT CURSOR s_cursor_lfa1 INTO TABLE lt_lfa1 PACKAGE SIZE p_psize_lfa1_1.
          IF sy-subrc NE 0 .
            CLOSE CURSOR s_cursor_lfa1.
            gv_lfa1_vend_mapping = 'X'.
            EXIT .
          ELSE.
            SORT lt_lfa1 BY mandt lifnr .

            LOOP AT lt_lfa1 INTO ls_lfa1.
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



if gv_site is INITIAL.

*            SELECT * FROM lfa1 AS a CLIENT SPECIFIED INTO CORRESPONDING FIELDS OF TABLE lt_lfa1  WHERE  brsch IS NOT NULL AND brsch NOT IN ( SELECT brsch FROM tp038m1 AS b CLIENT SPECIFIED WHERE  a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
          LOOP AT lt_lfa1 INTO ls_lfa1.
            READ TABLE lt_lfa1_key INTO ls_lfa1_key WITH KEY lifnr = ls_lfa1-lifnr.
            IF sy-subrc = 0.
              DELETE TABLE lt_lfa1 FROM ls_lfa1.
            ENDIF.
            CLEAR ls_lfa1.
            CLEAR ls_lfa1_key.
          ENDLOOP.
else.
 lt_lfa1 = lt_lfa1_key.
endif.

          LOOP AT  lt_lfa1  INTO ls_lfa1 WHERE brsch IS NOT INITIAL.
            CONCATENATE ls_lfa1-brsch 'Industry not maintained in table' 'TP038M2 in client'  'kindly refer note 2210486' ls_lfa1-mandt INTO ls_check_result-description IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT
            ls_check_result-return_code =  co_return_code-warning.
            APPEND ls_check_result TO ct_check_results.
                 ls_industry_out-indkey = ls_lfa1-brsch.
            append ls_industry_out to ct_industry_out.
*          clear ls_check_result.
          ENDLOOP.
          REFRESH lt_lfa1.
          REFRESH lt_lfa1_temp.
          REFRESH lt_lfa1_key.
          REFRESH lt_keys_vend.

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

  ENDMETHOD.


  METHOD compare_alpha_nriv.


    DATA: lv_percent           TYPE p12_perc,
          lv_return            TYPE  inri-returncode,
          lv_fromnumber        TYPE  nrlevel,
          lv_tonumber          TYPE  nrlevel,
          lv_depd_fromnumber   TYPE nrlevel,
          lv_source_fromnumber TYPE nrlevel,
          lv_depd_tonumber     TYPE nrlevel,
          lv_source_tonumber   TYPE nrlevel,
          ls_nriv_res          TYPE ts_nriv_res,
          ls_src               TYPE nriv,
*          lt_source_interval    TYPE nriv_tt,
          lt_dependent_nriv    TYPE tt_nriv_res.

    FIELD-SYMBOLS: <fs_nriv_source>    TYPE ts_nriv_res, <fs_nriv_dependent> TYPE ts_nriv_res.

    CL_S4_CHECKS_BP_ENH=>convert_alpha_tonum_nriv(
      EXPORTING
        it_alpha_nriv  = it_source_nriv
      IMPORTING
        et_number_nriv = et_num_alpha_intv
      EXCEPTIONS invalid_nr_format = 1
      OTHERS = 2 ).
    IF sy-subrc NE 0.
      RAISE invalid_nr_format.
    ENDIF.

    CL_S4_CHECKS_BP_ENH=>convert_alpha_tonum_nriv(
        EXPORTING
          it_alpha_nriv  = it_dependent_nriv
       IMPORTING
         et_number_nriv = lt_dependent_nriv
          EXCEPTIONS invalid_nr_format = 1
          OTHERS = 2 ).
    IF sy-subrc NE 0.
      RAISE invalid_nr_format.
    ENDIF.


* Check overlapping number ranges between customer and depdor
    LOOP AT et_num_alpha_intv ASSIGNING <fs_nriv_source> WHERE nrrangenr IS NOT INITIAL.

* Tmp
      MOVE-CORRESPONDING   <fs_nriv_source>   TO    ls_nriv_res.
      APPEND ls_nriv_res TO et_num_intv.

      LOOP AT lt_dependent_nriv ASSIGNING <fs_nriv_dependent> WHERE fromnumber >= <fs_nriv_source>-fromnumber.

        IF iv_act_ind = abap_true AND <fs_nriv_dependent>-nrlevel > 0.
          lv_tonumber =   <fs_nriv_dependent>-nrlevel.
        ELSE.
          lv_tonumber =  <fs_nriv_dependent>-tonumber.
        ENDIF.

        lv_fromnumber =  <fs_nriv_dependent>-fromnumber.

        lv_source_tonumber   = <fs_nriv_source>-tonumber.
        lv_source_fromnumber = <fs_nriv_source>-fromnumber.
        lv_depd_tonumber      = <fs_nriv_dependent>-tonumber.
        lv_depd_fromnumber    = <fs_nriv_dependent>-fromnumber.


        CALL METHOD CL_S4_CHECKS_BP_ENH=>check_alpha_nriv
          EXPORTING
            iv_depd_fromnumber   = lv_depd_fromnumber
            iv_source_fromnumber = lv_source_fromnumber
            iv_depd_tonumber     = lv_depd_tonumber
            iv_source_tonumber   = lv_source_tonumber
          IMPORTING
            ev_overlpercent      = lv_percent
            ev_return            = lv_return
          EXCEPTIONS
            interval_not_found   = 1
            OTHERS               = 2.

        IF sy-subrc NE 0.
          RETURN.
        ENDIF.

        READ TABLE et_num_alpha_intv INTO ls_src WITH KEY object = <fs_nriv_source>-object  nrrangenr = <fs_nriv_source>-nrrangenr.
        IF sy-subrc EQ 0.
          MOVE ls_src TO ls_nriv_res.
        ELSE.
          CONTINUE.
        ENDIF.
        IF lv_return = abap_false.
          MOVE lv_percent TO ls_nriv_res-percent.
          MOVE <fs_nriv_dependent>-object TO ls_nriv_res-depd_object.
          MOVE <fs_nriv_dependent>-nrrangenr TO ls_nriv_res-depd_nr.
          MOVE <fs_nriv_dependent>-fromnumber TO ls_nriv_res-depd_fromnr.
          MOVE <fs_nriv_dependent>-tonumber TO ls_nriv_res-depd_tonr.
          MOVE <fs_nriv_dependent>-nrlevel TO ls_nriv_res-depd_nrlevel.
          APPEND ls_nriv_res TO et_overlapping_nriv.
        ELSE.
          MOVE-CORRESPONDING <fs_nriv_source> TO ls_nriv_res.
          MOVE <fs_nriv_dependent>-object TO ls_nriv_res-depd_object.
          MOVE <fs_nriv_dependent>-nrrangenr TO ls_nriv_res-depd_nr.
          MOVE <fs_nriv_dependent>-fromnumber TO ls_nriv_res-depd_fromnr.
          MOVE <fs_nriv_dependent>-tonumber TO ls_nriv_res-depd_tonr.
          MOVE <fs_nriv_dependent>-nrlevel TO ls_nriv_res-depd_nrlevel.
          APPEND ls_nriv_res TO et_no_overlapping_nriv.
        ENDIF.
      ENDLOOP.

    ENDLOOP.


  ENDMETHOD.


  METHOD compare_detm_new_cmn_nriv.

    DATA: lv_noov                TYPE boolean VALUE abap_false,
          ls_nriv                TYPE  ts_nriv_res,
          lt_cust_nriv           TYPE nriv_tt,
          lt_vend_nriv           TYPE nriv_tt,
          lt_bp_nriv             TYPE nriv_tt,
          lt_source_nriv         TYPE nriv_tt,
          lt_dependent_nriv      TYPE nriv_tt,
          lt_new_nriv            TYPE tt_nriv_res,
          lt_overlapping_nriv    TYPE tt_nriv_res,
          lt_no_overlapping_nriv TYPE tt_nriv_res,
          ls_cvi_nriv            TYPE ty_cvi_nriv,
          lt_cvi_nriv            TYPE STANDARD TABLE OF ty_cvi_nriv.


    FIELD-SYMBOLS: <fs_nriv_source>    TYPE nriv, <fs_nriv_dependent> TYPE nriv.

    CL_S4_CHECKS_BP_ENH=>get_all_cvi_nriv(
    EXPORTING
       iv_bp_ind   =  iv_bp_ind
       iv_num_ind  =  abap_true
        IMPORTING
          et_cvi_nriv =  lt_cvi_nriv
        EXCEPTIONS
          wrong_nriv_format = 1
          OTHERS            = 2
              ).
    IF sy-subrc <> 0.
*     Implement suitable error handling here
    ENDIF.

    DESCRIBE TABLE it_new_requ_nriv LINES sy-tfill.
    IF sy-tfill <> 1.
      RAISE invalid_nr.
    ENDIF.

    APPEND LINES OF it_new_requ_nriv TO lt_dependent_nriv.

    WHILE lv_noov = abap_false.

      lv_noov = abap_true.

      LOOP AT lt_cvi_nriv INTO ls_cvi_nriv.

        CLEAR:  lt_source_nriv, lt_overlapping_nriv, lt_no_overlapping_nriv.



        APPEND LINES OF ls_cvi_nriv-cvi_sub TO  lt_source_nriv.
        IF lt_dependent_nriv IS INITIAL.
          APPEND LINES OF it_new_requ_nriv TO  lt_dependent_nriv.
        ENDIF.


        CL_S4_CHECKS_BP_ENH=>compare_nriv(
         EXPORTING
           iv_act_ind             = abap_false
           it_source_nriv         = lt_source_nriv
           it_dependent_nriv      = lt_dependent_nriv
         IMPORTING
           et_overlapping_nriv    = lt_overlapping_nriv
           et_no_overlapping_nriv = lt_no_overlapping_nriv
           ).

        IF lt_overlapping_nriv IS NOT INITIAL.

          CLEAR  lt_new_nriv.
          lv_noov = abap_false.

          APPEND LINES OF lt_source_nriv TO  lt_new_nriv.

          CL_S4_CHECKS_BP_ENH=>determine_new_nriv(
             EXPORTING
               iv_act_ind             = abap_false
               it_overlapping_nriv    = lt_overlapping_nriv
               it_no_overlapping_nriv = lt_no_overlapping_nriv
             CHANGING
               ct_new_nriv            = lt_new_nriv
             EXCEPTIONS
               invalid_number         = 1
               exceeds_number         = 2
               OTHERS                 = 3  ).

          IF sy-subrc <> 0.
            RAISE invalid_nr.
*   Implement suitable error handling here
          ENDIF.
*Only new one can exist.
          READ TABLE lt_new_nriv INTO ls_nriv WITH KEY  nr_new = abap_true.
          IF sy-subrc EQ 0.
            DELETE lt_dependent_nriv INDEX 1.
            APPEND ls_nriv TO lt_dependent_nriv.
          ENDIF.
        ENDIF.
      ENDLOOP.

    ENDWHILE.

    APPEND LINES OF lt_dependent_nriv TO et_new_cmn_nriv.


  ENDMETHOD.


  METHOD compare_nriv.

    DATA: lv_percent    TYPE p12_perc,
          lv_return     TYPE  inri-returncode,
          lv_fromnumber TYPE  numc10,
          lv_tonumber   TYPE  numc10,
          ls_nriv_res   TYPE ts_nriv_res.

    FIELD-SYMBOLS: <fs_nriv_source>    TYPE nriv, <fs_nriv_dependent> TYPE nriv.


* Check overlapping number ranges between source nr e.g customer and dependent nr e.g. vendor
    LOOP AT it_source_nriv ASSIGNING <fs_nriv_source> WHERE nrrangenr IS NOT INITIAL.

      LOOP AT it_dependent_nriv ASSIGNING <fs_nriv_dependent>." WHERE fromnumber >= <fs_nriv_source>-fromnumber.

        CLEAR lv_return.


        CLEAR ls_nriv_res.

        IF iv_act_ind = abap_true AND <fs_nriv_dependent>-nrlevel > 0.
          lv_tonumber =   <fs_nriv_dependent>-nrlevel.
        ELSE.
          lv_tonumber =  <fs_nriv_dependent>-tonumber.
        ENDIF.


        lv_fromnumber =  <fs_nriv_dependent>-fromnumber.

          CL_S4_CHECKS_BP_ENH=>check_nriv(
             EXPORTING
               iv_range_nr        =     <fs_nriv_source>-nrrangenr
               iv_fromnumber      =     lv_fromnumber
               iv_tonumber        =     lv_tonumber
               iv_object          =     <fs_nriv_source>-object
               iv_src_fromnumber = <fs_nriv_source>-fromnumber
               iv_src_nrlevel = <fs_nriv_source>-nrlevel
               iv_src_tonumber = <fs_nriv_source>-tonumber
               iv_acttonum       =     iv_act_ind
             IMPORTING
               ev_return          =     lv_return
               ev_overlpercent   = lv_percent
             EXCEPTIONS
               interval_not_found = 1
               OTHERS             = 2 ) .

          IF sy-subrc NE 0.
            RETURN.
          ENDIF.

        CLEAR ls_nriv_res.
* Overlapp
        MOVE-CORRESPONDING <fs_nriv_source> TO ls_nriv_res.
        MOVE lv_percent TO ls_nriv_res-percent.
        MOVE <fs_nriv_dependent>-object TO ls_nriv_res-depd_object.
        MOVE <fs_nriv_dependent>-nrrangenr TO ls_nriv_res-depd_nr.
        MOVE <fs_nriv_dependent>-fromnumber TO ls_nriv_res-depd_fromnr.
        MOVE <fs_nriv_dependent>-tonumber TO ls_nriv_res-depd_tonr.
        MOVE <fs_nriv_dependent>-nrlevel TO ls_nriv_res-depd_nrlevel.
        IF lv_return = abap_false.

          APPEND ls_nriv_res TO et_overlapping_nriv.
        ELSE.

          APPEND ls_nriv_res TO et_no_overlapping_nriv.

        ENDIF.
*
      ENDLOOP.
*      IF sy-subrc <> 0.
*        APPEND <fs_nriv_source> TO et_no_overlapping_interval.
*      ENDIF.


    ENDLOOP.

*    SORT  CT_OVERLAPPING_INTERVAL.
*
*    DELETE ADJACENT DUPLICATES FROM CT_OVERLAPPING_INTERVAL.

*  LOOP AT ET_OVERLapping_interval INTO LS_NRIV_RES.
** Check Numberrange with BP ID
*    WRITE:/  ET_OVERLapping_interval-OBJECT,GS_NRIV_RES-NRRANGENR, 'Overlapping Percentage', GS_NRIV_RES-PERCENT, 'with ',
*    GS_NRIV_RES-depd_OBJECT, GS_NRIV_RES-depd_NR.
*  ENDLOOP.
*

  ENDMETHOD.


  METHOD comp_detm_alpha_new_cmn_nriv.

    DATA: lv_noov                TYPE boolean,
          ls_nriv                TYPE  ts_nriv_res,
          lt_cust_nriv           TYPE nriv_tt,
          lt_vend_nriv           TYPE nriv_tt,
          lt_bp_nriv             TYPE nriv_tt,
          lt_source_nriv         TYPE nriv_tt,
          lt_dependent_nriv      TYPE nriv_tt,
          lt_new_nriv            TYPE tt_nriv_res,
          lt_overlapping_nriv    TYPE tt_nriv_res,
          lt_no_overlapping_nriv TYPE tt_nriv_res,
          lt_new_num_alpha_nriv  TYPE tt_nriv_res,
          ls_cvi_nriv            TYPE ty_cvi_nriv,
          lt_cvi_nriv            TYPE STANDARD TABLE OF ty_cvi_nriv.


    FIELD-SYMBOLS: <fs_nriv_source>    TYPE nriv, <fs_nriv_dependent> TYPE nriv.

    CL_S4_CHECKS_BP_ENH=>get_all_cvi_nriv(
    EXPORTING
      iv_bp_ind        =     iv_bp_ind
      iv_num_ind       =     abap_true
        IMPORTING
          et_cvi_nriv =  lt_cvi_nriv
        EXCEPTIONS
          wrong_nriv_format = 1
          OTHERS            = 2
              ).
    IF sy-subrc <> 0.
*     Implement suitable error handling here
    ENDIF.

    DESCRIBE TABLE it_new_requ_nriv LINES sy-tfill.
    IF sy-tfill <> 1.
      RAISE invalid_nr.
    ENDIF.

    APPEND LINES OF it_new_requ_nriv TO lt_dependent_nriv.

    WHILE lv_noov = abap_false.

            lv_noov = abap_true.

      LOOP AT lt_cvi_nriv INTO ls_cvi_nriv WHERE alpha_cvi_sub IS NOT INITIAL.

        CLEAR:  lt_source_nriv, lt_overlapping_nriv, lt_no_overlapping_nriv.

        APPEND LINES OF ls_cvi_nriv-alpha_cvi_sub TO  lt_source_nriv.
        IF lt_dependent_nriv IS INITIAL.
          APPEND LINES OF it_new_requ_nriv TO  lt_dependent_nriv.
        ENDIF.


        CL_S4_CHECKS_BP_ENH=>compare_alpha_nriv(
         EXPORTING
           iv_act_ind             = abap_false
           it_source_nriv         = lt_source_nriv
           it_dependent_nriv      = lt_dependent_nriv
         IMPORTING
           et_overlapping_nriv    = lt_overlapping_nriv
           et_no_overlapping_nriv = lt_no_overlapping_nriv
            et_num_alpha_intv =    lt_new_num_alpha_nriv
           ).

        IF lt_overlapping_nriv IS NOT INITIAL.

          CLEAR  lt_new_nriv.
          lv_noov = abap_false.

          APPEND LINES OF lt_new_num_alpha_nriv  TO  lt_new_nriv.

          CL_S4_CHECKS_BP_ENH=>determine_new_nriv(
             EXPORTING
               iv_alpha_ind           = abap_true
               iv_act_ind             = abap_false
               it_overlapping_nriv    = lt_overlapping_nriv
               it_no_overlapping_nriv = lt_no_overlapping_nriv
             CHANGING
               ct_new_nriv            = lt_new_nriv
             EXCEPTIONS
               invalid_number         = 1
               exceeds_number         = 2
               OTHERS                 = 3  ).

          IF sy-subrc <> 0.
            RAISE invalid_nr.
*   Implement suitable error handling here
          ENDIF.
*Only new one can exist.
          READ TABLE lt_new_nriv INTO ls_nriv WITH KEY  nr_new = abap_true.
          IF sy-subrc EQ 0.
            DELETE lt_dependent_nriv INDEX 1.
            APPEND ls_nriv TO lt_dependent_nriv.
          ENDIF.
        ENDIF.
      ENDLOOP.

    ENDWHILE.

    APPEND LINES OF lt_dependent_nriv TO et_new_cmn_nriv.


  ENDMETHOD.


  METHOD CONVERT_ALPHA_TONUM.

  Data:   lv_num_new   TYPE num2,
          lv_num_tmp   TYPE num1,
          lv_length    TYPE i,
          lv_cnt       TYPE num2,
          lv_index     TYPE num2.


    lv_length = strlen( iv_alpha ).

    CLEAR cv_numeric.

    DO lv_length TIMES.

      lv_cnt = sy-index.
      lv_index = sy-index - 1.

      CALL METHOD CL_S4_CHECKS_BP_ENH=>calc_base36_2digit
        EXPORTING
          it_alpha = it_alpha
          iv_alpha_ind = iv_alpha+lv_index(1)
        IMPORTING
          cv_new   = lv_num_new.

*(zn-1 * bn-1 + zn-2 * bn-2 + # + z0 * b0)36
      IF lv_num_new > 0.
        IF lv_num_new < 10.
          lv_num_tmp = lv_num_new+1(1).
          cv_numeric = ( lv_num_tmp  * ( 36 ** ( lv_length - lv_cnt ) ) ) + cv_numeric .
        ELSE.
          cv_numeric = ( lv_num_new * ( 36 ** ( lv_length  - lv_cnt ) ) ) + cv_numeric .
        ENDIF.
      ENDIF.

    ENDDO.



  ENDMETHOD.


  METHOD convert_alpha_tonum_nriv.

    TYPES : BEGIN OF ty_alpha,
              code1 TYPE char1,
              code2 TYPE num2,
            END OF ty_alpha.  "Type for Mapping table : 1 character to 2 character code

*    CONSTANTS: gc_charnum(36) TYPE c  VALUE '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'.


* Local data declaration
    DATA: lv_fromnumber  TYPE  nrlevel,
          lv_tonumber    TYPE  nrlevel,
          ls_number_nriv LIKE LINE OF et_number_nriv,
          ls_alpha       TYPE ty_alpha,
          lv_count       TYPE i,
          lv_offset      TYPE i.


    FIELD-SYMBOLS: <fs_nriv> TYPE nriv.

    CLEAR gt_alpha.

*populating internal table with 1 to 2 character mapping.
    lv_count = 0.
    lv_offset = 0.

    DO 36 TIMES.
      ls_alpha-code2 = lv_count.
      IF lv_count <= 9 .
        ls_alpha-code1 = lv_count.
      ELSE.
        ls_alpha-code1 = sy-abcde+lv_offset(1).
        lv_offset = lv_offset + 1.
      ENDIF.
      lv_count = lv_count + 1.
      APPEND ls_alpha TO gt_alpha.
      CLEAR ls_alpha.
    ENDDO.

    LOOP AT it_alpha_nriv ASSIGNING <fs_nriv> WHERE nrrangenr IS NOT INITIAL.
      IF NOT <fs_nriv>-fromnumber CA gc_charnum OR NOT <fs_nriv>-tonumber CA gc_charnum.
        RAISE invalid_nr_format.
      ENDIF.
      MOVE <fs_nriv> TO ls_number_nriv.
      CLEAR:  ls_number_nriv-fromnumber,  ls_number_nriv-tonumber.
      CL_S4_CHECKS_BP_ENH=>convert_alpha_tonum(
        EXPORTING
          iv_alpha   =  <fs_nriv>-fromnumber
          it_alpha   = gt_alpha
        CHANGING
          cv_numeric = lv_fromnumber ).
* Conversion  Tmp must be adapted to the right length
      MOVE lv_fromnumber TO ls_number_nriv-fromnumber.

      CL_S4_CHECKS_BP_ENH=>convert_alpha_tonum(
             EXPORTING
               iv_alpha   = <fs_nriv>-tonumber
               it_alpha   = gt_alpha
             CHANGING
               cv_numeric = lv_tonumber ).
      MOVE lv_tonumber TO ls_number_nriv-tonumber.
      MOVE <fs_nriv>-fromnumber TO ls_number_nriv-src_fromnr.
      MOVE <fs_nriv>-tonumber TO ls_number_nriv-src_tonr.
      APPEND ls_number_nriv TO et_number_nriv.

    ENDLOOP.


  ENDMETHOD.


  METHOD convert_num_toalpha.

    IF  iv_numeric CA sy-abcde.
      RAISE invalid_number.
    ENDIF.

    DATA: l_zahl(16)    TYPE p.
    DATA: l_zahl_36(20) TYPE c.
    DATA: l_off         LIKE sy-fdpos VALUE 19.
    DATA: l_mod(2)      TYPE n.

    FIELD-SYMBOLS: <fs> TYPE ANY.

    CONSTANTS: c_zmenge(36) VALUE '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'.
    CONSTANTS: c_zero(20) TYPE c VALUE '00000000000000000000'.


    l_zahl = iv_numeric.
    WHILE l_zahl GE 36.
      l_mod = l_zahl MOD 36.
      ASSIGN c_zmenge+l_mod(1) TO <fs>.
      l_zahl_36+l_off(1) = <fs>.
      l_off = l_off - 1.
      IF l_off LT 0.
        RAISE overflow.
      ENDIF.
      l_zahl = ( l_zahl - l_mod ) DIV 36.
    ENDWHILE.

    ASSIGN c_zmenge+l_zahl(1) TO <fs>.
    l_zahl_36+l_off(1) = <fs>.
    OVERLAY l_zahl_36 WITH c_zero ONLY space.
    cv_alpha = l_zahl_36.

    SHIFT cv_alpha LEFT DELETING LEADING '0'.



  ENDMETHOD.


  METHOD convert_num_toalpha_nriv.

* Local data declaration
    DATA: lv_fromnumber  TYPE  char20,
          lv_tonumber    TYPE  char20,
          ls_number_nriv TYPE ts_nriv_res.

    FIELD-SYMBOLS: <fs_nriv> TYPE ts_nriv_res.

    LOOP AT it_number_nriv ASSIGNING <fs_nriv> WHERE nrrangenr IS NOT INITIAL.
      MOVE <fs_nriv> TO ls_number_nriv.
      CLEAR:  ls_number_nriv-fromnumber,  ls_number_nriv-tonumber.
      CL_S4_CHECKS_BP_ENH=>convert_num_toalpha(
        EXPORTING
          iv_numeric   =  <fs_nriv>-fromnumber
        CHANGING
          cv_alpha  = lv_fromnumber
           EXCEPTIONS  invalid_number = 1 OTHERS         = 2  ).
      IF sy-subrc NE 0.
        RAISE interval_not_found.
      ENDIF.
* Conversion  Tmp must be adapted to the right length
      MOVE lv_fromnumber TO ls_number_nriv-fromnumber.

      CL_S4_CHECKS_BP_ENH=>convert_num_toalpha(
             EXPORTING
               iv_numeric   = <fs_nriv>-tonumber
             CHANGING
               cv_alpha = lv_tonumber  EXCEPTIONS  invalid_number = 1 OTHERS         = 2 ).
      IF sy-subrc NE 0.
        RAISE interval_not_found.
      ENDIF.
      MOVE lv_tonumber TO ls_number_nriv-tonumber.
      APPEND ls_number_nriv TO et_alpha_nriv.
    ENDLOOP.

  ENDMETHOD.


  METHOD determine_new_nriv.

    DATA:
      lv_newfill             TYPE sy-tfill,
      lv_index               TYPE i,
      lv_next                TYPE i,
      lv_chng                TYPE boolean VALUE abap_true,
      lv_subrc               TYPE sy-subrc,
      ls_nriv_next           TYPE ts_nriv_res,
      ls_nriv_tmp            TYPE ts_nriv_res,
      ls_tmp                 TYPE ts_nriv_res,
      ls_nriv_res            TYPE ts_nriv_res,
      lv_act_ind             TYPE xflag,
      lt_no_overlapping_nriv TYPE tt_nriv_res,
      lt_overlapping_nriv    TYPE tt_nriv_res.

    FIELD-SYMBOLS: <fs_ov_nriv>     TYPE ts_nriv_res.
    IF  cv_nr_factor IS INITIAL.
      cv_nr_factor = 1.
    ENDIF.
    lv_act_ind = iv_act_ind.
* Only for numeric  numbers an actual number exist.
    IF iv_alpha_ind IS NOT INITIAL.
      CLEAR lv_act_ind.
    ENDIF.

* Determine number of lines before change
    DESCRIBE TABLE  ct_new_nriv LINES  lv_newfill.

    lt_overlapping_nriv = it_overlapping_nriv.
    lt_no_overlapping_nriv = it_no_overlapping_nriv.

    SORT lt_no_overlapping_nriv BY fromnumber.

    SORT ct_new_nriv BY fromnumber.
*Check wether overlapping exist.
    IF lt_overlapping_nriv IS NOT INITIAL.
* Take also the not overlapping number ranges into account for the new ranges
      LOOP AT lt_no_overlapping_nriv INTO ls_nriv_res.
        READ TABLE  lt_overlapping_nriv INTO ls_tmp WITH  KEY depd_object =  ls_nriv_res-depd_object  depd_nr   =  ls_nriv_res-depd_nr.
        IF sy-subrc NE 0.
*Add already processed nr ranges.
          MOVE-CORRESPONDING ls_nriv_res TO ls_nriv_tmp.
          APPEND ls_nriv_tmp TO lt_overlapping_nriv.
        ENDIF.
      ENDLOOP.
    ELSE.
*No Overlapping exist add depedent nr to new nr
      LOOP AT lt_no_overlapping_nriv INTO ls_nriv_res.
        READ TABLE ct_new_nriv TRANSPORTING NO FIELDS  WITH  KEY object =  ls_nriv_res-depd_object  nrrangenr   =  ls_nriv_res-depd_nr.
        IF sy-subrc <> 0.
          MOVE ls_nriv_res-depd_object TO ls_nriv_tmp-object.
          MOVE ls_nriv_res-depd_nr TO ls_nriv_tmp-nrrangenr.
          MOVE ls_nriv_res-depd_fromnr TO ls_nriv_tmp-fromnumber.
          MOVE ls_nriv_res-depd_tonr TO ls_nriv_tmp-tonumber.
          APPEND ls_nriv_tmp TO  ct_new_nriv.
        ENDIF.
      ENDLOOP.
    ENDIF.

    SORT lt_overlapping_nriv BY fromnumber.

    CLEAR:  ls_nriv_res, ls_nriv_tmp.
* Check overlapping number ranges between customer and depdor
    LOOP AT lt_overlapping_nriv ASSIGNING <fs_ov_nriv> WHERE nrrangenr IS NOT INITIAL.

      lv_chng  = abap_true.

      READ TABLE ct_new_nriv INTO ls_nriv_res BINARY SEARCH WITH KEY fromnumber = <fs_ov_nriv>-depd_fromnr.
      lv_subrc = sy-subrc.
      lv_index = sy-tabix.
      IF sy-subrc NE 0.
        CLEAR ls_nriv_res.
      ELSE.
        IF iv_alpha_ind IS NOT INITIAL.
          IF ls_nriv_res-src_fromnr(1) CO '0123456789' OR
            ls_nriv_res-src_tonr(1) CO '0123456789'.
            RAISE wrong_start_limit.
          ENDIF.
        ENDIF.
      ENDIF.

      MOVE-CORRESPONDING  ls_nriv_res TO  ls_nriv_tmp.

      MOVE <fs_ov_nriv>-depd_object TO ls_nriv_tmp-object.
      MOVE <fs_ov_nriv>-depd_nr TO ls_nriv_tmp-nrrangenr.


      IF lv_subrc < 8.
        IF lv_subrc = 4.
* Nothing found index points to next entry retrieve prev entry
          IF lv_index > 1.
            lv_index  = lv_index  - 1.
          ENDIF.
        ENDIF.
        READ TABLE ct_new_nriv INTO ls_nriv_res INDEX lv_index .

*Check next entry
        lv_next = lv_index + 1.
        LOOP AT  ct_new_nriv INTO ls_nriv_next FROM lv_next.

          MOVE <fs_ov_nriv>-depd_object TO ls_nriv_tmp-object.
          MOVE <fs_ov_nriv>-depd_nr TO ls_nriv_tmp-nrrangenr.


          CL_S4_CHECKS_BP_ENH=>calc_new_nriv(
              EXPORTING  iv_act_ind = lv_act_ind iv_nr_factor = cv_nr_factor  is_act_nr   = ls_nriv_res  is_next_nr = ls_nriv_next iv_alpha_ind = iv_alpha_ind is_ov_nr = <fs_ov_nriv>
              CHANGING   cs_new_nr = ls_nriv_tmp
              EXCEPTIONS exceeds_number   = 1 OTHERS = 2 ).

          IF sy-subrc <> 0.
            RAISE invalid_number.
          ENDIF.

          IF ls_nriv_tmp IS NOT INITIAL.
            CLEAR ls_nriv_tmp-nrlevel.
            ls_nriv_tmp-nr_new = abap_true.
            INSERT ls_nriv_tmp INTO  ct_new_nriv INDEX lv_next.
            lv_chng = abap_false.
            EXIT.
          ELSE.
            lv_index = lv_index + 1.
            lv_next = lv_index + 1.
            MOVE ls_nriv_next TO ls_nriv_res.
          ENDIF.
        ENDLOOP.
      ENDIF.

* Will addd to the end
      IF lv_chng = abap_true.
*        CLEAR lv_delta.
        DESCRIBE TABLE ct_new_nriv LINES  sy-tfill.
        READ TABLE ct_new_nriv INTO ls_nriv_res INDEX sy-tfill.

        MOVE <fs_ov_nriv>-depd_object TO ls_nriv_tmp-object.
        MOVE <fs_ov_nriv>-depd_nr TO ls_nriv_tmp-nrrangenr.

* No next entry exist
        CLEAR ls_nriv_next.
        CL_S4_CHECKS_BP_ENH=>calc_new_nriv(
         EXPORTING  iv_act_ind = lv_act_ind   iv_nr_factor = cv_nr_factor  is_act_nr   = ls_nriv_res is_next_nr = ls_nriv_next iv_alpha_ind = iv_alpha_ind is_ov_nr = <fs_ov_nriv>
         CHANGING   cs_new_nr = ls_nriv_tmp
         EXCEPTIONS exceeds_number   = 1   OTHERS          = 2 ).

        IF sy-subrc <> 0.
          RAISE exceeds_number.
        ENDIF.
        CLEAR ls_nriv_tmp-nrlevel.
        ls_nriv_tmp-nr_new = abap_true.
        APPEND  ls_nriv_tmp TO  ct_new_nriv.
      ENDIF.

    ENDLOOP.

    DATA lv_fill_src TYPE sy-tfill.
    DATA lv_fill_trg TYPE sy-tfill.

    DESCRIBE TABLE  ct_new_nriv LINES  lv_fill_src.
    IF lt_overlapping_nriv IS NOT INITIAL.
      DESCRIBE TABLE  lt_overlapping_nriv LINES lv_fill_trg.

      lv_fill_trg = lv_fill_trg + lv_newfill.
    ELSE.
      lv_fill_trg = lv_fill_src.
    ENDIF.


    IF  lv_fill_src <> lv_fill_trg.
      RAISE invalid_number.
    ENDIF.

    SORT ct_new_nriv BY fromnumber.
  ENDMETHOD.


method GET_ALL_CVI_NRIV.

    DATA:    ls_cvi_nriv TYPE  ty_cvi_nriv.


    DATA: lc_object      TYPE inri-object VALUE 'BU_PARTNER',
          lc_object_cust TYPE inri-object VALUE 'DEBITOR',
          lc_object_depd TYPE inri-object VALUE 'KREDITOR',
          lv_object_cnt  TYPE sy-index.

    DATA: lt_t077k TYPE TABLE OF t077k,
          lt_t077d TYPE TABLE OF t077d,
          lt_tb001 TYPE TABLE OF tb001.

    DATA: lt_cust_nriv       TYPE nriv_tt,
          lt_vend_nriv       TYPE nriv_tt,
          lt_bp_nriv         TYPE nriv_tt,
          lt_cust_alpha_nriv TYPE nriv_tt,
          lt_vend_alpha_nriv TYPE nriv_tt,
          lt_bp_alpha_nriv   TYPE nriv_tt.

    SELECT * FROM t077d INTO TABLE lt_t077d.
    SELECT * FROM t077k INTO TABLE lt_t077k.
    SELECT * FROM  tb001 INTO TABLE lt_tb001.

    SELECT * FROM nriv INTO TABLE lt_cust_nriv WHERE  object = lc_object_cust.
*    SELECT * FROM nriv INTO TABLE lt_cust_nriv FOR ALL ENTRIES IN lt_t077d WHERE  object = lc_object_cust AND nrrangenr =  lt_t077d-numkr.
    IF sy-subrc = 0.
*Customer
*Check and separate alphanumeric number ranges
      IF iv_num_ind IS NOT INITIAL.
        CL_S4_CHECKS_BP_ENH=>check_detm_range(
              IMPORTING  et_alpha_nriv     = lt_cust_alpha_nriv
              CHANGING      ct_nriv           = lt_cust_nriv
          EXCEPTIONS    wrong_nriv_format = 1  OTHERS            = 2 ).
        IF sy-subrc NE 0.
          RAISE wrong_nriv_format.
        ENDIF.
      ENDIF.
      ls_cvi_nriv-id = 1.
      APPEND LINES OF lt_cust_nriv TO ls_cvi_nriv-cvi_sub.
       APPEND LINES OF lt_cust_alpha_nriv TO ls_cvi_nriv-alpha_cvi_sub.
      APPEND ls_cvi_nriv TO  et_cvi_nriv.
    ENDIF.
*    SELECT * FROM nriv INTO TABLE lt_vend_nriv FOR ALL ENTRIES IN lt_t077k WHERE  object = lc_object_depd AND nrrangenr =  lt_t077k-numkr.
    SELECT * FROM nriv INTO TABLE lt_vend_nriv WHERE  object = lc_object_depd.
    IF sy-subrc = 0.

      IF iv_num_ind IS NOT INITIAL.
*Vendor
*Check and separate alphanumeric number ranges
        CL_S4_CHECKS_BP_ENH=>check_detm_range(
          IMPORTING et_alpha_nriv     = lt_vend_alpha_nriv
          CHANGING      ct_nriv           = lt_vend_nriv
          EXCEPTIONS    wrong_nriv_format = 1  OTHERS            = 2 ).
        IF sy-subrc NE 0.
          RAISE wrong_nriv_format.
        ENDIF.
      ENDIF.

      CLEAR ls_cvi_nriv.
      ls_cvi_nriv-id = 2.
      APPEND LINES OF lt_vend_nriv TO ls_cvi_nriv-cvi_sub.
       APPEND LINES OF lt_vend_alpha_nriv TO ls_cvi_nriv-alpha_cvi_sub.
      APPEND ls_cvi_nriv TO  et_cvi_nriv.

    ENDIF.
    IF  iv_bp_ind  = abap_true.
*      SELECT * FROM nriv INTO TABLE lt_bp_nriv FOR ALL ENTRIES IN lt_tb001 WHERE  object = lc_object AND nrrangenr =  lt_tb001-nrrng.
      SELECT * FROM nriv INTO TABLE lt_bp_nriv WHERE  object = lc_object.
      IF sy-subrc = 0.
*BP
*Check and separate alphanumeric number ranges
        CL_S4_CHECKS_BP_ENH=>check_detm_range(
         IMPORTING  et_alpha_nriv     = lt_bp_alpha_nriv
              CHANGING      ct_nriv           = lt_bp_nriv
              EXCEPTIONS    wrong_nriv_format = 1  OTHERS            = 2 ).
        IF sy-subrc NE 0.
          RAISE wrong_nriv_format.
        ENDIF.
        CLEAR ls_cvi_nriv.
        ls_cvi_nriv-id = 3.
        APPEND LINES OF lt_bp_nriv TO ls_cvi_nriv-cvi_sub.
          APPEND LINES OF lt_bp_alpha_nriv TO ls_cvi_nriv-alpha_cvi_sub.
        APPEND ls_cvi_nriv TO  et_cvi_nriv.

      ENDIF.
    ENDIF.

endmethod.


method GET_ALL_CVI_NRIV_FILTER.

    DATA: lc_object      TYPE inri-object VALUE 'BU_PARTNER',
          lc_object_cust TYPE inri-object VALUE 'DEBITOR',
          lc_object_depd TYPE inri-object VALUE 'KREDITOR'.

    DATA: lt_t077k TYPE TABLE OF t077k,
          lt_t077d TYPE TABLE OF t077d,
          lt_tb001 TYPE TABLE OF tb001.

    DATA: lt_cust_nriv       TYPE nriv_tt,
          lt_vend_nriv       TYPE nriv_tt,
          lt_bp_nriv         TYPE nriv_tt,
          lt_cust_alpha_nriv TYPE nriv_tt,
          lt_vend_alpha_nriv TYPE nriv_tt,
          lt_bp_alpha_nriv   TYPE nriv_tt.

    SELECT * FROM t077d INTO TABLE lt_t077d.
    SELECT * FROM t077k INTO TABLE lt_t077k.
    SELECT * FROM  tb001 INTO TABLE lt_tb001.

**    SELECT * FROM nriv INTO TABLE lt_cust_nriv FOR ALL ENTRIES IN lt_t077d WHERE  object = lc_object_cust AND nrrangenr =  lt_t077d-numkr.
**    SELECT * FROM nriv INTO TABLE lt_vend_nriv FOR ALL ENTRIES IN lt_t077k WHERE  object = lc_object_depd AND nrrangenr =  lt_t077k-numkr.
**    IF  iv_bp_ind  = abap_true.
**      SELECT * FROM nriv INTO TABLE lt_bp_nriv FOR ALL ENTRIES IN lt_tb001 WHERE  object = lc_object AND nrrangenr =  lt_tb001-nrrng.
**    ENDIF.

    SELECT * FROM nriv INTO TABLE lt_cust_nriv WHERE  object = lc_object_cust.
    SELECT * FROM nriv INTO TABLE lt_vend_nriv WHERE  object = lc_object_depd.
    IF  iv_bp_ind  = abap_true.
      SELECT * FROM nriv INTO TABLE lt_bp_nriv WHERE  object = lc_object.
    ENDIF.

*Customer
*Check and separate alphanumeric number ranges
    CL_S4_CHECKS_BP_ENH=>check_detm_range(
      IMPORTING     et_alpha_nriv     = lt_cust_alpha_nriv
      CHANGING      ct_nriv           = lt_cust_nriv
      EXCEPTIONS    wrong_nriv_format = 1  OTHERS            = 2 ).
    IF sy-subrc NE 0.
      RAISE wrong_nriv_format.
    ENDIF.

*Vendor
*Check and separate alphanumeric number ranges
    CL_S4_CHECKS_BP_ENH=>check_detm_range(
      IMPORTING     et_alpha_nriv     = lt_vend_alpha_nriv
      CHANGING      ct_nriv           = lt_vend_nriv
      EXCEPTIONS    wrong_nriv_format = 1  OTHERS            = 2 ).
    IF sy-subrc NE 0.
      RAISE wrong_nriv_format.
    ENDIF.

*BP
*Check and separate alphanumeric number ranges
    CL_S4_CHECKS_BP_ENH=>check_detm_range(
      IMPORTING     et_alpha_nriv     = lt_bp_alpha_nriv
      CHANGING      ct_nriv           = lt_bp_nriv
      EXCEPTIONS    wrong_nriv_format = 1  OTHERS            = 2 ).
    IF sy-subrc NE 0.
      RAISE wrong_nriv_format.
    ENDIF.

    IF iv_bp_ind = abap_false.
      IF iv_rev_ind = abap_false.
        APPEND LINES OF lt_cust_nriv TO et_src_nriv.
        APPEND LINES OF lt_vend_nriv TO et_dpd_nriv.
        APPEND LINES OF lt_cust_alpha_nriv TO et_src_alpha_nriv.
        APPEND LINES OF lt_vend_alpha_nriv TO et_dpd_alpha_nriv.
      ELSE.
        APPEND LINES OF lt_vend_nriv TO et_src_nriv.
        APPEND LINES OF lt_cust_nriv TO et_dpd_nriv.
        APPEND LINES OF lt_vend_alpha_nriv TO et_src_alpha_nriv.
        APPEND LINES OF lt_cust_alpha_nriv TO et_dpd_alpha_nriv.
      ENDIF.
    ELSE.

      APPEND LINES OF lt_bp_nriv TO et_src_nriv.
      APPEND LINES OF lt_cust_nriv TO et_dpd_nriv.
      APPEND LINES OF lt_vend_nriv TO et_dpd_nriv.

      APPEND LINES OF lt_bp_alpha_nriv TO et_src_alpha_nriv.
      APPEND LINES OF lt_cust_alpha_nriv TO et_dpd_alpha_nriv.
      APPEND LINES OF lt_vend_alpha_nriv TO et_dpd_alpha_nriv.


    ENDIF.

endmethod.


method GET_BPS_WITH_UNSUPP_ROLES.

  DATA: lv_role    TYPE bu_partnerrole,
      lv_partner TYPE bu_partner.

  data : lt_partners TYPE tt_partner.



  SELECT partner rltyp from but100 INTO TABLE lt_partners WHERE
       rltyp = 'BAM001'  OR rltyp = 'BBP002' OR rltyp = 'BBP003' OR rltyp = 'BBP004' OR rltyp = 'BBP006'
    OR rltyp = 'CBIH10' OR rltyp = 'CBIH20'
    OR rltyp = 'CLERK1' OR rltyp = 'CLERK2'
    OR rltyp = 'CRM000' OR rltyp = 'CRM002' OR rltyp = 'CRM003' OR rltyp = 'CRM004' OR rltyp = 'CRM007' OR rltyp = 'CRM012' OR rltyp = 'CRM013'
    OR rltyp = 'HEA010' OR rltyp = 'HEA020' OR rltyp = 'HEA030' OR rltyp = 'HEA040' OR rltyp = 'HEA050'
    OR rltyp = 'HR1000'
    OR rltyp = 'LOG010'
    OR rltyp = 'RCFAGY' OR rltyp = 'RCFBRA'
    OR rltyp = 'RTP010' OR rltyp = 'RTP050'
    OR rltyp = 'TXS001' .

et_partners[] = lt_partners[].
endmethod.


method get_cust_supp_details.
  data : lt_kna1 type standard table of kna1.
  data : ls_kna1 like line of lt_kna1.
  data : lt_lfa1 type standard table of lfa1.
  data : ls_lfa1 like line of lt_lfa1.
  data : lt_lfbk type standard table of lfbk.
  data : ls_lfbk like line of lt_lfbk.

  data : lt_knbk type standard table of knbk.
  data : ls_knbk like line of lt_knbk.

  data : lt_cust_link type standard table of cvi_cust_link.
  data : ls_cust_link like line of lt_cust_link.
  data : lt_vend_link type standard table of cvi_vend_link.
  data : ls_vend_link like line of   lt_vend_link.
*    DATA : ls_check_result LIKE LINE OF ct_check_results.
*    DATA : lx_open_sql_error TYPE REF TO cx_sy_open_sql_error.


  data : lt_keys type  cmds_customer_numbers_t .
  data : ls_key like line of lt_keys.
*    DATA : ls_key LIKE LINE OF lt_keys.
  data : lt_kna1_temp type cmds_kna1_t.
  data : ls_kna1_temp like line of lt_kna1_temp.
  data : lt_kna1_key  type cmds_customer_numbers_s_t.
  data : ls_kna1_key like line of lt_kna1_key.
  data : ls_kna1key like line of et_kna1.
  data : ls_lfa1key like line of et_lfa1.


  data : lt_keys_vend type  vmds_vendor_numbers_t .
  data : ls_key_vend like line of lt_keys_vend.
  data : lt_lfa1_temp type vmds_lfa1_t.
  data : ls_lfa1_temp like line of lt_lfa1_temp.
  data : lt_lfa1_key  type vmds_vendor_numbers_s_t.
  data : ls_lfa1_key like line of lt_lfa1_key.
  data : lv_cursor_kna1_err type cursor.
  data : lv_cursor_lfa1_mapping type cursor.
  data : lv_cursor_knbk type cursor.
  data : lv_cursor_lfbk type cursor.
  data : lv_cust_from type  kna1-kunnr.
  data : lv_cust_to type kna1-kunnr.

*    DATA : ls_key LIKE LINE OF lt_keys.
  data : lt_knbk_temp type cmds_knbk_t.
  data : ls_knbk_temp like line of lt_knbk_temp.
  data : lt_knbk_key  type cmds_customer_numbers_s_t.
  data : ls_knbk_key like line of lt_knbk_key.
  data : ls_knbkkey like line of et_knbk.


  data : lt_lfbk_temp type vmds_lfbk_t.
  data : ls_lfbk_temp like line of lt_lfbk_temp.
  data : lt_lfbk_key  type vmds_vendor_numbers_s_t.
  data : ls_lfbk_key like line of lt_lfbk_key.
  data : ls_lfbkkey like line of et_lfbk.




  types: ty_r_kunnr type range of kna1-kunnr.

  data : ls_cust type line of ty_r_kunnr.
  data : lt_cust like table of ls_cust.

  data : lv_vend_from type  lfa1-lifnr.
  data : lv_vend_to type lfa1-lifnr.
  types: ty_r_lifnr type range of lfa1-lifnr.

  data : ls_vend type line of ty_r_lifnr.
  data : lt_vend like table of ls_vend.
  data : lv_flag type char1.
*   DATA : lt_cust TYPE TABLE OF ty_r_kunnr.



  data : p_psize_kna1 type integer value '1000'.  " Package size

  lv_flag = iv_flag.

*  if lv_flag eq 'C'.
  try.
      if lv_cursor_kna1_err is initial .
        if iv_no is initial.
          open cursor: lv_cursor_kna1_err for  select * from kna1  as a where lifnr <> '' and  kunnr not in ( select customer from cvi_cust_link as b ). "#EC CI_NOWHERE "#EC CI_NOFIELD "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
        else.
          open cursor: lv_cursor_kna1_err for  select * from kna1 as a up to iv_no rows  where lifnr <> '' and  kunnr not in ( select customer from cvi_cust_link as b ). "#EC CI_NOWHERE "#EC CI_NOFIELD "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
        endif.
      endif.


      do.
        fetch next cursor lv_cursor_kna1_err into table lt_kna1 package size p_psize_kna1.
        if sy-subrc ne 0 .
          close cursor lv_cursor_kna1_err.
          gv_kna1_cvi_mapping = 'X'.
          exit .
        else.
          sort lt_kna1 by mandt kunnr.
          loop at lt_kna1 into ls_kna1.

            move-corresponding ls_kna1 to ls_kna1_temp.
            ls_kna1_temp-lifnr = ls_kna1-lifnr .
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

        if gv_site is initial.
          loop at lt_kna1 into ls_kna1.
            read table lt_kna1_key into ls_kna1_key with key kunnr = ls_kna1-kunnr.
            if sy-subrc = 0.
              delete table lt_kna1 from ls_kna1.
            endif.
            clear ls_kna1.
            clear ls_kna1_key.
          endloop.
        else.
          loop at lt_kna1 into ls_kna1.
            read table lt_kna1_key into ls_kna1_key with key kunnr = ls_kna1-kunnr.
            if sy-subrc ne 0.
              delete table lt_kna1 from ls_kna1.
            endif.
            clear ls_kna1.
            clear ls_kna1_key.
          endloop.
        endif.





        loop at lt_kna1 into ls_kna1 where kunnr is not initial.
          append ls_kna1 to et_kna1.
          clear ls_kna1key.
*          clear ls_check_result.
        endloop.

        refresh  lt_kna1.
        refresh  lt_kna1_key.
        refresh  lt_kna1_temp.
        refresh  lt_keys.

      enddo.
    catch cx_sy_open_sql_error .
  endtry.


  data : p_psize_knbk type integer value '1000'.  " Package size

  try.
      if lv_cursor_knbk is initial .
        if iv_no is initial.
          open cursor: lv_cursor_knbk for  select * from knbk  as a where  kunnr not in ( select customer from cvi_cust_link as b where a~mandt = b~client ). "#EC CI_NOFIELD #EC CI_NOWHERE "#EC CI_BUFFSUBQ.
        else.
          open cursor: lv_cursor_knbk for  select * from knbk as a up to iv_no rows  where  kunnr not in ( select customer from cvi_cust_link as b where a~mandt = b~client ). "#EC CI_NOFIELD #EC CI_NOWHERE "#EC CI_BUFFSUBQ.
        endif.
      endif.


      do.
        fetch next cursor lv_cursor_knbk into table lt_knbk package size p_psize_knbk.
        if sy-subrc ne 0 .
          close cursor lv_cursor_knbk.
*            gv_kna1_cvi_mapping = 'X'.
          exit .
        else.
          sort lt_knbk by  kunnr banks bankl bankn.
          loop at lt_knbk into ls_knbk.
            move-corresponding ls_knbk to ls_knbk_temp.
            append ls_knbk to lt_knbk_temp.
            clear ls_key.
            clear ls_knbk_temp.
            clear ls_knbk.

          endloop.

        endif.
*    endif.


        call method check_cust_part_of_retail_site
          exporting
            it_keys         = lt_keys
            it_kna1         = lt_kna1_temp
          importing
            et_part_of_site = lt_kna1_key.

        if  gv_site is initial.
          loop at lt_knbk into ls_knbk.
            read table lt_kna1_key into ls_kna1_key with key kunnr = ls_kna1-kunnr.
            if sy-subrc = 0.
              delete table lt_knbk from ls_knbk.
            endif.
            clear ls_knbk.
            clear ls_knbk_key.
          endloop.
        else.
          loop at lt_knbk into ls_knbk.
            read table lt_kna1_key into ls_kna1_key with key kunnr = ls_kna1-kunnr.
            if sy-subrc ne 0.
              delete table lt_knbk from ls_knbk.
            endif.
            clear ls_knbk.
            clear ls_knbk_key.
          endloop.
        endif.





        loop at lt_knbk into ls_knbk where kunnr is not initial.
*            move  ls_knbk-kunnr to ls_knbkkey-kunnr.
          append ls_knbk to et_knbk.
          clear ls_knbkkey.
*          clear ls_check_result.
        endloop.

        refresh  lt_knbk.
        refresh  lt_knbk_key.
        refresh  lt_knbk_temp.
        refresh  lt_keys.

      enddo.
    catch cx_sy_open_sql_error .
  endtry.

*  endif.




*  if lv_flag eq 'S'.


  data : p_psize_lfa1 type integer value '1000'.  " Package size
*  DATA : s_cursor_lfa1_mapping TYPE cursor.
*  if gv_lfa1_cvi_mapping is not initial.
  try .
      if lv_cursor_lfa1_mapping is initial .
        if iv_no is initial.
          open cursor: lv_cursor_lfa1_mapping for select * from lfa1 as a
          where kunnr <> '' and lifnr not in ( select vendor from cvi_vend_link as b  ). "#EC CI_NOFIELD "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
        else.
          open cursor: lv_cursor_lfa1_mapping for select * from lfa1 as a up to iv_no rows
           where kunnr <> '' and lifnr not in ( select vendor from cvi_vend_link as b  ). "#EC CI_NOFIELD "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
        endif.
      endif.


      do.
        fetch next cursor lv_cursor_lfa1_mapping into table lt_lfa1 package size p_psize_lfa1 .
        if sy-subrc ne 0 .
          close cursor s_cursor_lfa1_mapping.
          gv_lfa1_cvi_mapping = 'X'.
          exit .
        else.
          sort lt_lfa1 by mandt lifnr.

          loop at lt_lfa1 into ls_lfa1 .
            move-corresponding ls_lfa1 to ls_lfa1_temp.
            append ls_lfa1 to lt_lfa1_temp.
            clear ls_key_vend.
            clear ls_lfa1_temp.
            clear ls_lfa1.
          endloop.


        endif.

        call method check_vend_part_of_retail_site
          exporting
            it_keys         = lt_keys_vend
            it_lfa1         = lt_lfa1_temp
          importing
            et_part_of_site = lt_lfa1_key.


        if gv_site is initial.
          loop at lt_lfa1 into ls_lfa1.
            read table lt_lfa1_key into ls_lfa1_key with key lifnr = ls_lfa1-lifnr.
            if sy-subrc = 0.
              delete table lt_lfa1 from ls_lfa1.
            endif.
            clear ls_lfa1.
            clear ls_lfa1_key.
          endloop.
        else.
          loop at lt_lfa1 into ls_lfa1.
            read table lt_lfa1_key into ls_lfa1_key with key lifnr = ls_lfa1-lifnr.
            if sy-subrc ne 0.
              delete table lt_lfa1 from ls_lfa1.
            endif.
            clear ls_lfa1.
            clear ls_lfa1_key.
          endloop.
        endif.



        loop at lt_lfa1 into ls_lfa1 where lifnr is not initial.
*            move  ls_lfa1-lifnr to ls_lfa1key-lifnr.
          append ls_lfa1 to et_lfa1.
          clear ls_lfa1key.

        endloop.


        refresh  lt_lfa1.
        refresh  lt_lfa1_key.
        refresh  lt_lfa1_temp.
        refresh lt_keys_vend.


      enddo.
    catch cx_sy_open_sql_error .

  endtry.

  data : p_psize_lfbk type integer value '1000'.  " Package size
*  DATA : s_cursor_lfa1_mapping TYPE cursor.
*  if gv_lfa1_cvi_mapping is not initial.
  try.
      if s_cursor_lfbk is initial .
        if iv_no is initial.
          open cursor: s_cursor_lfbk for select * from lfbk as a
          where lifnr not in ( select vendor from cvi_vend_link as b where a~mandt = b~client ). "#EC CI_NOFIELD #EC CI_NOWHERE "#EC CI_BUFFSUBQ.
        else.
          open cursor: s_cursor_lfbk for select * from lfbk as a up to iv_no rows
           where lifnr not in ( select vendor from cvi_vend_link as b where a~mandt = b~client ). "#EC CI_NOFIELD #EC CI_NOWHERE "#EC CI_BUFFSUBQ.
        endif.
      endif.


      do.
        fetch next cursor s_cursor_lfbk into table lt_lfbk package size p_psize_lfa1 .
        if sy-subrc ne 0 .
          close cursor s_cursor_lfbk.
*            gv_lfa1_cvi_mapping = 'X'.
          exit .
        else.
          sort lt_lfbk by  lifnr banks bankl bankn.

          loop at lt_lfbk into ls_lfbk .
            move-corresponding ls_lfbk to ls_lfbk_temp.
            append ls_lfbk to lt_lfbk_temp.
            clear ls_key_vend.
            clear ls_lfbk_temp.
            clear ls_lfbk.
          endloop.


        endif.
*    endif.



        call method check_vend_part_of_retail_site
          exporting
            it_keys         = lt_keys_vend
            it_lfa1         = lt_lfa1_temp
          importing
            et_part_of_site = lt_lfa1_key.


        if gv_site is initial.
          loop at lt_lfbk into ls_lfbk.
            read table lt_lfa1_key into ls_lfa1_key with key lifnr = ls_lfa1-lifnr.
            if sy-subrc = 0.
              delete table lt_lfbk from ls_lfbk.
            endif.
            clear ls_lfbk.
            clear ls_lfbk_key.
          endloop.
        else.
          loop at lt_lfbk into ls_lfbk.
            read table lt_lfa1_key into ls_lfa1_key with key lifnr = ls_lfa1-lifnr.
            if sy-subrc ne 0.
              delete table lt_lfbk from ls_lfbk.
            endif.
            clear ls_lfbk.
            clear ls_lfbk_key.
          endloop.
        endif.



        loop at lt_lfbk into ls_lfbk where lifnr is not initial.
*            move  ls_lfbk-lifnr to ls_lfbkkey-lifnr.
          append ls_lfbk to et_lfbk.
          clear ls_lfbkkey.

        endloop.


        refresh  lt_lfbk.
        refresh  lt_lfbk_key.
        refresh  lt_lfbk_temp.
        refresh lt_keys_vend.


      enddo.
    catch cx_sy_open_sql_error .
  endtry.

*  endif.














*        process_db_exception(
*          EXPORTING
*            ix_exception     = lx_open_sql_error
*            iv_check_id      = 'CVI_MAPPING'
*          CHANGING
*            ct_check_results = ct_check_results ).




  clear : ls_kna1,
          ls_lfa1,
          ls_cust_link,
          ls_vend_link,

          ls_key,ls_kna1_temp,
          ls_kna1_key,
          ls_key_vend,
          ls_lfa1_temp,
          ls_lfa1_key.

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


endmethod.


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


method GET_PREPROCESSING_CHECK_RESULT.
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


  METHOD SELECT_TNRO.

    SELECT SINGLE * FROM tnro INTO gs_tnro WHERE object = iv_object.
    IF sy-subrc <> 0.
      MESSAGE e002(nr) WITH iv_object RAISING object_not_found.
    ELSE.
      IF gs_tnro-buffer = abap_true     OR
         gs_tnro-buffer = local   OR
         gs_tnro-buffer = process OR
         gs_tnro-buffer = shadow.

      ENDIF.
*    aktuelles Objekt für Folgeaufrufe merken
      act_object = iv_object.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
