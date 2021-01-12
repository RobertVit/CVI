*----------------------------------------------------------------------*
***INCLUDE CVI_FS_CHECK_CUSTOMIZING_ENF13.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form SHOW_DATA_CUSTOMER_POST
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form show_data_customer_post .
  gs_layout_default_map-cwidth_opt = gc_false.
  gs_layout_default_map-smalltitle = '1'.
  data : ls_log like line of gt_outtab_post_log,
         flag   type c.

*  DATA: lt_dep_drpdwn TYPE lvc_t_drop,
*        ls_dep_drpdwn TYPE lvc_s_drop,
*        lt_tsab         TYPE TABLE OF tsab,
*        ls_tsab         LIKE LINE OF lt_tsab,
*        lt_tsabt         TYPE TABLE OF tsabt,
*        ls_tsabt        LIKE LINE OF lt_tsabt,
*        lv_cvi_dep_desc   TYPE VTEXT.
*
*  SELECT DISTINCT * FROM tsab INTO CORRESPONDING FIELDS OF TABLE lt_tsab WHERE abtnr IS NOT NULL.
*  SELECT DISTINCT * FROM tsabt  INTO CORRESPONDING FIELDS OF TABLE lt_tsabt  WHERE spras = sy-langu AND abtnr IS NOT NULL.

*  LOOP AT lt_tsab INTO ls_tsab.
*    READ TABLE lt_tsabt INTO ls_tsabt WITH KEY abtnr = ls_tsab-abtnr.
*    CONCATENATE ls_tsab-abtnr ls_tsabt-vtext INTO lv_cvi_dep_desc SEPARATED BY space.
*    ls_dep_drpdwn-handle = '2'.
*    ls_dep_drpdwn-value = lv_cvi_dep_desc.
*    APPEND ls_dep_drpdwn TO lt_dep_drpdwn.
*  ENDLOOP.

if gr_alv_tb910 is INITIAL.
  create object gr_alv_tb910
    exporting
      i_parent = gr_cont_tb910.
  endif.

*if gr_alv_tb910 IS BOUND.
*
*  call METHOD gr_alv_tb910->set_drop_down_table
*      EXPORTING
*        it_drop_down = lt_dep_drpdwn.
*
*  ENDIF.

  gs_layout_default_map-no_toolbar = gc_true.
  gs_layout_default_map-grid_title = 'Missing Department Numbers for Contact Person'.

  set handler lcl_event_handler=>on_click_tb910 for gr_alv_tb910.

  perform show_table_alv  using    gr_alv_tb910
                                 gs_layout_default_map
                        changing gt_outtab_tb910[]"gt_tb910_main[]
                                 gt_fieldcat_tb910.

*  DATA: lt_fn_drpdwn TYPE lvc_t_drop,
*        ls_fn_drpdwn TYPE lvc_s_drop,
*        lt_tpfk         TYPE TABLE OF tpfk,
*        ls_tpfk         LIKE LINE OF lt_tpfk,
*        lt_tpfkt         TYPE TABLE OF tpfkt,
*        ls_tpfkt        LIKE LINE OF lt_tpfkt,
*        lv_cvi_fn_desc   TYPE VTEXT.
*
*  SELECT DISTINCT * FROM tpfk INTO CORRESPONDING FIELDS OF TABLE lt_tpfk WHERE pafkt IS NOT NULL.
*  SELECT DISTINCT * FROM tpfkt  INTO CORRESPONDING FIELDS OF TABLE lt_tpfkt  WHERE spras = sy-langu AND pafkt IS NOT NULL.
*
*  LOOP AT lt_tpfk INTO ls_tpfk.
*    READ TABLE lt_tpfkt INTO ls_tpfkt WITH KEY pafkt = ls_tpfk-pafkt.
*    CONCATENATE ls_tpfk-pafkt ls_tpfkt-vtext INTO lv_cvi_fn_desc SEPARATED BY space.
*    ls_fn_drpdwn-handle = '2'.
*    ls_fn_drpdwn-value = lv_cvi_fn_desc.
*    APPEND ls_fn_drpdwn TO lt_fn_drpdwn.
*  ENDLOOP.


if gr_alv_tb912 is INITIAL.
  create object gr_alv_tb912
    exporting
      i_parent = gr_cont_tb912.
  ENDIF.

*if gr_alv_tb912 IS BOUND.
*    call METHOD gr_alv_tb912->set_drop_down_table
*      EXPORTING
*        it_drop_down = lt_fn_drpdwn.
*
*  ENDIF.
  gs_layout_default_map-grid_title = 'Missing Functions of Contact Person'.

  set handler lcl_event_handler=>on_click_tb912 for gr_alv_tb912.

  perform show_table_alv  using    gr_alv_tb912
                                   gs_layout_default_map
                          changing gt_outtab_tb912[]
                                   gt_fieldcat_tb912.



*  DATA: lt_auth_drpdwn TYPE lvc_t_drop,
*        ls_auth_drpdwn TYPE lvc_s_drop,
*        lt_tvpv         TYPE TABLE OF tvpv,
*        ls_tvpv        LIKE LINE OF lt_tvpv,
*        lt_tvpvt         TYPE TABLE OF tvpvt,
*        ls_tvpvt        LIKE LINE OF lt_tvpvt,
*        lv_cvi_auth_desc   TYPE VTEXT.
*
*  SELECT DISTINCT * FROM tvpv INTO CORRESPONDING FIELDS OF TABLE lt_tvpv WHERE parvo IS NOT NULL.
*  SELECT DISTINCT * FROM tvpvt  INTO CORRESPONDING FIELDS OF TABLE lt_tvpvt  WHERE spras = sy-langu AND parvo IS NOT NULL.
*
*  LOOP AT lt_tvpv INTO ls_tvpv.
*    READ TABLE lt_tvpvt INTO ls_tvpvt WITH KEY parvo = ls_tvpv-parvo.
*    CONCATENATE ls_tvpv-parvo ls_tvpvt-vtext INTO lv_cvi_auth_desc SEPARATED BY space.
*    ls_auth_drpdwn-handle = '2'.
*    ls_auth_drpdwn-value = lv_cvi_auth_desc.
*    APPEND ls_auth_drpdwn TO lt_auth_drpdwn.
*  ENDLOOP.




if gr_alv_tb914 is INITIAL.
  create object gr_alv_tb914
    exporting
      i_parent = gr_cont_tb914.
  endif.

*if gr_alv_tb914 IS BOUND.
*    call METHOD gr_alv_tb914->set_drop_down_table
*      EXPORTING
*        it_drop_down = lt_auth_drpdwn.
*
*  ENDIF.

  gs_layout_default_map-grid_title = 'Missing Authority of Contact Person'.

  set handler lcl_event_handler=>on_click_tb914 for gr_alv_tb914.

  perform show_table_alv  using    gr_alv_tb914
                                   gs_layout_default_map
                          changing gt_outtab_tb914[]
                                   gt_fieldcat_tb914.




*  DATA: lt_vip_drpdwn TYPE lvc_t_drop,
*        ls_vip_drpdwn TYPE lvc_s_drop,
*        lt_tvip         TYPE TABLE OF tvip,
*        ls_tvip        LIKE LINE OF lt_tvip,
*        lt_tvipt         TYPE TABLE OF tvipt,
*        ls_tvipt        LIKE LINE OF lt_tvipt,
*        lv_cvi_vip_desc   TYPE VTEXT.
*
*  SELECT DISTINCT * FROM tvip INTO CORRESPONDING FIELDS OF TABLE lt_tvip WHERE pavip IS NOT NULL.
*  SELECT DISTINCT * FROM tvipt  INTO CORRESPONDING FIELDS OF TABLE lt_tvipt  WHERE spras = sy-langu AND pavip IS NOT NULL.
*
*  LOOP AT lt_tvip INTO ls_tvip.
*    READ TABLE lt_tvipt INTO ls_tvipt WITH KEY pavip = ls_tvip-pavip.
*    CONCATENATE ls_tvip-pavip ls_tvipt-vtext INTO lv_cvi_vip_desc SEPARATED BY space.
*    ls_vip_drpdwn-handle = '2'.
*    ls_vip_drpdwn-value = lv_cvi_vip_desc.
*    APPEND ls_vip_drpdwn TO lt_vip_drpdwn.
*  ENDLOOP.




if gr_alv_tb916 is INITIAL.
  create object gr_alv_tb916
    exporting
      i_parent = gr_cont_tb916.
  endif.




  gs_layout_default_map-grid_title = 'Missing VIP Indicator for Contact Person'.

  set handler lcl_event_handler=>on_click_tb916 for gr_alv_tb916.

  perform show_table_alv  using    gr_alv_tb916
                                   gs_layout_default_map
                          changing gt_outtab_tb916[]
                                   gt_fieldcat_tb916.


*  DATA: lt_famst_drpdwn TYPE lvc_t_drop,
*        ls_famst_drpdwn TYPE lvc_s_drop,
*        lt_t052t         TYPE TABLE OF t052t,
*        ls_t052t       LIKE LINE OF lt_t052t,
**        lt_tvipt         TYPE TABLE OF tvipt,
**        ls_tvipt        LIKE LINE OF lt_tvipt,
*        lv_cvi_famst_desc   TYPE VTEXT.

*  SELECT DISTINCT * FROM tvip INTO CORRESPONDING FIELDS OF TABLE lt_tvip WHERE pavip IS NOT NULL.
*  SELECT DISTINCT * FROM t052t  INTO CORRESPONDING FIELDS OF TABLE lt_t052t  WHERE spras = sy-langu AND famst IS NOT NULL.

*  LOOP AT lt_tvip INTO ls_tvip.
*    READ TABLE lt_tvipt INTO ls_tvipt WITH KEY pavip = ls_tvip-pavip.
*    CONCATENATE ls_tvip-pavip ls_tvipt-vtext INTO lv_cvi_vip_desc SEPARATED BY space.
*    ls_vip_drpdwn-handle = '2'.
*    ls_vip_drpdwn-value = lv_cvi_vip_desc.
*    APPEND ls_vip_drpdwn TO lt_vip_drpdwn.
*  ENDLOOP.


if gr_alv_tb027 is INITIAL.
  create object gr_alv_tb027
    exporting
      i_parent = gr_cont_tb027.
  endif.
  gs_layout_default_map-grid_title = 'Missing Marital Statuses'.

  set handler lcl_event_handler=>on_click_tb027 for gr_alv_tb027.

  perform show_table_alv  using    gr_alv_tb027
                                   gs_layout_default_map
                          changing gt_tb027_main[]
                                   gt_fieldcat_tb027.


*  DATA: lt_stat_drpdwn TYPE lvc_t_drop,
*        ls_stat_drpdwn TYPE lvc_s_drop,
*        lt_tvgf        TYPE TABLE OF tvgf ,
*        ls_tvgf         LIKE LINE OF lt_tvgf ,
*        lt_tvgft         TYPE TABLE OF tvgft,
*        ls_tvgft        LIKE LINE OF lt_tvgft,
*        lv_cvi_stat_desc   TYPE VTEXT.
*
*  SELECT DISTINCT * FROM tvgf INTO CORRESPONDING FIELDS OF TABLE lt_tvgf WHERE gform IS NOT NULL.
*  SELECT DISTINCT * FROM tvgft  INTO CORRESPONDING FIELDS OF TABLE lt_tvgft  WHERE spras = sy-langu AND gform IS NOT NULL.
*
*  LOOP AT lt_tvgf INTO ls_tvgf.
*    READ TABLE lt_tvgft INTO ls_tvgft WITH KEY gform = ls_tvgf-gform.
*    CONCATENATE ls_tvgf-gform ls_tvgft-vtext INTO lv_cvi_stat_desc SEPARATED BY space.
*    ls_stat_drpdwn-handle = '2'.
*    ls_stat_drpdwn-value = lv_cvi_stat_desc.
*    APPEND ls_stat_drpdwn TO lt_stat_drpdwn.
*  ENDLOOP.
*


if gr_alv_tb019 is INITIAL.
  create object gr_alv_tb019
    exporting
      i_parent = gr_cont_tb019.
  endif.

*    if gr_alv_tb019 IS BOUND.
*      call METHOD gr_alv_tb019->set_drop_down_table
*      EXPORTING
*        it_drop_down = lt_stat_drpdwn.
*  ENDIF.

  gs_layout_default_map-grid_title = 'Missing Legal Form to Legal Status'.

  set handler lcl_event_handler=>on_click_tb019 for gr_alv_tb019.

  perform show_table_alv  using    gr_alv_tb019
                                   gs_layout_default_map
                          changing gt_outtab_tb019[]
                                   gt_fieldcat_tb019.

*  DATA: lt_pcard_drpdwn TYPE lvc_t_drop,
*        ls_pcard_drpdwn TYPE lvc_s_drop,
*        lt_tvcin        TYPE TABLE OF tvcin ,
*        ls_tvcin        LIKE LINE OF lt_tvcin ,
*        lt_tvcint         TYPE TABLE OF tvcint,
*        ls_tvcint        LIKE LINE OF lt_tvcint,
*        lv_cvi_pcard_desc   TYPE VTEXT.
*
*  SELECT DISTINCT * FROM tvcin INTO CORRESPONDING FIELDS OF TABLE lt_tvcin WHERE ccins IS NOT NULL.
*  SELECT DISTINCT * FROM tvcint  INTO CORRESPONDING FIELDS OF TABLE lt_tvcint  WHERE spras = sy-langu AND ccins IS NOT NULL.
*
*  LOOP AT lt_tvcin INTO ls_tvcin.
*    READ TABLE lt_tvcint INTO ls_tvcint WITH KEY ccins = ls_tvcin-ccins.
*    CONCATENATE ls_tvcin-ccins ls_tvcint-vtext INTO lv_cvi_pcard_desc SEPARATED BY space.
*    ls_pcard_drpdwn-handle = '2'.
*    ls_pcard_drpdwn-value = lv_cvi_pcard_desc.
*    APPEND ls_pcard_drpdwn TO lt_pcard_drpdwn.
*  ENDLOOP.
*

if gr_alv_tb033 is INITIAL.
  create object gr_alv_tb033
    exporting
      i_parent = gr_cont_tb033.
  endif.

*     if gr_alv_tb033 IS BOUND.
*      call METHOD gr_alv_tb033->set_drop_down_table
*      EXPORTING
*        it_drop_down = lt_pcard_drpdwn.
*  ENDIF.
  gs_layout_default_map-grid_title = 'Missing Payment Cards'.

  set handler lcl_event_handler=>on_click_tb033 for gr_alv_tb033.

  perform show_table_alv  using    gr_alv_tb033
                                   gs_layout_default_map
                          changing gt_outtab_tb033[]
                                   gt_fieldcat_tb033.

  clear : ls_log,
          flag.

gs_layout_post_log1100-no_toolbar = gc_true.

  if gv_checkid is initial.
    gt_outtab_post_log1100main[] = gt_outtab_post_log1100[].
  else.
    loop at gt_outtab_post_log1100 into ls_log where chk = gv_checkid.
      append ls_log to gt_outtab_post_log1100main.
    endloop.
  endif.

  perform show_table_alv using     gr_alv_post_log1100
                                 gs_layout_post_log1100
                        changing gt_outtab_post_log1100main[]
                                 gt_fieldcat_post_log1100.
endform.
