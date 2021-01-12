
*&---------------------------------------------------------------------*
*&      Form  EXIT_PROGRAM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
DATA :
      lv_date_difference TYPE i VALUE 30.

FORM exit_program .
  LEAVE PROGRAM.
ENDFORM.

* To call the subscreen to show error details.
FORM  error_detail
  USING es_log_alv_data TYPE IF_CVI_PRECHK=>TY_ALV_LOG_TAB.
    CALL SCREEN 2000.
ENDform.

* Default Values visible in the start of program
FORM perform_initialize .
  CREATE OBJECT go_cvi_prechk_ui.
  gs_scenarios = if_cvi_prechk=>gc_scenrios.
  gv_selectall = abap_true.
  gv_bg_mode = abap_true.
  gs_gen_sel-cust = abap_true.
  gv_dynnr_gen_sel = 1002.
  s_run_on-sign = 'I'.
  s_run_on-option = 'BT'.
  s_run_on-low = sy-datum - lv_date_difference.
  s_run_on-high = sy-datum.
  APPEND s_run_on.
ENDFORM.


* Select all logic of scenerio check
FORM select_all_toggle.
  IF gv_selectall = abap_false.
    CLEAR: gs_scenarios.
  ELSE.
    gs_scenarios = if_cvi_prechk=>gc_scenrios.
  ENDIF.
ENDFORM.

* To unselect the select all checkbox if any check is unchecked
FORM business_check_toggle.
  IF gs_scenarios EQ if_cvi_prechk=>gc_scenrios.
    gv_selectall = abap_true.
  ELSE.
    gv_selectall = abap_false.
  ENDIF.

ENDFORM.

* Execution button logic
FORM execute_scenario_checks
  USING p_error_chk type bapiret2.

  DATA:
    ls_error    TYPE bapiret2,
    ls_vsi_data TYPE  if_cvi_prechk=>ty_general_selection.


  IF go_cvi_prechk_ui IS NOT BOUND.
    MESSAGE i008 DISPLAY LIKE 'E'.

  ENDIF.
* Preparing the parrameter values that has to be passed to class method
  IF gs_gen_sel-vend = abap_true.
    ls_vsi_data-objtype =   if_cvi_prechk=>gc_objtype_vend.
    IF  s_vend IS NOT INITIAL.
      APPEND LINES OF s_vend TO ls_vsi_data-objid_rn.
    ENDIF.
    IF s_vac_gp IS NOT INITIAL.
      APPEND LINES OF s_vac_gp TO ls_vsi_data-cv_group .
    ENDIF.
  ELSEIF gs_gen_sel-cust = abap_true.
    ls_vsi_data-objtype =   if_cvi_prechk=>gc_objtype_cust.
    IF s_cust IS NOT INITIAL.
      APPEND LINES OF s_cust TO ls_vsi_data-objid_rn.
    ENDIF.
    IF s_cac_gp IS NOT INITIAL.
      APPEND LINES OF s_cac_gp TO ls_vsi_data-cv_group .
    ENDIF.
  ENDIF.

  ls_vsi_data-bgmode = gv_bg_mode.
  ls_vsi_data-server_group = gv_server_grp .
  ls_vsi_data-run_description = gv_run_desc.
* Method to validate the data entered in the UI
  CALL METHOD go_cvi_prechk_ui->validate_selection_ip
    EXPORTING
      im_selection_data = ls_vsi_data
      im_scenario       = gs_scenarios
    IMPORTING
      ex_bapiret        = ls_error.

  IF ls_error IS NOT INITIAL.
    p_error_chk = ls_error.
    return.

  ELSE.
*  To start the execution check selected by the user
    CALL METHOD go_cvi_prechk_ui->execute_checks
      EXPORTING
        im_gen_selection = ls_vsi_data              " General Selection
        im_scenario      = gs_scenarios               " Scenarios for Migration Precheck Run
      IMPORTING
        ex_return        = ls_error.
* To add entry in the ALV of the recently executed check
    PERFORM display_log_alv.

    IF ls_error IS INITIAL.
      IF ls_vsi_data-bgmode EQ abap_true.
        MESSAGE s034.
        CLEAR ls_error.
      ELSE.
        CALL SCREEN 2000.
      ENDIF.
    ELSE.
      p_error_chk = ls_error.
      return.
    ENDIF.
  ENDIF.

IF p_error_chk IS INITIAL.
  CLEAR: gv_server_grp,
         gv_run_desc,
         s_cust,
         s_cust[],
         s_vend,
         s_vend[],
         s_cac_gp,
         s_cac_gp[],
         s_vac_gp,
         s_vac_gp[].
  ENDIF.



ENDFORM.
* To display the checks executedin past in form of a table called ALV
FORM display_log_alv.

  DATA:
    ls_exec_chk_data TYPE if_cvi_prechk=>ty_log_gen_selection.


  IF s_run_on IS NOT INITIAL.
    CLEAR: ls_exec_chk_data.

    IF go_cvi_prechk_ui IS NOT BOUND.
      MESSAGE i008 DISPLAY LIKE 'E'.
    ENDIF.

    APPEND LINES OF s_run_on TO ls_exec_chk_data-date_rn  .
    ls_exec_chk_data-status = gs_run_details-status.

    CALL METHOD go_cvi_prechk_ui->get_and_disp_log_alv
      EXPORTING
        im_filter       = ls_exec_chk_data               " Type needs to be adapted once interface gen is complete
      EXCEPTIONS
        no_record_found = 1                " No record found for the selection
        alv_error       = 2                " Error while displaying ALV
        OTHERS          = 3.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE 'I' NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 DISPLAY LIKE 'E'.
*      RETURN.
    ENDIF.
  ELSE.
    MESSAGE i023 DISPLAY LIKE 'E'.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  DISPLAY_RESULT_ALV
*&---------------------------------------------------------------------*
*       To display the ALV in the second screen i.e. 2000
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_result_alv .
  IF go_cvi_prechk_ui IS BOUND.
    go_cvi_prechk_ui->get_and_disp_res_alv(
      EXCEPTIONS
        alv_error       = 1                " Error while displaying ALV
        no_record_found = 2                " No Record Found
        OTHERS          = 3
    ).
    IF sy-subrc <> 0.
     MESSAGE ID sy-msgid TYPE 'I' NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 DISPLAY LIKE 'E'.
    ENDIF.
  ENDIF.
ENDFORM.
