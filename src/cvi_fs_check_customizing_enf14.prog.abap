*----------------------------------------------------------------------*
***INCLUDE CVI_FS_CHECK_CUSTOMIZING_ENF14.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form SHOW_TEXT_ELEMENT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form show_text_element using i_parent type ref to cl_gui_custom_container
                             i_text type string.

 create object go_text_editor
        exporting
          parent                 = i_parent
*         lifetime               =
*         name                   =
        exceptions
          error_cntl_create      = 1
          error_cntl_init        = 2
          error_cntl_link        = 3
          error_dp_create        = 4
          gui_type_not_supported = 5
          others                 = 6.



      go_text_editor->set_toolbar_mode(
        exporting
          toolbar_mode           = 0   " visibility of toolbar; eq 0: OFF ; ne 0: ON
        exceptions
          error_cntl_call_method = 1
          invalid_parameter      = 2
          others                 = 3
      ).



      go_text_editor->set_statusbar_mode(
        exporting
          statusbar_mode         = 0   " visibility of statusbar; eq 0: OFF ; ne 0: ON
        exceptions
        error_cntl_call_method = 1
        invalid_parameter      = 2
        others                 = 3
      ).
*      gv_text_ac = 'CHK_CP_AC :ALL ENTRIES ARE SYNCHRONISED'.
      go_text_editor->set_textstream(
      exporting
        text = i_text ).


      go_text_editor->set_readonly_mode(
        exporting
          readonly_mode          = 1  " read-only mode; eq 0: OFF ; ne 0: ON
        exceptions
          error_cntl_call_method = 1
          invalid_parameter      = 2
          others                 = 3
      ).


endform.
