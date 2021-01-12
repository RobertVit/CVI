*----------------------------------------------------------------------*
***INCLUDE LCVI_VIEW_MAINTF09 .
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  check_cp4_link_initial
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM check_cp4_link_initial.

  TYPES: BEGIN OF t_cviv_cp4_link.
          INCLUDE STRUCTURE cviv_cp4_link.
  TYPES:  action(1) TYPE c.
  TYPES: END OF t_cviv_cp4_link.

  DATA:
    ls_cp4_link TYPE t_cviv_cp4_link.


  LOOP AT total INTO ls_cp4_link.

*   Do not process deleted entries
    IF ls_cp4_link-action = 'D'.
      CONTINUE.
    ENDIF.

*   Check non-key field values
    IF ls_cp4_link-gp_pavip IS INITIAL.
      MESSAGE s026(cvi_mapping)
              WITH 'VIP-Partner'(004)
              DISPLAY LIKE 'E'.
      sy-subrc = 4.
      RETURN.
    ENDIF.

  ENDLOOP.

ENDFORM.                    "check_cp4_link_initial
