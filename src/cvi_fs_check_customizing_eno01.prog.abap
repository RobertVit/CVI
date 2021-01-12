*----------------------------------------------------------------------*
***INCLUDE CVI_FS_CHECK_CUSTOMIZING_ENO01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module PBO_0700_CUSTOMER OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
module pbo_0700_customer output.
* SET PF-STATUS 'xxxxxxxx'.
 SET TITLEBAR 'CVI_CUST_CUSTOMIZING'.
 perform set_status_customer_0700.
  if gv_pbo_customer_is_done <> gc_true.  "Dynpro 0300-Customer not created yet.
*    perform set_status_customer_0700.
    perform select_data_customer_0700.
    perform check_entries_customer_0700.
    perform create_alv_customer_0700.
    perform show_data_customer_0700.

    gv_pbo_customer_is_done = gc_true.    "Dynpro 0300-Customer created.
  endif.
endmodule.                    "pbo_0700_customer OUTPUT
*&---------------------------------------------------------------------*
*& Form SET_STATUS_CUSTOMER_0700
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form set_status_customer_0700 .
  set pf-status 'CVI_FS_C_C_NEXT'.
*  set titlebar 'CVI_FS_C_C_CUSTOMER'.
endform.                    "set_status_customer_0700
*&---------------------------------------------------------------------*
*& Form SELECT_DATA_CUSTOMER_0700
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form select_data_customer_0700 .
*Select additional informatin e.g. number ranges and descriptions
  select * from tb002 into table gt_tb002 where spras = sy-langu.
  select * from nriv into corresponding fields of table gt_nriv where object = 'DEBITOR' or
                                                                    object = 'BU_PARTNER'.
  select * from tb001 into table gt_tb001.
  select * from t077x into table gt_t077x where spras = sy-langu.
  select * from t077d into table gt_t077d.
  select * from tb003t into corresponding fields of table gt_tb003t where spras = sy-langu.

*merge gt_bp_to_customer_n with additional information selected above
  perform compose_gt_bp_to_customer_n.
endform.                    "select_data_customer_0700
*&---------------------------------------------------------------------*
*& Form CHECK_ENTRIES_CUSTOMER_0700
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form check_entries_customer_0700 .
*check whether corresponding direction is active in MDSC_CTRL_OPT_A
  perform check_customer_directions_0700.

*check existence of roles, account groups and number ranges
  perform check_customer_existence_0700.

*check role assignment
  perform check_customer_roles_0700.

*Check number assignment
  perform check_customer_numbers_0700.

*If no error or warning occured, show message, that customizing is ok
  if gt_log_table_0700 is initial.
    perform write_log_table_0700 using gv_icon_green 032 gc_false gc_false.
    message e032(cvi_fs_check_cust_en) into gv_dummy_msg.
  endif.
endform.                    "check_entries_customer_0700
*&---------------------------------------------------------------------*
*& Form CREATE_ALV_CUSTOMER_0700
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form create_alv_customer_0700 .
*Direction BP -> Customer
*build up the fieldcatalog for Roles BP -> Customer
  clear gs_fcat.
  gs_fcat-fieldname = 'RLTYP'.
  gs_fcat-ref_table = 'V_TBD002'.
  gs_fcat-coltext   = 'BP Role'(003).
  append gs_fcat to gt_fieldcat_bp_customer_r.
  clear gs_fcat.

  gs_fcat-fieldname = 'RLCTXT'.
  gs_fcat-ref_table = 'V_TBD002'.
  gs_fcat-coltext   = 'Description'(004).
  append gs_fcat to gt_fieldcat_bp_customer_r.
  clear gs_fcat.

  gs_fcat-fieldname = 'DEB'.
  gs_fcat-ref_table = 'V_TBD002'.
  gs_fcat-coltext   = 'Mandatory'(003).
  append gs_fcat to gt_fieldcat_bp_customer_r.
  clear gs_fcat.

  gs_fcat-fieldname = 'DEB_FLAG'.
  gs_fcat-ref_table = 'V_TBD002'.
  gs_fcat-no_out    = gc_true.
  append gs_fcat to gt_fieldcat_bp_customer_r.
  clear gs_fcat.

  gs_fcat-fieldname = 'FNAME'.
  gs_fcat-ref_table = 'V_TBD002'.
  gs_fcat-no_out    = gc_true.
  append gs_fcat to gt_fieldcat_bp_customer_r.
  clear gs_fcat.

  gs_fcat-fieldname = 'FNAMEVORB'.
  gs_fcat-ref_table = 'V_TBD002'.
  gs_fcat-no_out    = gc_true.
  append gs_fcat to gt_fieldcat_bp_customer_r.
  clear gs_fcat.

*create container for Roles BP -> Customer
  create object gr_cont_bp_customer_r
    exporting
      container_name = 'CC_BP_CUSTOMER_R'.

*create ALV object for Roles BP -> Customer
  create object gr_alv_bp_customer_r
    exporting
      i_parent = gr_cont_bp_customer_r.

*build up the fieldcatalog for Number Assignment BP -> Customer
  gs_fcat-fieldname = 'BU_GROUP'.
  gs_fcat-ref_table = 'V_TBD001'.
  gs_fcat-coltext   = 'BP Grouping'(009).
  append gs_fcat to gt_fieldcat_bp_customer_n.
  clear gs_fcat.

  gs_fcat-fieldname = 'TXT15'.
  gs_fcat-ref_table = 'V_TBD001'.
  gs_fcat-coltext   = 'Description'(004).
  append gs_fcat to gt_fieldcat_bp_customer_n.
  clear gs_fcat.

  gs_fcat-fieldname = 'NRRNG'.
  gs_fcat-ref_table = 'TB001'.
  gs_fcat-coltext   = 'Range'(010).
  append gs_fcat to gt_fieldcat_bp_customer_n.
  clear gs_fcat.

  gs_fcat-fieldname = 'EXTERN_BP'.
  gs_fcat-ref_table = 'NRIV'.
  gs_fcat-ref_field = 'EXTERNIND'.
  gs_fcat-coltext   = 'ext'(039).
  append gs_fcat to gt_fieldcat_bp_customer_n.
  clear gs_fcat.
  clear gs_fcat.

  gs_fcat-fieldname = 'ARROW'.
  gs_fcat-inttype   = 'c'.
  gs_fcat-outputlen = '40'.
  gs_fcat-coltext   = 'Direction'(007).
  gs_fcat-seltext   = 'Direction'(007).
  gs_fcat-icon      = gc_true.
  append gs_fcat to gt_fieldcat_bp_customer_n.
  clear gs_fcat.

  gs_fcat-fieldname = 'KTOKD'.
  gs_fcat-ref_table = 'V_TBD001'.
  gs_fcat-coltext   = 'Customer Account Group'(008).
  append gs_fcat to gt_fieldcat_bp_customer_n.
  clear gs_fcat.

  gs_fcat-fieldname = 'TXT30'.
  gs_fcat-ref_table = 'V_TBD001'.
  gs_fcat-coltext   = 'Description'(004).
  append gs_fcat to gt_fieldcat_bp_customer_n.
  clear gs_fcat.

  gs_fcat-fieldname = 'NUMKR'.
  gs_fcat-ref_table = 'T077D'.
  gs_fcat-coltext   = 'Range'(010).
  append gs_fcat to gt_fieldcat_bp_customer_n.
  clear gs_fcat.

  gs_fcat-fieldname = 'EXTERN_CUST'.
  gs_fcat-ref_table = 'NRIV'.
  gs_fcat-ref_field = 'EXTERNIND'.
  gs_fcat-coltext   = 'ext'(039).
  append gs_fcat to gt_fieldcat_bp_customer_n.
  clear gs_fcat.

  gs_fcat-fieldname = 'XSAMENUMBER'.
  gs_fcat-ref_table = 'V_TBD001'.
  gs_fcat-coltext   = 'Same Nr.'(012).
  append gs_fcat to gt_fieldcat_bp_customer_n.
  clear gs_fcat.
  "create container for number assignment BP -> Customer
  create object gr_cont_bp_customer_n
    exporting
      container_name = 'CC_BP_CUSTOMER_N'.

*create ALV object for number assignment BP -> Customer
  create object gr_alv_bp_customer_n
    exporting
      i_parent = gr_cont_bp_customer_n.

*create container for log table
  create object gr_cont_log_0700
    exporting
      container_name = 'CC_LOG_CUSTOMER_POST'.
* create ALV object for log table
  create object gr_alv_log_0700
    exporting
      i_parent = gr_cont_log_0700.
*One handler is used for each event of cl_gui_alv_grid
  set handler gr_event_handler->on_f1 for gr_alv_log_0700.
  set handler gr_event_handler->on_double_click for gr_alv_log_0700.
  set handler gr_event_handler->on_hotspot_click for gr_alv_log_0700.

endform.                    "create_alv_customer_0700
*&---------------------------------------------------------------------*
*& Form SHOW_DATA_CUSTOMER_0700
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form show_data_customer_0700 .
*Show ALV for Roles BP -> Customer
  gs_layout_default-grid_title = 'Settings for Business Partner roles'(031).
  perform show_table_alv  using    gr_alv_bp_customer_r
                                   gs_layout_default
                          changing gt_bp_to_customer_r
                                   gt_fieldcat_bp_customer_r.

*Show ALV for Number Assignment BP -> Customer
  gs_layout_default-grid_title = 'Settings for Business Partner groupings'(032).
  perform show_table_alv  using    gr_alv_bp_customer_n
                                   gs_layout_default
                          changing gt_bp_to_customer_n
                                   gt_fieldcat_bp_customer_n.

*sort log table by icon, delete duplicates and show log in alv grid
clear gt_log_table.
gt_log_table = gt_log_table_0700.
  perform sort_log_table.
  gs_layout_log_0700-no_toolbar = gc_true.
  perform show_table_alv using    gr_alv_log_0700
                                  gs_layout_log_0700
                         changing gt_log_table
                                  gt_fieldcat_log.
endform.                    "show_data_customer_0700
