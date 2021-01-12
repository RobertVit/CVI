*----------------------------------------------------------------------*
***INCLUDE CVI_FS_CHECK_CUSTOMIZING_ENI01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_CUSTOMER_0700  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module user_command_customer_0700 input.
  case ok_code.
    when gc_info. "documentation for both directions
      perform show_documentation using gc_general_text 'CVI_FS_C_C_CUSTOMER'.
    when  gc_customizing. "goto customizing
      perform show_documentation using gc_general_text 'CVI_FS_C_C_GO_TO_CUSTOMIZING'.
    when gc_docu1. "documentation BP->Customer
      perform show_documentation using gc_general_text 'CVI_FS_C_C_BP_TO_CUSTOMER'.
    when gc_docu2. "documentation Customer->BP
      perform show_documentation using gc_general_text 'CVI_FS_C_C_CUSTOMER_TO_BP'.
    when gc_back.
      set screen 100. "start screen
      when gc_next.
      set screen 1100.
       when gc_prev.
      set screen 100.
       when gc_home.
      set screen 100.
    when gc_exit.
      leave program.
  endcase.
endmodule.
