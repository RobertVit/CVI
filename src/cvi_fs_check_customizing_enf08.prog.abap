*----------------------------------------------------------------------*
***INCLUDE CVI_FS_CHECK_CUSTOMIZING_ENF08.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form SHOW_DATA_VENDOR2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form show_data_vendor2 .

*  data: lv_text      type string,
*        lv_text_role type string.
*
*  if gt_outtab[] is not initial.
*    gs_layout_default-grid_title = 'CHK_BP_AC'.
    gs_layout_default-cwidth_opt = gc_false.
    set handler lcl_event_handler=>on_click_acgp for gr_alv_ac_gp.

    perform show_table_alv  using    gr_alv_ac_gp
                                     gs_layout_default
                            changing gt_outtab[]
                                     gt_fieldcat_ac_gp.


*  else.
*
*    if gt_outtab_log_ac[] is not initial.
**      concatenate gv_icon_red  'CHK_BP_AC :Error log account groups need to be maintained' into lv_text separated by space.
*      lv_text = 'CHK_BP_AC: Maintain Account Groups from Error Log'.
*    else.
*      lv_text = 'CHK_BP_AC: All entries are Synchronized'.
*    endif.
*
*    perform show_text_element using gr_cont_ac_gp
*                                    lv_text.
*
*  endif.

*  if gt_outtab_role[] is not initial.
*    gs_layout_role-grid_title = 'CHK_BP_ROLE'.
    gs_layout_role-cwidth_opt = gc_false.

set handler lcl_event_handler=>on_toolbar_role for gr_alv_role.


gr_alv_role->register_edit_event( exporting i_event_id = cl_gui_alv_grid=>mc_evt_modified ).

gr_alv_role->register_edit_event( exporting i_event_id = cl_gui_alv_grid=>mc_evt_enter ).


    perform show_table_alv  using    gr_alv_role
                                       gs_layout_role
                              changing gt_outtab_role[]
                                      gt_fieldcat_role.

SET HANDLER lcl_event_handler=>on_data_change for gr_alv_role.
 SET HANDLER lcl_event_handler=>on_handle_user_command for gr_alv_role.
set handler lcl_event_handler=>on_click_role for gr_alv_role.
SET HANDLER lcl_event_responder=>refresh_table_change_role for gr_alv_role.




*    set handler lcl_event_responder=>refresh_changed_data_out for  gr_alv_role.
*            set handler lcl_event_responder=>refresh_table_change_out for  gr_alv_role.
*  else.
*    if gt_outtab_log_role[] is not initial.
**      concatenate gv_icon_red  'CHK_BP_ROLE :Error log account groups need to be maintained' into lv_text_role separated by space.
*      lv_text_role = 'CHK_BP_ROLE : Maintain Account Groups from Error Log'.
*    else.
*      lv_text_role = 'CHK_BP_ROLE :ALL ENTRIES ARE SYNCHRONISED'.
*    endif.
*    perform show_text_element using gr_cont_role
*                                    lv_text_role.
*  endif.
*  if gt_outtab_log[] is not initial.
data : ls_outtab_log like line of gt_outtab_log_ac_fin.

refresh : gt_outtab_log_fin[].




  if gv_checkid is not initial.
     loop at gt_outtab_log_ac_fin into ls_outtab_log .
       if ls_outtab_log-chk = gv_checkid.
         append ls_outtab_log to gt_outtab_log_fin.
        endif.
      endloop.
   else.
     loop at gt_outtab_log_ac_fin into ls_outtab_log .
         append ls_outtab_log to gt_outtab_log_fin.
      endloop.
   endif.

*clear : gv_checkid.


    gs_layout_log-grid_title = 'Error'.
    perform show_table_alv using     gr_alv_log2
                                     gs_layout_log
                            changing gt_outtab_log_fin[]
                                     gt_fieldcat_log2.

    set handler lcl_event_handler=>on_hotspot_log1 for gr_alv_log2.
*  endif.
endform.
*&---------------------------------------------------------------------*
*& Form SHOW_DATA_VENDOR3
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form show_data_vendor3 .
  data: lv_text type string.
*  if gt_outtab_ind_in[] is not initial.
    gs_layout_ind_in-grid_title = 'Select Industry system'.
    gs_layout_ind_in-cwidth_opt = gc_false.
    gs_layout_ind_in-smalltitle = '1'.
    if gr_alv_ind_in is initial.
          create object gr_alv_ind_in
            exporting
              i_parent = gr_cont_ind_in.
endif.
  gr_alv_ind_in->register_edit_event( exporting i_event_id = cl_gui_alv_grid=>mc_evt_enter ).
    gr_alv_ind_in->register_edit_event( exporting i_event_id = cl_gui_alv_grid=>mc_evt_modified ).

    perform show_table_alv  using    gr_alv_ind_in
                                    gs_layout_ind_in
                           changing gt_outtab_ind_sys[]
                                     gt_fieldcat_ind_in.
        set handler lcl_event_responder=>refresh_changed_data_in for  gr_alv_ind_in.
            set handler lcl_event_responder=>refresh_table_change_in for  gr_alv_ind_in.




    gs_layout_ind_out-grid_title = 'Missing Industry Keys'.
    gs_layout_ind_out-cwidth_opt = gc_false.
    gs_layout_ind_out-smalltitle = '1'.


    perform show_table_alv  using    gr_alv_ind_out
                                    gs_layout_ind_out
                           changing gt_outtab_ind_in[]
                                    gt_fieldcat_ind_out.

    gs_layout_cust_log2-grid_title = 'Error'.
    gs_layout_cust_log2-cwidth_opt = gc_false.
    gs_layout_cust_log2-smalltitle = '1'.
    create object gr_alv_cust_log2
                    exporting
                      i_parent = gr_cont_cust_log2.

    perform show_table_alv using     gr_alv_cust_log2
                                   gs_layout_cust_log2
                          changing gt_outtab_log_ind[]
                                   gt_fieldcat_cust_log2.
    set handler lcl_event_handler=>on_hotspot_cust_log2 for gr_alv_cust_log2.
endform.
