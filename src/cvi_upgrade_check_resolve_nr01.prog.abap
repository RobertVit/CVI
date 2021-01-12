*----------------------------------------------------------------------*
***INCLUDE CVI_UPGRADE_CHECK_RESOLVE_NR01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SHOW_ALL_NUMBER_RANGES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SHOW_ALL_NUMBER_RANGES .

  CALL METHOD CL_S4_CHECKS_BP_ENH=>GET_ALL_CVI_NRIV_FILTER
    EXPORTING
      IV_BP_IND         = 'X'
      IV_REV_IND        = ' '
    IMPORTING
      ET_SRC_ALPHA_NRIV = gt_src_alpha_nriv
      ET_DPD_ALPHA_NRIV = gt_dep_alpha_nriv
      ET_SRC_NRIV       = gt_source_nriv
      ET_DPD_NRIV       = gt_depend_nriv
    EXCEPTIONS
      WRONG_NRIV_FORMAT = 1
      others            = 2
          .
  IF SY-SUBRC <> 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  APPEND LINES OF gt_src_alpha_nriv TO gt_total_nriv.
  APPEND LINES OF gt_dep_alpha_nriv TO gt_total_nriv.
  APPEND LINES OF gt_source_nriv TO gt_total_nriv.
  APPEND LINES OF gt_depend_nriv TO gt_total_nriv.


  SORT gt_total_nriv.
  SORT gt_source_nriv BY fromnumber.
  SORT gt_depend_nriv BY fromnumber.

  refresh gt_total_nriv_fcat.

  gs_fcat-fieldname = 'OBJECT'.
  gs_fcat-tabname = 'NRIV'.
  gs_fcat-col_pos = 1.
  gs_fcat-outputlen = 20.
  gs_fcat-coltext   = 'Number Range Object'(041).
  gs_fcat-ROLLNAME = 'OBJECT'.
  gs_fcat-DATATYPE = 'NROBJ'.
  append gs_fcat to  gt_total_nriv_fcat.
  clear gs_fcat.

  gs_fcat-fieldname = 'NRRANGENR'.
  gs_fcat-tabname = 'NRIV'.
  gs_fcat-col_pos = 2.
  gs_fcat-outputlen = 20.
  gs_fcat-coltext   = 'Number Range Number'.
  gs_fcat-ROLLNAME = 'NRRANGENR'.
  gs_fcat-DATATYPE = 'NRNR'.
  append gs_fcat to  gt_total_nriv_fcat.
  clear gs_fcat.

  gs_fcat-fieldname = 'FROMNUMBER'.
  gs_fcat-tabname = 'NRIV'.
  gs_fcat-col_pos = 3.
  gs_fcat-outputlen = 40.
  gs_fcat-coltext   = 'From Number'(042).
  gs_fcat-ROLLNAME = 'FROMNUMBER'.
  gs_fcat-DATATYPE = 'NRFROM'.
  append gs_fcat to  gt_total_nriv_fcat.
  clear gs_fcat.

  gs_fcat-fieldname = 'TONUMBER'.
  gs_fcat-tabname = 'NRIV'.
  gs_fcat-col_pos = 4.
  gs_fcat-outputlen = 40.
  gs_fcat-coltext   = 'To Number'(043).
  gs_fcat-ROLLNAME = 'TONUMBER'.
  gs_fcat-DATATYPE = 'NRTO'.
  append gs_fcat to  gt_total_nriv_fcat.
  clear gs_fcat.

  gs_fcat-fieldname = 'NRLEVEL'.
  gs_fcat-tabname = 'NRIV'.
  gs_fcat-col_pos = 5.
  gs_fcat-outputlen = 80.
  gs_fcat-coltext   = 'Number Range Status'.
  gs_fcat-ROLLNAME = 'TONUMBER'.
  gs_fcat-DATATYPE = 'NRLEVEL'.
  append gs_fcat to  gt_total_nriv_fcat.
  clear gs_fcat.

  gs_fcat-fieldname = 'EXTERNIND'.
  gs_fcat-tabname = 'NRIV'.
  gs_fcat-col_pos = 5.
  gs_fcat-outputlen = 20.
  gs_fcat-coltext   = 'External Range'(039).
  gs_fcat-ROLLNAME = 'EXTERNIND'.
  gs_fcat-DATATYPE = 'NRIND'.
  append gs_fcat to  gt_total_nriv_fcat.
  clear gs_fcat.


* create container for existing number ranges
  if gr_total_nriv_cc is initial.
    create object gr_total_nriv_cc
      exporting
        container_name = 'CC_EXISTING_NR'.
  endif.

*create ALV object for existing number ranges
  if  gr_total_nriv_alv is initial.
    create object  gr_total_nriv_alv
      exporting
        i_parent = gr_total_nriv_cc.
  endif.

  gs_layout_default-grid_title = 'Existing Number Ranges'.

  perform show_table_alv  using    gr_total_nriv_alv
                                   gs_layout_default
                          changing gt_total_nriv
                                   gt_total_nriv_fcat.

ENDFORM.                    " SHOW_ALL_NUMBER_RANGES
