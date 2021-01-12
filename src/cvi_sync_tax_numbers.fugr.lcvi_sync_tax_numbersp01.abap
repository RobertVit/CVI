*----------------------------------------------------------------------*
**INCLUDE LCVI_SYNC_TAX_NUMBERSP01 .
*----------------------------------------------------------------------*

*       CLASScvi_sync_cust_tax_numbersDEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
class cvi_sync_cust_tax_numbers definition.

* ______________________________________________________________________
  public section.

* >>> attributes

    class-data current_package_key     type bank_str_pp_packagekey.
    class-data cust_run_params         type cvis_conversion_params.

    constants true                     type boole_d                value 'X'. "#EC NOTEXT
    constants false                    type boole_d                value space. "#EC NOTEXT
    constants task_insert              type bus_ei_object_task     value 'I'. "#EC NOTEXT
    constants msg_error                type symsgty                value 'E'. "#EC NOTEXT
    constants msg_status               type symsgty                value 'S'. "#EC NOTEXT
    constants msg_abort                type symsgty                value 'A'. "#EC NOTEXT
    constants messageclass             type symsgid                value 'CVI_SYNC_TAX_NUMBER'. "#EC NOTEXT
*    constants pp_cust_application_type type bank_dte_pp_paapplcatg value 'CVI_ACUTAX'."#EC NOTEXT
    constants direction_bp_cust        type c                      value '1'. "#EC NOTEXT
    constants direction_cust_bp        type c                      value '2'. "#EC NOTEXT

* >>> methods

*   builds the packages for customer processing
    class-methods build_cust_packages
      importing
        !i_str_param       type cvis_conversion_params
        !i_str_package_key type bank_str_pp_packagekey
      exporting
        !e_limit_high      type bank_dte_pp_objno
        !e_limit_low       type bank_dte_pp_objno
        !e_flg_no_package  type xfeld.

*   sets the ids for the object that should be processed in the current run
    class-methods set_analysis_objlist_cust
      importing
        !i_str_package_key type bank_str_pp_packagekey
        !i_limit_low       type bank_dte_pp_objno
        !i_limit_high      type bank_dte_pp_objno.

*   sets the ids for the object that should be processed in the current run
    class-methods set_cust_current_objlist
      importing
        !i_str_param       type cvis_conversion_params
        !i_str_package_key type bank_str_pp_packagekey
        !i_limit_low       type bank_dte_pp_objno
        !i_limit_high      type bank_dte_pp_objno
        !i_xrestart        type xfeld                       "#EC NEEDED
        !i_flg_aborted     type xfeld.                      "#EC NEEDED

*   starts the analysis for conflicts between customer and partner tax data
    class-methods analyze_cust_tax_data
      returning
        value(r_error) type boole_d.


*   starts the synchronization for the tax data
    class-methods synchronize_tax_data_cust
      returning
        value(r_error) type boole_d.

*   send message to application log
    class-methods log_message
      importing
        !i_message type bapiret2.

* ______________________________________________________________________
  protected section.

* ______________________________________________________________________
  private section.


* >>> attributes
    class-data last_limit_high            type bu_partner.
    class-data current_limit_low          type bank_dte_pp_objno.
    class-data current_limit_high         type bank_dte_pp_objno.
    class-data cust_current_guids         type cvis_partner_and_guid_cust_t.
    class-data partner_taxnumbers_for_run type com_bupa_buttax_t.
    class-data cust_kna1_tax_for_run      type cvis_kna1_tax_t.
    class-data cust_knas_tax_for_run      type cvis_knas_t.
    class-data kna1_updates               type cvis_kna1_tax_t.
    class-data knas_deletes               type cvis_customer_t.
    class-data knas_inserts               type cvis_knas_t.
    class-data bptax_deletes              type com_bupa_buttax_t.
    class-data bptax_inserts              type com_bupa_buttax_t.

* ________________________________________

* >>> methods

* partner processing
*   fills the attribute partner_taxnumbers_for_run with the tax data of ALL the partners that
*   are processed in this run
    class-methods set_partner_tax_data_for_run.

*   delivers the tax data of the partners for the current run
*   returns partner_taxnumbers_for_run[]
    class-methods get_partner_tax_data_for_run
      exporting
        !et_taxnumbers type com_bupa_buttax_t.

*   converts the partner taxnumbers from the db table structure to the structure of the
*   external interface
*   es_cust_ei_data - tax data of bp mapped to complex structure of customer (only for synchronize - so that the mapping is called only once)
    class-methods convert_partner_tax_data_to_ei
      importing
        !i_partner       type bu_partner
        !i_customer      type kunnr
        !i_taxnumbers    type com_bupa_buttax_t
      exporting
        !et_tax_data     type bus_ei_bupa_taxnumber_t
        !es_cust_ei_data type cmds_ei_extern
        !e_error         type boole_d.

* customer processing
*   fills the attribute cust_kna1_tax_for run and cust_knas_tax_for_run with the tax data
*   of ALL the customers that are processed in this run
    class-methods set_customer_tax_data_for_run.

*   returns cust_kna1_tax_for_run[], cust_knas_tax_for_run[]
    class-methods get_customer_tax_data_for_run
      exporting
        !et_knas_tax type cvis_knas_t
        !et_kna1_tax type cvis_kna1_tax_t.

*   returns the country from the cust_kna1_tax_for_run[]
    class-methods get_cust_country
      importing
        !i_customer      type kunnr
      returning
        value(r_country) type land1_gp.

*   converts the customer taxnumbers from the db table structure to the structure of the
*   external interface
    class-methods convert_cust_tax_data_to_ei
      importing
        !i_customer  type kunnr
        !i_partner   type bu_partner
        !it_knas     type cvis_knas_t
        !it_kna1_tax type cvis_kna1_tax_t
      exporting
        !et_tax_data type bus_ei_bupa_taxnumber_t
        !e_error     type boole_d.

*   checks if the customer and partner tax data differ
    class-methods check_cust_for_conflicts
      importing
        !i_partner         type bu_partner
        !i_customer        type kunnr
        !it_taxnumbers     type com_bupa_buttax_t
        !it_knas_tax       type cvis_knas_t
        !it_kna1_tax       type cvis_kna1_tax_t
        !i_partner_natpers type bu_natural_person           "#EC NEEDED
      exporting
        !et_bp_tax         type bus_ei_bupa_taxnumber_t
        !et_cu_tax         type bus_ei_bupa_taxnumber_t
        !e_conflict        type boole_d
        !e_error           type boole_d.

*   maps partner tax data to customer and fills class attributes
*   with resulting entries for DB operations
*      it_bp_tax_data  - tax data for the given BP in EI format
    class-methods sync_partner_to_customer
      importing
        !i_partner         type bu_partner                  "#EC NEEDED
        !i_customer        type kunnr
        !i_partner_natpers type bu_natural_person
        !it_bp_tax_data    type bus_ei_bupa_taxnumber_t     "#EC NEEDED
        !is_cust_ei_data   type cmds_ei_extern.


*   maps customer tax data to partner and fills class attributes
*   with resulting entries for DB operations
    class-methods sync_customer_to_partner
      importing
        !i_customer     type kunnr                          "#EC NEEDED
        !i_partner      type bu_partner
        !it_bp_ei_tax   type bus_ei_bupa_taxnumber_t
        !it_cust_ei_tax type bus_ei_bupa_taxnumber_t.

*   Locks all business partners of current package, assigned customers or vendors are locked automatically too
*   if exclusive lock is not possible, then the error messages are logged and e_error is set (the package needs to be restarted).
    class-methods lock_all_bps_cust
      returning
        value(r_error) type boole_d.

*   Handles the event after the COMMIT WORK to unlock all the BPs
    class-methods after_commit
                  for event ev_after_db_change of cl_bank_pp_db_change_mngr
      importing kind_db_change.                             "#EC NEEDED

*   writes the changes of tax data to DB
    class-methods save_cust_tax_data.

* technical methods

* logging
    class-methods write_no_of_packages_to_log
      importing
        !i_package_count type numc10 .

*   log the std error message for 003(cvi_sync_tax_number) the (BP,customer) and cvi errors
    class-methods log_cust_cvi_errors
      importing
        !i_partner  type bu_partner
        !i_customer type kunnr
        !i_errors   type cvis_error.
endclass.                    "cvi_sync_cust_tax_numbers DEFINITION

*&---------------------------------------------------------------------*
*&       Class (Implementation)  cvi_cust_sync_tax_numbers
*&---------------------------------------------------------------------*
*        Text
*----------------------------------------------------------------------*
class cvi_sync_cust_tax_numbers implementation.

  method build_cust_packages.

    types:
      begin of lty_numbers,
        partner type  bu_partner,
      end of lty_numbers.

    data:
      lt_numbers       type table of lty_numbers,
      ls_message       type bapiret2,
      lv_lines         type i,
      lv_package_count type numc10.

    field-symbols:
      <number>   like line of lt_numbers.

    select partner from bd001 into table lt_numbers
                   up to i_str_param-package_size rows
                   where partner > last_limit_high
                   order by partner.

    describe table lt_numbers lines lv_lines.
    if lv_lines <> 0.
      read table lt_numbers assigning <number> index 1.
      e_limit_low = <number>.
      read table lt_numbers assigning <number> index lv_lines.
      e_limit_high = last_limit_high = <number>.
    else.
      e_flg_no_package = true.
      lv_package_count = i_str_package_key-packageno - 1.
      write_no_of_packages_to_log( lv_package_count ).
      if lv_package_count = 0.
        ls_message-type       = msg_status.
        ls_message-id         = messageclass.
        ls_message-number     = '006'.
        log_message( ls_message ).
      endif.
    endif.

  endmethod.                    "build_cust_packages

  method set_analysis_objlist_cust.

    data:
      lt_bd001         type table of bd001.

    field-symbols:
      <bd001>        like line of lt_bd001,
      <current_guid> like line of cust_current_guids[].

    clear cust_current_guids[].
    clear partner_taxnumbers_for_run[].
    clear cust_kna1_tax_for_run[].
    clear cust_knas_tax_for_run[].
    clear kna1_updates[].
    clear knas_deletes[].
    clear knas_inserts[].
    clear bptax_deletes[].
    clear bptax_inserts[].

    current_limit_low   = i_limit_low.
    current_limit_high  = i_limit_high.
    current_package_key = i_str_package_key.

    select * from bd001 into table lt_bd001
      where partner >= current_limit_low and partner <= current_limit_high.

    assert lt_bd001[] is not initial. "package must have some data

    select partner partner_guid natpers from but000 into corresponding fields of table cust_current_guids[]
           for all entries in lt_bd001[]
           where partner = lt_bd001-partner.

    loop at lt_bd001[] assigning <bd001>.
      read table cust_current_guids assigning <current_guid> with key partner = <bd001>-partner.
      if sy-subrc = 0.
        <current_guid>-customer = <bd001>-kunnr.
      endif.
    endloop.

  endmethod.                    "set_analysis_objlist_cust


  method set_cust_current_objlist.

    set_analysis_objlist_cust(
       exporting
         i_str_package_key     = i_str_package_key
         i_limit_low           = i_limit_low
         i_limit_high          = i_limit_high
    ).
    cust_run_params = i_str_param.
*        i_xrestart            type xfeld
*        i_flg_aborted         type xfeld.

  endmethod.                    "set_cust_current_objlist


  method analyze_cust_tax_data.

    data:
      lt_bp_tax   type bus_ei_bupa_taxnumber_t,
      lt_bp_dfkk  like partner_taxnumbers_for_run,
      lt_cu_tax   like lt_bp_tax,
      lt_knas     like cust_knas_tax_for_run,
      lt_kna1_tax like cust_kna1_tax_for_run,
      ls_message  type bapiret2,
      lv_conflict type boole-boole.

    field-symbols:
      <current_guid>     like line of cust_current_guids.

*   read the tax data for the whole package from DB
    set_partner_tax_data_for_run( ).
    set_customer_tax_data_for_run( ).

*   import the tax data for the current objects
    get_partner_tax_data_for_run(
      importing et_taxnumbers = lt_bp_dfkk
    ).
    get_customer_tax_data_for_run(
      importing et_knas_tax = lt_knas
                et_kna1_tax = lt_kna1_tax
    ).

    loop at cust_current_guids assigning <current_guid>.

      check_cust_for_conflicts(
        exporting i_partner         = <current_guid>-partner
                  i_customer        = <current_guid>-customer
                  it_taxnumbers     = lt_bp_dfkk
                  it_knas_tax       = lt_knas
                  it_kna1_tax       = lt_kna1_tax
                  i_partner_natpers = <current_guid>-natpers
        importing et_bp_tax         = lt_bp_tax
                  et_cu_tax         = lt_cu_tax
                  e_conflict        = lv_conflict
                  e_error           = r_error
      ).
      if r_error = true.  return.  endif.

      if lv_conflict = true.
        ls_message-type       = msg_error.
        ls_message-id         = messageclass.
        ls_message-number     = '000'.
        ls_message-message_v1 = <current_guid>-partner.
        ls_message-message_v2 = <current_guid>-customer.
        log_message( ls_message ).

        if lt_bp_tax[] is initial.
          ls_message-type       = msg_error.
          ls_message-id         = messageclass.
          ls_message-number     = '015'.
          ls_message-message_v1 = <current_guid>-partner.
          log_message( ls_message ).

        elseif lt_cu_tax[] is initial.
          ls_message-type       = msg_error.
          ls_message-id         = messageclass.
          ls_message-number     = '016'.
          ls_message-message_v1 = <current_guid>-customer.
          log_message( ls_message ).

        endif.
      endif.

      clear: lt_bp_tax, lt_cu_tax, lv_conflict.

    endloop.

    ls_message-type       = msg_status.
    ls_message-id         = messageclass.
    ls_message-number     = '005'.
    ls_message-message_v1 = current_package_key-packageno.
    log_message( ls_message ).

  endmethod.                    "analyze_cust_tax_data

  method synchronize_tax_data_cust.

    data:
      lt_bp_ei_tax    type bus_ei_bupa_taxnumber_t,
      lt_cust_ei_tax  like lt_bp_ei_tax,
      ls_cust_ei_data type cmds_ei_extern,
      direction       type cvi_direction_map_tax,
      ls_message      type bapiret2.

    field-symbols:
      <current_guid>  like line of cust_current_guids.

*   read the tax data for the whole package from DB
    set_partner_tax_data_for_run( ).
    set_customer_tax_data_for_run( ).

*   lock the corresponding objects
    r_error = lock_all_bps_cust( ).
    check r_error = false.

*   start processing & decide direction
    loop at cust_current_guids assigning <current_guid>.
      direction = cust_run_params-tax_mapping_direction.

      convert_partner_tax_data_to_ei(
        exporting i_partner       = <current_guid>-partner
                  i_customer      = <current_guid>-customer
                  i_taxnumbers    = partner_taxnumbers_for_run[]
        importing et_tax_data     = lt_bp_ei_tax[]
                  es_cust_ei_data = ls_cust_ei_data
                  e_error         = r_error
      ).
      if r_error = true.  return.  endif.

      convert_cust_tax_data_to_ei(
        exporting i_customer   = <current_guid>-customer
                  i_partner    = <current_guid>-partner
                  it_knas      = cust_knas_tax_for_run[]
                  it_kna1_tax  = cust_kna1_tax_for_run[]
        importing et_tax_data  = lt_cust_ei_tax
                  e_error      = r_error
      ).
      if r_error = true.  return.  endif.

      sort: lt_bp_ei_tax[], lt_cust_ei_tax[].

      if lt_bp_ei_tax[] <> lt_cust_ei_tax[].

        if cust_run_params-auto_direction_change = true.
*       change direction if one object has no tax data
*       (the flag for nat_pers is irrelevant for the direction decision, only tax data matters)
          if lt_bp_ei_tax[] is initial.
            direction = direction_cust_bp.
          elseif lt_cust_ei_tax[] is initial.
            direction = direction_bp_cust.
          endif.
        endif.
        if direction = direction_bp_cust.
          sync_partner_to_customer(
            exporting
              i_partner          = <current_guid>-partner
              i_customer         = <current_guid>-customer
              i_partner_natpers  = <current_guid>-natpers
              it_bp_tax_data     = lt_bp_ei_tax[]
              is_cust_ei_data    = ls_cust_ei_data
          ).
        else.
          sync_customer_to_partner(
            exporting
              i_partner      = <current_guid>-partner
              i_customer     = <current_guid>-customer
              it_bp_ei_tax   = lt_bp_ei_tax[]
              it_cust_ei_tax = lt_cust_ei_tax[]
          ).
        endif.

*       log message according to direction of mapping
        if direction = direction_bp_cust.
          ls_message-type       = msg_status.
          ls_message-id         = messageclass.
          ls_message-number     = '001'.
          ls_message-message_v1 = <current_guid>-partner.
          ls_message-message_v2 = <current_guid>-customer.
          log_message( ls_message ).
        else.
          ls_message-type       = msg_status.
          ls_message-id         = messageclass.
          ls_message-number     = '002'.
          ls_message-message_v1 = <current_guid>-customer.
          ls_message-message_v2 = <current_guid>-partner.
          log_message( ls_message ).
        endif.

      endif.  "if lt_bp_ei_tax[] <> lt_cust_ei_tax[].

      clear: lt_bp_ei_tax[], ls_cust_ei_data, lt_cust_ei_tax[].

    endloop.

*   change the data on DB
    save_cust_tax_data( ).

*   success message for the package
    ls_message-type       = msg_status.
    ls_message-id         = messageclass.
    ls_message-number     = '008'.
    ls_message-message_v1 = current_package_key-packageno.
    log_message( ls_message ).

  endmethod.                    "synchronize_tax_data

  method convert_partner_tax_data_to_ei.

    data:
      ls_tax_data   like line of et_tax_data,
      ls_ei_bp      type bus_ei_extern,
      ls_error      type cvis_error,
      ls_ei_address type bus_ei_bupa_address,
      lv_country    type char2,
      lcl_fm        type ref to cvi_fm_bp_customer.

    field-symbols:
     <taxnumber>    like line of i_taxnumbers.

    clear et_tax_data.
    lcl_fm = cvi_fm_bp_customer=>get_instance( ).

*   map to customer and back to bp in order to get rid of tax types that don't get mapped (e.g. CH1, DE1, ...)
*   we could do this manually here but reusing the mapping seems to be a good idea if this thing here want's to
*   remain up to date
    loop at i_taxnumbers assigning <taxnumber> where partner = i_partner.
      ls_tax_data-data_key-taxtype = <taxnumber>-taxtype.
      ls_tax_data-data_key-taxnumber = <taxnumber>-taxnum.
      append ls_tax_data to ls_ei_bp-central_data-taxnumber-taxnumbers.
    endloop.

    ls_ei_bp-header-object_task               = task_insert. "has to be Insert, so that BP data will NOT be read
    ls_ei_bp-header-object_instance-bpartner  = i_partner.

*   country of the std address is needed for the mapping, it was read from KNA1
    lv_country = get_cust_country( i_customer ).

    ls_ei_address-currently_valid                  = true.
    ls_ei_address-data-postal-data-standardaddress = true.
    ls_ei_address-data-postal-data-country         = lv_country.
    append ls_ei_address to ls_ei_bp-central_data-address-addresses[].

    ls_ei_bp-central_data-taxnumber-current_state = true.  "has to be set or mapping starts to read partner data
    lcl_fm->map_bp_tax_data(
      exporting i_partner  = ls_ei_bp
      changing  c_customer = es_cust_ei_data
                c_errors   = ls_error
    ).

    if ls_error-is_error = true.
*     log errors, the whole package needs to be analyzed & restarted.
      e_error = true.
      log_cust_cvi_errors(
        exporting i_partner  = i_partner
                  i_customer = i_customer
                  i_errors   = ls_error
      ).
      return.
    endif.

    clear ls_ei_bp.  "has to be cleared 'cause map_customer_tax_data would append identical lines

    es_cust_ei_data-header-object_instance-kunnr              = i_customer.
    es_cust_ei_data-header-object_task                        = task_insert. " has to be set so that the customer data is not read
*   get the country of the std address of BP, it is needed for the mapping
    es_cust_ei_data-central_data-address-postal-data-country  = lv_country.

    lcl_fm->map_customer_tax_data(
      exporting i_customer = es_cust_ei_data
      changing  c_partner  = ls_ei_bp
                c_errors   = ls_error
    ).
    if ls_error-is_error = true.
      e_error = true.
      log_cust_cvi_errors(
        exporting i_partner  = i_partner
                  i_customer = i_customer
                  i_errors   = ls_error
      ).
      return.
    endif.

    et_tax_data[] = ls_ei_bp-central_data-taxnumber-taxnumbers[].

  endmethod.                    "CONVERT_PARTNER_TAX_DATA


  method convert_cust_tax_data_to_ei.

    data:
      ls_ei_cu      type cmds_ei_extern,
      ls_ei_bp      type bus_ei_extern,
      ls_vat_number like line of ls_ei_cu-central_data-vat_number-vat_numbers,
      ls_errors     type cvis_error,
      ls_message    type bapiret2,
      ls_kna1_tax   like line of it_kna1_tax,
      lcl_fm        type ref to cvi_fm_bp_customer.

    field-symbols:
      <knas> like line of it_knas,
      <msg>  like line of ls_errors-messages.


    lcl_fm = cvi_fm_bp_customer=>get_instance( ).

    read table it_kna1_tax into ls_kna1_tax with key kunnr = i_customer.
    if sy-subrc <> 0.
      clear ls_kna1_tax.
    endif.

    loop at it_knas assigning <knas> where kunnr = i_customer.
      ls_vat_number-data_key-land1 = <knas>-land1.
      ls_vat_number-data-stceg     = <knas>-stceg.
      append ls_vat_number to ls_ei_cu-central_data-vat_number-vat_numbers[].
    endloop.
    ls_ei_cu-central_data-address-postal-data-country = ls_kna1_tax-land1.
    move-corresponding ls_kna1_tax to ls_ei_cu-central_data-central-data. "#EC ENHOK
    ls_ei_cu-header-object_task = task_insert.     "has to be set or mapping starts to read the customer data
    lcl_fm->map_customer_tax_data(
      exporting i_customer = ls_ei_cu
      changing  c_partner  = ls_ei_bp
                c_errors   = ls_errors
    ).
    if ls_errors-is_error = true.
*     log errors, the whole package needs to be analyzed & restarted.
      e_error = true.
      ls_message-type       = msg_error.
      ls_message-id         = messageclass.
      ls_message-number     = '003'.
      ls_message-message_v1 = i_partner.
      ls_message-message_v2 = i_customer.
      log_message( ls_message ).
      loop at ls_errors-messages assigning <msg>.
        log_message( <msg> ).
      endloop.
      return.
    endif.

    et_tax_data[] = ls_ei_bp-central_data-taxnumber-taxnumbers[].

  endmethod.                    "convert_customer_tax_data


  method check_cust_for_conflicts.

*   convert partner and customer data into an identical format (EI structure for BP tax data)
    convert_partner_tax_data_to_ei(
      exporting i_partner    = i_partner
                i_customer   = i_customer
                i_taxnumbers = it_taxnumbers
      importing et_tax_data  = et_bp_tax
                e_error      = e_error
    ).
    check e_error = false.

    convert_cust_tax_data_to_ei(
      exporting i_customer   = i_customer
                i_partner    = i_partner
                it_knas      = it_knas_tax
                it_kna1_tax  = it_kna1_tax
      importing et_tax_data  = et_cu_tax
                e_error      = e_error
    ).
    check e_error = false.

*   i_partner_natpers <> ls_kna1_tax-stkzn  - is not a conflict!

    sort: et_cu_tax, et_bp_tax.
    if et_cu_tax[] <> et_bp_tax[]. "only comparing data part: task cannot be filled as we don't do it...
      e_conflict = true.
    endif.

  endmethod.                    "check_cust_for_conflicts

  method set_customer_tax_data_for_run.

    assert cust_current_guids is not initial. "this method should not be called if current_guids is initial and in this case a
*                                         dump makes more sense than reading the whole db table

*   field order is from kna1 to get out the last bits of performance, so if you want to add a field do this also ;)
    select kunnr land1 stcd1 stcd2 stkzn stceg stcdt stcd3 stcd4 from kna1 into table cust_kna1_tax_for_run
           for all entries in cust_current_guids where kunnr = cust_current_guids-customer.

    select * from knas into corresponding fields of table cust_knas_tax_for_run
           for all entries in cust_current_guids where kunnr = cust_current_guids-customer.

  endmethod.                    "GET_CUSTOMER_TAX_DATA

  method get_customer_tax_data_for_run.

    et_kna1_tax[] = cust_kna1_tax_for_run[].
    et_knas_tax[] = cust_knas_tax_for_run[].

  endmethod.                    "GET_CUSTOMER_TAX_DATA

  method get_partner_tax_data_for_run.

    et_taxnumbers[] = partner_taxnumbers_for_run[].

  endmethod.                    "get_partner_tax_for_run

  method set_partner_tax_data_for_run.

    assert cust_current_guids is not initial. "this method should not be called if current_guids is initial and in this case a
*                                         dump makes more sense than reading the whole db table

    select * from dfkkbptaxnum into table partner_taxnumbers_for_run
         for all entries in cust_current_guids where partner = cust_current_guids-partner.

  endmethod.                    "set_partner_tax_for_run

  method get_cust_country.

    field-symbols:
      <kna1>  like line of cust_kna1_tax_for_run[].

    read table cust_kna1_tax_for_run[] assigning <kna1>
        with key kunnr = i_customer.
    assert <kna1> is assigned.
    r_country = <kna1>-land1.
    assert r_country is not initial.

  endmethod.                    "get_cust_country


  method sync_partner_to_customer.
    data:
      ls_kna1_tax like line of kna1_updates,
      ls_knas     like line of knas_inserts.

    field-symbols:
      <vat_number>  like line of is_cust_ei_data-central_data-vat_number-vat_numbers.

*   make an update for the KNA1
    ls_kna1_tax-kunnr = i_customer.
    ls_kna1_tax-land1 = is_cust_ei_data-central_data-address-postal-data-country.
    ls_kna1_tax-stcd1 = is_cust_ei_data-central_data-central-data-stcd1.
    ls_kna1_tax-stcd2 = is_cust_ei_data-central_data-central-data-stcd2.
    ls_kna1_tax-stkzn = i_partner_natpers.
    ls_kna1_tax-stceg = is_cust_ei_data-central_data-central-data-stceg.
    ls_kna1_tax-stcdt = is_cust_ei_data-central_data-central-data-stcdt.
    ls_kna1_tax-stcd3 = is_cust_ei_data-central_data-central-data-stcd3.
    ls_kna1_tax-stcd4 = is_cust_ei_data-central_data-central-data-stcd4.
    append ls_kna1_tax to kna1_updates[].

*   make deletes for KNAS
*   - just note the customer number to delete all entries in KNAS
    append i_customer to knas_deletes[].

*   make inserts for KNAS
    loop at is_cust_ei_data-central_data-vat_number-vat_numbers[] assigning <vat_number>.
      ls_knas-kunnr = i_customer.
      ls_knas-land1 = <vat_number>-data_key-land1.
      ls_knas-stceg = <vat_number>-data-stceg.
      append ls_knas to knas_inserts[].
    endloop.

  endmethod.                    "sync_partner_to_customer

  method sync_customer_to_partner.

    data:
      ls_bptaxnum  type dfkkbptaxnum.
    field-symbols:
      <bp_tax>   like line of it_bp_ei_tax,
      <cust_tax> like line of it_cust_ei_tax.

    ls_bptaxnum-partner = i_partner.

*  make deletes for bp tax data that is mapped
    loop at it_bp_ei_tax assigning <bp_tax>.
      ls_bptaxnum-taxtype = <bp_tax>-data_key-taxtype.
      ls_bptaxnum-taxnum = <bp_tax>-data_key-taxnumber.
      append ls_bptaxnum to bptax_deletes[].
    endloop.

*  make insert for tax data that was mapped from customer
    loop at it_cust_ei_tax assigning <cust_tax>.
      ls_bptaxnum-taxtype = <cust_tax>-data_key-taxtype.
      ls_bptaxnum-taxnum = <cust_tax>-data_key-taxnumber.
      append ls_bptaxnum to bptax_inserts[].
    endloop.

  endmethod.                    "sync_partner_to_customer

  method save_cust_tax_data.

    field-symbols:
      <kna1_tax> like line of kna1_updates[],
      <kunnr>    like line of knas_deletes[].

    delete dfkkbptaxnum from table bptax_deletes[].
    assert sy-subrc = 0.

    insert dfkkbptaxnum from table bptax_inserts[].
    assert sy-subrc = 0.

*   many updates for KNA1 are faster than one array update.
    loop at kna1_updates assigning <kna1_tax>.

      update kna1 set land1 = <kna1_tax>-land1
                      stcd1 = <kna1_tax>-stcd1
                      stcd2 = <kna1_tax>-stcd2
                      stkzn = <kna1_tax>-stkzn
                      stceg = <kna1_tax>-stceg
                      stcdt = <kna1_tax>-stcdt
                      stcd3 = <kna1_tax>-stcd3
                      stcd4 = <kna1_tax>-stcd4
        where kunnr = <kna1_tax>-kunnr.
      assert sy-subrc = 0.

    endloop.

    loop at knas_deletes[] assigning <kunnr>.
      delete from knas where kunnr = <kunnr>.
    endloop.

    insert knas from table knas_inserts[].
    assert sy-dbcnt = lines( knas_inserts[] ).

  endmethod.                    "save_cust_tax_data_on_db

  method lock_all_bps_cust.

    data:
      lt_return  type table of bapiret2.

    field-symbols:
      <guid> like line of cust_current_guids,
      <msg>  like line of lt_return.

    set handler after_commit activation true.

    loop at cust_current_guids assigning <guid>.
      call function 'BUPA_ENQUEUE'
        exporting
          iv_partner          = <guid>-partner
          iv_check_not_number = true
        tables
          et_return           = lt_return.
      loop at lt_return assigning <msg> where type = msg_error or type = msg_abort.
        log_message( <msg> ).
        r_error = true.
      endloop.
      if r_error = true.
        return.
      endif.
    endloop.

  endmethod.                    "lock_all_bps_cust

  method after_commit.

    data:
      lt_return  type table of bapiret2.

    field-symbols:
      <guid> like line of cust_current_guids,
      <msg>  like line of lt_return.

    loop at cust_current_guids assigning <guid>.
      call function 'BUPA_DEQUEUE'
        exporting
          iv_partner          = <guid>-partner
          iv_check_not_number = true
        tables
          et_return           = lt_return.
      loop at lt_return assigning <msg> where type = msg_error or type = msg_abort.
        log_message( <msg> ).
      endloop.
    endloop.

    set handler after_commit activation false.

  endmethod.                    "after_commit

  method log_message.

    call function 'CVI_EMSG_LOG_PUT_MESSAGE'
      exporting
        i_message = i_message.

  endmethod.                    "log_message

  method write_no_of_packages_to_log.

    data:
      ls_message type bapiret2.

    ls_message-type       = msg_status.
    ls_message-id         = 'CVI_CONVERT_LINK'.
    ls_message-number     = '001'.
    ls_message-message_v1 = i_package_count.

    log_message( ls_message ).

  endmethod.                    "write_no_of_packages_to_log

  method log_cust_cvi_errors.

    data:
        ls_message    type bapiret2.

    field-symbols:
      <msg>  like line of i_errors-messages[].

    ls_message-type       = msg_error.
    ls_message-id         = messageclass.
    ls_message-number     = '003'.
    ls_message-message_v1 = i_partner.
    ls_message-message_v2 = i_customer.
    log_message( ls_message ).
    loop at i_errors-messages assigning <msg>.
      log_message( <msg> ).
    endloop.

  endmethod.                    "log_cvi_errors

endclass.                    "cvi_sync_cust_tax_numbers IMPLEMENTATION
