*----------------------------------------------------------------------*
***INCLUDE CVI_UPGRADE_CHECK_RESOLVE_SO02 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_1144  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module status_1144 output.
  set pf-status 'STAT_1144'.
*  SET TITLEBAR 'xxx'.
*  perform prepare_fcat.
  perform select_customer_data.
  perform create_customer_alv.
  perform show.
endmodule.                 " STATUS_1144  OUTPUT
*&---------------------------------------------------------------------*
*&      Form  PREPARE_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form prepare_fcat .

endform.                    " PREPARE_FCAT
*&---------------------------------------------------------------------*
*&      Form  SHOW
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form show .
*if gt_change eq 'X'.
*  gs_layout_default-grid_title = 'Inconsistencies in legal entity mapping for customets'.
  data: ls_outtab_cust_log like line of gt_outtab_cust_log.
  clear gt_outtab_cust_log.
  clear gt_outtab_cust_log[].
  perform show_table_alv  using    gr_alv_kna1
                                   gs_layout_default
                          changing gt_err_kna1
                                   gt_fcat_cvi_kna1.

  perform show_table_alv  using    gr_alv_knbk
                                   gs_layout_default
                          changing gt_err_knbk
                                   gt_fcat_cvi_knbk.

  perform show_table_alv  using    gr_alv_kna1_ind
                                   gs_layout_default
                        changing   gt_err_kna1_ind
                                   gt_fcat_cvi_kna1_ind.


  loop at screen.
    if screen-name eq 'BOX1'.
      if gt_err_kna1 is initial.
        ls_outtab_cust_log-log = 'Tax data is consistent'.
        ls_outtab_cust_log-chk = 'CHK_CUST_RET_TAX'.
        ls_outtab_cust_log-icon = gv_icon_green.
        ls_outtab_cust_log-value = '' .
        append ls_outtab_cust_log to gt_outtab_cust_log.
      else.
        ls_outtab_cust_log-log = 'Inconsistent Tax Fields: One or more of the following fields are inconsistent: STCD1, STCD2, STKZU, STCEG'.
        ls_outtab_cust_log-chk = 'CHK_CUST_RET_TAX'.
        ls_outtab_cust_log-icon = gv_icon_red.
        ls_outtab_cust_log-value = '' .
        append ls_outtab_cust_log to gt_outtab_cust_log.
      endif.
    endif.
    if screen-name eq 'BOX2'.
      if gt_err_kna1_ind is initial.
        ls_outtab_cust_log-log = 'Location/Industry data is consistent'.
        ls_outtab_cust_log-chk = 'CHK_CUST_RET_LOC'.
        ls_outtab_cust_log-icon = gv_icon_green.
        ls_outtab_cust_log-value = '' .
        append ls_outtab_cust_log to gt_outtab_cust_log.
      else.
        ls_outtab_cust_log-log = 'Inconsistent Location/Industry Fields: One or more of the following fields are inconsistent: BBBNR, BBSNR, BUBKZ, BRSCH, VBUND'.
        ls_outtab_cust_log-chk = 'CHK_CUST_RET_LOC'.
        ls_outtab_cust_log-icon = gv_icon_red.
        ls_outtab_cust_log-value = '' .
        append ls_outtab_cust_log to gt_outtab_cust_log.
      endif.
    endif.
    if screen-name eq 'BOX3'.
      if gt_err_knbk is initial.
        ls_outtab_cust_log-log = 'Bank data is consistent'.
        ls_outtab_cust_log-chk = 'CHK_CUST_RET_BANK'.
        ls_outtab_cust_log-icon = gv_icon_green.
        ls_outtab_cust_log-value = '' .
        append ls_outtab_cust_log to gt_outtab_cust_log.
      else.
        ls_outtab_cust_log-log = 'Inconsistent Bank Fields: One or more of the following fields are inconsistent: BANKS, BANKL, BANKN'.
        ls_outtab_cust_log-chk = 'CHK_CUST_RET_BANK'.
        ls_outtab_cust_log-icon = gv_icon_red.
        ls_outtab_cust_log-value = '' .
        append ls_outtab_cust_log to gt_outtab_cust_log.
      endif.
    endif.
    if screen-name eq 'TEXT'.
      if gt_err_kna1 is initial and gt_err_kna1_ind is initial and gt_err_knbk is initial.
        screen-active = '1'.
      else.
        screen-active = '0'.
      endif.
    endif.
    modify screen.
  endloop.



  perform show_table_alv using     gr_alv_cust_log
                               gs_layout_cust_log
                      changing gt_outtab_cust_log[]
                               gt_fieldcat_cust_log.
endform.                    " SHOW
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_1144  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module user_command_1144 input.
  case sy-ucomm .
    when 'EXIT'.
      leave to screen 0.
    when 'CANCEL'.
      set screen 520.
    when 'DOCU_RET'.
      perform show_documentation using gc_general_text 'CVI_CUS_INC_DATA'.
    when 'BACK'.
      if gr_cont_cust_kna1 is not initial.
        call method gr_alv_cust_kna1->free.
        clear gr_alv_cust_kna1.
      endif.
      if gr_cont_cust_kna1 is not initial.
        call method gr_cont_cust_kna1->free.
        clear gr_cont_cust_kna1.
      endif.

      if gr_cont_cust_knbk is not initial.
        call method gr_alv_cust_knbk->free.
        clear gr_alv_cust_knbk.
      endif.
      if gr_cont_cust_knbk is not initial.
        call method gr_cont_cust_knbk->free.
        clear gr_cont_cust_knbk.
      endif.
      if gr_cont_cust_log is not initial.
        call method gr_cont_cust_log->free.
        clear gr_cont_cust_log.
      endif.

      set screen 520.
    when gc_home.
      set screen 100.
*    when gc_exit.
*      leave program.
    when gc_prev.
      if gr_cont_cust_kna1 is not initial.
        call method gr_alv_cust_kna1->free.
        clear gr_alv_cust_kna1.
      endif.
      if gr_cont_cust_kna1 is not initial.
        call method gr_cont_cust_kna1->free.
        clear gr_cont_cust_kna1.
      endif.

      if gr_cont_cust_knbk is not initial.
        call method gr_alv_cust_knbk->free.
        clear gr_alv_cust_knbk.
      endif.
      if gr_cont_cust_knbk is not initial.
        call method gr_cont_cust_knbk->free.
        clear gr_cont_cust_knbk.
      endif.
      if gr_cont_cust_log is not initial.
        call method gr_cont_cust_log->free.
        clear gr_cont_cust_log.
      endif.


      set screen 520.

    when others.
  endcase.
endmodule.                 " USER_COMMAND_1144  INPUT
*&---------------------------------------------------------------------*
*&      Form  SELECT_CUSTOMER_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form select_customer_data .
  cl_ref->check_customer( importing  et1_kna1 = gt_err_kna1 et1_knbk = gt_err_knbk et1_kna1_ind = gt_err_kna1_ind changing c_change = gt_change ).
endform.                    " SELECT_CUSTOMER_DATA
*&---------------------------------------------------------------------*
*&      Form  CREATE_CUSTOMER_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form create_customer_alv .
  refresh gt_fcat_cvi_kna1.
  refresh gt_fcat_cvi_knbk.
  refresh gt_fcat_cvi_kna1_ind.
  clear gs_fcat.
  clear gr_cont_cust_log.
  clear gr_alv_cust_log.
  gs_fcat-fieldname = 'KUNNR'.
  gs_fcat-tabname = 'KNA1'.
  gs_fcat-col_pos = 1.
  gs_fcat-coltext   = 'Customer Number'(044).
  gs_fcat-rollname = 'KUNNR'.
  gs_fcat-datatype = 'KUNNR'.
  append gs_fcat to gt_fcat_cvi_kna1.

  clear gs_fcat.
  gs_fcat-fieldname = 'KUNNR'.
  gs_fcat-tabname = 'KNBK'.
  gs_fcat-col_pos = 1.
  gs_fcat-coltext   = 'Customer Number'(044).
  gs_fcat-rollname = 'KUNNR'.
  gs_fcat-datatype = 'KUNNR'.
  append gs_fcat to gt_fcat_cvi_knbk.

  clear gs_fcat.
  gs_fcat-fieldname = 'KUNNR'.
  gs_fcat-tabname = 'KNA1'.
  gs_fcat-col_pos = 1.
  gs_fcat-coltext   = 'Customer Number'(044).
  gs_fcat-rollname = 'KUNNR'.
  gs_fcat-datatype = 'KUNNR'.
  append gs_fcat to gt_fcat_cvi_kna1_ind.


  if gr_cvi_kna1 is initial.
    create object gr_cvi_kna1
      exporting
        container_name = 'ALV_KNA1_GRID'.
  endif.
  if  gr_alv_kna1 is initial.
    create object gr_alv_kna1
      exporting
        i_parent = gr_cvi_kna1.
  endif.

  if gr_cvi_kna1_ind is initial.
    create object gr_cvi_kna1_ind
      exporting
        container_name = 'ALV_KNA1_IND_GRID'.
  endif.
  if  gr_alv_kna1_ind is initial.
    create object gr_alv_kna1_ind
      exporting
        i_parent = gr_cvi_kna1_ind.
  endif.

*create container for Customer link
  if gr_cvi_knbk is initial.
    create object gr_cvi_knbk
      exporting
        container_name = 'ALV_KNBK_GRID'.
  endif.
*create ALV object for Customer link
  if  gr_alv_knbk is initial.
    create object gr_alv_knbk
      exporting
        i_parent = gr_cvi_knbk.
  endif.

  "Error Log
  clear: gs_fcat_map , gt_fieldcat_cust_log.

  gs_fcat_map-fieldname = 'ICON'.
  gs_fcat_map-coltext   = 'Type'(014).
  gs_fcat_map-col_pos = 1.
  gs_fcat_map-outputlen = 3.
  gs_fcat_map-icon = 'X'.
  append gs_fcat_map to gt_fieldcat_cust_log.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'CHK'.
  gs_fcat_map-coltext   = 'Check ID'(015).
  gs_fcat_map-col_pos = 2.
  gs_fcat_map-outputlen = 30.
  append gs_fcat_map to gt_fieldcat_cust_log.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'LOG'.
  gs_fcat_map-coltext   = 'Error Log'(016).
  gs_fcat_map-col_pos = 2.
  gs_fcat_map-outputlen = 150.
  gs_fcat_map-hotspot = 'X'.
  append gs_fcat_map to gt_fieldcat_cust_log.
  clear gs_fcat_map.

  if gr_cont_cust_log is initial.
    create object gr_cont_cust_log
      exporting
        container_name = 'CUST_RET_ERR'.
  endif.

  if gr_alv_cust_log is initial.
    create object gr_alv_cust_log
      exporting
        i_parent = gr_cont_cust_log.
  endif.
endform.                    " CREATE_CUSTOMER_ALV
