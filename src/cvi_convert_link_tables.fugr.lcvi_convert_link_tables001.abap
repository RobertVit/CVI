*&---------------------------------------------------------------------*
*&  Include           LCVI_CONVERT_LINK_TABLES001
*&---------------------------------------------------------------------*

*----------------------------------------------------------------------*
*       CLASS cvi_convert_link_tables DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
class cvi_convert_link_tables definition.

  public section.

    constants true type boole_d value 'X'.                  "#EC NOTEXT
    constants false type boole_d value space.               "#EC NEEDED
    constants msgtype_status type bapi_mtype value 'S'.     "#EC NOTEXT
    constants messageclass type symsgid value 'CVI_CONVERT_LINK'."#EC NOTEXT

    class-methods initialize_vend_link_package
      importing
        !i_limit_high type bank_dte_pp_objno
        !i_limit_low type bank_dte_pp_objno
        !i_str_package_key type bank_str_pp_packagekey .
    class-methods initialize_cust_link_package
      importing
        !i_limit_high type bank_dte_pp_objno
        !i_limit_low type bank_dte_pp_objno
        !i_str_package_key type bank_str_pp_packagekey .
    class-methods convert_vendor_linktable .
    class-methods convert_customer_linktable .
    class-methods build_vend_link_packages
      importing
        !i_str_param type cvis_conversion_params
        !i_str_package_key type bank_str_pp_packagekey
      exporting
        !e_limit_high type bank_dte_pp_objno
        !e_limit_low type bank_dte_pp_objno
        !e_flg_no_package type xfeld .
    class-methods build_cust_link_packages
      importing
        !i_str_param type cvis_conversion_params
        !i_str_package_key type bank_str_pp_packagekey
      exporting
        !e_limit_high type bank_dte_pp_objno
        !e_limit_low type bank_dte_pp_objno
        !e_flg_no_package type xfeld .


  protected section.


  private section.

    class-data start_of_next_customer_package type bu_partner .
    class-data cust_current_limit_high type bank_dte_pp_objno .
    class-data cust_current_limit_low type bank_dte_pp_objno .
    class-data start_of_next_vendor_package type bu_partner .
    class-data vend_current_limit_high type bank_dte_pp_objno .
    class-data vend_current_limit_low type bank_dte_pp_objno .
    class-data cust_current_package_no type bank_str_pp_packagekey .
    class-data vend_current_package_no type bank_str_pp_packagekey .

    class-methods write_package_success_message
      importing
        !i_package_no type bank_str_pp_packagekey
        !i_limit_high type bank_dte_pp_objno
        !i_limit_low type bank_dte_pp_objno .
    class-methods write_no_of_packages_to_log
      importing
        !i_package_count type numc10 .


endclass.                    "cvi_convert_link_tables DEFINITION

*----------------------------------------------------------------------*
*       CLASS cvi_convert_link_tables IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
class cvi_convert_link_tables implementation.

  method initialize_vend_link_package.

    vend_current_package_no = i_str_package_key.
    vend_current_limit_high = i_limit_high.
    vend_current_limit_low  = i_limit_low.

  endmethod.                    "initialize_vend_link_package

  method initialize_cust_link_package.

    cust_current_package_no = i_str_package_key.
    cust_current_limit_high = i_limit_high.
    cust_current_limit_low  = i_limit_low.

  endmethod.                    "initialize_cust_link_package

  method convert_vendor_linktable.

    types:
      begin of lty_guids,
        partner      type bu_partner,
        partner_guid type bu_partner_guid,
      end of lty_guids.

    data:
      lt_bc001    type table of bc001,
      lt_guids    type table of lty_guids,
      lt_cvi_link type table of cvi_vend_link,
      ls_cvi_link like line of lt_cvi_link.

    field-symbols:
      <bc001>  type bc001,
      <guid>   like line of lt_guids.

    select * from bc001 into table lt_bc001 where partner >= vend_current_limit_low and partner <= vend_current_limit_high.

    select partner partner_guid from but000 into corresponding fields of table lt_guids
           for all entries in lt_bc001 where partner = lt_bc001-partner.

    loop at lt_bc001 assigning <bc001>.
      read table lt_guids assigning <guid> with key partner = <bc001>-partner.
      assert <guid> is assigned.
      ls_cvi_link-partner_guid = <guid>-partner_guid.
      ls_cvi_link-vendor       = <bc001>-lifnr.
      ls_cvi_link-cruser       = <bc001>-cruser.
      ls_cvi_link-crdat        = <bc001>-crdat.
      ls_cvi_link-crtim        = <bc001>-crtim.
      append ls_cvi_link to lt_cvi_link.
      clear ls_cvi_link.
    endloop.

    insert cvi_vend_link from table lt_cvi_link accepting duplicate keys.
    assert sy-subrc <= 4.

    write_package_success_message(
      i_package_no = vend_current_package_no
      i_limit_high = vend_current_limit_high
      i_limit_low  = vend_current_limit_low
    ).

  endmethod.                    "convert_vendor_linktable

  method convert_customer_linktable.

    types:
      begin of lty_guids,
        partner      type bu_partner,
        partner_guid type bu_partner_guid,
      end of lty_guids.

    data:
      lt_bd001    type table of bd001,
      lt_guids    type table of lty_guids,
      lt_cvi_link type table of cvi_cust_link,
      ls_cvi_link like line of lt_cvi_link.

    field-symbols:
      <bd001>  type bd001,
      <guid>   like line of lt_guids.

    select * from bd001 into table lt_bd001 where partner >= cust_current_limit_low and partner <= cust_current_limit_high.

    select partner partner_guid from but000 into corresponding fields of table lt_guids
           for all entries in lt_bd001 where partner = lt_bd001-partner.

    loop at lt_bd001 assigning <bd001>.
      read table lt_guids assigning <guid> with key partner = <bd001>-partner.
      assert <guid> is assigned.
      ls_cvi_link-partner_guid = <guid>-partner_guid.
      ls_cvi_link-customer     = <bd001>-kunnr.
      ls_cvi_link-cruser       = <bd001>-cruser.
      ls_cvi_link-crdat        = <bd001>-crdat.
      ls_cvi_link-crtim        = <bd001>-crtim.
      append ls_cvi_link to lt_cvi_link.
      clear ls_cvi_link.
    endloop.

    insert cvi_cust_link from table lt_cvi_link accepting duplicate keys.
    assert sy-subrc <= 4.

    write_package_success_message(
      i_package_no = cust_current_package_no
      i_limit_high = cust_current_limit_high
      i_limit_low  = cust_current_limit_low
    ).

  endmethod.                    "convert_customer_linktable

  method build_vend_link_packages.

    types:
      begin of lty_numbers,
        partner type  bu_partner,
      end of lty_numbers.

    data:
      lt_numbers type table of lty_numbers,
      lv_lines   type i,
      lv_package_count type numc10.

    field-symbols:
      <number>   like line of lt_numbers.

    select partner from bc001 into table lt_numbers
                   up to i_str_param-package_size rows
                   where partner > start_of_next_vendor_package
                   order by partner.

    describe table lt_numbers lines lv_lines.
    if lv_lines <> 0.
      read table lt_numbers assigning <number> index 1.
      e_limit_low = <number>.
      read table lt_numbers assigning <number> index lv_lines.
      e_limit_high = start_of_next_vendor_package = <number>.
    else.
      clear start_of_next_vendor_package.
      e_flg_no_package = true.
      lv_package_count = i_str_package_key-packageno - 1.
      write_no_of_packages_to_log( lv_package_count ).
    endif.

  endmethod.                    "build_vend_link_packages

  method build_cust_link_packages.

    types:
      begin of lty_numbers,
        partner type  bu_partner,
      end of lty_numbers.

    data:
      lt_numbers       type table of lty_numbers,
      lv_lines         type i,
      lv_package_count type numc10.

    field-symbols:
      <number>   like line of lt_numbers.

    select partner from bd001 into table lt_numbers
                   up to i_str_param-package_size rows
                   where partner > start_of_next_customer_package
                   order by partner.

    describe table lt_numbers lines lv_lines.
    if lv_lines <> 0.
      read table lt_numbers assigning <number> index 1.
      e_limit_low = <number>.
      read table lt_numbers assigning <number> index lv_lines.
      e_limit_high = start_of_next_customer_package = <number>.
    else.
      clear start_of_next_customer_package.
      e_flg_no_package = true.
      lv_package_count = i_str_package_key-packageno - 1.
      write_no_of_packages_to_log( lv_package_count ).
    endif.

  endmethod.                    "build_cust_link_packages

  method write_package_success_message.

    data:
      ls_message type bapiret2.

    ls_message-type       = msgtype_status.
    ls_message-id         = messageclass.
    ls_message-number     = '000'.
    ls_message-message_v1 = i_package_no-packageno.
    ls_message-message_v2 = i_limit_low.
    ls_message-message_v3 = i_limit_high.

    call function 'CVI_EMSG_LOG_PUT_MESSAGE'
      exporting
        i_message = ls_message.

  endmethod.                    "write_package_success_message

  method write_no_of_packages_to_log.

    data:
      ls_message type bapiret2.

    ls_message-type       = msgtype_status.
    ls_message-id         = messageclass.
    ls_message-number     = '001'.
    ls_message-message_v1 = i_package_count.

    call function 'CVI_EMSG_LOG_PUT_MESSAGE'
      exporting
        i_message = ls_message.

  endmethod.                    "write_no_of_packages_to_log

endclass.                    "cvi_convert_link_tables IMPLEMENTATION
