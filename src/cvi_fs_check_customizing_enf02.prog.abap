*----------------------------------------------------------------------*
***INCLUDE CVI_FS_CHECK_CUSTOMIZING_ENF02.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form CREATE_ALV_CUSTOMER2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form create_alv_customer2 .

DATA : ls_toolbar  TYPE stb_button,
           lv_disabled TYPE c.

  refresh :gt_fieldcat_ac_gp, gt_fieldcat_log2,gt_fieldcat_role.
  clear : gs_fcat_role, gs_fcat.


  gs_fcat-fieldname = 'AC_GP'.
  gs_fcat-coltext   = 'Customer Account Group'(008).
  gs_fcat-col_pos = 1.
  gs_fcat-outputlen = 20.
*  gs_fcat-dd_outlen = 80.
*  gs_fcat-col_opt = 'X'.
  append gs_fcat to gt_fieldcat_ac_gp.
  clear gs_fcat.

  gs_fcat-fieldname = 'BP_GP'.
  gs_fcat-coltext   = 'BP Grouping'(009).
  gs_fcat-col_pos = 2.
  gs_fcat-outputlen = 20.
  gs_fcat-drdn_field = 'DROP_DOWN_HANDLE'.
  gs_fcat-edit = 'X'.
  append gs_fcat to gt_fieldcat_ac_gp.
  clear gs_fcat.

  gs_fcat-fieldname = 'S_NO'.
  gs_fcat-coltext   = 'Same Number'(012).
  gs_fcat-col_pos = 3.
  gs_fcat-outputlen = 50.
  gs_fcat-checkbox = 'X'.
  gs_fcat-edit = 'X'.
  append gs_fcat to gt_fieldcat_ac_gp.
  clear gs_fcat.

 if gr_cont_ac_gp is initial.
  create object gr_cont_ac_gp
    exporting
      container_name = 'CUST_ACCOUNT_BP_CONTAINER'.
 endif.

  clear: gs_fcat, gt_fieldcat_log2.
  gs_fcat-fieldname = 'ICON'.
  gs_fcat-coltext   = 'Type'(014).
  gs_fcat-col_pos = 1.
  gs_fcat-outputlen = 3.
  gs_fcat-icon = 'X'.
  append gs_fcat to gt_fieldcat_log2.
  clear gs_fcat.

  gs_fcat-fieldname = 'CHK'.
  gs_fcat-coltext   = 'Check ID'(015).
  gs_fcat-col_pos = 2.
  gs_fcat-outputlen = 20.
  append gs_fcat to gt_fieldcat_log2.
  clear gs_fcat.


  gs_fcat-fieldname = 'LOG'.
  gs_fcat-coltext   = 'Error Log'(016).
  gs_fcat-col_pos = 3.
  gs_fcat-outputlen = 70.
*  gs_fcat-hotspot = 'X'.
  append gs_fcat to gt_fieldcat_log2.
  clear gs_fcat.

if gr_cont_log2 is initial .
  create object gr_cont_log2
    exporting
      container_name = 'CC_LOG_CUSTOMER2'.
 endif.
* create ALV object for log table
  if gr_alv_log2 is initial .
  create object gr_alv_log2
    exporting
      i_parent = gr_cont_log2.
  endif.


  clear : gs_fcat_role.
  gs_fcat_role-fieldname = 'AC_GP'.
  gs_fcat_role-coltext   = 'Account Group'(013).
  gs_fcat_role-col_pos = 1.
  gs_fcat_role-outputlen = 20.
*  gs_fcat_role-dd_outlen = 80.
*  gs_fcat-col_opt = 'X'.
  append gs_fcat_role to gt_fieldcat_role.
  clear gs_fcat_role.

  gs_fcat_role-fieldname = 'ROLE'.
  gs_fcat_role-coltext   = 'BP Role'(003).
  gs_fcat_role-col_pos = 2.
  gs_fcat_role-outputlen = 20.
  gs_fcat_role-drdn_field = 'DROP_DOWN_HANDLE'.
  gs_fcat_role-edit = 'X'.
  append gs_fcat_role to gt_fieldcat_role.
  clear gs_fcat_role.

  gs_fcat_role-fieldname = 'ROLE_DESC'.
  gs_fcat_role-coltext   = 'Role Description'.
  gs_fcat_role-col_pos = 3.
  gs_fcat_role-outputlen = 50.
*  gs_fcat_role-edit = 'X'.
  append gs_fcat_role to gt_fieldcat_role.
  clear gs_fcat_role.

if gr_cont_role is initial .
  create object gr_cont_role
    exporting
      container_name = 'CUST_ACCOUNT_ROLE_CONTAINER'.
endif.
*  create object gr_alv_role
*    exporting
*      i_parent = gr_cont_role.


endform.                    "create_alv_customer2
*&---------------------------------------------------------------------*
*& Form CREATE_ALV_CUSTOMER3
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form create_alv_customer3 .
  clear: gs_fcat_map, gt_fieldcat_dept.
  clear:gt_fieldcat_fn,gt_fieldcat_au,gt_fieldcat_au,gt_fieldcat_vip,gt_fieldcat_marital,gt_fieldcat_legal,gt_fieldcat_pcard,gt_fieldcat_cpassign.


  "department assignment for contact person
  if gr_cont_dept is initial.
  create object gr_cont_dept
    exporting
      container_name = 'DEPT_ASSIGN'.
endif.
  clear gs_fcat_map.
  gs_fcat_map-fieldname = 'DEPT'.
  gs_fcat_map-coltext   = 'Department'.
  gs_fcat_map-col_pos = 1.
  gs_fcat_map-outputlen = 6.
  gs_fcat_map-dd_outlen = 6.
  append gs_fcat_map to gt_fieldcat_dept.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'DESC'.
  gs_fcat_map-coltext   = 'Description'.
  gs_fcat_map-col_pos = 2.
  gs_fcat_map-outputlen = 15.
  gs_fcat_map-edit = ' '.
  append gs_fcat_map to gt_fieldcat_dept.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'DEPT_CHECK'.
  gs_fcat_map-coltext   = 'Select department'.
  gs_fcat_map-col_pos = 3.
  gs_fcat_map-outputlen = 6.
  gs_fcat_map-checkbox = 'X'.
  gs_fcat_map-edit = 'X'.
  append gs_fcat_map to gt_fieldcat_dept.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'BP_DEPT_TEXT'.
  gs_fcat_map-coltext   = 'Department(BP)'.
  gs_fcat_map-col_pos = 4.
  gs_fcat_map-outputlen = 20.
  gs_fcat_map-dd_outlen = 20.
  gs_fcat_map-drdn_field = 'DROPDOWN_BP_DEPT'.
  gs_fcat_map-edit = 'X'.
  append gs_fcat_map to gt_fieldcat_dept.
  clear gs_fcat_map.


  "function assignment for contact person(CVI) to Functions(BP)
 if  gr_cont_fn is initial.
  create object gr_cont_fn
    exporting
      container_name = 'FN_ASSIGN'.
endif.
  clear gs_fcat_map.
  gs_fcat_map-fieldname = 'FN'.
  gs_fcat_map-coltext   = 'Function'.
  gs_fcat_map-col_pos = 1.
  gs_fcat_map-outputlen = 6.
  gs_fcat_map-dd_outlen = 6.
  append gs_fcat_map to gt_fieldcat_fn.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'DESC'.
  gs_fcat_map-coltext   = 'Description'.
  gs_fcat_map-col_pos = 2.
  gs_fcat_map-outputlen = 20.
  gs_fcat_map-edit = ' '.
  append gs_fcat_map to gt_fieldcat_fn.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'FN_CHECK'.
  gs_fcat_map-coltext   = 'Select Function'.
  gs_fcat_map-col_pos = 3.
  gs_fcat_map-outputlen = 6.
  gs_fcat_map-checkbox = 'X'.
  gs_fcat_map-edit = 'X'.
  append gs_fcat_map to gt_fieldcat_fn.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'BP_FN_TEXT'.
  gs_fcat_map-coltext   = 'Function(BP)'.
  gs_fcat_map-col_pos = 4.
  gs_fcat_map-outputlen = 22.
  gs_fcat_map-dd_outlen = 22.
  gs_fcat_map-drdn_field = 'DROPDOWN_BP_FN'.
  gs_fcat_map-edit = 'X'.
  append gs_fcat_map to gt_fieldcat_fn.
  clear gs_fcat_map.


  "Authority assignment for contact person
  if gr_cont_au is initial.
  create object gr_cont_au
    exporting
      container_name = 'AUTH_ASSIGN'.
endif.
  clear gs_fcat_map.
  gs_fcat_map-fieldname = 'AUTH'.
  gs_fcat_map-coltext   = 'Authority'.
  gs_fcat_map-col_pos = 1.
  gs_fcat_map-outputlen = 4.
  gs_fcat_map-dd_outlen = 4.
  append gs_fcat_map to gt_fieldcat_au.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'DESC'.
  gs_fcat_map-coltext   = 'Description'.
  gs_fcat_map-col_pos = 2.
  gs_fcat_map-outputlen = 13.
  gs_fcat_map-edit = ' '.
  append gs_fcat_map to gt_fieldcat_au.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'AUTH_CHECK'.
  gs_fcat_map-coltext   = 'Select authority'.
  gs_fcat_map-col_pos = 3.
  gs_fcat_map-outputlen = 6.
  gs_fcat_map-checkbox = 'X'.
  gs_fcat_map-edit = 'X'.
  append gs_fcat_map to gt_fieldcat_au.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'BP_POA_AUTH'.
  gs_fcat_map-coltext   = 'Pwr of Att.(BP)'.
  gs_fcat_map-col_pos = 4.
  gs_fcat_map-outputlen = 13.
  gs_fcat_map-dd_outlen = 13.
  gs_fcat_map-drdn_field = 'DROPDOWN_BP_POA'.
  gs_fcat_map-edit = 'X'.
  append gs_fcat_map to gt_fieldcat_au.
  clear gs_fcat_map.


  "VIP Indicator assignment for contact person
if gr_cont_vip is initial.
  create object gr_cont_vip
    exporting
      container_name = 'VIP_ASSIGN'.
endif.
  clear gs_fcat_map.
  gs_fcat_map-fieldname = 'VIP'.
  gs_fcat_map-coltext   = 'VIP Indicator(CVI)'.
  gs_fcat_map-col_pos = 1.
  gs_fcat_map-outputlen = 6.
  gs_fcat_map-dd_outlen = 6.
  append gs_fcat_map to gt_fieldcat_vip.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'DESC'.
  gs_fcat_map-coltext   = 'Description'.
  gs_fcat_map-col_pos = 2.
  gs_fcat_map-outputlen = 13.
  gs_fcat_map-edit = ' '.
  append gs_fcat_map to gt_fieldcat_vip.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'VIP_CHECK'.
  gs_fcat_map-coltext   = 'Select VIP'.
  gs_fcat_map-col_pos = 3.
  gs_fcat_map-outputlen = 6.
  gs_fcat_map-checkbox = 'X'.
  gs_fcat_map-edit = 'X'.
  append gs_fcat_map to gt_fieldcat_vip.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'BP_VIP_TEXT'.
  gs_fcat_map-coltext   = 'VIP Indicator(BP)'.
  gs_fcat_map-col_pos = 4.
  gs_fcat_map-outputlen = 15.
  gs_fcat_map-dd_outlen = 15.
  gs_fcat_map-drdn_field = 'DROPDOWN_BP_VIP'.
  gs_fcat_map-edit = 'X'.
  append gs_fcat_map to gt_fieldcat_vip.
  clear gs_fcat_map.

  "Marital status assignment
if gr_cont_marital is initial.
  create object gr_cont_marital
    exporting
      container_name = 'MARITAL_ASSIGN'.
endif.
  clear gs_fcat_map.
  gs_fcat_map-fieldname = 'MSTAT'.
  gs_fcat_map-coltext   = 'Marital Status'.
  gs_fcat_map-col_pos = 1.
  gs_fcat_map-outputlen = 6.
  gs_fcat_map-dd_outlen = 6.
  append gs_fcat_map to gt_fieldcat_marital.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'DESC'.
  gs_fcat_map-coltext   = 'Description'.
  gs_fcat_map-col_pos = 2.
  gs_fcat_map-outputlen = 20.
  gs_fcat_map-edit = ' '.
  append gs_fcat_map to gt_fieldcat_marital.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'MSTAT_CHECK'.
  gs_fcat_map-coltext   = 'Select Marital Status'.
  gs_fcat_map-col_pos = 3.
  gs_fcat_map-outputlen = 6.
  gs_fcat_map-checkbox = 'X'.
  gs_fcat_map-edit = 'X'.
  append gs_fcat_map to gt_fieldcat_marital.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'BP_MARST_TEXT'.
  gs_fcat_map-coltext   = 'Marital Status(BP)'.
  gs_fcat_map-col_pos = 4.
  gs_fcat_map-outputlen = 15.
  gs_fcat_map-dd_outlen = 15.
  gs_fcat_map-drdn_field = 'DROPDOWN_BP_MARST'.
  gs_fcat_map-edit = 'X'.
  append gs_fcat_map to gt_fieldcat_marital.
  clear gs_fcat_map.


  "Customer Legal Status to BP Legal Form
  if gr_cont_legal is initial.
  create object gr_cont_legal
    exporting
      container_name = 'LEGAL_ASSIGN'.
endif.
  clear gs_fcat_map.
  gs_fcat_map-fieldname = 'LEGAL'.
  gs_fcat_map-coltext   = 'Legal Status'.
  gs_fcat_map-col_pos = 1.
  gs_fcat_map-outputlen = 7.
  gs_fcat_map-dd_outlen = 7.
  append gs_fcat_map to gt_fieldcat_legal.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'DESC'.
  gs_fcat_map-coltext   = 'Description'.
  gs_fcat_map-col_pos = 2.
  gs_fcat_map-outputlen = 10.
  gs_fcat_map-edit = ' '.
  append gs_fcat_map to gt_fieldcat_legal.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'LEGAL_CHECK'.
  gs_fcat_map-coltext   = 'Select legal_form'.
  gs_fcat_map-col_pos = 3.
  gs_fcat_map-outputlen = 8.
  gs_fcat_map-checkbox = 'X'.
  gs_fcat_map-edit = 'X'.
  append gs_fcat_map to gt_fieldcat_legal.
  clear gs_fcat_map.


  gs_fcat_map-fieldname = 'LEGAL_FORM_BP'.
  gs_fcat_map-coltext   = 'Legal Form'.
  gs_fcat_map-col_pos = 4.
  gs_fcat_map-outputlen = 12.
  gs_fcat_map-dd_outlen = 12.
  gs_fcat_map-drdn_field = 'DROPDOWN_BP_FORM'.
  gs_fcat_map-edit = 'X'.
  append gs_fcat_map to gt_fieldcat_legal.
  clear gs_fcat_map.

  "Payment Card Assignment
if gr_cont_pcard is initial.
  create object gr_cont_pcard
    exporting
      container_name = 'PAY_ASSIGN'.
endif.
  clear gs_fcat_map.
  gs_fcat_map-fieldname = 'PCARD'.
  gs_fcat_map-coltext   = 'Card Type(CVI)'.
  gs_fcat_map-col_pos = 1.
  gs_fcat_map-outputlen = 6.
  gs_fcat_map-dd_outlen = 6.
  append gs_fcat_map to gt_fieldcat_pcard.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'DESC'.
  gs_fcat_map-coltext   = 'Description'.
  gs_fcat_map-col_pos = 2.
  gs_fcat_map-outputlen = 20.
  gs_fcat_map-edit = ' '.
  append gs_fcat_map to gt_fieldcat_pcard.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'PCARD_CHECK'.
  gs_fcat_map-coltext   = 'Select Payment card'.
  gs_fcat_map-col_pos = 3.
  gs_fcat_map-outputlen = 6.
  gs_fcat_map-checkbox = 'X'.
  gs_fcat_map-edit = 'X'.
  append gs_fcat_map to gt_fieldcat_pcard.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'BP_PCARD_TEXT'.
  gs_fcat_map-coltext   = 'Card Type(BP)'.
  gs_fcat_map-col_pos = 4.
  gs_fcat_map-outputlen = 15.
  gs_fcat_map-dd_outlen = 15.
  gs_fcat_map-drdn_field = 'DROPDOWN_BP_PCARD'.
  gs_fcat_map-edit = 'X'.
  append gs_fcat_map to gt_fieldcat_pcard.
  clear gs_fcat_map.

  "Contact Person assignment
  if gr_cont_cpassign is initial.
  create object gr_cont_cpassign
    exporting
      container_name = 'CP_ASSIGN'.
endif.
  clear gs_fcat_map.
  gs_fcat_map-fieldname = 'CP_ASSIGN'.
  gs_fcat_map-coltext   = 'Contact Person assignment'.
  gs_fcat_map-col_pos = 1.
  gs_fcat_map-outputlen = 6.
  gs_fcat_map-dd_outlen = 6.
   gs_fcat_map-checkbox = 'X'.
  gs_fcat_map-edit = 'X'.
  append gs_fcat_map to gt_fieldcat_cpassign.
  clear gs_fcat_map.


  "Error Log
  clear: gs_fcat_map , gt_fieldcat_cust_log.

  gs_fcat_map-fieldname = 'ICON'.
  gs_fcat_map-coltext   = 'Ty.'.
  gs_fcat_map-col_pos = 1.
  gs_fcat_map-outputlen = 3.
  gs_fcat_map-icon = 'X'.
  append gs_fcat_map to gt_fieldcat_cust_log.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'CHK'.
  gs_fcat_map-coltext   = 'Check ID'.
  gs_fcat_map-col_pos = 2.
  gs_fcat_map-outputlen = 30.
  append gs_fcat_map to gt_fieldcat_cust_log.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'LOG'.
  gs_fcat_map-coltext   = 'Error Log'.
  gs_fcat_map-col_pos = 2.
  gs_fcat_map-outputlen = 50.
  gs_fcat_map-hotspot = 'X'.
  append gs_fcat_map to gt_fieldcat_cust_log.
  clear gs_fcat_map.

  if gr_cont_cust_log is initial.
  create object gr_cont_cust_log
    exporting
      container_name = 'CUST_ERROR'.
  endif.

endform.                    "create_alv_customer3
*&---------------------------------------------------------------------*
*& Form CREATE_ALV_CUSTOMER4
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form create_alv_customer4 .
  "Industry system
  clear : gs_fcat_map,gt_fieldcat_ind_in.



  gs_fcat_map-fieldname = 'INDSYS'.
  gs_fcat_map-coltext   = 'Industry system'.
  gs_fcat-ref_table = ''.
  gs_fcat_map-col_pos = 1.
  gs_fcat_map-outputlen = 6.
  append gs_fcat_map to gt_fieldcat_ind_in.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'DESC'.
  gs_fcat_map-coltext   = 'Description'.
  gs_fcat-ref_table = ''.
  gs_fcat_map-col_pos = 2.
  gs_fcat_map-outputlen = 26.
  gs_fcat_map-edit = ' '.
  append gs_fcat_map to gt_fieldcat_ind_in.
  clear gs_fcat_map.


  gs_fcat_map-fieldname = 'ISYS_CHECK'.
  gs_fcat_map-coltext   = 'Select Industry System'.
  gs_fcat_map-col_pos = 3.
  gs_fcat_map-outputlen = 6.
  gs_fcat_map-checkbox = 'X'.
  gs_fcat_map-edit = 'X'.
  append gs_fcat_map to gt_fieldcat_ind_in.
  clear gs_fcat_map.


create object gr_cont_ind_in
    exporting
      container_name = 'IND_SYS'.

  clear: gs_fcat_map,gt_fieldcat_ind_out.
if gr_alv_ind_out is not initial.
    call method gr_alv_ind_out->free.
    clear gr_alv_ind_out.
  endif.
if gr_cont_ind_out is not initial.
    call method gr_cont_ind_out->free.
    clear gr_cont_ind_out.

 endif.
  "Industry key
  gs_fcat_map-fieldname = 'DESC'.
  gs_fcat_map-coltext   = 'Description'.
  gs_fcat_map-col_pos = 2.
  gs_fcat_map-outputlen = 26.
  gs_fcat_map-edit = ' '.
  append gs_fcat_map to gt_fieldcat_ind_out.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'INDKEY'.
  gs_fcat_map-coltext   = 'Industry Key'.
  gs_fcat_map-col_pos = 1.
  gs_fcat_map-outputlen = 6.
  append gs_fcat_map to gt_fieldcat_ind_out.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'IKEY_CHECK'.
  gs_fcat_map-coltext   = 'Select industry key'.
  gs_fcat_map-col_pos = 3.
  gs_fcat_map-outputlen = 6.
  gs_fcat_map-checkbox = 'X'.
  gs_fcat_map-edit = 'X'.
  append gs_fcat_map to gt_fieldcat_ind_out.
  clear gs_fcat_map.
  gs_fcat_map-fieldname = 'INDSECTOR'.
  gs_fcat_map-coltext   = 'Industry sector'.
  gs_fcat_map-col_pos = 4.
  gs_fcat_map-outputlen = 25.
  gs_fcat_map-drdn_field = 'DROP_DOWN_HANDLE'.
  gs_fcat_map-edit = 'X'.
  append gs_fcat_map to gt_fieldcat_ind_out.
  clear gs_fcat_map.
 create object gr_cont_ind_out
    exporting
      container_name = 'IND_KEY'.
"Error Log
  if gr_alv_cust_log2 is not initial.
    call method gr_alv_cust_log2->free.
    clear gr_alv_cust_log2.
  endif.
if gr_cont_cust_log2 is not initial.
    call method gr_cont_cust_log2->free.
    clear gr_cont_cust_log2.
  endif.
  clear: gs_fcat_map , gt_fieldcat_cust_log2.
  gs_fcat_map-fieldname = 'ICON'.
  gs_fcat_map-coltext   = 'Ty.'.
  gs_fcat_map-col_pos = 1.
  gs_fcat_map-outputlen = 3.
  gs_fcat_map-icon = 'X'.
  append gs_fcat_map to gt_fieldcat_cust_log2.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'CHK'.
  gs_fcat_map-coltext   = 'Check ID'.
  gs_fcat_map-col_pos = 2.
  gs_fcat_map-outputlen = 30.
  append gs_fcat_map to gt_fieldcat_cust_log2.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'LOG'.
  gs_fcat_map-coltext   = 'Error Log'.
  gs_fcat_map-col_pos = 2.
  gs_fcat_map-outputlen = 85.
  gs_fcat_map-hotspot = 'X'.
  append gs_fcat_map to gt_fieldcat_cust_log2.
  clear gs_fcat_map.

  create object gr_cont_cust_log2
    exporting
      container_name = 'CUST_ERROR_2'.

endform.                    "create_alv_customer4
*&---------------------------------------------------------------------*
*& Form CREATE_ALV_CHK_CUST
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form create_alv_chk_cust .
  data:  ls_outtab_chk_cust_log like line of gt_outtab_chk_cust_log,
        lv_check type bool value gc_true.
clear: gs_fcat_map , gt_fieldcat_cust_log.
   if gr_alv_cust_log is not initial.
    call method gr_alv_cust_log->free.
    clear gr_alv_cust_log.
  endif.
if gr_cont_cust_log is not initial.
    call method gr_cont_cust_log->free.
    clear gr_cont_cust_log.
  endif.
  gs_fcat_map-fieldname = 'ICON'.
  gs_fcat_map-coltext   = 'Ty.'.
  gs_fcat_map-col_pos = 1.
  gs_fcat_map-outputlen = 3.
  gs_fcat_map-icon = 'X'.
  append gs_fcat_map to gt_fieldcat_cust_log.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'CHK'.
  gs_fcat_map-coltext   = 'Check ID'.
  gs_fcat_map-col_pos = 2.
  gs_fcat_map-outputlen = 30.
  append gs_fcat_map to gt_fieldcat_cust_log.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'VALUE'.
  gs_fcat_map-coltext   = 'Key'.
  gs_fcat_map-col_pos = 3.
  gs_fcat_map-outputlen = 30.
  append gs_fcat_map to gt_fieldcat_cust_log.
  clear gs_fcat_map.
*select * from gt_outtab_chk_cust_log[] where table = 'CHK_BP_AC' or table = 'CHK_BP_ROLE'.
   read table  gt_outtab_chk_cust_log[] with key  chk = 'CHK_BP_AC'  into ls_outtab_chk_cust_log.
  if sy-subrc <> 0.
read table  gt_outtab_chk_cust_log[] with key  chk = 'CHK_BP_ROLE'  into ls_outtab_chk_cust_log.
if sy-subrc <> 0.
  lv_check = gc_false.
endif.
  endif.
  if lv_check = gc_false.
  gs_fcat_map-fieldname = 'LOG'.
  gs_fcat_map-coltext   = 'Error Log'.
  gs_fcat_map-col_pos = 4.
  gs_fcat_map-outputlen = 85.
  gs_fcat_map-hotspot = 'X'.
  append gs_fcat_map to gt_fieldcat_cust_log.
  clear gs_fcat_map.
  else.
    gs_fcat_map-fieldname = 'LOG'.
  gs_fcat_map-coltext   = 'Error Log'.
  gs_fcat_map-col_pos = 5.
  gs_fcat_map-outputlen = 85.
  gs_fcat_map-hotspot = 'X'.
  append gs_fcat_map to gt_fieldcat_cust_log.
  clear gs_fcat_map.

    gs_fcat_map-fieldname = 'NO_RANGE'.
  gs_fcat_map-coltext   = 'Number range'.
  gs_fcat_map-col_pos = 4.
  gs_fcat_map-outputlen = 20.
    gs_fcat_map-drdn_field = 'DROP_DOWN_HANDLE'.
  gs_fcat_map-edit = 'X'.
  append gs_fcat_map to gt_fieldcat_cust_log.
  clear gs_fcat_map.
  endif.

  create object gr_cont_cust_log
    exporting
      container_name = 'CUST_CHK_LOG'.
  create object gr_alv_cust_log
    exporting
      i_parent = gr_cont_cust_log.

endform.                    "create_alv_chk_cust
*&---------------------------------------------------------------------*
*&      Form  CREATE_ALV_CUST_EXISTING
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CREATE_ALV_CUST_EXISTING .
  clear: gs_fcat_map, gt_fieldcat_dept.
  clear:gt_fieldcat_fn,gt_fieldcat_au,gt_fieldcat_au,gt_fieldcat_vip,gt_fieldcat_marital,gt_fieldcat_legal,gt_fieldcat_pcard,gt_fieldcat_cpassign.
  "department assignment for contact person


  if gr_cont_dept is initial.
    create object gr_cont_dept
      EXPORTING
        container_name = 'DEPT_ASSIGN'.
  endif.
  clear gs_fcat_map.
  gs_fcat_map-fieldname = 'DEPT'.
  gs_fcat_map-coltext   = 'Department'.
  gs_fcat_map-col_pos = 1.
  gs_fcat_map-outputlen = 6.
  gs_fcat_map-dd_outlen = 6.
  append gs_fcat_map to gt_fieldcat_dept.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'DESC'.
  gs_fcat_map-coltext   = 'Description'.
  gs_fcat_map-col_pos = 2.
  gs_fcat_map-outputlen = 20.
  gs_fcat_map-edit = ' '.
  append gs_fcat_map to gt_fieldcat_dept.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'BP_DEPT_KEY'.
  gs_fcat_map-coltext   = 'BP Dept.'.
  gs_fcat_map-col_pos = 3.
  gs_fcat_map-outputlen = 3.
  gs_fcat_map-edit = ' '.
  append gs_fcat_map to gt_fieldcat_dept.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'BP_DEPT_TEXT'.
  gs_fcat_map-coltext   = 'Description'.
  gs_fcat_map-col_pos = 4.
  gs_fcat_map-outputlen = 20.
  gs_fcat_map-edit = ' '.
  append gs_fcat_map to gt_fieldcat_dept.
  clear gs_fcat_map.

  "function assignment for contact person
  if  gr_cont_fn is initial.
    create object gr_cont_fn
      EXPORTING
        container_name = 'FN_ASSIGN'.
  endif.
  clear gs_fcat_map.
  gs_fcat_map-fieldname = 'FN'.
  gs_fcat_map-coltext   = 'Function'.
  gs_fcat_map-col_pos = 1.
  gs_fcat_map-outputlen = 6.
  gs_fcat_map-dd_outlen = 6.
  append gs_fcat_map to gt_fieldcat_fn.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'DESC'.
  gs_fcat_map-coltext   = 'Description'.
  gs_fcat_map-col_pos = 2.
  gs_fcat_map-outputlen = 20.
  gs_fcat_map-edit = ' '.
  append gs_fcat_map to gt_fieldcat_fn.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'BP_FN_KEY'.
  gs_fcat_map-coltext   = 'BP Function'.
  gs_fcat_map-col_pos = 3.
  gs_fcat_map-outputlen = 3.
  gs_fcat_map-edit = ' '.
  append gs_fcat_map to gt_fieldcat_fn.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'BP_FN_TEXT'.
  gs_fcat_map-coltext   = 'Description'.
  gs_fcat_map-col_pos = 4.
  gs_fcat_map-outputlen = 20.
  gs_fcat_map-edit = ' '.
  append gs_fcat_map to gt_fieldcat_fn.
  clear gs_fcat_map.

  "Authority assignment for contact person
  if gr_cont_au is initial.
    create object gr_cont_au
      EXPORTING
        container_name = 'AUTH_ASSIGN'.
  endif.
  clear gs_fcat_map.
  gs_fcat_map-fieldname = 'AUTH'.
  gs_fcat_map-coltext   = 'Authority'.
  gs_fcat_map-col_pos = 1.
  gs_fcat_map-outputlen = 6.
  gs_fcat_map-dd_outlen = 6.
  append gs_fcat_map to gt_fieldcat_au.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'DESC'.
  gs_fcat_map-coltext   = 'Description'.
  gs_fcat_map-col_pos = 2.
  gs_fcat_map-outputlen = 16.
  gs_fcat_map-edit = ' '.
  append gs_fcat_map to gt_fieldcat_au.
  clear gs_fcat_map.


  gs_fcat_map-fieldname = 'BP_POA_KEY'.
  gs_fcat_map-coltext   = 'BP PoA'.
  gs_fcat_map-col_pos = 3.
  gs_fcat_map-outputlen = 3.
  gs_fcat_map-edit = ' '.
  append gs_fcat_map to gt_fieldcat_au.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'BP_POA_AUTH'.
  gs_fcat_map-coltext   = 'Description'.
  gs_fcat_map-col_pos = 4.
  gs_fcat_map-outputlen = 20.
  gs_fcat_map-edit = ' '.
  append gs_fcat_map to gt_fieldcat_au.
  clear gs_fcat_map.
  "VIP Indicator assignment
  if gr_cont_vip is initial.
    create object gr_cont_vip
      EXPORTING
        container_name = 'VIP_ASSIGN'.
  endif.
  clear gs_fcat_map.
  gs_fcat_map-fieldname = 'VIP'.
  gs_fcat_map-coltext   = 'VIP Indicator'.
  gs_fcat_map-col_pos = 1.
  gs_fcat_map-outputlen = 6.
  gs_fcat_map-dd_outlen = 6.
  append gs_fcat_map to gt_fieldcat_vip.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'DESC'.
  gs_fcat_map-coltext   = 'Description'.
  gs_fcat_map-col_pos = 2.
  gs_fcat_map-outputlen = 20.
  gs_fcat_map-edit = ' '.
  append gs_fcat_map to gt_fieldcat_vip.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'BP_VIP_KEY'.
  gs_fcat_map-coltext   = 'BP VIP'.
  gs_fcat_map-col_pos = 3.
  gs_fcat_map-outputlen = 3.
  gs_fcat_map-edit = ' '.
  append gs_fcat_map to gt_fieldcat_vip.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'BP_VIP_TEXT'.
  gs_fcat_map-coltext   = 'Description'.
  gs_fcat_map-col_pos = 4.
  gs_fcat_map-outputlen = 20.
  gs_fcat_map-edit = ' '.
  append gs_fcat_map to gt_fieldcat_vip.
  clear gs_fcat_map.


  "Marital status assignment
  if gr_cont_marital is initial.
    create object gr_cont_marital
      EXPORTING
        container_name = 'MARITAL_ASSIGN'.
  endif.
  clear gs_fcat_map.
  gs_fcat_map-fieldname = 'MSTAT'.
  gs_fcat_map-coltext   = 'Marital Status'.
  gs_fcat_map-col_pos = 1.
  gs_fcat_map-outputlen = 6.
  gs_fcat_map-dd_outlen = 6.
  append gs_fcat_map to gt_fieldcat_marital.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'DESC'.
  gs_fcat_map-coltext   = 'Description'.
  gs_fcat_map-col_pos = 2.
  gs_fcat_map-outputlen = 20.
  gs_fcat_map-edit = ' '.
  append gs_fcat_map to gt_fieldcat_marital.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'BP_MARST_KEY'.
  gs_fcat_map-coltext   = 'BP Marital Status'.
  gs_fcat_map-col_pos = 3.
  gs_fcat_map-outputlen = 3.
  gs_fcat_map-edit = ' '.
  append gs_fcat_map to gt_fieldcat_marital.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'BP_MARST_TEXT'.
  gs_fcat_map-coltext   = 'Description'.
  gs_fcat_map-col_pos = 4.
  gs_fcat_map-outputlen = 20.
  gs_fcat_map-edit = ' '.
  append gs_fcat_map to gt_fieldcat_marital.
  clear gs_fcat_map.

  "Customer Legal Status to BP Legal Form
  if gr_cont_legal is initial.
    create object gr_cont_legal
      EXPORTING
        container_name = 'LEGAL_ASSIGN'.
  endif.
  clear gs_fcat_map.
  gs_fcat_map-fieldname = 'LEGAL'.
  gs_fcat_map-coltext   = 'Legal Status'.
  gs_fcat_map-col_pos = 1.
  gs_fcat_map-outputlen = 6.
  gs_fcat_map-dd_outlen = 6.
  append gs_fcat_map to gt_fieldcat_legal.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'DESC'.
  gs_fcat_map-coltext   = 'Description'.
  gs_fcat_map-col_pos = 2.
  gs_fcat_map-outputlen = 20.
  gs_fcat_map-edit = ' '.
  append gs_fcat_map to gt_fieldcat_legal.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'LEGAL_FORM_BP_KEY'.
  gs_fcat_map-coltext   = 'BP Legal Form'.
  gs_fcat_map-col_pos = 3.
  gs_fcat_map-outputlen = 6.
  gs_fcat_map-edit = ' '.
  append gs_fcat_map to gt_fieldcat_legal.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'LEGAL_FORM_BP'.
  gs_fcat_map-coltext   = 'Description'.
  gs_fcat_map-col_pos = 3.
  gs_fcat_map-outputlen = 20.
  gs_fcat_map-edit = ' '.
  append gs_fcat_map to gt_fieldcat_legal.
  clear gs_fcat_map.

  "Payment Card Assignment
  if gr_cont_pcard is initial.
    create object gr_cont_pcard
      EXPORTING
        container_name = 'PAY_ASSIGN'.
  endif.
  clear gs_fcat_map.
  gs_fcat_map-fieldname = 'PCARD'.
  gs_fcat_map-coltext   = 'Payment card'.
  gs_fcat_map-col_pos = 1.
  gs_fcat_map-outputlen = 6.
  gs_fcat_map-dd_outlen = 6.
  append gs_fcat_map to gt_fieldcat_pcard.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'DESC'.
  gs_fcat_map-coltext   = 'Description'.
  gs_fcat_map-col_pos = 2.
  gs_fcat_map-outputlen = 20.
  gs_fcat_map-edit = ' '.
  append gs_fcat_map to gt_fieldcat_pcard.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'BP_PCARD_KEY'.
  gs_fcat_map-coltext   = 'BP Payment Card'.
  gs_fcat_map-col_pos = 3.
  gs_fcat_map-outputlen = 3.
  gs_fcat_map-edit = ' '.
  append gs_fcat_map to gt_fieldcat_pcard.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'BP_PCARD_TEXT'.
  gs_fcat_map-coltext   = 'Description'.
  gs_fcat_map-col_pos = 4.
  gs_fcat_map-outputlen = 20.
  gs_fcat_map-edit = ' '.
  append gs_fcat_map to gt_fieldcat_pcard.
  clear gs_fcat_map.


  "Contact Person assignment
  if gr_cont_cpassign is initial.
    create object gr_cont_cpassign
      EXPORTING
        container_name = 'CP_ASSIGN'.
  endif.
  clear gs_fcat_map.
  gs_fcat_map-fieldname = 'CP_ASSIGN'.
  gs_fcat_map-coltext   = 'Contact Person assignment'.
  gs_fcat_map-col_pos = 1.
  gs_fcat_map-outputlen = 6.
  gs_fcat_map-dd_outlen = 6.
  gs_fcat_map-checkbox = 'X'.
  gs_fcat_map-edit = ' '.
  append gs_fcat_map to gt_fieldcat_cpassign.
  clear gs_fcat_map.


  "Error Log
  clear: gs_fcat_map , gt_fieldcat_cust_log.

  gs_fcat_map-fieldname = 'ICON'.
  gs_fcat_map-coltext   = 'Ty.'.
  gs_fcat_map-col_pos = 1.
  gs_fcat_map-outputlen = 3.
  gs_fcat_map-icon = 'X'.
  append gs_fcat_map to gt_fieldcat_cust_log.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'CHK'.
  gs_fcat_map-coltext   = 'Check ID'.
  gs_fcat_map-col_pos = 2.
  gs_fcat_map-outputlen = 30.
  append gs_fcat_map to gt_fieldcat_cust_log.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'LOG'.
  gs_fcat_map-coltext   = 'Error Log'.
  gs_fcat_map-col_pos = 2.
  gs_fcat_map-outputlen = 50.
  gs_fcat_map-hotspot = 'X'.
  append gs_fcat_map to gt_fieldcat_cust_log.
  clear gs_fcat_map.

  if gr_cont_cust_log is initial.
    create object gr_cont_cust_log
      EXPORTING
        container_name = 'CUST_ERROR'.
  endif.

ENDFORM.                    " CREATE_ALV_CUST_EXISTING
