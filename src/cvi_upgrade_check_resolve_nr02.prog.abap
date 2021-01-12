*----------------------------------------------------------------------*
***INCLUDE CVI_UPGRADE_CHECK_RESOLVE_NR02 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SHOW_OVERLAP_NUMBER_RANGES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SHOW_OVERLAP_NUMBER_RANGES .

  CALL METHOD CL_S4_CHECKS_BP_ENH=>COMPARE_NRIV
    EXPORTING
      IV_ACT_IND             = ' '
      IT_SOURCE_NRIV         = gt_source_nriv
      IT_DEPENDENT_NRIV      = gt_depend_nriv
    IMPORTING
      ET_OVERLAPPING_NRIV    = gt_overlap_nriv
      ET_NO_OVERLAPPING_NRIV = gt_non_overlap_nriv
      .

  CALL METHOD CL_S4_CHECKS_BP_ENH=>COMPARE_ALPHA_NRIV
    EXPORTING
      IV_ACT_IND             = ' '
      IT_SOURCE_NRIV         = gt_src_alpha_nriv
      IT_DEPENDENT_NRIV      = gt_dep_alpha_nriv
    IMPORTING
      ET_OVERLAPPING_NRIV    = gt_alpha_ov_nriv_res
      ET_NO_OVERLAPPING_NRIV = gt_alpha_nriv_no_res
      ET_NUM_ALPHA_INTV      = gt_new_num_alpha_nriv
    EXCEPTIONS
      INVALID_NR_FORMAT      = 1
      others                 = 2
          .

  APPEND LINES OF gt_overlap_nriv TO gt_all_overlaps.
  APPEND LINES OF gt_alpha_ov_nriv_res TO gt_all_overlaps.

  refresh gt_overlap_nriv_fcat.
  refresh gt_overlap_al_nriv_fcat.

  gs_fcat-fieldname = 'OBJECT'.
  gs_fcat-tabname = 'NRIV'.
  gs_fcat-col_pos = 1.
  gs_fcat-outputlen = 20.
  gs_fcat-coltext   = 'Number Range Object'.
  gs_fcat-ROLLNAME = 'OBJECT'.
  gs_fcat-DATATYPE = 'NROBJ'.
  append gs_fcat to  gt_overlap_nriv_fcat.
  append gs_fcat to  gt_overlap_al_nriv_fcat.
  clear gs_fcat.

  gs_fcat-fieldname = 'NRRANGENR'.
  gs_fcat-tabname = 'NRIV'.
  gs_fcat-col_pos = 2.
  gs_fcat-outputlen = 20.
  gs_fcat-coltext   = 'Number Range Number'.
  gs_fcat-ROLLNAME = 'NRRANGENR'.
  gs_fcat-DATATYPE = 'NRNR'.
  append gs_fcat to  gt_overlap_nriv_fcat.
  append gs_fcat to  gt_overlap_al_nriv_fcat.
  clear gs_fcat.

  gs_fcat-fieldname = 'DEPD_OBJECT'.
  gs_fcat-tabname = 'NRIV'.
  gs_fcat-col_pos = 3.
  gs_fcat-outputlen = 20.
  gs_fcat-coltext   = 'Overlapping Object'.
  gs_fcat-ROLLNAME = 'DEPD_OBJECT'.
  gs_fcat-DATATYPE = 'NROBJ'.
  append gs_fcat to  gt_overlap_nriv_fcat.
  append gs_fcat to  gt_overlap_al_nriv_fcat.
  clear gs_fcat.

  gs_fcat-fieldname = 'DEPD_NR'.
  gs_fcat-tabname = 'NRIV'.
  gs_fcat-col_pos = 4.
  gs_fcat-outputlen = 20.
  gs_fcat-coltext   = 'Overlapping Number'.
  gs_fcat-ROLLNAME = 'DEPD_NR'.
  gs_fcat-DATATYPE = 'NRNR'.
  append gs_fcat to  gt_overlap_nriv_fcat.
  append gs_fcat to  gt_overlap_al_nriv_fcat.
  clear gs_fcat.

  gs_fcat-fieldname = 'PERCENT'.
*  gs_fcat-tabname = 'NRIV'.
  gs_fcat-col_pos = 5.
  gs_fcat-outputlen = 20.
  gs_fcat-coltext   = 'Overlap %'.
  gs_fcat-ROLLNAME = 'PERCENT'.
*  gs_fcat-DATATYPE = 'NRNR'.
  append gs_fcat to  gt_overlap_nriv_fcat.
  append gs_fcat to  gt_overlap_al_nriv_fcat.
  clear gs_fcat.



* create container for overlapping number ranges
  if gr_overlap_nriv_cc is initial.
    create object gr_overlap_nriv_cc
      exporting
        container_name = 'CC_OVERLAP_NR'.
  endif.
  if gr_overlap_al_nriv_cc is initial.
    create object gr_overlap_al_nriv_cc
      exporting
        container_name = 'CC_OVERLAP_AL_NR'.
  endif.

*create ALV object for overlapping number ranges
  if  gr_overlap_nriv_alv is initial.
    create object  gr_overlap_nriv_alv
      exporting
        i_parent = gr_overlap_nriv_cc.
  endif.
  if  gr_overlap_al_nriv_alv is initial.
    create object  gr_overlap_al_nriv_alv
      exporting
        i_parent = gr_overlap_al_nriv_cc.
  endif.

  gs_layout_default-grid_title = 'Overlapping Numeric Number Ranges'.

  perform show_table_alv  using    gr_overlap_nriv_alv
                                   gs_layout_default
                          changing gt_overlap_nriv
                                   gt_overlap_nriv_fcat.

  gs_layout_default-grid_title = 'Overlapping Alphanumeric Number Ranges'.

  perform show_table_alv  using    gr_overlap_al_nriv_alv
                                   gs_layout_default
                          changing gt_alpha_ov_nriv_res
                                   gt_overlap_al_nriv_fcat.

ENDFORM.                    " SHOW_OVERLAP_NUMBER_RANGES
