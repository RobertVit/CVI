*----------------------------------------------------------------------*
***INCLUDE CVI_FS_CHECK_CUSTOMIZING_ENO06.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module CUSTOMER_POST_VALUE_PBO_1110 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
module customer_post_value_pbo_1110 output.

  set pf-status 'STATUS_1110'.

  refresh :
            gt_fieldcat_post_log2,
            gt_outtab_post_log1110main.

  data : ls_log like line of gt_outtab_post_log.

  if gr_alv_post_log2 is not initial.
    call method gr_alv_post_log2->free.
    clear gr_alv_post_log2.
  endif.

  if gr_cont_post_log2 is not initial.
    call method gr_cont_post_log2->free.
    clear gr_cont_post_log2.
  endif.




***************ERROR START******************************************
  clear gs_fcat_map.
  gs_fcat_map-fieldname = 'ICON'.
  gs_fcat_map-coltext   = 'Type'.
  gs_fcat_map-col_pos = 1.
  gs_fcat_map-outputlen = 3.
  gs_fcat_map-icon = 'X'.
  append gs_fcat_map to gt_fieldcat_post_log2.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'CHK'.
  gs_fcat_map-coltext   = 'Check ID'.
  gs_fcat_map-col_pos = 2.
  gs_fcat_map-outputlen = 20.
  append gs_fcat_map to gt_fieldcat_post_log2.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'LOG'.
  gs_fcat_map-coltext   = 'Error Log'.
  gs_fcat_map-col_pos = 2.
  gs_fcat_map-outputlen = 20.
  gs_fcat_map-hotspot = 'X'.
  append gs_fcat_map to gt_fieldcat_post_log2.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'VALUE1'.
  gs_fcat_map-coltext   = 'Value Missing'.
  gs_fcat_map-col_pos = 2.
  gs_fcat_map-outputlen = 20.
  gs_fcat_map-hotspot = 'X'.
  append gs_fcat_map to gt_fieldcat_post_log2.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'TABLE'.
  gs_fcat_map-coltext   = 'Table Name'.
  gs_fcat_map-col_pos = 2.
  gs_fcat_map-outputlen = 20.
  gs_fcat_map-hotspot = 'X'.
  append gs_fcat_map to gt_fieldcat_post_log2.
  clear gs_fcat_map.

  create object gr_cont_post_log2
    exporting
      container_name = 'CUST_ERROR_POST'.

  create object gr_alv_post_log2
    exporting
      i_parent = gr_cont_post_log2.

****************ERROR END***********************


  delete adjacent duplicates from gt_outtab_post_log.

  if gv_checkid is initial.
    gt_outtab_post_log1110main[] = gt_outtab_post_log[].
  else.
    loop at gt_outtab_post_log into ls_log where chk = gv_checkid.
      append ls_log to gt_outtab_post_log1110main.
    endloop.
  endif.

  gs_layout_post_log2-grid_title = 'Error'.
  gs_layout_post_log2-no_toolbar = gc_true.

  perform show_table_alv using     gr_alv_post_log2
                                 gs_layout_post_log2
                        changing gt_outtab_post_log1110main[]
                                 gt_fieldcat_post_log2.
  set handler lcl_event_handler=>on_hotspot_post_log2 for gr_alv_post_log2.
endmodule.
*&---------------------------------------------------------------------*
*&      Module  CUSTOMER_POST_VALUE_PAI_1110  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module customer_post_value_pai_1110 input.

  case sy-ucomm.
    when 'CANCEL'.
      leave to screen 0.
    when 'DISPLAY'.
      perform save_post_data_error_log.
      leave to screen 0.
  endcase.
endmodule.

*&---------------------------------------------------------------------*
*& Form SAVE_POST_DATA_ERROR_LOG
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form save_post_data_error_log .
  data : ls_post like line of gt_outtab_post_log.
  data : lt_istype type table of bu_istype,
         ls_istype like line of lt_istype,
         lt_tb910  type table of tb910,
         ls_tb910  like line of lt_tb910,
         lt_tb912  type table of tb912,
         ls_tb912  like line of lt_tb912,
         lt_tb914  type table of tb914,
         ls_tb914  like line of lt_tb914,
         lt_tb916  type table of tb916,
         ls_tb916  like line of lt_tb916,
         lt_tb027  type table of tb027,
         ls_tb027  like line of lt_tb027,
         lt_tb019  type table of tb019,
         ls_tb019  like line of lt_tb019,
         lt_tb033  type table of tb033,
         ls_tb033  like line of lt_tb033.

  if gs_maintain is not initial.
    loop at gt_outtab_post_log into ls_post.

*******************TB910****************
      if ls_post-chk = 'CHK_CP_TB910' and ls_post-table = 'TB910'.
        ls_tb910-abtnr = ls_post-value1.
        ls_tb910-client = sy-mandt.
        append ls_tb910 to lt_tb910.
      endif.


*******************TB912****************
      if ls_post-chk = 'CHK_CP_TB912' and ls_post-table = 'TB912'.
        ls_tb912-pafkt = ls_post-value1.
        ls_tb912-client = sy-mandt.
        append ls_tb912 to lt_tb912.
      endif.

*******************TB914****************
      if ls_post-chk = 'CHK_CP_TB914' and ls_post-table = 'TB914'.
        ls_tb914-paauth = ls_post-value1.
        ls_tb914-client = sy-mandt.
        append ls_tb914 to lt_tb914.
      endif.

*******************TB916****************
      if ls_post-chk = 'CHK_CP_TB916' and ls_post-table = 'TB916'.
        ls_tb916-pavip = ls_post-value1.
        ls_tb916-client = sy-mandt.
        append ls_tb916 to lt_tb916.
      endif.

*******************TB027****************
      if ls_post-chk = 'CHK_CP_TB027' and ls_post-table = 'TB027'.
        ls_tb027-marst = ls_post-value1.
        ls_tb027-client = sy-mandt.
        append ls_tb027 to lt_tb027.
      endif.

*******************TB019****************
      if ls_post-chk = 'CHK_CP_TB019' and ls_post-table = 'TB019'.
        ls_tb019-legal_enty = ls_post-value1.
        ls_tb019-client = sy-mandt.
        append ls_tb019 to lt_tb019.
      endif.

*******************TB033****************
      if ls_post-chk = 'CHK_CP_TB033' and ls_post-table = 'TB033'.
        ls_tb033-ccins = ls_post-value1.
        ls_tb033-mandt = sy-mandt.
        append ls_tb033 to lt_tb033.
      endif.

    endloop.

*********MODIFICATION OF TABLES FROM THE POPUP DATA**************
    if lt_tb910 is not initial.
      modify tb910 from table lt_tb910.
    endif.

    if lt_tb912 is not initial.
      modify tb912 from table lt_tb912.
    endif.

    if lt_tb914 is not initial.
      modify tb914 from table lt_tb914.
    endif.

    if lt_tb916 is not initial.
      modify tb916 from table lt_tb916.
    endif.

    if lt_tb027 is not initial.
      modify tb027 from table lt_tb027.
    endif.

    if lt_tb019 is not initial.
      modify tb019 from table lt_tb019.
    endif.

  endif.
endform.
