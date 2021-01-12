*----------------------------------------------------------------------*
***INCLUDE LCVI_VIEW_MAINTF08 .
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  check_cp3_link_initial
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM check_cp3_link_initial.

  TYPES: BEGIN OF t_cviv_cp3_link.
          INCLUDE STRUCTURE cviv_cp3_link.
  TYPES:  action(1) TYPE c.
  TYPES: END OF t_cviv_cp3_link.

  DATA:
    ls_cp3_link TYPE t_cviv_cp3_link.


  LOOP AT total INTO ls_cp3_link.

*   Do not process deleted entries
    IF ls_cp3_link-action = 'D'.
      CONTINUE.
    ENDIF.

*   Check non-key field values
    IF ls_cp3_link-paauth IS INITIAL.
      MESSAGE s026(cvi_mapping)
              WITH 'Vollmacht des Partners'(003)
              DISPLAY LIKE 'E'.
      sy-subrc = 4.
      RETURN.
    ENDIF.

  ENDLOOP.

ENDFORM.                    "check_cp3_link_initial
