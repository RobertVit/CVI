*----------------------------------------------------------------------*
***INCLUDE CVI_UPGRADE_CHECK_RESOLVE_UI04 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0230  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0230 INPUT.

  DATA: lv_otflag TYPE boole_d,
        lv_err_flag TYPE boole_d.

  if gr_new_nriv_alv is not initial.
    gr_new_nriv_alv->check_changed_data( ).
  endif.

  lv_otflag = abap_true.
  lv_err_flag = abap_false.

  case ok_code.

    when gc_back.

      PERFORM CLEAR_NUMBER_RANGES.
      set screen 220. "start screen

    when gc_prev.

      PERFORM CLEAR_NUMBER_RANGES.
      set screen 220.


    when gc_home.

      PERFORM CLEAR_NUMBER_RANGES.
      set screen 100.

*    when gc_next.
*      set screen 230.

    when gc_exit.
      leave program.

    when 'SAVE'.

      DATA: ls_new_edit_nriv LIKE LINE OF gt_new_edit_nriv,
            lt_nriv TYPE TABLE OF NRIV.

      IF lines( gt_new_edit_nriv ) > 0.

        LOOP AT gt_new_edit_nriv INTO ls_new_edit_nriv.
          IF ls_new_edit_nriv-select EQ 'X'.
            SELECT * FROM NRIV INTO TABLE LT_NRIV WHERE OBJECT = ls_new_edit_nriv-OBJECT AND NRRANGENR = ls_new_edit_nriv-nrrangenr.
            IF sy-subrc EQ 0.
              lv_err_flag = abap_true.
              EXIT.
            ENDIF.
          ENDIF.
        ENDLOOP.

        IF lv_err_flag EQ abap_false.

          CALL FUNCTION 'POPUP_TO_CONFIRM'
            EXPORTING
             TITLEBAR                    = 'Confirm New Number Ranges'
             TEXT_QUESTION               = 'Maintaining new Business Partner number ranges is expected to be a one-time activity during migration to S/4. Do you want to save the proposed number ranges ?'
             TEXT_BUTTON_1               = 'Yes'
             ICON_BUTTON_1               = 'ICON_OKAY'
             TEXT_BUTTON_2               = 'Cancel'
             ICON_BUTTON_2               = 'ICON_CANCEL'
             DEFAULT_BUTTON              = '1'
             DISPLAY_CANCEL_BUTTON       = ' '
*         USERDEFINED_F1_HELP         = ' '
             START_COLUMN                = 25
             START_ROW                   = 6
*             POPUP_TYPE                  =
*         IV_QUICKINFO_BUTTON_1       = ' '
*         IV_QUICKINFO_BUTTON_2       = ' '
           IMPORTING
             ANSWER                      = answer.

          IF answer EQ '1'.

            DATA: LV_OBJECT TYPE TNRO-OBJECT,
            LT_ERROR TYPE TABLE OF INRIV,
            LT_INTERVAL TYPE TABLE OF INRIV,
            LS_INTERVAL LIKE LINE OF LT_INTERVAL.

            CLEAR ls_new_edit_nriv.

            LOOP AT gt_new_edit_nriv INTO ls_new_edit_nriv.

              IF ls_new_edit_nriv-select EQ 'X'.

                LV_OBJECT = ls_new_edit_nriv-object.

                IF LV_OBJECT NE 'BU_PARTNER'.
                  lv_otflag = abap_false.
                ENDIF.

                LS_INTERVAL-NRRANGENR = ls_new_edit_nriv-nrrangenr.
                LS_INTERVAL-TOYEAR = '0000'.
                LS_INTERVAL-FROMNUMBER = ls_new_edit_nriv-fromnumber.
                LS_INTERVAL-TONUMBER = ls_new_edit_nriv-tonumber.
                LS_INTERVAL-PROCIND = 'I'.
                APPEND LS_INTERVAL TO LT_INTERVAL.

                CALL FUNCTION 'NUMBER_RANGE_INTERVAL_UPDATE'
                  EXPORTING
                    OBJECT   = LV_OBJECT
                  TABLES
                    ERROR_IV = LT_ERROR
                    INTERVAL = LT_INTERVAL.

                IF SY-SUBRC EQ 0.

                  CALL FUNCTION 'NUMBER_RANGE_UPDATE_CLOSE'
                    EXPORTING
                      OBJECT = LV_OBJECT.

                ENDIF.

                CLEAR ls_interval.
                CLEAR lt_interval.

              ENDIF.

            ENDLOOP.


            MESSAGE 'The selected number range proposals have been saved in the database.' TYPE 'S'.

            IF lv_otflag EQ abap_true.
* Create table entry for storing one time use flag?
            ENDIF.

          ENDIF.

        ELSE.

          MESSAGE 'Number Range Number(s) entered already exists in the database. Enter new number(s).' TYPE 'E'.

        ENDIF.

      ENDIF.

      PERFORM CLEAR_NUMBER_RANGES.

    when 'CONFIG'.

      PERFORM CLEAR_NUMBER_RANGES.

    when 'DOCU_NR'.

      PERFORM show_documentation USING gc_general_text 'CVI_FS_GEN_NUM_ASSIGN'.
      PERFORM CLEAR_NUMBER_RANGES.

    when others.

      PERFORM CLEAR_NUMBER_RANGES.

  ENDCASE.

ENDMODULE.                 " USER_COMMAND_0230  INPUT
