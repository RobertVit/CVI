*----------------------------------------------------------------------*
***INCLUDE CVI_FS_CHECK_CUSTOMIZING_ENO09.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module CUSTOMER_POST_VALUE_PBO_1130 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
module customer_post_value_pbo_1130 output.

   set pf-status 'STATUS_1110'.

  refresh :
            gt_fieldcat_post_log1130.


  clear : gs_maintain_1130.

  if gr_alv_post_log1130 is not initial.
    call method gr_alv_post_log1130->free.
    clear gr_alv_post_log1130.
  endif.

  if gr_cont_post_log1130 is not initial.
    call method gr_cont_post_log1130->free.
    clear gr_cont_post_log1130.
  endif.




***************ERROR START******************************************
  clear gs_fcat_map.
  gs_fcat_map-fieldname = 'ICON'.
  gs_fcat_map-coltext   = 'Type'.
  gs_fcat_map-col_pos = 1.
  gs_fcat_map-outputlen = 3.
  gs_fcat_map-icon = 'X'.
  append gs_fcat_map to gt_fieldcat_post_log1130.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'CHK'.
  gs_fcat_map-coltext   = 'Check ID'.
  gs_fcat_map-col_pos = 2.
  gs_fcat_map-outputlen = 20.
  append gs_fcat_map to gt_fieldcat_post_log1130.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'LOG'.
  gs_fcat_map-coltext   = 'Error Log'.
  gs_fcat_map-col_pos = 2.
  gs_fcat_map-outputlen = 20.
  gs_fcat_map-hotspot = 'X'.
  append gs_fcat_map to gt_fieldcat_post_log1130.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'VALUE1'.
  gs_fcat_map-coltext   = 'Missing Industry Type'.
  gs_fcat_map-col_pos = 2.
  gs_fcat_map-outputlen = 20.
  gs_fcat_map-hotspot = 'X'.
  append gs_fcat_map to gt_fieldcat_post_log1130.
  clear gs_fcat_map.

   gs_fcat_map-fieldname = 'VALUE2'.
  gs_fcat_map-coltext   = 'Missing Industry Sector'.
  gs_fcat_map-col_pos = 2.
  gs_fcat_map-outputlen = 20.
  gs_fcat_map-hotspot = 'X'.
  append gs_fcat_map to gt_fieldcat_post_log1130.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'TABLE'.
  gs_fcat_map-coltext   = 'Table Name'.
  gs_fcat_map-col_pos = 2.
  gs_fcat_map-outputlen = 20.
  gs_fcat_map-hotspot = 'X'.
  append gs_fcat_map to gt_fieldcat_post_log1130.
  clear gs_fcat_map.

  create object gr_cont_post_log1130
    exporting
      container_name = 'CUST_ERROR_POST_1130'.

  create object gr_alv_post_log1130
    exporting
      i_parent = gr_cont_post_log1130.

****************ERROR END***********************

  gs_layout_post_log1130-grid_title = 'Error'.
  gs_layout_post_log1130-no_toolbar = gc_true.

  perform show_table_alv using     gr_alv_post_log1130
                                 gs_layout_post_log1130
                        changing gt_outtab_post_out_log1130[]
                                 gt_fieldcat_post_log1130.

  set handler lcl_event_handler=>on_hotspot_post_log1120 for gr_alv_post_log1130.

endmodule.
*&---------------------------------------------------------------------*
*&      Module  CUSTOMER_POST_VALUE_PAI_1130  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module customer_post_value_pai_1130 input.
  case sy-ucomm.
    when 'CANCEL'.
      leave to screen 0.
    when 'DISPLAY'.
      perform save_post_data_err_1130.
      leave to screen 0.
  endcase.
endmodule.
*&---------------------------------------------------------------------*
*&      Module  DATA_SAVE_PAI_1130  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module data_save_pai_1130 input.

endmodule.
*&---------------------------------------------------------------------*
*& Form SAVE_POST_DATA_ERR_1130
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form save_post_data_err_1130 .
  data : ls_post like line of gt_outtab_post_log.
  data : lt_istype type table of bu_istype,
         ls_istype like line of lt_istype,
         lt_tb038a type table of tb038a,
         ls_tb038a like line of lt_tb038a.

  if gs_maintain_1130 is not initial.
    loop at gt_outtab_post_out_log1130 into ls_post.
      if ls_post-table = 'TB038A'.
        ls_tb038a-istype = ls_post-value1.
        ls_tb038a-IND_SECTOR = ls_post-value2.
        ls_tb038a-client = sy-mandt.
        append ls_tb038a to lt_tb038a.
      endif.
    endloop.

    if lt_tb038a is not initial.
      modify tb038a from table lt_tb038a.
    endif.
  endif.
endform.
