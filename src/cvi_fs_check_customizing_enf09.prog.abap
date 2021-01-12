*----------------------------------------------------------------------*
***INCLUDE CVI_FS_CHECK_CUSTOMIZING_ENF09.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form SELECT_DATA_CUSTOMER_POST
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form select_data_customer_post .
  data: cl_chk_map           type ref to cl_s4_checks_bp_enh,
        lt_check_results_map type table of ty_preprocessing_check_result,
        ls_check_results_map like line of lt_check_results_map,
        ls_tb910             like line of gt_tb910,
        ls_tb912             like line of gt_tb912,
        ls_tb914             like line of gt_tb914,
        ls_tb916             like line of gt_tb916,
        ls_tb027             like line of gt_tb027,
        ls_tb019             like line of gt_tb019,
*        ls_tb038a            like line of gt_tb038a,
        ls_tb033             like line of gt_tb033.

  refresh : gt_tb910,
          gt_tb912,
          gt_tb914,
          gt_tb916,
          gt_tb027,
          gt_tb019,
*          gt_tb038a,
          gt_tb033,
          gt_tb910_d,
          gt_tb912_d,
          gt_tb914_d,
          gt_tb916_d,
          gt_tb027_d,
          gt_tb019_d,
*          gt_tb038a_d,
          gt_tb033_d,
          gt_tb910_main,
          gt_tb912_main,
          gt_tb914_main,
          gt_tb916_main,
          gt_tb027_main,
          gt_tb019_main,
*          gt_tb038a_main,
          gt_tb033_main,
          gt_outtab_post_log,
          gt_outtab_post_log1100,
          gt_outtab_post_log1100main.

  refresh :  gt_fieldcat_tb910,
            gt_fieldcat_tb912,
            gt_fieldcat_tb914,
            gt_fieldcat_tb916,
            gt_fieldcat_tb027,
            gt_fieldcat_tb019,
            gt_fieldcat_tb033,
            gt_fieldcat_tb038a,
            gt_fieldcat_post_log2,
            gt_fieldcat_post_log1100.


*  if gr_alv_post_log2 is not initial.
*    call method gr_alv_post_log2->free.
*    clear gr_alv_post_log2.
*  endif.
*
*
*  if gr_alv_post_log1100 is not initial.
*    call method gr_alv_post_log1100->free.
*    clear gr_alv_post_log1100.
*  endif.

*if gv_flag_save = 2.
*  if gr_alv_tb910 is not initial.
*    call method gr_alv_tb910->free.
*    clear gr_alv_tb910.
*  endif.
*
*  if gr_alv_tb912 is not initial.
*    call method gr_alv_tb912->free.
*    clear gr_alv_tb912.
*  endif.
*
*  if gr_alv_tb914 is not initial.
*    call method gr_alv_tb914->free.
*    clear gr_alv_tb914.
*  endif.
*
*  if gr_alv_tb916 is not initial.
*    call method gr_alv_tb916->free.
*    clear gr_alv_tb910.
*  endif.
*
*  if gr_alv_tb027 is not initial.
*    call method gr_alv_tb027->free.
*    clear gr_alv_tb027.
*  endif.
*
*  if gr_alv_tb033 is not initial.
*    call method gr_alv_tb033->free.
*    clear gr_alv_tb033.
*  endif.
*
*  if gr_alv_tb019 is not initial.
*    call method gr_alv_tb019->free.
*    clear gr_alv_tb019.
*  endif.
*
*  if gr_alv_tb038a is not initial.
*    call method gr_alv_tb038a->free.
*    clear gr_alv_tb038a.
*  endif.
*endif.

*  if gr_cont_post_log2 is not initial.
*    call method gr_cont_post_log2->free.
*    clear gr_cont_post_log2.
*  endif.
*
*  if gr_cont_post_log1100 is not initial.
*    call method gr_cont_post_log1100->free.
*    clear gr_cont_post_log1100.
*  endif.

*if gv_flag_save = 2.
*  if gr_cont_tb910 is  not initial.
*    call method gr_cont_tb910->free.
*    clear gr_cont_tb910.
*  endif.
*
*    if gr_cont_tb912 is  not initial.
*    call method gr_cont_tb912->free.
*    clear gr_cont_tb912.
*  endif.
*
*    if gr_cont_tb914 is  not initial.
*    call method gr_cont_tb914->free.
*    clear gr_cont_tb914.
*  endif.
*
*    if gr_cont_tb916 is  not initial.
*    call method gr_cont_tb916->free.
*    clear gr_cont_tb916.
*  endif.
*
*    if gr_cont_tb027 is  not initial.
*    call method gr_cont_tb027->free.
*    clear gr_cont_tb027.
*  endif.
*
*    if gr_cont_tb019 is  not initial.
*    call method gr_cont_tb019->free.
*    clear gr_cont_tb019.
*  endif.
*
*    if gr_cont_tb033 is  not initial.
*    call method gr_cont_tb033->free.
*    clear gr_cont_tb033.
*  endif.
*
*    if gr_cont_tb038a is  not initial.
*    call method gr_cont_tb038a->free.
*    clear gr_cont_tb038a.
*  endif.
*endif.



  create object cl_chk_map.
  call method cl_chk_map->check_post_value_mapping
    importing
      ct_tb910         = gt_tb910
      ct_tb912         = gt_tb912
      ct_tb914         = gt_tb914
      ct_tb916         = gt_tb916
      ct_tb027         = gt_tb027
      ct_tb019         = gt_tb019
      ct_tb038a        = gt_tb038a
      ct_tb033         = gt_tb033
      ct_tb038a_out    = gt_tb038a_out
    changing
      ct_check_results = lt_check_results_map.


  sort gt_tb910 by abtnr.
  sort gt_tb912 by pafkt.
  sort gt_tb914 by bu_paauth.
  sort gt_tb916 by pavip.
  sort gt_tb027 by bu_marst.
  sort gt_tb019 by bu_legenty.
*  sort gt_tb038a by indkey.
*  sort gt_tb038a_out by indkey.
  sort gt_tb033 by ccins.

  delete adjacent duplicates from gt_tb910 comparing abtnr.
  delete adjacent duplicates from gt_tb912 comparing pafkt.
  delete adjacent duplicates from gt_tb914 comparing bu_paauth.
  delete adjacent duplicates from gt_tb916 comparing pavip.
  delete adjacent duplicates from gt_tb027 comparing bu_marst.
  delete adjacent duplicates from gt_tb019 comparing bu_legenty.
*  delete adjacent duplicates from gt_tb038a comparing indkey.
*  delete adjacent duplicates from gt_tb038a_out comparing indkey.
  delete adjacent duplicates from gt_tb033 comparing ccins.

  if gt_tb910_d is initial and gt_tb910 is not initial.
    select abtnr bez20 from tb911 into table gt_tb910_d  for all entries in gt_tb910
      where abtnr eq  gt_tb910-abtnr and spras = sy-langu."INTO TABLE gt_tb910_d.
  endif.

  if gt_tb912_d is initial and gt_tb912 is not initial.
    select pafkt bez30 from tb913 into table gt_tb912_d  for all entries in gt_tb912
      where pafkt eq  gt_tb912-pafkt and spras = sy-langu."INTO TABLE gt_tb910_d.
  endif.


  if gt_tb914_d  is initial and gt_tb914 is not initial.
    select paauth bez20 from tb915 into table gt_tb914_d  for all entries in gt_tb914
      where paauth eq  gt_tb914-bu_paauth and spras = sy-langu."INTO TABLE gt_tb910_d.
  endif.


  if gt_tb916_d  is initial and gt_tb916 is not initial.
    select pavip bez20 from tb917 into table gt_tb916_d  for all entries in gt_tb916
      where pavip eq  gt_tb916-pavip and spras = sy-langu."INTO TABLE gt_tb910_d.
  endif.


  if gt_tb027_d  is initial and gt_tb027 is not initial.
    select marst bez20 from tb027t into table gt_tb027_d  for all entries in gt_tb027
      where marst eq  gt_tb027-bu_marst and spras = sy-langu."INTO TABLE gt_tb910_d.
  endif.


  if gt_tb019_d  is initial and gt_tb019 is not initial.
    select legal_enty textlong from tb020 into table gt_tb019_d  for all entries in gt_tb019
      where legal_enty eq  gt_tb019-bu_legenty and spras = sy-langu."INTO TABLE gt_tb910_d.
  endif.


  if gt_tb033_d  is initial and gt_tb033 is not initial.
    select ccins from tb033 into table gt_tb033_d  for all entries in gt_tb033
      where ccins eq  gt_tb033-ccins and ccins not in ( select ccins from cvic_ccid_link ). "#EC CI_BUFFSUBQ. "INTO TABLE gt_tb910_d.
  endif.

*
*  if gt_tb038a_d  is initial and gt_tb038a is not initial.
*    select istype ind_sector text from tb038b into table gt_tb038a_d  for all entries in gt_tb038a
*      where istype eq  gt_tb038a-istype and spras = sy-langu."INTO TABLE gt_tb910_d.
*  endif.



endform.
