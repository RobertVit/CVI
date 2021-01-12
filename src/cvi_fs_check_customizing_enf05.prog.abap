*----------------------------------------------------------------------*
***INCLUDE CVI_FS_CHECK_CUSTOMIZING_ENF05.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form SELECT_DATA_VENDOR2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form select_data_vendor2 .

  data: cl_chk           type ref to cl_s4_checks_bp_enh,
        lt_check_results type table of ty_preprocessing_check_result,
        ls_check_results like line of lt_check_results,
        ls_accounts      like line of gt_accounts,
        ls_account_group like line of gt_account_group,
        ls_ac_role       like line of gt_ac_role,
        ls_role          like line of gt_role.


  create object cl_chk.

*cl_chk->get_results( importing et_check_results = lt_check_results ).
  clear: gt_accounts, gt_account_group, gt_ac_role, gt_role.

  lv_flag = 'v'.
  cl_chk->check_bp_role_ac( exporting iv_flag = lv_flag importing ct_account_gp = gt_ac_role changing ct_check_results = lt_check_results ).

  sort gt_ac_role by ac_gp.
  delete adjacent duplicates from gt_ac_role comparing ac_gp.

  loop at gt_ac_role into ls_ac_role.
    ls_role-ac_gp = ls_ac_role-ac_gp.
    append ls_role to gt_role.
  endloop.

  cl_chk->check_ac_bprole( exporting iv_flag = lv_flag importing ct_account_gp = gt_accounts changing ct_check_results = lt_check_results ).

  sort gt_accounts by ac_gp.
  delete adjacent duplicates from gt_accounts comparing ac_gp.

  loop at gt_accounts into ls_accounts.
    ls_account_group-ac_gp = ls_accounts-ac_gp.
    append ls_account_group to gt_account_group.
  endloop.

endform.
*&---------------------------------------------------------------------*
*& Form SELECT_DATA_VENDOR3
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form select_data_vendor3 .
  data: cl_chk_map2          type ref to cl_s4_checks_bp_enh,
        lt_check_results_map type table of ty_preprocessing_check_result,
        ls_check_results_map like line of lt_check_results_map,
        ls_ind_in            like line of gt_ind_in,
        ls_ind_out           like line of gt_ind_out,
        ls_industry_in       like line of gt_industry_in,
        ls_industry_out      like line of gt_industry_out.
  clear : gt_ind_in,gt_ind_out.
  clear : gt_industry_in,gt_industry_out.
  create object cl_chk_map2.
  call method cl_chk_map2->check_vend_value_mapping
    importing
      ct_industry_in   = gt_ind_in
      ct_industry_out  = gt_ind_out
    changing
      ct_check_results = lt_check_results_map.
  sort gt_ind_in by indkey.
  sort gt_ind_out by indkey.
  delete adjacent duplicates from gt_ind_in comparing indkey.
  delete adjacent duplicates from gt_ind_out comparing indkey.


  loop at gt_ind_in into ls_ind_in.
    ls_industry_in-indkey = ls_ind_in-indkey.
    append ls_industry_in to gt_industry_in.
  endloop.
  loop at gt_ind_out into ls_ind_out.
    ls_industry_out-indkey = ls_ind_out-indkey.
    append ls_industry_out to gt_industry_out.
  endloop.
endform.
