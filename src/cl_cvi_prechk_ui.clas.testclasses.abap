
CLASS lcl_cvi_prechk_ui DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

   PRIVATE SECTION.
    DATA:
      f_cut TYPE REF TO cl_cvi_prechk_ui.

    Methods: calling_method FOR TESTING.
*             EXECUTE_CHECKS FOR TESTING.
ENDCLASS.


CLASS lcl_cvi_prechk_ui IMPLEMENTATION.
  METHOD calling_method.
  DATA: ls_selection_ip TYPE IF_CVI_PRECHK=>TY_GENERAL_SELECTION,
        ls_scenarios TYPE if_Cvi_Prechk=>ty_scenario_selection,
        ls_exec_chk_data TYPE if_cvi_prechk=>ty_log_gen_selection,
        lt_run_on TYPE RANGE OF datum,
        ls_run_on like LINE OF lt_run_on,
        REF_LOG_ALV_CONT TYPE REF TO  CL_GUI_CUSTOM_CONTAINER,
        lo_alv_toolbar TYPE REF TO CL_GUI_ALV_GRID.

    ls_selection_ip-objtype = if_cvi_prechk=>gc_objtype_vend.
    ls_selection_ip-server_group = ' 369'.
    ls_selection_ip-run_description = 'Testing'.
    ls_run_on-sign = 'I'.
    ls_run_on-option = 'BT'.
    ls_run_on-low = sy-datum - 30.
    ls_run_on-high = sy-datum.
    APPEND ls_run_on TO lt_run_on.
    APPEND LINES OF lt_run_on TO ls_exec_chk_data-date_rn.

    ls_scenarios = if_cvi_prechk=>gc_scenrios.
    create OBJECT f_Cut.
    IF ref_log_alv_cont IS NOT BOUND.
      CREATE OBJECT ref_log_alv_cont
        EXPORTING
          container_name              = 'CONT_LOG'
        EXCEPTIONS
          cntl_error                  = 1                " CNTL_ERROR
          cntl_system_error           = 2                " CNTL_SYSTEM_ERROR
          create_error                = 3                " CREATE_ERROR
          lifetime_error              = 4                " LIFETIME_ERROR
          lifetime_dynpro_dynpro_link = 5                " LIFETIME_DYNPRO_DYNPRO_LINK
          OTHERS                      = 6.
      IF sy-subrc <> 0.

      ENDIF.
    ENDIF.

      f_Cut->validate_selection_ip(
        EXPORTING
          im_selection_data =  ls_selection_ip                " General Selection
          im_scenario       =  ls_scenarios                " Scenarios for Migration Precheck Run
*        IMPORTING
*          ex_bapiret        =
      ).

      f_cut->execute_checks(
        EXPORTING
          im_gen_selection =  ls_selection_ip                " General Selection
          im_scenario      =  ls_scenarios                " Scenarios for Migration Precheck Run
*        IMPORTING
*          ex_return        =
      ).

      f_Cut->get_and_disp_log_alv(
        EXPORTING
          im_filter       =   ls_exec_chk_data               " Type needs to be adapted once interface gen is complete
*        EXCEPTIONS
*          no_record_found = 1                " No record found for the selection
*          alv_error       = 2                " Error while displaying ALV
*          others          = 3
      ).
      IF sy-subrc <> 0.
*       MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*         WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

      f_Cut->get_and_disp_res_alv(
*        EXCEPTIONS
*          alv_error       = 1                " Error while displaying ALV
*          no_record_found = 2                " No Record Found
*          others          = 3
      ).
      IF sy-subrc <> 0.
*       MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*         WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

    ENDMETHOD.

ENDCLASS.
