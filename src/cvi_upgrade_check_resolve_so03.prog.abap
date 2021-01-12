*----------------------------------------------------------------------*
***INCLUDE CVI_UPGRADE_CHECK_RESOLVE_SO03 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_1145  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module status_1145 output.
  set pf-status 'STAT_1145'.
*  SET TITLEBAR 'xxx'.

  perform select_supplier_data.
  perform create_supplier_alv.
  perform show_supplier_alv.

endmodule.                 " STATUS_1145  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_1145  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module user_command_1145 input.
  case sy-ucomm .
    when 'EXIT'.
      leave to screen 0.
    when 'CANCEL'.
      set screen 610.
    when 'DOCU_RET'.
      perform show_documentation using gc_general_text 'CVI_SUP_INC_DATA'.
    when 'BACK'.

      if gr_cont_cust_lfa1 is not initial.
        call method gr_alv_cust_lfa1->free.
        clear gr_alv_cust_lfa1.
      endif.
      if gr_cont_cust_lfa1 is not initial.
        call method gr_cont_cust_lfa1->free.
        clear gr_cont_cust_lfa1.

        if gr_cont_cust_lfbk is not initial.
          call method gr_alv_cust_lfbk->free.
          clear gr_alv_cust_lfbk.
        endif.
      endif.
      if gr_cont_cust_lfbk is not initial.
        call method gr_cont_cust_lfbk->free.
        clear gr_cont_cust_lfbk.
      endif.
       if gr_cont_cust_log is not initial.
          call method gr_cont_cust_log->free.
          clear gr_cont_cust_log.
        endif.
      set screen 610.


    when gc_home.
      set screen 100.
*    when gc_exit.
*      leave program.
    when gc_prev.
      if gr_cont_cust_lfa1 is not initial.
        call method gr_alv_cust_lfa1->free.
        clear gr_alv_cust_lfa1.
      endif.
      if gr_cont_cust_lfa1 is not initial.
        call method gr_cont_cust_lfa1->free.
        clear gr_cont_cust_lfa1.

        if gr_cont_cust_lfbk is not initial.
          call method gr_alv_cust_lfbk->free.
          clear gr_alv_cust_lfbk.
        endif.
      endif.
      if gr_cont_cust_lfbk is not initial.
        call method gr_cont_cust_lfbk->free.
        clear gr_cont_cust_lfbk.
      endif.
       if gr_cont_cust_log is not initial.
          call method gr_cont_cust_log->free.
          clear gr_cont_cust_log.
        endif.
      set screen 610.
    when others.
  endcase.

endmodule.                 " USER_COMMAND_1145  INPUT
*&---------------------------------------------------------------------*
*&      Form  SHOW_SUPPLIER_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form show_supplier_alv .
  clear gt_outtab_cust_log.
  clear gt_outtab_cust_log[].
  data: ls_outtab_cust_log like line of gt_outtab_cust_log.
  perform show_table_alv  using    gr_alv_lfa1
                                 gs_layout_default
                        changing gt_err_lfa1
                                 gt_fcat_cvi_lfa1.

*     gs_layout_default-grid_title = 'Suppliers'.
  perform show_table_alv  using    gr_alv_lfbk
                                 gs_layout_default
                        changing gt_err_lfbk
                                 gt_fcat_cvi_lfbk.

  perform show_table_alv  using    gr_alv_lfa1_ind
                                 gs_layout_default
                        changing gt_err_lfa1_ind
                                 gt_fcat_cvi_lfa1_ind.
  loop at screen.
    if screen-name eq 'BOX1'.
      if gt_err_lfa1 is initial.
        ls_outtab_cust_log-log = 'No Inconsistencies in tax data'.
        ls_outtab_cust_log-chk = 'CHK_SUP_RET_TAX'.
        ls_outtab_cust_log-icon = gv_icon_green.
        ls_outtab_cust_log-value = '' .
        append ls_outtab_cust_log to gt_outtab_cust_log.
      else.
        ls_outtab_cust_log-log = 'Inconsistent Tax Fields: One or more of the following fields are inconsistent: STCD1, STCD2, STKZU, STCEG'.
        ls_outtab_cust_log-chk = 'CHK_SUP_RET_TAX'.
        ls_outtab_cust_log-icon = gv_icon_red.
        ls_outtab_cust_log-value = '' .
        append ls_outtab_cust_log to gt_outtab_cust_log.
      endif.
    endif.
    if screen-name eq 'BOX2'.
      if gt_err_lfa1_ind is initial.
        ls_outtab_cust_log-log = 'No Inconsistencies in location/industry data'.
        ls_outtab_cust_log-chk = 'CHK_SUP_RET_LOC'.
        ls_outtab_cust_log-icon = gv_icon_green.
        ls_outtab_cust_log-value = '' .
        append ls_outtab_cust_log to gt_outtab_cust_log.
      else.
        ls_outtab_cust_log-log = 'Inconsistent Location/Industry Fields: One or more of the following fields are inconsistent: BBBNR, BBSNR, BUBKZ, BRSCH, VBUND'.
        ls_outtab_cust_log-chk = 'CHK_SUP_RET_LOC'.
        ls_outtab_cust_log-icon = gv_icon_red.
        ls_outtab_cust_log-value = '' .
        append ls_outtab_cust_log to gt_outtab_cust_log.
      endif.
    endif.
    if screen-name eq 'BOX3'.
      if gt_err_lfbk is initial.
        ls_outtab_cust_log-log = 'No Inconsistencies in bank data'.
        ls_outtab_cust_log-chk = 'CHK_SUP_RET_BANK'.
        ls_outtab_cust_log-icon = gv_icon_green.
        ls_outtab_cust_log-value = '' .
        append ls_outtab_cust_log to gt_outtab_cust_log.
      else.
        ls_outtab_cust_log-log = 'Inconsistent Bank Fields: One or more of the following fields are inconsistent: BANKS, BANKL, BANKN'.
        ls_outtab_cust_log-chk = 'CHK_SUP_RET_BANK'.
        ls_outtab_cust_log-icon = gv_icon_red.
        ls_outtab_cust_log-value = '' .
        append ls_outtab_cust_log to gt_outtab_cust_log.
      endif.
    endif.

    if screen-name eq 'TEXT'.
      if gt_err_lfa1 is initial and gt_err_lfa1_ind is initial and gt_err_lfbk is initial.
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
endform.                    " SHOW_SUPPLIER_ALV
*&---------------------------------------------------------------------*
*&      Form  SELECT_SUPPLIER_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form select_supplier_data .
  cl_ref->check_supplier( importing  et_lfa1 = gt_err_lfa1 et_lfbk = gt_err_lfbk et_lfa1_ind = gt_err_lfa1_ind changing c_change_1 = gt_change ).
endform.                    " SELECT_SUPPLIER_DATA
*&---------------------------------------------------------------------*
*&      Form  CREATE_SUPPLIER_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form create_supplier_alv .
  refresh gt_fcat_cvi_lfa1.
  refresh gt_fcat_cvi_lfbk.
  refresh gt_fcat_cvi_lfa1_ind.
  clear gr_alv_cust_log.
  clear gr_cont_cust_log.
  clear gs_fcat.
  gs_fcat-fieldname = 'LIFNR'.
  gs_fcat-tabname = 'LFA1'.
  gs_fcat-col_pos = 1.
  gs_fcat-coltext   = 'Supplier Number'.
  gs_fcat-rollname = 'LIFNR'.
  gs_fcat-datatype = 'LIFNR'.
  append gs_fcat to gt_fcat_cvi_lfa1.

  clear gs_fcat.
  gs_fcat-fieldname = 'LIFNR'.
  gs_fcat-tabname = 'LFBK'.
  gs_fcat-col_pos = 1.
  gs_fcat-coltext   = 'Supplier Number'.
  gs_fcat-rollname = 'LIFNR'.
  gs_fcat-datatype = 'LIFNR'.
  append gs_fcat to gt_fcat_cvi_lfbk.

  clear gs_fcat.
  gs_fcat-fieldname = 'LIFNR'.
  gs_fcat-tabname = 'LFBK'.
  gs_fcat-col_pos = 1.
  gs_fcat-coltext   = 'Supplier Number'.
  gs_fcat-rollname = 'LIFNR'.
  gs_fcat-datatype = 'LIFNR'.
  append gs_fcat to gt_fcat_cvi_lfa1_ind.

*create container for Customer link
  if gr_cvi_lfa1 is initial.
    create object gr_cvi_lfa1
      exporting
        container_name = 'ALV_LFA1_GRID'.
  endif.
*create ALV object for Customer link
  if  gr_alv_lfa1 is initial.
    create object gr_alv_lfa1
      exporting
        i_parent = gr_cvi_lfa1.
  endif.

  if gr_cvi_lfa1_ind is initial.
    create object gr_cvi_lfa1_ind
      exporting
        container_name = 'ALV_LFA1_IND_GRID'.
  endif.
*create ALV object for Customer link
  if  gr_alv_lfa1_ind is initial.
    create object gr_alv_lfa1_ind
      exporting
        i_parent = gr_cvi_lfa1_ind.
  endif.

*create container for Customer link
  if gr_cvi_lfbk is initial.
    create object gr_cvi_lfbk
      exporting
        container_name = 'ALV_LFBK_GRID'.
  endif.
*create ALV object for Customer link
  if  gr_alv_lfbk is initial.
    create object gr_alv_lfbk
      exporting
        i_parent = gr_cvi_lfbk.
  endif.

  "Error Log
  clear: gs_fcat_map , gt_fieldcat_cust_log.

  gs_fcat_map-fieldname = 'ICON'.
  gs_fcat_map-coltext   = 'Ty.'.
  gs_fcat_map-col_pos = 1.
  gs_fcat_map-outputlen = 3.
  gs_fcat_map-icon = 'X'.
  append gs_fcat_map to gt_fieldcat_cust_log.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'CHK'.
  gs_fcat_map-coltext   = 'Check ID'.
  gs_fcat_map-col_pos = 2.
  gs_fcat_map-outputlen = 30.
  append gs_fcat_map to gt_fieldcat_cust_log.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'LOG'.
  gs_fcat_map-coltext   = 'Error Log'.
  gs_fcat_map-col_pos = 2.
  gs_fcat_map-outputlen = 150.
  gs_fcat_map-hotspot = 'X'.
  append gs_fcat_map to gt_fieldcat_cust_log.
  clear gs_fcat_map.

  if gr_cont_cust_log is initial.
    create object gr_cont_cust_log
      exporting
        container_name = 'SUPP_RET_ERR'.
  endif.

  if gr_alv_cust_log is initial.
    create object gr_alv_cust_log
      exporting
        i_parent = gr_cont_cust_log.
  endif.
endform.                    " CREATE_SUPPLIER_ALV
