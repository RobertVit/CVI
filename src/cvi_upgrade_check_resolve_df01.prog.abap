*----------------------------------------------------------------------*
***INCLUDE CVI_UPGRADE_CHECK_RESOLVE_DF01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  DELETE_REOLE_ASSIGMENTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DELETE_REOLE_ASSIGMENTS .

data : ls_selected_roles LIKE LINE OF gt_selected_roles.

LOOP at gt_selected_roles INTO ls_selected_roles WHERE delete = 'X'.

delete from but100 WHERE rltyp = ls_selected_roles-rltyp.

if sy-subrc IS INITIAL.

delete gt_selected_roles WHERE rltyp = ls_selected_roles-rltyp. " Clean the GT

  ELSE.
    "show error message.
  ENDIF.

ENDLOOP.

ENDFORM.                    " DELETE_REOLE_ASSIGMENTS
