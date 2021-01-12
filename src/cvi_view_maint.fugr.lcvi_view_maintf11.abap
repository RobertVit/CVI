*----------------------------------------------------------------------*
***INCLUDE LCVI_VIEW_MAINTF11 .
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  check_legform_link_initial
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM check_legform_link_initial.

  TYPES: BEGIN OF t_cviv_legform_link.
          INCLUDE STRUCTURE cviv_legform_lnk.
  TYPES:  action(1) TYPE c.
  TYPES: END OF t_cviv_legform_link.

  DATA:
    ls_legform_link TYPE t_cviv_legform_link.


  LOOP AT total INTO ls_legform_link.

*   Do not process deleted entries
    IF ls_legform_link-action = 'D'.
      CONTINUE.
    ENDIF.

*   Check non-key field values
    IF ls_legform_link-legal_enty IS INITIAL.
      MESSAGE s026(cvi_mapping)
              WITH 'GP: Rechtsform der Organisation'(006)
              DISPLAY LIKE 'E'.
      sy-subrc = 4.
      RETURN.
    ENDIF.

  ENDLOOP.

ENDFORM.                    "check_legform_link_initial
