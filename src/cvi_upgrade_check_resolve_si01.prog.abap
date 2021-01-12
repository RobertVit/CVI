*&---------------------------------------------------------------------*
*&      Module  INITIALIZATION_1138  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE INITIALIZATION_1138 OUTPUT.
perform initialization_1138.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  S_SEL3-LOW_VAL  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE S_SEL3-LOW_VAL INPUT.
PERFORM determine_searchhelp USING 's_sel3-low'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  S_SEL3-HIGH_VAL  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE S_SEL3-HIGH_VAL INPUT.
PERFORM determine_searchhelp USING 's_sel3-high'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  S_SEL18-LOW_VAL  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE S_SEL18-LOW_VAL INPUT.
  ls_help_info-call      = 'V'.
  ls_help_info-object    = 'F'.
  ls_help_info-tabname   = '/SAPPO/STR_DIALOG_SELECT'.
  ls_help_info-fieldname = 'CREATIONDATE'.
  ls_help_info-fieldtype = 'DATE'.
  ls_help_info-DYNPRO    = 1140.
  ls_help_info-DYNPROFLD = 'S_SEL18-LOW'.
  ls_help_info-show      = abap_true.
  ls_help_info-menufunct = 'HC'.
  ls_help_info-program   = 'cvi_upgrade_check_resolve'.

  CALL FUNCTION 'HELP_START'
    EXPORTING
      help_infos   = ls_help_info
    TABLES
      dynpselect   = lt_dynpselect
      dynpvaluetab = lt_dynpvaluetab.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  S_SEL18-HIGH_VAL  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE S_SEL18-HIGH_VAL INPUT.
ls_help_info-call      = 'V'.
  ls_help_info-object    = 'F'.
  ls_help_info-tabname   = '/SAPPO/STR_DIALOG_SELECT'.
  ls_help_info-fieldname = 'CREATIONDATE'.
  ls_help_info-fieldtype = 'DATE'.
  ls_help_info-DYNPRO    = 1140.
  ls_help_info-DYNPROFLD = 'S_SEL18-HIGH'.
  ls_help_info-show      = abap_true.
  ls_help_info-menufunct = 'HC'.
  ls_help_info-program   = 'cvi_upgrade_check_resolve'.

  CALL FUNCTION 'HELP_START'
    EXPORTING
      help_infos   = ls_help_info
    TABLES
      dynpselect   = lt_dynpselect
      dynpvaluetab = lt_dynpvaluetab.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  STATUS_1140  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_1140 OUTPUT.
*if g_flg_display_mode is initial.
*    set titlebar '1138' with text-005.
*  else.
*    set titlebar '1138' with text-006.
*  endif.

   SET PF-STATUS 'STAT1'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  INITIALIZATION_1140  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE INITIALIZATION_1140 OUTPUT.
perform initialization_1140.
ENDMODULE.
