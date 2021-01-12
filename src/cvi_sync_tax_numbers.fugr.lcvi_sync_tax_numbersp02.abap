*&---------------------------------------------------------------------*
*&  Include           LCVI_SYNC_TAX_NUMBERSP02
*&---------------------------------------------------------------------*
*       CLASS cvi_sync_vend_tax_numbers DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
class cvi_sync_vend_tax_numbers definition.

* ______________________________________________________________________
  public section.

* >>> attributes

    class-data current_package_key     type bank_str_pp_packagekey.
    class-data vend_run_params         type cvis_conversion_params.

    constants true                     type boole_d                value 'X'. "#EC NOTEXT
    constants false                    type boole_d                value space. "#EC NOTEXT
    constants task_insert              type bus_ei_object_task     value 'I'. "#EC NOTEXT
    constants msg_error                type symsgty                value 'E'. "#EC NOTEXT
    constants msg_status               type symsgty                value 'S'. "#EC NOTEXT
    constants msg_abort                type symsgty                value 'A'. "#EC NOTEXT
    constants messageclass             type symsgid                value 'CVI_SYNC_TAX_NUMBER'. "#EC NOTEXT
    constants direction_bp_vend        type c                      value '3'. "#EC NOTEXT
    constants direction_vend_bp        type c                      value '4'. "#EC NOTEXT

* >>> methods

*   builds the packages for vendor processing
    class-methods build_vend_packages
      importing
        !i_str_param       type cvis_conversion_params
        !i_str_package_key type bank_str_pp_packagekey
      exporting
        !e_limit_high      type bank_dte_pp_objno
        !e_limit_low       type bank_dte_pp_objno
        !e_flg_no_package  type xfeld.

*   vendor: sets the ids for the object that should be processed in the current run
    class-methods set_analysis_objlist_vend
      importing
        !i_str_package_key type bank_str_pp_packagekey
        !i_limit_low       type bank_dte_pp_objno
        !i_limit_high      type bank_dte_pp_objno.

*   vendor:sets the ids for the object that should be processed in the current run
    class-methods set_vend_current_objlist
      importing
        !i_str_param       type cvis_conversion_params
        !i_str_package_key type bank_str_pp_packagekey
        !i_limit_low       type bank_dte_pp_objno
        !i_limit_high      type bank_dte_pp_objno
        !i_xrestart        type xfeld                       "#EC NEEDED
        !i_flg_aborted     type xfeld.                      "#EC NEEDED

*   vendor: starts the analysis for conflicts between vendor and partner tax data
    class-methods analyze_vend_tax_data
      returning
        value(r_error) type boole_d.

*   starts the synchronization for the tax data
    class-methods synchronize_tax_data_vend
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
    class-data vend_current_guids         type cvis_partner_and_guid_vend_t.
    class-data partner_taxnumbers_for_run type com_bupa_buttax_t.
    class-data bptax_deletes              type com_bupa_buttax_t.
    class-data bptax_inserts              type com_bupa_buttax_t.
    class-data vend_lfa1_tax_for_run      type cvis_lfa1_tax_t.
    class-data vend_lfas_tax_for_run      type cvis_lfas_t.
    class-data lfa1_updates               type cvis_lfa1_tax_t.
    class-data lfas_deletes               type cvis_vendor_t.
    class-data lfas_inserts               type cvis_lfas_t.

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

*   fills the attribute vend_lfa1_tax_for run and vend_lfas_tax_for_run with the tax data
*   of ALL the vendors that are processed in this run
    class-methods set_vendor_tax_data_for_run.

*   returns vend_lfa1_tax_for_run[], vend_lfas_tax_for_run[]
    class-methods get_vendor_tax_data_for_run
      exporting
        !et_lfas_tax type cvis_lfas_t
        !et_lfa1_tax type cvis_lfa1_tax_t.

*   returns the country from the vend_lfa1_tax_for_run[]
    class-methods get_vend_country
      importing
        !i_vendor        type lifnr
      returning
        value(r_country) type land1_gp.

*   converts the vendor taxnumbers from the db table structure to the structure of the
*   external interface
    class-methods convert_vend_tax_data_to_ei
      importing
        !i_vendor    type lifnr
        !i_partner   type bu_partner
        !it_lfas     type cvis_lfas_t
        !it_lfa1_tax type cvis_lfa1_tax_t
      exporting
        !et_tax_data type bus_ei_bupa_taxnumber_t
        !e_error     type boole_d.

*   checks if the vendor and partner tax data differ
    class-methods check_vend_for_conflicts
      importing
        !i_partner         type bu_partner
        !i_vendor          type lifnr
        !it_taxnumbers     type com_bupa_buttax_t
        !it_lfas_tax       type cvis_lfas_t
        !it_lfa1_tax       type cvis_lfa1_tax_t
        !i_partner_natpers type bu_natural_person           "#EC NEEDED
      exporting
        !et_bp_tax         type bus_ei_bupa_taxnumber_t
        !et_ve_tax         type bus_ei_bupa_taxnumber_t
        !e_conflict        type boole_d
        !e_error           type boole_d.

*   maps partner tax data to vendor and fills class attributes
*   with resulting entries for DB operations
*      it_bp_tax_data  - tax data for the given BP in EI format
    class-methods sync_partner_to_vendor
      importing
        !i_partner         type bu_partner                  "#EC NEEDED
        !i_vendor          type lifnr
        !i_partner_natpers type bu_natural_person
        !it_bp_tax_data    type bus_ei_bupa_taxnumber_t     "#EC NEEDED
        !is_vend_ei_data   type vmds_ei_extern.

*   maps vendor tax data to partner and fills class attributes
*   with resulting entries for DB operations
    class-methods sync_vendor_to_partner
      importing
        !i_vendor       type lifnr                          "#EC NEEDED
        !i_partner      type bu_partner
        !it_bp_ei_tax   type bus_ei_bupa_taxnumber_t
        !it_vend_ei_tax type bus_ei_bupa_taxnumber_t.

*   Locks all business partners of current package, assigned customers or vendors are locked automatically too
*   if exclusive lock is not possible, then the error messages are logged and e_error is set (the package needs to be restarted).
    class-methods lock_all_bps_vend
      returning
        value(r_error) type boole_d.

*   Handles the event after the COMMIT WORK to unlock all the BPs
    class-methods after_commit
                  for event ev_after_db_change of cl_bank_pp_db_change_mngr
      importing kind_db_change.                             "#EC NEEDED

*   writes the changes of tax data to DB
    class-methods save_vend_tax_data.

*   converts the partner taxnumbers from the db table structure to the structure of the external interface
*   es_vend_ei_data - tax data of bp mapped to complex structure of vendor (only for synchronize - so that the mapping is called only once)
    class-methods convert_partner_tax_data_to_ei
      importing
        !i_partner       type bu_partner
        !i_vendor        type lifnr
        !i_taxnumbers    type com_bupa_buttax_t
      exporting
        !et_tax_data     type bus_ei_bupa_taxnumber_t
        !es_vend_ei_data type vmds_ei_extern
        !e_error         type boole_d.

* technical methods

* logging
    class-methods write_no_of_packages_to_log
      importing
        !i_package_count type numc10 .

*   log the std error message for 033(cvi_sync_tax_number) the (BP,vendor) and cvi errors
    class-methods log_vend_cvi_errors
      importing
        !i_partner type bu_partner
        !i_vendor  type lifnr
        !i_errors  type cvis_error.

endclass.                    "cvi_sync_vend_tax_numbers DEFINITION

*&---------------------------------------------------------------------*
*&       Class (Implementation)  cvi_sync_vend_tax_numbers
*&---------------------------------------------------------------------*
*        Text
*----------------------------------------------------------------------*
class cvi_sync_vend_tax_numbers implementation.

  method set_analysis_objlist_vend.

    data:
      lt_bc001         type table of bc001.
    field-symbols:
      <bc001>        like line of lt_bc001,
      <current_guid> like line of vend_current_guids[].

    clear vend_current_guids[].
    clear partner_taxnumbers_for_run[].
    clear vend_lfa1_tax_for_run[].
    clear vend_lfas_tax_for_run[].
    clear lfa1_updates[].
    clear lfas_deletes[].
    clear lfas_inserts[].
    clear bptax_deletes[].
    clear bptax_inserts[].

    current_limit_low   = i_limit_low.
    current_limit_high  = i_limit_high.
    current_package_key = i_str_package_key.

    select * from bc001 into table lt_bc001
      where partner >= current_limit_low and partner <= current_limit_high.

    assert lt_bc001[] is not initial. "package must have some data

    select partner partner_guid natpers from but000 into corresponding fields of table vend_current_guids[]
           for all entries in lt_bc001[]
           where partner = lt_bc001-partner.

    loop at lt_bc001[] assigning <bc001>.
      read table vend_current_guids assigning <current_guid> with key partner = <bc001>-partner.
      if sy-subrc = 0.
        <current_guid>-vendor = <bc001>-lifnr.
      endif.
    endloop.

  endmethod.                    "set_analysis_objlist_vend

  method set_vend_current_objlist.

    set_analysis_objlist_vend(
       exporting
         i_str_package_key     = i_str_package_key
         i_limit_low           = i_limit_low
         i_limit_high          = i_limit_high
    ).
    vend_run_params = i_str_param.
*        i_xrestart            type xfeld
*        i_flg_aborted         type xfeld.

  endmethod.                    "set_vend_current_objlist

  method analyze_vend_tax_data.

    data:
      lt_bp_tax   type bus_ei_bupa_taxnumber_t,
      lt_bp_dfkk  like partner_taxnumbers_for_run,
      lt_ve_tax   like lt_bp_tax,
      lt_lfas     like vend_lfas_tax_for_run,
      lt_lfa1_tax like vend_lfa1_tax_for_run,
      ls_message  type bapiret2,
      lv_conflict type boole-boole.

    field-symbols:
      <current_guid>     like line of vend_current_guids.

*   read the tax data for the whole package from DB
    set_partner_tax_data_for_run( ).
    set_vendor_tax_data_for_run( ).

*   import the tax data for the current objects
    get_partner_tax_data_for_run(
      importing et_taxnumbers = lt_bp_dfkk
    ).
    get_vendor_tax_data_for_run(
      importing et_lfas_tax = lt_lfas
                et_lfa1_tax = lt_lfa1_tax
    ).

    loop at vend_current_guids assigning <current_guid>.

      check_vend_for_conflicts(
        exporting i_partner         = <current_guid>-partner
                  i_vendor          = <current_guid>-vendor
                  it_taxnumbers     = lt_bp_dfkk
                  it_lfas_tax       = lt_lfas
                  it_lfa1_tax       = lt_lfa1_tax
                  i_partner_natpers = <current_guid>-natpers
        importing et_bp_tax         = lt_bp_tax
                  et_ve_tax         = lt_ve_tax
                  e_conflict        = lv_conflict
                  e_error           = r_error
      ).
      if r_error = true.  return.  endif.

      if lv_conflict = true.
        ls_message-type       = msg_error.
        ls_message-id         = messageclass.
        ls_message-number     = '030'.
        ls_message-message_v1 = <current_guid>-partner.
        ls_message-message_v2 = <current_guid>-vendor.
        log_message( ls_message ).

        if lt_bp_tax[] is initial.
          ls_message-type       = msg_error.
          ls_message-id         = messageclass.
          ls_message-number     = '031'.
          ls_message-message_v1 = <current_guid>-partner.
          log_message( ls_message ).

        elseif lt_ve_tax[] is initial.
          ls_message-type       = msg_error.
          ls_message-id         = messageclass.
          ls_message-number     = '032'.
          ls_message-message_v1 = <current_guid>-vendor.
          log_message( ls_message ).

        endif.
      endif.

      clear: lt_bp_tax, lt_ve_tax, lv_conflict.

    endloop.

    ls_message-type       = msg_status.
    ls_message-id         = messageclass.
    ls_message-number     = '005'.
    ls_message-message_v1 = current_package_key-packageno.
    log_message( ls_message ).

  endmethod.                    "analyze_vend_tax_data

  method build_vend_packages.

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

    select partner from bc001 into table lt_numbers
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

  endmethod.                    "build_vend_packages

  method synchronize_tax_data_vend.

    data:
      lt_bp_ei_tax    type bus_ei_bupa_taxnumber_t,
      lt_vend_ei_tax  like lt_bp_ei_tax,
      ls_vend_ei_data type vmds_ei_extern,
      direction       type cvi_direction_map_tax,
      ls_message      type bapiret2.

    field-symbols:
      <current_guid>  like line of vend_current_guids.

*   read the tax data for the whole package from DB
    set_partner_tax_data_for_run( ).
    set_vendor_tax_data_for_run( ).

*   lock the corresponding objects
    r_error = lock_all_bps_vend( ).
    check r_error = false.

*   start processing & decide direction
    loop at vend_current_guids assigning <current_guid>.
      direction = vend_run_params-tax_mapping_direction.

      convert_partner_tax_data_to_ei(
        exporting i_partner       = <current_guid>-partner
                  i_vendor        = <current_guid>-vendor
                  i_taxnumbers    = partner_taxnumbers_for_run[]
        importing et_tax_data     = lt_bp_ei_tax[]
                  es_vend_ei_data = ls_vend_ei_data
                  e_error         = r_error
      ).
      if r_error = true.  return.  endif.

      convert_vend_tax_data_to_ei(
        exporting i_vendor     = <current_guid>-vendor
                  i_partner    = <current_guid>-partner
                  it_lfas      = vend_lfas_tax_for_run[]
                  it_lfa1_tax  = vend_lfa1_tax_for_run[]
        importing et_tax_data  = lt_vend_ei_tax
                  e_error      = r_error
      ).
      if r_error = true.  return.  endif.

      sort: lt_bp_ei_tax[], lt_vend_ei_tax[].

      if lt_bp_ei_tax[] <> lt_vend_ei_tax[].

        if vend_run_params-auto_direction_change = true.
*       change direction if one object has no tax data
*       (the flag for nat_pers is irrelevant for the direction decision, only tax data matters)
          if lt_bp_ei_tax[] is initial.
            direction = direction_vend_bp.
          elseif lt_vend_ei_tax[] is initial.
            direction = direction_bp_vend.
          endif.
        endif.
        if direction = direction_bp_vend.
          sync_partner_to_vendor(
            exporting
              i_partner          = <current_guid>-partner
              i_vendor           = <current_guid>-vendor
              i_partner_natpers  = <current_guid>-natpers
              it_bp_tax_data     = lt_bp_ei_tax[]
              is_vend_ei_data    = ls_vend_ei_data
          ).
        else.
          sync_vendor_to_partner(
            exporting
              i_partner      = <current_guid>-partner
              i_vendor       = <current_guid>-vendor
              it_bp_ei_tax   = lt_bp_ei_tax[]
              it_vend_ei_tax = lt_vend_ei_tax[]
          ).
        endif.

*       log message according to direction of mapping
        if direction = direction_bp_vend.
          ls_message-type       = msg_status.
          ls_message-id         = messageclass.
          ls_message-number     = '034'.
          ls_message-message_v1 = <current_guid>-partner.
          ls_message-message_v2 = <current_guid>-vendor.
          log_message( ls_message ).
        else.
          ls_message-type       = msg_status.
          ls_message-id         = messageclass.
          ls_message-number     = '035'.
          ls_message-message_v1 = <current_guid>-vendor.
          ls_message-message_v2 = <current_guid>-partner.
          log_message( ls_message ).
        endif.

      endif.  "if lt_bp_ei_tax[] <> lt_vend_ei_tax[].

      clear: lt_bp_ei_tax[], ls_vend_ei_data, lt_vend_ei_tax[].

    endloop.

*   change the data on DB
    save_vend_tax_data( ).

*   success message for the package
    ls_message-type       = msg_status.
    ls_message-id         = messageclass.
    ls_message-number     = '008'.
    ls_message-message_v1 = current_package_key-packageno.
    log_message( ls_message ).

  endmethod.                    "synchronize_tax_data_vend

  method convert_partner_tax_data_to_ei.

    data:
      ls_tax_data   like line of et_tax_data,
      ls_ei_bp      type bus_ei_extern,
      ls_error      type cvis_error,
      ls_ei_address type bus_ei_bupa_address,
      lv_country    type char2,
      lcl_fm        type ref to cvi_fm_bp_vendor.

    field-symbols:
     <taxnumber>    like line of i_taxnumbers.

    clear et_tax_data.
    lcl_fm = cvi_fm_bp_vendor=>get_instance( ).

*   map to vendor and back to bp in order to get rid of tax types that don't get mapped (e.g. CH1, DE1, ...)
*   we could do this manually here but reusing the mapping seems to be a good idea if this thing here want's to
*   remain up to date
    loop at i_taxnumbers assigning <taxnumber> where partner = i_partner.
      ls_tax_data-data_key-taxtype = <taxnumber>-taxtype.
      ls_tax_data-data_key-taxnumber = <taxnumber>-taxnum.
      append ls_tax_data to ls_ei_bp-central_data-taxnumber-taxnumbers.
    endloop.

    ls_ei_bp-header-object_task               = task_insert. "has to be Insert, so that BP data will NOT be read
    ls_ei_bp-header-object_instance-bpartner  = i_partner.

*   country of the std address is needed for the mapping, it was read from LFA1
    lv_country = get_vend_country( i_vendor ).

    ls_ei_address-currently_valid                  = true.
    ls_ei_address-data-postal-data-standardaddress = true.
    ls_ei_address-data-postal-data-country         = lv_country.
    append ls_ei_address to ls_ei_bp-central_data-address-addresses[].

    ls_ei_bp-central_data-taxnumber-current_state = true.  "has to be set or mapping starts to read partner data
    lcl_fm->map_bp_tax_data(
      exporting i_partner  = ls_ei_bp
      changing  c_vendor   = es_vend_ei_data
                c_errors   = ls_error
    ).

    if ls_error-is_error = true.
*     log errors, the whole package needs to be analyzed & restarted.
      e_error = true.
      log_vend_cvi_errors(
        exporting i_partner  = i_partner
                  i_vendor = i_vendor
                  i_errors   = ls_error
      ).
      return.
    endif.

    clear ls_ei_bp.  "has to be cleared 'cause map_vendor_tax_data would append identical lines

    es_vend_ei_data-header-object_instance-lifnr              = i_vendor.
    es_vend_ei_data-header-object_task                        = task_insert. " has to be set so that the vendor data is not read
*   get the country of the std address of BP, it is needed for the mapping
    es_vend_ei_data-central_data-address-postal-data-country  = lv_country.

    lcl_fm->map_vendor_tax_data(
      exporting i_vendor   = es_vend_ei_data
      changing  c_partner  = ls_ei_bp
                c_errors   = ls_error
    ).
    if ls_error-is_error = true.
      e_error = true.
      log_vend_cvi_errors(
        exporting i_partner  = i_partner
                  i_vendor = i_vendor
                  i_errors   = ls_error
      ).
      return.
    endif.

    et_tax_data[] = ls_ei_bp-central_data-taxnumber-taxnumbers[].

  endmethod.                    "convert_partner_tax_data_to_ei

  method convert_vend_tax_data_to_ei.

    data:
      ls_ei_ve      type vmds_ei_extern,
      ls_ei_bp      type bus_ei_extern,
      ls_vat_number like line of ls_ei_ve-central_data-vat_number-vat_numbers,
      ls_errors     type cvis_error,
      ls_message    type bapiret2,
      ls_lfa1_tax   like line of it_lfa1_tax,
      lcl_fm        type ref to cvi_fm_bp_vendor.

    field-symbols:
      <lfas> like line of it_lfas,
      <msg>  like line of ls_errors-messages.


    lcl_fm = cvi_fm_bp_vendor=>get_instance( ).

    read table it_lfa1_tax into ls_lfa1_tax with key lifnr = i_vendor.
    if sy-subrc <> 0.
      clear ls_lfa1_tax.
    endif.

    loop at it_lfas assigning <lfas> where lifnr = i_vendor.
      ls_vat_number-data_key-land1 = <lfas>-land1.
      ls_vat_number-data-stceg     = <lfas>-stceg.
      append ls_vat_number to ls_ei_ve-central_data-vat_number-vat_numbers[].
    endloop.
    ls_ei_ve-central_data-address-postal-data-country = ls_lfa1_tax-land1.
    move-corresponding ls_lfa1_tax to ls_ei_ve-central_data-central-data. "#EC ENHOK
    ls_ei_ve-header-object_task = task_insert.     "has to be set or mapping starts to read the vendor data
    lcl_fm->map_vendor_tax_data(
      exporting i_vendor   = ls_ei_ve
      changing  c_partner  = ls_ei_bp
                c_errors   = ls_errors
    ).
    if ls_errors-is_error = true.
*     log errors, the whole package needs to be analyzed & restarted.
      e_error = true.
      ls_message-type       = msg_error.
      ls_message-id         = messageclass.
      ls_message-number     = '033'.
      ls_message-message_v1 = i_partner.
      ls_message-message_v2 = i_vendor.
      log_message( ls_message ).
      loop at ls_errors-messages assigning <msg>.
        log_message( <msg> ).
      endloop.
      return.
    endif.

    et_tax_data[] = ls_ei_bp-central_data-taxnumber-taxnumbers[].

  endmethod.                    "convert_vend_tax_data_to_ei

  method check_vend_for_conflicts.

*   convert partner and vendor data into an identical format (EI structure for BP tax data)
    convert_partner_tax_data_to_ei(
      exporting i_partner    = i_partner
                i_vendor     = i_vendor
                i_taxnumbers = it_taxnumbers
      importing et_tax_data  = et_bp_tax
                e_error      = e_error
    ).
    check e_error = false.

    convert_vend_tax_data_to_ei(
      exporting i_vendor   = i_vendor
                i_partner    = i_partner
                it_lfas      = it_lfas_tax
                it_lfa1_tax  = it_lfa1_tax
      importing et_tax_data  = et_ve_tax
                e_error      = e_error
    ).
    check e_error = false.

    sort: et_ve_tax, et_bp_tax.
    if et_ve_tax[] <> et_bp_tax[]. "only comparing data part: task cannot be filled as we don't do it...
      e_conflict = true.
    endif.

  endmethod.                    "check_vend_for_conflicts

  method set_vendor_tax_data_for_run.

*   this method should not be called if current_guids is initial and in this case
*   a dump makes more sense than reading the whole db table
    assert vend_current_guids is not initial.

*   field order is from lfa1 to get out the last bits of performance
    select lifnr land1 stcd1 stcd2 stkzn stceg stcdt stcd3 stcd4 stenr from lfa1 into table vend_lfa1_tax_for_run
           for all entries in vend_current_guids where lifnr = vend_current_guids-vendor.

    select * from lfas into corresponding fields of table vend_lfas_tax_for_run
           for all entries in vend_current_guids where lifnr = vend_current_guids-vendor.

  endmethod.                    "set_vendor_tax_data_for_run

  method get_vendor_tax_data_for_run.

    et_lfa1_tax[] = vend_lfa1_tax_for_run[].
    et_lfas_tax[] = vend_lfas_tax_for_run[].

  endmethod.                    "get_vendor_tax_data_for_run

  method get_partner_tax_data_for_run.

    et_taxnumbers[] = partner_taxnumbers_for_run[].

  endmethod.                    "get_partner_tax_for_run

  method set_partner_tax_data_for_run.

*   this method should not be called if current_guids is initial and in this case
*   a dump makes more sense than reading the whole db table
    assert vend_current_guids is not initial.

    select * from dfkkbptaxnum into table partner_taxnumbers_for_run
         for all entries in vend_current_guids where partner = vend_current_guids-partner.

  endmethod.                    "set_partner_tax_for_run

  method get_vend_country.

    field-symbols:
      <lfa1>  like line of vend_lfa1_tax_for_run[].

    read table vend_lfa1_tax_for_run[] assigning <lfa1>
        with key lifnr = i_vendor.
    assert <lfa1> is assigned.
    r_country = <lfa1>-land1.
    assert r_country is not initial.

  endmethod.                    "get_vend_country


  method sync_partner_to_vendor.
    data:
      ls_lfa1_tax like line of lfa1_updates,
      ls_lfas     like line of lfas_inserts.

    field-symbols:
      <vat_number>  like line of is_vend_ei_data-central_data-vat_number-vat_numbers.

*   make an update for the lfa1
    ls_lfa1_tax-lifnr = i_vendor.
    ls_lfa1_tax-land1 = is_vend_ei_data-central_data-address-postal-data-country.
    ls_lfa1_tax-stcd1 = is_vend_ei_data-central_data-central-data-stcd1.
    ls_lfa1_tax-stcd2 = is_vend_ei_data-central_data-central-data-stcd2.
    ls_lfa1_tax-stkzn = i_partner_natpers.
    ls_lfa1_tax-stceg = is_vend_ei_data-central_data-central-data-stceg.
    ls_lfa1_tax-stcdt = is_vend_ei_data-central_data-central-data-stcdt.
    ls_lfa1_tax-stcd3 = is_vend_ei_data-central_data-central-data-stcd3.
    ls_lfa1_tax-stcd4 = is_vend_ei_data-central_data-central-data-stcd4.
    ls_lfa1_tax-stenr = is_vend_ei_data-central_data-central-data-stenr.
    append ls_lfa1_tax to lfa1_updates[].

*   make deletes for lfas
*   - just note the vendor number to delete all entries in lfas
    append i_vendor to lfas_deletes[].

*   make inserts for lfas
    loop at is_vend_ei_data-central_data-vat_number-vat_numbers[] assigning <vat_number>.
      ls_lfas-lifnr = i_vendor.
      ls_lfas-land1 = <vat_number>-data_key-land1.
      ls_lfas-stceg = <vat_number>-data-stceg.
      append ls_lfas to lfas_inserts[].
    endloop.

  endmethod.                    "sync_partner_to_vendor

  method sync_vendor_to_partner.

    data:
      ls_bptaxnum  type dfkkbptaxnum.
    field-symbols:
      <bp_tax>   like line of it_bp_ei_tax,
      <vend_tax> like line of it_vend_ei_tax.

    ls_bptaxnum-partner = i_partner.

*  make deletes for bp tax data that is mapped
    loop at it_bp_ei_tax assigning <bp_tax>.
      ls_bptaxnum-taxtype = <bp_tax>-data_key-taxtype.
      ls_bptaxnum-taxnum = <bp_tax>-data_key-taxnumber.
      append ls_bptaxnum to bptax_deletes[].
    endloop.

*  make insert for tax data that was mapped from vendor
    loop at it_vend_ei_tax assigning <vend_tax>.
      ls_bptaxnum-taxtype = <vend_tax>-data_key-taxtype.
      ls_bptaxnum-taxnum = <vend_tax>-data_key-taxnumber.
      append ls_bptaxnum to bptax_inserts[].
    endloop.

  endmethod.                    "sync_vendor_to_partner

  method save_vend_tax_data.

    field-symbols:
      <lfa1_tax> like line of lfa1_updates[],
      <lifnr>    like line of lfas_deletes[].

    delete dfkkbptaxnum from table bptax_deletes[].
    assert sy-subrc = 0.

    insert dfkkbptaxnum from table bptax_inserts[].
    assert sy-subrc = 0.

*   many updates for lfa1 are faster than one array update.
    loop at lfa1_updates assigning <lfa1_tax>.

      update lfa1 set land1 = <lfa1_tax>-land1
                      stcd1 = <lfa1_tax>-stcd1
                      stcd2 = <lfa1_tax>-stcd2
                      stkzn = <lfa1_tax>-stkzn
                      stceg = <lfa1_tax>-stceg
                      stcdt = <lfa1_tax>-stcdt
                      stcd3 = <lfa1_tax>-stcd3
                      stcd4 = <lfa1_tax>-stcd4
                      stenr = <lfa1_tax>-stenr
        where lifnr = <lfa1_tax>-lifnr.
      assert sy-subrc = 0.

    endloop.

    loop at lfas_deletes[] assigning <lifnr>.
      delete from lfas where lifnr = <lifnr>.
    endloop.

    insert lfas from table lfas_inserts[].
    assert sy-dbcnt = lines( lfas_inserts[] ).

  endmethod.                    "save_vend_tax_data_on_db

  method lock_all_bps_vend.

    data:
      lt_return  type table of bapiret2.

    field-symbols:
      <guid> like line of vend_current_guids,
      <msg>  like line of lt_return.

    set handler after_commit activation true.

    loop at vend_current_guids assigning <guid>.
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
  endmethod.                    "lock_all_bps_vend

  method after_commit.

    data:
      lt_return  type table of bapiret2.

    field-symbols:
      <guid> like line of vend_current_guids,
      <msg>  like line of lt_return.

    loop at vend_current_guids assigning <guid>.
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

  method log_vend_cvi_errors.

    data:
        ls_message    type bapiret2.

    field-symbols:
      <msg>  like line of i_errors-messages[].

    ls_message-type       = msg_error.
    ls_message-id         = messageclass.
    ls_message-number     = '033'.
    ls_message-message_v1 = i_partner.
    ls_message-message_v2 = i_vendor.
    log_message( ls_message ).
    loop at i_errors-messages assigning <msg>.
      log_message( <msg> ).
    endloop.

  endmethod.                    "log_cvi_errors

endclass.                    "cvi_sync_vend_tax_numbers IMPLEMENTATION
