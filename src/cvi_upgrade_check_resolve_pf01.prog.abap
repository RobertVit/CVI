*----------------------------------------------------------------------*
***INCLUDE CVI_UPGRADE_CHECK_RESOLVE_PF01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  PREP_ROLES_FOR_UNASSIGNMENT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM PREP_ROLES_FOR_UNASSIGNMENT .


refresh gt_roles_fcat.
  gs_fcat-fieldname = 'CHECKBOX'.
  gs_fcat-col_pos = 1.
  gs_fcat-coltext   = 'Select'.
  gs_fcat-TOOLTIP = 'Select roles'.
  gs_fcat-CHECKBOX = 'X'.
  gs_fcat-edit = 'X'.
  append gs_fcat to  gt_roles_fcat.
  clear gs_fcat.


  gs_fcat-fieldname = 'RLTYP'.
  gs_fcat-tabname = 'BUT100'.
  gs_fcat-col_pos = 2.
  gs_fcat-outputlen = 13.
  gs_fcat-coltext   = 'Role'.
  gs_fcat-ROLLNAME = 'RLTYP'.
  gs_fcat-DATATYPE = 'BU_PARTNERROLE'.
  append gs_fcat to  gt_roles_fcat.
  clear gs_fcat.

if gr_roles_cc is initial.
  create object gr_roles_cc
    exporting
      container_name = 'ROLES_CUSTOM_CONTROL'.
endif.
*create ALV object for unsupported roles
if  gr_roles_alv is initial.
  create object  gr_roles_alv
    exporting
      i_parent = gr_roles_cc.
endif.





ENDFORM.                    " PREP_ROLES_FOR_UNASSIGNMENT
