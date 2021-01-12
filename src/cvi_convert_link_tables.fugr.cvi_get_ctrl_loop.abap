FUNCTION CVI_GET_CTRL_LOOP.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_SOURCE_OBJECT) TYPE  MDS_CTRL_OBJ_SOURCE
*"     VALUE(IV_TARGET_OBJECT) TYPE  MDS_CTRL_OBJ_SOURCE
*"  EXPORTING
*"     VALUE(EV_RELEVANT) TYPE  BOOLE_D
*"----------------------------------------------------------------------

  DATA:
        lr_cvi_ctrl_loop            TYPE REF TO cvi_ctrl_loop.

*&---- Checking EOP check done for CUSTOMER to BP or not.
  CALL METHOD cvi_ctrl_loop=>get_instance
    IMPORTING
      er_object = lr_cvi_ctrl_loop.

  CALL METHOD lr_cvi_ctrl_loop->check_steps
    EXPORTING
      iv_source_object = iv_source_object
      iv_target_object = iv_target_object
    IMPORTING
      ev_relevant      = ev_relevant
*     es_error         =
    .
ENDFUNCTION.
