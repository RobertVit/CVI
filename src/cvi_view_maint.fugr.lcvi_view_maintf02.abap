*----------------------------------------------------------------------*
***INCLUDE LCVI_VIEW_MAINTF02 .
*----------------------------------------------------------------------*

*&--------------------------------------------------------------------*
*&      Form  check_numberrange_cust_to_bp1
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
form check_numberrange_cust_to_bp1.

  types: begin of t_cviv_cust_to_bp1.
          include structure cviv_cust_to_bp1.
  types:  action(1) type c.
  types: end of t_cviv_cust_to_bp1.

  data:
    ls_cust_to_bp1   type t_cviv_cust_to_bp1,
    ls_t077d         type t077d,
    ls_interval_cust type nriv,
    ls_tb001         type tb001,
    ls_interval_bp   type nriv.
  constants:
    true             type boole-boole value 'X',
    false            type boole-boole value ' '.

  loop at total into ls_cust_to_bp1.
* do not process deleted entries
    if ls_cust_to_bp1-action = 'D'.
      continue.
    endif.

    if ls_cust_to_bp1-grouping is initial.
* BP grouping must be entered
      message s041(cvi_mapping) with ls_cust_to_bp1-account_group
        display like 'E'.
      sy-subrc = 4.
      return.
    endif.

* get customer account group and number range interval
    call function 'T077D_SINGLE_READ'
      exporting
        i_ktokd = ls_cust_to_bp1-account_group
      importing
        o_t077d = ls_t077d
      exceptions
        others  = 1.

    if sy-subrc <> 0.
      message s033(cvi_mapping) with ls_cust_to_bp1-account_group
        display like 'E'.
      sy-subrc = 4.
      return.
    else.

      if ls_t077d-numkr is initial.
        message s034(cvi_mapping) with ls_cust_to_bp1-account_group
          display like 'E'.
        sy-subrc = 4.
        return.
      else.
        call function 'NUMBER_GET_INFO'
          exporting
            nr_range_nr = ls_t077d-numkr
            object      = 'DEBITOR'
          importing
            interval    = ls_interval_cust
          exceptions
            others      = 1.

        if sy-subrc <> 0.
          message s035(cvi_mapping) with ls_t077d-numkr ls_cust_to_bp1-account_group
            display like 'E'.
          sy-subrc = 4.
          return.
        endif.
      endif.
    endif.

* get business partner grouping and number range interval
    call function 'BUP_TB001_SELECT_SINGLE'
      exporting
        i_bu_group = ls_cust_to_bp1-grouping
      importing
        e_tb001    = ls_tb001
      exceptions
        others     = 1.

    if sy-subrc <> 0.
      message s036(cvi_mapping) with ls_cust_to_bp1-account_group
        display like 'E'.
      sy-subrc = 4.
      return.
    else.
      if ls_tb001-nrrng is initial.
        message s037(cvi_mapping) with ls_cust_to_bp1-account_group
          display like 'E'.
        sy-subrc = 4.
        return.
      else.
        call function 'NUMBER_GET_INFO'
          exporting
            nr_range_nr = ls_tb001-nrrng
            object      = 'BU_PARTNER'
          importing
            interval    = ls_interval_bp
          exceptions
            others      = 1.

        if sy-subrc <> 0.
          message s038(cvi_mapping) with ls_t077d-numkr ls_cust_to_bp1-account_group
            display like 'E'.
          sy-subrc = 4.
          return.
        endif.
      endif.
    endif.

    if ls_cust_to_bp1-same_number = true.
      if ls_interval_bp-externind = false.
* internal number assignment for BP is not allowed with same number option
        message s039(cvi_mapping) with ls_cust_to_bp1-grouping
          display like 'E'.
        sy-subrc = 4.
        return.
      else.
* boundaries of both number ranges must be equal
        if ls_interval_cust-fromnumber <> ls_interval_bp-fromnumber or
           ls_interval_cust-tonumber   <> ls_interval_bp-tonumber.
          message s018(cvi_mapping) with ls_cust_to_bp1-account_group ls_cust_to_bp1-grouping
            display like 'E'.
          sy-subrc = 4.
          return.
        endif.
      endif.
    else.
      if ls_interval_bp-externind = true.
* external number assignment for BP is not allowed without same number option
        message s040(cvi_mapping) with ls_cust_to_bp1-grouping
          display like 'E'.
        sy-subrc = 4.
        return.
      endif.
    endif.
  endloop.
  sy-subrc = 0.

endform.                    "check_numberrange_cust_to_bp1
