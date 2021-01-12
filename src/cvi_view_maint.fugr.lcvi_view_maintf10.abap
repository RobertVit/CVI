*----------------------------------------------------------------------*
***INCLUDE LCVI_VIEW_MAINTF10 .
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  check_marst_link_initial
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM check_marst_link_initial.

  TYPES: BEGIN OF t_cviv_marst_link.
          INCLUDE STRUCTURE cviv_marst_link.
  TYPES:  action(1) TYPE c.
  TYPES: END OF t_cviv_marst_link.

  DATA:
    ls_marst_link TYPE t_cviv_marst_link.


  LOOP AT total INTO ls_marst_link.

*   Do not process deleted entries
    IF ls_marst_link-action = 'D'.
      CONTINUE.
    ENDIF.

*   Check non-key field values
    IF ls_marst_link-marst IS INITIAL.
      MESSAGE s026(cvi_mapping)
              WITH 'Familienstand des Geschäftspartners'(005)
              DISPLAY LIKE 'E'.
      sy-subrc = 4.
      RETURN.
    ENDIF.

  ENDLOOP.

ENDFORM.                    "check_marst_link_initial
