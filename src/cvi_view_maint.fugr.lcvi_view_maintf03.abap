*----------------------------------------------------------------------*
***INCLUDE LCVI_VIEW_MAINTF03 .
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  check_tb003_cust_to_bp2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM check_tb003_cust_to_bp2.

  TYPES: BEGIN OF t_cviv_cust_to_bp2.
          INCLUDE STRUCTURE cviv_cust_to_bp2.
  TYPES:  action(1) TYPE c.
  TYPES: END OF t_cviv_cust_to_bp2.

  DATA:
    ls_cust_to_bp2 TYPE t_cviv_cust_to_bp2,
    ls_tb003       TYPE tb003.


  LOOP AT total INTO ls_cust_to_bp2.

*   Do not process deleted entries
    IF ls_cust_to_bp2-action = 'D'.
      CONTINUE.
    ENDIF.

*   Get business partner roles
    CALL FUNCTION 'BUP_TB003_SELECT_SINGLE'
      EXPORTING
        i_role    = ls_cust_to_bp2-role
      IMPORTING
        e_tb003   = ls_tb003
      EXCEPTIONS
        not_found = 1
        OTHERS    = 2.
    IF sy-subrc <> 0.
      MESSAGE s058(00)
              WITH ls_cust_to_bp2-role
                   space
                   space
                   'TB003'
              DISPLAY LIKE 'E'.
      sy-subrc = 4.
      RETURN.
    ELSE.
*     Role category must exist
      IF ls_tb003-rolecategory IS INITIAL.
        MESSAGE s019(cvi_mapping)
                WITH ls_cust_to_bp2-role
                DISPLAY LIKE 'E'.
        sy-subrc = 4.
        RETURN.
      ENDIF.
    ENDIF.

  ENDLOOP.

  sy-subrc = 0.

ENDFORM.                    "check_tb003_cust_to_bp2
