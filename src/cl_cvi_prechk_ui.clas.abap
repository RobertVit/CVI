class CL_CVI_PRECHK_UI definition
  public
  final
  create public .

public section.

  data REF_LOG_ALV type ref to CL_GUI_ALV_GRID .
  data REF_RESULT_ALV type ref to CL_GUI_ALV_GRID .
  constants LOG_CONTAINER_NAME type CHAR30 value 'CONT_LOG' ##NO_TEXT.
  constants RES_CONTAINER_NAME type CHAR30 value 'CONT_RES' ##NO_TEXT.

  methods GET_AND_DISP_LOG_ALV
    importing
      !IM_FILTER type IF_CVI_PRECHK=>TY_LOG_GEN_SELECTION
    exceptions
      NO_RECORD_FOUND
      ALV_ERROR .
  methods GET_AND_DISP_RES_ALV
    exceptions
      ALV_ERROR
      NO_RECORD_FOUND .
  methods VALIDATE_SELECTION_IP
    importing
      !IM_SELECTION_DATA type IF_CVI_PRECHK=>TY_GENERAL_SELECTION
      !IM_SCENARIO type IF_CVI_PRECHK=>TY_SCENARIO_SELECTION
    exporting
      !EX_BAPIRET type BAPIRET2 .
  methods EXECUTE_CHECKS
    importing
      !IM_GEN_SELECTION type IF_CVI_PRECHK=>TY_GENERAL_SELECTION
      !IM_SCENARIO type IF_CVI_PRECHK=>TY_SCENARIO_SELECTION
    exporting
      !EX_RETURN type BAPIRET2 .
protected section.
private section.

  data REF_LOG_ALV_CONT type ref to CL_GUI_CUSTOM_CONTAINER .
  data REF_RESULT_ALV_CONT type ref to CL_GUI_CUSTOM_CONTAINER .
  data LOG_ALV_DATA type IF_CVI_PRECHK=>TT_ALV_LOG_TAB .
  data RES_ALV_DATA type IF_CVI_PRECHK=>TT_ALV_RESULT_TAB_OUT .
  data RES_ALV_HEADER_DOC type ref to CL_DD_DOCUMENT .
  data RES_ALV_CONTAINER_HEAD type ref to CL_GUI_CONTAINER .
  data RES_ALV_CONTAINER_BODY type ref to CL_GUI_CONTAINER .
  data RES_ALV_SPLITTER type ref to CL_GUI_SPLITTER_CONTAINER .
  data SELECTED_LOG_ALV_DATA type IF_CVI_PRECHK=>TY_ALV_LOG_TAB .

  methods DISPLAY_LOG_ALV
    importing
      !IM_DATA type IF_CVI_PRECHK=>TT_ALV_LOG_TAB
    exceptions
      ALV_ERROR .
  methods PREPARE_LOG_ALV_FCAT
    exporting
      !EX_FCAT type LVC_T_FCAT .
  methods HANDLE_LOG_ALV_TOOLBAR
    for event TOOLBAR of CL_GUI_ALV_GRID
    importing
      !E_OBJECT .
  methods HANDLE_LOG_ALV_USERCOMMAND
    for event USER_COMMAND of CL_GUI_ALV_GRID
    importing
      !E_UCOMM .
  methods HANDLE_LOG_DOUBLECLICK
    for event DOUBLE_CLICK of CL_GUI_ALV_GRID
    importing
      !E_ROW
      !E_COLUMN .
  methods DISPLAY_RESULT_ALV
    importing
      !IM_DATA type IF_CVI_PRECHK=>TT_ALV_RESULT_TAB
    exceptions
      NO_RECORD_FOUND
      ALV_ERROR .
  methods PREPARE_RESULT_FCAT
    exporting
      !EX_FCAT type LVC_T_FCAT
    exceptions
      ALV_ERROR .
  methods REFRESH_ALV
    exceptions
      ALV_ERROR .
  methods HANDLE_RES_ALV_TOP_OF_PAGE
    for event TOP_OF_PAGE of CL_GUI_ALV_GRID
    importing
      !E_DYNDOC_ID .
  methods CONVERT_RESULT_ALV_TAB
    importing
      !IT_DATA type IF_CVI_PRECHK=>TT_ALV_RESULT_TAB
    exporting
      !ET_DATA type IF_CVI_PRECHK=>TT_ALV_RESULT_TAB_OUT .
  methods HANDLE_HOTSPOT_CLICK
    for event HOTSPOT_CLICK of CL_GUI_ALV_GRID
    importing
      !E_ROW_ID
      !E_COLUMN_ID
      !ES_ROW_NO .
ENDCLASS.



CLASS CL_CVI_PRECHK_UI IMPLEMENTATION.


  METHOD convert_result_alv_tab.
    DATA: ls_data_out LIKE LINE OF et_data.
    DATA: lv_domvalue TYPE dd07v-domvalue_l.
    DATA: lv_ddtext   TYPE dd07v-ddtext.
    DATA: lv_counter  TYPE i VALUE 0.

    LOOP AT it_data ASSIGNING FIELD-SYMBOL(<ls_data>).
      lv_counter = lv_counter + 1.
      ls_data_out-serial_num = lv_counter.
      ls_data_out-objectid = <ls_data>-objectid.
      ls_data_out-value = <ls_data>-value.
      ls_data_out-fieldname = <ls_data>-fieldname.
      ls_data_out-error = <ls_data>-error.

      CLEAR: lv_ddtext.
      lv_domvalue = <ls_data>-scenario.
      CALL FUNCTION 'DOMAIN_VALUE_GET'
        EXPORTING
          i_domname        = 'CVI_PRECHK_SCENARIO'
          i_domvalue       = lv_domvalue
        IMPORTING
          e_ddtext         = lv_ddtext
        EXCEPTIONS
          not_exist        = 1
          OTHERS     = 2.
      IF sy-subrc = 0.
        ls_data_out-scenario = lv_ddtext.
      ENDIF.

      APPEND ls_data_out TO et_data.
      CLEAR: ls_data_out.
    ENDLOOP.
  ENDMETHOD.


  METHOD display_log_alv.
    DATA: lt_tb_exclude TYPE ui_functions,
          lv_name       TYPE string,
          lv_info       TYPE string,
          lv_result     TYPE tv_image,
          ls_layout     TYPE lvc_s_layo,
          lt_fcat       TYPE lvc_t_fcat.
    CLEAR: log_alv_data.

    log_alv_data = im_data.

    IF ref_log_alv_cont IS NOT BOUND.
      CREATE OBJECT ref_log_alv_cont
        EXPORTING
          container_name              = log_container_name                " Name of the Screen CustCtrl Name to Link Container To
          lifetime                    = cntl_lifetime_dynpro " Lifetime
        EXCEPTIONS
          cntl_error                  = 1                " CNTL_ERROR
          cntl_system_error           = 2                " CNTL_SYSTEM_ERROR
          create_error                = 3                " CREATE_ERROR
          lifetime_error              = 4                " LIFETIME_ERROR
          lifetime_dynpro_dynpro_link = 5                " LIFETIME_DYNPRO_DYNPRO_LINK
          OTHERS                      = 6.
      IF sy-subrc <> 0.
        IF 1 = 2.
          MESSAGE e038(cvi_prechk).
        ENDIF.
        MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 038 RAISING alv_error.
      ENDIF.

      IF ref_log_alv IS NOT BOUND.
        CREATE OBJECT ref_log_alv
          EXPORTING
            i_parent          = ref_log_alv_cont               " Parent Container
          EXCEPTIONS
            error_cntl_create = 1                " Error when creating the control
            error_cntl_init   = 2                " Error While Initializing Control
            error_cntl_link   = 3                " Error While Linking Control
            error_dp_create   = 4                " Error While Creating DataProvider Control
            OTHERS            = 5.
        IF sy-subrc <> 0.
          IF 1 = 2.
            MESSAGE e038(cvi_prechk).
          ENDIF.
          MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 038 RAISING alv_error.
      ENDIF.
    ENDIF.

      "ALV construction is not required if only ALV data to be refreshed.
      CALL METHOD prepare_log_alv_fcat
      IMPORTING
        ex_fcat = lt_fcat.

    "Remove unnecessary tools from default ALV toolbar.

    APPEND cl_gui_alv_grid=>mc_fc_detail TO lt_tb_exclude.
    APPEND cl_gui_alv_grid=>mc_fc_loc_copy TO lt_tb_exclude.
    APPEND cl_gui_alv_grid=>mc_fc_loc_undo TO lt_tb_exclude.
    APPEND cl_gui_alv_grid=>mc_fc_loc_paste TO lt_tb_exclude.
    APPEND cl_gui_alv_grid=>mc_fc_loc_cut TO lt_tb_exclude.
    APPEND cl_gui_alv_grid=>mc_fc_check TO lt_tb_exclude.
    APPEND cl_gui_alv_grid=>mc_fc_refresh TO lt_tb_exclude.
    APPEND cl_gui_alv_grid=>mc_fc_loc_append_row TO lt_tb_exclude.
    APPEND cl_gui_alv_grid=>mc_fc_loc_append_row TO lt_tb_exclude.
    APPEND cl_gui_alv_grid=>mc_fc_loc_delete_row TO lt_tb_exclude.
    APPEND cl_gui_alv_grid=>mc_fc_loc_copy_row TO lt_tb_exclude.
    APPEND cl_gui_alv_grid=>mc_mb_sum TO lt_tb_exclude.
    APPEND cl_gui_alv_grid=>mc_mb_subtot TO lt_tb_exclude.
    APPEND cl_gui_alv_grid=>mc_fc_print_back TO lt_tb_exclude.
    APPEND cl_gui_alv_grid=>mc_mb_view TO lt_tb_exclude.
    APPEND cl_gui_alv_grid=>mc_mb_export TO lt_tb_exclude.
    APPEND cl_gui_alv_grid=>mc_fc_current_variant TO lt_tb_exclude.
    APPEND cl_gui_alv_grid=>mc_fc_graph TO lt_tb_exclude.
    APPEND cl_gui_alv_grid=>mc_fc_info TO lt_tb_exclude.

      ls_layout-sel_mode = 'A'.
    ref_log_alv->set_table_for_first_display(
      EXPORTING
        it_toolbar_excluding          = lt_tb_exclude
        is_layout                     = ls_layout
      CHANGING
        it_outtab                     =  log_alv_data                 " Output Table
        it_fieldcatalog               =  lt_fcat                " Field Catalog
      EXCEPTIONS
        invalid_parameter_combination = 1                " Wrong Parameter
        program_error                 = 2                " Program Errors
        too_many_lines                = 3                " Too many Rows in Ready for Input Grid
        OTHERS                        = 4
    ).

    IF sy-subrc NE 0.
        IF 1 = 2.
          MESSAGE e038(cvi_prechk).
        ENDIF.
        MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 038 RAISING alv_error.
      ENDIF.
    ENDIF.

    "For tooltip on icons.
    LOOP AT log_alv_data ASSIGNING FIELD-SYMBOL(<fs_alv_log>).
      IF <fs_alv_log>-status_icon IS NOT INITIAL.
        IF <fs_alv_log>-status_icon = icon_led_green.
          lv_name = icon_led_green.
          lv_info = TEXT-020.
        ENDIF.
        IF <fs_alv_log>-status_icon = icon_led_yellow.
          lv_name = icon_led_yellow.
          lv_info = TEXT-021.
        ENDIF.
        IF <fs_alv_log>-status_icon = icon_incomplete.
          lv_name = icon_incomplete.
          lv_info = TEXT-022.
        ENDIF.
        CALL FUNCTION 'ICON_CREATE'
          EXPORTING
            name   = lv_name
            info   = lv_info
          IMPORTING
            result = lv_result.
        <fs_alv_log>-status_icon = lv_result.
      ENDIF.
      IF <fs_alv_log>-detail IS NOT INITIAL.
        CLEAR: lv_result.
        CALL FUNCTION 'ICON_CREATE'
          EXPORTING
*           name   = icon_overview
            name   = icon_select_detail
            info   = TEXT-019
          IMPORTING
            result = lv_result.
        <fs_alv_log>-detail = lv_result.
      ENDIF.
    ENDLOOP.

    SET HANDLER me->handle_log_doubleclick FOR ref_log_alv.
    SET HANDLER me->handle_log_alv_toolbar FOR ref_log_alv.
    SET HANDLER me->handle_log_alv_usercommand FOR ref_log_alv.
    SET HANDLER me->handle_hotspot_click FOR ref_log_alv.

    CALL METHOD ref_log_alv->refresh_table_display
      EXCEPTIONS
        finished = 1
        OTHERS   = 2.
    IF sy-subrc <> 0.
      IF 1 = 2.
        MESSAGE e038(cvi_prechk).
      ENDIF.
      MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 038 RAISING alv_error.
    ENDIF.
  ENDMETHOD.


  METHOD display_result_alv.
    DATA: ls_layout TYPE lvc_s_layo,
          lt_fcat   TYPE lvc_t_fcat.

    CLEAR: res_alv_data.

    IF im_data IS NOT INITIAL.
      "To convert the domain value to domain value text for the field Scenario
      me->convert_result_alv_tab(
            EXPORTING
              it_data = im_data
            IMPORTING
              et_data = res_alv_data
          ).
    ENDIF.

    IF ref_result_alv_cont IS NOT BOUND.

      "Creation of Custom Container
      CREATE OBJECT ref_result_alv_cont
        EXPORTING
          container_name              = res_container_name
        EXCEPTIONS
          cntl_error                  = 1                " CNTL_ERROR
          cntl_system_error           = 2                " CNTL_SYSTEM_ERROR
          create_error                = 3                " CREATE_ERROR
          lifetime_error              = 4                " LIFETIME_ERROR
          lifetime_dynpro_dynpro_link = 5                " LIFETIME_DYNPRO_DYNPRO_LINK
          OTHERS                      = 6.
      IF sy-subrc <> 0.
        IF 1 = 2.
          MESSAGE e038(cvi_prechk).
        ENDIF.
        MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 038 RAISING alv_error.
      ENDIF.

      "Split the Custom Container in two GUI Containers
      CREATE OBJECT res_alv_splitter
        EXPORTING
          parent                  = ref_result_alv_cont                   " Parent Container
          rows                    = 2                   " Number of Rows to be displayed
          columns                 = 1                   " Number of Columns to be Displayed
        EXCEPTIONS
          cntl_error        = 1                  " See Superclass
          cntl_system_error = 2                  " See Superclass
          OTHERS            = 3.
      IF sy-subrc <> 0.
        IF 1 = 2.
          MESSAGE e038(cvi_prechk).
        ENDIF.
        MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 038 RAISING alv_error.
      ENDIF.

      "Assign the two GUI Containers to the respective variables
     res_alv_container_head = res_alv_splitter->get_container( row = 1 column    = 1 ).
     res_alv_container_body = res_alv_splitter->get_container( row = 2 column    = 1 ).

      "Setting the row height of header container
     res_alv_splitter->set_row_height(
       EXPORTING
         id                = 1                 " Row ID
         height            = 10
       EXCEPTIONS
         cntl_error        = 1                " See CL_GUI_CONTROL
         cntl_system_error = 2                " See CL_GUI_CONTROL
         OTHERS            = 3
     ).
     IF sy-subrc <> 0.
        IF 1 = 2.
          MESSAGE e038(cvi_prechk).
        ENDIF.
        MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 038 RAISING alv_error.
     ENDIF.

    ENDIF.

    IF ref_result_alv IS NOT BOUND.

      "Grid ALV Object creation
      CREATE OBJECT ref_result_alv
        EXPORTING
          i_parent          = res_alv_container_body "ref_result_alv_cont
        EXCEPTIONS
          error_cntl_create = 1                " Error when creating the control
          error_cntl_init   = 2                " Error While Initializing Control
          error_cntl_link   = 3                " Error While Linking Control
          error_dp_create   = 4                " Error While Creating DataProvider Control
          OTHERS            = 5.
      IF sy-subrc <> 0.
        IF 1 = 2.
          MESSAGE e038(cvi_prechk).
        ENDIF.
        MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 038 RAISING alv_error.
      ENDIF.

      "Prepare Field catalog for ALV
      me->prepare_result_fcat(
            IMPORTING
              ex_fcat = lt_fcat
            EXCEPTIONS
              alv_error = 1
              OTHERS    = 2
          ).
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 RAISING alv_error.
      ENDIF.

      ls_layout-col_opt = abap_true.

      "Register event handler for TOP_OF_PAGE event of ALV
      SET HANDLER me->handle_res_alv_top_of_page FOR ref_result_alv.

      ref_result_alv->set_table_for_first_display(
          EXPORTING
            is_layout                     = ls_layout                 " Layout
          CHANGING
            it_outtab                     = res_alv_data
            it_fieldcatalog               = lt_fcat
          EXCEPTIONS
            invalid_parameter_combination = 1                " Wrong Parameter
            program_error                 = 2                " Program Errors
            too_many_lines                = 3                " Too many Rows in Ready for Input Grid
            OTHERS                        = 4
        ).
        IF sy-subrc <> 0.
        IF 1 = 2.
          MESSAGE e038(cvi_prechk).
        ENDIF.
        MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 038 RAISING alv_error.
      ENDIF.

      "Creating document object to be placed in the Header container
      CREATE OBJECT res_alv_header_doc.

    ELSE.
      ref_result_alv->refresh_table_display(
        EXCEPTIONS
          finished       = 1                " Display was Ended (by Export)
          OTHERS         = 2
      ).
      IF sy-subrc <> 0.
        IF 1 = 2.
          MESSAGE e038(cvi_prechk).
        ENDIF.
        MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 038 RAISING alv_error.
      ENDIF.
    ENDIF.

    IF ref_result_alv IS BOUND AND res_alv_header_doc IS BOUND.
      "Intialize the document content so that only new content is displayed
      res_alv_header_doc->initialize_document( ).

      "Trigger TOP_OF_PAGE event
        ref_result_alv->list_processing_events(
          EXPORTING
            i_event_name      = 'TOP_OF_PAGE'
            i_dyndoc_id       = res_alv_header_doc ).

    ENDIF.

  ENDMETHOD.


  METHOD execute_checks.

    DATA ls_prechk_header TYPE cvi_prechk.

    CALL METHOD cl_cvi_prechk=>process_selection_data
      EXPORTING
        im_gen_selection = im_gen_selection
        im_scenario      = im_scenario
      IMPORTING
        ex_return        = ex_return
        ex_prechk_header = ls_prechk_header
      EXCEPTIONS
        runid_id_error   = 1                " Error while generating Number Range
        OTHERS           = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
       WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO ex_return-message.
      ex_return-id = sy-msgid.
      ex_return-type = sy-msgty.
      ex_return-message_v1 = sy-msgv1.
      ex_return-message_v2 = sy-msgv2.
      ex_return-message_v3 = sy-msgv3.
      ex_return-message_v4 = sy-msgv4.
      ex_return-number = sy-msgno.
    ENDIF.

    "TO show detail screen incase of foreground mode, need to fill attribute of UI class.
    IF im_gen_selection-bgmode EQ space AND ex_return IS INITIAL.
      selected_log_alv_data-runid = ls_prechk_header-runid.
      selected_log_alv_data-runby = ls_prechk_header-run_by.
      selected_log_alv_data-runon = ls_prechk_header-run_on.
      selected_log_alv_data-objectype = ls_prechk_header-objectype.
      selected_log_alv_data-rundesc = ls_prechk_header-run_desc.
      selected_log_alv_data-rec_count = ls_prechk_header-rec_count.
    ENDIF.
  ENDMETHOD.


  METHOD get_and_disp_log_alv.
    DATA: ls_alv_log_tab TYPE if_cvi_prechk=>ty_alv_log_tab,
          lt_alv_log_tab TYPE if_cvi_prechk=>tt_alv_log_tab,
          lv_ddtext      TYPE dd07v-ddtext,
          ls_header_data TYPE cvi_prechk,
          lt_header_data TYPE TABLE OF cvi_prechk.

    cl_cvi_prechk=>get_log_data(
      EXPORTING
        im_filter = im_filter
      IMPORTING
        ex_data   = lt_header_data
    ).

    LOOP AT lt_header_data INTO ls_header_data.
      CLEAR ls_alv_log_tab.
      ls_alv_log_tab-runid = ls_header_data-runid.
      ls_alv_log_tab-objectype = ls_header_data-objectype.
      IF ls_alv_log_tab-objectype IS NOT INITIAL.
        CALL FUNCTION 'DOMAIN_VALUE_GET'
          EXPORTING
            i_domname  = 'CVI_PRECHK_OBJTYPE'
            i_domvalue = ls_alv_log_tab-objectype
          IMPORTING
            e_ddtext   = lv_ddtext
          EXCEPTIONS
            not_exist  = 1
            OTHERS     = 2.
        IF sy-subrc   = 0.
          ls_alv_log_tab-objectype_desc = lv_ddtext.
        ENDIF.
      ENDIF.
      ls_alv_log_tab-runby = ls_header_data-run_by.
      ls_alv_log_tab-rundesc = ls_header_data-run_desc.
      ls_alv_log_tab-runon = ls_header_data-run_on.
      ls_alv_log_tab-rec_count = ls_header_data-rec_count.
      ls_alv_log_tab-detail = icon_select_detail.
      ls_alv_log_tab-status = ls_header_data-status.
      IF ls_header_data-status = 01.
        ls_alv_log_tab-status_icon = icon_led_yellow.
      ELSEIF ls_header_data-status = 02.
        ls_alv_log_tab-status_icon = icon_led_green.
      ELSEIF ls_header_data-status = 03.
        ls_alv_log_tab-status_icon = icon_incomplete.
      ENDIF.
      INSERT ls_alv_log_tab INTO TABLE lt_alv_log_tab.
    ENDLOOP.

    CALL METHOD display_log_alv
      EXPORTING
        im_data   = lt_alv_log_tab
      EXCEPTIONS
        alv_error = 1                " Error while displaying ALV
        OTHERS    = 2.
    IF sy-subrc <> 0.
       MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 RAISING alv_error.
    ENDIF.
  ENDMETHOD.


  METHOD get_and_disp_res_alv.
    DATA: lt_result_data TYPE if_cvi_prechk=>tt_alv_result_tab.

    IF selected_log_alv_data-runid IS NOT INITIAL.
      CALL METHOD cl_cvi_prechk=>get_result_data
        EXPORTING
          im_runid = me->selected_log_alv_data-runid                " Run ID
        IMPORTING
          ex_data  = lt_result_data.

      me->display_result_alv(
        EXPORTING
          im_data         = lt_result_data                 " Type to be modified
        EXCEPTIONS
          no_record_found = 1                " No record found for the selection
          alv_error       = 2                " Error while displaying ALV
          others          = 3
      ).
      IF sy-subrc EQ 1.
        IF 1 = 2.
          MESSAGE e039(cvi_prechk).
        ENDIF.
        MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 039 RAISING no_record_found.
      ELSEIF sy-subrc NE 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 RAISING alv_error.
      ENDIF.

    ENDIF.
  ENDMETHOD.


METHOD handle_hotspot_click.
  DATA: lv_error_msg TYPE BAPI_MSG.

  "get the selected row id details
  READ TABLE log_alv_data INTO selected_log_alv_data INDEX e_row_id.
  IF sy-subrc <> 0.
    RETURN.
  ENDIF.

  "On click of RunId - navigate to error screen
  IF e_column_id = 'RUNID'.
*    IF selected_log_alv_data-status <> '02'. " icon_led_green.
    IF selected_log_alv_data-status = '01'. " icon_led_green.
      MESSAGE i035(cvi_prechk) DISPLAY LIKE 'E'.
      RETURN.
    ENDIF.

*****    Handle messgae for Terminated
    IF selected_log_alv_data-status = '03'.
      SELECT SINGLE ERROR_MSG FROM CVI_PRECHK INTO lv_error_msg  WHERE runid = selected_log_alv_data-runid.
        IF sy-subrc = 0.
          MESSAGE lv_error_msg TYPE 'I' DISPLAY LIKE 'E'.
          RETURN.
        ENDIF.
    ENDIF.

    PERFORM error_detail IN PROGRAM cvi_migration_prechk USING selected_log_alv_data.
  ENDIF.
ENDMETHOD.


  METHOD handle_log_alv_toolbar.
    DATA: ls_toolbar   TYPE stb_button.

    CLEAR: ls_toolbar.
    ls_toolbar-function = 'REFRESH'.
    ls_toolbar-quickinfo = TEXT-011.
    ls_toolbar-disabled = ''.
    ls_toolbar-icon = icon_refresh.
    INSERT ls_toolbar INTO e_object->mt_toolbar INDEX 1.

    CLEAR: ls_toolbar.
    ls_toolbar-function = 'DELETE'.
    ls_toolbar-quickinfo = TEXT-012.
    ls_toolbar-disabled = ''.
    ls_toolbar-icon = icon_delete.
    INSERT ls_toolbar INTO e_object->mt_toolbar INDEX 2.

  ENDMETHOD.


  METHOD handle_log_alv_usercommand.
    DATA : lt_log_alv_rows TYPE lvc_t_row,
           ls_log_alv_rows TYPE lvc_s_row,
           ls_log_alv      TYPE if_cvi_prechk=>ty_alv_log_tab,
           lt_log_alv      TYPE if_cvi_prechk=>tt_alv_log_tab,
         ls_ans          TYPE c,
         ls_subrc        TYPE sy-subrc.

  IF e_ucomm = 'REFRESH'.
    CALL METHOD me->refresh_alv
                  EXCEPTIONS
                    alv_error = 1
                    OTHERS    = 2 .
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE 'I' NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 DISPLAY LIKE 'E'.
    ENDIF.
    ENDIF.

    IF e_ucomm = 'DELETE'.
      ref_log_alv->get_selected_rows(
        IMPORTING
          et_index_rows =  lt_log_alv_rows                " Indexes of Selected Rows
      ).

      IF lt_log_alv_rows IS INITIAL.
      MESSAGE i036(cvi_prechk) DISPLAY LIKE 'E'.
        RETURN.
      ENDIF.

    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        titlebar              = TEXT-005
        text_question         = TEXT-006
        text_button_1         = TEXT-007
        text_button_2         = TEXT-008
          default_button        = '1'
          display_cancel_button = ' '
        IMPORTING
          answer                = ls_ans
        EXCEPTIONS
          text_not_found        = 1
          OTHERS                = 2.
      IF sy-subrc <> 0 OR ls_ans = 2 .
      RETURN.
    ENDIF.

    LOOP AT lt_log_alv_rows INTO ls_log_alv_rows.
      READ TABLE log_alv_data INTO ls_log_alv INDEX ls_log_alv_rows-index.
      IF sy-subrc = 0 AND ls_log_alv-status = 01.
        MESSAGE i037(cvi_prechk) DISPLAY LIKE 'E'.
        RETURN.
      ENDIF.
    ENDLOOP.

    LOOP AT lt_log_alv_rows INTO ls_log_alv_rows.
      READ TABLE log_alv_data INTO ls_log_alv INDEX ls_log_alv_rows-index.
      IF sy-subrc = 0.
          CALL METHOD cl_cvi_prechk=>delete_log_data
            EXPORTING
              im_runid = ls_log_alv-runid                " Run ID
            IMPORTING
              ex_subrc = ls_subrc.                 " ABAP-Systemfeld: Rückgabewert von ABAP-Anweisungen
          IF ls_subrc <> 0.
          MESSAGE i008(cvi_prechk) DISPLAY LIKE 'E'.
          ELSE.
            INSERT ls_log_alv INTO TABLE lt_log_alv.
          ENDIF.
      ENDIF.
    ENDLOOP.

        LOOP AT lt_log_alv INTO ls_log_alv.
          DELETE TABLE log_alv_data FROM ls_log_alv.
        ENDLOOP.

    IF ref_log_alv IS NOT BOUND.
      MESSAGE i038(cvi_prechk) DISPLAY LIKE 'E'.
        RETURN.
      ENDIF.

      ref_log_alv->refresh_table_display(
        EXCEPTIONS
          finished       = 1                " Display was Ended (by Export)
          OTHERS         = 2
      ).
      IF sy-subrc <> 0.
      MESSAGE i038(cvi_prechk) DISPLAY LIKE 'E'.
      RETURN.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD handle_log_doubleclick.

  DATA: lt_scenarios   TYPE STANDARD TABLE OF if_cvi_prechk=>ty_scenario_selection,
        lt_excluding   TYPE slis_t_extab.

    CLEAR: selected_log_alv_data.
    READ TABLE log_alv_data INTO selected_log_alv_data INDEX e_row-index.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    CASE e_column-fieldname.
      WHEN 'DETAIL'.
      cl_cvi_prechk=>get_scenarios(
            EXPORTING
              im_runid    = selected_log_alv_data-runid                " Run ID
            IMPORTING
              ex_scenario = DATA(ls_scenario)                 " Scenarios for Migration Precheck Run
          ).

          APPEND ls_scenario TO lt_scenarios.

      "Removing the buttons (function codes) from the toolbar
          lt_excluding = VALUE #( ( fcode = '&NT1' )
                                  ( fcode = '&ETA' )
                                  ( fcode = '&OUP' )
                                  ( fcode = '&ODN' )
                                  ( fcode = '%SC' )
                                  ( fcode = '%SC+' )
                                  ( fcode = '&ILT' )
                                  ( fcode = '&OL0' ) ).


      CALL FUNCTION 'REUSE_ALV_POPUP_TO_SELECT'
        EXPORTING
          i_title          = TEXT-004
          i_selection      = abap_false
          i_tabname        = '1'
          i_structure_name = 'CVI_PRECHK_SCENARIO_S'
          it_excluding     = lt_excluding
            TABLES
              t_outtab                      = lt_scenarios
           EXCEPTIONS
             program_error                 = 1
            OTHERS           = 2.
          IF sy-subrc <> 0.
        MESSAGE i038(cvi_prechk) DISPLAY LIKE 'E'.
        RETURN.
          ENDIF.

      WHEN OTHERS.
    ENDCASE.
  ENDMETHOD.


  METHOD handle_res_alv_top_of_page.
    DATA: lv_text      TYPE sdydo_text_element,
          lv_text_temp TYPE sdydo_text_element.

    IF selected_log_alv_data-objectype = if_cvi_prechk=>gc_objtype_cust.
      selected_log_alv_data-objectype = TEXT-009.
    ELSEIF selected_log_alv_data-objectype = if_cvi_prechk=>gc_objtype_vend.
      selected_log_alv_data-objectype = TEXT-010.
    ENDIF.

    CONCATENATE TEXT-000':' INTO lv_text_temp.
    CONCATENATE lv_text_temp selected_log_alv_data-objectype INTO lv_text SEPARATED BY space.

    e_dyndoc_id->add_text(
      EXPORTING
        text          = lv_text
    ).

    CLEAR: lv_text.
    e_dyndoc_id->new_line( ).

    CONCATENATE TEXT-001':' INTO lv_text_temp.
    CONCATENATE lv_text_temp selected_log_alv_data-rundesc
                INTO lv_text SEPARATED BY space.

    e_dyndoc_id->add_text(
      EXPORTING
        text          = lv_text
    ).

    CLEAR: lv_text.
    e_dyndoc_id->new_line( ).

    DATA(lv_rec_count_string) = CONV string( selected_log_alv_data-rec_count ).

    CONCATENATE TEXT-002':' INTO lv_text_temp.
    CONCATENATE lv_text_temp lv_rec_count_string INTO lv_text SEPARATED BY space.


    e_dyndoc_id->add_text(
      EXPORTING
        text          = lv_text
    ).

    CLEAR: lv_text.
    e_dyndoc_id->new_line( ).

    DATA(lv_lines_res_alv) = CONV string( lines( res_alv_data ) ).

    CONCATENATE TEXT-003':' INTO lv_text_temp.
    CONCATENATE lv_text_temp lv_lines_res_alv INTO lv_text SEPARATED BY space.

    e_dyndoc_id->add_text(
      EXPORTING
        text          = lv_text
    ).

    CLEAR: lv_text.
    e_dyndoc_id->new_line( ).

*    e_dyndoc_id->

    e_dyndoc_id->display_document(
      EXPORTING
        parent             = res_alv_container_head                 " Contain Object Already Exists
        reuse_control      = abap_true
      EXCEPTIONS
        html_display_error = 1                " Error Displaying the Document in the HTML Control
        OTHERS             = 2
    ).

    IF sy-subrc <> 0.
      MESSAGE i038(cvi_prechk) DISPLAY LIKE 'E'.
    ENDIF.

  ENDMETHOD.


  METHOD prepare_log_alv_fcat.
    DATA: lt_fieldcat TYPE lvc_t_fcat,
          ls_fieldcat TYPE lvc_s_fcat.

    CLEAR: ls_fieldcat.

    ls_fieldcat-fieldname = 'STATUS_ICON'.
    ls_fieldcat-lowercase = abap_true.
    ls_fieldcat-outputlen = '5'.
    ls_fieldcat-icon = abap_true.
    ls_fieldcat-scrtext_s = ls_fieldcat-scrtext_m = ls_fieldcat-scrtext_l = text-017.
    APPEND ls_fieldcat TO lt_fieldcat.
*******    For uni code for status
    CLEAR: ls_fieldcat.
    ls_fieldcat-fieldname = 'STATUS'.
    ls_fieldcat-tech = abap_true.
    APPEND ls_fieldcat TO lt_fieldcat.
*********
    CLEAR: ls_fieldcat.
    ls_fieldcat-fieldname = 'DETAIL'.
    ls_fieldcat-scrtext_s = ls_fieldcat-scrtext_m = ls_fieldcat-scrtext_l = text-019.
    ls_fieldcat-outputlen = '5'.
    ls_fieldcat-icon = abap_true.
    APPEND ls_fieldcat TO lt_fieldcat.

    CLEAR: ls_fieldcat.
    ls_fieldcat-fieldname = 'RUNID'.
    ls_fieldcat-hotspot = 'X'.
    ls_fieldcat-ref_table = 'CVI_PRECHK'.
    ls_fieldcat-ref_field = 'RUNID'.
    APPEND ls_fieldcat TO lt_fieldcat.

    CLEAR: ls_fieldcat.
    ls_fieldcat-fieldname = 'RUNDESC'.
    ls_fieldcat-ref_table = 'CVI_PRECHK'.
    ls_fieldcat-ref_field = 'RUN_DESC'.
    APPEND ls_fieldcat TO lt_fieldcat.

    CLEAR: ls_fieldcat.
    ls_fieldcat-fieldname = 'OBJECTYPE_DESC'.
    ls_fieldcat-scrtext_s = ls_fieldcat-scrtext_m = ls_fieldcat-scrtext_l = text-000.
    ls_fieldcat-outputlen = '8'.
    ls_fieldcat-lowercase = abap_true.
    APPEND ls_fieldcat TO lt_fieldcat.

*******     Object Type Description
    CLEAR: ls_fieldcat.
    ls_fieldcat-fieldname = 'OBJECTYPE'.
    ls_fieldcat-tech = abap_true.
    APPEND ls_fieldcat TO lt_fieldcat.
********
    CLEAR: ls_fieldcat.
    ls_fieldcat-fieldname = 'RUNBY'.
    ls_fieldcat-ref_field = 'RUN_BY'.
    ls_fieldcat-ref_table = 'CVI_PRECHK'.
    APPEND ls_fieldcat TO lt_fieldcat.

    CLEAR: ls_fieldcat.
    ls_fieldcat-fieldname = 'RUNON'.
    ls_fieldcat-ref_field = 'RUN_ON'.
    ls_fieldcat-ref_table = 'CVI_PRECHK'.
    APPEND ls_fieldcat TO lt_fieldcat.

    ex_fcat = lt_fieldcat.

  ENDMETHOD.


  METHOD prepare_result_fcat.
    DATA: lt_fieldcat     TYPE lvc_t_fcat.
    DATA: ls_fieldcat     LIKE LINE OF lt_fieldcat.

    "Get the field catalog from DDIC structure
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
     EXPORTING
       i_structure_name             = 'CVI_PRECHK_DET'
      CHANGING
        ct_fieldcat                  = lt_fieldcat
     EXCEPTIONS
       inconsistent_interface       = 1
       program_error                = 2
        OTHERS                 = 3.
    IF sy-subrc <> 0.
      IF 1 = 2.
        MESSAGE e038(cvi_prechk).
      ENDIF.
      MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 038 RAISING alv_error.
    ENDIF.

    IF lt_fieldcat IS NOT INITIAL.
      " Remove unwanted columns from the field catalog
      DELETE lt_fieldcat WHERE fieldname = 'MANDT'
                            OR fieldname = 'RUNID'
                            OR fieldname = 'MSG_ID'
                            OR fieldname = 'MSG_NUMBER'
                            OR fieldname = 'SCEN_FIELDCHECK'.
      CLEAR: ls_fieldcat.
      ls_fieldcat-fieldname = 'SERIAL_NUM'.
      ls_fieldcat-scrtext_s = TEXT-013.
      ls_fieldcat-scrtext_m = ls_fieldcat-scrtext_l = TEXT-014.
      ls_fieldcat-key = abap_true.
      ls_fieldcat-col_pos = 1.
      APPEND ls_fieldcat TO lt_fieldcat.
      CLEAR: ls_fieldcat.

      ls_fieldcat-fieldname = 'SCENARIO'.
      ls_fieldcat-scrtext_s = ls_fieldcat-scrtext_m = ls_fieldcat-scrtext_l = TEXT-016.
      ls_fieldcat-key = abap_true.
      ls_fieldcat-outputlen = 20.
      ls_fieldcat-col_pos = 3.
      ls_fieldcat-lowercase = abap_true.
      APPEND ls_fieldcat TO lt_fieldcat.
      CLEAR: ls_fieldcat.

* Change the fieldnames because DDIC structure fieldname and Internal table field name are different
      LOOP AT lt_fieldcat ASSIGNING FIELD-SYMBOL(<ls_fieldcat>).
        CASE <ls_fieldcat>-fieldname.
          WHEN 'CV_NUM'.
            <ls_fieldcat>-fieldname = 'OBJECTID'.
            <ls_fieldcat>-scrtext_s = <ls_fieldcat>-scrtext_m = <ls_fieldcat>-scrtext_l = <ls_fieldcat>-reptext = TEXT-015.
            <ls_fieldcat>-outputlen = 10.
            <ls_fieldcat>-col_pos = 2.
          WHEN 'FIELDNAME'.
            <ls_fieldcat>-fieldname = 'FIELDNAME'.
            <ls_fieldcat>-scrtext_s = <ls_fieldcat>-scrtext_m = <ls_fieldcat>-scrtext_l = TEXT-018.
            <ls_fieldcat>-outputlen = 30.
            <ls_fieldcat>-col_pos = 4.
          WHEN 'VALUE'.
            <ls_fieldcat>-fieldname = 'VALUE'.
            <ls_fieldcat>-scrtext_s = <ls_fieldcat>-scrtext_m = <ls_fieldcat>-scrtext_l = TEXT-024.
            <ls_fieldcat>-outputlen = 40.
            <ls_fieldcat>-col_pos = 5.
          WHEN 'MESSAGE'.
            <ls_fieldcat>-fieldname = 'ERROR'.
            <ls_fieldcat>-scrtext_s = <ls_fieldcat>-scrtext_m = <ls_fieldcat>-scrtext_l = TEXT-023.
            <ls_fieldcat>-outputlen = 60.
            <ls_fieldcat>-col_pos = 6.
          WHEN OTHERS.
        ENDCASE.
      ENDLOOP.

      ex_fcat = lt_fieldcat.
    ENDIF.

  ENDMETHOD.


  METHOD refresh_alv.
    DATA: lt_data        TYPE IF_CVI_PRECHK=>tt_ruinid_status,
          ls_data        TYPE IF_CVI_PRECHK=>ty_runid_status,
          ls_alv_log_tab TYPE IF_CVI_PRECHK=>ty_alv_log_tab,
          lv_result      TYPE tv_image,
          lv_name        TYPE string,
          lv_info        TYPE string.

*    READ TABLE log_alv_data WITH KEY status = '01' status = '03' TRANSPORTING NO FIELDS.
*    IF sy-subrc <> 0.
*      RETURN.
*    ENDIF.

    LOOP AT log_alv_data INTO ls_alv_log_tab WHERE status <> '02' .
      ls_data-runid = ls_alv_log_tab-runid.
*      ls_data-status = 01.
      ls_data-status = ls_alv_log_tab-status.
      APPEND ls_data TO lt_data.
    ENDLOOP.

    CHECK lt_data IS NOT INITIAL.

    CALL METHOD cl_cvi_prechk=>get_current_run_status
      CHANGING
        ch_runid_status = lt_data.

    CLEAR ls_data.
    LOOP AT lt_data INTO ls_data.
      READ TABLE log_alv_data ASSIGNING FIELD-SYMBOL(<fs_log_alv_data>) WITH KEY runid = ls_data-runid.
      IF sy-subrc = 0 AND ls_data-status <> <fs_log_alv_data>-status.
        <fs_log_alv_data>-status = ls_data-status.
        IF ls_data-status = 02.
          lv_name = icon_led_green.
          lv_info = TEXT-020.
        ENDIF.
        IF ls_data-status = 03.
          lv_name = icon_incomplete.
          lv_info = TEXT-022.
        ENDIF.
        CALL FUNCTION 'ICON_CREATE'
          EXPORTING
            name   = lv_name
            info   = lv_info
            IMPORTING
              result = lv_result.
          <fs_log_alv_data>-status_icon = lv_result.
      ENDIF.
    ENDLOOP.

    IF ref_log_alv IS NOT BOUND.
      IF 1 = 2.
        MESSAGE e038(cvi_prechk).
      ENDIF.
      MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 038 RAISING alv_error.
      RETURN.
    ENDIF.

    ref_log_alv->refresh_table_display(
      EXCEPTIONS
        finished       = 1                " Display was Ended (by Export)
        OTHERS         = 2
    ).
    IF sy-subrc <> 0.
      IF 1 = 2.
        MESSAGE e038(cvi_prechk).
      ENDIF.
      MESSAGE ID if_cvi_prechk=>gc_message_class TYPE 'E' NUMBER 038 RAISING alv_error.
    ENDIF.

  ENDMETHOD.


  METHOD validate_selection_ip.

    DATA : lo_cvi_prechk TYPE REF TO cl_cvi_prechk.

    "The object type can't be initial
    CHECK im_selection_data-objtype IS NOT INITIAL.

    CREATE OBJECT lo_cvi_prechk.

    "check at least one of the scenario is checked, if not then raise an error message and return.
    IF im_scenario-addr_ind IS INITIAL
     AND im_scenario-bank_ind IS INITIAL
     AND im_scenario-email_ind IS INITIAL
     AND im_scenario-indus_ind IS INITIAL
     AND im_scenario-pcode_ind IS INITIAL
     AND im_scenario-taxcode_ind IS INITIAL
     AND im_scenario-taxjur_ind IS INITIAL
     AND im_scenario-tzone_ind IS INITIAL
     AND im_scenario-numrng_ind IS INITIAL.
      IF 1 = 2.
        MESSAGE e003(CVI_PRECHK).
      ENDIF.
      CLEAR ex_bapiret.
      ex_bapiret-type = 'E'.
      ex_bapiret-id = if_cvi_prechk=>GC_MESSAGE_CLASS.
      ex_bapiret-number = '003'.
      MESSAGE ID ex_bapiret-id TYPE ex_bapiret-type NUMBER ex_bapiret-number INTO ex_bapiret-message.
      RETURN.
    ENDIF.

    lo_cvi_prechk->validate_selection_input(
      EXPORTING
        im_gen_selection =  im_selection_data                " General Selection
        im_scenario      =  im_scenario                " Scenarios for Migration Precheck Run
      IMPORTING
        ex_return        =  ex_bapiret
    ).

  ENDMETHOD.
ENDCLASS.
