*----------------------------------------------------------------------*
***INCLUDE CVI_UPGRADE_CHECK_RESOLVE_UI03 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0220  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0220 INPUT.

data : ls_selected_roles LIKE LINE OF gt_selected_roles,
        answer type c LENGTH 1.

  case ok_code.

    when gc_back.

      PERFORM free_alvs.
      set screen 210. "start screen

    when gc_prev.

      PERFORM free_alvs.
      set screen 210.


    when gc_home.
      set screen 100.

    when gc_next.
      set screen 230.

    when gc_exit.
      leave program.

    when 'DEL'.

*if gt_selected_roles IS NOT INITIAL.

READ TABLE gt_selected_roles with key delete = 'X' TRANSPORTING NO FIELDS.
if sy-subrc = 0.
CALL FUNCTION 'POPUP_TO_CONFIRM'
  EXPORTING
   TITLEBAR                    = 'Confirm deletion'
   TEXT_QUESTION               = 'Do you want to delete the selected role assignments ?'
   TEXT_BUTTON_1               = 'Yes'
   ICON_BUTTON_1               = 'ICON_OKAY'
   TEXT_BUTTON_2               = 'Cancel'
   ICON_BUTTON_2               = 'ICON_CANCEL'
   DEFAULT_BUTTON              = '1'
   DISPLAY_CANCEL_BUTTON       = ' '
*   USERDEFINED_F1_HELP         = ' '
   START_COLUMN                = 25
   START_ROW                   = 6
*   POPUP_TYPE                  =
*   IV_QUICKINFO_BUTTON_1       = ' '
*   IV_QUICKINFO_BUTTON_2       = ' '
 IMPORTING
   ANSWER                      = answer
          .

if answer = '1'.
   PERFORM delete_reole_assigments.
   clear gv_retain_selection.
else.
  gv_retain_selection = 'X'.
  endif.

ENDIF.

WHEN 'DOCU_BP'.
  perform show_documentation using gc_general_text 'CVI_FS_GEN_UN_ROLE'.
WHEN 'DOCU_ROLE'.

  perform show_documentation using gc_general_text 'CVI_FS_GEN_UN_ROLE_2'.
  ENDCASE.

*      set handler lcl_event_handler=>on_toolbar_role for gr_alv_role.


ENDMODULE.                 " USER_COMMAND_0220  INPUT
