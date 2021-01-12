*----------------------------------------------------------------------*
***INCLUDE CVI_FS_CHECK_CUSTOMIZING_ENF12.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form SET_DATA_CUSTOMER_POST
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_data_customer_post .

**********Picking data from Database into local variables starts**********************
  IF gt_tb910_db[] IS INITIAL.
    SELECT * FROM tb910 INTO CORRESPONDING FIELDS OF TABLE gt_tb910_db.
  ENDIF.

  IF gt_tb912_db[] IS INITIAL.
    SELECT * FROM tb912 INTO CORRESPONDING FIELDS OF TABLE gt_tb912_db.
  ENDIF.

  IF gt_tb914_db[] IS INITIAL.
    SELECT * FROM tb914 INTO CORRESPONDING FIELDS OF TABLE gt_tb914_db.
  ENDIF.

  IF gt_tb916_db[] IS INITIAL.
    SELECT * FROM tb916 INTO CORRESPONDING FIELDS OF TABLE gt_tb916_db.
  ENDIF.

  IF gt_tb019_db[] IS INITIAL.
    SELECT * FROM tb019 INTO CORRESPONDING FIELDS OF TABLE gt_tb019_db.
  ENDIF.

  IF gt_tb027_db[] IS INITIAL.
    SELECT * FROM tb027 INTO CORRESPONDING FIELDS OF TABLE gt_tb027_db.
  ENDIF.

  IF gt_tb033_db[] IS INITIAL.
    SELECT * FROM tb033 INTO CORRESPONDING FIELDS OF TABLE gt_tb033_db.
  ENDIF.

**********Picking data from Database into local variables ends**********************

  DATA: ls_tb910           LIKE LINE OF gt_tb910,
        ls_tb910_loc       LIKE LINE OF gt_tb910_db,
        ls_tb910_d         LIKE LINE OF gt_outtab_tb910,
        lt_tb910           TYPE TABLE OF tb910,
        lt_tb911           TYPE TABLE OF tb911,
        ls_tb911           LIKE LINE OF lt_tb911,
        ls_outtab_cust_log LIKE LINE OF gt_outtab_post_log,
        ls_post            LIKE LINE OF gt_outtab_post_log.

*  if gt_outtab_tb910[] is INITIAL.
  IF gt_tb910 IS NOT INITIAL.
    IF lt_tb911 IS INITIAL.
      SELECT DISTINCT * FROM tb911 INTO TABLE lt_tb911 WHERE  spras = sy-langu. "#EC CI_BYPASS.
    ENDIF.
    LOOP AT gt_tb910 INTO ls_tb910.
      READ TABLE gt_tb910_db INTO ls_tb910_loc WITH KEY abtnr = ls_tb910-abtnr.
      IF sy-subrc = 0.
        READ TABLE lt_tb911 INTO ls_tb911 WITH KEY abtnr = ls_tb910-abtnr .
        ls_tb910_d-abtnr = ls_tb910-abtnr.
        ls_tb910_d-desc = ls_tb911-bez20.
        ls_tb910_d-abtnr_check = 'X'.
*        IF ls_tb910_d-abtnr = ls_tb911-abtnr.
*          ls_tb910_d-desc = ls_tb911-bez20.
*        ENDIF.
*        ls_tb910_d-abtnr_check = 'X'.
*        ls_tb910_d-dropdown_cvi_dept = '2'.
*        ls_tb910_d-cvi_dept_text = ''.
        APPEND ls_tb910_d TO gt_outtab_tb910.
        CLEAR : ls_tb910.
      ENDIF.
    ENDLOOP.
  ENDIF.
*ENDIF.
  SORT gt_outtab_tb910[] BY abtnr desc.
  DELETE ADJACENT DUPLICATES FROM gt_outtab_tb910[].

****************TB912**************
  DATA : ls_tb912     LIKE LINE OF gt_tb912,
         ls_tb912_loc LIKE LINE OF gt_tb912_db,
         lt_tb913     TYPE TABLE OF tb913,
         ls_tb913     LIKE LINE OF lt_tb913,
         lt_tb912     TYPE TABLE OF tb912,
         ls_tb912_d   LIKE LINE OF gt_outtab_tb912,
         lv_string    TYPE string.

* IF gt_outtab_tb912[] IS INITIAL.
  IF gt_tb912 IS NOT INITIAL.
    IF lt_tb913 IS INITIAL.
      SELECT DISTINCT * FROM tb913 INTO TABLE lt_tb913 WHERE spras = sy-langu. "#EC CI_BYPASS.
    ENDIF.
    LOOP AT gt_tb912 INTO ls_tb912.
      READ TABLE gt_tb912_db INTO ls_tb912_loc WITH KEY pafkt = ls_tb912-pafkt .
      if sy-subrc = 0.
        read table lt_tb913 into ls_tb913 with key pafkt = ls_tb912-pafkt .
        ls_tb912_d-pafkt = ls_tb912-pafkt.
        if ls_tb913-bez30 is not initial.
          ls_tb912_d-desc = ls_tb913-bez30.
        else.
          lv_string = ls_tb912-pafkt.
          concatenate lv_string ' DESC' into ls_tb912_d-desc.
        endif.
        ls_tb912_d-pafkt_check = 'X'.
        append ls_tb912_d to gt_outtab_tb912.
      ENDIF.
    ENDLOOP.
  ENDIF.
*  ENDIF.
  SORT gt_outtab_tb912[] BY pafkt desc.
  DELETE ADJACENT DUPLICATES FROM gt_outtab_tb912[].

****************TB914**************
  DATA : ls_tb914     LIKE LINE OF gt_tb914,
         ls_tb914_loc LIKE LINE OF gt_tb914_db,
         lt_tb915     TYPE TABLE OF tb915,
         lt_tb914     TYPE TABLE OF tb914,
         ls_tb914_d   LIKE LINE OF gt_outtab_tb914.
  DATA: ls_tb915   LIKE LINE OF lt_tb915.

*  IF gt_outtab_tb914[] IS INITIAL.


  IF gt_tb914 IS NOT INITIAL.
    IF lt_tb915 IS INITIAL.
      SELECT DISTINCT * FROM tb915 INTO TABLE lt_tb915 WHERE spras = sy-langu. "#EC CI_BYPASS.
    ENDIF.
    LOOP AT gt_tb914 INTO ls_tb914.
      READ TABLE gt_tb914_db INTO ls_tb914_loc WITH KEY paauth = ls_tb914-bu_paauth.
      IF sy-subrc = 0.
        READ TABLE lt_tb915 INTO ls_tb915 WITH KEY paauth = ls_tb914_d-bu_paauth .
        ls_tb914_d-bu_paauth = ls_tb914-bu_paauth.
        ls_tb914_d-desc = ls_tb915-bez20.
        ls_tb914_d-bu_paauth_check = 'X'.
*        IF ls_tb914_d-bu_paauth = ls_tb915-paauth.
*          ls_tb914_d-desc = ls_tb915-bez20.
*        ENDIF.
*        ls_tb914_d-bu_paauth_check = 'X'.
*        ls_tb914_d-dropdown_cvi_auth = '2'.
*        ls_tb914_d-cvi_auth_text = ''.
        APPEND ls_tb914_d TO gt_outtab_tb914.
      ENDIF.
    ENDLOOP.
  ENDIF.
* ENDIF.
  SORT gt_outtab_tb914[] BY bu_paauth desc.
  DELETE ADJACENT DUPLICATES FROM gt_outtab_tb914[].

****************TB916**************
  DATA: ls_tb916     LIKE LINE OF gt_tb916,
        ls_tb916_loc LIKE LINE OF gt_tb916_db,
        lt_tb917     TYPE TABLE OF tb917,
        ls_tb917     LIKE LINE OF lt_tb917,
        lt_tb916     TYPE TABLE OF tb916,
        ls_tb916_d   LIKE LINE OF gt_outtab_tb916.

*  IF gt_outtab_tb916[] IS INITIAL.
  IF gt_tb916 IS NOT INITIAL.
    IF lt_tb917 IS INITIAL.
      SELECT DISTINCT * FROM tb917 INTO TABLE lt_tb917 WHERE spras = sy-langu. "#EC CI_BYPASS.
    ENDIF.
    LOOP AT gt_tb916 INTO ls_tb916.
      READ TABLE gt_tb916_db INTO ls_tb916_loc WITH KEY pavip = ls_tb916-pavip .
      IF sy-subrc = 0.
        READ TABLE lt_tb917 INTO ls_tb917 WITH KEY pavip = ls_tb916-pavip .
*        IF ls_tb916_d-pavip = ls_tb917-pavip.
*          ls_tb916_d-desc = ls_tb917-bez20.
*        ENDIF.
*        ls_tb916_d-pavip_check = 'X'.
*        ls_tb916_d-dropdown_cvi_vip = '2'.
*        ls_tb916_d-cvi_vip_text = ''.
        ls_tb916_d-pavip = ls_tb916-pavip.
        ls_tb916_d-desc = ls_tb917-bez20.
        ls_tb916_d-pavip_check = 'X'.
        APPEND ls_tb916_d TO gt_outtab_tb916.
        CLEAR : ls_tb916_d.
      ELSE.

      ENDIF.
    ENDLOOP.
  ENDIF.
*  ENDIF.
  SORT gt_outtab_tb916[] BY pavip desc.
  DELETE ADJACENT DUPLICATES FROM gt_outtab_tb916[].


****************TB027**************
  DATA : ls_tb027     LIKE LINE OF gt_tb027,
         ls_tb027_loc LIKE LINE OF gt_tb027_db,
         lt_tb027t    TYPE TABLE OF tb027t,
         ls_tb027t    LIKE LINE OF lt_tb027t,
         lt_tb027     TYPE TABLE OF tb027,
         ls_tb027_d   LIKE LINE OF gt_outtab_tb027.

*  IF gt_outtab_tb027[] IS INITIAL.

  IF gt_tb027 IS NOT INITIAL.
    IF lt_tb027t IS INITIAL.
      SELECT DISTINCT * FROM tb027t INTO TABLE lt_tb027t WHERE spras = sy-langu. "#EC CI_BYPASS.
    ENDIF.
    LOOP AT gt_tb027 INTO ls_tb027.
      READ TABLE gt_tb027_db INTO ls_tb027_loc WITH KEY marst = ls_tb027-bu_marst.
      IF sy-subrc = 0.
        READ TABLE lt_tb027t INTO ls_tb027t WITH KEY marst = ls_tb027-bu_marst .
*        IF ls_tb027_d-bu_marst = ls_tb027t-marst.
*          ls_tb027_d-desc = ls_tb027t-bez20.
*        ENDIF.
*        ls_tb027_d-bu_marst_check = 'X'.
*        ls_tb027_d-dropdown_cvi_famst = '2'.
*        ls_tb027_d-cvi_famst_text = ''.
        ls_tb027_d-bu_marst = ls_tb027-bu_marst.
        ls_tb027_d-desc = ls_tb027t-bez20.
        ls_tb027_d-bu_marst_check = 'X'.
        APPEND ls_tb027_d TO gt_outtab_tb027.
      ENDIF.
    ENDLOOP.
  ENDIF.
*  ENDIF.
  SORT gt_outtab_tb027[] BY bu_marst desc.
  DELETE ADJACENT DUPLICATES FROM gt_outtab_tb027[].


****************TB019**************
  DATA : ls_tb019     LIKE LINE OF gt_tb019,
         ls_tb019_loc LIKE LINE OF gt_tb019_db,
         lt_tb020     TYPE TABLE OF tb020,
         ls_tb020     LIKE LINE OF lt_tb020,
         lt_tb019     TYPE TABLE OF tb019,
         ls_tb019_d   LIKE LINE OF gt_outtab_tb019.

* IF gt_outtab_tb019[] IS INITIAL.
  IF gt_tb019 IS NOT INITIAL.
    IF lt_tb020 IS INITIAL.
      SELECT DISTINCT * FROM tb020 INTO TABLE lt_tb020 WHERE spras = sy-langu. "#EC CI_BYPASS.
    ENDIF.
    LOOP AT gt_tb019 INTO ls_tb019.
      READ TABLE gt_tb019_db INTO ls_tb019_loc WITH KEY legal_enty = ls_tb019-bu_legenty .
      IF sy-subrc = 0.
        READ TABLE lt_tb020 INTO ls_tb020 WITH KEY legal_enty = ls_tb019-bu_legenty .
*        IF ls_tb019_d-bu_legenty = ls_tb020-legal_enty.
*          ls_tb019_d-desc =  ls_tb020-textlong.
*        ENDIF.
*        ls_tb019_d-bu_legenty_check = 'X'.
*        ls_tb019_d-dropdown_cvi_stat = '2'.
*        ls_tb019_d-legal_stat_cvi = ''.
        ls_tb019_d-bu_legenty = ls_tb019-bu_legenty.
        ls_tb019_d-desc = ls_tb020-textshort.
        ls_tb019_d-bu_legenty_check = 'X'.
        APPEND ls_tb019_d TO gt_outtab_tb019.

      ENDIF.
    ENDLOOP.
  ENDIF.
*  ENDIF.
  SORT gt_outtab_tb019[] BY bu_legenty desc.
  DELETE ADJACENT DUPLICATES FROM gt_outtab_tb019[].

****************TB033**************

  DATA : ls_tb033     LIKE LINE OF gt_tb033,
         ls_tb033_loc LIKE LINE OF gt_tb033_db,
         lt_tb033t    TYPE TABLE OF tb033t,
         ls_tb033t    LIKE LINE OF lt_tb033t,
         lt_tb033     TYPE TABLE OF tb033,
         ls_tb033_d   LIKE LINE OF gt_outtab_tb033.

*  IF gt_outtab_tb033[] IS INITIAL.
  IF gt_tb033 IS NOT INITIAL.
    IF lt_tb033t IS INITIAL.
      SELECT DISTINCT * FROM tb033t INTO TABLE lt_tb033t WHERE spras = sy-langu. "#EC CI_BYPASS.
    ENDIF.
    LOOP AT gt_tb033 INTO ls_tb033.
      READ TABLE gt_tb033_db INTO ls_tb033_loc WITH KEY ccins = ls_tb033-ccins .
      IF sy-subrc = 0.
        READ TABLE lt_tb033t INTO ls_tb033t WITH KEY ccins = ls_tb033-ccins .
*        IF ls_tb033_d = ls_tb033t-ccins.
*          ls_tb033_d-desc = ls_tb033t-bez30.
*        ENDIF.
*        ls_tb033_d-ccins_check = 'X'.
*        ls_tb033_d-dropdown_cvi_pcard = '2'.
*        ls_tb033_d-cvi_pcard_text = ''.
        ls_tb033_d-ccins = ls_tb033-ccins.
        ls_tb033_d-desc = ls_tb033t-bez30.
        ls_tb033_d-ccins_check = 'X'.
        APPEND ls_tb033_d TO gt_outtab_tb033.
*      ELSE.
      ENDIF.
    ENDLOOP.
  ENDIF.
*  ENDIF.
  SORT gt_outtab_tb033[] BY ccins desc.
  DELETE ADJACENT DUPLICATES FROM gt_outtab_tb033[].

  DELETE ADJACENT DUPLICATES FROM gt_outtab_post_log.

**********PREPARING ERROR LOG STARTS******************

  IF gt_outtab_tb910[] IS INITIAL.
    ls_outtab_cust_log-chk = 'CHK_CP_TB910'.
    ls_outtab_cust_log-icon = gv_icon_green.
    ls_outtab_cust_log-log = 'Department Assignment for Contact Person is consistent'.
    APPEND ls_outtab_cust_log TO gt_outtab_post_log1100.
  ELSE.
    ls_outtab_cust_log-chk = 'CHK_CP_TB910'.
    ls_outtab_cust_log-icon = gv_icon_red.
    ls_outtab_cust_log-log = 'Department Assignment for Contact Person is inconsistent '.
    APPEND ls_outtab_cust_log TO gt_outtab_post_log1100.
  ENDIF.

  IF gt_outtab_tb912[] IS INITIAL.
    ls_outtab_cust_log-chk = 'CHK_CP_TB912'.
    ls_outtab_cust_log-icon = gv_icon_green.
    ls_outtab_cust_log-log = 'Function of Partner Assignment for Contact Person is consistent'.
    APPEND ls_outtab_cust_log TO gt_outtab_post_log1100.
  ELSE.
    ls_outtab_cust_log-chk = 'CHK_CP_TB912'.
    ls_outtab_cust_log-icon = gv_icon_red.
    ls_outtab_cust_log-log = 'Function of Partner Assignment for Contact Person is inconsistent'.
    APPEND ls_outtab_cust_log TO gt_outtab_post_log1100.
  ENDIF.

  IF gt_outtab_tb914[] IS INITIAL.
    ls_outtab_cust_log-chk = 'CHK_CP_TB914'.
    ls_outtab_cust_log-icon = gv_icon_green.
    ls_outtab_cust_log-log = 'Partner Authority Assignment for Contact Person is consistent'.
    APPEND ls_outtab_cust_log TO gt_outtab_post_log1100.
  ELSE.
    ls_outtab_cust_log-chk = 'CHK_CP_TB914'.
    ls_outtab_cust_log-icon = gv_icon_red.
    ls_outtab_cust_log-log = 'Partner Authority Assignment for Contact Person is inconsistent'.
    APPEND ls_outtab_cust_log TO gt_outtab_post_log1100.
  ENDIF.

  IF gt_outtab_tb916[] IS INITIAL.
    ls_outtab_cust_log-chk = 'CHK_CP_TB916'.
    ls_outtab_cust_log-icon = gv_icon_green.
    ls_outtab_cust_log-log = 'VIP Indicator Assignment for Contact Person is consistent'.
    APPEND ls_outtab_cust_log TO gt_outtab_post_log1100.
  ELSE.
    ls_outtab_cust_log-chk = 'CHK_CP_TB916'.
    ls_outtab_cust_log-icon = gv_icon_red.
    ls_outtab_cust_log-log = 'VIP Indicator Assignment for Contact Person is inconsistent'.
    APPEND ls_outtab_cust_log TO gt_outtab_post_log1100.
  ENDIF.

  IF gt_outtab_tb027[] IS INITIAL.
    ls_outtab_cust_log-chk = 'CHK_CP_TB027'.
    ls_outtab_cust_log-icon = gv_icon_green.
    ls_outtab_cust_log-log = 'Marital Status Assignment for Partner is consistent'.
    APPEND ls_outtab_cust_log TO gt_outtab_post_log1100.
  ELSE.
    ls_outtab_cust_log-chk = 'CHK_CP_TB027'.
    ls_outtab_cust_log-icon = gv_icon_red.
    ls_outtab_cust_log-log = 'Marital Status Assignment for Partner is inconsistent'.
    APPEND ls_outtab_cust_log TO gt_outtab_post_log1100.
  ENDIF.

  IF gt_outtab_tb019[] IS INITIAL.
    ls_outtab_cust_log-chk = 'CHK_CP_TB019'.
    ls_outtab_cust_log-icon = gv_icon_green.
    ls_outtab_cust_log-log = 'Legal Form of Organization Assignment for Partner is consistent'.
    APPEND ls_outtab_cust_log TO gt_outtab_post_log1100.
  ELSE.
    ls_outtab_cust_log-chk = 'CHK_CP_TB019'.
    ls_outtab_cust_log-icon = gv_icon_red.
    ls_outtab_cust_log-log = 'Legal Form of Organization Assignment for Partner is inconsistent'.
    APPEND ls_outtab_cust_log TO gt_outtab_post_log1100.
  ENDIF.

  IF gt_outtab_tb033[] IS INITIAL.
    ls_outtab_cust_log-chk = 'CHK_CP_TB033'.
    ls_outtab_cust_log-icon = gv_icon_green.
    ls_outtab_cust_log-log = 'Payment Card Type Assignment for Contact Person is consistent'.
    APPEND ls_outtab_cust_log TO gt_outtab_post_log1100.
  ELSE.
    ls_outtab_cust_log-chk = 'CHK_CP_TB033'.
    ls_outtab_cust_log-icon = gv_icon_red.
    ls_outtab_cust_log-log = 'Payment Card Type Assignment for Contact Person is inconsistent'.
    APPEND ls_outtab_cust_log TO gt_outtab_post_log1100.
  ENDIF.

**********PREPARING ERROR LOG ENDS******************
ENDFORM.                    "set_data_customer_post
