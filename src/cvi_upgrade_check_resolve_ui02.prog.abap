*----------------------------------------------------------------------*
***INCLUDE CVI_UPGRADE_CHECK_RESOLVE_UI02 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_1001  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_1001 INPUT.
 DATA : lt_err TYPE BAPIRET2_T.
case ok_code.
*    when gc_back.
*      set screen 100. "start screen
*    when gc_next.
*      set screen 600. "vendor check screen
*    when gc_exit.
*      leave program.
     when 'DISP'.
       GV_DISP = 'X'.
     when log.
     call screen 1140 STARTING AT 10 5. "log screen
     when supress.
     call screen 1143 STARTING AT 10 5. "supress screen
*     when 'COMPLETE'.
*       DATA lv_check TYPE usr05-parva.
*
*       clear lv_check.
*
*       CALL FUNCTION 'G_SET_USER_PARAMETER'
*          EXPORTING
*            parameter_id          = 'MIG_CHECK'
*            parameter_value       = lv_check
**       EXCEPTIONS
**         DOES_NOT_EXIST        = 1
**         OTHERS                = 2
*                  .
*        IF sy-subrc <> 0.
**       MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**               WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*        ENDIF.
*       CALL FUNCTION 'CVI_SUPPRESS_COUNTRY_CHECKS'
*        EXPORTING
*          IV_COMPLETE       = 'X'
*        IMPORTING
*          ET_ERRORS         = lt_err.
*
*      MESSAGE 'Reverted the country specific suppress checks to the original state' TYPE 'S'.

  endcase.
ENDMODULE.                 " USER_COMMAND_1001  INPUT
