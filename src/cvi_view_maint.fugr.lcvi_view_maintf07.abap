*----------------------------------------------------------------------*
***INCLUDE LCVI_VIEW_MAINTF07 .
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  check_cp2_link_initial
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM check_cp2_link_initial.

  TYPES: BEGIN OF t_cviv_cp2_link.
          INCLUDE STRUCTURE cviv_cp2_link.
  TYPES:  action(1) TYPE c.
  TYPES: END OF t_cviv_cp2_link.

  DATA:
    ls_cp2_link TYPE t_cviv_cp2_link.


  LOOP AT total INTO ls_cp2_link.

*   Do not process deleted entries
    IF ls_cp2_link-action = 'D'.
      CONTINUE.
    ENDIF.

*   Check non-key field values
    IF ls_cp2_link-gp_pafkt IS INITIAL.
      MESSAGE s026(cvi_mapping)
              WITH 'Funktion des Partners'(002)
              DISPLAY LIKE 'E'.
      sy-subrc = 4.
      RETURN.
    ENDIF.

  ENDLOOP.

ENDFORM.                    "check_cp2_link_initial
