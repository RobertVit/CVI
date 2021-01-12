class CVI_FM_BP_CUSTOMER definition
  public
  inheriting from CVI_FIELD_MAPPING
  final
  create private .

*"* public components of class CVI_FM_BP_CUSTOMER
*"* do not include other source files here!!!
public section.

  events DELIVER_CUSTOMER_DATA
    exporting
      value(I_CURRENT_PARTNER) type BU_PARTNER
      value(I_CURRENT_CUSTOMER_DATA) type ref to CMDS_EI_EXTERN .

  class-methods GET_INSTANCE
    returning
      value(R_INSTANCE) type ref to CVI_FM_BP_CUSTOMER .
  methods MAP_BP_TAX_DATA
    importing
      !I_PARTNER type BUS_EI_EXTERN
    changing
      !C_CUSTOMER type CMDS_EI_EXTERN
      !C_ERRORS type CVIS_ERROR .
  methods MAP_BP_TO_CUSTOMER
    importing
      !I_PARTNER type BUS_EI_EXTERN
    exporting
      !E_ERRORS type CVIS_ERROR
    changing
      !C_CUSTOMER type CMDS_EI_EXTERN .
  methods MAP_CUSTOMER_TAX_DATA
    importing
      !I_CUSTOMER type CMDS_EI_EXTERN
    changing
      !C_PARTNER type BUS_EI_EXTERN
      !C_ERRORS type CVIS_ERROR .
  methods MAP_CUSTOMER_TO_BP
    importing
      !I_CUSTOMER type CMDS_EI_EXTERN
    exporting
      !E_ERRORS type CVIS_ERROR
    changing
      !C_PARTNER type BUS_EI_EXTERN .
protected section.
*"* protected components of class CVI_FM_BP_CUSTOMER
*"* do not include other source files here!!!
private section.
*"* private components of class CVI_FM_BP_CUSTOMER
*"* do not include other source files here!!!

  aliases CVI_MAPPER_BADI_NAME
    for IF_CVI_COMMON_CONSTANTS~CVI_MAPPER_BADI_NAME .
  aliases CVI_MAP_BANKDETAILS_BADI_NAME
    for IF_CVI_COMMON_CONSTANTS~CVI_MAP_BANKDETAILS_BADI_NAME .
  aliases CVI_MAP_CREDIT_CARDS_BADI_NAME
    for IF_CVI_COMMON_CONSTANTS~CVI_MAP_CREDIT_CARDS_BADI_NAME .
  aliases CVI_MAP_TITLE_BADI_NAME
    for IF_CVI_COMMON_CONSTANTS~CVI_MAP_TITLE_BADI_NAME .

  class-data INSTANCE type ref to CVI_FM_BP_CUSTOMER .

  methods GET_ENHANCEMENT_DATA
    importing
      !I_PARTNER type BU_PARTNER
      !I_GROUP type BU_GROUP optional
    changing
      !C_CUSTOMER type CMDS_EI_EXTERN .
  methods MAP_BP_ADDRESS
    importing
      !I_PARTNER type BUS_EI_EXTERN
    changing
      !C_CUSTOMER type CMDS_EI_EXTERN
      !C_ERRORS type CVIS_ERROR .
  methods MAP_BP_BANKDETAILS
    importing
      !I_PARTNER type BUS_EI_EXTERN
    changing
      !C_CUSTOMER type CMDS_EI_EXTERN
      !C_ERRORS type CVIS_ERROR .
  methods MAP_BP_CREDIT_CARDS
    importing
      !I_PARTNER type BUS_EI_EXTERN
    changing
      !C_CUSTOMER type CMDS_EI_EXTERN
      !C_ERRORS type CVIS_ERROR .
  methods MAP_BP_FS_DATA
    importing
      !I_PARTNER type BUS_EI_EXTERN
    changing
      !C_CUSTOMER type CMDS_EI_EXTERN
      !C_ERRORS type CVIS_ERROR .
  methods MAP_BP_GENERAL_DATA
    importing
      !I_PARTNER type BUS_EI_EXTERN
    changing
      !C_CUSTOMER type CMDS_EI_EXTERN
      !C_ERRORS type CVIS_ERROR .
  methods MAP_BP_INDUSTRY_SECTOR
    importing
      !I_PARTNER type BUS_EI_EXTERN
    changing
      !C_CUSTOMER type CMDS_EI_EXTERN
      !C_ERRORS type CVIS_ERROR .
  methods MAP_CUSTOMER_ADDRESS
    importing
      !I_CUSTOMER type CMDS_EI_EXTERN
    changing
      !C_PARTNER type BUS_EI_EXTERN
      !C_ERRORS type CVIS_ERROR .
  methods MAP_CUSTOMER_BANKDETAILS
    importing
      !I_CUSTOMER type CMDS_EI_EXTERN
    changing
      !C_PARTNER type BUS_EI_EXTERN
      !C_ERRORS type CVIS_ERROR .
  methods MAP_CUSTOMER_CREDIT_CARDS
    importing
      !I_CUSTOMER type CMDS_EI_EXTERN
    changing
      !C_PARTNER type BUS_EI_EXTERN
      !C_ERRORS type CVIS_ERROR .
  methods MAP_CUSTOMER_GENERAL_DATA
    importing
      !I_CUSTOMER type CMDS_EI_EXTERN
    changing
      !C_PARTNER type BUS_EI_EXTERN
      !C_ERRORS type CVIS_ERROR .
  methods MAP_CUSTOMER_INDUSTRY_SECTOR
    importing
      !I_CUSTOMER type CMDS_EI_EXTERN
    changing
      !C_PARTNER type BUS_EI_EXTERN
      !C_ERRORS type CVIS_ERROR .
  methods MAP_CUSTOMER_TRADING_PARTNER
    importing
      !I_CUSTOMER type CMDS_EI_EXTERN
    changing
      !C_PARTNER type BUS_EI_EXTERN
      !C_ERRORS type CVIS_ERROR .
ENDCLASS.



CLASS CVI_FM_BP_CUSTOMER IMPLEMENTATION.


method get_enhancement_data.

  data:
    lcl_ka_customer  type ref to cvi_ka_bp_customer,
    lr_customer      type ref to cmds_ei_extern,
    ls_tbd001        type tbd001,
    lv_account_group type ktokd,
    lv_flexible      type xfeld.

  field-symbols:
    <lv_flexible> type any.

  "buffer the predefined account group
  lv_account_group = c_customer-central_data-central-data-ktokd.

  "get current data (e.g. from CVI memory)
  get reference of c_customer into lr_customer.
  raise event deliver_customer_data
    exporting
      i_current_partner       = i_partner
      i_current_customer_data = lr_customer.

  "set the default account group from customizing if no account
  "group is defined at all or flexible handling is forbidden
  if lv_account_group is initial
    and i_group is not initial
    and c_customer-header-object_task = task_modify.
    lcl_ka_customer = cvi_ka_bp_customer=>get_instance( ).
    ls_tbd001 = lcl_ka_customer->get_tbd001_line( i_group = i_group ).
    assign component 'XFLEXIBLE' of structure ls_tbd001 to <lv_flexible>.
    if sy-subrc eq 0.
      lv_flexible = <lv_flexible>.
    endif.
    if c_customer-central_data-central-data-ktokd is initial
      or lv_flexible = abap_false.
      c_customer-central_data-central-data-ktokd = ls_tbd001-ktokd.
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
      c_address = c_customer-central_data-address
      c_errors  = c_errors
  ).

endmethod.


method map_bp_bankdetails.

  data:
     ls_bp_bankdetails       type bus_ei_bankdetail,
     ls_customer_bankdetails type cvis_ei_bankdetail,
     ls_errors               type cvis_error.


  check c_errors-is_error = false.

  ls_bp_bankdetails = i_partner-central_data-bankdetail.

  if i_partner-header-object_task = task_current_state or
     i_partner-header-object_task = task_insert.
    ls_bp_bankdetails-current_state = true.
  endif.

  clear ls_errors.
* call BAdI CVI_MAP_BANKDETAILS
  if not badi_ref_bankdetails is initial.
      call badi badi_ref_bankdetails->map_bp_bankdetails_to_customer
        exporting
          i_partner_guid         = i_partner-header-object_instance-bpartnerguid
          i_customer_id          = c_customer-header-object_instance-kunnr
          i_partner_bankdetails  = ls_bp_bankdetails
        importing
          e_customer_bankdetails = ls_customer_bankdetails
          e_errors               = ls_errors.

      append lines of ls_errors-messages to c_errors-messages.
      c_errors-is_error = ls_errors-is_error.
  endif.

  check c_errors-is_error = false.
  c_customer-central_data-bankdetail = ls_customer_bankdetails.

endmethod.


method map_bp_credit_cards.

  data:
    ls_errors          type cvis_error,
    ls_bp_credit_cards like i_partner-central_data-paycard.

  check c_errors-is_error = false.
  ls_bp_credit_cards = i_partner-central_data-paycard.
  if i_partner-header-object_task = task_current_state.
    ls_bp_credit_cards-current_state = true.
  endif.

  clear ls_errors.
* call BAdI CVI_MAP_CREDIT_CARDS
  if badi_ref_credit_cards is bound.
    call badi badi_ref_credit_cards->map_bp_credit_cards
      exporting
        i_partner_guid          = i_partner-header-object_instance-bpartnerguid
        i_customer_id           = c_customer-header-object_instance-kunnr
        i_partner_credit_cards  = ls_bp_credit_cards
      importing
        e_customer_credit_cards = c_customer-central_data-creditcard
        e_errors                = ls_errors.

    append lines of ls_errors-messages to c_errors-messages.
    c_errors-is_error = ls_errors-is_error.
  endif.

endmethod.


method map_bp_fs_data.

  check c_errors-is_error = false.

  c_customer-central_data-central-data-vbund = i_partner-finserv_data-common-data-fsbp_centrl-vbund.

  case i_partner-header-object_task.
    when task_insert.
*     do nothing
    when task_current_state.
      c_customer-central_data-central-datax-vbund = true.
    when task_update or task_modify.
      c_customer-central_data-central-datax-vbund  = i_partner-finserv_data-common-datax-fsbp_centrl-vbund.
    when others.
*     do nothing
  endcase.

endmethod.


method map_bp_general_data.

  data:
    lv_name_changed    type bapiupdate,
    lv_person_name(130) type c,
    lv_person_name1(40) type c,
    lv_person_name2(40) type c,
    lv_prefix1         type ad_prefixt,
    lv_prefix2         type ad_prefixt.

* Begin of OSS-Note 1920832 (Account Group Change)
  data: ls_table_data type        str_xo_memory_data,
        lcl_bo_cvi    type ref to fsbp_bo_cvi.

  field-symbols:
    <kna1_table> type         cvis_kna1_t,
    <kna1>       like line of <kna1_table>.
* End of OSS-Note 1920832 (Account Group Change)


  check c_errors-is_error = false.

  select single gform
    from  cvic_legform_lnk
    into  c_customer-central_data-central-data-gform
    where legal_enty = i_partner-central_data-common-data-bp_organization-legalform."#EC *

  c_customer-central_data-central-data-loevm        = i_partner-central_data-common-data-bp_centraldata-centralarchivingflag.
  c_customer-central_data-central-data-bbbnr        = i_partner-central_data-common-data-bp_organization-loc_no_1.
  c_customer-central_data-central-data-bbsnr        = i_partner-central_data-common-data-bp_organization-loc_no_2.
  c_customer-central_data-central-data-bubkz        = i_partner-central_data-common-data-bp_organization-chk_digit.
  c_customer-central_data-address-postal-data-title = i_partner-central_data-common-data-bp_centraldata-title_key.
  c_customer-central_data-address-postal-data-sort1 = i_partner-central_data-common-data-bp_centraldata-searchterm1.
  c_customer-central_data-address-postal-data-sort2 = i_partner-central_data-common-data-bp_centraldata-searchterm2.

  if i_partner-central_data-common-data-bp_control-category = bp_as_person.
    if i_partner-central_data-common-datax-bp_person-firstname = true or
       i_partner-central_data-common-datax-bp_person-lastname  = true or
       i_partner-central_data-common-datax-bp_person-prefix1   = true or
       i_partner-central_data-common-datax-bp_person-prefix2   = true or
       i_partner-header-object_task = task_insert                     or
       i_partner-header-object_task = task_current_state.
      lv_name_changed = true.
    endif.
*     prefixes also mapped along with first name and last name
  clear lv_prefix1.

  Select single prefix_txt from tsad4 into lv_prefix1
  where prefix_key = i_partner-central_data-common-data-bp_person-prefix1.

clear lv_person_name1.
clear lv_person_name2.
  clear lv_prefix2.

  Select single prefix_txt from tsad4 into lv_prefix2
  where prefix_key = i_partner-central_data-common-data-bp_person-prefix2.

condense lv_prefix1.
condense lv_prefix2.
lv_person_name1 = i_partner-central_data-common-data-bp_person-firstname.
condense lv_person_name1.
lv_person_name2 = i_partner-central_data-common-data-bp_person-lastname.
condense lv_person_name2.

    concatenate
       lv_person_name1
       lv_prefix1
       lv_prefix2
       lv_person_name2
       into lv_person_name
       in character mode separated by space respecting blanks.
    condense lv_person_name.

    if lv_person_name+40(40) is initial.
      c_customer-central_data-address-postal-data-name   = lv_person_name.
      c_customer-central_data-address-postal-data-name_2 = space.
    else.
    clear lv_person_name.
    concatenate
       lv_person_name1
       lv_prefix1
       lv_prefix2
       into lv_person_name
       in character mode separated by space respecting blanks.
    condense lv_person_name.
      c_customer-central_data-address-postal-data-name   = lv_person_name.
      c_customer-central_data-address-postal-data-name_2 = i_partner-central_data-common-data-bp_person-lastname.
    endif.
  elseif i_partner-central_data-common-data-bp_control-category = bp_as_org.
    c_customer-central_data-address-postal-data-name   = i_partner-central_data-common-data-bp_organization-name1.
    c_customer-central_data-address-postal-data-name_2 = i_partner-central_data-common-data-bp_organization-name2.
    c_customer-central_data-address-postal-data-name_3 = i_partner-central_data-common-data-bp_organization-name3.
    c_customer-central_data-address-postal-data-name_4 = i_partner-central_data-common-data-bp_organization-name4.
  else.
    c_customer-central_data-address-postal-data-name   = i_partner-central_data-common-data-bp_group-namegroup1.
    c_customer-central_data-address-postal-data-name_2 = i_partner-central_data-common-data-bp_group-namegroup2.
  endif.


  case i_partner-header-object_task.

    when task_insert.
*     do nothing

    when task_current_state.
      c_customer-central_data-central-datax-loevm         = true.
      c_customer-central_data-central-datax-bbbnr         = true.
      c_customer-central_data-central-datax-bbsnr         = true.
      c_customer-central_data-central-datax-bubkz         = true.
      c_customer-central_data-central-datax-gform         = true.
      c_customer-central_data-address-postal-datax-title  = true.
      c_customer-central_data-address-postal-datax-sort1  = true.
      c_customer-central_data-address-postal-datax-sort2  = true.
      c_customer-central_data-address-postal-datax-name   = true.
      c_customer-central_data-address-postal-datax-name_2 = true.
      c_customer-central_data-address-postal-datax-name_3 = true.
      c_customer-central_data-address-postal-datax-name_4 = true.

    when task_update or task_modify.
      c_customer-central_data-central-datax-loevm         = i_partner-central_data-common-datax-bp_centraldata-centralarchivingflag.
      c_customer-central_data-central-datax-bbbnr         = i_partner-central_data-common-datax-bp_organization-loc_no_1.
      c_customer-central_data-central-datax-bbsnr         = i_partner-central_data-common-datax-bp_organization-loc_no_2.
      c_customer-central_data-central-datax-bubkz         = i_partner-central_data-common-datax-bp_organization-chk_digit.
      c_customer-central_data-central-datax-gform         = i_partner-central_data-common-datax-bp_organization-legalform.
      c_customer-central_data-address-postal-datax-title  = i_partner-central_data-common-datax-bp_centraldata-title_key.
      c_customer-central_data-address-postal-datax-sort1  = i_partner-central_data-common-datax-bp_centraldata-searchterm1.
      c_customer-central_data-address-postal-datax-sort2  = i_partner-central_data-common-datax-bp_centraldata-searchterm2.
      c_customer-central_data-address-postal-datax-name_3 = i_partner-central_data-common-datax-bp_organization-name3.
      c_customer-central_data-address-postal-datax-name_4 = i_partner-central_data-common-datax-bp_organization-name4.

      if i_partner-central_data-common-data-bp_control-category = bp_as_person.
        c_customer-central_data-address-postal-datax-name   = lv_name_changed.
        c_customer-central_data-address-postal-datax-name_2 = lv_name_changed.
      elseif i_partner-central_data-common-data-bp_control-category = bp_as_org.
        c_customer-central_data-address-postal-datax-name   = i_partner-central_data-common-datax-bp_organization-name1.
        c_customer-central_data-address-postal-datax-name_2 = i_partner-central_data-common-datax-bp_organization-name2.
      else.
        c_customer-central_data-address-postal-datax-name   = i_partner-central_data-common-datax-bp_group-namegroup1.
        c_customer-central_data-address-postal-datax-name_2 = i_partner-central_data-common-datax-bp_group-namegroup2.
      endif.

    when others.
*     do nothing

  endcase.


* Begin of OSS-Note 1920832 (Account Group Change)
  if CMD_EI_API_CHECK=>IS_ACCOUNT_GROUP_CHANGE_POSS( ) = abap_true.

    if c_customer-header-object_task = 'U'.
      lcl_bo_cvi ?= fsbp_business_factory=>get_instance( i_partner-HEADER-OBJECT_INSTANCE-BPARTNER ).
      ls_table_data = lcl_bo_cvi->get_table_data( if_cvi_const_xo_objects_cust=>mo_kna1 ).
      assign ls_table_data-data_new->* to <kna1_table>.
      assert <kna1_table> is assigned.
      read table <kna1_table> assigning <kna1> index 1.
      c_customer-central_data-central-data-ktokd  = <kna1>-ktokd.
      c_customer-central_data-central-datax-ktokd = 'X'.
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
        c_customer-central_data-central-data-brsch = ''.
        c_customer-central_data-central-datax-brsch = true.
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
          c_customer-central_data-central-datax-brsch = true.
          return.
        else.

          read table i_partner-central_data-industry-industries assigning <ind_sector>
            with key data_key-keysystem = lv_standard_ind_sector_type
                     data-ind_default   = false
                     datax-ind_default  = true
                     task               = task_update.

          if <ind_sector> is assigned.
            c_customer-central_data-central-datax-brsch = true.
            return.
          endif.
        endif.

      endif.

    when others.

  endcase.

  check <ind_sector> is assigned.

  c_customer-central_data-central-datax-brsch = true.
  If NOT <ind_sector>-TASK = 'D'.
  try.

      c_customer-central_data-central-data-brsch = fsbp_ind_sector_mapper=>map_bp_to_trbp_deb( <ind_sector>-data_key-ind_sector ).
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
    ls_vat_number   like line of c_customer-central_data-vat_number-vat_numbers,
    ls_errors       like c_errors,
    lt_tax_numbers  like i_partner-central_data-taxnumber-taxnumbers,
    lv_cntry_iso    type intca,
    lv_cntry(3)     type c.
  field-symbols:
    <taxnumbers>    like line of i_partner-central_data-taxnumber-taxnumbers.

  check c_errors-is_error = false.

  c_customer-central_data-vat_number-current_state = true.
  if i_partner-central_data-taxnumber-current_state = true               or
     i_partner-header-object_task                   = task_current_state or
     i_partner-header-object_task                   = task_insert.
    lt_tax_numbers[] = i_partner-central_data-taxnumber-taxnumbers[].
  elseif ( i_partner-header-object_task = task_modify or
           i_partner-header-object_task = task_update ) and
         ( c_customer-central_data-address-postal-datax-countryiso = true or
           c_customer-central_data-address-postal-datax-country    = true or
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

    if ( <taxnumbers>-data_key-taxtype(2) = lv_cntry_iso ) or ( <taxnumbers>-data_key-taxtype(2) = 'GR' and lv_cntry_iso = 'EL' ).

      if <taxnumbers>-task <> task_delete.

        case <taxnumbers>-data_key-taxtype+2(1).
          when '0'.
            IF <taxnumbers>-data_key-taxtype(2) = 'CN'.
              c_customer-central_data-central-data-stcd5 = <taxnumbers>-data_key-taxnumber.
            ELSEIF <taxnumbers>-data_key-taxtype(2) = 'US' AND  <taxnumbers>-data_key-taxtype+2(2) = '01'.
                  IF I_PARTNER-CENTRAL_DATA-COMMON-DATA-BP_CONTROL-CATEGORY = '1' OR I_PARTNER-CENTRAL_DATA-COMMON-DATA-BP_CONTROL-CATEGORY = '3'.
                    c_customer-central_data-central-data-stcd1 = <taxnumbers>-data_key-taxnumber. "if tax category is US01 and bp type is person or group, map it to stcd1
                  ELSE.
                    c_customer-central_data-central-data-stcd2 = <taxnumbers>-data_key-taxnumber. " if type = org, map it to stcd2
                  ENDIF.
            ELSE.
              c_customer-central_data-central-data-stceg = <taxnumbers>-data_key-taxnumber.
            ENDIF.
          when '1'. c_customer-central_data-central-data-stcd1 = <taxnumbers>-data_key-taxnumber.
          when '2'. c_customer-central_data-central-data-stcd2 = <taxnumbers>-data_key-taxnumber.
          when '3'. c_customer-central_data-central-data-stcd3 = <taxnumbers>-data_key-taxnumber.
          when '4'. c_customer-central_data-central-data-stcd4 = <taxnumbers>-data_key-taxnumber.
*          when '5'. c_customer-central_data-central-data-stcd5 = <taxnumbers>-data_key-taxnumber.
          when '5'.
            c_customer-central_data-central-data-stcd5 = <taxnumbers>-data_key-TAXNUMXL.
            IF <taxnumbers>-data_key-TAXNUMXL is INITIAL. "in Extract mode taxnumxl may be empty
              c_customer-central_data-central-data-stcd5 = <taxnumbers>-data_key-taxnumber.
            ENDIF.
          when others.
        endcase.

        if <taxnumbers>-data_key-taxtype(2) = 'AR' and <taxnumbers>-data_key-taxtype+2(1) = '1'.
          case <taxnumbers>-data_key-taxtype+3(1).
            when 'A'. c_customer-central_data-central-data-stcdt = '80'.
            when 'B'. c_customer-central_data-central-data-stcdt = '86'.
            when 'C'. c_customer-central_data-central-data-stcdt = '87'.
            when others.
          endcase.
        endif.

      else.

        case <taxnumbers>-data_key-taxtype+2(1).
          when '0'. clear c_customer-central_data-central-data-stceg.
          when '1'. clear c_customer-central_data-central-data-stcd1.
          when '2'. clear c_customer-central_data-central-data-stcd2.
          when '3'. clear c_customer-central_data-central-data-stcd3.
          when '4'. clear c_customer-central_data-central-data-stcd4.
          when '5'. clear c_customer-central_data-central-data-stcd5.
        endcase.

        if <taxnumbers>-data_key-taxtype(2) = 'AR' and <taxnumbers>-data_key-taxtype+2(1) = '1'.
          clear c_customer-central_data-central-data-stcdt.
        endif.
        if <taxnumbers>-data_key-taxtype(2) = 'CN' and <taxnumbers>-data_key-taxtype+2(1) = '0'.
          clear c_customer-central_data-central-data-stcd5.
        endif.
      endif.

      c_customer-central_data-central-datax-stceg = true.
      c_customer-central_data-central-datax-stcd1 = true.
      c_customer-central_data-central-datax-stcd2 = true.
      c_customer-central_data-central-datax-stcd3 = true.
      c_customer-central_data-central-datax-stcd4 = true.
      c_customer-central_data-central-datax-stcd5 = true.

if <taxnumbers>-data_key-taxtype(2) = 'AR'.
      c_customer-central_data-central-datax-stcdt = true.
endif.

    elseif <taxnumbers>-data_key-taxtype+2(1) = '0' and
           <taxnumbers>-task <> task_delete.

*      ls_vat_number-task           = <taxnumbers>-task.
       ls_vat_number-task           = 'M'.
        call function 'COUNTRY_CODE_ISO_TO_SAP'
          exporting
            iso_code        = <taxnumbers>-data_key-taxtype(2)
          importing
            sap_code        =  lv_cntry
          exceptions
            others          = 2
                   .
      ls_vat_number-data_key-land1 = <taxnumbers>-data_key-taxtype(2).
      ls_vat_number-data-stceg     = <taxnumbers>-data_key-taxnumber.
      append ls_vat_number to c_customer-central_data-vat_number-vat_numbers.


    endif.

  endloop.

  c_customer-central_data-central-data-stkzn  = i_partner-central_data-taxnumber-common-data-nat_person.
  c_customer-central_data-central-datax-stkzn = i_partner-central_data-taxnumber-common-datax-nat_person.

endmethod.


method map_bp_to_customer.

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
      c_customer = c_customer
  ).

  map_bp_general_data(
    exporting
      i_partner  = i_partner
    changing
      c_customer = c_customer
      c_errors   = e_errors
 ).

  map_bp_address(
    exporting
      i_partner  = i_partner
   changing
      c_customer = c_customer
      c_errors   = e_errors
  ).

  map_bp_fs_data(
   exporting
      i_partner  = i_partner
    changing
      c_customer = c_customer
      c_errors   = e_errors
  ).

  map_bp_industry_sector(
    exporting
      i_partner  = i_partner
    changing
      c_customer = c_customer
      c_errors   = e_errors
  ).

  map_bp_bankdetails(
    exporting
      i_partner  = i_partner
    changing
      c_customer = c_customer
      c_errors   = e_errors
  ).

  map_bp_tax_data(
    exporting
      i_partner  = i_partner
    changing
      c_customer = c_customer
      c_errors   = e_errors
  ).

  map_bp_credit_cards(
    exporting
      i_partner  = i_partner
    changing
      c_customer = c_customer
      c_errors   = e_errors
  ).

endmethod.


method map_customer_address.

  data:
    ls_address type bus_ei_bupa_address.

  data: g_additional_data type ref to if_ex_cvi_call_bte.
  FIELD-SYMBOLS : <fs_remarks> TYPE BUS_EI_BUPA_ADDRESSREMARK.

  check c_errors-is_error = false.

  check i_customer-central_data-address is not initial.
* BTE flag not set in non-dialog mode. This causes infinite loop when address data is changed
  call method cl_exithandler=>get_instance
    exporting
      exit_name              = 'CVI_CALL_BTE'
      null_instance_accepted = 'X'
    changing
      instance               = g_additional_data.

  check not g_additional_data is initial.

  call method g_additional_data->set_bte_flag.

  ls_address-task = task_standard.

  ls_address-data-postal-data-standardaddress = true.
  ls_address-data-postal-data-languiso = i_customer-central_data-address-postal-data-langu_iso.

  move-corresponding:
  i_customer-central_data-address-postal to ls_address-data-postal,"#EC ENHOK
  i_customer-central_data-address-remark to ls_address-data-remark."#EC ENHOK
  ls_address-data-postal-data-languiso = i_customer-central_data-address-postal-data-langu_iso.
  c_partner-central_data-common-data-bp_person-correspondlanguage  = i_customer-central_data-address-postal-data-langu.
  c_partner-central_data-common-datax-bp_person-correspondlanguage = true.
  c_partner-central_data-common-data-bp_person-correspondlanguageiso  = i_customer-central_data-address-postal-data-langu_iso.
  c_partner-central_data-common-datax-bp_person-correspondlanguageiso = true.

  IF cl_vs_switch_check=>cmd_vmd_tr_sfw_01( ) IS NOT INITIAL.
    move i_customer-central_data-address-postal-data-county to ls_address-data-postal-data-county.
    move i_customer-central_data-address-postal-data-county_code to ls_address-data-postal-data-county_no.
    move i_customer-central_data-address-postal-data-township to ls_address-data-postal-data-township.
    move i_customer-central_data-address-postal-data-township_code to ls_address-data-postal-data-township_no.
  ENDIF.

  map_cv_version(
    exporting
      i_cvi_version = i_customer-central_data-address-version
    importing
      e_bp_version  = ls_address-data-version
  ).

  map_cv_communication(
    exporting
      i_cvi_communication = i_customer-central_data-address-communication
    importing
      e_bp_communication  = ls_address-data-communication
  ).

  if i_customer-header-object_task = task_insert or
     i_customer-header-object_task = task_current_state.

    translate ls_address-data-postal-datax using ' X'.

    ls_address-data-remark-current_state = 'X'.
    loop at ls_address-data-remark-remarks ASSIGNING <fs_remarks>.
      translate <fs_remarks>-datax using ' X'.
    endloop.
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


method map_customer_bankdetails.

  data:
    ls_customer_bankdetails like i_customer-central_data-bankdetail,
    ls_bp_bankdetails       like c_partner-central_data-bankdetail,
    ls_errors               type cvis_error.

  check c_errors-is_error = false.

  ls_customer_bankdetails = i_customer-central_data-bankdetail.

  if i_customer-header-object_task = task_insert or
     i_customer-header-object_task = task_current_state.
    ls_customer_bankdetails-current_state = true.
  endif.

  clear ls_errors.
* call BAdI CVI_MAP_BANKDETAILS
  if not badi_ref_bankdetails is initial.
      call badi badi_ref_bankdetails->map_customer_bankdetails
        exporting
          i_customer_id          = i_customer-header-object_instance-kunnr
          i_partner_guid         = c_partner-header-object_instance-bpartnerguid
          i_customer_bankdetails = ls_customer_bankdetails
        importing
          e_partner_bankdetails  = ls_bp_bankdetails
          e_errors               = ls_errors.

      append lines of ls_errors-messages to c_errors-messages.
      c_errors-is_error = ls_errors-is_error.
  endif.
  check c_errors-is_error = false.
  c_partner-central_data-bankdetail = ls_bp_bankdetails.

endmethod.


method map_customer_credit_cards.

  data:
    ls_errors            type cvis_error,
    ls_cust_credit_cards like i_customer-central_data-creditcard.

  check c_errors-is_error = false.
  ls_cust_credit_cards = i_customer-central_data-creditcard.
  if i_customer-header-object_task = task_current_state.
    ls_cust_credit_cards-current_state = true.
  endif.

  clear ls_errors.
* call BAdI CVI_MAP_CREDIT_CARDS
  if badi_ref_credit_cards is not initial.
    call badi badi_ref_credit_cards->map_customer_credit_cards
      exporting
        i_customer_id           = i_customer-header-object_instance-kunnr
        i_partner_guid          = c_partner-header-object_instance-bpartnerguid
        i_customer_credit_cards = ls_cust_credit_cards
      importing
        e_partner_credit_cards  = c_partner-central_data-paycard
        e_errors                = ls_errors.

    append lines of ls_errors-messages to c_errors-messages.
    c_errors-is_error = ls_errors-is_error.
  endif.

endmethod.


method map_customer_general_data.

  check c_errors-is_error = false.

  c_partner-central_data-common-data-bp_centraldata-centralarchivingflag = i_customer-central_data-central-data-loevm.
  c_partner-central_data-common-data-bp_organization-loc_no_1            = i_customer-central_data-central-data-bbbnr.
  c_partner-central_data-common-data-bp_organization-loc_no_2            = i_customer-central_data-central-data-bbsnr.
  c_partner-central_data-common-data-bp_organization-chk_digit           = i_customer-central_data-central-data-bubkz.
  c_partner-central_data-common-data-bp_centraldata-searchterm1          = i_customer-central_data-address-postal-data-sort1.
  c_partner-central_data-common-data-bp_centraldata-searchterm2          = i_customer-central_data-address-postal-data-sort2.

  select single legal_enty from cvic_legform_lnk into c_partner-central_data-common-data-bp_organization-legalform
         where  gform = i_customer-central_data-central-data-gform."#EC *

  if i_customer-central_data-address-postal-data-name_2 is initial.
    c_partner-central_data-common-data-bp_person-lastname  = i_customer-central_data-address-postal-data-name.
  else.
    c_partner-central_data-common-data-bp_person-firstname = i_customer-central_data-address-postal-data-name.
    c_partner-central_data-common-data-bp_person-lastname  = i_customer-central_data-address-postal-data-name_2.
  endif.
  c_partner-central_data-common-data-bp_organization-name1 = i_customer-central_data-address-postal-data-name.
  c_partner-central_data-common-data-bp_organization-name2 = i_customer-central_data-address-postal-data-name_2.
  c_partner-central_data-common-data-bp_organization-name3 = i_customer-central_data-address-postal-data-name_3.
  c_partner-central_data-common-data-bp_organization-name4 = i_customer-central_data-address-postal-data-name_4.
  c_partner-central_data-common-data-bp_group-namegroup1   = i_customer-central_data-address-postal-data-name.
  c_partner-central_data-common-data-bp_group-namegroup2   = i_customer-central_data-address-postal-data-name_2.

  case i_customer-header-object_task.

    when task_insert.
*     do nothing

    when task_current_state.
      c_partner-central_data-common-datax-bp_centraldata-centralarchivingflag = true.
      c_partner-central_data-common-datax-bp_organization-loc_no_1            = true.
      c_partner-central_data-common-datax-bp_organization-loc_no_2            = true.
      c_partner-central_data-common-datax-bp_organization-chk_digit           = true.
      c_partner-central_data-common-datax-bp_organization-legalform           = true.
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
      c_partner-central_data-common-datax-bp_centraldata-centralarchivingflag = i_customer-central_data-central-datax-loevm.
      c_partner-central_data-common-datax-bp_organization-loc_no_1            = i_customer-central_data-central-datax-bbbnr.
      c_partner-central_data-common-datax-bp_organization-loc_no_2            = i_customer-central_data-central-datax-bbsnr.
      c_partner-central_data-common-datax-bp_organization-chk_digit           = i_customer-central_data-central-datax-bubkz.
      c_partner-central_data-common-datax-bp_organization-legalform           = i_customer-central_data-central-datax-gform.
      c_partner-central_data-common-datax-bp_centraldata-title_key            = i_customer-central_data-address-postal-datax-title.
      c_partner-central_data-common-datax-bp_centraldata-searchterm1          = i_customer-central_data-address-postal-datax-sort1.
      c_partner-central_data-common-datax-bp_centraldata-searchterm2          = i_customer-central_data-address-postal-datax-sort2.

      c_partner-central_data-common-datax-bp_person-firstname = i_customer-central_data-address-postal-datax-name.
      c_partner-central_data-common-datax-bp_person-lastname  = i_customer-central_data-address-postal-datax-name_2.

      if c_partner-central_data-common-datax-bp_person-lastname = 'X'.
        c_partner-central_data-common-datax-bp_person-firstname = 'X'.
        c_partner-central_data-common-datax-bp_person-prefix1 = 'X'.
        c_partner-central_data-common-datax-bp_person-prefix2 = 'X'.
      elseif c_partner-central_data-common-datax-bp_person-firstname = 'X'.
        c_partner-central_data-common-datax-bp_person-lastname = 'X'.
        c_partner-central_data-common-datax-bp_person-prefix1 = 'X'.
        c_partner-central_data-common-datax-bp_person-prefix2 = 'X'.
      endif.

      c_partner-central_data-common-datax-bp_organization-name1               = i_customer-central_data-address-postal-datax-name.
      c_partner-central_data-common-datax-bp_organization-name2               = i_customer-central_data-address-postal-datax-name_2.
      c_partner-central_data-common-datax-bp_organization-name3               = i_customer-central_data-address-postal-datax-name_3.
      c_partner-central_data-common-datax-bp_organization-name4               = i_customer-central_data-address-postal-datax-name_4.
      c_partner-central_data-common-datax-bp_group-namegroup1                 = i_customer-central_data-address-postal-datax-name.
      c_partner-central_data-common-datax-bp_group-namegroup2                 = i_customer-central_data-address-postal-datax-name_2.

    when others.
*     do nothing

  endcase.

endmethod.


method map_customer_industry_sector.

  data:
    ls_ind_sector  like line of c_partner-central_data-industry-industries,
    ls_message                  type bapiret2,
    lv_msgvar1                  type symsgv,
    lv_msgvar2                  type symsgv,
    lv_bpartner                 type bu_partner,
    lv_bpartner_guid            type bu_partner_guid,
    LT_BUT0IS                   TYPE TABLE OF BUT0IS,
    LS_BUT0IS       like line of LT_BUT0IS.

  if i_customer-header-object_task = task_insert or
     i_customer-header-object_task = task_current_state.
    ls_ind_sector-task = task_standard.
    ls_ind_sector-data-ind_default = true.
    ls_ind_sector-datax-ind_default = true.
    check i_customer-central_data-central-data-brsch is not initial.
  else.
*   Industry is changed for the Customer
    if i_customer-central_data-central-data-brsch is not initial.
      ls_ind_sector-task = task_standard.  "in update mode change the existing BP Industry
      ls_ind_sector-data-ind_default = true.
      ls_ind_sector-datax-ind_default = true.
    elseif i_customer-central_data-central-data-brsch is initial and i_customer-central_data-central-datax-brsch is not initial.
*     Industry is deleted for the Customer
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
          Exit.
        Endif.

        read table LT_BUT0IS into LS_BUT0IS
             with key istype = ls_ind_sector-data_key-keysystem
                      isdef  = true.

        if sy-subrc <> 0.
          Exit.
        endif.

        ls_ind_sector-data_key-ind_sector = LS_BUT0IS-ind_sector.

      endif.
    endif.
  endif.

  if i_customer-central_data-central-data-brsch is not initial.

    ls_ind_sector-data_key-keysystem = fsbp_ind_sector_mapper=>get_standard_ind_sector_type( ).
    try.

        ls_ind_sector-data_key-ind_sector = fsbp_ind_sector_mapper=>map_trbp_deb_to_bp( i_customer-central_data-central-data-brsch ).

      catch cx_fsbp_mapping_error cx_parameter_invalid.

        lv_msgvar1 = i_customer-central_data-central-data-brsch.
        lv_msgvar2 = i_customer-header-object_instance-kunnr.

        ls_message = fsbp_generic_services=>new_message(
          i_class_id  = 'CVI_MAPPING'
          i_type      = fsbp_generic_services=>msg_info
          i_number    = '002'
          i_variable1 = lv_msgvar1
          i_variable2 = text-002
          i_variable3 = lv_msgvar2
        ).
        append ls_message to c_errors-messages.

    endtry.

  endif.

  append ls_ind_sector to c_partner-central_data-industry-industries.

endmethod.


method map_customer_tax_data.

  data:
    ls_tax_number  like line of c_partner-central_data-taxnumber-taxnumbers,
    ls_customer    type cmds_ei_extern,
    ls_errors      type cvis_error,
    lt_master_data type cmds_ei_main,
    ls_master_data type cmds_ei_extern,
    lv_cntry_iso   type intca.
  field-symbols:
     <taxnumbers>  like line of i_customer-central_data-vat_number-vat_numbers.
  constants:
    con_a          type c value 'A',
    con_b          type c value 'B',
    con_c          type c value 'C',
    con_0          type c value '0',
    con_1          type c value '1',
    con_2          type c value '2',
    con_3          type c value '3',
    con_4          type c value '4',
    con_5          type c value '5',
    con_ar         type string value 'AR',
    con_80         type string value '80',
    con_86         type string value '86',
    con_87         type string value '87',
    con_cn         TYPE string value 'CN'.

  check c_errors-is_error = false.

  ls_customer = i_customer.

  if ls_customer-header-object_task <> task_insert and
     ls_customer-header-object_task <> task_current_state.

    check ls_customer-central_data-vat_number          is not initial or
          ls_customer-central_data-central-data-stceg  is not initial or
          ls_customer-central_data-central-datax-stceg is not initial or
          ls_customer-central_data-central-data-stcd1  is not initial or
          ls_customer-central_data-central-datax-stcd1 is not initial or
          ls_customer-central_data-central-data-stcd2  is not initial or
          ls_customer-central_data-central-datax-stcd2 is not initial or
          ls_customer-central_data-central-data-stcd3  is not initial or
          ls_customer-central_data-central-datax-stcd3 is not initial or
          ls_customer-central_data-central-data-stcd4  is not initial or
          ls_customer-central_data-central-datax-stcd4 is not initial or
          ls_customer-central_data-central-data-stcd5  is not initial or
          ls_customer-central_data-central-datax-stcd5 is not initial or
          ls_customer-central_data-central-data-stkzn  is not initial or
          ls_customer-central_data-central-datax-stkzn is not initial.

    append i_customer to lt_master_data-customers.
    cmd_ei_api_extract=>get_data(
     exporting
       is_master_data = lt_master_data
     importing
       es_master_data = lt_master_data
       es_error       = ls_errors
   ).
    append lines of ls_errors-messages to c_errors-messages.
    c_errors-is_error = ls_errors-is_error.
    check c_errors-is_error = false.

    read table lt_master_data-customers into ls_master_data index 1.
    if sy-subrc ne 0.
      c_errors-is_error = false.
      exit.
    endif.
    ls_customer = ls_master_data.

    if ls_customer-central_data-vat_number-current_state = false.
      ls_customer-central_data-vat_number-vat_numbers[] = ls_master_data-central_data-vat_number-vat_numbers[].
    endif.
  endif.

  CALL FUNCTION 'COUNTRY_CODE_SAP_TO_ISO'
      EXPORTING
        SAP_CODE        = ls_customer-central_data-address-postal-data-country
       IMPORTING
         ISO_CODE        = lv_cntry_iso
       EXCEPTIONS
         OTHERS          = 2
              .
  c_partner-central_data-taxnumber-current_state = true.

* STKZN
  c_partner-central_data-taxnumber-common-data-nat_person  = ls_customer-central_data-central-data-stkzn.
  c_partner-central_data-taxnumber-common-datax-nat_person = ls_customer-central_data-central-datax-stkzn.

* STCEG
  if ls_customer-central_data-central-data-stceg is not initial.
    if ls_customer-central_data-central-data-stceg(2) = lv_cntry_iso.
      ls_tax_number-data_key-taxtype(2) = ls_customer-central_data-central-data-stceg(2).
    else.
      ls_tax_number-data_key-taxtype(2) = lv_cntry_iso.
    endif.
*    IF ls_tax_number-data_key-taxtype(2) = 'CH'.
*      ls_tax_number-data_key-taxtype+2(1) = con_1.
*    ELSE.
      ls_tax_number-data_key-taxtype+2(1) = con_0.
*    ENDIF.
    ls_tax_number-data_key-taxnumber    = ls_customer-central_data-central-data-stceg.
    append ls_tax_number to c_partner-central_data-taxnumber-taxnumbers.
  endif.
* STCD1
  if ls_customer-central_data-central-data-stcd1 is not initial.
    if ls_customer-central_data-central-data-stcd1(2) = lv_cntry_iso.
      ls_tax_number-data_key-taxtype(2) = ls_customer-central_data-central-data-stcd1(2).
    else.
      ls_tax_number-data_key-taxtype(2) = lv_cntry_iso.
    endif.
    ls_tax_number-data_key-taxtype+2(1) = con_1.
    ls_tax_number-data_key-taxnumber    = ls_customer-central_data-central-data-stcd1.

    if ls_tax_number-data_key-taxtype(2) = con_ar.
      case ls_customer-central_data-central-data-stcdt.
        when con_80. ls_tax_number-data_key-taxtype+3(1) = con_a.
        when con_86. ls_tax_number-data_key-taxtype+3(1) = con_b.
        when con_87. ls_tax_number-data_key-taxtype+3(1) = con_c.
        when others.
      endcase.
    endif.

    append ls_tax_number to c_partner-central_data-taxnumber-taxnumbers.
  endif.
* STCD2
  CLEAR LS_TAX_NUMBER-DATA_KEY-TAXTYPE.
  if ls_customer-central_data-central-data-stcd2 is not initial.
    if ls_customer-central_data-central-data-stcd2(2) = lv_cntry_iso.
      ls_tax_number-data_key-taxtype(2) = ls_customer-central_data-central-data-stcd2(2).
    else.
      ls_tax_number-data_key-taxtype(2) = lv_cntry_iso.
    endif.
    ls_tax_number-data_key-taxtype+2(1) = con_2.
    ls_tax_number-data_key-taxnumber    = ls_customer-central_data-central-data-stcd2.
    append ls_tax_number to c_partner-central_data-taxnumber-taxnumbers.
  endif.
* STCD3
  CLEAR LS_TAX_NUMBER-DATA_KEY-TAXTYPE.
  if ls_customer-central_data-central-data-stcd3 is not initial.
    if ls_customer-central_data-central-data-stcd3(2) = lv_cntry_iso.
      ls_tax_number-data_key-taxtype(2) = ls_customer-central_data-central-data-stcd3(2).
    else.
      ls_tax_number-data_key-taxtype(2) = lv_cntry_iso.
    endif.
    ls_tax_number-data_key-taxtype+2(1) = con_3.
    ls_tax_number-data_key-taxnumber    = ls_customer-central_data-central-data-stcd3.
    append ls_tax_number to c_partner-central_data-taxnumber-taxnumbers.
  endif.
* STCD4
  CLEAR LS_TAX_NUMBER-DATA_KEY-TAXTYPE.
  if ls_customer-central_data-central-data-stcd4 is not initial.
    if ls_customer-central_data-central-data-stcd4(2) = lv_cntry_iso.
      ls_tax_number-data_key-taxtype(2) = ls_customer-central_data-central-data-stcd4(2).
    else.
      ls_tax_number-data_key-taxtype(2) = lv_cntry_iso.
    endif.
    ls_tax_number-data_key-taxtype+2(1) = con_4.
    ls_tax_number-data_key-taxnumber    = ls_customer-central_data-central-data-stcd4.
    append ls_tax_number to c_partner-central_data-taxnumber-taxnumbers.
  endif.
*

* STCD5
  CLEAR ls_tax_number-data_key-taxnumber.
  if ls_customer-central_data-central-data-stcd5 is not initial.
    if ls_customer-central_data-central-data-stcd5(2) = lv_cntry_iso.
      ls_tax_number-data_key-taxtype(2) = ls_customer-central_data-central-data-stcd5(2).
    else.
      ls_tax_number-data_key-taxtype(2) = lv_cntry_iso.
    endif.
    ls_tax_number-data_key-taxtype+2(1) = con_5.
*    ls_tax_number-data_key-taxnumber    = ls_customer-central_data-central-data-stcd5.
    ls_tax_number-data_key-TAXNUMXL     = ls_customer-central_data-central-data-stcd5.

*    chinese golden tax number is mapped to CN5, Note 2463731
    IF ls_tax_number-data_key-taxtype(2) = con_cn.
      CALL FUNCTION 'BUPA_TAX_TYPE_SELECT_CB'
        EXPORTING
          IV_TAX_TYPE             = ls_tax_number-data_key-taxtype
       EXCEPTIONS
         NOT_FOUND               = 1
         OTHERS                  = 2.
      IF SY-SUBRC <> 0.
       ls_tax_number-data_key-taxtype+2(1) = con_0.
       ls_tax_number-data_key-taxnumber    = ls_customer-central_data-central-data-stcd5.
       clear ls_tax_number-data_key-TAXNUMXL.
      ENDIF.
    ENDIF.
    append ls_tax_number to c_partner-central_data-taxnumber-taxnumbers.
  endif.



  loop at ls_customer-central_data-vat_number-vat_numbers assigning <taxnumbers>.
    ls_tax_number-task                  = <taxnumbers>-task.
    CALL FUNCTION 'COUNTRY_CODE_SAP_TO_ISO'
      EXPORTING
        SAP_CODE        = <taxnumbers>-data_key-land1(3)
       IMPORTING
         ISO_CODE        = lv_cntry_iso
       EXCEPTIONS
         OTHERS          = 2
              .
    ls_tax_number-data_key-taxtype(2)   = lv_cntry_iso.
    ls_tax_number-data_key-taxtype+2(1) = con_0.
    ls_tax_number-data_key-taxnumber    = <taxnumbers>-data-stceg.
    append ls_tax_number to c_partner-central_data-taxnumber-taxnumbers.
  endloop.

endmethod.


method map_customer_to_bp.

  data:
    lv_msgvar1    type symsgv,
    lv_msgvar2    type symsgv,
    ls_message    type bapiret2.

  if i_customer-header-object_task <> task_insert and
     i_customer-header-object_task <> task_current_state and
     i_customer-header-object_task <> task_update and
     i_customer-header-object_task <> task_modify.

    lv_msgvar1 = i_customer-header-object_task.
    lv_msgvar2 = i_customer-header-object_instance-kunnr.

    ls_message = fsbp_generic_services=>new_message(
      i_class_id  = msg_class_cvi
      i_type      = fsbp_generic_services=>msg_error
      i_number    = '001'
      i_variable1 = lv_msgvar1
      i_variable2 = text-002
      i_variable3 = lv_msgvar2
    ).
    append ls_message to e_errors-messages.
    e_errors-is_error = true.
    return.

  endif.

  map_customer_general_data(
    exporting
      i_customer = i_customer
    changing
      c_partner  = c_partner
      c_errors   = e_errors
 ).

  map_customer_address(
    exporting
      i_customer = i_customer
    changing
      c_partner  = c_partner
      c_errors   = e_errors
 ).

  map_customer_trading_partner(
    exporting
      i_customer = i_customer
    changing
      c_partner  = c_partner
      c_errors   = e_errors
 ).

  map_customer_tax_data(
    exporting
      i_customer = i_customer
    changing
      c_partner  = c_partner
      c_errors   = e_errors
 ).

  map_customer_industry_sector(
    exporting
      i_customer = i_customer
    changing
      c_partner  = c_partner
      c_errors   = e_errors
 ).

  map_customer_bankdetails(
    exporting
      i_customer = i_customer
    changing
      c_partner  = c_partner
      c_errors   = e_errors
 ).

  map_customer_credit_cards(
    exporting
      i_customer = i_customer
    changing
      c_partner  = c_partner
      c_errors   = e_errors
 ).

endmethod.


method map_customer_trading_partner.

  check c_errors-is_error = false.

  c_partner-finserv_data-common-data-fsbp_centrl-vbund       = i_customer-central_data-central-data-vbund.

  case i_customer-header-object_task.
    when task_insert.
      c_partner-finserv_data-common-datax-fsbp_centrl-vbund = true.
    when task_current_state.
      c_partner-finserv_data-common-datax-fsbp_centrl-vbund = true.
    when task_update or task_modify.
      c_partner-finserv_data-common-datax-fsbp_centrl-vbund = i_customer-central_data-central-datax-vbund.
    when others.
*     do nothing
  endcase.

endmethod.
ENDCLASS.
