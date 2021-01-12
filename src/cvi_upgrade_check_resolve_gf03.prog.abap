*----------------------------------------------------------------------*
***INCLUDE CVI_UPGRADE_CHECK_RESOLVE_GF03 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_ROLES_FOR_UNASSIGNMENT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_ROLES_FOR_UNASSIGNMENT .

data : ls_partners like LINE OF gt_partners,
       ls_roles like LINE OF gt_roles.

refresh gt_roles.
IF gt_partners is not INITIAL.

loop at gt_partners INTO ls_partners.
CLEAR ls_roles.
ls_roles-rltyp = LS_PARTNERS-rltyp.
APPEND ls_roles to gt_roles.
CLEAR ls_partners.

ENDLOOP.

SORT gt_roles by rltyp.
delete ADJACENT DUPLICATES FROM gt_roles comparing RLTYP .

if gv_retain_selection = ' '.
gt_selected_roles[] = gt_roles[].
endif.

else.
  refresh gt_roles.
  ENDIF.

ENDFORM.                    " GET_ROLES_FOR_UNASSIGNMENT
