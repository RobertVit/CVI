*----------------------------------------------------------------------*
***INCLUDE ZTEST_PRE_CHECK_USER_COMMANI01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module user_command_0100 input.
**********************************************************************************************************
*****************************************************RECORDS DISPLAY START********************************
**********************************************************************************************************
  if gv_kna1 is initial.
    select count(*) from kna1 client specified into gv_kna1 .
  endif.

  if gv_kna1_retail is initial.
    select count(*) from kna1 client specified into gv_kna1_retail where kunnr ne '' and not werks = space..
  endif.

  select count(*) from kna1 as a client specified into gv_cust_link where lifnr = '' and
    kunnr not in ( select customer from cvi_cust_link as b client specified where a~mandt = b~client and a~kunnr = b~customer ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

  if gv_lfa1 is initial.
    select count(*) from lfa1 client specified into gv_lfa1 .
  endif.

  if gv_lfa1_retail is initial.
    select COUNT(*) from lfa1 client specified into gv_lfa1_retail where lifnr ne '' and not werks = space.
  endif.

    select count(*) from lfa1 as a client specified into gv_vend_link where kunnr = '' and
      lifnr not in ( select vendor from cvi_vend_link as b client specified where a~mandt = b~client and a~lifnr = b~vendor  ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

    gv_kna1_final = gv_kna1 - ( gv_cust_link + gv_kna1_retail ).

    gv_lfa1_final = gv_lfa1 - ( gv_vend_link + gv_lfa1_retail ).

  gs_kna1 = gv_kna1.
  gs_kna1_final = gv_kna1_final.

  gs_lfa1 = gv_lfa1.
  gs_lfa1_final = gv_lfa1_final.

  concatenate 'CVI MAPPING [ customer ' ' ( '  gs_kna1_final '/'  gs_kna1  ' )'  ' vendor ' ' ( '  gs_lfa1_final '/'  gs_lfa1  ' ) ]' into gv_check_cust.

**********************************************************************************************************
*****************************************************RECORDS DISPLAY END********************************
**********************************************************************************************************


  DATA: ls_color TYPE LVC_S_SCOL.
  ls_color-color-col = 3.
  ls_color-fname = 'ERR_TYPE'.

  case ok_code.
    when 'CURR_CLIENT'.
      gv_current_client = gv_current_client.
    when 'EXIT' or 'CANCEL' or 'BACK'.

      leave to screen 0.

    when 'EXECUTE'.
      clear gs_check.
      refresh gt_check_final.


      gs_check_final-chkid = 'CHK_1'.
      gs_check_final-chk_name = 'BP roles are assigned to account groups'.
      gs_check_final-status = '@EB@' .
      gs_check_final-err_type = 'Customizing Error'.
      append ls_color to gs_check_final-color.
      append gs_check_final to gt_check_final.

      clear gs_check_final.
      gs_check_final-chkid = 'CHK_2'.
      gs_check_final-chk_name = 'Every account group BP Grouping must be available'.
      gs_check_final-status = '@EB@' .
      gs_check_final-err_type = 'Customizing Error'.
      append ls_color to gs_check_final-color.
      append gs_check_final to gt_check_final.

      clear gs_check_final.
      gs_check_final-chkid = 'CHK_4'.
      gs_check_final-chk_name = 'Customer value mapping'.
      gs_check_final-status = '@EB@' .
      gs_check_final-err_type = 'Customizing Error'.
      append ls_color to gs_check_final-color.
      append gs_check_final to gt_check_final.

      clear gs_check_final.
      gs_check_final-chkid = 'CHK_5'.
      gs_check_final-chk_name = 'Vendor value mapping'.
      gs_check_final-status = '@EB@' .
      gs_check_final-err_type = 'Customizing Error'.
      append ls_color to gs_check_final-color.
      append gs_check_final to gt_check_final.
      clear gs_check_final.


      gs_check_final-chkid = 'CHK_10'.
      gs_check_final-chk_name = 'Customer and Vendor Value mapping(BP->Customer or Vendor)'.
      gs_check_final-status = '@EB@' .
      gs_check_final-err_type = 'Customizing Error'.
      append ls_color to gs_check_final-color.
      append gs_check_final to gt_check_final.
      clear gs_check_final.

      gs_check_final-chkid = 'CHK_12'.
      gs_check_final-chk_name = 'CVI Link'.
      gs_check_final-status = '@EB@' .
      gs_check_final-err_type = 'Customizing Error'.
      append ls_color to gs_check_final-color.
      append gs_check_final to gt_check_final.



*      gs_check_final-chkid = 'CHK_13'.
*      gs_check_final-chk_name = gv_check_cust.
*      gs_check_final-status = '@EB@' .
*      append gs_check_final to gt_check_final.
*
*
*      gs_check_final-chkid = 'CHK_14'.
*      gs_check_final-chk_name = gv_check_vend.
*      gs_check_final-status = '@EB@' .
*      append gs_check_final to gt_check_final.

      clear gs_check_final.
      refresh gt_check_msg.
      gs_check_final-chkid = 'CHK_3'.
      gs_check_final-chk_name = gv_check_cust.
      gs_check_final-status = '@EB@' .
      gs_check_final-err_type = 'Data Error'.
      append gs_check_final to gt_check_final.

      clear gs_check_final.
      gs_check_final-chkid = 'CHK_6'.
      gs_check_final-chk_name = 'Contact Person Mapping'.
      gs_check_final-status = '@EB@' .
      gs_check_final-err_type = 'Data Error'.
      append gs_check_final to gt_check_final.
      clear gs_check_final.

*      gs_check_final-chkid = 'CHK_7'.
*      gs_check_final-chk_name = text-031."'vendor value mapping'.
*      gs_check_final-status = '@EB@' .
*      append gs_check_final to gt_check_final.
*      clear gs_check_final.
*
*      gs_check_final-chkid = 'CHK_8'.
*      gs_check_final-chk_name = text-032."'vendor value mapping'.
*      gs_check_final-status = '@EB@' .
*      append gs_check_final to gt_check_final.
*      clear gs_check_final.
*
*      gs_check_final-chkid = 'CHK_9'.
*      gs_check_final-chk_name = text-033."'vendor value mapping'.
*      gs_check_final-status = '@EB@' .
*      append gs_check_final to gt_check_final.
*      clear gs_check_final.



*      gs_check_final-chkid = 'CHK_11'.
*      gs_check_final-chk_name = text-035."'vendor value mapping'.
*      gs_check_final-status = '@EB@' .
*      append gs_check_final to gt_check_final.
*      clear gs_check_final.

*      loop at gt_check into gs_check where check is not initial.
*
*
*        if   gs_check-chkid  = 'CHK_1' .
*          perform chk_op1 .
*        elseif gs_check-chkid  = 'CHK_2'.
*          perform chk_op2.
*        elseif gs_check-chkid  =  'CHK_3'.
*          perform chk_op3.
*        elseif gs_check-chkid  =  'CHK_4'.
*          perform chk_op4.
*        elseif gs_check-chkid  = 'CHK_5'.
*          perform chk_op5.
*        elseif gs_check-chkid  = 'CHK_6'.
*          perform chk_op6.
**        ELSEIF gs_check-chkid = 'CHK_7'.
**          PERFORM chk_op7.
**        ELSEIF gs_check-chkid = 'CHK_8'.
**          PERFORM chk_op8.
**        ELSEIF gs_check-chkid = 'CHK_9'.
**          PERFORM chk_op9.
*        elseif gs_check-chkid = 'CHK_10'.
*          perform chk_op10.
**        ELSEIF gs_check-chkid = 'CHK_11'.
**          PERFORM chk_op11.
*        endif.
*      endloop.




      perform check_status.

      field-symbols : <ls_final> like line of gt_check_final.

      loop at gt_check into gs_check.
        if gs_check-check <> 'X'.
          read table gt_check_final assigning <ls_final> with key chkid = gs_check-chkid.
          <ls_final>-status = '@EB@'.
          <ls_final>-stat_chk = ''.
        endif.
      endloop.


clear: gs_check, gs_check_final.
      loop at gt_check into gs_check where check is not initial.

        case gs_check-chkid.
            if gs_check-chkid = 'CHK_1'.
              loop at gt_msg_check into gs_msg_check.
                if gs_msg_check-chkid = 'CHK_1'.
                  read table gt_check_final assigning <ls_final> with key chkid = 'CHK_1'.
                  if sy-subrc = 0.
                    <ls_final>-status = '@0A@'.
                    <ls_final>-stat_chk = 'E'.
                  else.
                    <ls_final>-status = '@08@'.
                  endif.
                endif.
              endloop.
            elseif gs_check-chkid = 'CHK_2'.
              loop at gt_msg_check into gs_msg_check.
                if gs_msg_check-chkid = 'CHK_2'.
                  read table gt_check_final assigning <ls_final> with key chkid = 'CHK_2'.
                  if sy-subrc = 0.
                    <ls_final>-status = '@0A@'.
                    <ls_final>-stat_chk = 'E'.
                  else.
                    <ls_final>-status = '@08@'.
                  endif.
                endif.
              endloop.
            elseif gs_check-chkid = 'CHK_3'.
              loop at gt_msg_check into gs_msg_check.
                if gs_msg_check-chkid = 'CHK_3'.
                  read table gt_check_final assigning <ls_final> with key chkid = 'CHK_3'.
                  if sy-subrc = 0.
                    <ls_final>-status = '@0A@'.
                    <ls_final>-stat_chk = 'E'.
                  else.
                    <ls_final>-status = '@08@'.
                  endif.
                endif.
              endloop.
            elseif gs_check-chkid = 'CHK_4'.
              loop at gt_msg_check into gs_msg_check.
                if gs_msg_check-chkid = 'CHK_4'.
                  read table gt_check_final assigning <ls_final> with key chkid = 'CHK_4'.
                  if sy-subrc = 0.
                    <ls_final>-status = '@0A@'.
                    <ls_final>-stat_chk = 'E'.
                  else.
                    <ls_final>-status = '@08@'.
                  endif.
                endif.
              endloop.
            elseif gs_check-chkid = 'CHK_5'.
              loop at gt_msg_check into gs_msg_check.
                if gs_msg_check-chkid = 'CHK_5'.
                  read table gt_check_final assigning <ls_final> with key chkid = 'CHK_5'.
                  if sy-subrc = 0.
                    <ls_final>-status = '@0A@'.
                    <ls_final>-stat_chk = 'E'.
                  else.
                    <ls_final>-status = '@08@'.
                  endif.
                endif.
              endloop.
            elseif gs_check-chkid = 'CHK_6'.
              loop at gt_msg_check into gs_msg_check.
                if gs_msg_check-chkid = 'CHK_6'.
                  read table gt_check_final assigning <ls_final> with key chkid = 'CHK_6'.
                  if sy-subrc = 0.
                    <ls_final>-status = '@0A@'.
                    <ls_final>-stat_chk = 'E'.
                  else.
                    <ls_final>-status = '@08@'.
                  endif.
                endif.
              endloop.
            elseif gs_check-chkid = 'CHK_12'.
              loop at gt_msg_check into gs_msg_check.
                if gs_msg_check-chkid = 'CHK_12'.
                  read table gt_check_final assigning <ls_final> with key chkid = 'CHK_12'.
                  if sy-subrc = 0 and <ls_final>-stat_chk = 'E'.
                    <ls_final>-status = '@0A@'.
                    <ls_final>-stat_chk = 'E'.
                  else.
                    <ls_final>-status = '@08@'.
                  endif.
                endif.
              endloop.
            elseif gs_check-chkid = 'CHK_13'.
              loop at gt_msg_check into gs_msg_check.
                if gs_msg_check-chkid = 'CHK_13'.
                  read table gt_check_final assigning <ls_final> with key chkid = 'CHK_13'.
                  if sy-subrc = 0 and <ls_final>-stat_chk = 'E'.
                    <ls_final>-status = '@0A@'.
                    <ls_final>-stat_chk = 'E'.
                  else.
                    <ls_final>-status = '@08@'.
                  endif.
                endif.
              endloop.
            elseif gs_check-chkid = 'CHK_14'.
              loop at gt_msg_check into gs_msg_check.
                if gs_msg_check-chkid = 'CHK_14'.
                  read table gt_check_final assigning <ls_final> with key chkid = 'CHK_14'.
                  if sy-subrc = 0 and <ls_final>-stat_chk = 'E'.
                    <ls_final>-status = '@0A@'.
                    <ls_final>-stat_chk = 'E'.
                  else.
                    <ls_final>-status = '@08@'.
                  endif.
                endif.
              endloop.
            elseif gs_check-chkid = 'CHK_10'.
              loop at gt_msg_check into gs_msg_check.
                if gs_msg_check-chkid = 'CHK_10'.
                  read table gt_check_final assigning <ls_final> with key chkid = 'CHK_10'.
                  if sy-subrc = 0.
                    <ls_final>-status = '@0A@'.
                    <ls_final>-stat_chk = 'E'.
                  else.
                    <ls_final>-status = '@08@'.
                  endif.
                endif.
              endloop.
            endif.
        endcase.
      endloop.
      call screen 200.
  endcase.

endmodule.                    "user_command_0100 INPUT
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module user_command_0200 input.
  case ok_code_200.
    when 'BACK' or 'CANCEL' or 'EXIT'.
      refresh gt_check.
      refresh gt_check_final.
      clear gv_title.
      clear gv_current_client.
      leave to screen 0.
  endcase.

endmodule.                    "user_command_0200 INPUT
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0201  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module user_command_0201 input.
  case ok_code_0201.
    when 'CANCEL' .
      leave to screen 0.
    when others .
      leave to screen 0.
  endcase.
endmodule.                    "user_command_0201 INPUT
