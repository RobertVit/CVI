*----------------------------------------------------------------------*
***INCLUDE LCVI_VIEW_MAINTF06 .
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  check_cp1_link_initial
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM check_cp1_link_initial.

  TYPES: BEGIN OF t_cviv_cp1_link.
          INCLUDE STRUCTURE cviv_cp1_link.
  TYPES:  action(1) TYPE c.
  TYPES: END OF t_cviv_cp1_link.

  DATA:
    ls_cp1_link TYPE t_cviv_cp1_link.


  LOOP AT total INTO ls_cp1_link.

*   Do not process deleted entries
    IF ls_cp1_link-action = 'D'.
      CONTINUE.
    ENDIF.

*   Check non-key field values
    IF ls_cp1_link-gp_abtnr IS INITIAL.
      MESSAGE s026(cvi_mapping)
              WITH 'Abteilung'(001)
              DISPLAY LIKE 'E'.
      sy-subrc = 4.
      RETURN.
    ENDIF.

  ENDLOOP.

ENDFORM.                    "check_cp1_link_initial
