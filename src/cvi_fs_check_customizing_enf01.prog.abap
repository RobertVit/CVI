*----------------------------------------------------------------------*
***INCLUDE CVI_FS_CHECK_CUSTOMIZING_ENF01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form SELECT_DATA_CUSTOMER2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form select_data_customer2 .

  data: cl_chk           type ref to cl_s4_checks_bp_enh,
        lt_check_results type table of ty_preprocessing_check_result,
        ls_check_results like line of lt_check_results,
        ls_accounts      like line of gt_accounts,
        ls_account_group like line of gt_account_group,
        ls_ac_role       like line of gt_ac_role,
        ls_role          like line of gt_role.


  create object cl_chk.


*cl_chk->get_results( importing et_check_results = lt_check_results ).
  REFRESH : gt_accounts, gt_account_group, gt_ac_role, gt_role.

  lv_flag = 'c'.
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
*& Form SELECT_DATA_CUSTOMER3
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form select_data_customer3 .
  data: cl_chk_map           type ref to cl_s4_checks_bp_enh,
        lt_check_results_map type table of ty_preprocessing_check_result,
        ls_check_results_map like line of lt_check_results_map,
        ls_dept              like line of gt_dept,
        ls_func              like line of gt_func,
        ls_auth              like line of gt_auth,
        ls_vip               like line of gt_vip,
        ls_marital           like line of gt_marital,
        ls_legal             like line of gt_legal,
        ls_pay               like line of gt_pay,
        ls_cp                like line of gt_cp.
  clear: gt_dept,gt_func,gt_auth,gt_vip,gt_marital,gt_legal,gt_pay,gt_cp.
  clear: gt_department,gt_function,gt_authority,gt_vip_check,gt_marital_status,gt_legal_form,gt_payment_card.
  create object cl_chk_map.
  call method cl_chk_map->check_value_mapping
    importing
      ct_department    = gt_dept
      ct_function      = gt_func
      ct_authority     = gt_auth
      ct_vip           = gt_vip
      ct_marital       = gt_marital
      ct_legal         = gt_legal
      ct_pcard         = gt_pay
      ct_cp_assign     = gt_cp
    changing
      ct_check_results = lt_check_results_map.

*   cl_chk->CHECK_VALUE_MAPPING(  importing ct_department = gt_dept changing ct_check_results = lt_check_results ).

  sort gt_dept by dept.
  sort gt_func by fn.
  sort gt_auth by auth.
  sort gt_vip by vip.
  sort gt_marital by mstat.
  sort gt_legal by legal.
  sort gt_pay by pcard.
  delete adjacent duplicates from gt_dept comparing dept.
  delete adjacent duplicates from gt_func comparing fn.
  delete adjacent duplicates from gt_auth comparing auth.
  delete adjacent duplicates from gt_vip comparing vip.
  delete adjacent duplicates from gt_marital comparing mstat.
  delete adjacent duplicates from gt_legal comparing legal.
  delete adjacent duplicates from gt_pay comparing pcard.

  append lines of gt_dept to gt_department.
  append lines of gt_func to gt_function.
  append lines of gt_auth to gt_authority.
  append lines of gt_vip to gt_vip_check.
  append lines of gt_marital to gt_marital_status.
  append lines of gt_legal to gt_legal_form.
  append lines of gt_pay to gt_payment_card.

endform.
*&---------------------------------------------------------------------*
*& Form SELECT_DATA_CUSTOMER4
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form select_data_customer4 .
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
  call method cl_chk_map2->check_value_mapping
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
