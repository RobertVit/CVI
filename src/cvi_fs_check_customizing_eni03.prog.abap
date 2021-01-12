*----------------------------------------------------------------------*
***INCLUDE CVI_FS_CHECK_CUSTOMIZING_ENI03.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_CUST_MAP_1100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module user_command_cust_map_1100 input.
  case ok_code.
    when gc_back.
      set screen 700. "start screen
       when gc_home.
      set screen 100.
    when gc_prev.
      set screen 700.
        when gc_next.
      set screen 1120.
    when 'DOCU_POS_1'.
      perform show_documentation using gc_general_text 'CVI_FS_C_C_CUS_POST_DEPT'.
    when 'DOCU_POS_2'.
      perform show_documentation using gc_general_text 'CVI_FS_C_C_CUS_POST_FUNC'.
    when 'DOCU_POS_3'.
      perform show_documentation using gc_general_text 'CVI_FS_C_C_CUS_POST_AUTH'.
    when 'DOCU_POS_4'.
      perform show_documentation using gc_general_text 'CVI_FS_C_C_CUS_POST_VIP'.
    when 'DOCU_POS_5'.
      perform show_documentation using gc_general_text 'CVI_FS_C_C_CUS_POST_MARITAL'.
    when 'DOCU_POS_6'.
      perform show_documentation using gc_general_text 'CVI_FS_C_C_CUS_POST_LEGAL'.
    when 'DOCU_POS_7'.
      perform show_documentation using gc_general_text 'CVI_FS_C_C_CUS_POST_CARDS'.
    when 'SAVE'.
      perform cust_save_post_1100.
      clear gv_checkid.
    when 'CHK_CUST'.
      if gt_outtab_post_log[] is  not initial.
        call screen 1110 starting at 10 10.
      else.
        message 'No Customizing Errors exist' type 'I'.
      endif.
    when gc_exit.
      leave program.
      when 'DISP_ALL'.
        clear gv_checkid.
  endcase.
endmodule.
*&---------------------------------------------------------------------*
*& Form CUST_SAVE_POST_1100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form cust_save_post_1100 .
gv_flag_save = 2.

**************************TB910*************************************
  data: lt_cvic_cp1_link type table of cvic_cp1_link,
        ls_cvic_cp1_link type cvic_cp1_link,
        lt_tb910         type table of tb910,
        ls_tb910         type tb910,
         lv_legal_stat_key type char2,
         lv_auth_cvi_key type auth,
         lv_vip_cvi_key type pavip,
         lv_fn_cvi_key type pafkt,
         lv_dep_cvi_key type abtnr,
         lv_famst_cvi_key TYPE famst,
         lv_pcard_cvi_key TYPE ccins.

  data: ls_tb910_d like line of gt_tb910_main.
  if gt_outtab_tb910[] is not initial.
    gr_alv_tb910->check_changed_data( ).
    clear ls_tb910_d.
    loop at gt_outtab_tb910[] into ls_tb910_d where cvi_dept_text IS NOT INITIAL.
      if ls_tb910_d-abtnr_check is not initial.
        ls_cvic_cp1_link-client = sy-mandt.
        ls_cvic_cp1_link-gp_abtnr = ls_tb910_d-abtnr.
        lv_dep_cvi_key = ls_tb910_d-cvi_dept_text.
        ls_cvic_cp1_link-abtnr = lv_dep_cvi_key.
        append ls_cvic_cp1_link to lt_cvic_cp1_link.
      endif.
    endloop.
    if lt_cvic_cp1_link is not initial.
      modify cvic_cp1_link from table lt_cvic_cp1_link.
      REFRESH gt_outtab_tb910.
    endif.
  endif.

******************************TB912*************
  data: lt_cvic_cp2_link type table of cvic_cp2_link,
        ls_cvic_cp2_link type cvic_cp2_link,
        lt_tb912         type table of tb912,
        ls_tb912         type tb912,
        length           type i.

  data: ls_tb912_d like line of gt_tb912_main,
        lv_string type string.
  if gt_outtab_tb912[] is not initial.
    gr_alv_tb912->check_changed_data( ).
    clear ls_tb912_d.
    loop at gt_outtab_tb912[] into ls_tb912_d WHERE cvi_fn_text IS NOT INITIAL .
      if ls_tb912_d-pafkt_check is not initial.
        ls_cvic_cp2_link-client = sy-mandt.
        ls_cvic_cp2_link-gp_pafkt = ls_tb912_d-pafkt.
        lv_fn_cvi_key = ls_tb912_d-cvi_fn_text.
        ls_cvic_cp2_link-pafkt =  lv_fn_cvi_key.
*        lv_string = lv_fn_cvi_key.
*        length = strlen( lv_string ).
*        if length = 4.
*          ls_cvic_cp2_link-pafkt = lv_string+2(2).
*        else.
*          ls_cvic_cp2_link-pafkt = ls_tb912_d-pafkt.
*        endif.
*        clear : lv_string.
*        ls_cvic_cp2_link-gp_pafkt = ls_tb912_d-pafkt.
        append ls_cvic_cp2_link to lt_cvic_cp2_link.
      endif.
    endloop.
    if lt_cvic_cp2_link is not initial.
      modify cvic_cp2_link from table lt_cvic_cp2_link.
      REFRESH gt_outtab_tb912.
    endif.
  endif.


************TB914**************
  data: lt_cvic_cp3_link type table of cvic_cp3_link,
        ls_cvic_cp3_link type cvic_cp3_link,
        lt_tb914         type table of tb914,
        ls_tb914         type tb914.

  data: ls_tb914_d like line of gt_tb914_main.
  if gt_outtab_tb914[] is not initial.
    gr_alv_tb914->check_changed_data( ).
    clear ls_tb914_d.
    loop at gt_outtab_tb914[] into ls_tb914_d WHERE cvi_auth_text IS NOT INITIAL .
      if ls_tb914_d-bu_paauth_check is not initial.
        ls_cvic_cp3_link-client = sy-mandt.
        ls_cvic_cp3_link-parvo = ls_tb914_d-bu_paauth.
        lv_auth_cvi_key = ls_tb914_d-cvi_auth_text.
        ls_cvic_cp3_link-paauth = lv_auth_cvi_key.
        append ls_cvic_cp3_link to lt_cvic_cp3_link.
      endif.
    endloop.
    if lt_cvic_cp3_link is not initial.
      modify cvic_cp3_link from table lt_cvic_cp3_link.
      refresh gt_outtab_tb914.
    endif.
  endif.

***********TB916*******************
  data: lt_cvic_cp4_link type table of cvic_cp4_link,
        ls_cvic_cp4_link type cvic_cp4_link,
        lt_tb916         type table of tb916,
        ls_tb916         type tb916.

  data: ls_tb916_d like line of gt_tb916_main.

  if gt_outtab_tb916[] is not initial.
    gr_alv_tb916->check_changed_data( ).
    clear ls_tb916_d.
    loop at gt_outtab_tb916[] into ls_tb916_d WHERE cvi_vip_text IS NOT INITIAL.
      if ls_tb916_d-pavip_check is not initial.
        ls_cvic_cp4_link-client = sy-mandt.
        ls_cvic_cp4_link-gp_pavip = ls_tb916_d-pavip.
        lv_vip_cvi_key = ls_tb916_d-cvi_vip_text.
        ls_cvic_cp4_link-pavip = lv_vip_cvi_key.
        append ls_cvic_cp4_link to lt_cvic_cp4_link.
      endif.
    endloop.
    if lt_cvic_cp4_link is not initial.
      modify cvic_cp4_link from table lt_cvic_cp4_link.
      refresh gt_outtab_tb916.
    endif.
  endif.


*************TB027**********************
  data: lt_cvic_marst_link type table of cvic_marst_link,
        ls_cvic_marst_link type cvic_marst_link,
        lt_tb027           type table of tb027,
        ls_tb027           type tb027.

  data: ls_tb027_d like line of gt_tb027_main.
  if gt_outtab_tb027[] is not initial.
    gr_alv_tb027->check_changed_data( ).
    clear ls_tb027_d.
    loop at gt_outtab_tb027[] into ls_tb027_d WHERE cvi_famst_text IS NOT INITIAL.
      if ls_tb027_d-bu_marst_check is not initial.
        ls_cvic_marst_link-client = sy-mandt.
        ls_cvic_marst_link-famst = ls_tb027_d-bu_marst.
        lv_famst_cvi_key = ls_tb027_d-cvi_famst_text.
        ls_cvic_marst_link-marst = lv_famst_cvi_key.
        append ls_cvic_marst_link to lt_cvic_marst_link.
      endif.
    endloop.
    if lt_cvic_marst_link is not initial.
      modify cvic_marst_link from table lt_cvic_marst_link.
      refresh gt_outtab_tb027.
    endif.
  endif.

************TB019**************
  data: lt_cvic_legform_lnk type table of cvic_legform_lnk,
        ls_cvic_legform_lnk type cvic_legform_lnk,
        lt_tb019            type table of tb019,
        ls_tb019            type tb019.

  data: ls_tb019_d like line of gt_tb019_main.

  if gt_outtab_tb019[] is not initial.
    gr_alv_tb019->check_changed_data( ).
    clear ls_tb019_d.
    loop at gt_outtab_tb019[] into ls_tb019_d WHERE legal_stat_cvi IS NOT INITIAL.
      if ls_tb019_d-bu_legenty_check is not initial.
        ls_cvic_legform_lnk-client = sy-mandt.
        ls_cvic_legform_lnk-gform = ls_tb019_d-bu_legenty.
        lv_legal_stat_key = ls_tb019_d-legal_stat_cvi.
        ls_cvic_legform_lnk-legal_enty = lv_legal_stat_key.
        append ls_cvic_legform_lnk to lt_cvic_legform_lnk.
      endif.
    endloop.
    if lt_cvic_legform_lnk is not initial.
      modify cvic_legform_lnk from table lt_cvic_legform_lnk.
      refresh gt_outtab_tb019.
    endif.
  endif.


************TB033**********************
  data: lt_cvic_ccid_link type table of cvic_ccid_link,
        ls_cvic_ccid_link type cvic_ccid_link,
        lt_tb033          type table of tb033,
        ls_tb033          type tb033.

  data: ls_tb033_d like line of gt_tb033_main.

  if gt_outtab_tb033[] is not initial.
    gr_alv_tb033->check_changed_data( ).
    clear ls_tb033_d.
    loop at gt_outtab_tb033[] into ls_tb033_d WHERE cvi_pcard_text IS NOT INITIAL.
      if ls_tb033_d-ccins_check is not initial.
        ls_cvic_ccid_link-client = sy-mandt.
        ls_cvic_ccid_link-pcid_bp = ls_tb033_d-ccins.
        lv_pcard_cvi_key = ls_tb033_d-cvi_pcard_text.
        ls_cvic_ccid_link-ccins = lv_pcard_cvi_key.
        append ls_cvic_ccid_link to lt_cvic_ccid_link.
      endif.
    endloop.
    if lt_cvic_ccid_link is not initial.
      modify cvic_ccid_link from table lt_cvic_ccid_link.
      refresh gt_outtab_tb033.
    endif.
  endif.


endform.
