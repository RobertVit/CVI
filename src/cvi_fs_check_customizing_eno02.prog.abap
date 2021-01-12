*----------------------------------------------------------------------*
***INCLUDE CVI_FS_CHECK_CUSTOMIZING_ENO02.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module PBO_0800_VENDOR OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
module pbo_0800_vendor output.
* SET PF-STATUS 'xxxxxxxx'.
* SET TITLEBAR 'xxx'.
  if gv_pbo_vendor_is_done <> gc_true.  "Dynpro 0400-Vendor not created yet.
    clear: gt_log_table.
    perform set_status_vendor_0800.
    perform select_data_vendor_0800.
    perform check_entries_vendor_0800.
    perform create_alv_vendor_0800.
    perform show_data_vendor_0800.

    gv_pbo_vendor_is_done = gc_true.    "Dynpro 0400-Vendor created.
  endif.
endmodule.
*&---------------------------------------------------------------------*
*& Form SET_STATUS_VENDOR_0800
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form set_status_vendor_0800 .
  set pf-status 'STATUS_0800'.
*  set titlebar 'CVI_FS_C_C_VENDOR'.
endform.
*&---------------------------------------------------------------------*
*& Form SELECT_DATA_VENDOR_0800
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form select_data_vendor_0800 .
  select * from tb002 into table gt_tb002 where spras = sy-langu.
  select * from nriv into corresponding fields of table gt_nriv where object = 'KREDITOR' or
                                                                    object = 'BU_PARTNER'.
  select * from tb001 into table gt_tb001.
  select * from t077y into table gt_t077y where spras = sy-langu.
  select * from t077k into table gt_t077k.
  select * from tb003t into corresponding fields of table gt_tb003t where spras = sy-langu.

*merge gt_bp_to_vendor_n with additional data selected above
  perform compose_gt_bp_to_vendor_n.
endform.
*&---------------------------------------------------------------------*
*& Form CHECK_ENTRIES_VENDOR_0800
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form check_entries_vendor_0800 .
*check whether corresponding direction is active
  perform check_vendor_directions_0800.

*check existence of roles, account groups and number ranges
  perform check_vendor_existence_0800.

*Check role assignment
  perform check_vendor_roles_0800.

*Check number assignment
  perform check_vendor_numbers_0800.

*If no error or warning occured, show note that customizing is ok
  if gt_log_table_0800 is initial.
    perform write_log_table_0800 using gv_icon_green 032 gc_false gc_false.
    message e032(cvi_fs_check_cust_en) into gv_dummy_msg.
  endif.
endform.
*&---------------------------------------------------------------------*
*& Form CREATE_ALV_VENDOR_0800
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form create_alv_vendor_0800 .
*Direction BP -> Vendor
*build up the fieldcatalog for Roles BP -> Vendor
  gs_fcat-fieldname = 'RLTYP'.
  gs_fcat-ref_table = 'V_TBC002'.
  gs_fcat-coltext   = 'BP Role'(003).
  append gs_fcat to gt_fieldcat_bp_vendor_r.
  clear gs_fcat.

  gs_fcat-fieldname = 'RLCTXT'.
  gs_fcat-ref_table = 'V_TBC002'.
  gs_fcat-coltext   = 'Description'(004).
  append gs_fcat to gt_fieldcat_bp_vendor_r.
  clear gs_fcat.

  gs_fcat-fieldname = 'KRED'.
  gs_fcat-ref_table = 'V_TBC002'.
  gs_fcat-coltext   = 'Mandatory'(046).
  append gs_fcat to gt_fieldcat_bp_vendor_r.
  clear gs_fcat.

  gs_fcat-fieldname = 'KRED_FLAG'.
  gs_fcat-ref_table = 'V_TBC002'.
  gs_fcat-no_out    = gc_true.
  append gs_fcat to gt_fieldcat_bp_vendor_r.
  clear gs_fcat.

  gs_fcat-fieldname = 'FNAME'.
  gs_fcat-ref_table = 'V_TBC002'.
  gs_fcat-no_out    = gc_true.
  append gs_fcat to gt_fieldcat_bp_vendor_r.
  clear gs_fcat.

  gs_fcat-fieldname = 'FNAMEVORB'.
  gs_fcat-ref_table = 'V_TBC002'.
  gs_fcat-no_out    = gc_true.
  append gs_fcat to gt_fieldcat_bp_vendor_r.
  clear gs_fcat.

*create container for Roles BP -> Vendor
  create object gr_cont_bp_vendor_r
    exporting
      container_name = 'CC_BP_VENDOR_R'.

*create ALV object for Roles BP -> Vendor
  create object gr_alv_bp_vendor_r
    exporting
      i_parent = gr_cont_bp_vendor_r.

*build up the fieldcatalog for Number Assignment BP -> Vendor
  gs_fcat-fieldname = 'BU_GROUP'.
  gs_fcat-ref_table = 'V_TBC001'.
  gs_fcat-coltext   = 'BP Grouping'(009).
  append gs_fcat to gt_fieldcat_bp_vendor_n.
  clear gs_fcat.

  gs_fcat-fieldname = 'TXT15'.
  gs_fcat-ref_table = 'V_TBC001'.
  gs_fcat-coltext   = 'Description'(004).
  append gs_fcat to gt_fieldcat_bp_vendor_n.
  clear gs_fcat.

  gs_fcat-fieldname = 'NRRNG'.
  gs_fcat-ref_table = 'TB001'.
  gs_fcat-coltext   = 'Range'(010).
  append gs_fcat to gt_fieldcat_bp_vendor_n.
  clear gs_fcat.

  gs_fcat-fieldname = 'EXTERN_BP'.
  gs_fcat-ref_table = 'NRIV'.
  gs_fcat-ref_field = 'EXTERNIND'.
  gs_fcat-coltext   = 'ext'(039).
  append gs_fcat to gt_fieldcat_bp_vendor_n.
  clear gs_fcat.

  gs_fcat-fieldname = 'ARROW'.
  gs_fcat-inttype   = 'c'.
  gs_fcat-outputlen = '2'.
  gs_fcat-coltext   = 'Direction'(007).
  gs_fcat-seltext   = 'Direction'(007).
  gs_fcat-icon      = gc_true.
  append gs_fcat to gt_fieldcat_bp_vendor_n.
  clear gs_fcat.

  gs_fcat-fieldname = 'KTOKK'.
  gs_fcat-ref_table = 'V_TBC001'.
  gs_fcat-coltext   = 'Vendor Account Group'(013).
  append gs_fcat to gt_fieldcat_bp_vendor_n.
  clear gs_fcat.

  gs_fcat-fieldname = 'TXT30'.
  gs_fcat-ref_table = 'V_TBC001'.
  gs_fcat-coltext   = 'Description'(004).
  append gs_fcat to gt_fieldcat_bp_vendor_n.
  clear gs_fcat.

  gs_fcat-fieldname = 'NUMKR'.
  gs_fcat-ref_table = 'T077K'.
  gs_fcat-coltext   = 'Range'(010).
  append gs_fcat to gt_fieldcat_bp_vendor_n.
  clear gs_fcat.

  gs_fcat-fieldname = 'EXTERN_VEND'.
  gs_fcat-ref_table = 'NRIV'.
  gs_fcat-ref_field = 'EXTERNIND'.
  gs_fcat-coltext   = 'ext'(039).
  append gs_fcat to gt_fieldcat_bp_vendor_n.
  clear gs_fcat.

  gs_fcat-fieldname = 'XSAMENUMBER'.
  gs_fcat-ref_table = 'V_TBC001'.
  gs_fcat-coltext   = 'Same Nr.'(012).
  append gs_fcat to gt_fieldcat_bp_vendor_n.
  clear gs_fcat.

*create container for number assignment BP -> Vendor
  create object gr_cont_bp_vendor_n
    exporting
      container_name = 'CC_BP_VENDOR_N'.

*create ALV object for number assignment BP -> Vendor
  create object gr_alv_bp_vendor_n
    exporting
      i_parent = gr_cont_bp_vendor_n.

*create container for log table
  create object gr_cont_log_0800
    exporting
      container_name = 'CC_LOG_VENDOR_POST'.
*create ALV object for log table
  create object gr_alv_log_0800
    exporting
      i_parent = gr_cont_log_0800.
*one handler is used for each event of cl_gui_alv_grid
  set handler gr_event_handler->on_f1 for gr_alv_log_0800.
  set handler gr_event_handler->on_double_click for gr_alv_log_0800.
  set handler gr_event_handler->on_hotspot_click for gr_alv_log_0800.
endform.
*&---------------------------------------------------------------------*
*& Form SHOW_DATA_VENDOR_0800
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form show_data_vendor_0800 .
gs_layout_default-grid_title = 'Settings for Business Partner roles'(031).
  perform show_table_alv  using    gr_alv_bp_vendor_r
                                   gs_layout_default
                          changing gt_bp_to_vendor_r
                                   gt_fieldcat_bp_vendor_r.

*Show ALV for Number Assingment BP -> Vendor
  gs_layout_default-grid_title = 'ettings for Business Partner groupings'(032).
  perform show_table_alv  using    gr_alv_bp_vendor_n
                                   gs_layout_default
                          changing gt_bp_to_vendor_n
                                   gt_fieldcat_bp_vendor_n.

*sort log table by icon, delete duplicates and display in alv grid
  clear gt_log_table.
  gt_log_table = gt_log_table_0800.
  perform sort_log_table.
  perform show_table_alv using    gr_alv_log_0800
                                  gs_layout_log_0800
                         changing gt_log_table
                                  gt_fieldcat_log.
endform.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_VENDOR_0800  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module user_command_vendor_0800 input.
  case ok_code.
    when gc_info. "documentation for both directions
      perform show_documentation using gc_general_text 'CVI_FS_C_C_VENDOR'.
    when  gc_customizing. "goto customizing
      perform show_documentation using gc_general_text 'CVI_FS_C_C_GO_TO_CUSTOMIZING'.
    when gc_docu1. "documentation BP->Vendor
      perform show_documentation using gc_general_text 'CVI_FS_C_C_BP_TO_VENDOR'.
    when gc_docu2. "documentation Vendor->BP
      perform show_documentation using gc_general_text 'CVI_FS_C_C_VENDOR_TO_BP'.
    when gc_back.
      set screen 100. "start screen
       when gc_prev.
      set screen 100.
       when gc_home.
      set screen 100.
*    when gc_next.
*      set screen 600. "vendor check screen

    when gc_exit.
      leave program.
  endcase.
endmodule.
