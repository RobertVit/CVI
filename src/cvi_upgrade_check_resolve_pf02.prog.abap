*----------------------------------------------------------------------*
***INCLUDE CVI_UPGRADE_CHECK_RESOLVE_PF02 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  PREP_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM PREP_LOG .


"prepration for Log
REFRESH gt_fieldcat_cust_log.
  clear: gs_fcat_map.

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

if gr_partners_log_cc is initial.
    create object gr_partners_log_cc
      exporting
        container_name = 'ROLES_ERR_LOG_CC'.
  endif.

  if gr_partners_log_alv is initial.
    create object gr_partners_log_alv
      exporting
        i_parent = gr_partners_log_cc.
ENDIF.


ENDFORM.                    " PREP_LOG
