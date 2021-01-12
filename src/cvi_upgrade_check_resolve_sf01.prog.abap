*----------------------------------------------------------------------*
***INCLUDE CVI_UPGRADE_CHECK_RESOLVE_SF01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SHOW_BPS_WITH_UNSUP_ROLES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SHOW_BPS_WITH_UNSUP_ROLES .



gs_layout_default-grid_title = 'Display BPs'.



  perform show_table_alv  using    gr_partners_alv
                                   gs_layout_default
                          changing gt_partners
                                   gt_partners_fcat.





ENDFORM.                    " SHOW_BPS_WITH_UNSUP_ROLES
