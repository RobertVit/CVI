*&---------------------------------------------------------------------*
*&  Include           CVI_MIGRATION_PRECHK_F03
*&---------------------------------------------------------------------*


MODULE pbo_1000 OUTPUT.


  DATA:
    ss_gen_sel TYPE sy-dynnr.

  SET PF-STATUS 'INITIAL'.
  SET TITLEBAR 'INITIAL'.

  gv_repid = sy-repid.

  IF gs_gen_sel-vend = 'X'.
    ss_gen_sel = 1003.
    s_cust-low = ''.
    s_cust-high = ''.
    MODIFY SCREEN.
  ELSEIF gs_gen_sel-cust = 'X'.
    ss_gen_sel = 1002.
    s_vend-low = ''.
    s_vend-high = ''.
    MODIFY SCREEN.
  ELSE.
    gs_gen_sel-cust = 'X'.
    ss_gen_sel = 1002.
    s_vend-low = ''.
    s_vend-high = ''.
    MODIFY SCREEN.
  ENDIF.


  IF sy-ucomm IS INITIAL.
*    gs_run_details-is_vendor_sel = 'X'.
*    gs_run_details-is_customer_sel = 'X'.
    s_run_on-sign = 'I'.
    s_run_on-option = 'BT'.
    s_run_on-low = sy-datum - 30. "first_day
    s_run_on-high = sy-datum. "last_day
    APPEND s_run_on.
    PERFORM display_log_alv.
  ENDIF.

ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  PBO_2000  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pbo_2000 OUTPUT.

  SET PF-STATUS 'DETAIL'.
  SET TITLEBAR 'DETAIL'.

  PERFORM display_result_alv.



ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PAI_1001  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pai_2000 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK'.
      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN 'CANC' OR 'EXIT'.
      LEAVE PROGRAM.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PAI_1000  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pai_1000 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK' OR 'CANC' OR 'EXIT' .
      PERFORM exit_program.
    WHEN 'SELALL'.
      PERFORM select_all_toggle.
    WHEN 'EXECUTE'.
      PERFORM execute_scenario_checks.
    WHEN 'DISPLOG'.
      PERFORM display_log_alv.
*    WHEN 'BUSCHKTOGGLE'.
*      PERFORM business_check_toggle.
    WHEN 'OK'.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
