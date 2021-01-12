*----------------------------------------------------------------------*
***INCLUDE CVI_UPGRADE_CHECK_RESOLVE_FF01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  FREE_ALVS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM FREE_ALVS .

  if gr_partners_cc is not initial.
    call method gr_partners_alv->free.
    clear gr_partners_alv.
  ENDIF.

  if gr_roles_cc is not initial.
    call method gr_roles_alv->free.
    clear gr_roles_alv.
  ENDIF.

  if gr_partners_log_cc is not initial.
    call method gr_partners_log_alv->free.
    clear gr_partners_log_alv.
  ENDIF.


ENDFORM.                    " FREE_ALVS
