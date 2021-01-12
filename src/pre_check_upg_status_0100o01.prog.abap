*----------------------------------------------------------------------*
***INCLUDE ZTEST_PRE_CHECK_STATUS_0100O01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
module status_0100 output.
  set pf-status 'PF_STATUS'.
  set titlebar 'TIT_STAT'.

  data : lo_custom type ref to cl_gui_custom_container.
  data : lo_alv type ref to cl_gui_alv_grid.
  data : lt_fcat type lvc_t_fcat.
  data : ls_fcat like line of lt_fcat.
  data : ls_layo type lvc_s_layo.


  if lo_custom is not bound.
    create object lo_custom
      exporting
*       parent                      =     " Parent container
        container_name              = 'CUSTOM_CONTROL'    " Name of the Screen CustCtrl Name to Link Container To
      exceptions
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        others                      = 6.
    if sy-subrc <> 0.
*    message id sy-msgid type sy-msgty number sy-msgno
*               with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    endif.


  endif.

  if lo_alv is not bound and lo_custom is bound.

    create object lo_alv
      exporting
        i_parent          = lo_custom     " Parent Container
      exceptions
        error_cntl_create = 1
        error_cntl_init   = 2
        error_cntl_link   = 3
        error_dp_create   = 4
        others            = 5.
    if sy-subrc <> 0.
*   message id sy-msgid type sy-msgty number sy-msgno
*              with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    endif.
  endif.

  refresh gt_fcat.

*  ls_fcat-fieldname = 'No_of_records'.
*  ls_fcat-coltext = 'No of records'.
**  ls_fcat-edit = 'X'.
*  ls_fcat-outputlen = 20.
*  ls_fcat-tooltip = 'No of records to process'.
**  ls_fcat-col_pos = 3.
*  append ls_fcat to gt_fcat.
*  clear ls_fcat.


  ls_fcat-fieldname = 'CHK_NAME'.
*  ls_fcat-edit = 'X'.
  ls_fcat-coltext = 'PreCheck Details'.
  ls_fcat-outputlen = 60.
  ls_fcat-col_pos = 1.
  ls_fcat-tooltip = 'CheckName'.
  append ls_fcat to gt_fcat.
  clear ls_fcat.


  ls_fcat-fieldname = 'CHECK'.
  ls_fcat-coltext = 'Checks'.
  ls_fcat-edit = 'X'.
  ls_fcat-outputlen = 20.
  ls_fcat-checkbox = 'X'.
  ls_fcat-tooltip = 'Checks'.
  ls_fcat-col_pos = 2.
  append ls_fcat to gt_fcat.
  clear ls_fcat.

  if gt_check is initial.

    gs_check-chkid = 'CHK_1'.
    gs_check-chk_name = 'BP roles are assigned to account groups'. "text-013.
    gs_check-check = ''.
    append gs_check to gt_check.
    clear gs_check.
    gs_check-chkid = 'CHK_2'.
    gs_check-chk_name = 'Every account group BP Grouping must be available'. "text-015.
    gs_check-check = ''.
    append gs_check to gt_check.
    clear gs_check.

    gs_check-chkid = 'CHK_4'.
    gs_check-chk_name = 'Customer value mapping'.  "text-016.
    gs_check-check = ' '.
    append gs_check to gt_check.
    clear gs_check.

    gs_check-chkid = 'CHK_5'.
    gs_check-chk_name = 'Vendor value Mapping'. "text-018.
    gs_check-check = ' '.
    append gs_check to gt_check.
    clear gs_check.

    gs_check-chkid = 'CHK_10'.
    gs_check-chk_name = 'Customer and Vendor Value mapping(BP->Customer or Vendor)'." text-033.
    gs_check-check = ' '.
    append gs_check to gt_check.
    clear gs_check.

    gs_check-chkid = 'CHK_12'.
    gs_check-chk_name = text-060.
    gs_check-check = 'X'.
    append gs_check to gt_check.
    clear gs_check.

    gs_check-chkid = 'CHK_3'.
    gs_check-chk_name = 'CVI Mapping '. "text-019.
*    gs_check-chk_name = lv_check.
    gs_check-check = 'X'.
    append gs_check to gt_check.
    clear gs_check.

    gs_check-chkid = 'CHK_6'.
    gs_check-chk_name = 'Contact Person Mapping'." text-030.
    gs_check-check = 'X'.
    append gs_check to gt_check.
    clear gs_check.

  endif.



  ls_layo-grid_title = 'Pre-Upgrade checks'." text-017.
  ls_layo-no_rowmark = 'X'.
  lo_alv->register_edit_event(
    exporting
      i_event_id =   cl_gui_alv_grid=>mc_evt_modified   " Event ID
*  exceptions
*    error      = 1
*    others     = 2
  ).
  if sy-subrc <> 0.
* message id sy-msgid type sy-msgty number sy-msgno
*            with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  endif.



*
*  LOOP AT SCREEN.
*IF SCREEN-NAME = 'GS_INPUT' OR SCREEN-NAME = 'GS_TEXT'.
*SCREEN-INPUT = 0.
*SCREEN-INVISIBLE = 1.
*MODIFY SCREEN.
*ENDIF.
*ENDLOOP.
*


  set handler lcl_class=>on_toolbar for lo_alv.
  lo_alv->set_table_for_first_display(
    exporting
*    i_buffer_active               =     " Buffering Active
*    i_bypassing_buffer            =     " Switch Off Buffer
*    i_consistency_check           =     " Starting Consistency Check for Interface Error Recognition
*    i_structure_name              =     " Internal Output Table Structure Name
*    is_variant                    =     " Layout
*    i_save                        =     " Save Layout
*    i_default                     = 'X'    " Default Display Variant
        is_layout                    = ls_layo    " Layout
*    is_print                      =     " Print Control
*    it_special_groups             =     " Field Groups
*    it_toolbar_excluding          =     " Excluded Toolbar Standard Functions
*    it_hyperlink                  =     " Hyperlinks
*    it_alv_graphics               =     " Table of Structure DTC_S_TC
*    it_except_qinfo               =     " Table for Exception Tooltip
*    ir_salv_adapter               =     " Interface ALV Adapter
    changing
      it_outtab                     =  gt_check   " Output Table
      it_fieldcatalog               =  gt_fcat    " Field Catalog
*    it_sort                       =     " Sort Criteria
*    it_filter                     =     " Filter Criteria
*  exceptions
*    invalid_parameter_combination = 1
*    program_error                 = 2
*    too_many_lines                = 3
*    others                        = 4
  ).
  if sy-subrc <> 0.
* message id sy-msgid type sy-msgty number sy-msgno
*            with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  endif.
  set handler lcl_class=>on_data_change for lo_alv.
  set handler lcl_class=>on_data_change_finished for lo_alv.




endmodule.                    "status_0100 OUTPUT
*&---------------------------------------------------------------------*
*& Module STATUS_0200 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
module status_0200 output.
  set pf-status 'STATUS_200'.
  set titlebar 'TITL_200' with gv_title.


  data : lo_custom_final type ref to cl_gui_custom_container.
  data : lo_alv_final type ref to cl_gui_alv_grid.
  data : lt_fcat_final type lvc_t_fcat.
  data : ls_fcat_final like line of lt_fcat.
  data : ls_layo_final type lvc_s_layo.


  refresh gt_fcat_final.

  if lo_custom_final is not bound.
    create object lo_custom_final
      exporting
*       parent                      =     " Parent container
        container_name              = 'CUSTOM_CONTAINER_FINAL'    " Name of the Screen CustCtrl Name to Link Container To
      exceptions
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        others                      = 6.
    if sy-subrc <> 0.
*    message id sy-msgid type sy-msgty number sy-msgno
*               with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    endif.


  endif.

  if lo_alv_final is not bound and lo_custom_final is bound.

    create object lo_alv_final
      exporting
        i_parent          = lo_custom_final     " Parent Container
      exceptions
        error_cntl_create = 1
        error_cntl_init   = 2
        error_cntl_link   = 3
        error_dp_create   = 4
        others            = 5.
    if sy-subrc <> 0.
*   message id sy-msgid type sy-msgty number sy-msgno
*              with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    endif.
  endif.

  ls_fcat_final-fieldname = 'CHK_NAME'.
  ls_fcat_final-coltext = 'PreCheck Details'.
  ls_fcat_final-outputlen = 60.
  ls_fcat_final-tooltip = 'Check Name'.
  ls_fcat_final-col_pos = 1.
  append ls_fcat_final to gt_fcat_final.
  clear ls_fcat_final.


  ls_fcat_final-fieldname = 'STATUS'.
  ls_fcat_final-coltext = 'Status'.
  ls_fcat_final-tooltip = 'Status'.
  ls_fcat_final-outputlen = 20.
  ls_fcat_final-hotspot = 'X'.
  ls_fcat_final-icon = 'X'.
  ls_fcat_final-col_pos = 2.
  append ls_fcat_final to gt_fcat_final.
  clear ls_fcat_final.

  ls_fcat_final-fieldname = 'ERR_TYPE'.
  ls_fcat_final-coltext = 'Error Type'.
  ls_fcat_final-tooltip = 'Error Type'.
  ls_fcat_final-outputlen = 20.
**  ls_fcat_final-hotspot = 'X'.
**  ls_fcat_final-icon = 'X'.
  ls_fcat_final-col_pos = 3.
  append ls_fcat_final to gt_fcat_final.
  clear ls_fcat_final.




  ls_layo_final-grid_title = 'Precheck Status Result'.
  ls_layo_final-ctab_fname = 'COLOR'.
*  ls_layo_final-SMALLTITLE = 'X'.


  set handler lcl_class=>on_toolbar for lo_alv_final.
  lo_alv_final->set_table_for_first_display(
    exporting
*    i_buffer_active               =     " Buffering Active
*    i_bypassing_buffer            =     " Switch Off Buffer
*    i_consistency_check           =     " Starting Consistency Check for Interface Error Recognition
*    i_structure_name              =     " Internal Output Table Structure Name
*    is_variant                    =     " Layout
*    i_save                        =     " Save Layout
*    i_default                     = 'X'    " Default Display Variant
        is_layout                    = ls_layo_final    " Layout
*    is_print                      =     " Print Control
*    it_special_groups             =     " Field Groups
*    it_toolbar_excluding          =     " Excluded Toolbar Standard Functions
*    it_hyperlink                  =     " Hyperlinks
*    it_alv_graphics               =     " Table of Structure DTC_S_TC
*    it_except_qinfo               =     " Table for Exception Tooltip
*    ir_salv_adapter               =     " Interface ALV Adapter
    changing
      it_outtab                     =  gt_check_final   " Output Table
      it_fieldcatalog               =  gt_fcat_final    " Field Catalog
*    it_sort                       =     " Sort Criteria
*    it_filter                     =     " Filter Criteria
*  exceptions
*    invalid_parameter_combination = 1
*    program_error                 = 2
*    too_many_lines                = 3
*    others                        = 4
  ).
  if sy-subrc <> 0.
* message id sy-msgid type sy-msgty number sy-msgno
*            with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  endif.
  set handler lcl_class=>on_data_change for lo_alv_final.
  set handler lcl_class=>on_data_change_finished for lo_alv_final.

  set handler lcl_class=>on_hotspot for lo_alv_final.
endmodule.                    "status_0200 OUTPUT
*&---------------------------------------------------------------------*
*& Module STATUS_0201 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
module status_0201 output.
  set pf-status 'STATUS_0201'.
  set titlebar 'TITL_0201' with gv_title.
  data : lo_custom_msg type ref to cl_gui_custom_container.
  data : lo_alv_msg type ref to cl_gui_alv_grid.
  data :  ls_fcat_msg type lvc_s_fcat.
  data : ls_msg_layo type lvc_s_layo.


  refresh gt_fcat_msg.

  if lo_custom_msg is not bound.
    create object lo_custom_msg
      exporting
*       parent                      =     " Parent container
        container_name              = 'CUSTOM_CONTROL_MSG'    " Name of the Screen CustCtrl Name to Link Container To
      exceptions
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        others                      = 6.
    if sy-subrc <> 0.
*    message id sy-msgid type sy-msgty number sy-msgno
*               with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    endif.


  endif.

  if lo_alv_msg is not bound and lo_custom_msg is bound.

    create object lo_alv_msg
      exporting
        i_parent          = lo_custom_msg     " Parent Container
      exceptions
        error_cntl_create = 1
        error_cntl_init   = 2
        error_cntl_link   = 3
        error_dp_create   = 4
        others            = 5.
    if sy-subrc <> 0.
*   message id sy-msgid type sy-msgty number sy-msgno
*              with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    endif.
  endif.

  ls_fcat_msg-fieldname = 'STATUS'.
  ls_fcat_msg-coltext = 'Status'.
  ls_fcat_msg-outputlen = 10.
  ls_fcat-tooltip = 'Status'.
  ls_fcat_msg-icon = 'X'.
  ls_fcat_msg-col_pos = 2.
  append ls_fcat_msg to gt_fcat_msg.
  clear ls_fcat_msg.

  ls_fcat_msg-fieldname = 'MSG_NAME'.
  ls_fcat_msg-coltext = 'Error description'.
  ls_fcat-tooltip = 'Error description'.
  ls_fcat_msg-outputlen = 50.
  ls_fcat_msg-icon = 'X'.
  ls_fcat_msg-col_pos = 2.
  ls_fcat_msg-hotspot = 'X'.
  append ls_fcat_msg to gt_fcat_msg.
  clear ls_fcat_msg.



  ls_msg_layo-grid_title = 'Error Messages'.
  ls_msg_layo-smalltitle = 'X'.
  ls_msg_layo-stylefname = 'LT_STYL'.



  set handler lcl_class=>on_toolbar for lo_alv_msg.

  DATA: ls_style TYPE lvc_s_styl.

  FIELD-SYMBOLS: <fs_check_msg_final> LIKE LINE OF gt_check_msg_final.

  LOOP AT gt_check_msg_final ASSIGNING <fs_check_msg_final>.
    refresh <fs_check_msg_final>-LT_STYL.
    IF <fs_check_msg_final> IS ASSIGNED AND <fs_check_msg_final>-CLIENT NE SY-MANDT.
      ls_style-style =  cl_gui_alv_grid=>MC_STYLE_HOTSPOT_NO.
    ENDIF.

    ls_style-fieldname = 'MSG_NAME'.

    APPEND ls_style TO <fs_check_msg_final>-LT_STYL.
    CLEAR ls_style.
  ENDLOOP.

  lo_alv_msg->set_table_for_first_display(
    exporting
*    i_buffer_active               =     " Buffering Active
*    i_bypassing_buffer            =     " Switch Off Buffer
*    i_consistency_check           =     " Starting Consistency Check for Interface Error Recognition
*    i_structure_name              =     " Internal Output Table Structure Name
*    is_variant                    =     " Layout
*    i_save                        =     " Save Layout
*    i_default                     = 'X'    " Default Display Variant
        is_layout                    = ls_msg_layo   " Layout
*    is_print                      =     " Print Control
*    it_special_groups             =     " Field Groups
*    it_toolbar_excluding          =     " Excluded Toolbar Standard Functions
*    it_hyperlink                  =     " Hyperlinks
*    it_alv_graphics               =     " Table of Structure DTC_S_TC
*    it_except_qinfo               =     " Table for Exception Tooltip
*    ir_salv_adapter               =     " Interface ALV Adapter
    changing
      it_outtab                     =  gt_check_msg_final   " Output Table
      it_fieldcatalog               =  gt_fcat_msg    " Field Catalog
*    it_sort                       =     " Sort Criteria
*    it_filter                     =     " Filter Criteria
*  exceptions
*    invalid_parameter_combination = 1
*    program_error                 = 2
*    too_many_lines                = 3
*    others                        = 4
  ).


  set handler lcl_class=>on_hotspot_new for lo_alv_msg.
  if sy-subrc <> 0.
* message id sy-msgid type sy-msgty number sy-msgno
*            with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  endif.
endmodule.                    "status_0201 OUTPUT
