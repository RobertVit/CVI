*----------------------------------------------------------------------*
***INCLUDE CVI_FS_CHECK_CUSTOMIZING_ENO07.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module PBO_1120_CUST_MAP_CONTIN OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
module pbo_1120_cust_map_contin output.
  set pf-status 'CVI_FS_C_C_PREV'.
*  set titlebar 'CVI_FS_C_C_CUSTOMER'.
  perform select_data_customer_1120.
  perform create_alv_customer_1120.
  perform set_data_customer_1120.
  perform show_data_customer_1120.
endmodule.                    "pbo_1120_cust_map_contin OUTPUT
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_CONTIN_1120  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module user_command_contin_1120 input.
  if gr_alv_tb038a_out is not initial.
    gr_alv_tb038a_out->check_changed_data( ).
    gr_alv_tb038a_out->refresh_table_display( ).
  endif.
  case ok_code.
    when gc_back.
      set screen 1100. "start screen
       when gc_home.
      set screen 100.
    when 'DOCU_IND'.
      perform show_documentation using gc_general_text 'CVI_FS_C_C_CUS_POST_IND'.
    when gc_prev.
      set screen 1100.
    when 'SAVE'.
      perform cust_save_post.
    when 'CHK_CUST'.
      if indout = 'X'.
        if gt_outtab_post_out_log1120[] is not initial.
          gt_outtab_post_out_log1130[] = gt_outtab_post_out_log1120[].
          call screen 1130 starting at 10 10.
        else.
          message 'No Customizing Erorrs exist for Outgoing Industries' type 'I'.
        endif.
      elseif indin = 'X'..
        if gt_outtab_post_log1120[] is not initial.
          gt_outtab_post_out_log1130[] = gt_outtab_post_log1120[].
          call screen 1130 starting at 10 10.
        else.
          message 'No Customizing Erorrs exist for Incoming Industries' type 'I'.
        endif.
      endif.
    when gc_exit.
      leave program.
  endcase.
endmodule.                    "user_command_contin_1120 INPUT
*&---------------------------------------------------------------------*
*& Form SELECT_DATA_CUSTOMER_1120
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form select_data_customer_1120 .
  data: cl_chk_map           type ref to cl_s4_checks_bp_enh,
        lt_check_results_map type table of ty_preprocessing_check_result,
        ls_check_results_map like line of lt_check_results_map,
        ls_tb038a            like line of gt_tb038a,
        ls_tb038a_out        like line of gt_tb038a_out.

  refresh : gt_tb038a,
            gt_tb038a_main,
            gt_tb038a_out,
            gt_tb038a_main_out,
            gt_fieldcat_tb038a,
            gt_fieldcat_tb038a_out,
            gt_fieldcat_post_log1120,
            gt_outtab_post_log1120main,
            gt_outtab_post_log1120new,
            gt_outtab_post_log1120,
            gt_tb038a_in_err,
            gt_tb038a_out_err,
            gt_outtab_post_out_log1120,
            gt_outtab_post_log1120,
            gt_outtab_post_out_log1130.


  create object cl_chk_map.
  call method cl_chk_map->check_post_value_mapping
    importing
      ct_tb910         = gt_tb910
      ct_tb912         = gt_tb912
      ct_tb914         = gt_tb914
      ct_tb916         = gt_tb916
      ct_tb027         = gt_tb027
      ct_tb019         = gt_tb019
      ct_tb038a        = gt_tb038a
      ct_tb033         = gt_tb033
      ct_tb038a_out    = gt_tb038a_out
    changing
      ct_check_results = lt_check_results_map.



  sort gt_tb038a by istype ind_sector.
  sort gt_tb038a_out by istype ind_sector.

  delete adjacent duplicates from gt_tb038a comparing istype ind_sector.
  delete adjacent duplicates from gt_tb038a_out comparing istype ind_sector.

endform.                    "select_data_customer_1120
*&---------------------------------------------------------------------*
*& Form CREATE_ALV_CUSTOMER_1120
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form create_alv_customer_1120 .

********************************************TB038a START*********************
  gs_fcat_map-fieldname = 'ISTYPE'.
  gs_fcat_map-coltext   = 'Industry System'(047).
  gs_fcat_map-col_pos = 1.
  gs_fcat_map-outputlen = 6.
  gs_fcat_map-dd_outlen = 6.
  append gs_fcat_map to gt_fieldcat_tb038a.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'IND_SECTOR'.
  gs_fcat_map-coltext   = 'Industry Sector'(048).
  gs_fcat_map-col_pos = 2.
  gs_fcat_map-outputlen = 6.
  gs_fcat_map-dd_outlen = 6.
  append gs_fcat_map to gt_fieldcat_tb038a.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'DESC'.
  gs_fcat_map-coltext   = 'Description'(004).
  gs_fcat_map-col_pos = 4.
  gs_fcat_map-outputlen = 26.
  gs_fcat_map-edit = ' '.
  append gs_fcat_map to gt_fieldcat_tb038a.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'ISTYPE_CHECK'.
  gs_fcat_map-coltext   = 'Industry System'(047).
  gs_fcat_map-col_pos = 5.
  gs_fcat_map-outputlen = 6.
  gs_fcat_map-checkbox = 'X'.
  gs_fcat_map-edit = 'X'.
  append gs_fcat_map to gt_fieldcat_tb038a.
  clear gs_fcat_map.

  if gr_cont_tb038a  is initial.
    create object gr_cont_tb038a
      exporting
        container_name = 'CC_BP_CUSTOMER_IN'.
  endif.

  gs_fcat_map-fieldname = 'ISTYPE'.
  gs_fcat_map-coltext   = 'Industry System'(047).
  gs_fcat_map-col_pos = 1.
  gs_fcat_map-outputlen = 6.
  gs_fcat_map-dd_outlen = 6.
  append gs_fcat_map to gt_fieldcat_tb038a_out.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'IND_SECTOR'.
  gs_fcat_map-coltext   = 'Industry Sector'(048).
  gs_fcat_map-col_pos = 1.
  gs_fcat_map-outputlen = 6.
  gs_fcat_map-dd_outlen = 6.
  append gs_fcat_map to gt_fieldcat_tb038a_out.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'INDKEY'.
  gs_fcat_map-coltext   = 'Industry Key'(049).
  gs_fcat_map-col_pos = 3.
  gs_fcat_map-outputlen = 16.
  gs_fcat_map-dd_outlen = 6.
  gs_fcat_map-drdn_field = 'DROP_DOWN_HANDLE'.
  gs_fcat_map-edit = 'X'.
  append gs_fcat_map to gt_fieldcat_tb038a.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'DESC'.
  gs_fcat_map-coltext   = 'Description'(004).
  gs_fcat_map-col_pos = 2.
  gs_fcat_map-outputlen = 26.
  gs_fcat_map-edit = ' '.
  append gs_fcat_map to gt_fieldcat_tb038a_out.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'ISTYPE_CHECK'.
  gs_fcat_map-coltext   = 'Industry System'(047).
  gs_fcat_map-col_pos = 3.
  gs_fcat_map-outputlen = 6.
  gs_fcat_map-checkbox = 'X'.
  gs_fcat_map-edit = 'X'.
  append gs_fcat_map to gt_fieldcat_tb038a_out.
  clear gs_fcat_map.



  if gr_cont_tb038a_out is initial.
    create object gr_cont_tb038a_out
      exporting
        container_name = 'CC_BP_CUSTOMER_OUT'.
  endif.



********************************************TB038a END*********************

  clear gs_fcat_map.
  gs_fcat_map-fieldname = 'ICON'.
  gs_fcat_map-coltext   = 'Type'(014).
  gs_fcat_map-col_pos = 1.
  gs_fcat_map-outputlen = 3.
  gs_fcat_map-icon = 'X'.
  append gs_fcat_map to gt_fieldcat_post_log1120.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'CHK'.
  gs_fcat_map-coltext   = 'Check ID'(015).
  gs_fcat_map-col_pos = 2.
  gs_fcat_map-outputlen = 20.
  append gs_fcat_map to gt_fieldcat_post_log1120.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'LOG'.
  gs_fcat_map-coltext   = 'Error Log'(016).
  gs_fcat_map-col_pos = 2.
  gs_fcat_map-outputlen = 85.
  gs_fcat_map-hotspot = 'X'.
  append gs_fcat_map to gt_fieldcat_post_log1120.
  clear gs_fcat_map.

  if gr_cont_post_log1120 is initial.
    create object gr_cont_post_log1120
      exporting
        container_name = 'CUST_ERROR_1120'.
  endif.

  if gr_alv_post_log1120 is initial.
    create object gr_alv_post_log1120
      exporting
        i_parent = gr_cont_post_log1120.
  endif.

endform.                    "create_alv_customer_1120
*&---------------------------------------------------------------------*
*& Form SET_DATA_CUSTOMER_1120
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form set_data_customer_1120 .
****************TB038a**************
  data: ls_tb038a          like line of gt_tb038a,
        lt_tb038b          type table of tb038b,
        ls_tb038b          like line of lt_tb038b,
        lt_tb038a          type table of tb038a,
        ls_tb038a_d        like line of gt_outtab_tb038a,
        ls_outtab_cust_log like line of gt_outtab_post_log,
        ls_tb038a_err      like line of gt_tb038a_in_err.


  data: lt_dropdown_ind_in type lvc_t_drop,
        ls_dropdown_ind_in type lvc_s_drop.
  data: lt_t016            type table of t016 with header line,
        ls_t016            like line of lt_t016.

  select * from t016 into corresponding fields of table lt_t016.
  loop at lt_t016 into ls_t016.
    ls_dropdown_ind_in-handle = '1'.
    ls_dropdown_ind_in-value = ls_t016-brsch.
    append ls_dropdown_ind_in to lt_dropdown_ind_in.
  endloop.

  if gt_tb038a is not initial.
    if lt_tb038b is initial.
      select distinct * from tb038b into table lt_tb038b where spras = sy-langu." where paauth = ls_tb914_d-bu_paauth. "#EC CI_BYPASS.
    endif.
    loop at gt_tb038a into ls_tb038a.
      select * from tb038a into table lt_tb038a where istype = ls_tb038a-istype and ind_sector = ls_tb038a-ind_sector .
      if sy-subrc = 0.
        read table lt_tb038b into ls_tb038b with key istype = ls_tb038a-istype ind_sector = ls_tb038a-ind_sector .
        ls_tb038a_d-istype = ls_tb038a-istype .
        ls_tb038a_d-ind_sector = ls_tb038a-ind_sector .
        ls_tb038a_d-desc = ls_tb038b-text.
        ls_tb038a_d-istype_check = 'X'.
        append ls_tb038a_d to gt_tb038a_main.
      else.
        ls_outtab_cust_log-chk = 'CHK_CP_TB038A_IN'.
        ls_outtab_cust_log-icon = gv_icon_red.
        ls_outtab_cust_log-table = 'TB038A'.
        concatenate 'ISTYPE = '  ls_tb038a-istype  ' IND_SECTOR = '  ls_tb038a-ind_sector into ls_outtab_cust_log-log.
        ls_outtab_cust_log-value1 = ls_tb038a-istype.
        ls_outtab_cust_log-value2 = ls_tb038a-ind_sector.
        append ls_outtab_cust_log to gt_outtab_post_log1120.
        ls_tb038a_err-client = sy-mandt.
        ls_tb038a_err-istype = ls_tb038a-istype.
        ls_tb038a_err-ind_sector = ls_tb038a-ind_sector.

        append ls_tb038a_err to gt_tb038a_in_err.
        clear ls_tb038a_err.
      endif.
    endloop.
  endif.

  data : ls_tb038a_main like line of gt_tb038a_main,
         lv_index type i.
  lv_index = 1.
  if gt_tb038a_main is not initial.
    loop at gt_tb038a_main into ls_tb038a_main .
      ls_tb038a_main-indkey = ls_dropdown_ind_in-value.
      ls_tb038a_main-drop_down_handle = '1'.
      modify gt_tb038a_main index lv_index from ls_tb038a_main transporting indkey drop_down_handle.
      lv_index = lv_index + 1.
    endloop.
  endif.


  if gt_tb038a_out is not initial.
    if lt_tb038b is initial.
      select distinct * from tb038b into table lt_tb038b where spras = sy-langu." where paauth = ls_tb914_d-bu_paauth."#EC CI_BYPASS.
    endif.
    loop at gt_tb038a_out into ls_tb038a.
      select * from tb038a into table lt_tb038a where istype = ls_tb038a-istype and ind_sector = ls_tb038a-ind_sector .
      if sy-subrc = 0.
        read table lt_tb038b into ls_tb038b with key istype = ls_tb038a-istype ind_sector = ls_tb038a-ind_sector .
        ls_tb038a_d-istype = ls_tb038a-istype .
        ls_tb038a_d-ind_sector = ls_tb038a-ind_sector .
        ls_tb038a_d-desc = ls_tb038b-text.
        ls_tb038a_d-istype_check = 'X'.
        append ls_tb038a_d to gt_tb038a_main_out.
      else.
        ls_outtab_cust_log-chk = 'CHK_CP_TB038A_OUT'.
        ls_outtab_cust_log-icon = gv_icon_red.
        ls_outtab_cust_log-table = 'TB038A'.
        concatenate 'ISTYPE = '  ls_tb038a-istype  ' IND_SECTOR = '  ls_tb038a-ind_sector into ls_outtab_cust_log-log.
        ls_outtab_cust_log-value1 = ls_tb038a-istype.
        ls_outtab_cust_log-value2 = ls_tb038a-ind_sector.
        append ls_outtab_cust_log to gt_outtab_post_out_log1120.
        ls_tb038a_err-client = sy-mandt.
        ls_tb038a_err-istype = ls_tb038a-istype.
        ls_tb038a_err-ind_sector = ls_tb038a-ind_sector.
        append ls_tb038a_err to gt_tb038a_out_err.
        clear ls_tb038a_err.
      endif.
    endloop.
  endif.

  data : ls_tb038a_main_out like line of gt_tb038a_main_out,
         lv_index_out type i.
  lv_index_out = 1.
  if gt_tb038a_main_out is not initial.
    loop at gt_tb038a_main_out into ls_tb038a_main_out .
      ls_tb038a_main_out-indkey = ls_dropdown_ind_in-value.
      ls_tb038a_main_out-drop_down_handle = '1'.
      modify gt_tb038a_main_out index lv_index_out from ls_tb038a_main_out transporting indkey drop_down_handle.
      lv_index_out = lv_index_out + 1.
    endloop.
  endif.
  delete adjacent duplicates from gt_outtab_post_log1120.
  delete adjacent duplicates from gt_outtab_post_out_log1120.

  if lt_t016[] is initial.
    ls_outtab_cust_log-chk = 'CHK_CP_TB038A_IN'.
    ls_outtab_cust_log-icon = gv_icon_red.
    ls_outtab_cust_log-log = 'Industry Keys are not maintained. Click here to maintain Industry Keys.'.
    append ls_outtab_cust_log to gt_outtab_post_log1120main.
  endif.


  if gt_tb038a is initial.
    ls_outtab_cust_log-chk = 'CHK_CP_TB038A_IN'.
    ls_outtab_cust_log-icon = gv_icon_green.
    ls_outtab_cust_log-log = 'Assignment of Incoming Industries is consistent'.
    append ls_outtab_cust_log to gt_outtab_post_log1120main.
  else.
    ls_outtab_cust_log-chk = 'CHK_CP_TB038A_IN'.
    ls_outtab_cust_log-icon = gv_icon_red.
    ls_outtab_cust_log-log = 'Assignment of Incoming Industries is inconsistent'.
    append ls_outtab_cust_log to gt_outtab_post_log1120main.
  endif.

  if gt_tb038a_out is initial.
    ls_outtab_cust_log-chk = 'CHK_CP_TB038A_OUT'.
    ls_outtab_cust_log-icon = gv_icon_green.
    ls_outtab_cust_log-log = 'Assignment of Outgoing Industries consistent'.
    append ls_outtab_cust_log to gt_outtab_post_log1120main.
  else.
    ls_outtab_cust_log-chk = 'CHK_CP_TB038A_OUT'.
    ls_outtab_cust_log-icon = gv_icon_red.
    ls_outtab_cust_log-log = 'Assignment of Outgoing Industries is inconsistent'.
    append ls_outtab_cust_log to gt_outtab_post_log1120main.
  endif.

  if gt_tb038a_in_err is INITIAL.
    ls_outtab_cust_log-chk = 'CHK_CP_TB038A_IN'.
    ls_outtab_cust_log-icon = gv_icon_green.
    ls_outtab_cust_log-log = 'No Customizating errors in Assignment of Incoming Industries'.
    append ls_outtab_cust_log to gt_outtab_post_log1120main.
  else.
    ls_outtab_cust_log-chk = 'CHK_CP_TB038A_IN'.
    ls_outtab_cust_log-icon = gv_icon_red.
    ls_outtab_cust_log-log = 'Customizing  errors in Assignment of Incoming Industries.Check Customizing '.
    append ls_outtab_cust_log to gt_outtab_post_log1120main.
    endif.

  if gt_tb038a_out_err is INITIAL.
    ls_outtab_cust_log-chk = 'CHK_CP_TB038A_OUT'.
    ls_outtab_cust_log-icon = gv_icon_green.
    ls_outtab_cust_log-log = 'No Customizing  errors in Assignment of Outgoing Industries'.
    append ls_outtab_cust_log to gt_outtab_post_log1120main.
  else.
    ls_outtab_cust_log-chk = 'CHK_CP_TB038A_OUT'.
    ls_outtab_cust_log-icon = gv_icon_red.
    ls_outtab_cust_log-log = 'Customizing  errors in Assignment of Outgoing Industries.Check Customizing  '.
    append ls_outtab_cust_log to gt_outtab_post_log1120main.
    endif.

  if gr_alv_tb038a_out is initial.
    create object gr_alv_tb038a_out
      exporting
        i_parent = gr_cont_tb038a_out.
  endif.



  call method gr_alv_tb038a_out->set_drop_down_table
    exporting
      it_drop_down = lt_dropdown_ind_in.




endform.                    "set_data_customer_1120
*&---------------------------------------------------------------------*
*& Form SHOW_DATA_CUSTOMER_1120
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form show_data_customer_1120 .

  gs_layout_default_map-cwidth_opt = gc_false.
  gs_layout_default_map-smalltitle = '1'.

  if gr_alv_tb038a is initial.
    create object gr_alv_tb038a
      exporting
        i_parent = gr_cont_tb038a.
  endif.

  if indin = ' '.
    gt_tb038a_main_alv[] = gt_tb038a_main_out[].
    loop at gt_outtab_post_log1120main into ls_log where chk = 'CHK_CP_TB038A_OUT'.
      append ls_log to gt_outtab_post_log1120new.
    endloop.
  elseif indout = ' '.
    gt_tb038a_main_alv[] = gt_tb038a_main[].
    loop at gt_outtab_post_log1120main into ls_log where chk = 'CHK_CP_TB038A_IN'.
      append ls_log to gt_outtab_post_log1120new.
    endloop.
  endif.

  gs_layout_post_log1120-no_toolbar = gc_true.
  gs_layout_default_map-no_toolbar = gc_true.

  if gr_alv_tb038a_out is initial.
    create object gr_alv_tb038a_out
      exporting
        i_parent = gr_cont_tb038a_out.
  endif.


  if indout = 'X'.
    gs_layout_default_map-grid_title = 'Missing Outgoing Industry System Mapping'.

  perform show_table_alv  using    gr_alv_tb038a_out
                                   gs_layout_default_map
                          changing gt_tb038a_main_alv[]
                                   gt_fieldcat_tb038a.

    perform show_table_alv using     gr_alv_post_log1120
                                 gs_layout_post_log1120
                        changing gt_outtab_post_log1120new[]
                                 gt_fieldcat_post_log1120.

  else.
    gs_layout_default_map-grid_title = 'Missing Incoming Industry System Mapping'.


    perform show_table_alv  using    gr_alv_tb038a_out
                                   gs_layout_default_map
                          changing gt_tb038a_main_alv[]
                                   gt_fieldcat_tb038a.

  perform show_table_alv using     gr_alv_post_log1120
                               gs_layout_post_log1120
                      changing gt_outtab_post_log1120new[]
                               gt_fieldcat_post_log1120.
  endif.
  set handler lcl_event_handler=>on_hotspot_cust_ind_log1 for gr_alv_post_log1120.
  call method gr_alv_tb038a_out->register_edit_event
    exporting
      i_event_id = cl_gui_alv_grid=>mc_evt_modified
    exceptions
      error      = 1
      others     = 2.


endform.                    "show_data_customer_1120
