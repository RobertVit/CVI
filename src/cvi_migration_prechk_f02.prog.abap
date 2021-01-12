*&---------------------------------------------------------------------*
*&  Include           CVI_MIGRATION_PRECHK_F03
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  STATUS_2000  OUTPUT
*&---------------------------------------------------------------------*
*       Initial screen process before input
*----------------------------------------------------------------------*
MODULE STATUS_1000 OUTPUT.

  SET PF-STATUS 'INITIAL'.
  SET TITLEBAR 'INITIAL'.

  IF gs_gen_sel-vend = abap_true.
    gv_dynnr_gen_sel = 1003.
    CLEAR : s_cust, s_cust[].
  ELSEIF gs_gen_sel-cust = abap_true.
    gv_dynnr_gen_sel = 1002.
    CLEAR: s_vend, s_vend[].
  ENDIF.

*&---------------------------------------------------------------------*
*&  Initialization and display run history for last 30 days
*&---------------------------------------------------------------------*
  IF gv_ok_code = 'INIT'.
    PERFORM perform_initialize.
    PERFORM display_log_alv.
  ENDIF.

ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  STATUS_2000  OUTPUT
*&---------------------------------------------------------------------*
*       Error log alv of screen 2000 before input
*----------------------------------------------------------------------*
MODULE STATUS_2000 OUTPUT.

  SET PF-STATUS 'DETAIL'.
  SET TITLEBAR 'DETAIL'.

  PERFORM display_result_alv.



ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_2000  INPUT
*&---------------------------------------------------------------------*
*       Error log alv screen 2000 after input
*----------------------------------------------------------------------*
MODULE USER_COMMAND_2000 INPUT.
  CASE gv_ok_code.
    WHEN 'BACK'.
      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN 'CANC' OR 'EXIT'.
      LEAVE PROGRAM.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_1000  INPUT
*&---------------------------------------------------------------------*
*       Main screen 1000 after the input given by user
*----------------------------------------------------------------------*
MODULE USER_COMMAND_1000 INPUT.
  DATA: ls_error TYPE bapiret2.
  CASE gv_ok_code.
    WHEN 'BACK'.
      PERFORM exit_program.
    WHEN 'CANC' OR 'EXIT'.
      PERFORM exit_program.
    WHEN 'SELALL'.
      PERFORM select_all_toggle.
    WHEN 'EXECUTE'.
      CLEAR ls_error.
      PERFORM execute_scenario_checks USING ls_error.
      if ls_error is not INITIAL and ls_error-type = 'E' .
        MESSAGE ls_error-message TYPE 'S' DISPLAY LIKE ls_error-type.
        SET SCREEN 1000.
        LEAVE SCREEN.
      ENDIF.
    WHEN 'DISPLOG'.
      PERFORM display_log_alv.
    WHEN 'BCHK'.
      PERFORM business_check_toggle.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  VAL_REQD_TECHNICAL_FIELDS  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE val_reqd_technical_fields INPUT.
  IF gv_ok_code EQ 'EXECUTE'.
    IF gv_server_grp IS INITIAL.
      MESSAGE  E021.
    ELSEIF   gv_run_desc IS INITIAL.
      MESSAGE  E022.
    ENDIF.
  ENDIF.
ENDMODULE.
