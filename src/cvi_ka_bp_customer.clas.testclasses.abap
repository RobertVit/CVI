* ----------------------------------------------------------------------
*---------------------------------------------------------------------*
*       CLASS lcl_cvi_ka_bp_ext DEFINITION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
class lcl_cvi_ka_bp_ext definition for testing  risk level critical  duration short.

  private section.
    data:
      cvi_ka_bp_customer    type ref to cvi_ka_bp_customer,
      generated_but000      type table of but000,
      generated_t077d       type table of t077d,
      generated_nriv        type table of nriv,
      generated_tbd001      type table of tbd001.
    methods:
      setup,
      teardown,
      get_instance          for testing,
      get_t077d             for testing,
      get_t077d_line        for testing,
      get_tbd001            for testing,
      get_tbd001_line       for testing,
      check_id_ext          for testing.

endclass.                    "lcl_cvi_ka_bp_ext DEFINITION

*---------------------------------------------------------------------*
*       CLASS lcl_cvi_ka_bp_int DEFINITION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
class lcl_cvi_ka_bp_int definition for testing  risk level critical  duration short.

  private section.
    data:
      cvi_ka_bp_customer    type ref to cvi_ka_bp_customer,
      generated_but000      type table of but000,
      generated_t077d       type table of t077d,
      generated_nriv        type table of nriv,
      generated_tbd001      type table of tbd001.
    methods:
      setup,
      teardown,
      check_id_int          for testing.

endclass.                    "lcl_cvi_ka_bp_int DEFINITION

*---------------------------------------------------------------------*
*       CLASS lcl_cvi_ka_bp_int_same DEFINITION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
class lcl_cvi_ka_bp_int_same definition for testing  risk level critical  duration short.

  private section.
    data:
      cvi_ka_bp_customer    type ref to cvi_ka_bp_customer,
      generated_but000      type table of but000,
      generated_t077d       type table of t077d,
      generated_nriv        type table of nriv,
      generated_tbd001      type table of tbd001.
    methods:
      setup,
      teardown,
      check_id_int_same     for testing.

endclass.                    "lcl_cvi_ka_bp_int_same DEFINITION


*---------------------------------------------------------------------*
*       CLASS lcl_cvi_ka_bp_ext IMPLEMENTATION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
class lcl_cvi_ka_bp_ext implementation .

  method setup.

    data:
      ls_but000        type but000,
      ls_t077d         type t077d,
      ls_nriv          type nriv,
      ls_tbd001        type tbd001.

*   NRIV
    ls_nriv-client     = sy-mandt.
    ls_nriv-object     = 'DEBITOR'.
    ls_nriv-externind  = 'X'.
    ls_nriv-toyear     = '0000'.
    ls_nriv-nrrangenr  = 'AB'.
    ls_nriv-fromnumber = '0000000001'.
    ls_nriv-tonumber   = '9999999999'.
    append ls_nriv to generated_nriv.

*   T077D
    ls_t077d-mandt = sy-mandt.
    ls_t077d-numkr = ls_nriv-nrrangenr.
    ls_t077d-ktokd = fsbp_aut_services=>generate_key( i_tablename = 'T077D'
                                                      i_fieldname = 'KTOKD' ).
    append ls_t077d to generated_t077d.

*   TBD001
    ls_tbd001-client   = sy-mandt.
    ls_tbd001-ktokd    = ls_t077d-ktokd.
    ls_tbd001-bu_group = fsbp_aut_services=>generate_key( i_tablename = 'TBD001'
                                                          i_fieldname = 'BU_GROUP' ).
    append ls_tbd001 to generated_tbd001.

*   BUT000
    ls_but000-client  = sy-mandt.
    ls_but000-partner = fsbp_aut_services=>generate_key( i_tablename = 'BUT000'
                                                         i_fieldname = 'PARTNER' ).
    ls_but000-td_switch = 'X'.
    ls_but000-bu_group  = ls_tbd001-bu_group.
    append ls_but000 to generated_but000.

    insert but000 from table generated_but000.
    insert tbd001 from table generated_tbd001.
    insert t077d  from table generated_t077d.
    insert nriv   from table generated_nriv.

    cvi_ka_bp_customer = cvi_ka_bp_customer=>get_instance( ).

  endmethod.                    "setup

  method get_instance.

    cl_aunit_assert=>assert_bound( cvi_ka_bp_customer ).

  endmethod.                    "get_instance

  method check_id_ext.

    data:
      ls_error   type cvis_error,
      ls_but000  type but000.

    read table generated_but000 index 1 into ls_but000.

    ls_error = cvi_ka_bp_customer->check_id_for_new_customer(
      i_partner_id  = ls_but000-partner
      i_customer_id = '4711'
    ).

    set extended check off.
    cl_aunit_assert=>assert_initial( ls_error ).
    set extended check on.

  endmethod.                    "check_id_ext

  method get_t077d.

    data:
      lt_t077d       type cvis_t077d_t,
      ls_t077d       type t077d,
      ls_t077d_exp   type t077d.

    read table generated_t077d index 1 into ls_t077d_exp.

    lt_t077d = cvi_ka_bp_customer->get_t077d( ).
    read table lt_t077d from ls_t077d_exp into ls_t077d.

    cl_aunit_assert=>assert_equals(
      act = ls_t077d
      exp = ls_t077d_exp
    ).

  endmethod.                                                "get_t077d

  method get_t077d_line.

    data:
      ls_t077d       type t077d,
      ls_t077d_exp   type t077d.

    read table generated_t077d index 1 into ls_t077d_exp.

    ls_t077d = cvi_ka_bp_customer->get_t077d_line( i_account_group = ls_t077d_exp-ktokd ).
    cl_aunit_assert=>assert_equals(
      act = ls_t077d
      exp = ls_t077d_exp
    ).

  endmethod.                    "get_t077d_line

  method get_tbd001.

    data:
      lt_tbd001       type cvis_tbd001_t,
      ls_tbd001       type tbd001,
      ls_tbd001_exp   type tbd001.

    read table generated_tbd001 index 1 into ls_tbd001_exp.

    lt_tbd001 = cvi_ka_bp_customer->get_tbd001( ).
    read table lt_tbd001 from ls_tbd001_exp into ls_tbd001.

    cl_aunit_assert=>assert_equals(
      act = ls_tbd001
      exp = ls_tbd001_exp
    ).

  endmethod.                                                "get_tbd001

  method get_tbd001_line.

    data:
      ls_tbd001       type tbd001,
      ls_tbd001_exp   type tbd001.

    read table generated_tbd001 index 1 into ls_tbd001_exp.

    ls_tbd001 = cvi_ka_bp_customer->get_tbd001_line( i_group = ls_tbd001_exp-bu_group ).

    cl_aunit_assert=>assert_equals(
      act = ls_tbd001
      exp = ls_tbd001_exp
    ).

  endmethod.                    "get_tbd001_line

  method teardown.
    clear cvi_ka_bp_customer.
    rollback work.
  endmethod.                    "teardown

endclass.                    "lcl_cvi_ka_bp_ext IMPLEMENTATION

*---------------------------------------------------------------------*
*       CLASS lcl_cvi_ka_bp_int IMPLEMENTATION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
class lcl_cvi_ka_bp_int implementation .

  method setup.

    data:
      ls_but000        type but000,
      ls_t077d         type t077d,
      ls_nriv          type nriv,
      ls_tbd001        type tbd001.

*   NRIV
    ls_nriv-client     = sy-mandt.
    ls_nriv-object     = 'DEBITOR'.
    ls_nriv-toyear     = '0000'.
    ls_nriv-nrrangenr  = 'AC'.
    ls_nriv-fromnumber = '0000000001'.
    ls_nriv-tonumber   = 'ZZZZZZZZZZ'.
    append ls_nriv to generated_nriv.

*   T077D
    ls_t077d-mandt = sy-mandt.
    ls_t077d-numkr = ls_nriv-nrrangenr.
    ls_t077d-ktokd = fsbp_aut_services=>generate_key( i_tablename = 'T077D'
                                                      i_fieldname = 'KTOKD' ).
    append ls_t077d to generated_t077d.

*   TBD001
    ls_tbd001-client      = sy-mandt.
    ls_tbd001-ktokd       = ls_t077d-ktokd.
    ls_tbd001-bu_group = fsbp_aut_services=>generate_key( i_tablename = 'TBD001'
                                                          i_fieldname = 'BU_GROUP' ).
    append ls_tbd001 to generated_tbd001.

*   BUT000
    ls_but000-client  = sy-mandt.
    ls_but000-partner = fsbp_aut_services=>generate_key( i_tablename = 'BUT000'
                                                         i_fieldname = 'PARTNER' ).
    ls_but000-td_switch = 'X'.
    ls_but000-bu_group  = ls_tbd001-bu_group.
    append ls_but000 to generated_but000.

    insert but000 from table generated_but000.
    insert tbd001 from table generated_tbd001.
    insert t077d  from table generated_t077d.
    insert nriv   from table generated_nriv.

    cvi_ka_bp_customer = cvi_ka_bp_customer=>get_instance( ).

  endmethod.                    "setup

  method check_id_int.

    data:
      ls_error   type cvis_error,
      ls_but000  type but000.

    read table generated_but000 index 1 into ls_but000.

    ls_error = cvi_ka_bp_customer->check_id_for_new_customer(
      i_partner_id  = ls_but000-partner
      i_customer_id = ''
    ).
    cl_aunit_assert=>assert_initial( ls_error ).

  endmethod.                    "check_id_int

  method teardown.
    clear cvi_ka_bp_customer.
    rollback work.
  endmethod.                    "teardown

endclass.                    "lcl_cvi_ka_bp_int IMPLEMENTATION


*---------------------------------------------------------------------*
*       CLASS lcl_cvi_ka_bp_int_same IMPLEMENTATION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
class lcl_cvi_ka_bp_int_same implementation .

  method setup.

    data:
      ls_but000        type but000,
      ls_t077d         type t077d,
      ls_nriv          type nriv,
      ls_tbd001        type tbd001,
      lv_customer      type kna1-kunnr.

*   NRIV
    ls_nriv-client     = sy-mandt.
    ls_nriv-object     = 'DEBITOR'.
    ls_nriv-toyear     = '0000'.
    ls_nriv-nrrangenr  = 'AC'.
    ls_nriv-fromnumber = '0000000001'.
    ls_nriv-tonumber   = 'ZZZZZZZZZZ'.
    append ls_nriv to generated_nriv.

*   T077D
    ls_t077d-mandt = sy-mandt.
    ls_t077d-numkr = ls_nriv-nrrangenr.
    ls_t077d-ktokd = fsbp_aut_services=>generate_key( i_tablename = 'T077D'
                                                      i_fieldname = 'KTOKD' ).
    append ls_t077d to generated_t077d.

*   TBD001
    ls_tbd001-client      = sy-mandt.
    ls_tbd001-ktokd       = ls_t077d-ktokd.
    ls_tbd001-xsamenumber = 'X'.
    ls_tbd001-bu_group = fsbp_aut_services=>generate_key( i_tablename = 'TBD001'
                                                          i_fieldname = 'BU_GROUP' ).
    append ls_tbd001 to generated_tbd001.

*   BUT000
    ls_but000-client  = sy-mandt.
    do.
      " generate a partner key which is not used in KNA1 yet (--> same number)
      ls_but000-partner = fsbp_aut_services=>generate_key(
        i_tablename = 'BUT000'
        i_fieldname = 'PARTNER'
      ).
      select single kunnr from kna1 into lv_customer  where kunnr = ls_but000-partner.
      if sy-subrc <> 0.
        exit.
      endif.
    enddo.
    ls_but000-td_switch = 'X'.
    ls_but000-bu_group  = ls_tbd001-bu_group.
    append ls_but000 to generated_but000.

    insert but000 from table generated_but000.
    insert tbd001 from table generated_tbd001.
    insert t077d  from table generated_t077d.
    insert nriv   from table generated_nriv.

    cvi_ka_bp_customer = cvi_ka_bp_customer=>get_instance( ).

  endmethod.                    "setup

  method check_id_int_same.

    data:
      ls_error   type cvis_error,
      ls_but000  type but000.

    read table generated_but000 index 1 into ls_but000.

    ls_error = cvi_ka_bp_customer->check_id_for_new_customer(
      i_partner_id  = ls_but000-partner
      i_customer_id = ls_but000-partner
    ).
    cl_aunit_assert=>assert_initial( ls_error ).

  endmethod.                    "check_id_int_same

  method teardown.
    clear cvi_ka_bp_customer.
    rollback work.
  endmethod.                    "teardown

endclass.                    "lcl_cvi_ka_bp_int_same IMPLEMENTATION
