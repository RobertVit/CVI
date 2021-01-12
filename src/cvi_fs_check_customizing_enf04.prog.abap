*----------------------------------------------------------------------*
***INCLUDE CVI_FS_CHECK_CUSTOMIZING_ENF04.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form SET_DATA_CUSTOMER2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_data_customer2 .

  DATA : lv_kna1      TYPE  kna1-kunnr,
         lv_knb1      TYPE  knb1-kunnr,
         lv_knvv      TYPE  knvv-kunnr,
         lv_cust_acgp TYPE kna1-kunnr.

  DATA: lt_tbd002 TYPE TABLE OF tbd002,
        ls_tbd002 TYPE tbd002.


  DATA: lt_dropdown_role TYPE lvc_t_drop,
        ls_dropdown_role TYPE lvc_s_drop.


  DATA: ls_role            LIKE LINE OF gt_role,
        ls_outtab_role     LIKE LINE OF gt_outtab_role,
        ls_outtab_log_role LIKE LINE OF gt_outtab_log_role,
        ls_outtab_log      LIKE LINE OF gt_outtab_log.


  REFRESH: gt_outtab_log,gt_outtab_log_ac,gt_outtab_log_role ,gt_outtab_log_ac_fin.
*  clear gv_flag_insert.

  ls_dropdown_role-handle = '1'.
  ls_dropdown_role-value = ''.
  APPEND ls_dropdown_role TO lt_dropdown_role.



  SELECT * FROM tbd002 INTO TABLE lt_tbd002 WHERE deb = 'X'.
  LOOP AT lt_tbd002 INTO ls_tbd002.
    IF ls_tbd002-rltyp <> 'FLCU00' AND ls_tbd002-rltyp <> 'FLCU01'.
      ls_dropdown_role-handle = '1'.
      ls_dropdown_role-value = ls_tbd002-rltyp.
      APPEND ls_dropdown_role TO lt_dropdown_role.

    ENDIF.
  ENDLOOP.


  LOOP AT gt_role INTO ls_role.
    MOVE-CORRESPONDING ls_role TO ls_outtab_role.

    SELECT SINGLE ktokd INTO lv_cust_acgp FROM t077d WHERE  ktokd = ls_role-ac_gp.

    IF sy-subrc = 0.

      SELECT SINGLE kunnr FROM kna1 INTO lv_kna1 WHERE ktokd = ls_role-ac_gp. "#EC CI_NOFIELD

      IF sy-subrc = 0.

        SELECT SINGLE kunnr FROM knb1 INTO lv_knb1 WHERE kunnr = lv_kna1.

        IF sy-subrc = 0.
          READ TABLE lt_dropdown_role INTO ls_dropdown_role WITH KEY value = 'FLCU00'.
          IF sy-subrc <> 0.
            ls_dropdown_role-handle = '1'.
            ls_dropdown_role-value = 'FLCU00'.
            APPEND ls_dropdown_role TO lt_dropdown_role.
          ENDIF.
        ELSE.
          SELECT SINGLE kunnr FROM knvv INTO lv_knvv WHERE kunnr = lv_kna1.
          IF sy-subrc = 0.
            READ TABLE lt_dropdown_role INTO ls_dropdown_role WITH KEY value = 'FLCU01'.
            IF sy-subrc <> 0.
              ls_dropdown_role-value = 'FLCU01'.
              ls_dropdown_role-handle = '1'.
              APPEND ls_dropdown_role TO lt_dropdown_role.
            ENDIF.
          ELSE.
            READ TABLE lt_dropdown_role INTO ls_dropdown_role WITH KEY value = 'FLCU00' .
            IF sy-subrc <> 0.
              ls_dropdown_role-handle = '1'.
              ls_dropdown_role-value = 'FLCU00'.
              APPEND ls_dropdown_role TO lt_dropdown_role.
            ENDIF.
            READ TABLE lt_dropdown_role INTO ls_dropdown_role WITH KEY value = 'FLCU01'.
            IF sy-subrc <> 0.
              ls_dropdown_role-handle = '1'.
              ls_dropdown_role-value = 'FLCU01'.
              APPEND ls_dropdown_role TO lt_dropdown_role.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDLOOP.






  DATA : lt_t077d_role TYPE TABLE OF t077d,
         ls_t077d_role TYPE t077d.

  DATA : lt_role_acgp TYPE  TABLE OF cvic_cust_to_bp2,
         ls_role_acgp TYPE cvic_cust_to_bp2.


  LOOP AT gt_role INTO ls_role.
    MOVE-CORRESPONDING ls_role TO ls_outtab_role.
    SELECT * FROM t077d INTO TABLE lt_t077d_role WHERE ktokd = ls_role-ac_gp.
    IF sy-subrc = 0 .
      SELECT * FROM cvic_cust_to_bp2 INTO TABLE lt_role_acgp WHERE account_group = ls_role-ac_gp.
      IF sy-subrc = 0 .
        LOOP AT lt_role_acgp INTO ls_role_acgp.
          DELETE lt_dropdown_role WHERE value = ls_role_acgp-role.
*            delete from lt_dropdown_role where value = ls_role_acgp-role.
        ENDLOOP.
        ls_outtab_role-role = ls_dropdown_role-value.
        ls_outtab_role-drop_down_handle = '1'.
      ELSE.
        IF ls_dropdown_role-value = 'FLCU00'.
          ls_outtab_role-role = ls_dropdown_role-value.
          ls_outtab_role-drop_down_handle = '1'.
          ls_outtab_role-role_desc = 'Business Partner FI Customer'.
        ELSEIF ls_dropdown_role-value = 'FLCU01'.
          ls_outtab_role-role = ls_dropdown_role-value.
          ls_outtab_role-drop_down_handle = '1'.
          ls_outtab_role-role_desc = 'Business Partner Customer'.
        ELSE.
          ls_outtab_role-role = ls_dropdown_role-value.
          ls_outtab_role-drop_down_handle = '1'.
          ls_outtab_role-role_desc = ''.
        ENDIF.
      ENDIF.
      IF gv_flag_insert IS INITIAL AND gv_count IS INITIAL.
        APPEND ls_outtab_role TO gt_outtab_role.
      ENDIF.

    ENDIF.
  ENDLOOP.

*    ELSE.
*      CONCATENATE ls_role-ac_gp  TEXT-034 INTO ls_outtab_log_role-log SEPARATED BY space.
*      ls_outtab_log_role-chk = 'CHK_BP_ROLE'.
*      ls_outtab_log_role-icon = gv_icon_red.
*      ls_outtab_log_role-value = ls_role-ac_gp.
*      ls_outtab_log_role-table = 't077d'.
*      APPEND ls_outtab_log_role TO gt_outtab_log_role.
*      APPEND ls_outtab_log_role TO gt_outtab_log.


  IF gv_flag_insert IS INITIAL.
    SORT gt_outtab_role BY ac_gp.
    DELETE ADJACENT DUPLICATES FROM gt_outtab_role COMPARING ac_gp.
  ENDIF.

*
*  IF gt_outtab_role[] IS NOT INITIAL.
**    CLEAR ls_outtab_log.
**    READ TABLE  gt_outtab_log[] WITH KEY  chk = 'CHK_BP_ROLE' INTO ls_outtab_log.
**    IF sy-subrc = 0.
*      ls_outtab_log-log = 'Customer Account Group->Role Mapping is inconsistent '.
*      ls_outtab_log-icon = gv_icon_red.
*      ls_outtab_log-chk = 'CHK_BP_ROLE'.
*      APPEND ls_outtab_log TO gt_outtab_log_ac_fin.
*
**    ENDIF.
*  ELSE.
*    ls_outtab_log-log = 'Customer Account Group->Role Mapping is consistent '.
*    ls_outtab_log-icon = gv_icon_green.
*    ls_outtab_log-chk = 'CHK_BP_ROLE'.
*    APPEND ls_outtab_log TO gt_outtab_log_ac_fin.
*  ENDIF.
*
*  CLEAR ls_outtab_log.
  IF gt_outtab_role[] IS NOT INITIAL.

    ls_outtab_log-log = 'Customer Account Group->Role Mapping is inconsistent '.
    ls_outtab_log-chk = 'CHK_BP_ROLE'.
    ls_outtab_log-icon = gv_icon_red.
    APPEND ls_outtab_log TO gt_outtab_log_ac_fin.
  ELSE.
    ls_outtab_log-log = 'Customer Account Group->Role Mapping is consistent'.
    ls_outtab_log-chk = 'CHK_BP_ROLE'.
    ls_outtab_log-icon = gv_icon_green.
    APPEND ls_outtab_log TO gt_outtab_log_ac_fin.

  ENDIF.


  IF gr_alv_role IS INITIAL.
    CREATE OBJECT gr_alv_role
      EXPORTING
        i_parent = gr_cont_role.
  ENDIF.
  CALL METHOD gr_alv_role->set_drop_down_table
    EXPORTING
      it_drop_down = lt_dropdown_role.

  CALL METHOD gr_alv_role->register_edit_event
    EXPORTING
      i_event_id = cl_gui_alv_grid=>mc_evt_modified.


  DATA: lt_dropdown_1 TYPE lvc_t_drop,
        lt_dropdown_2 TYPE lvc_t_drop,
        ls_dropdown   TYPE lvc_s_drop.

  DATA: lt_tb001 TYPE TABLE OF tb001,
        ls_tb001 TYPE tb001.

  DATA: ls_account_group LIKE LINE OF gt_account_group,
        ls_outtab        LIKE LINE OF gt_outtab.

  DATA: lt_t077d TYPE TABLE OF t077d,
        ls_t077d TYPE t077d,
        lt_nriv  TYPE TABLE OF nriv,
        ls_nriv  TYPE nriv.

  ls_dropdown-handle = '1'.
  ls_dropdown-value = ''.
  APPEND ls_dropdown TO lt_dropdown_1.

  ls_dropdown-handle = '2'.
  ls_dropdown-value = ''.
  APPEND ls_dropdown TO lt_dropdown_2.

  SELECT * FROM tb001 INTO TABLE lt_tb001 WHERE bu_group IS NOT NULL AND nrrng NE ''. "#EC CI_BYPASS.
  LOOP AT lt_tb001 INTO ls_tb001.
    SELECT * FROM nriv INTO TABLE lt_nriv WHERE nrrangenr = ls_tb001-nrrng AND object = 'BU_PARTNER'.
    IF sy-subrc EQ '0'.
      LOOP AT lt_nriv INTO ls_nriv.
      ENDLOOP.
      IF ls_nriv-externind = 'X'.
        ls_dropdown-handle = '2'.
        ls_dropdown-value = ls_tb001-bu_group.
        APPEND ls_dropdown TO lt_dropdown_2.
      ELSE.
        ls_dropdown-handle = '1'.
        ls_dropdown-value = ls_tb001-bu_group.
        APPEND ls_dropdown TO lt_dropdown_1.
      ENDIF.
    ENDIF.

*    if ls_tb001-xexst = 'X' .
*      ls_dropdown-handle = '2'.
*      ls_dropdown-value = ls_tb001-bu_group.
*      append ls_dropdown to lt_dropdown.
*    else.
*      ls_dropdown-handle = '1'.
*      ls_dropdown-value = ls_tb001-bu_group.
*      append ls_dropdown to lt_dropdown.
*    endif.
  ENDLOOP.


*    call method gr_alv_ac_gp->set_drop_down_table
*      exporting
*        it_drop_down = lt_dropdown.

  LOOP AT gt_account_group INTO ls_account_group.
    MOVE-CORRESPONDING ls_account_group TO ls_outtab.
    SELECT * FROM t077d INTO TABLE lt_t077d WHERE ktokd = ls_account_group-ac_gp.
    IF sy-subrc = 0.
      LOOP AT lt_t077d INTO ls_t077d.
        SELECT * FROM nriv INTO TABLE lt_nriv WHERE nrrangenr = ls_t077d-numkr AND object = 'DEBITOR'.
        LOOP AT lt_nriv INTO ls_nriv.
        ENDLOOP.
        IF ls_nriv-externind = 'X'.
          LOOP AT lt_dropdown_2 INTO ls_dropdown WHERE handle = '2'.
            IF ls_dropdown-value IS NOT INITIAL.
              EXIT.
            ENDIF.
          ENDLOOP.
*          ls_outtab-bp_gp = '0002'.
          ls_outtab-bp_gp = ls_dropdown-value.
          ls_outtab-drop_down_handle = '2'.
        ELSE.
          LOOP AT lt_dropdown_1 INTO ls_dropdown WHERE handle = '1'.
            IF ls_dropdown-value IS NOT INITIAL.
              EXIT.
            ENDIF.
          ENDLOOP.
*          ls_outtab-bp_gp = '0001'.
          ls_outtab-bp_gp = ls_dropdown-value.
          ls_outtab-drop_down_handle = '1'.
        ENDIF.
        IF gv_count IS INITIAL.
          APPEND ls_outtab TO gt_outtab.
        ENDIF.
      ENDLOOP.
*    ELSE.
*      CONCATENATE ls_account_group-ac_gp  TEXT-034 INTO ls_outtab_log-log SEPARATED BY space.
*      ls_outtab_log-chk = 'CHK_BP_AC'.
*      ls_outtab_log-icon = gv_icon_red.
*      ls_outtab_log-value = ls_account_group-ac_gp.
*      ls_outtab_log-table = 't077d'.
*      APPEND ls_outtab_log TO gt_outtab_log.
*      APPEND ls_outtab_log TO gt_outtab_log_ac.
    ENDIF.
  ENDLOOP.


  SORT gt_outtab BY ac_gp.
  DELETE ADJACENT DUPLICATES FROM gt_outtab COMPARING ac_gp.

*  IF gt_outtab_log[] IS NOT INITIAL.
*    CLEAR ls_outtab_log.
*    READ TABLE  gt_outtab_log[] WITH KEY  chk = 'CHK_BP_AC' INTO ls_outtab_log.
*    IF sy-subrc = 0.
*      ls_outtab_log-log = 'Customization error in Customer Account Group->BP Grouping Mapping. Check Customizing '.
*      ls_outtab_log-chk = 'CHK_BP_AC'.
*      ls_outtab_log-icon = gv_icon_red.
*      APPEND ls_outtab_log TO gt_outtab_log_ac_fin.
*    ENDIF.
*  ELSE.
*    ls_outtab_log-log = 'Customization error in Customer Account Group->BP Grouping Mapping. Check Customizing '.
*    ls_outtab_log-chk = 'CHK_BP_AC'.
*    ls_outtab_log-icon = gv_icon_green.
*    APPEND ls_outtab_log TO gt_outtab_log_ac_fin.
*
*  ENDIF.

  CLEAR ls_outtab_log.
  IF gt_outtab[] IS NOT INITIAL.

    ls_outtab_log-log = 'Customer Account Group->BP Grouping Mapping is inconsistent'.
    ls_outtab_log-chk = 'CHK_BP_AC'.
    ls_outtab_log-icon = gv_icon_red.
    APPEND ls_outtab_log TO gt_outtab_log_ac_fin.
  ELSE.
    ls_outtab_log-log = 'Customer Account Group->BP Grouping Mapping is consistent'.
    ls_outtab_log-chk = 'CHK_BP_AC'.
    ls_outtab_log-icon = gv_icon_green.
    APPEND ls_outtab_log TO gt_outtab_log_ac_fin.

  ENDIF.

*  if gt_outtab[] is not initial.
  IF gr_alv_ac_gp IS INITIAL .
    CREATE OBJECT gr_alv_ac_gp
      EXPORTING
        i_parent = gr_cont_ac_gp.
  ENDIF.

  CALL METHOD gr_alv_ac_gp->set_drop_down_table
    EXPORTING
      it_drop_down = lt_dropdown_1.

  CALL METHOD gr_alv_ac_gp->set_drop_down_table
    EXPORTING
      it_drop_down = lt_dropdown_2.
*  endif.
  SORT gt_outtab_log BY value.
  DELETE ADJACENT DUPLICATES FROM gt_outtab_log[] COMPARING value.

  gv_count = 1.
*  if gt_outtab_role[] is initial.
* clear gv_flag_insert.
* endif.
ENDFORM.                    "set_data_customer2
*&---------------------------------------------------------------------*
*& Form SHOW_DATA_CUSTOMER3
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_data_customer3 .
  DATA: lt_tsabt TYPE TABLE OF tsabt WITH HEADER LINE,
        ls_tsabt LIKE LINE OF lt_tsabt.
  DATA: ls_department LIKE LINE OF gt_department,
        ls_outtab_d   LIKE LINE OF gt_outtab_d.
  DATA: lt_tpfkt TYPE TABLE OF tpfkt WITH HEADER LINE,
        ls_tpfkt LIKE LINE OF lt_tpfkt.
  DATA: ls_function  LIKE LINE OF gt_function,
        ls_outtab_fn LIKE LINE OF gt_outtab_fn.
  DATA: lt_tvpvt TYPE TABLE OF tvpvt WITH HEADER LINE,
        ls_tvpvt LIKE LINE OF lt_tvpvt.
  DATA: ls_authority LIKE LINE OF gt_authority,
        ls_outtab_au LIKE LINE OF gt_outtab_au.
  DATA: ls_vip        LIKE LINE OF gt_vip_check,
        ls_outtab_vip LIKE LINE OF gt_outtab_vip.
  DATA: lt_tvipt TYPE TABLE OF tvipt WITH HEADER LINE,
        ls_tvipt LIKE LINE OF lt_tvipt.
  DATA: lt_t502t TYPE TABLE OF t502t WITH HEADER LINE,
        ls_t502t LIKE LINE OF lt_t502t.
  DATA: ls_marital        LIKE LINE OF gt_marital_status,
        ls_outtab_marital LIKE LINE OF gt_outtab_marital.
  DATA: lt_tvgft TYPE TABLE OF tvgft WITH HEADER LINE,
        ls_tvgft LIKE LINE OF lt_tvgft.
  DATA: ls_legal        LIKE LINE OF gt_legal_form,
        ls_outtab_legal LIKE LINE OF gt_outtab_legal.
  DATA: ls_pcard        LIKE LINE OF gt_payment_card,
        ls_outtab_pcard LIKE LINE OF gt_outtab_pcard.
  DATA: lt_tvcint TYPE TABLE OF tvcint WITH HEADER LINE,
        ls_tvcint LIKE LINE OF lt_tvcint.
  DATA: lt_tsab              TYPE TABLE OF tsab,
        ls_tsab              LIKE LINE OF lt_tsab,
        lt_tpfk              TYPE TABLE OF tpfk,
        ls_tpfk              LIKE LINE OF lt_tpfk,
        lt_tvpv              TYPE TABLE OF tvpv,
        ls_tvpv              LIKE LINE OF lt_tvpv,
        lt_tvip              TYPE TABLE OF tvip,
        ls_tvip              LIKE LINE OF lt_tvip,
        lt_t502t_t           TYPE TABLE OF t502t,
        ls_t502t_t           LIKE LINE OF lt_t502t_t,
        lt_tvgf              TYPE TABLE OF tvgf,
        ls_tvgf              LIKE LINE OF lt_tvgf,
        lt_tvcin             TYPE TABLE OF tvcin,
        ls_outtab_cust_log   LIKE LINE OF gt_outtab_cust_log,
        lt_tb019             TYPE TABLE OF tb019,
        ls_tb019             LIKE LINE OF lt_tb019,
        lt_drpdwn_legal_form TYPE lvc_t_drop,
        ls_drpdwn_legal_form TYPE lvc_s_drop,
        lt_drpdwn_bp_poa     TYPE lvc_t_drop,
        ls_drpdwn_bp_poa     TYPE lvc_s_drop,
        lt_drpdwn_bp_pcard  TYPE lvc_t_drop,
        ls_drpdwn_bp_pcard  TYPE lvc_s_drop,
        lt_tb020             TYPE TABLE OF tb020,
        ls_tb020             LIKE LINE OF lt_tb020.

  DATA: lv_counter    TYPE i VALUE 0,
        lv_line_count TYPE i.

  CLEAR gt_outtab_log_custvalue[].
  "Missing department numbers for contact person
  REFRESH : gt_outtab_d,gt_outtab_fn,gt_outtab_au,gt_outtab_vip,gt_outtab_marital,gt_outtab_legal,gt_outtab_pcard,gt_outtab_cp,gt_outtab_cust_log.

  IF gt_department IS NOT INITIAL.
    DESCRIBE TABLE gt_department LINES lv_line_count.
    SELECT * FROM tsabt INTO CORRESPONDING FIELDS OF TABLE lt_tsabt WHERE  spras = sy-langu AND abtnr IS NOT NULL AND abtnr NOT  IN ( SELECT abtnr FROM cvic_cp1_link ) . "#EC CI_BUFFSUBQ.
    SELECT * FROM tsab INTO TABLE lt_tsab.
    LOOP AT gt_department INTO ls_outtab_d.
      READ TABLE lt_tsab INTO ls_tsab WITH KEY  abtnr = ls_outtab_d-dept.
      IF sy-subrc = 0.
        lv_counter = lv_counter + 1.
        READ TABLE lt_tsabt INTO ls_tsabt WITH KEY abtnr = ls_outtab_d-dept .

        IF ls_outtab_d-dept = ls_tsabt-abtnr.
          ls_outtab_d-desc = ls_tsabt-vtext.
        ENDIF.
        ls_outtab_d-dept_check = 'X'.
        ls_outtab_d-dropdown_bp_dept = '2'.
        ls_outtab_d-bp_dept_text = ''.
        APPEND ls_outtab_d TO gt_outtab_d.
        CLEAR ls_outtab_d.

      ELSEIF lv_counter < lv_line_count.
        ls_outtab_d-dept_check = 'X'.
        ls_outtab_d-dropdown_bp_dept = '2'.
        ls_outtab_d-bp_dept_text = ''.
        APPEND ls_outtab_d TO gt_outtab_d.
        CLEAR ls_outtab_d.
      ENDIF.
    ENDLOOP.

  ENDIF.

  CLEAR ls_outtab_cust_log.
  IF gt_outtab_d[] IS NOT INITIAL.

    ls_outtab_cust_log-log = 'Department assignment for Contact Person is inconsistent'.
    ls_outtab_cust_log-chk = 'CHK_CP_DEPT'.
    ls_outtab_cust_log-icon = gv_icon_red.
    APPEND ls_outtab_cust_log TO gt_outtab_log_custvalue.
  ELSE.
    ls_outtab_cust_log-log = 'Department assignment for Contact Person is consistent'.
    ls_outtab_cust_log-chk = 'CHK_CP_DEPT'.
    ls_outtab_cust_log-icon = gv_icon_green.
    APPEND ls_outtab_cust_log TO gt_outtab_log_custvalue.

  ENDIF.


  "Functions for contact person (CVI) to BP function mapping
  IF gt_function IS NOT INITIAL.
    DESCRIBE TABLE gt_function LINES lv_line_count.
    SELECT * FROM tpfkt INTO CORRESPONDING FIELDS OF TABLE lt_tpfkt WHERE  spras = sy-langu AND pafkt IS NOT NULL AND pafkt NOT  IN ( SELECT pafkt FROM cvic_cp2_link ) . "#EC CI_BUFFSUBQ.
    SELECT * FROM tpfk INTO TABLE lt_tpfk.
    LOOP AT gt_function INTO ls_outtab_fn.
      READ TABLE lt_tpfk INTO ls_tpfk WITH KEY pafkt = ls_outtab_fn-fn .
      IF sy-subrc = 0.
        lv_counter = lv_counter + 1.
        READ TABLE lt_tpfkt INTO ls_tpfkt WITH KEY pafkt = ls_outtab_fn-fn.

        IF ls_outtab_fn-fn = ls_tpfkt-pafkt.
          ls_outtab_fn-desc = ls_tpfkt-vtext.
        ENDIF.
        ls_outtab_fn-fn_check = 'X'.
        ls_outtab_fn-dropdown_bp_fn = '2'.
        ls_outtab_fn-bp_fn_text = ''.
        APPEND ls_outtab_fn TO gt_outtab_fn.
        CLEAR ls_outtab_fn.

      ELSEIF lv_counter < lv_line_count.
        ls_outtab_fn-fn_check = 'X'.
        ls_outtab_fn-dropdown_bp_fn = '2'.
        ls_outtab_fn-bp_fn_text = ''.
        APPEND ls_outtab_fn TO gt_outtab_fn.
        CLEAR ls_outtab_fn.
      ENDIF.
    ENDLOOP.

  ENDIF.
  CLEAR: lv_counter,lv_line_count.
  CLEAR ls_outtab_cust_log.
  IF gt_outtab_fn[] IS NOT INITIAL.

    ls_outtab_cust_log-log = 'Function assignment for Contact Person is inconsistent'.
    ls_outtab_cust_log-chk = 'CHK_CP_FN'.
    ls_outtab_cust_log-icon = gv_icon_red.
    APPEND ls_outtab_cust_log TO gt_outtab_log_custvalue.
  ELSE.
    ls_outtab_cust_log-log = 'Function assignment for Contact Person is consistent'.
    ls_outtab_cust_log-chk = 'CHK_CP_FN'.
    ls_outtab_cust_log-icon = gv_icon_green.
    APPEND ls_outtab_cust_log TO gt_outtab_log_custvalue.

  ENDIF.

  "Customer contact person (CVI PoA) authority to BP authoriy (BP PoA) mapping

  IF gt_auth IS NOT INITIAL.
    DESCRIBE TABLE gt_auth LINES lv_line_count.
    SELECT * FROM tvpvt INTO CORRESPONDING FIELDS OF TABLE lt_tvpvt WHERE  spras = sy-langu AND parvo IS NOT NULL
                                                                             AND parvo NOT  IN ( SELECT parvo FROM cvic_cp3_link ) . "#EC CI_BUFFSUBQ.
    SELECT * FROM tvpv INTO TABLE lt_tvpv.
    LOOP AT gt_auth INTO ls_outtab_au.
      READ TABLE lt_tvpv INTO ls_tvpv WITH KEY  parvo = ls_outtab_au-auth .
      IF sy-subrc = 0.
        lv_counter = lv_counter + 1.
        READ TABLE lt_tvpvt INTO ls_tvpvt WITH KEY parvo = ls_outtab_au-auth.

        IF ls_outtab_au-auth = ls_tvpvt-parvo.
          ls_outtab_au-desc = ls_tvpvt-vtext.
        ENDIF.
        ls_outtab_au-auth_check = 'X'.
        ls_outtab_au-dropdown_bp_poa = '2'.
        ls_outtab_au-bp_poa_auth = ''.
        APPEND ls_outtab_au TO gt_outtab_au.
        CLEAR ls_outtab_au.
      ELSEIF lv_counter < lv_line_count.
        ls_outtab_au-auth_check = 'X'.
        ls_outtab_au-dropdown_bp_poa = '2'.
        ls_outtab_au-bp_poa_auth = ''.
        APPEND ls_outtab_au TO gt_outtab_au.
        CLEAR ls_outtab_au.

      ENDIF.
    ENDLOOP.

  ENDIF.
  CLEAR: lv_counter,lv_line_count.
  CLEAR ls_outtab_cust_log.

  IF gt_outtab_au[] IS NOT INITIAL.

    ls_outtab_cust_log-log = 'Authority assignment for Contact Person is inconsistent'.
    ls_outtab_cust_log-chk = 'CHK_CP_AUTH'.
    ls_outtab_cust_log-icon = gv_icon_red.
    APPEND ls_outtab_cust_log TO gt_outtab_log_custvalue.
  ELSE.
    ls_outtab_cust_log-log = 'Authority assignment for Contact Person is consistent'.
    ls_outtab_cust_log-chk = 'CHK_CP_AUTH'.
    ls_outtab_cust_log-icon = gv_icon_green.
    APPEND ls_outtab_cust_log TO gt_outtab_log_custvalue.

  ENDIF.

  "Customer VIP Indicator to BP VIP indicator
  IF gt_vip IS NOT INITIAL.
    DESCRIBE TABLE gt_vip LINES lv_line_count.
    SELECT * FROM tvipt INTO CORRESPONDING FIELDS OF TABLE lt_tvipt WHERE  spras = sy-langu AND pavip IS NOT NULL
                                                                             AND pavip NOT  IN ( SELECT pavip FROM cvic_cp4_link ) . "#EC CI_BUFFSUBQ.
    SELECT * FROM tvip INTO TABLE lt_tvip.
    LOOP AT gt_vip INTO ls_outtab_vip.

      READ TABLE lt_tvip INTO ls_tvip WITH KEY   pavip = ls_outtab_vip-vip .
      IF sy-subrc = 0.
        lv_counter = lv_counter + 1.
        READ TABLE lt_tvipt INTO ls_tvipt WITH KEY pavip = ls_outtab_vip-vip.

        IF ls_outtab_vip-vip = ls_tvipt-pavip.
          ls_outtab_vip-desc = ls_tvipt-vtext.
        ENDIF.
        ls_outtab_vip-vip_check = 'X'.
        ls_outtab_vip-dropdown_bp_vip = '2'.
        ls_outtab_vip-bp_vip_text = ''.
        APPEND ls_outtab_vip TO gt_outtab_vip.
        CLEAR ls_outtab_vip.

      ELSEIF lv_counter < lv_line_count.
        ls_outtab_vip-vip_check = 'X'.
        ls_outtab_vip-dropdown_bp_vip = '2'.
        ls_outtab_vip-bp_vip_text = ''.
        APPEND ls_outtab_vip TO gt_outtab_vip.
        CLEAR ls_outtab_au.
      ENDIF.

    ENDLOOP.

  ENDIF.
  CLEAR: lv_counter,lv_line_count.
  CLEAR ls_outtab_cust_log.
  IF gt_outtab_vip[] IS NOT INITIAL.

    ls_outtab_cust_log-log = 'VIP Indicator assignment for Contact Person is inconsistent '.
    ls_outtab_cust_log-chk = 'CHK_CP_VIP'.
    ls_outtab_cust_log-icon = gv_icon_red.
    APPEND ls_outtab_cust_log TO gt_outtab_log_custvalue.
  ELSE.
    ls_outtab_cust_log-log = 'VIP Indicator assignment for Contact Person is consistent'.
    ls_outtab_cust_log-chk = 'CHK_CP_VIP'.
    ls_outtab_cust_log-icon = gv_icon_green.
    APPEND ls_outtab_cust_log TO gt_outtab_log_custvalue.

  ENDIF.
  "Missing Marital Status
  IF gt_marital_status IS NOT INITIAL.
    DESCRIBE TABLE gt_marital_status LINES lv_line_count.
    SELECT * FROM t502t INTO CORRESPONDING FIELDS OF TABLE lt_t502t WHERE  sprsl = sy-langu AND famst IS NOT NULL AND famst NOT  IN ( SELECT famst FROM cvic_marst_link ) . "#EC CI_BUFFSUBQ.
*    SELECT * FROM t502 INTO TABLE lt_t502.
    LOOP AT gt_marital_status INTO ls_outtab_marital.
        READ TABLE lt_t502t INTO ls_t502t WITH KEY famst = ls_outtab_marital-mstat.
        IF ls_outtab_marital-mstat = ls_t502t-famst.
          ls_outtab_marital-desc = ls_t502t-ftext.

        ENDIF.
        ls_outtab_marital-mstat_check = 'X'.
        ls_outtab_marital-dropdown_bp_marst = '2'.
        ls_outtab_marital-bp_marst_text = ''.
        APPEND ls_outtab_marital TO gt_outtab_marital.

    ENDLOOP.

  ENDIF.

  CLEAR ls_outtab_cust_log.
  CLEAR: lv_counter,lv_line_count.
  IF gt_outtab_marital[] IS NOT INITIAL.

    ls_outtab_cust_log-log = 'Marital status assignment is inconsistent '.
    ls_outtab_cust_log-chk = 'CHK_CP_MARITAL'.
    ls_outtab_cust_log-icon = gv_icon_red.
    APPEND ls_outtab_cust_log TO gt_outtab_log_custvalue.
  ELSE.
    ls_outtab_cust_log-log = 'Marital status  assignment is consistent'.
    ls_outtab_cust_log-chk = 'CHK_CP_MARITAL'.
    ls_outtab_cust_log-icon = gv_icon_green.
    APPEND ls_outtab_cust_log TO gt_outtab_log_custvalue.

  ENDIF.
  "Customer legal status to BP legal form mapping
  IF gt_legal_form IS NOT INITIAL.
    CLEAR: lv_counter,lv_line_count.
    DESCRIBE TABLE gt_legal_form LINES lv_line_count.
    SELECT * FROM tvgft INTO CORRESPONDING FIELDS OF TABLE lt_tvgft WHERE  spras = sy-langu AND gform IS NOT NULL AND gform NOT  IN ( SELECT gform FROM cvic_legform_lnk ) . "#EC CI_BUFFSUBQ.
    SELECT * FROM tvgf INTO TABLE lt_tvgf.

    "table tb019 conatains the available BP legal statuses for mapping..TB020--> text table for TB019

    LOOP AT gt_legal_form INTO ls_outtab_legal.
      READ TABLE lt_tvgf INTO ls_tvgf WITH KEY  gform = ls_outtab_legal-legal .
      IF sy-subrc = 0.
        lv_counter = lv_counter + 1.
        READ TABLE lt_tvgft INTO ls_tvgft WITH KEY gform = ls_outtab_legal-legal.

        IF ls_outtab_legal-legal = ls_tvgft-gform.
          ls_outtab_legal-desc = ls_tvgft-vtext.
        ENDIF.
        ls_outtab_legal-legal_check = 'X'.
        ls_outtab_legal-dropdown_bp_form = '2'.
        ls_outtab_legal-legal_form_bp = ls_drpdwn_legal_form-value.
        APPEND ls_outtab_legal TO gt_outtab_legal.
        CLEAR ls_outtab_legal.
      ELSEIF lv_counter < lv_line_count.
        ls_outtab_legal-legal_check = 'X'.
        ls_outtab_legal-dropdown_bp_form = '2'.
        ls_outtab_legal-legal_form_bp = ls_drpdwn_legal_form-value.
        APPEND ls_outtab_legal TO gt_outtab_legal.
        CLEAR ls_outtab_legal.

      ENDIF.
    ENDLOOP.

  ENDIF.

  CLEAR ls_outtab_cust_log.
  IF gt_outtab_legal[] IS NOT INITIAL.

    ls_outtab_cust_log-log = 'Assignment of Legal Form to Legal Status is inconsistent'.
    ls_outtab_cust_log-chk = 'CHK_CP_LEGAL'.
    ls_outtab_cust_log-icon = gv_icon_red.
    APPEND ls_outtab_cust_log TO gt_outtab_log_custvalue.
  ELSE.
    ls_outtab_cust_log-log = 'Assignment of Legal Form to Legal Status is consistent'.
    ls_outtab_cust_log-chk = 'CHK_CP_LEGAL'.
    ls_outtab_cust_log-icon = gv_icon_green.
    APPEND ls_outtab_cust_log TO gt_outtab_log_custvalue.

  ENDIF.

  IF gr_alv_legal IS INITIAL.
    CREATE OBJECT gr_alv_legal
      EXPORTING
        i_parent = gr_cont_legal.
  ENDIF.

  "Payment card types (CVI) to payment card types (BP)
  IF gt_payment_card IS NOT INITIAL.
    CLEAR: lv_counter,lv_line_count.
    DESCRIBE TABLE gt_payment_card LINES lv_line_count.
    SELECT * FROM tvcint INTO CORRESPONDING FIELDS OF TABLE lt_tvcint WHERE  spras = sy-langu AND ccins IS NOT NULL AND ccins NOT  IN ( SELECT ccins FROM cvic_ccid_link ) . "#EC CI_BUFFSUBQ.
    SELECT * FROM tvcin INTO TABLE lt_tvcin. "#EC CI_GENBUFF.
    LOOP AT gt_payment_card INTO ls_outtab_pcard.
      READ TABLE lt_tvcin INTO ls_tvcin WITH KEY  ccins = ls_outtab_pcard-pcard .
      IF sy-subrc = 0.
        lv_counter = lv_counter + 1.
        READ TABLE lt_tvcint INTO ls_tvcint WITH KEY ccins = ls_outtab_pcard-pcard.
        IF ls_outtab_pcard-pcard = ls_tvcint-ccins.
          ls_outtab_pcard-desc = ls_tvcint-vtext.
        ENDIF.
        ls_outtab_pcard-pcard_check = 'X'.
        ls_outtab_pcard-dropdown_bp_pcard = '2'.
        ls_outtab_pcard-bp_pcard_text = ls_drpdwn_bp_pcard-value.
        APPEND ls_outtab_pcard TO gt_outtab_pcard.
        CLEAR ls_outtab_pcard.
      ELSEIF lv_counter < lv_line_count.
        ls_outtab_pcard-pcard_check = 'X'.
        ls_outtab_pcard-dropdown_bp_pcard = '2'.
        ls_outtab_pcard-bp_pcard_text = ls_drpdwn_bp_pcard-value.
        APPEND ls_outtab_pcard TO gt_outtab_pcard.
        CLEAR ls_outtab_pcard.
      ENDIF.

  ENDLOOP.

ENDIF.

CLEAR ls_outtab_cust_log.
IF gt_outtab_pcard[] IS NOT INITIAL.

  ls_outtab_cust_log-log = 'Payment Card Assignment is inconsistent'.
  ls_outtab_cust_log-chk = 'CHK_CP_PAYMENT'.
  ls_outtab_cust_log-icon = gv_icon_red.
  APPEND ls_outtab_cust_log TO gt_outtab_log_custvalue.
ELSE.
  ls_outtab_cust_log-log = 'Payment Card Assignment is consistent'.
  ls_outtab_cust_log-chk = 'CHK_CP_PAYMENT'.
  ls_outtab_cust_log-icon = gv_icon_green.
  APPEND ls_outtab_cust_log TO gt_outtab_log_custvalue.

ENDIF.
IF gr_alv_cust_log IS INITIAL.
  CREATE OBJECT gr_alv_cust_log
    EXPORTING
      i_parent = gr_cont_cust_log.
ENDIF.
"missing contact person assignment
CLEAR ls_outtab_cust_log.
IF gt_cp[] IS NOT INITIAL.

  ls_outtab_cust_log-log = 'Inconsistencies in Activating Assignment of Contact Person  '.
  ls_outtab_cust_log-chk = 'CHK_CP_ASSIGN'.
  ls_outtab_cust_log-icon = gv_icon_red.
  APPEND ls_outtab_cust_log TO gt_outtab_log_custvalue.
ELSE.
  ls_outtab_cust_log-log = 'Activating Assignment of Contact Person is consistent'.
  ls_outtab_cust_log-chk = 'CHK_CP_ASSIGN'.
  ls_outtab_cust_log-icon = gv_icon_green.
  APPEND ls_outtab_cust_log TO gt_outtab_log_custvalue.

ENDIF.
ENDFORM.                    "set_data_customer3
*&---------------------------------------------------------------------*
*& Form SET_DATA_CUSTOMER4
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_data_customer4 .
  DATA: lt_t016t            TYPE TABLE OF t016t WITH HEADER LINE,
        ls_t016t            LIKE LINE OF lt_t016t,
        lt_tb038t           TYPE TABLE OF tb038t WITH HEADER LINE,
        ls_tb038t           LIKE LINE OF lt_tb038t,
        lv_index            TYPE i,
        lv_flag             TYPE bool VALUE gc_false,
        ls_outtab_ind_in    LIKE LINE OF gt_outtab_ind_in,
        ls_outtab_ind_out   LIKE LINE OF gt_outtab_ind_out,
        lt_t016             TYPE TABLE OF t016 WITH HEADER LINE,
        ls_t016             LIKE LINE OF lt_t016,
        ls_outtab_cust_log2 LIKE LINE OF gt_outtab_cust_log2.
  DATA: lt_tb038a TYPE TABLE OF tb038a,
        ls_tb038a TYPE tb038a.
  DATA: lt_dropdown_ind_in TYPE lvc_t_drop,
        ls_dropdown_ind_in TYPE lvc_s_drop.
  DATA: lt_tp038m2 TYPE TABLE OF tp038m2,
        ls_tp038m2 LIKE LINE OF lt_tp038m2.
  DATA: lt_tp038m1 TYPE TABLE OF tp038m1,
        ls_tp038m1 LIKE LINE OF lt_tp038m1.
  DATA : ls_outtab_ind_sys LIKE LINE OF gt_outtab_ind_sys.
  DATA: lv_lines(5) TYPE i.
  DATA : lv_log TYPE bool VALUE abap_false.
  REFRESH : gt_outtab_ind_in,gt_outtab_ind_out,gt_outtab_cust_log2.
  CLEAR:  gt_outtab_log_ind[],gt_outtab_ind_sys[].
  "fetching all available industry systems
  SELECT DISTINCT istype bez30 FROM tb038t INTO CORRESPONDING FIELDS OF TABLE lt_tb038t WHERE langu = sy-langu . "#EC CI_BYPASS.

    LOOP AT lt_tb038t INTO ls_tb038t.


      ls_outtab_ind_sys-indsys = ls_tb038t-istype.
      ls_outtab_ind_sys-desc = ls_tb038t-bez30.
      APPEND ls_outtab_ind_sys TO gt_outtab_ind_sys.

    ENDLOOP.
    CLEAR  ls_outtab_ind_sys.
    "setting the currently selected industry system
    LOOP AT gt_outtab_ind_sys INTO ls_outtab_ind_sys.
      IF ls_outtab_ind_sys-indsys = gv_istype.
        ls_outtab_ind_sys-isys_check = 'X'.
        MODIFY gt_outtab_ind_sys INDEX sy-tabix FROM ls_outtab_ind_sys TRANSPORTING isys_check.
      ENDIF.
    ENDLOOP.

    "processing incoming/outgoing industry keys
    IF ind_in = 'X'.
      IF gt_industry_in IS NOT INITIAL.
        SELECT brsch FROM tp038m2 INTO TABLE lt_tp038m2."  WHERE brsch IS NOT NULL.
          IF sy-subrc = 0.
            delete lt_tp038m2 where brsch is initial.
          ENDIF.

          SELECT * FROM t016t INTO TABLE lt_t016t WHERE spras = sy-langu.

            SELECT * FROM t016 INTO  TABLE lt_t016  .
              "check whether industry key is maintained in t016
              LOOP AT gt_industry_in INTO ls_outtab_ind_in.
                READ TABLE lt_t016 INTO ls_t016 WITH KEY brsch = ls_outtab_ind_in-indkey .
                IF sy-subrc = 0.
                  READ TABLE lt_t016t INTO ls_t016t WITH KEY brsch = ls_outtab_ind_in-indkey .

                  IF ls_outtab_ind_in-indkey = ls_t016t-brsch.
                    ls_outtab_ind_in-desc = ls_t016t-brtxt.

                  ENDIF.
                  ls_outtab_ind_in-ikey_check = 'X'.
                  APPEND ls_outtab_ind_in TO gt_outtab_ind_in.

*                ELSE.
*                  CONCATENATE ls_outtab_ind_in-indkey TEXT-043 INTO ls_outtab_cust_log2-log SEPARATED BY space.
*                  ls_outtab_cust_log2-chk = 'CHK_CP_IND_IN'.
*                  ls_outtab_cust_log2-icon = gv_icon_red.
*                  ls_outtab_cust_log2-value = ls_outtab_ind_in-indkey .
*                  APPEND ls_outtab_cust_log2 TO gt_outtab_cust_log2.
                ENDIF.
              ENDLOOP.
              "loading all avilable industry sectors for current industry system
              SELECT * FROM tb038a INTO TABLE lt_tb038a WHERE istype = gv_istype.
                IF lt_tb038a IS INITIAL.
                  CLEAR ls_outtab_cust_log2.
                  ls_outtab_cust_log2-chk = 'CHK_CP_IND_IN'.
                  ls_outtab_cust_log2-icon = gv_icon_red.
                  ls_outtab_cust_log2-log = 'Create new industry sector to maintain industry keys for Industry System.Click to navigate'.
                  APPEND ls_outtab_cust_log2 TO gt_outtab_log_ind.
                ENDIF.

                LOOP AT lt_tb038a INTO ls_tb038a.

                  ls_dropdown_ind_in-handle = '1'.
                  ls_dropdown_ind_in-value = ls_tb038a-ind_sector.
                  APPEND ls_dropdown_ind_in TO lt_dropdown_ind_in.
                ENDLOOP.
                lv_index = 1.
                LOOP AT gt_outtab_ind_in INTO ls_outtab_ind_in .
                  ls_outtab_ind_in-indsector = ls_dropdown_ind_in-value.
                  ls_outtab_ind_in-drop_down_handle = '1'.
                  MODIFY gt_outtab_ind_in INDEX lv_index FROM ls_outtab_ind_in TRANSPORTING indsector drop_down_handle.
                  lv_index = lv_index + 1.
                ENDLOOP.
              ENDIF.
*              IF gt_outtab_cust_log2[] IS NOT INITIAL.
*                CLEAR ls_outtab_cust_log2.
*                READ TABLE  gt_outtab_cust_log2[] WITH KEY  chk = 'CHK_CP_IND_IN' INTO ls_outtab_cust_log2.
*                IF sy-subrc = 0.
*                  ls_outtab_cust_log2-log = 'Customization error in assignment of Incoming Industries. Check Customization '.
*                  ls_outtab_cust_log2-chk = 'CHK_CP_IND_IN'.
*                  ls_outtab_cust_log2-icon = gv_icon_red.
*                  APPEND ls_outtab_cust_log2 TO gt_outtab_log_ind.
*                ENDIF.
*              ELSE.
*                ls_outtab_cust_log2-log = 'No Customization error in Assignment of Incoming Industries'.
*                ls_outtab_cust_log2-chk = 'CHK_CP_IND_IN'.
*                ls_outtab_cust_log2-icon = gv_icon_green.
*                APPEND ls_outtab_cust_log2 TO gt_outtab_log_ind.
*              ENDIF.
*              CLEAR ls_outtab_cust_log2.
              IF gt_outtab_ind_in[] IS NOT INITIAL.

                ls_outtab_cust_log2-log = 'Assignment of Incoming Industries is inconsistent'.
                ls_outtab_cust_log2-chk = 'CHK_CP_IND_IN'.
                ls_outtab_cust_log2-icon = gv_icon_red.
                APPEND ls_outtab_cust_log2 TO gt_outtab_log_ind.
              ELSE.
                ls_outtab_cust_log2-log = 'Assignment of Incoming Industries is consistent'.
                ls_outtab_cust_log2-chk = 'CHK_CP_IND_IN'.
                ls_outtab_cust_log2-icon = gv_icon_green.
                APPEND ls_outtab_cust_log2 TO gt_outtab_log_ind.

              ENDIF.
            ELSE.
              IF gt_industry_out IS NOT INITIAL.
                SELECT brsch FROM tp038m1 INTO TABLE lt_tp038m1."  WHERE brsch IS NOT NULL.
                  IF sy-subrc = 0.
                    delete lt_tp038m1 where brsch is initial.
                  ENDIF.

                  SELECT  * FROM t016t INTO  TABLE lt_t016t WHERE spras = sy-langu.

                    SELECT  * FROM t016 INTO TABLE lt_t016  .

                      LOOP AT gt_industry_out INTO ls_outtab_ind_in.
                        READ TABLE lt_t016 INTO ls_t016 WITH KEY brsch = ls_outtab_ind_in-indkey .
                        IF sy-subrc = 0.



                          READ TABLE lt_t016t INTO ls_t016t WITH KEY brsch = ls_outtab_ind_in-indkey .


                          IF ls_outtab_ind_in-indkey = ls_t016t-brsch.
                            ls_outtab_ind_in-desc = ls_t016t-brtxt.

                          ENDIF.
                          ls_outtab_ind_in-ikey_check = 'X'.
                          APPEND ls_outtab_ind_in TO gt_outtab_ind_in.
*
*
*
*                        ELSE.
*                          CONCATENATE ls_outtab_ind_in-indkey TEXT-043 INTO ls_outtab_cust_log2-log SEPARATED BY space.
*                          ls_outtab_cust_log2-chk = 'CHK_CP_IND_OUT'.
*                          ls_outtab_cust_log2-icon = gv_icon_red.
*                          ls_outtab_cust_log2-value = ls_outtab_ind_in-indkey .
*                          APPEND ls_outtab_cust_log2 TO gt_outtab_cust_log2.
                        ENDIF.

                      ENDLOOP.
                      CLEAR  lt_tb038a.
                      SELECT * FROM tb038a INTO TABLE lt_tb038a WHERE istype = gv_istype AND ind_sector NOT IN ( SELECT ind_sector FROM tp038m1 WHERE istype = gv_istype  ) . "#EC CI_BUFFSUBQ.
                        IF lt_tb038a IS INITIAL.
                          lv_log = abap_true.
                        ENDIF.
                        DESCRIBE TABLE lt_tb038a LINES lv_lines.
                        ls_dropdown_ind_in-handle = '1'.
                        ls_dropdown_ind_in-value = ' '.
                        APPEND ls_dropdown_ind_in TO lt_dropdown_ind_in.
                        LOOP AT lt_tb038a INTO ls_tb038a.

                          ls_dropdown_ind_in-handle = '1'.
                          ls_dropdown_ind_in-value = ls_tb038a-ind_sector.
                          APPEND ls_dropdown_ind_in TO lt_dropdown_ind_in.
                        ENDLOOP.
                        lv_index = 1.
                        LOOP AT gt_outtab_ind_in INTO ls_outtab_ind_in .
                          IF lv_index <= lv_lines.
                            READ TABLE lt_tb038a INDEX sy-tabix INTO ls_tb038a.
                            ls_outtab_ind_in-indsector = ls_tb038a-ind_sector."ls_dropdown_ind_in-value.

                          ELSE.
                            ls_outtab_ind_in-indsector = ' '.
                            lv_log = abap_true.
                          ENDIF.
                          ls_outtab_ind_in-drop_down_handle = '1'.
                          MODIFY gt_outtab_ind_in INDEX lv_index FROM ls_outtab_ind_in TRANSPORTING indsector drop_down_handle.
                          lv_index = lv_index + 1.
                        ENDLOOP.
                        IF lv_log = abap_true.
                          CLEAR ls_outtab_cust_log2.
                          ls_outtab_cust_log2-chk = 'CHK_CP_IND_OUT'.
                          ls_outtab_cust_log2-icon = gv_icon_red.
                          ls_outtab_cust_log2-log = 'Create new industry sector to maintain industry keys for Outgoing Industry.Click to navigate'.
                          APPEND ls_outtab_cust_log2 TO gt_outtab_log_ind.
                        ENDIF.
                      ENDIF.
*                      IF gt_outtab_cust_log2[] IS NOT INITIAL.
*                        CLEAR ls_outtab_cust_log2.
*                        READ TABLE  gt_outtab_cust_log2[] WITH KEY  chk = 'CHK_CP_IND_OUT' INTO ls_outtab_cust_log2.
*                        IF sy-subrc = 0.
*                          ls_outtab_cust_log2-log = 'Customization error in assignment of Outgoing Industries. Check Customization '.
*                          ls_outtab_cust_log2-chk = 'CHK_CP_IND_OUT'.
*                          ls_outtab_cust_log2-icon = gv_icon_red.
*                          APPEND ls_outtab_cust_log2 TO gt_outtab_log_ind.
*                        ENDIF.
*                      ELSE.
*                        ls_outtab_cust_log2-log = 'No Customization error in Assignment of Outgoing Industries'.
*                        ls_outtab_cust_log2-chk = 'CHK_CP_IND_OUT'.
*                        ls_outtab_cust_log2-icon = gv_icon_green.
*                        APPEND ls_outtab_cust_log2 TO gt_outtab_log_ind.
*                      ENDIF.
                      CLEAR ls_outtab_cust_log2.
                      IF gt_outtab_ind_in[] IS NOT INITIAL.

                        ls_outtab_cust_log2-log = 'Assignment of Outgoing Industries is inconsistent'.
                        ls_outtab_cust_log2-chk = 'CHK_CP_IND_OUT'.
                        ls_outtab_cust_log2-icon = gv_icon_red.
                        APPEND ls_outtab_cust_log2 TO gt_outtab_log_ind.
                      ELSE.
                        ls_outtab_cust_log2-log = 'Assignment of Outgoing Industries is consistent'.
                        ls_outtab_cust_log2-chk = 'CHK_CP_IND_OUT'.
                        ls_outtab_cust_log2-icon = gv_icon_green.
                        APPEND ls_outtab_cust_log2 TO gt_outtab_log_ind.

                      ENDIF.
                    ENDIF.
                    CREATE OBJECT gr_alv_ind_out
                      EXPORTING
                        i_parent = gr_cont_ind_out.
                    CALL METHOD gr_alv_ind_out->set_drop_down_table
                      EXPORTING
                        it_drop_down = lt_dropdown_ind_in.
ENDFORM.                    "set_data_customer4
*&---------------------------------------------------------------------*
*& Form SET_DATA_CHK_CUST
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_data_chk_cust .
  DATA: lt_nriv TYPE TABLE OF nriv,
        ls_nriv LIKE LINE OF lt_nriv.
  DATA: lt_dropdown_no_range   TYPE lvc_t_drop,
        ls_dropdown_no_range   TYPE lvc_s_drop,
        ls_outtab_chk_cust_log LIKE LINE OF gt_outtab_chk_cust_log.
  READ TABLE  gt_outtab_chk_cust_log[] WITH KEY  table = 't077k'  INTO ls_outtab_chk_cust_log.
  IF sy-subrc = 0 .
    SELECT * FROM nriv INTO TABLE lt_nriv WHERE object = 'KREDITOR'.
      LOOP AT lt_nriv INTO ls_nriv.
        ls_dropdown_no_range-handle = '1'.
        ls_dropdown_no_range-value = ls_nriv-nrrangenr.
        APPEND ls_dropdown_no_range TO lt_dropdown_no_range.
      ENDLOOP.
      LOOP AT gt_outtab_chk_cust_log INTO  ls_outtab_chk_cust_log.
        CLEAR   ls_outtab_chk_cust_log.
        ls_outtab_chk_cust_log-no_range = ls_dropdown_no_range-value.
        ls_outtab_chk_cust_log-drop_down_handle = '1'.
        MODIFY gt_outtab_chk_cust_log[] FROM ls_outtab_chk_cust_log TRANSPORTING no_range drop_down_handle.
      ENDLOOP.
*sort gt_outtab_chk_cust_log[] by value.


    ELSE.
      READ TABLE  gt_outtab_chk_cust_log[] WITH KEY  table = 't077d'  INTO ls_outtab_chk_cust_log.
      IF sy-subrc = 0.


        SELECT * FROM nriv INTO TABLE lt_nriv WHERE object = 'DEBITOR'.
          LOOP AT lt_nriv INTO ls_nriv.
            ls_dropdown_no_range-handle = '1'.
            ls_dropdown_no_range-value = ls_nriv-nrrangenr.
            APPEND ls_dropdown_no_range TO lt_dropdown_no_range.
          ENDLOOP.
          LOOP AT gt_outtab_chk_cust_log INTO  ls_outtab_chk_cust_log.
            CLEAR   ls_outtab_chk_cust_log.
            ls_outtab_chk_cust_log-no_range = ls_dropdown_no_range-value.
            ls_outtab_chk_cust_log-drop_down_handle = '1'.
            MODIFY gt_outtab_chk_cust_log[] FROM ls_outtab_chk_cust_log TRANSPORTING no_range drop_down_handle.
          ENDLOOP.
        ENDIF.
      ENDIF.
      CALL METHOD gr_alv_cust_log->set_drop_down_table
        EXPORTING
          it_drop_down = lt_dropdown_no_range.


ENDFORM.                    "set_data_chk_cust
*&---------------------------------------------------------------------*
*&      Form  SET_DATA_CUST_EXISTING
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_data_cust_existing .
  DATA: lt_tsabt TYPE TABLE OF tsabt WITH HEADER LINE,
        ls_tsabt LIKE LINE OF lt_tsabt.
  DATA: ls_department LIKE LINE OF gt_department,
        ls_outtab_d   LIKE LINE OF gt_outtab_d.
  DATA: lt_tpfkt TYPE TABLE OF tpfkt WITH HEADER LINE,
        ls_tpfkt LIKE LINE OF lt_tpfkt.
  DATA: ls_function  LIKE LINE OF gt_function,
        ls_outtab_fn LIKE LINE OF gt_outtab_fn.
  DATA: lt_tvpvt TYPE TABLE OF tvpvt WITH HEADER LINE,
        ls_tvpvt LIKE LINE OF lt_tvpvt.
  DATA: ls_authority LIKE LINE OF gt_authority,
        ls_outtab_au LIKE LINE OF gt_outtab_au.
  DATA: ls_vip        LIKE LINE OF gt_vip_check,
        ls_outtab_vip LIKE LINE OF gt_outtab_vip.
  DATA: lt_tvipt TYPE TABLE OF tvipt WITH HEADER LINE,
        ls_tvipt LIKE LINE OF lt_tvipt.
  DATA: lt_t502t TYPE TABLE OF t502t WITH HEADER LINE,
        ls_t502t LIKE LINE OF lt_t502t.
  DATA: ls_marital        LIKE LINE OF gt_marital_status,
        ls_outtab_marital LIKE LINE OF gt_outtab_marital.
  DATA: lt_tvgft TYPE TABLE OF tvgft WITH HEADER LINE,
        ls_tvgft LIKE LINE OF lt_tvgft.
  DATA: ls_legal        LIKE LINE OF gt_legal_form,
        ls_outtab_legal LIKE LINE OF gt_outtab_legal.
  DATA: ls_pcard        LIKE LINE OF gt_payment_card,
        ls_outtab_pcard LIKE LINE OF gt_outtab_pcard.
  DATA: lt_tvcint TYPE TABLE OF tvcint WITH HEADER LINE,
        ls_tvcint LIKE LINE OF lt_tvcint.
  DATA: lt_tsab    TYPE TABLE OF tsab,
        ls_tsab    LIKE LINE OF lt_tsab,
        lt_tpfk    TYPE TABLE OF tpfk,
        ls_tpfk    LIKE LINE OF lt_tpfk,
        lt_tvpv    TYPE TABLE OF tvpv,
        ls_tvpv    LIKE LINE OF lt_tvpv,
        lt_tvip    TYPE TABLE OF tvip,
        ls_tvip    LIKE LINE OF lt_tvip,
        lt_t502t_t TYPE TABLE OF t502t,
        ls_t502t_t LIKE LINE OF lt_t502t_t,
        lt_tvgf    TYPE TABLE OF tvgf,
        ls_tvgf    LIKE LINE OF lt_tvgf,
        lt_tvcin   TYPE TABLE OF tvcin.

  DATA: lt_authority_link TYPE TABLE OF cvic_cp3_link,
        ls_authority_link LIKE LINE OF lt_authority_link,
        lt_tb915          TYPE TABLE OF tb915,
        ls_tb915          LIKE LINE OF lt_tb915,
        lt_legal_form_lnk TYPE TABLE OF cvic_legform_lnk,
        ls_legal_form_lnk LIKE LINE OF lt_legal_form_lnk,
        lt_tb020          TYPE TABLE OF tb020,
        ls_tb020          LIKE LINE OF lt_tb020,
        lt_dept_link      TYPE TABLE OF cvic_cp1_link,
        ls_dept_link      LIKE LINE OF lt_dept_link,
        lt_tb911          TYPE TABLE OF tb911,
        ls_tb911          LIKE LINE OF lt_tb911,
        lt_function_link  TYPE TABLE OF cvic_cp2_link,
        ls_function_link  LIKE LINE OF lt_function_link,
        lt_tb913          TYPE TABLE OF tb913,
        ls_tb913          LIKE LINE OF lt_tb913,
        lt_vip_link       TYPE TABLE OF cvic_cp4_link,
        ls_vip_link       LIKE LINE OF lt_vip_link,
        lt_tb917          TYPE TABLE OF tb917,
        ls_tb917          LIKE LINE OF lt_tb917,
        lt_marst_link     TYPE TABLE OF cvic_marst_link,
        ls_marst_link     LIKE LINE OF lt_marst_link,
        lt_tb027t         TYPE TABLE OF tb027t,
        ls_tb027t         LIKE LINE OF lt_tb027t,
        lt_paycard_link   TYPE TABLE OF cvic_ccid_link,
        ls_paycard_link   LIKE LINE OF lt_paycard_link,
        lt_tb033t         TYPE TABLE OF tb033t,
        ls_tb033t         LIKE LINE OF lt_tb033t.



  REFRESH : gt_outtab_d,gt_outtab_fn,gt_outtab_au,gt_outtab_vip,gt_outtab_marital,gt_outtab_legal,gt_outtab_pcard,gt_outtab_cp.

  "Department numbers for contact person (CVI) to Departmenr numbers (BP)
  SELECT * FROM cvic_cp1_link INTO CORRESPONDING FIELDS OF TABLE lt_dept_link.
    SELECT * FROM tsabt INTO CORRESPONDING FIELDS OF TABLE lt_tsabt WHERE  spras = sy-langu." AND abtnr IS NOT NULL. "AND abtnr IN ( SELECT abtnr FROM cvic_cp1_link ) . "#EC CI_BUFFSUBQ.
      IF sy-subrc = 0.
        delete lt_tsabt where abtnr is initial.
      ENDIF.
      SELECT * FROM tb911 INTO CORRESPONDING FIELDS OF TABLE lt_tb911 WHERE spras = sy-langu." AND abtnr IS NOT NULL.
        IF sy-subrc = 0.
        delete lt_tb911 where abtnr is initial.
      ENDIF.

        LOOP AT lt_dept_link INTO ls_dept_link.
          IF lt_dept_link[] IS NOT INITIAL .

            READ TABLE lt_tb911 INTO ls_tb911 WITH KEY abtnr = ls_dept_link-abtnr.
            IF sy-subrc = 0.
              ls_outtab_d-bp_dept_key = ls_tb911-abtnr.
              ls_outtab_d-bp_dept_text = ls_tb911-bez20.
            ENDIF.

            READ TABLE lt_tsabt INTO ls_tsabt WITH KEY abtnr = ls_dept_link-abtnr.
            IF sy-subrc = 0.
              ls_outtab_d-dept = ls_tsabt-abtnr.
              ls_outtab_d-desc = ls_tsabt-vtext.
            ELSE. " This means , there is an entry in link table for contact person department (CVI) but no corresponding record in TSAB
              ls_outtab_d-dept = ls_dept_link-abtnr.
            ENDIF.
            APPEND ls_outtab_d TO gt_outtab_d.
            CLEAR ls_outtab_d.

          ENDIF.
        ENDLOOP.


        "Existing functions for contact person
        SELECT * FROM cvic_cp2_link INTO CORRESPONDING FIELDS OF TABLE lt_function_link.
          SELECT * FROM tpfkt INTO CORRESPONDING FIELDS OF TABLE lt_tpfkt WHERE  spras = sy-langu." AND pafkt IS NOT NULL. "AND pafkt IN ( SELECT pafkt FROM cvic_cp2_link ) . "#EC CI_BUFFSUBQ.
            IF sy-subrc = 0.
              delete lt_tpfkt where pafkt is initial.
            ENDIF.
            SELECT * FROM tb913 INTO CORRESPONDING FIELDS OF TABLE lt_tb913 WHERE spras = sy-langu." AND pafkt IS NOT NULL.
              IF sy-subrc = 0.
              delete lt_tb913 where pafkt is initial.
            ENDIF.

              LOOP AT lt_function_link INTO ls_function_link.
                IF lt_function_link IS NOT INITIAL.

                  READ TABLE lt_tb913 INTO ls_tb913 WITH KEY pafkt = ls_function_link-gp_pafkt.
                  IF sy-subrc = 0 .
                    ls_outtab_fn-bp_fn_key = ls_tb913-pafkt.
                    ls_outtab_fn-bp_fn_text = ls_tb913-bez30.
                  ENDIF.

                  READ TABLE lt_tpfkt INTO ls_tpfkt WITH KEY pafkt = ls_function_link-pafkt.
                  IF sy-subrc = 0.
                    ls_outtab_fn-fn = ls_tpfkt-pafkt.
                    ls_outtab_fn-desc = ls_tpfkt-vtext.
                  ELSE.
                    ls_outtab_fn-fn = ls_function_link-pafkt.
                  ENDIF.
                  APPEND ls_outtab_fn TO gt_outtab_fn.
                  CLEAR ls_outtab_fn.

                ENDIF.
              ENDLOOP.

              "Authority for Customer contact person to BP Power of Attorney (PoA)
              SELECT * FROM cvic_cp3_link INTO CORRESPONDING FIELDS OF TABLE lt_authority_link.
                SELECT * FROM tvpvt INTO CORRESPONDING FIELDS OF TABLE lt_tvpvt  WHERE  spras = sy-langu." AND parvo IS NOT NULL." and parvo in ( select parvo from cvic_cp3_link ) . "#EC CI_BUFFSUBQ.
                  IF sy-subrc = 0.
                    delete lt_tvpvt where parvo is initial.
                  ENDIF.
                  SELECT * FROM tb915 INTO CORRESPONDING FIELDS OF TABLE lt_tb915  WHERE  spras = sy-langu." AND paauth IS NOT NULL." and paauth in ( select paauth from cvic_cp3_link ).
                    IF sy-subrc = 0.
                    delete lt_tb915 where paauth is initial.
                  ENDIF.

                    LOOP AT lt_authority_link INTO ls_authority_link.
                      IF lt_authority_link IS NOT INITIAL.
                        READ TABLE lt_tb915 INTO ls_tb915 WITH KEY paauth = ls_authority_link-paauth.
                        IF sy-subrc = 0.
                          ls_outtab_au-bp_poa_key = ls_tb915-paauth.
                          ls_outtab_au-bp_poa_auth = ls_tb915-bez20.

                        ENDIF.

                        READ TABLE lt_tvpvt INTO ls_tvpvt WITH KEY parvo = ls_authority_link-parvo.
                        IF sy-subrc = 0.
                          ls_outtab_au-auth = ls_tvpvt-parvo.
                          ls_outtab_au-desc = ls_tvpvt-vtext.
                        ELSE. " This means , there is an entry in link table for customer Authority but no corresponding record in TVPV
                          ls_outtab_au-auth = ls_authority_link-parvo.
                        ENDIF.
                        APPEND ls_outtab_au TO gt_outtab_au.
                        CLEAR ls_outtab_au.
                      ENDIF.
                    ENDLOOP.



                    "VIP Indicators for customer contact person (CVI) to BP
                    SELECT * FROM cvic_cp4_link INTO CORRESPONDING FIELDS OF TABLE lt_vip_link.
                      SELECT * FROM tvipt INTO CORRESPONDING FIELDS OF TABLE lt_tvipt WHERE  spras = sy-langu." AND pavip IS NOT NULL. "AND pavip IN ( SELECT pavip FROM cvic_cp4_link ) . "#EC CI_BUFFSUBQ.
                        IF sy-subrc = 0.
                    delete lt_tvipt where pavip is initial.
                  ENDIF.
                        SELECT * FROM tb917 INTO CORRESPONDING FIELDS OF TABLE lt_tb917  WHERE  spras = sy-langu." AND pavip IS NOT NULL.
                          IF sy-subrc = 0.
                    delete lt_tb917 where pavip is initial.
                  ENDIF.

                          LOOP AT lt_vip_link INTO ls_vip_link.
                            IF lt_vip_link IS NOT INITIAL.

                              READ TABLE lt_tb917 INTO ls_tb917 WITH KEY pavip = ls_vip_link-gp_pavip.
                              IF sy-subrc = 0.
                                ls_outtab_vip-bp_vip_key = ls_tb917-pavip.
                                ls_outtab_vip-bp_vip_text = ls_tb917-bez20.
                              ENDIF.

                              READ TABLE lt_tvipt INTO ls_tvipt WITH KEY pavip = ls_vip_link-pavip.
                              IF sy-subrc = 0.
                                ls_outtab_vip-vip = ls_tvipt-pavip.
                                ls_outtab_vip-desc = ls_tvipt-vtext.
                              ELSE.
                                ls_outtab_vip-vip = ls_vip_link-pavip.
                              ENDIF.

                              APPEND ls_outtab_vip TO gt_outtab_vip.
                              CLEAR ls_outtab_vip.

                            ENDIF.
                          ENDLOOP.

                          "Marital Status (CVI) to Marital Status (BP)
                          SELECT * FROM cvic_marst_link INTO CORRESPONDING FIELDS OF TABLE lt_marst_link.
                            SELECT * FROM t502t INTO CORRESPONDING FIELDS OF TABLE lt_t502t WHERE  sprsl = sy-langu." AND famst IS NOT NULL. "AND famst IN ( SELECT famst FROM cvic_marst_link ) . "#EC CI_BUFFSUBQ.
                              IF sy-subrc = 0.
                                delete lt_t502t WHERE famst is INITIAL.
                              ENDIF.
                              SELECT * FROM tb027t INTO CORRESPONDING FIELDS OF TABLE lt_tb027t  WHERE  spras = sy-langu." AND marst IS NOT NULL. "AND marst IN ( SELECT marst FROM cvic_marst_link ).
                                IF sy-subrc = 0.
                                delete lt_tb027t WHERE marst is INITIAL.
                              ENDIF.
                                LOOP AT lt_marst_link INTO ls_marst_link.
                                  IF lt_marst_link IS NOT INITIAL.
                                    READ TABLE lt_tb027t INTO ls_tb027t WITH KEY marst = ls_marst_link-marst.
                                    IF sy-subrc = 0.
                                      ls_outtab_marital-bp_marst_key = ls_tb027t-marst.
                                      ls_outtab_marital-bp_marst_text = ls_tb027t-bez20.
                                    ENDIF.

                                    READ TABLE lt_t502t INTO ls_t502t WITH KEY famst = ls_marst_link-famst.
                                    IF sy-subrc = 0.
                                      ls_outtab_marital-mstat = ls_t502t-famst.
                                      ls_outtab_marital-desc = ls_t502t-ftext.
                                    ELSE.
                                      ls_outtab_marital = ls_marst_link-famst.
                                    ENDIF.

                                    APPEND ls_outtab_marital TO gt_outtab_marital.
                                    CLEAR ls_outtab_marital.
                                  ENDIF.
                                ENDLOOP.

                                "Customer legal status to BP legal form
                                SELECT * FROM cvic_legform_lnk INTO CORRESPONDING FIELDS OF TABLE lt_legal_form_lnk.
                                  SELECT * FROM tvgft INTO CORRESPONDING FIELDS OF TABLE lt_tvgft WHERE  spras = sy-langu." AND gform IS NOT NULL. "AND gform IN ( SELECT gform FROM cvic_legform_lnk ) . "#EC CI_BUFFSUBQ.
                                    IF sy-subrc = 0.
                                      delete lt_tvgft where gform is initial.
                                    ENDIF.
                                    SELECT * FROM tb020 INTO CORRESPONDING FIELDS OF TABLE lt_tb020 WHERE  spras = sy-langu." AND legal_enty IS NOT NULL. "AND legal_enty IN ( SELECT legal_enty FROM cvic_legform_lnk ) . "#EC CI_BUFFSUBQ.
                                      IF sy-subrc = 0.
                                      delete lt_tb020 where legal_enty is initial.
                                    ENDIF.

                                      LOOP AT lt_legal_form_lnk INTO ls_legal_form_lnk.
                                        IF lt_legal_form_lnk IS NOT INITIAL.
                                          READ TABLE lt_tb020 INTO ls_tb020 WITH KEY legal_enty = ls_legal_form_lnk-legal_enty.

                                          IF sy-subrc = 0.
                                            ls_outtab_legal-legal_form_bp_key = ls_tb020-legal_enty.
                                            ls_outtab_legal-legal_form_bp = ls_tb020-textshort.
                                          ENDIF.

                                          READ TABLE lt_tvgft INTO ls_tvgft WITH KEY gform = ls_legal_form_lnk-gform.
                                          IF sy-subrc = 0.
                                            ls_outtab_legal-legal = ls_tvgft-gform.
                                            ls_outtab_legal-desc = ls_tvgft-vtext.
                                          ELSE. " This means , there is an entry in link table for customer legal status but no corresponding record in TVGF
                                            ls_outtab_legal-legal = ls_legal_form_lnk-gform.
                                          ENDIF.
                                          APPEND ls_outtab_legal TO gt_outtab_legal.
                                          CLEAR ls_outtab_legal.
                                        ENDIF.
                                      ENDLOOP.



                                      "Existing Payment card
                                      SELECT * FROM cvic_ccid_link INTO CORRESPONDING FIELDS OF TABLE lt_paycard_link.
                                        SELECT * FROM tvcint INTO CORRESPONDING FIELDS OF TABLE lt_tvcint WHERE  spras = sy-langu." AND ccins IS NOT NULL. "AND ccins IN ( SELECT ccins FROM cvic_ccid_link ) . "#EC CI_BUFFSUBQ "#EC CI_GENBUFF
                                          IF sy-subrc = 0.
                                            delete lt_tvcint where ccins is initial.
                                          ENDIF.
                                          SELECT * FROM tb033t INTO CORRESPONDING FIELDS OF TABLE lt_tb033t WHERE  spras = sy-langu." AND ccins IS NOT NULL. "AND ccins IN ( SELECT ccins FROM cvic_ccid_link ).
                                            IF sy-subrc = 0.
                                            delete lt_tb033t where ccins is initial.
                                          ENDIF.

                                            LOOP AT lt_paycard_link INTO ls_paycard_link.
                                              IF lt_paycard_link IS NOT INITIAL.
                                                READ TABLE lt_tb033t INTO ls_tb033t WITH KEY ccins = ls_paycard_link-pcid_bp.
                                                IF sy-subrc = 0.
                                                  ls_outtab_pcard-bp_pcard_key = ls_tb033t-ccins.
                                                  ls_outtab_pcard-bp_pcard_text = ls_tb033t-bez30.
                                                ENDIF.

                                                READ TABLE lt_tvcint INTO ls_tvcint WITH KEY ccins = ls_paycard_link-ccins.
                                                IF sy-subrc = 0.
                                                  ls_outtab_pcard-pcard = ls_tvcint-ccins.
                                                  ls_outtab_pcard-desc  = ls_tvcint-vtext.
                                                ELSE.
                                                  ls_outtab_pcard-pcard = ls_paycard_link-ccins.
                                                ENDIF.
                                                APPEND ls_outtab_pcard TO gt_outtab_pcard.
                                                CLEAR ls_outtab_pcard.
                                              ENDIF.
                                            ENDLOOP.

ENDFORM.                    " SET_DATA_CUST_EXISTING
