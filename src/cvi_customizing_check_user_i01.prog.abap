*----------------------------------------------------------------------*
***INCLUDE CVI_CUSTOMIZING_CHECK_USER_I01 .
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.



  call method cl_gui_cfw=>dispatch
    IMPORTING
      return_code = lv_return_code.

  if lv_return_code <> cl_gui_cfw=>rc_noevent.
    " a control event occured => exit PAI
    clear g_ok_code.
    return.
  endif.

  case g_ok_code.
    when 'PRINT'.

      call method lcl_application=>print.

    when 'EXPAND_ALL'.

      call method lcl_application=>expand_all_nodes.

    when 'COLLAP_ALL'.

      call method lcl_application=>collapse_all_nodes.

    when 'REFRESH'.

      call method lcl_application=>refresh.

    when others.
      "do nothing

  endcase.


  clear g_ok_code.

ENDMODULE.                 " USER_COMMAND_0100  INPUT
