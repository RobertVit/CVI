*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_1140  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_1140 INPUT.
*PERFORM user_command_1140.
  LEAVE SCREEN.
ENDMODULE.                    "USER_COMMAND_1140 INPUT
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_1138  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_1138 INPUT.
  g_savecode = g_okcode.
  CLEAR : g_okcode.
  CASE sy-ucomm.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'CANCEL' or 'ABBR'.
      LEAVE TO SCREEN 0.
    WHEN 'ENDE'.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT'.
*      LEAVE TO SCREEN 0.
      EXIT.
    WHEN OTHERS.

      CALL METHOD go_list_view->update_display
        EXPORTING
          i_okcode = g_savecode.
  ENDCASE.
ENDMODULE.                    "USER_COMMAND_1138 INPUT
*&---------------------------------------------------------------------*
*&      Module  STATUS_1138  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_1138 OUTPUT.

*  IF g_flg_display_mode IS INITIAL.
*    SET TITLEBAR '1138' WITH text-005.
*  ELSE.
*    SET TITLEBAR '1138' WITH text-006.
*  ENDIF.
  SET PF-STATUS 'STAT2'.
ENDMODULE.                    "STATUS_1138 OUTPUT
*&---------------------------------------------------------------------*
*&      Form  INITIALIZATION_1138
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM initialization_1138 .
  CLEAR : g_okcode, g_savecode.

  IF go_docking_container IS INITIAL.
    PERFORM creating_docking_container.

    CALL METHOD go_list_view->initialize
      EXPORTING
        i_rcl_model     = g_rcl_office_model
        i_rcl_container = go_docking_container.
    IF sy-subrc <> 0.
      MESSAGE x208(00) WITH 'g_rcl_office_view->initialize'. "#EC NOTEXT
    ENDIF.

    CALL METHOD go_list_view->display.

  ENDIF.
ENDFORM.                    "INITIALIZATION_1138
*&---------------------------------------------------------------------*
*&      Form  CREATING_DOCKING_CONTAINER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM creating_docking_container .
  DATA : lv_repid TYPE sy-repid,
         lv_dynnr TYPE sy-dynnr.

  lv_repid = sy-repid.
  lv_dynnr = sy-dynnr.

  CREATE OBJECT go_docking_container
    EXPORTING
*     PARENT                      =
      repid                       = lv_repid
      dynnr                       = lv_dynnr
      side                        = cl_gui_docking_container=>dock_at_left
*      extension                   = l_cols_pix
      extension                   = 10000
*     STYLE                       =
*     LIFETIME                    = lifetime_default
*     CAPTION                     =
      metric                      = cl_gui_docking_container=>metric_pixel
*     RATIO                       =
*     NO_AUTODEF_PROGID_DYNNR     =
*     NAME                        =
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      lifetime_dynpro_dynpro_link = 5
      OTHERS                      = 6.

  IF sy-subrc <> 0.
    MESSAGE x208(00) WITH 'CREATE OBJECT G_RCL_DOCKING_CONTAINER'.
  ENDIF.
ENDFORM.                    "CREATING_DOCKING_CONTAINER
*&---------------------------------------------------------------------*
*&      Form  DETERMINE_SEARCHHELP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0013   text
*----------------------------------------------------------------------*
FORM determine_searchhelp    USING u_selname TYPE any.
  CASE u_selname.
    WHEN 's_sel3-low'.
      PERFORM f4_business_proc USING 'S_SEL3-LOW'.

    WHEN 's_sel3-high'.
      PERFORM f4_business_proc USING 'S_SEL3-HIGH'.

    WHEN OTHERS.
  ENDCASE.
ENDFORM.                    "DETERMINE_SEARCHHELP
*&---------------------------------------------------------------------*
*&      Form  F4_BUSINESS_PROC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0175   text
*----------------------------------------------------------------------*
FORM f4_business_proc  USING u_selname TYPE any.
  TYPES:
      BEGIN OF l_ty_bproc_t,
        component TYPE  /sappo/dte_component,
        business_process  TYPE  /sappo/dte_business_process,
        description TYPE  /sappo/dte_business_proc_desc,
      END OF l_ty_bproc_t.


  DATA: l_tab_sel_options TYPE TABLE OF rsparams,
        l_tas_component      TYPE /sappo/tas_c_cmpnt_t,     "#EC NEEDED
        l_rng_component TYPE /sappo/rng_component,
        l_tas_bproc_t TYPE /sappo/tas_c_bproc_t,
        l_tab_bproc_t TYPE TABLE OF l_ty_bproc_t,
        l_tab_return         TYPE TABLE OF ddshretval.

  FIELD-SYMBOLS: <sel_option> LIKE LINE OF l_tab_sel_options,
                 <rng_component> LIKE LINE OF l_rng_component,
                 <bproc_with_client> LIKE LINE OF l_tas_bproc_t,
                 <bproc_f4> LIKE LINE OF l_tab_bproc_t.

* get field values from screen (after PAI only)
  CALL FUNCTION 'RS_REFRESH_FROM_SELECTOPTIONS'
    EXPORTING
      curr_report     = sy-repid
    TABLES
      selection_table = l_tab_sel_options[]
    EXCEPTIONS
      not_found       = 1
      no_report       = 2
      OTHERS          = 3.
  IF sy-subrc <> 0.
    EXIT.
  ENDIF.

* get components
  LOOP AT l_tab_sel_options ASSIGNING <sel_option>
    WHERE selname = 'S_SEL1' AND NOT sign IS INITIAL.
    APPEND INITIAL LINE TO l_rng_component ASSIGNING <rng_component>.
    MOVE-CORRESPONDING <sel_option> TO <rng_component>.
  ENDLOOP.

* get components in system
  CALL FUNCTION '/SAPPO/DB_CMPNT_GET'
    EXPORTING
      i_language       = sy-langu
      i_refresh_buffer = ' '
    IMPORTING
      e_tas_cmpnt_t    = l_tas_component.

  CALL FUNCTION '/SAPPO/API_BPROC_GET'
    EXPORTING
      i_language    = sy-langu
    IMPORTING
      e_tas_bproc_t = l_tas_bproc_t.

  LOOP AT l_tas_bproc_t ASSIGNING <bproc_with_client>
    WHERE component IN l_rng_component.                 "#EC CI_SORTSEQ
    APPEND INITIAL LINE TO l_tab_bproc_t ASSIGNING <bproc_f4>.
    MOVE-CORRESPONDING <bproc_with_client> TO <bproc_f4>.
  ENDLOOP.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'BUSINESS_PROCESS'
      dynpprog        = '/SAPPO/SAPLAPI_DIALOG_START'
      dynpnr          = '0207'
      dynprofield     = u_selname
      value_org       = 'S'
    TABLES
      value_tab       = l_tab_bproc_t
      return_tab      = l_tab_return
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.

  IF sy-subrc <> 0.
    EXIT.
  ENDIF.
ENDFORM.                    "F4_BUSINESS_PROC
*&---------------------------------------------------------------------*
*&      Form  GET_SELECTOPTIONS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_G_TAB_FIELDRANGE  text
*----------------------------------------------------------------------*
FORM get_selectoptions  CHANGING c_tab_fieldrange TYPE /sappo/tab_filter_fieldrange.
  DATA: l_tab_sel_options TYPE TABLE OF rsparams,
          l_str_sel_options TYPE rsparams,
          l_str_reftab      TYPE lvc_s_fcat.

  DATA: l_str_fieldrange TYPE /sappo/str_filter_fieldrange,
        l_str_range      TYPE /sappo/str_rsdsselopt.

  DATA: l_repid LIKE sy-repid,
        l_tabix TYPE sytabix.

  DATA: l_string(10) TYPE c.
  DATA: selname(20) TYPE c.
  FIELD-SYMBOLS: <f1> TYPE ANY.

  CLEAR: c_tab_fieldrange.

*  G_TAB_FIELDRANGE[]-BUSINESS_PROCESS-RANGE[]-LOW-BP-LOW.
*  G_TAB_FIELDRANGE-BUSINESS_PROCESS-RANGE-HIGH-BP-HIGH.
*  G_TAB_FIELDRANGE-RANGE-LOW-BP-LOW.
*  G_TAB_FIELDRANGE-RANGE-HIGH-BP-HIGH.


ENDFORM.                    "GET_SELECTOPTIONS
*&---------------------------------------------------------------------*
*&      Form  FINALIZE_MODEL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM finalize_model .
  CALL METHOD go_list_view->finalize.

  CALL METHOD g_rcl_office_model->finalize.

  IF NOT go_docking_container IS INITIAL.
    CALL METHOD go_docking_container->free
      EXCEPTIONS
        cntl_error        = 1
        cntl_system_error = 2
        OTHERS            = 3.
  ENDIF.
ENDFORM.                    "FINALIZE_MODEL
*&---------------------------------------------------------------------*
*&      Form  INITIALIZE_MODEL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM initialize_model .
  DATA: l_filter_mode TYPE c.

  CLEAR : go_docking_container,
          go_list_view.

  FREE: go_docking_container.

  IF gv_authority = 'ALL'.
    l_filter_mode = '2'.
  ELSEIF gv_authority = 'OWN'.
    l_filter_mode = '1'.
  ELSE.
    l_filter_mode = '0'.
  ENDIF.

  CREATE OBJECT g_rcl_office_model
    EXPORTING
      i_component    = gv_component
      i_display_mode = g_flg_display_mode
      i_filter_mode  = l_filter_mode.

  CALL METHOD /sappo/cl_list_view_factory=>get_view
    EXPORTING
      i_component     = gv_component
    CHANGING
      c_rcl_list_view = go_list_view.
ENDFORM.                    "INITIALIZE_MODEL
*&---------------------------------------------------------------------*
*&      Form  SET_SELECTOPTIONS_FOR_MODEL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_G_TAB_FIELDRANGE  text
*      <--P_L_FLG_NODATA  text
*----------------------------------------------------------------------*
FORM set_selectoptions_for_model USING    u_tab_fieldrange  TYPE /sappo/tab_filter_fieldrange
                                          bp-low
                                          bp-high
                                          cd-low
                                          cd-high
                                 CHANGING c_flg_nodata      TYPE xfeld.

  DATA: l_str_fieldrange TYPE /sappo/str_filter_fieldrange,
        l_str_range TYPE /sappo/str_rsdsselopt,
       l_tab_order_key         TYPE /sappo/tab_order_key,
        l_rng_component         TYPE /sappo/rng_component,
        l_str_component         LIKE LINE OF l_rng_component,
        l_rng_logsys            TYPE /sappo/rng_order_logsys,
        l_str_logsys            LIKE LINE OF l_rng_component,
        l_rng_business_proc     TYPE /sappo/rng_business_process,
        l_str_business_proc     LIKE LINE OF l_rng_business_proc,
        l_rng_business_proc_id  TYPE /sappo/rng_business_proc_id,
        l_str_business_proc_id  LIKE LINE OF l_rng_business_proc_id,
        l_str_msg_key           TYPE /sappo/str_message_key,
        l_rng_status            TYPE /sappo/rng_status,
        l_str_status            LIKE LINE OF l_rng_status,
        l_tab_processor         TYPE /sappo/tab_processor,
        l_str_processor         LIKE LINE OF l_tab_processor,
        l_rng_postdate          TYPE /sappo/rng_postdate,
        l_str_postdate          LIKE LINE OF l_rng_postdate,
        l_rng_creationdate      TYPE /sappo/rng_creationdate,
        l_str_creationdate      LIKE LINE OF l_rng_creationdate,
        l_rng_procmeth          TYPE /sappo/rng_procmeth,
        l_str_procmeth          LIKE LINE OF l_rng_procmeth ,
        l_rng_priority          TYPE /sappo/rng_priority,
        l_str_priority          LIKE LINE OF l_rng_priority,
        l_tab_worklist          TYPE /sappo/tab_worklist,
        l_tab_hash_1            TYPE /sappo/tab_hash_1,
        l_tab_hash_2            TYPE /sappo/tab_hash_2,
        l_rng_fa_amnt           TYPE /sappo/rng_fa_amnt,
        l_str_fa_amnt           LIKE LINE OF l_rng_fa_amnt,
        l_fa_curr               TYPE /sappo/dte_fa_curr,
        l_rng_fa1               TYPE /sappo/rng_fa1,
        l_str_fa1               LIKE LINE OF l_rng_fa1,
        l_rng_fa2               TYPE /sappo/rng_fa1,
        l_str_fa2               LIKE LINE OF l_rng_fa2,
        l_rng_fa3               TYPE /sappo/rng_fa1,
        l_str_fa3               LIKE LINE OF l_rng_fa3,
        l_rng_fa4               TYPE /sappo/rng_fa1,
        l_str_fa4               LIKE LINE OF l_rng_fa4,
        l_rng_fa5               TYPE /sappo/rng_fa1,
        l_str_fa5               LIKE LINE OF l_rng_fa5,
        l_rng_fa6               TYPE /sappo/rng_fa1,
        l_str_fa6               LIKE LINE OF l_rng_fa6,
        l_role                  TYPE /sappo/dte_object_role,
        l_str_object            TYPE /sappo/str_object,
        l_date_low              TYPE dats,
        l_date_high             TYPE dats,
        l_time_low              TYPE tims,
        l_time_high             TYPE tims,
        l_timst_low             TYPE timestamp,
        l_timst_high            TYPE timestamp,
        l_auth_actvt            TYPE activ_auth,
        l_auth_check            TYPE /sappo/dte_auth_check,
*       Earliest Manual Time and date conversion to timestamp
        l_date_em_low              TYPE dats,
        l_date_em_high             TYPE dats,
        l_time_em_low              TYPE tims,
        l_time_em_high             TYPE tims,
        l_timst_em_low             TYPE timestamp,
        l_timst_em_high            TYPE timestamp,
*       Earliest Retry Time and date conversion to timestamp
        l_date_rt_low              TYPE dats,
        l_date_rt_high             TYPE dats,
        l_time_rt_low              TYPE tims,
        l_time_rt_high             TYPE tims,
        l_timst_rt_low             TYPE timestamp,
        l_timst_rt_high            TYPE timestamp,
*       Earliest Completion Time and date conversion to timestamp
        l_date_cp_low              TYPE dats,
        l_date_cp_high             TYPE dats,
        l_time_cp_low              TYPE tims,
        l_time_cp_high             TYPE tims,
        l_timst_cp_low             TYPE timestamp,
        l_timst_cp_high            TYPE timestamp,
        l_rng_timestamp         TYPE /sappo/rng_tstamp,
        l_str_timestamp         LIKE LINE OF l_rng_timestamp,
        l_rng_msgty             TYPE symsgty,
*        l_str_msgty             LIKE LINE OF l_rng_msgty,
        l_str_message_key       TYPE /sappo/str_message_key,
        lv_max_count            TYPE i,
        l_subrc                 TYPE sysubrc,
        l_worklist_mode         TYPE /sappo/dte_worklist_mode,

        l_str_closing_type      TYPE /sappo/str_closing_type_rng,
        l_rng_closing_type      TYPE /sappo/rng_closing_type,
        l_str_error_category    TYPE /sappo/str_error_category_rng,
        l_rng_error_category    TYPE /sappo/rng_error_category,
        l_str_retry_class       TYPE /sappo/str_retry_class_rng,
        l_rng_retry_class       TYPE /sappo/rng_retry_class,
        l_str_fail_class        TYPE /sappo/str_fail_class_rng,
        l_rng_fail_class        TYPE /sappo/rng_fail_class,
        l_str_finish_class      TYPE /sappo/str_finish_class_rng,
        l_rng_finish_class      TYPE /sappo/rng_finish_class,
        l_str_retry_mode        TYPE /sappo/str_retry_mode_rng,
        l_rng_retry_mode        TYPE /sappo/rng_retry_mode,
        l_str_fail_mode         TYPE /sappo/str_fail_mode_rng,
        l_rng_fail_mode         TYPE /sappo/rng_fail_mode,
        l_str_retry_group       TYPE /sappo/str_retry_group_rng,
        l_rng_retry_group       TYPE /sappo/rng_retry_group,
        l_str_earliest_cmpltn   TYPE /sappo/str_earliest_cmpltn_rng,
        l_rng_earliest_cmpltn   TYPE /sappo/rng_earliest_cmpltn,
        l_str_earliest_manual   TYPE /sappo/str_earliest_manual_rng,
        l_rng_earliest_manual   TYPE /sappo/rng_earliest_manual,
        l_str_earliest_retry    TYPE /sappo/str_earliest_retry_rng,
        l_rng_earliest_retry    TYPE /sappo/rng_earliest_retry,
        l_str_processor_rng     TYPE /sappo/str_processor_rng,
        l_rng_processor         TYPE /sappo/rng_processor.


  DATA l_answer TYPE c.

  DATA: l_flg_more_data      TYPE /sappo/dte_more_data,
        l_flg_not_authorized TYPE abap_bool.

  DATA:  l_objkey            TYPE /sappo/dte_objkey.
  DATA: l_str_rsd            TYPE /sappo/str_rsdsselopt.
*  DATA: l_str_rsd_bp         TYPE /SAPPO/STR_RSDSSELOPT.
*  DATA: l_str_rsd_cd          TYPE /SAPPO/STR_RSDSSELOPT.

  CLEAR: c_flg_nodata.

  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      percentage = 10
      text       = 'Verarbeite Selektionskriterien'(011).

* worklist selection
  l_worklist_mode = g_worklist_mode.

  IF bp-low NE '' AND bp-high NE ''.
    l_str_fieldrange-fieldname = 'BUSINESS_PROCESS'.
*   l_str_fieldrange-range-/SAPPO/TAB_RSELOPTION-/SAPPO/STR_RSDSSELOPT-SIGN = 'I'.
*   l_str_fieldrange-range-/SAPPO/TAB_RSELOPTION-OPTION = 'BT'.
*   l_str_fieldrange-range-/SAPPO/TAB_RSELOPTION-LOW = 'BP-LOW'.
*   l_str_fieldrange-range-/SAPPO/TAB_RSELOPTION-HIGH = 'BP-HIGH'.
    l_str_rsd-sign = 'I'.
    l_str_rsd-option = 'BT'.
    l_str_rsd-low = bp-low.
    l_str_rsd-high = bp-high.
  ENDIF.

  IF bp-low NE '' AND bp-high EQ ''.
    l_str_fieldrange-fieldname = 'BUSINESS_PROCESS'.
*   l_str_fieldrange-range-/SAPPO/TAB_RSELOPTION-/SAPPO/STR_RSDSSELOPT-SIGN = 'I'.
*   l_str_fieldrange-range-/SAPPO/TAB_RSELOPTION-OPTION = 'BT'.
*   l_str_fieldrange-range-/SAPPO/TAB_RSELOPTION-LOW = 'BP-LOW'.
*   l_str_fieldrange-range-/SAPPO/TAB_RSELOPTION-HIGH = 'BP-HIGH'.
    l_str_rsd-sign = 'I'.
    l_str_rsd-option = 'EQ'.
    l_str_rsd-low = bp-low.
    l_str_rsd-high = bp-high.
  ENDIF.

  IF bp-low EQ '' AND bp-high NE ''.
    l_str_fieldrange-fieldname = 'BUSINESS_PROCESS'.
*   l_str_fieldrange-range-/SAPPO/TAB_RSELOPTION-/SAPPO/STR_RSDSSELOPT-SIGN = 'I'.
*   l_str_fieldrange-range-/SAPPO/TAB_RSELOPTION-OPTION = 'BT'.
*   l_str_fieldrange-range-/SAPPO/TAB_RSELOPTION-LOW = 'BP-LOW'.
*   l_str_fieldrange-range-/SAPPO/TAB_RSELOPTION-HIGH = 'BP-HIGH'.
    l_str_rsd-sign = 'I'.
    l_str_rsd-option = 'EQ'.
    l_str_rsd-low = bp-low.
    l_str_rsd-high = bp-high.
  ENDIF.

  CASE l_str_fieldrange-fieldname.
    WHEN 'BUSINESS_PROCESS'.
      MOVE-CORRESPONDING l_str_rsd TO l_str_business_proc.
*     APPEND l_str_rsd TO l_rng_business_proc.
      APPEND l_str_business_proc TO l_rng_business_proc.
    WHEN OTHERS.
  ENDCASE.
  IF cd-low EQ '00000000'.
    cd-low = ''.
  ENDIF.

  IF cd-high EQ '00000000'.
    cd-high = ''.
  ENDIF.

  IF cd-low EQ '' AND cd-high EQ ''.
    l_str_fieldrange-fieldname = 'CREATIONDATE'.
    l_str_rsd-sign = ''.
    l_str_rsd-option = ''.
    l_str_rsd-low = cd-low.
    l_str_rsd-high = cd-high.
  ENDIF.

  IF cd-low NE '' AND cd-high NE ''.
    l_str_fieldrange-fieldname = 'CREATIONDATE'.
    l_str_rsd-sign = 'I'.
    l_str_rsd-option = 'BT'.
    l_str_rsd-low = cd-low.
    l_str_rsd-high = cd-high.
  ENDIF.

  IF cd-low NE '' .
*     and CD-HIGH eq '00000000'.
    l_str_fieldrange-fieldname = 'CREATIONDATE'.
    l_str_rsd-sign = 'I'.
    l_str_rsd-option = 'EQ'.
    l_str_rsd-low = cd-low.
*   l_str_rsd-HIGH = ''.
  ENDIF.

*   if CD-LOW eq '00000000' and
  IF  cd-high NE ''.
    l_str_fieldrange-fieldname = 'CREATIONDATE'.
    l_str_rsd-sign = 'I'.
    l_str_rsd-option = 'EQ'.
*   l_str_rsd-LOW = ''.
    l_str_rsd-high = cd-high.
  ENDIF.

*   if CD-LOW eq '00000000' and CD-HIGH eq '00000000'.
*   l_str_fieldrange-fieldname = 'CREATIONDATE'.
*   l_str_rsd-SIGN = ''.
*   l_str_rsd-OPTION = ''.
*   l_str_rsd-LOW = ''.
*   l_str_rsd-HIGH = ''.
*  endif.

  CASE l_str_fieldrange-fieldname.
    WHEN 'CREATIONDATE'.
      MOVE-CORRESPONDING l_str_rsd TO  l_str_creationdate.
      APPEND  l_str_creationdate TO l_rng_creationdate.
    WHEN OTHERS.
  ENDCASE.
  IF l_str_creationdate-low EQ '' AND l_str_creationdate-high EQ ''.
    REFRESH l_rng_creationdate.
*    APPEND  l_str_creationdate TO l_rng_creationdate.
  ENDIF.

  l_str_fieldrange-fieldname = 'PROCMETH'.
  l_str_rsd-sign = 'I'.
  l_str_rsd-option = 'BT'.
  l_str_rsd-low = 2.
  l_str_rsd-high = 3.

  CASE l_str_fieldrange-fieldname.
    WHEN 'PROCMETH'.
      MOVE-CORRESPONDING l_str_rsd TO  l_str_procmeth.
      APPEND  l_str_procmeth TO l_rng_procmeth.
    WHEN OTHERS.
  ENDCASE.


  l_str_fieldrange-fieldname = 'STATUS'.
  l_str_rsd-sign = 'I'.
  l_str_rsd-option = 'BT'.
  l_str_rsd-low = '1'.
  l_str_rsd-high = '2'.

  CASE l_str_fieldrange-fieldname.
    WHEN 'STATUS'.
      MOVE-CORRESPONDING l_str_rsd TO  l_str_status.
      APPEND  l_str_status TO l_rng_status.
    WHEN OTHERS.
  ENDCASE.

  l_str_fieldrange-fieldname = 'COMPONENT'.
  l_str_rsd-sign = 'I'.
  l_str_rsd-option = 'EQ'.
  l_str_rsd-low = 'AP-MD'.
  l_str_rsd-high = ''.

  CASE l_str_fieldrange-fieldname.
    WHEN 'COMPONENT'.
      MOVE-CORRESPONDING l_str_rsd TO  l_str_component.
      APPEND  l_str_component TO l_rng_component.
    WHEN OTHERS.
  ENDCASE.

  IF ( l_str_message_key-msgid IS INITIAL )
    AND ( NOT l_str_message_key-msgno IS INITIAL ).

    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        titlebar              = ' '
        text_question         = text-007
        text_button_1         = text-008
        icon_button_1         = 'ICON_CHECKED'
        text_button_2         = text-009
        icon_button_2         = 'ICON_INCOMPLETE'
        default_button        = '1'
        display_cancel_button = ' '
        popup_type            = 'ICON_MESSAGE_WARNING'
      IMPORTING
        answer                = l_answer
      EXCEPTIONS
        text_not_found        = 1
        OTHERS                = 2.

    IF sy-subrc = 0.

      IF l_answer = '1'.
*       go on - clear message structure
        CLEAR: l_str_message_key.
      ELSE.
*       go back to selection screen
        c_flg_nodata = 'X'.
        EXIT.
      ENDIF.
    ENDIF.

  ENDIF.





  CLEAR : l_str_earliest_cmpltn.

  lv_max_count = gv_max_count.

  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      percentage = 50
      text       = 'Selektiere Daten'(012).

  l_worklist_mode = 2.
  lv_max_count = 0.
  l_auth_actvt = 03.
  l_auth_check = 1.


  CALL METHOD g_rcl_office_model->select_by_select_options
    EXPORTING
*    I_TAB_ORDER_KEY        =
      i_rng_component        = l_rng_component
      i_rng_business_proc    = l_rng_business_proc
      i_rng_business_proc_id = l_rng_business_proc_id
*      i_rng_msgty            = l_rng_msgty
      i_str_msg_key          = l_str_message_key
      i_tab_rng_status       = l_rng_status
      i_tab_processor        = l_tab_processor
      i_rng_processor        = l_rng_processor
      i_rng_postdate         = l_rng_postdate
      i_rng_creationdate     = l_rng_creationdate
      i_rng_procmeth         = l_rng_procmeth
      i_rng_priority         = l_rng_priority
*    I_TAB_WORKLIST         =
*    I_TAB_HASH_1           =
*    I_TAB_HASH_2           =
      i_tab_rng_order_logsys = l_rng_logsys
      i_rng_fa_amnt          = l_rng_fa_amnt
      i_fa_curr              = l_fa_curr
      i_rng_fa1              = l_rng_fa1
      i_rng_fa2              = l_rng_fa2
      i_rng_fa3              = l_rng_fa3
      i_rng_fa4              = l_rng_fa4
      i_rng_fa5              = l_rng_fa5
      i_rng_fa6              = l_rng_fa6
      i_rng_tstamp_create    = l_rng_timestamp
      i_worklist_mode        = l_worklist_mode
*     i_user                 = l_user
      i_role                 = l_role
      i_object               = l_str_object
*     I_STR_ORDER_KEY        =
      i_rng_closing_type     = l_rng_closing_type
      i_rng_error_category   = l_rng_error_category
      i_rng_retry_class      = l_rng_retry_class
      i_rng_fail_class       = l_rng_fail_class
      i_rng_finish_class     = l_rng_finish_class
      i_rng_retry_mode       = l_rng_retry_mode
      i_rng_fail_mode        = l_rng_fail_mode
      i_rng_retry_group      = l_rng_retry_group
      i_rng_earliest_cmpltn  = l_rng_earliest_cmpltn
      i_rng_earliest_manual  = l_rng_earliest_manual
      i_rng_earliest_retry   = l_rng_earliest_retry
*      i_auth_check           = l_auth_check
*      i_auth_actvt           = l_auth_actvt
      i_maxcount             = lv_max_count
*     I_FLG_NO_EXPORT        =
   IMPORTING
      e_flg_more_data = l_flg_more_data
*     E_FLG_NO_OTHERS
      e_flg_not_authorized = l_flg_not_authorized
      e_flg_nothing_selected = c_flg_nodata
   EXCEPTIONS
     invalid_input          = 1
     OTHERS                 = 2
          .
  IF sy-subrc = 0.

    CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
      EXPORTING
        percentage = 100
        text       = 'Selektion beendet'(013).

    IF NOT c_flg_nodata IS INITIAL.
      IF NOT l_flg_not_authorized IS INITIAL.
        MESSAGE s412(/sappo/msg).
*       Die Selektion lieferte nur Datensätze ohne Anzeigeberechtigung
      ELSE.
        MESSAGE s315(/sappo/msg).
*       Es entsprechen keine Datensätze den Selektionskriterien
      ENDIF.
      EXIT.
    ENDIF.

    IF NOT l_flg_more_data IS INITIAL.
      IF NOT l_flg_not_authorized IS INITIAL.
        MESSAGE s318(/sappo/msg).
*       Es konnten nicht alle Datensätze angezeigt werden
      ELSE.
        MESSAGE s316(/sappo/msg).
*       Es gibt weitere Daten zu diesen Selektionskriterien
      ENDIF.
    ELSE.
      IF NOT l_flg_not_authorized IS INITIAL.
        MESSAGE s317(/sappo/msg).
*       Für mindestens einen Auftrag fehlt die Berechtigung
      ENDIF.
    ENDIF.
  ELSE.
    c_flg_nodata = abap_true.
    MESSAGE i309(/sappo/msg).
  ENDIF.

ENDFORM.                    "set_selectoptions_for_model
*&---------------------------------------------------------------------*
*&      Form  INITIALIZATION_1140
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM initialization_1140 .
** only first run
*  IF g_flg_init IS INITIAL.
*
**   get component from transaction code
*    PERFORM get_component CHANGING gv_component.
*
**   get details for component
*    PERFORM get_component_detail CHANGING g_flg_display_mode
*                                          gv_cust_def_count
*                                          gv_cust_max_count.
**   check if user has authority for transaction
*    PERFORM check_authority_for_component USING gv_component
*                                                g_flg_display_mode.
**   get logical systems for component
*    PERFORM check_display_logsys USING gv_component
*                                 CHANGING g_flg_logsys.
*
**   get logical object systems for component
*    PERFORM check_display_objlogsys USING gv_component
*                                    CHANGING g_flg_objlogsys.
*
**   get filter authority setting for user
*    PERFORM check_authority_for_filter USING gv_component
*                                       CHANGING gv_authority.
*
*    PERFORM check_display_fa_fields USING gv_component.
*
*    IF gv_authority = 'ALL'.
**     global and user specific filters
*      g_flg_user_specific = space.
*    ELSEIF gv_authority = 'OWN'.
**     only user specific filters
*      g_flg_user_specific = 'X'.
*    ENDIF.
*
**   create default key settings for filter
*    CONCATENATE '1' gv_component INTO g_str_key-report.
*    g_str_key-tabname  = '/SAPPO/STR_DIALOG_SELECT'.
*    g_str_key-username = sy-uname.
*
*    gv_max_count = gv_cust_def_count.
*
**   create reference table for output arangement
*    PERFORM create_default USING g_str_key-tabname
*                           CHANGING g_tab_reftab.
*
**   get restrictions for output
*    PERFORM get_restrictions USING g_str_key-tabname
*                             CHANGING g_tab_restriction.
*
**   search for default filter
*    CALL FUNCTION '/SAPPO/API_FILTER_SELECT_DEF'
*      EXPORTING
*        i_report      = g_str_key-report
*        i_tabname     = g_str_key-tabname
*        i_username    = g_str_key-username
*      IMPORTING
*        e_variantname = g_str_key-variantname.
*
*    IF g_str_key-variantname IS INITIAL.
*
**     no default found - create default
*      PERFORM create_default USING g_str_key-tabname
*                             CHANGING g_tab_outtab.
*
**     fill default entries
*      PERFORM fill_default.
*
*    ELSE.
*      IF g_str_key-variantname+0(1) CA '/'.
*        CLEAR g_str_key-username.
*      ELSE.
*        g_str_key-username = sy-uname.
*      ENDIF.
*
*      PERFORM select_variant USING g_str_key
*                                   g_tab_restriction
*                             CHANGING g_tab_outtab
*                                      g_tab_fieldrange.
*
*    ENDIF.
*
*    PERFORM update_selectoptions USING g_str_key
*                                       g_tab_outtab
*                                       g_tab_fieldrange.
*
*    g_flg_init = 'X'.
*  ENDIF.
ENDFORM.                    "INITIALIZATION_1140

*&---------------------------------------------------------------------*
*&      Module  1140  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE 1140 OUTPUT.
*CALL SCREEN 1140.
ENDMODULE.                    "1140 OUTPUT
*&---------------------------------------------------------------------*
*&      Form  USER_COMMAND_1140
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_BP_LOW  text
*      -->P_BP_HIGH  text
*      -->P_CD_LOW  text
*      -->P_CD_HIGH  text
*----------------------------------------------------------------------*
FORM user_command_1140  USING    bp-low
                                 bp-high
                                 cd-low
                                 cd-high.
  DATA: l_action          TYPE syucomm,
         l_tab_replacement TYPE /sappo/tab_replacement,
         l_tab_dfies       TYPE ddfields,
         l_tab_fcat        TYPE lvc_t_fcat,
         l_flg_nodata      TYPE xfeld.

  DATA: l_str_outtab       TYPE lvc_s_fcat,
        l_tab_fields       TYPE /sappo/tab_filter_fields,
        l_tab_fields_new   TYPE /sappo/tab_filter_fields,
        l_str_fields       TYPE /sappo/str_filter_fields,
        l_str_callback     TYPE /sappo/str_callback.

  DATA: l_str_order_key TYPE /sappo/str_order_key.

  DATA: l_detail_function  TYPE /sappo/dte_detail_function,
        l_funcname         TYPE funcname.

  CASE sy-ucomm .

    WHEN 'CANCEL'.

*      CLEAR g_okcode .
*      SET SCREEN 0.
      LEAVE TO SCREEN 0.

    WHEN 'ENTER'.

*      CLEAR g_okcode .

*     get selection values
*      PERFORM get_selectoptions CHANGING g_tab_fieldrange.

*     initialize model for list view
      PERFORM initialize_model.

*     initialize Flag MV_POP_UP_ACTIVE
*      call method /sappo/cl_order_log=>init_pop_up_cancelled.

*     selct data from db according to selection values

      PERFORM set_selectoptions_for_model USING g_tab_fieldrange
                                                bp-low
                                                bp-high
                                                cd-low
                                                cd-high
                                       CHANGING l_flg_nodata.

      IF l_flg_nodata IS INITIAL .
*        and
*        /sappo/cl_order_log=>get_pop_up_cancelled( ) IS INITIAL.
*       call list view
        CALL SCREEN 1138.

*       free model
        PERFORM finalize_model.
      ELSE.
        CALL METHOD g_rcl_office_model->finalize.
      ENDIF.
    WHEN OTHERS.
  ENDCASE.



ENDFORM.                    " USER_COMMAND_1140
*&---------------------------------------------------------------------*
*&      Module  EXECUTE_BP_DATE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE execute_bp_date INPUT.
  PERFORM user_command_1140  USING bp-low
                                   bp-high
                                   cd-low
                                   cd-high.
ENDMODULE.                 " EXECUTE_BP_DATE  INPUT
