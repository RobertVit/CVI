*----------------------------------------------------------------------*
***INCLUDE CVI_UPGRADE_CHECK_RESOLVE_NR04 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  CLEAR_NUMBER_RANGES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CLEAR_NUMBER_RANGES .

  if gr_total_nriv_cc is not initial.
    call method gr_total_nriv_alv->free.
    clear gr_total_nriv_alv.
  ENDIF.

  if gr_overlap_nriv_cc is not initial.
    call method gr_overlap_nriv_alv->free.
    clear gr_overlap_nriv_alv.
  ENDIF.

  if gr_overlap_al_nriv_cc is not initial.
    call method gr_overlap_al_nriv_alv->free.
    clear gr_overlap_al_nriv_alv.
  ENDIF.

  if gr_new_nriv_cc is not initial.
    call method gr_new_nriv_alv->free.
    clear gr_new_nriv_alv.
  ENDIF.

  CLEAR:  gt_src_alpha_nriv,
          gt_dep_alpha_nriv,
          gt_source_nriv,
          gt_depend_nriv,
          gt_total_nriv,
          gt_all_overlaps,
          gt_overlap_nriv,
          gt_non_overlap_nriv,
          gt_alpha_ov_nriv_res,
          gt_alpha_nriv_no_res,
          gt_new_num_alpha_nriv,
          gt_all_new_nriv,
          gt_new_edit_nriv,
          gt_new_nriv.

ENDFORM.                    " CLEAR_NUMBER_RANGES
