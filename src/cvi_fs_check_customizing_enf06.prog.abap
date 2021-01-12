*----------------------------------------------------------------------*
***INCLUDE CVI_FS_CHECK_CUSTOMIZING_ENF06.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form CREATE_ALV_VENDOR2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form create_alv_vendor2 .

  clear: gs_fcat, gt_fieldcat_ac_gp, gt_fieldcat_log2, gs_fcat_role, gt_fieldcat_role.

*if gr_alv_role is not initial.
*    call method gr_alv_role->free.
*    clear gr_alv_role.
*  endif.
*
*if gr_cont_role is not initial.
*    call method gr_cont_role->free.
*    clear gr_cont_role.
*  endif.
*
*  if gr_alv_ac_gp is not initial.
*    call method gr_alv_ac_gp->free.
*    clear gr_alv_ac_gp.
*  endif.
*
*  if gr_cont_ac_gp is not initial.
*    call method gr_cont_ac_gp->free.
*    clear gr_cont_ac_gp.
*  endif.
*
*
*  if gr_alv_log2 is not initial.
*    call method gr_alv_log2->free.
*    clear gr_alv_log2.
*  endif.
*
*  if gr_cont_log2 is not initial.
*    call method gr_cont_log2->free.
*    clear gr_cont_log2.
*  endif.


  gs_fcat_role-fieldname = 'AC_GP'.
  gs_fcat_role-coltext   = 'Account Group'.
  gs_fcat_role-col_pos = 1.
  gs_fcat_role-outputlen = 20.
  append gs_fcat_role to gt_fieldcat_role.
  clear gs_fcat_role.

  gs_fcat_role-fieldname = 'ROLE'.
  gs_fcat_role-coltext   = 'Role'.
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
  gs_fcat_role-edit = 'X'.
  append gs_fcat_role to gt_fieldcat_role.
  clear gs_fcat_role.




*  gs_fcat_role-fieldname = 'Role'.
*  gs_fcat_role-coltext   = 'Role'.
*  gs_fcat_role-col_pos = 3.
*  gs_fcat_role-outputlen = 10.
*  append gs_fcat_role to gt_fieldcat_role.
*  clear gs_fcat_role.


if gr_cont_role is initial .
  create object gr_cont_role
    exporting
      container_name = 'VEND_ACCOUNT_ROLE_CONTAINER'.
 endif.

*  create object gr_alv_role
*    exporting
*      i_parent = gr_cont_role.

  gs_fcat-fieldname = 'AC_GP'.
  gs_fcat-coltext   = 'Account Group'.
  gs_fcat-col_pos = 1.
  gs_fcat-outputlen = 20.
  append gs_fcat to gt_fieldcat_ac_gp.
  clear gs_fcat.

  gs_fcat-fieldname = 'BP_GP'.
  gs_fcat-coltext   = 'BP Grouping'.
  gs_fcat-col_pos = 2.
  gs_fcat-outputlen = 50.
  gs_fcat-drdn_field = 'DROP_DOWN_HANDLE'.
  gs_fcat-edit = 'X'.
  append gs_fcat to gt_fieldcat_ac_gp.
  clear gs_fcat.

  gs_fcat-fieldname = 'S_NO'.
  gs_fcat-coltext   = 'Same Number'.
  gs_fcat-col_pos = 3.
  gs_fcat-outputlen = 20.
  gs_fcat-checkbox = 'X'.
  gs_fcat-edit = 'X'.
  append gs_fcat to gt_fieldcat_ac_gp.
  clear gs_fcat.

if gr_cont_ac_gp is initial .
  create object gr_cont_ac_gp
    exporting
      container_name = 'VEND_ACCOUNT_BP_CONTAINER'.
endif.
*  create object gr_alv_ac_gp
*    exporting
*      i_parent = gr_cont_ac_gp.

  clear: gs_fcat, gt_fieldcat_log2.
  gs_fcat-fieldname = 'ICON'.
  gs_fcat-coltext   = 'Ty.'.
  gs_fcat-col_pos = 1.
  gs_fcat-outputlen = 3.
  gs_fcat-icon = 'X'.
  append gs_fcat to gt_fieldcat_log2.
  clear gs_fcat.

  gs_fcat-fieldname = 'CHK'.
  gs_fcat-coltext   = 'Check ID'.
  gs_fcat-col_pos = 1.
  gs_fcat-outputlen = 20.
  append gs_fcat to gt_fieldcat_log2.
  clear gs_fcat.

  gs_fcat-fieldname = 'LOG'.
  gs_fcat-coltext   = 'Error Log'.
  gs_fcat-col_pos = 2.
  gs_fcat-outputlen = 70.
*  gs_fcat-hotspot = 'X'.
  append gs_fcat to gt_fieldcat_log2.
  clear gs_fcat.

if gr_cont_log2 is initial .
  create object gr_cont_log2
    exporting
      container_name = 'CC_LOG_VENDOR2'.
 endif.
* create ALV object for log table
 if gr_alv_log2 is initial .
  create object gr_alv_log2
    exporting
      i_parent = gr_cont_log2.
endif.
endform.
*&---------------------------------------------------------------------*
*& Form CREATE_ALV_VENDOR3
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form create_alv_vendor3 .
  " industry system



  clear : gs_fcat_map,gt_fieldcat_ind_in.

  gs_fcat_map-fieldname = 'INDSYS'.
  gs_fcat_map-coltext   = 'Industry system'.
  gs_fcat_map-col_pos = 1.
  gs_fcat_map-outputlen = 6.
  append gs_fcat_map to gt_fieldcat_ind_in.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'DESC'.
  gs_fcat_map-coltext   = 'Description'.
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
  "Industry keys

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

"error log
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
      container_name = 'VEND_ERROR'.

endform.
