class CVI_FM_BP_VENDOR definition
  public
  inheriting from CVI_FIELD_MAPPING
  final
  create private .

*"* public components of class CVI_FM_BP_VENDOR
*"* do not include other source files here!!!
public section.

  events DELIVER_VENDOR_DATA
    exporting
      value(I_CURRENT_PARTNER) type BU_PARTNER
      value(I_CURRENT_VENDOR_DATA) type ref to VMDS_EI_EXTERN .

  class-methods GET_INSTANCE
    returning
      value(R_INSTANCE) type ref to CVI_FM_BP_VENDOR .
  methods MAP_BP_TO_VENDOR
    importing
      !I_PARTNER type BUS_EI_EXTERN
    exporting
      !E_ERRORS type CVIS_ERROR
    changing
      !C_VENDOR type VMDS_EI_EXTERN .
  methods MAP_VENDOR_TO_BP
    importing
      !I_VENDOR type VMDS_EI_EXTERN
    exporting
      !E_ERRORS type CVIS_ERROR
    changing
      !C_PARTNER type BUS_EI_EXTERN .
  methods MAP_BP_TAX_DATA
    importing
      !I_PARTNER type BUS_EI_EXTERN
    changing
      !C_VENDOR type VMDS_EI_EXTERN
      !C_ERRORS type CVIS_ERROR .
  methods MAP_VENDOR_TAX_DATA
    importing
      !I_VENDOR type VMDS_EI_EXTERN
    changing
      !C_PARTNER type BUS_EI_EXTERN
      !C_ERRORS type CVIS_ERROR .
protected section.
*"* protected components of class CVI_FM_BP_VENDOR
*"* do not include other source files here!!!
private section.
*"* private components of class CVI_FM_BP_VENDOR
*"* do not include other source files here!!!

  class-data INSTANCE type ref to CVI_FM_BP_VENDOR .

  methods GET_ENHANCEMENT_DATA
    importing
      !I_PARTNER type BU_PARTNER
      !I_GROUP type BU_GROUP optional
    changing
      !C_VENDOR type VMDS_EI_EXTERN .
  methods MAP_BP_ADDRESS
    importing
      !I_PARTNER type BUS_EI_EXTERN
    changing
      !C_VENDOR type VMDS_EI_EXTERN
      !C_ERRORS type CVIS_ERROR .
  methods MAP_BP_BANKDETAILS
    importing
      !I_PARTNER type BUS_EI_EXTERN
    changing
      !C_VENDOR type VMDS_EI_EXTERN
      !C_ERRORS type CVIS_ERROR .
  methods MAP_BP_FS_DATA
    importing
      !I_PARTNER type BUS_EI_EXTERN
    changing
      !C_VENDOR type VMDS_EI_EXTERN
      !C_ERRORS type CVIS_ERROR .
  methods MAP_BP_GENERAL_DATA
    importing
      !I_PARTNER type BUS_EI_EXTERN
    changing
      !C_VENDOR type VMDS_EI_EXTERN
      !C_ERRORS type CVIS_ERROR .
  methods MAP_BP_INDUSTRY_SECTOR
    importing
      !I_PARTNER type BUS_EI_EXTERN
    changing
      !C_VENDOR type VMDS_EI_EXTERN
      !C_ERRORS type CVIS_ERROR .
  methods MAP_VENDOR_ADDRESS
    importing
      !I_VENDOR type VMDS_EI_EXTERN
    changing
      !C_PARTNER type BUS_EI_EXTERN
      !C_ERRORS type CVIS_ERROR .
  methods MAP_VENDOR_BANKDETAILS
    importing
      !I_VENDOR type VMDS_EI_EXTERN
    changing
      !C_PARTNER type BUS_EI_EXTERN
      !C_ERRORS type CVIS_ERROR .
  methods MAP_VENDOR_GENERAL_DATA
    importing
      !I_VENDOR type VMDS_EI_EXTERN
    changing
      !C_PARTNER type BUS_EI_EXTERN
      !C_ERRORS type CVIS_ERROR .
  methods MAP_VENDOR_INDUSTRY_SECTOR
    importing
      !I_VENDOR type VMDS_EI_EXTERN
    changing
      !C_PARTNER type BUS_EI_EXTERN
      !C_ERRORS type CVIS_ERROR .
  methods MAP_VENDOR_TRADING_PARTNER
    importing
      !I_VENDOR type VMDS_EI_EXTERN
    changing
      !C_PARTNER type BUS_EI_EXTERN
      !C_ERRORS type CVIS_ERROR .
ENDCLASS.



CLASS CVI_FM_BP_VENDOR IMPLEMENTATION.


method get_enhancement_data.

  data:
    lcl_ka_vendor    type ref to cvi_ka_bp_vendor,
    lr_vendor        type ref to vmds_ei_extern,
    ls_tbc001        type tbc001,
    lv_account_group type ktokk,
    lv_flexible      type xfeld.

  field-symbols:
    <lv_flexible> type any.

  "buffer the predefined account group
  lv_account_group = c_vendor-central_data-central-data-ktokk.

  "get current data (e.g. from CVI memory)
  get reference of c_vendor into lr_vendor.
  raise event deliver_vendor_data
    exporting
      i_current_partner     = i_partner
      i_current_vendor_data = lr_vendor.

  "set the default account group from customizing if no account
  "group is defined at all or flexible handling is forbidden
  if lv_account_group is initial
    and i_group is not initial
    and c_vendor-header-object_task = task_modify.
    lcl_ka_vendor = cvi_ka_bp_vendor=>get_instance( ).
    ls_tbc001 = lcl_ka_vendor->get_tbc001_line( i_group = i_group ).
    assign component 'XFLEXIBLE' of structure ls_tbc001 to <lv_flexible>.
    if sy-subrc eq 0.
      lv_flexible = <lv_flexible>.
    endif.
    if c_vendor-central_data-central-data-ktokk is initial
      or lv_flexible = abap_false.
      c_vendor-central_data-central-data-ktokk = ls_tbc001-ktokk.
    endif.
  endif.
endmethod.


method get_instance.

  if instance is not bound.
    create object instance.
  endif.
  r_instance = instance.

endmethod.


method map_bp_address.

  map_bp_cv_address(
    exporting
      i_partner = i_partner
    changing
      c_address = c_vendor-central_data-address
      c_errors  = c_errors
  ).

endmethod.


method map_bp_bankdetails.

  data:
     ls_bp_bankdetails     type bus_ei_bankdetail,
     ls_vendor_bankdetails type cvis_ei_bankdetail,
     ls_errors             type cvis_error.


  check c_errors-is_error = false.

  ls_bp_bankdetails = i_partner-central_data-bankdetail.

  if i_partner-header-object_task = task_current_state or
     i_partner-header-object_task = task_insert.
    ls_bp_bankdetails-current_state = true.
  endif.

  clear ls_errors.
* call BAdI CVI_MAP_BANKDETAILS
  if not badi_ref_bankdetails is initial.
      call badi badi_ref_bankdetails->map_bp_bankdetails_to_vendor
        exporting
          i_partner_guid        = i_partner-header-object_instance-bpartnerguid
          i_vendor_id           = c_vendor-header-object_instance-lifnr
          i_partner_bankdetails = ls_bp_bankdetails
        importing
          e_vendor_bankdetails  = ls_vendor_bankdetails
          e_errors              = ls_errors.

      append lines of ls_errors-messages to c_errors-messages.
      c_errors-is_error = ls_errors-is_error.
  endif.

  check c_errors-is_error = false.
  c_vendor-central_data-bankdetail = ls_vendor_bankdetails.

endmethod.


method map_bp_fs_data.

  check c_errors-is_error = false.

  c_vendor-central_data-central-data-vbund = i_partner-finserv_data-common-data-fsbp_centrl-vbund.

  case i_partner-header-object_task.
    when task_insert.
*     do nothing
    when task_current_state.
      c_vendor-central_data-central-datax-vbund = true.
    when task_update or task_modify.
      c_vendor-central_data-central-datax-vbund  = i_partner-finserv_data-common-datax-fsbp_centrl-vbund.
    when others.
*     do nothing
  endcase.

endmethod.


method map_bp_general_data.

  data:
    lv_name_changed    type bapiupdate,
    lv_person_name(81) type c.

* Begin of OSS-Note 1920832 (Account Group Change)
  data: ls_table_data type        str_xo_memory_data,
        lcl_bo_cvi    type ref to fsbp_bo_cvi.

  field-symbols:
    <lfa1_table> type         cvis_lfa1_t,
    <lfa1>       like line of <lfa1_table>.
* End of OSS-Note 1920832 (Account Group Change)


  check c_errors-is_error = false.

  c_vendor-central_data-central-data-loevm        = i_partner-central_data-common-data-bp_centraldata-centralarchivingflag.
  c_vendor-central_data-central-data-bbbnr        = i_partner-central_data-common-data-bp_organization-loc_no_1.
  c_vendor-central_data-central-data-bbsnr        = i_partner-central_data-common-data-bp_organization-loc_no_2.
  c_vendor-central_data-central-data-bubkz        = i_partner-central_data-common-data-bp_organization-chk_digit.
  c_vendor-central_data-address-postal-data-title = i_partner-central_data-common-data-bp_centraldata-title_key.
  c_vendor-central_data-address-postal-data-sort1 = i_partner-central_data-common-data-bp_centraldata-searchterm1.
  c_vendor-central_data-address-postal-data-sort2 = i_partner-central_data-common-data-bp_centraldata-searchterm2.

  if i_partner-central_data-common-data-bp_control-category = bp_as_person.
    if i_partner-central_data-common-datax-bp_person-firstname = true or
       i_partner-central_data-common-datax-bp_person-lastname  = true or
       i_partner-header-object_task = task_insert                     or
       i_partner-header-object_task = task_current_state.
      lv_name_changed = true.
    endif.
    concatenate
       i_partner-central_data-common-data-bp_person-firstname
       i_partner-central_data-common-data-bp_person-lastname
       into lv_person_name
       in character mode separated by space respecting blanks.
    condense lv_person_name.

    if lv_person_name+40(40) is initial.
      c_vendor-central_data-address-postal-data-name    = lv_person_name.
    else.
      c_vendor-central_data-address-postal-data-name    = i_partner-central_data-common-data-bp_person-firstname.
      c_vendor-central_data-address-postal-data-name_2  = i_partner-central_data-common-data-bp_person-lastname.
    endif.

* Map Birth place, Birth date and Sex
    c_vendor-central_data-central-data-gbort = i_partner-central_data-common-data-bp_person-birthplace.
    c_vendor-central_data-central-data-gbdat = i_partner-central_data-common-data-bp_person-birthdate.
    if i_partner-central_data-common-data-bp_person-sex = '1'.
      c_vendor-central_data-central-data-sexkz = '2'.
    elseif i_partner-central_data-common-data-bp_person-sex = '2'.
      c_vendor-central_data-central-data-sexkz = '1'.
    endif.

  elseif i_partner-central_data-common-data-bp_control-category = bp_as_org.
    c_vendor-central_data-address-postal-data-name    = i_partner-central_data-common-data-bp_organization-name1.
    c_vendor-central_data-address-postal-data-name_2  = i_partner-central_data-common-data-bp_organization-name2.
    c_vendor-central_data-address-postal-data-name_3  = i_partner-central_data-common-data-bp_organization-name3.
    c_vendor-central_data-address-postal-data-name_4  = i_partner-central_data-common-data-bp_organization-name4.
  else.
    c_vendor-central_data-address-postal-data-name    = i_partner-central_data-common-data-bp_group-namegroup1.
    c_vendor-central_data-address-postal-data-name_2  = i_partner-central_data-common-data-bp_group-namegroup2.
  endif.


  case i_partner-header-object_task.

    when task_insert.
*     do nothing

    when task_current_state.
      c_vendor-central_data-central-datax-loevm         = true.
      c_vendor-central_data-central-datax-bbbnr         = true.
      c_vendor-central_data-central-datax-bbsnr         = true.
      c_vendor-central_data-central-datax-bubkz         = true.
      c_vendor-central_data-central-datax-gbort         = true.
      c_vendor-central_data-central-datax-gbdat         = true.
      c_vendor-central_data-central-datax-sexkz         = true.
      c_vendor-central_data-address-postal-datax-title  = true.
      c_vendor-central_data-address-postal-datax-sort1  = true.
      c_vendor-central_data-address-postal-datax-sort2  = true.
      c_vendor-central_data-address-postal-datax-name   = true.
      c_vendor-central_data-address-postal-datax-name_2 = true.
      c_vendor-central_data-address-postal-datax-name_3 = true.
      c_vendor-central_data-address-postal-datax-name_4 = true.

    when task_update or task_modify.
      c_vendor-central_data-central-datax-loevm         = i_partner-central_data-common-datax-bp_centraldata-centralarchivingflag.
      c_vendor-central_data-central-datax-bbbnr         = i_partner-central_data-common-datax-bp_organization-loc_no_1.
      c_vendor-central_data-central-datax-bbsnr         = i_partner-central_data-common-datax-bp_organization-loc_no_2.
      c_vendor-central_data-central-datax-bubkz         = i_partner-central_data-common-datax-bp_organization-chk_digit.
      c_vendor-central_data-central-datax-gbort         = i_partner-central_data-common-datax-bp_person-birthplace.
      c_vendor-central_data-central-datax-gbdat         = i_partner-central_data-common-datax-bp_person-birthdate.
      c_vendor-central_data-central-datax-sexkz         = i_partner-central_data-common-datax-bp_person-sex.
      c_vendor-central_data-address-postal-datax-title  = i_partner-central_data-common-datax-bp_centraldata-title_key.
      c_vendor-central_data-address-postal-datax-sort1  = i_partner-central_data-common-datax-bp_centraldata-searchterm1.
      c_vendor-central_data-address-postal-datax-sort2  = i_partner-central_data-common-datax-bp_centraldata-searchterm2.
      c_vendor-central_data-address-postal-datax-name_3 = i_partner-central_data-common-datax-bp_organization-name3.
      c_vendor-central_data-address-postal-datax-name_4 = i_partner-central_data-common-datax-bp_organization-name4.

      if i_partner-central_data-common-data-bp_control-category = bp_as_person.
        c_vendor-central_data-address-postal-datax-name   = lv_name_changed.
        c_vendor-central_data-address-postal-datax-name_2 = lv_name_changed.
      elseif i_partner-central_data-common-data-bp_control-category = bp_as_org.
        c_vendor-central_data-address-postal-datax-name   = i_partner-central_data-common-datax-bp_organization-name1.
        c_vendor-central_data-address-postal-datax-name_2 = i_partner-central_data-common-datax-bp_organization-name2.
      else.
        c_vendor-central_data-address-postal-datax-name   = i_partner-central_data-common-datax-bp_group-namegroup1.
        c_vendor-central_data-address-postal-datax-name_2 = i_partner-central_data-common-datax-bp_group-namegroup2.
      endif.

    when others.
*     do nothing

  endcase.


* Begin of OSS-Note 1920832 (Account Group Change)
  if VMD_EI_API_CHECK=>IS_ACCOUNT_GROUP_CHANGE_POSS( ) = abap_true.

    if c_vendor-header-object_task = 'U'.
      lcl_bo_cvi ?= fsbp_business_factory=>get_instance( i_partner-HEADER-OBJECT_INSTANCE-BPARTNER ).
      ls_table_data = lcl_bo_cvi->get_table_data( if_cvi_const_xo_objects_vendor=>mo_lfa1 ).
      assign ls_table_data-data_new->* to <lfa1_table>.
      assert <lfa1_table> is assigned.
      read table <lfa1_table> assigning <lfa1> index 1.
      c_vendor-central_data-central-data-ktokk  = <lfa1>-ktokk.
      c_vendor-central_data-central-datax-ktokk = 'X'.
    endif.

  endif.
* End of OSS-Note 1920832 (Account Group Change)


endmethod.


method map_bp_industry_sector.

  data:
    ls_message                  type bapiret2,
    lv_msgvar1                  type symsgv,
    lv_msgvar2                  type symsgv,
    lv_standard_ind_sector_type type bu_istype,
    lv_obj_task                 type bus_ei_object_task.
  field-symbols:
    <ind_sector>                like line of i_partner-central_data-industry-industries.

  check c_errors-is_error = false.

  lv_standard_ind_sector_type = fsbp_ind_sector_mapper=>get_standard_ind_sector_type( ).

  lv_obj_task = i_partner-header-object_task.
  if i_partner-central_data-industry-current_state = true.
    lv_obj_task = task_current_state.
  endif.

  case lv_obj_task.

    when task_insert or task_current_state.

      read table i_partner-central_data-industry-industries assigning <ind_sector>
        with key data_key-keysystem = lv_standard_ind_sector_type
                 data-ind_default   = true.

      if <ind_sector> is not assigned.
        c_vendor-central_data-central-datax-brsch = true.
        c_vendor-central_data-central-data-brsch = ''.
      endif.

    when task_update or task_modify.

      loop at i_partner-central_data-industry-industries assigning <ind_sector>
        where data_key-keysystem = lv_standard_ind_sector_type
          and data-ind_default   = true
          and ( task = task_insert or ( datax-ind_default = true and ( task = task_modify or task = task_update ) ) ).
        exit.
      endloop.

      if <ind_sector> is not assigned.

        read table i_partner-central_data-industry-industries assigning <ind_sector>
          with key data_key-keysystem = lv_standard_ind_sector_type
                   data-ind_default   = true
                   task               = task_delete.

        if <ind_sector> is assigned.
          c_vendor-central_data-central-datax-brsch = true.
          return.
        else.

          read table i_partner-central_data-industry-industries assigning <ind_sector>
            with key data_key-keysystem = lv_standard_ind_sector_type
                     data-ind_default   = false
                     datax-ind_default  = true
                     task               = task_update.

          if <ind_sector> is assigned.
            c_vendor-central_data-central-datax-brsch = true.
            return.
          endif.
        endif.

      endif.

    when others.

  endcase.

  check <ind_sector> is assigned.

  c_vendor-central_data-central-datax-brsch = true.
  If NOT <ind_sector>-TASK = 'D'.
  try.

      c_vendor-central_data-central-data-brsch = fsbp_ind_sector_mapper=>map_bp_to_trbp_deb( <ind_sector>-data_key-ind_sector ).
    catch cx_fsbp_mapping_error cx_parameter_invalid.

      lv_msgvar1 = <ind_sector>-data_key-ind_sector.
      lv_msgvar2 = i_partner-header-object_instance-bpartner.

      ls_message = fsbp_generic_services=>new_message(
        i_class_id  = msg_class_cvi
        i_type      = fsbp_generic_services=>msg_info
        i_number    = '002'
        i_variable1 = lv_msgvar1
        i_variable2 = text-001
        i_variable3 = lv_msgvar2
      ).
      append ls_message to c_errors-messages.

  endtry.
  ENDIF.
endmethod.


method map_bp_tax_data.

  data:
    lv_country(3)   type c,
    ls_vat_number   like line of c_vendor-central_data-vat_number-vat_numbers,
    ls_errors       like c_errors,
    lt_tax_numbers  like i_partner-central_data-taxnumber-taxnumbers,
    lv_cntry_iso    type intca,
    lv_cntry(3)     type c.
  field-symbols:
    <taxnumbers>    like line of i_partner-central_data-taxnumber-taxnumbers.

  check c_errors-is_error = false.

  c_vendor-central_data-vat_number-current_state = true.
  if i_partner-central_data-taxnumber-current_state = true               or
     i_partner-header-object_task                   = task_current_state or
     i_partner-header-object_task                   = task_insert.
    lt_tax_numbers[] = i_partner-central_data-taxnumber-taxnumbers[].
  elseif ( i_partner-header-object_task = task_modify or
           i_partner-header-object_task = task_update ) and
         ( c_vendor-central_data-address-postal-datax-countryiso = true or
           c_vendor-central_data-address-postal-datax-country    = true or
           i_partner-central_data-taxnumber-taxnumbers[] is not initial ).
    read_all_bp_tax_numbers(
      exporting
        i_partner     = i_partner
      importing
        e_tax_numbers = lt_tax_numbers[]
        e_errors      = ls_errors
    ).
    append lines of ls_errors-messages to c_errors-messages.
    c_errors-is_error = ls_errors-is_error.
    check c_errors-is_error = false.
  endif.

  get_bp_standard_country(
    exporting
      i_partner = i_partner
    importing
      e_country = lv_country
      e_errors  = ls_errors
  ).

  append lines of ls_errors-messages to c_errors-messages.
  c_errors-is_error = ls_errors-is_error.
  check c_errors-is_error = false.

  call function 'COUNTRY_CODE_SAP_TO_ISO'
    exporting
      sap_code        = lv_country
    importing
      iso_code        = lv_cntry_iso
    exceptions
      others          = 2
            .

  loop at lt_tax_numbers assigning <taxnumbers>.

    if <taxnumbers>-data_key-taxtype(2) = lv_cntry_iso.

      if <taxnumbers>-task <> task_delete.
        if lv_cntry_iso = 'DE'.
          case <taxnumbers>-data_key-taxtype+2(1).
            when '0'. c_vendor-central_data-central-data-stceg = <taxnumbers>-data_key-taxnumber.
            when '1'. c_vendor-central_data-central-data-stenr = <taxnumbers>-data_key-taxnumber.
            when '2'. c_vendor-central_data-central-data-stcd1 = <taxnumbers>-data_key-taxnumber.
            when '3'. c_vendor-central_data-central-data-stcd3 = <taxnumbers>-data_key-taxnumber.
            when '4'. c_vendor-central_data-central-data-stcd4 = <taxnumbers>-data_key-taxnumber.
*            when '5'. c_vendor-central_data-central-data-stcd2 = <taxnumbers>-data_key-taxnumber.
             when '5'.
               c_vendor-central_data-central-data-stcd2 = <taxnumbers>-data_key-taxnumxl."DE5 is to map to stcd2
               IF <taxnumbers>-data_key-taxnumxl is INITIAL. "extract mode taxnumxl is empty
                 c_vendor-central_data-central-data-stcd2 = <taxnumbers>-data_key-taxnumber.
               ENDIF.
            when others.
          endcase.
        else.
          case <taxnumbers>-data_key-taxtype+2(1).
            when '0'.
              IF <taxnumbers>-data_key-taxtype(2) = 'CN'.
                c_vendor-central_data-central-data-stcd5 = <taxnumbers>-data_key-taxnumber.
                ELSEIF <taxnumbers>-data_key-taxtype(2) = 'US' AND  <taxnumbers>-data_key-taxtype+2(2) = '01'.
                  IF I_PARTNER-CENTRAL_DATA-COMMON-DATA-BP_CONTROL-CATEGORY = '1' OR I_PARTNER-CENTRAL_DATA-COMMON-DATA-BP_CONTROL-CATEGORY = '3'.
                    c_vendor-central_data-central-data-stcd1 = <taxnumbers>-data_key-taxnumber. "if tax category is US01 and bp type is person or group, map it to stcd1
                  ELSE.
                    c_vendor-central_data-central-data-stcd2 = <taxnumbers>-data_key-taxnumber. " if type = org, map it to stcd2
                  ENDIF.
              ELSE.
                c_vendor-central_data-central-data-stceg = <taxnumbers>-data_key-taxnumber.
              ENDIF.
            when '1'. c_vendor-central_data-central-data-stcd1 = <taxnumbers>-data_key-taxnumber.
            when '2'. c_vendor-central_data-central-data-stcd2 = <taxnumbers>-data_key-taxnumber.
            when '3'. c_vendor-central_data-central-data-stcd3 = <taxnumbers>-data_key-taxnumber.
            when '4'. c_vendor-central_data-central-data-stcd4 = <taxnumbers>-data_key-taxnumber.
            when '5'.
              c_vendor-central_data-central-data-stcd5 = <taxnumbers>-data_key-taxnumxl.
              IF <taxnumbers>-data_key-taxnumxl is INITIAL. "extract mode taxnumxl is empty
                c_vendor-central_data-central-data-stcd5 = <taxnumbers>-data_key-taxnumber.
              ENDIF.
            when others.
          endcase.
        endif.
        if <taxnumbers>-data_key-taxtype(2) = 'AR' and <taxnumbers>-data_key-taxtype+2(1) = '1'.
          case <taxnumbers>-data_key-taxtype+3(1).
            when 'A'. c_vendor-central_data-central-data-stcdt = '80'.
            when 'B'. c_vendor-central_data-central-data-stcdt = '86'.
            when 'C'. c_vendor-central_data-central-data-stcdt = '87'.
            when others.
          endcase.
        endif.
      else.
        if lv_cntry_iso = 'DE'.
          case <taxnumbers>-data_key-taxtype+2(1).
            when '0'. clear c_vendor-central_data-central-data-stceg.
            when '1'. clear c_vendor-central_data-central-data-stenr.
            when '2'. clear c_vendor-central_data-central-data-stcd1.
            when '3'. clear c_vendor-central_data-central-data-stcd3.
            when '4'. clear c_vendor-central_data-central-data-stcd4.
            when '5'. clear c_vendor-central_data-central-data-stcd2.
*            when '5'. clear c_vendor-central_data-central-data-stcd5.
            when others.
          endcase.
        else.
          case <taxnumbers>-data_key-taxtype+2(1).
            when '0'. clear c_vendor-central_data-central-data-stceg.
            when '1'. clear c_vendor-central_data-central-data-stcd1.
            when '2'. clear c_vendor-central_data-central-data-stcd2.
            when '3'. clear c_vendor-central_data-central-data-stcd3.
            when '4'. clear c_vendor-central_data-central-data-stcd4.
            when '5'. clear c_vendor-central_data-central-data-stcd5.
            when others.
          endcase.
        endif.
        if <taxnumbers>-data_key-taxtype(2) = 'AR' and <taxnumbers>-data_key-taxtype+2(1) = '1'.
          clear c_vendor-central_data-central-data-stcdt.
        endif.
        if <taxnumbers>-data_key-taxtype(2) = 'CN' and <taxnumbers>-data_key-taxtype+2(1) = '0'.
          clear c_vendor-central_data-central-data-stcd5.
        endif.
      endif.

      c_vendor-central_data-central-datax-stceg = true.
      c_vendor-central_data-central-datax-stenr = true.
      c_vendor-central_data-central-datax-stcd1 = true.
      c_vendor-central_data-central-datax-stcd2 = true.
      c_vendor-central_data-central-datax-stcd3 = true.
      c_vendor-central_data-central-datax-stcd4 = true.
      c_vendor-central_data-central-datax-stcd5 = true.
      c_vendor-central_data-central-datax-stcdt = true.

    elseif <taxnumbers>-data_key-taxtype+2(1) = '0' and
           <taxnumbers>-task <> task_delete.

*      ls_vat_number-task           = <taxnumbers>-task.
*Note 1128784
      ls_vat_number-task           = 'M'.
        call function 'COUNTRY_CODE_ISO_TO_SAP'
          exporting
            iso_code        = <taxnumbers>-data_key-taxtype(2)
          importing
            sap_code        =  lv_cntry
          exceptions
            others          = 2
                   .
      ls_vat_number-data_key-land1 = lv_cntry.
      ls_vat_number-data-stceg     = <taxnumbers>-data_key-taxnumber.
      append ls_vat_number to c_vendor-central_data-vat_number-vat_numbers.

    endif.

  endloop.

  c_vendor-central_data-central-data-stkzn  = i_partner-central_data-taxnumber-common-data-nat_person.
  c_vendor-central_data-central-datax-stkzn = i_partner-central_data-taxnumber-common-datax-nat_person.

endmethod.


method map_bp_to_vendor.

  data:
    lv_msgvar1    type symsgv,
    lv_msgvar2    type symsgv,
    ls_message    type bapiret2.

  if i_partner-header-object_task <> task_insert and
     i_partner-header-object_task <> task_current_state and
     i_partner-header-object_task <> task_update and
     i_partner-header-object_task <> task_modify and
     i_partner-header-object_task <> task_time.

    lv_msgvar1 = i_partner-header-object_task.
    lv_msgvar2 = i_partner-header-object_instance-bpartner.

    ls_message = fsbp_generic_services=>new_message(
      i_class_id  = msg_class_cvi
      i_type      = fsbp_generic_services=>msg_error
      i_number    = '001'
      i_variable1 = lv_msgvar1
      i_variable2 = text-001
      i_variable3 = lv_msgvar2
    ).
    append ls_message to e_errors-messages.
    e_errors-is_error = true.
    return.

  endif.

  get_enhancement_data(
    exporting
      i_partner  = i_partner-header-object_instance-bpartner
      i_group    = i_partner-central_data-common-data-bp_control-grouping
    changing
      c_vendor   = c_vendor
  ).

  map_bp_general_data(
    exporting
      i_partner  = i_partner
    changing
      c_vendor   = c_vendor
      c_errors   = e_errors
  ).

  map_bp_address(
    exporting
      i_partner  = i_partner
   changing
      c_vendor   = c_vendor
      c_errors   = e_errors
  ).

  map_bp_fs_data(
   exporting
      i_partner  = i_partner
    changing
      c_vendor   = c_vendor
      c_errors   = e_errors
  ).

  map_bp_industry_sector(
    exporting
      i_partner  = i_partner
    changing
      c_vendor   = c_vendor
      c_errors   = e_errors
  ).

  map_bp_bankdetails(
    exporting
      i_partner  = i_partner
    changing
      c_vendor   = c_vendor
      c_errors   = e_errors
  ).

  map_bp_tax_data(
    exporting
      i_partner  = i_partner
    changing
      c_vendor   = c_vendor
      c_errors   = e_errors
  ).

endmethod.


method map_vendor_address.

  data:
    lv_count   type i,
    ls_address type bus_ei_bupa_address.

  field-symbols:
    <comp>     type bapiupdate.

  check c_errors-is_error = false.

  ls_address-task = task_standard.
  ls_address-data-postal-data-standardaddress = true.
  ls_address-data-postal-data-languiso = i_vendor-central_data-address-postal-data-langu_iso.

  move-corresponding:
  i_vendor-central_data-address-postal to ls_address-data-postal,"#EC ENHOK
  i_vendor-central_data-address-remark to ls_address-data-remark."#EC ENHOK
  ls_address-data-postal-data-languiso = i_vendor-central_data-address-postal-data-langu_iso.
  c_partner-central_data-common-data-bp_person-correspondlanguageiso  = i_vendor-central_data-address-postal-data-langu_iso.
  c_partner-central_data-common-datax-bp_person-correspondlanguageiso = i_vendor-central_data-address-postal-datax-langu_iso.

  IF cl_vs_switch_check=>cmd_vmd_tr_sfw_01( ) IS NOT INITIAL.
    move i_vendor-central_data-address-postal-data-county to ls_address-data-postal-data-county.
    move i_vendor-central_data-address-postal-data-county_code to ls_address-data-postal-data-county_no.
    move i_vendor-central_data-address-postal-data-township to ls_address-data-postal-data-township.
    move i_vendor-central_data-address-postal-data-township_code to ls_address-data-postal-data-township_no.
  ENDIF.
  map_cv_version(
    exporting
      i_cvi_version = i_vendor-central_data-address-version
    importing
      e_bp_version  = ls_address-data-version
      ).

  map_cv_communication(
  exporting
    i_cvi_communication = i_vendor-central_data-address-communication
  importing
    e_bp_communication  = ls_address-data-communication
       ).


  if i_vendor-header-object_task = task_insert or
     i_vendor-header-object_task = task_current_state.
    do.
      lv_count = lv_count + 1.
      assign component lv_count of structure ls_address-data-postal-datax to <comp>.
      if sy-subrc <> 0.
        exit.
      endif.
      <comp> = true.
    enddo.
  endif.

* special check for postal code data
* if one of the postal field's (POSTL_COD2 , POSTL_COD3 , PO_BOX)
* datax is set, then set datax for all the other postal fields

  IF ls_address-data-postal-datax-postl_cod2 = 'X'
    OR ls_address-data-postal-datax-postl_cod3 = 'X'
    OR ls_address-data-postal-datax-po_box = 'X'.

    ls_address-data-postal-datax-postl_cod2 = 'X'.
    ls_address-data-postal-datax-postl_cod3 = 'X'.
    ls_address-data-postal-datax-po_box     = 'X'.
  ENDIF.
  append ls_address to c_partner-central_data-address-addresses.

endmethod.


method map_vendor_bankdetails.

  data:
    ls_vendor_bankdetails like i_vendor-central_data-bankdetail,
    ls_bp_bankdetails     like c_partner-central_data-bankdetail,
    ls_errors             type cvis_error.

  check c_errors-is_error = false.

  ls_vendor_bankdetails = i_vendor-central_data-bankdetail.

  if i_vendor-header-object_task = task_insert or
     i_vendor-header-object_task = task_current_state.
    ls_vendor_bankdetails-current_state = true.
  endif.

  clear ls_errors.
* call BAdI CVI_MAP_BANKDETAILS
  if not badi_ref_bankdetails is initial.
      call badi badi_ref_bankdetails->map_vendor_bankdetails
        exporting
          i_vendor_id           = i_vendor-header-object_instance-lifnr
          i_partner_guid        = c_partner-header-object_instance-bpartnerguid
          i_vendor_bankdetails  = ls_vendor_bankdetails
        importing
          e_partner_bankdetails = ls_bp_bankdetails
          e_errors              = ls_errors.

      append lines of ls_errors-messages to c_errors-messages.
      c_errors-is_error = ls_errors-is_error.
  endif.

  check c_errors-is_error = false.
  c_partner-central_data-bankdetail = ls_bp_bankdetails.

endmethod.


method map_vendor_general_data.

  check c_errors-is_error = false.

  c_partner-central_data-common-data-bp_centraldata-centralarchivingflag = i_vendor-central_data-central-data-loevm.
  c_partner-central_data-common-data-bp_organization-loc_no_1            = i_vendor-central_data-central-data-bbbnr.
  c_partner-central_data-common-data-bp_organization-loc_no_2            = i_vendor-central_data-central-data-bbsnr.
  c_partner-central_data-common-data-bp_organization-chk_digit           = i_vendor-central_data-central-data-bubkz.
  c_partner-central_data-common-data-bp_centraldata-title_key            = i_vendor-central_data-address-postal-data-title.
  c_partner-central_data-common-data-bp_centraldata-searchterm1          = i_vendor-central_data-address-postal-data-sort1.
  c_partner-central_data-common-data-bp_centraldata-searchterm2          = i_vendor-central_data-address-postal-data-sort2.

  if i_vendor-central_data-address-postal-data-name_2 is initial.
    c_partner-central_data-common-data-bp_person-lastname  = i_vendor-central_data-address-postal-data-name.
  else.
    c_partner-central_data-common-data-bp_person-firstname = i_vendor-central_data-address-postal-data-name.
    c_partner-central_data-common-data-bp_person-lastname  = i_vendor-central_data-address-postal-data-name_2.
  endif.
  c_partner-central_data-common-data-bp_organization-name1 = i_vendor-central_data-address-postal-data-name.
  c_partner-central_data-common-data-bp_organization-name2 = i_vendor-central_data-address-postal-data-name_2.
  c_partner-central_data-common-data-bp_organization-name3 = i_vendor-central_data-address-postal-data-name_3.
  c_partner-central_data-common-data-bp_organization-name4 = i_vendor-central_data-address-postal-data-name_4.
  c_partner-central_data-common-data-bp_group-namegroup1   = i_vendor-central_data-address-postal-data-name.
  c_partner-central_data-common-data-bp_group-namegroup2   = i_vendor-central_data-address-postal-data-name_2.

  case i_vendor-header-object_task.

    when task_insert.
*     do nothing

    when task_current_state.
      c_partner-central_data-common-datax-bp_centraldata-centralarchivingflag = true.
      c_partner-central_data-common-datax-bp_organization-loc_no_1            = true.
      c_partner-central_data-common-datax-bp_organization-loc_no_2            = true.
      c_partner-central_data-common-datax-bp_organization-chk_digit           = true.
      c_partner-central_data-common-datax-bp_centraldata-title_key            = true.
      c_partner-central_data-common-datax-bp_centraldata-searchterm1          = true.
      c_partner-central_data-common-datax-bp_centraldata-searchterm2          = true.
      c_partner-central_data-common-datax-bp_person-firstname                 = true.
      c_partner-central_data-common-datax-bp_person-lastname                  = true.
      c_partner-central_data-common-datax-bp_organization-name1               = true.
      c_partner-central_data-common-datax-bp_organization-name2               = true.
      c_partner-central_data-common-datax-bp_organization-name3               = true.
      c_partner-central_data-common-datax-bp_organization-name4               = true.
      c_partner-central_data-common-datax-bp_group-namegroup1                 = true.
      c_partner-central_data-common-datax-bp_group-namegroup2                 = true.

    when task_update or task_modify.
      c_partner-central_data-common-datax-bp_centraldata-centralarchivingflag = i_vendor-central_data-central-datax-loevm.
      c_partner-central_data-common-datax-bp_organization-loc_no_1            = i_vendor-central_data-central-datax-bbbnr.
      c_partner-central_data-common-datax-bp_organization-loc_no_2            = i_vendor-central_data-central-datax-bbsnr.
      c_partner-central_data-common-datax-bp_organization-chk_digit           = i_vendor-central_data-central-datax-bubkz.
      c_partner-central_data-common-datax-bp_centraldata-title_key            = i_vendor-central_data-address-postal-datax-title.
      c_partner-central_data-common-datax-bp_centraldata-searchterm1          = i_vendor-central_data-address-postal-datax-sort1.
      c_partner-central_data-common-datax-bp_centraldata-searchterm2          = i_vendor-central_data-address-postal-datax-sort2.

      c_partner-central_data-common-datax-bp_person-firstname = i_vendor-central_data-address-postal-datax-name.
      c_partner-central_data-common-datax-bp_person-lastname  = i_vendor-central_data-address-postal-datax-name_2.

      if c_partner-central_data-common-datax-bp_person-lastname = 'X'.
        c_partner-central_data-common-datax-bp_person-firstname = 'X'.
      elseif c_partner-central_data-common-datax-bp_person-firstname = 'X'.
        c_partner-central_data-common-datax-bp_person-lastname = 'X'.
      endif.

*      c_partner-central_data-common-datax-bp_person-lastname                  = i_vendor-central_data-address-postal-datax-name_2.
      c_partner-central_data-common-datax-bp_organization-name1               = i_vendor-central_data-address-postal-datax-name.
      c_partner-central_data-common-datax-bp_organization-name2               = i_vendor-central_data-address-postal-datax-name_2.
      c_partner-central_data-common-datax-bp_organization-name3               = i_vendor-central_data-address-postal-datax-name_3.
      c_partner-central_data-common-datax-bp_organization-name4               = i_vendor-central_data-address-postal-datax-name_4.
      c_partner-central_data-common-datax-bp_group-namegroup1                 = i_vendor-central_data-address-postal-datax-name.
      c_partner-central_data-common-datax-bp_group-namegroup2                 = i_vendor-central_data-address-postal-datax-name_2.

    when others.
*     do nothing

  endcase.

endmethod.


method map_vendor_industry_sector.

  data:
    ls_ind_sector  like line of c_partner-central_data-industry-industries,
    ls_message                  type bapiret2,
    lv_msgvar1                  type symsgv,
    lv_msgvar2                  type symsgv,
    lv_bpartner                 type bu_partner,
    lv_bpartner_guid            type bu_partner_guid,
    LT_BUT0IS                   TYPE TABLE OF BUT0IS,
    LS_BUT0IS       like line of LT_BUT0IS.

  if i_vendor-header-object_task = task_insert or
     i_vendor-header-object_task = task_current_state.
    ls_ind_sector-task = task_standard.
    ls_ind_sector-data-ind_default = true.
    ls_ind_sector-datax-ind_default = true.
    check i_vendor-central_data-central-data-brsch is not initial.
  else.
*   Industry is changed for the Vendor
    if i_vendor-central_data-central-data-brsch is not initial.
      ls_ind_sector-task = task_standard.  "in update mode change the existing BP Industry
      ls_ind_sector-data-ind_default = true.
      ls_ind_sector-datax-ind_default = true.
    elseif i_vendor-central_data-central-data-brsch is initial and i_vendor-central_data-central-datax-brsch is not initial.
*     Industry is deleted for the Vendor
      ls_ind_sector-task = task_delete.
      ls_ind_sector-data-ind_default = true.
      ls_ind_sector-datax-ind_default = true.
      ls_ind_sector-data_key-keysystem = fsbp_ind_sector_mapper=>get_standard_ind_sector_type( ).
      if c_partner-header-object_instance-bpartner is initial.

        lv_bpartner_guid = c_partner-header-object_instance-bpartnerguid.

        CALL FUNCTION 'BUPA_NUMBERS_GET'
          EXPORTING
            IV_PARTNER_GUID = lv_bpartner_guid
          IMPORTING
            EV_PARTNER      = lv_bpartner.

      else.
        lv_bpartner = c_partner-header-object_instance-bpartner.
      endif.

      if lv_bpartner is not initial.

        CALL FUNCTION 'BUP_BUT0IS_SELECT_WITH_PARTNER'
          EXPORTING
            IV_PARTNER = lv_bpartner
          TABLES
            ET_BUT0IS  = LT_BUT0IS
          EXCEPTIONS
            NOT_FOUND  = 1
            OTHERS     = 2.

        if sy-subrc <> 0.
          exit.
        endif.

        read table LT_BUT0IS into LS_BUT0IS
             with key istype = ls_ind_sector-data_key-keysystem
                      isdef  = true.

        if sy-subrc <> 0.
          exit.
        endif.

        ls_ind_sector-data_key-ind_sector = LS_BUT0IS-ind_sector.

      endif.
    endif.
  endif.

  if i_vendor-central_data-central-data-brsch is not initial.

    ls_ind_sector-data_key-keysystem = fsbp_ind_sector_mapper=>get_standard_ind_sector_type( ).
    try.

        ls_ind_sector-data_key-ind_sector = fsbp_ind_sector_mapper=>map_trbp_deb_to_bp( i_vendor-central_data-central-data-brsch ).

      catch cx_fsbp_mapping_error cx_parameter_invalid.

        lv_msgvar1 = i_vendor-central_data-central-data-brsch.
        lv_msgvar2 = i_vendor-header-object_instance-lifnr.

        ls_message = fsbp_generic_services=>new_message(
          i_class_id  = 'CVI_MAPPING'
          i_type      = fsbp_generic_services=>msg_info
          i_number    = '002'
          i_variable1 = lv_msgvar1
          i_variable2 = text-003
          i_variable3 = lv_msgvar2
        ).
        append ls_message to c_errors-messages.

    endtry.

  endif.

  append ls_ind_sector to c_partner-central_data-industry-industries.

endmethod.


method map_vendor_tax_data.

  data:
    ls_master_data type vmds_ei_extern,
    ls_tax_number  like line of c_partner-central_data-taxnumber-taxnumbers,
    ls_vendor      type vmds_ei_extern,
    ls_errors      type cvis_error,
    lt_master_data type vmds_ei_main,
    lv_cntry_iso   type intca.

  field-symbols:
     <taxnumbers>  like line of i_vendor-central_data-vat_number-vat_numbers.

  check c_errors-is_error = false.

  ls_vendor = i_vendor.
  c_partner-central_data-taxnumber-current_state = true.

  if ls_vendor-header-object_task <> task_insert and
     ls_vendor-header-object_task <> task_current_state.

    check ls_vendor-central_data-vat_number          is not initial or
          ls_vendor-central_data-central-data-stceg  is not initial or
          ls_vendor-central_data-central-datax-stceg is not initial or
          ls_vendor-central_data-central-data-stcd1  is not initial or
          ls_vendor-central_data-central-datax-stcd1 is not initial or
          ls_vendor-central_data-central-data-stcd2  is not initial or
          ls_vendor-central_data-central-datax-stcd2 is not initial or
          ls_vendor-central_data-central-data-stcd3  is not initial or
          ls_vendor-central_data-central-datax-stcd3 is not initial or
          ls_vendor-central_data-central-data-stcd4  is not initial or
          ls_vendor-central_data-central-datax-stcd4 is not initial or
          ls_vendor-central_data-central-data-stcd5  is not initial or
          ls_vendor-central_data-central-datax-stcd5 is not initial or
          ls_vendor-central_data-central-data-stkzn  is not initial or
          ls_vendor-central_data-central-datax-stkzn is not initial or
          ls_vendor-central_data-central-data-stenr  is not initial or
          ls_vendor-central_data-central-datax-stenr is not initial.

    append i_vendor to lt_master_data-vendors.
    call method vmd_ei_api_extract=>get_data
      exporting
        is_master_data = lt_master_data
      importing
        es_master_data = lt_master_data
        es_error       = ls_errors.
    append lines of ls_errors-messages to c_errors-messages.
    c_errors-is_error = ls_errors-is_error.
    check c_errors-is_error = false.

    read table lt_master_data-vendors into ls_master_data index 1.
    if sy-subrc ne 0.
      c_errors-is_error = false.
      exit.
    endif.
    ls_vendor = ls_master_data.
    if ls_vendor-central_data-vat_number-current_state = false.
      ls_vendor-central_data-vat_number-vat_numbers[] = ls_master_data-central_data-vat_number-vat_numbers[].
    endif.

  endif.

  call function 'COUNTRY_CODE_SAP_TO_ISO'
      exporting
        sap_code        = ls_vendor-central_data-address-postal-data-country
       importing
         iso_code        = lv_cntry_iso
       exceptions
         others          = 2
              .
* STCEG
  if ls_vendor-central_data-central-data-stceg is not initial.
    If ls_vendor-central_data-central-data-stceg(2) = lv_cntry_iso.
      ls_tax_number-data_key-taxtype(2)   =  ls_vendor-central_data-central-data-stceg(2).
    ELSE.
      ls_tax_number-data_key-taxtype(2)   =  lv_cntry_iso.
    ENDIF.

**VAT Registration number for Switzerland: Tax type CH1
*    IF ls_tax_number-data_key-taxtype(2) = 'CH'.
*          ls_tax_number-data_key-taxtype+2(1) = '1'.
*    ELSE.
          ls_tax_number-data_key-taxtype+2(1) = '0'. " Switzerland is not an EU country and so VAT not saved in STCEG
*    ENDIF.

    ls_tax_number-data_key-taxnumber    = ls_vendor-central_data-central-data-stceg.
    append ls_tax_number to c_partner-central_data-taxnumber-taxnumbers.
  endif.
* STENR
  if ls_vendor-central_data-central-data-stenr is not initial.
    if lv_cntry_iso = 'DE'.
      ls_tax_number-data_key-taxtype(2)   = 'DE'.
      ls_tax_number-data_key-taxtype+2(1) = '1'.
      ls_tax_number-data_key-taxnumber    = ls_vendor-central_data-central-data-stenr.
      append ls_tax_number to c_partner-central_data-taxnumber-taxnumbers.
    endif.
  endif.
* STCD1
  if ls_vendor-central_data-central-data-stcd1 is not initial.
    ls_tax_number-data_key-taxtype(2)   = lv_cntry_iso.
    if lv_cntry_iso = 'DE'.
      ls_tax_number-data_key-taxtype+2(1) = '2'.
    else.
      ls_tax_number-data_key-taxtype+2(1) = '1'.
    endif.
    ls_tax_number-data_key-taxnumber    = ls_vendor-central_data-central-data-stcd1.

    if ls_tax_number-data_key-taxtype(2) = 'AR'.
      case ls_vendor-central_data-central-data-stcdt.
        when '80'.ls_tax_number-data_key-taxtype+3(1) = 'A'.
        when '86'.ls_tax_number-data_key-taxtype+3(1) = 'B'.
        when '87'.ls_tax_number-data_key-taxtype+3(1) = 'C'.
        when others.
      endcase.
    endif.

    append ls_tax_number to c_partner-central_data-taxnumber-taxnumbers.
  endif.
* STCD2
  CLEAR LS_TAX_NUMBER-DATA_KEY-TAXTYPE.
  if ls_vendor-central_data-central-data-stcd2 is not initial.
    ls_tax_number-data_key-taxtype(2)   = lv_cntry_iso.
    if lv_cntry_iso = 'DE'.
      ls_tax_number-data_key-taxtype+2(1) = '5'.
    else.
      ls_tax_number-data_key-taxtype+2(1) = '2'.
    endif.
    ls_tax_number-data_key-taxnumber    = ls_vendor-central_data-central-data-stcd2.
    append ls_tax_number to c_partner-central_data-taxnumber-taxnumbers.
  endif.
* STCD3
  if ls_vendor-central_data-central-data-stcd3 is not initial.
    ls_tax_number-data_key-taxtype(2)   = lv_cntry_iso.
    ls_tax_number-data_key-taxtype+2(1) = '3'.
    ls_tax_number-data_key-taxnumber    = ls_vendor-central_data-central-data-stcd3.
    append ls_tax_number to c_partner-central_data-taxnumber-taxnumbers.
  endif.
* STCD4
  if ls_vendor-central_data-central-data-stcd4 is not initial.
    ls_tax_number-data_key-taxtype(2)   = lv_cntry_iso.
    ls_tax_number-data_key-taxtype+2(1) = '4'.
    ls_tax_number-data_key-taxnumber    = ls_vendor-central_data-central-data-stcd4.
    append ls_tax_number to c_partner-central_data-taxnumber-taxnumbers.
  endif.

* STCD5
  CLEAR ls_tax_number-data_key-taxnumber.
  if ls_vendor-central_data-central-data-stcd5 is not initial.
    ls_tax_number-data_key-taxtype(2)   = lv_cntry_iso.
    ls_tax_number-data_key-taxtype+2(1) = '5'.
*    ls_tax_number-data_key-taxnumber    = ls_vendor-central_data-central-data-stcd5.
    ls_tax_number-data_key-taxnumxl    = ls_vendor-central_data-central-data-stcd5.


    IF ls_tax_number-data_key-taxtype(2) = 'CN'.
      CALL FUNCTION 'BUPA_TAX_TYPE_SELECT_CB'
        EXPORTING
          IV_TAX_TYPE             = ls_tax_number-data_key-taxtype
       EXCEPTIONS
         NOT_FOUND               = 1
         OTHERS                  = 2.
      IF SY-SUBRC <> 0.
       ls_tax_number-data_key-taxtype+2(1) = '0'.
       ls_tax_number-data_key-taxnumber    = ls_vendor-central_data-central-data-stcd5.
       clear ls_tax_number-data_key-TAXNUMXL.
      ENDIF.
    ENDIF.

    IF lv_cntry_iso = 'DE'.
      CLEAR ls_tax_number.    "stcd5 of vendor in DE is ignored
    ELSE.
      append ls_tax_number to c_partner-central_data-taxnumber-taxnumbers.
    ENDIF.
  endif.


*
  loop at ls_vendor-central_data-vat_number-vat_numbers assigning <taxnumbers>.
    ls_tax_number-task                  = <taxnumbers>-task.
    call function 'COUNTRY_CODE_SAP_TO_ISO'
      exporting
        sap_code        = <taxnumbers>-data_key-land1(3)
       importing
         iso_code        = lv_cntry_iso
       exceptions
         others          = 2
              .
    ls_tax_number-data_key-taxtype(2)   = lv_cntry_iso.
    ls_tax_number-data_key-taxtype+2(1) = '0'.
    ls_tax_number-data_key-taxnumber    = <taxnumbers>-data-stceg.
    append ls_tax_number to c_partner-central_data-taxnumber-taxnumbers.
  endloop.

  c_partner-central_data-taxnumber-common-data-nat_person  = ls_vendor-central_data-central-data-stkzn.
  c_partner-central_data-taxnumber-common-datax-nat_person = ls_vendor-central_data-central-datax-stkzn.

endmethod.


method map_vendor_to_bp.

  data:
    lv_msgvar1    type symsgv,
    lv_msgvar2    type symsgv,
    ls_message    type bapiret2.

  if i_vendor-header-object_task <> task_insert and
     i_vendor-header-object_task <> task_current_state and
     i_vendor-header-object_task <> task_update and
     i_vendor-header-object_task <> task_modify.

    lv_msgvar1 = i_vendor-header-object_task.
    lv_msgvar2 = i_vendor-header-object_instance-lifnr.

    ls_message = fsbp_generic_services=>new_message(
      i_class_id  = msg_class_cvi
      i_type      = fsbp_generic_services=>msg_error
      i_number    = '001'
      i_variable1 = lv_msgvar1
      i_variable2 = text-003
      i_variable3 = lv_msgvar2
    ).
    append ls_message to e_errors-messages.
    e_errors-is_error = true.
    return.

  endif.

  map_vendor_general_data(
    exporting
      i_vendor   = i_vendor
    changing
      c_partner  = c_partner
      c_errors   = e_errors
 ).

  map_vendor_address(
    exporting
      i_vendor   = i_vendor
    changing
      c_partner  = c_partner
      c_errors   = e_errors
 ).

  map_vendor_trading_partner(
    exporting
      i_vendor   = i_vendor
    changing
      c_partner  = c_partner
      c_errors   = e_errors
 ).

  map_vendor_tax_data(
    exporting
      i_vendor   = i_vendor
    changing
      c_partner  = c_partner
      c_errors   = e_errors
 ).

  map_vendor_industry_sector(
    exporting
      i_vendor   = i_vendor
    changing
      c_partner  = c_partner
      c_errors   = e_errors
 ).

  map_vendor_bankdetails(
    exporting
      i_vendor   = i_vendor
    changing
      c_partner  = c_partner
      c_errors   = e_errors
 ).

endmethod.


method map_vendor_trading_partner.

  check c_errors-is_error = false.

  c_partner-finserv_data-common-data-fsbp_centrl-vbund      = i_vendor-central_data-central-data-vbund.

  case i_vendor-header-object_task.
    when task_insert.
      c_partner-finserv_data-common-datax-fsbp_centrl-vbund = true.
    when task_current_state.
      c_partner-finserv_data-common-datax-fsbp_centrl-vbund = true.
    when task_update or task_modify.
      c_partner-finserv_data-common-datax-fsbp_centrl-vbund = i_vendor-central_data-central-datax-vbund.
    when others.
*     do nothing
  endcase.

endmethod.
ENDCLASS.
