class CVI_FM_BP_VENDOR_CONTACT definition
  public
  inheriting from CVI_FIELD_MAPPING
  final
  create private .

public section.
*"* public components of class CVI_FM_BP_VENDOR_CONTACT
*"* do not include other source files here!!!

  interfaces IF_FSBP_GENERIC_CONSTANTS .

  methods MAP_VC_BUSINESS_ADDRESS
    importing
      !I_VENDOR_CONTACT type VMDS_EI_CONTACTS
    changing
      !C_ERRORS type CVIS_ERROR
      !C_PARTNER type BUS_EI_EXTERN
      !C_PERSON type BUS_EI_EXTERN
      !C_RELATION type BURS_EI_EXTERN .
  class-methods GET_INSTANCE
    returning
      value(R_INSTANCE) type ref to CVI_FM_BP_VENDOR_CONTACT .
  methods MAP_BP_REL_TO_VENDOR_CONTACT
    importing
      !I_PERSON type BUS_EI_EXTERN
      !I_RELATION type BURS_EI_EXTERN
    exporting
      !E_ERRORS type CVIS_ERROR
    changing
      !V_ADDRESS_GUID type SYSUUID_C
      !V_CONTACT type VMDS_EI_CONTACTS .
  methods MAP_PERSON_TO_VENDOR_CONTACT
    importing
      !I_PERSON type BUS_EI_EXTERN
      !I_RELATION type BURS_EI_EXTERN
    exporting
      !E_ERRORS type CVIS_ERROR
    changing
      !V_ADDRESS_GUID type SYSUUID_C
      !V_CONTACT type VMDS_EI_CONTACTS .
  methods MAP_VEND_CONT_TO_BP_AND_REL
    importing
      !I_VENDOR_CONTACT type VMDS_EI_CONTACTS
    exporting
      !E_ERRORS type CVIS_ERROR
    changing
      !C_PARTNER type BUS_EI_EXTERN
      !C_PERSON type BUS_EI_EXTERN
      !C_RELATION type BURS_EI_EXTERN .
  methods MAP_BP_GENERAL_DATA
    importing
      !I_PERSON type BUS_EI_EXTERN
    changing
      !V_CONTACT type VMDS_EI_CONTACTS .
  methods MAP_BP_RELATION_BUSINESS_HOURS
    importing
      !I_RELATION type BURS_EI_EXTERN
    changing
      !V_CONTACT type VMDS_EI_CONTACTS .
  methods MAP_BP_ADDRESS
    importing
      !I_PERSON type BUS_EI_EXTERN
    changing
      !V_CONTACT type VMDS_EI_CONTACTS .
  methods MAP_BP_RELATION_DATA
    importing
      !I_RELATION type BURS_EI_EXTERN
    changing
      !V_CONTACT type VMDS_EI_CONTACTS .
  methods MAP_BP_RELATION_ADDRESS
    importing
      !I_RELATION type BURS_EI_EXTERN
    changing
      !V_ADDRESS_GUID type SYSUUID_C
      !V_CONTACT type VMDS_EI_CONTACTS .
  methods MAP_BP_BUSINESS_ADDRESS
    importing
      !I_PARTNER type BUS_EI_EXTERN
      !I_RELATION type BURS_EI_EXTERN
    changing
      !C_ERRORS type CVIS_ERROR
      !V_CONTACT type VMDS_EI_CONTACTS .
  methods MAP_BP_REL_BUSINESS_ADDRESS
    importing
      !I_PARTNER type BUS_EI_EXTERN
      !I_PERSON type BUS_EI_EXTERN
      !I_RELATION type BURS_EI_EXTERN
    changing
      !V_ADDRESS_GUID type SYSUUID_C
      !C_ERRORS type CVIS_ERROR
      !V_CONTACT type VMDS_EI_CONTACTS .
  methods MAP_PERSON_BUSINESS_ADDRESS
    importing
      !I_PERSON type BUS_EI_EXTERN
    changing
      !C_ERRORS type CVIS_ERROR
      !V_CONTACT type VMDS_EI_CONTACTS .
  methods MAP_VC_CONTACT_ADDRESS
    importing
      !I_CONTACT type VMDS_EI_CONTACTS
    changing
      !C_PARTNER type BUS_EI_EXTERN
      !C_PERSON type BUS_EI_EXTERN
      !C_RELATION type BURS_EI_EXTERN .
  methods MAP_VC_GENERAL_DATA
    importing
      !I_CONTACT type VMDS_EI_CONTACTS
    changing
      !C_PERSON type BUS_EI_EXTERN
      !C_RELATION type BURS_EI_EXTERN .
  methods MAP_VC_PRIVATE_ADDRESS
    importing
      !I_CONTACT type VMDS_EI_CONTACTS
    changing
      !C_PERSON type BUS_EI_EXTERN .
  methods MAP_VC_BUSINESS_HOURS
    importing
      !I_CONTACT type VMDS_EI_CONTACTS
    changing
      !C_RELATION type BURS_EI_EXTERN .
protected section.
*"* protected components of class CVI_FM_BP_VENDOR_CONTACT
*"* do not include other source files here!!!
private section.
*"* private components of class CVI_FM_BP_VENDOR_CONTACT
*"* do not include other source files here!!!

  aliases ACTIVITY_CHANGE
    for IF_FSBP_GENERIC_CONSTANTS~ACTIVITY_CHANGE .
  aliases ACTIVITY_CREATE
    for IF_FSBP_GENERIC_CONSTANTS~ACTIVITY_CREATE .
  aliases ACTIVITY_DISPLAY
    for IF_FSBP_GENERIC_CONSTANTS~ACTIVITY_DISPLAY .
  aliases BP_HANDLE
    for IF_FSBP_GENERIC_CONSTANTS~BP_HANDLE .
  aliases COMP_DIFFERENT_LINES
    for IF_FSBP_GENERIC_CONSTANTS~COMP_DIFFERENT_LINES .
  aliases COMP_EXACT_LINES
    for IF_FSBP_GENERIC_CONSTANTS~COMP_EXACT_LINES .
  aliases COMP_SAME_KEY
    for IF_FSBP_GENERIC_CONSTANTS~COMP_SAME_KEY .
  aliases MSG_ABORT
    for IF_FSBP_GENERIC_CONSTANTS~MSG_ABORT .
  aliases MSG_ERROR
    for IF_FSBP_GENERIC_CONSTANTS~MSG_ERROR .
  aliases MSG_EXIT
    for IF_FSBP_GENERIC_CONSTANTS~MSG_EXIT .
  aliases MSG_INFO
    for IF_FSBP_GENERIC_CONSTANTS~MSG_INFO .
  aliases MSG_SUCCESS
    for IF_FSBP_GENERIC_CONSTANTS~MSG_SUCCESS .
  aliases MSG_WARNING
    for IF_FSBP_GENERIC_CONSTANTS~MSG_WARNING .

  class-data INSTANCE type ref to CVI_FM_BP_VENDOR_CONTACT .

  methods CREATE_ORG_AND_REL_ADDRESS
    importing
      !I_CC_DEVIANT_ADR type CVIS_EI_ADDRESS1
      !I_CC_ADDRESS type CVIS_EI_ADDRESS3
    exporting
      !E_REL_ADDRESS type BURS_EI_REL_ADDRESS
      !E_ORG_ADDRESS type BUS_EI_BUPA_ADDRESS .
  methods GET_VC_ADDRESS
    importing
      !I_ORGANISATION_GUID type BU_PARTNER_GUID_BAPI
      !I_VENDOR_CONTACT_ID type PARNR
    exporting
      !E_DEVIANT_ADDRESS type CVIS_EI_ADDRESS1
      !E_PRIVATE_ADDRESS type CVIS_EI_ADDRESS2
      !E_CONTACT_ADDRESS type CVIS_EI_ADDRESS3
    changing
      !C_ERRORS type CVIS_ERROR .
ENDCLASS.



CLASS CVI_FM_BP_VENDOR_CONTACT IMPLEMENTATION.


method CREATE_ORG_AND_REL_ADDRESS.

  data:
    lv_guid_32        type guid_32.

* create a new type 1 address for the organisation
  call function 'GUID_CREATE'
    importing
      ev_guid_32 = lv_guid_32.

  e_org_address-task          = task_insert.
  e_org_address-data_key-guid = lv_guid_32.

  move-corresponding:
    i_cc_deviant_adr-postal to e_org_address-data-postal.   "#EC ENHOK

* create a new type 3 address for the relationship as standard address
  e_rel_address-task          = task_insert.
  e_rel_address-data_key-guid = lv_guid_32.
  e_rel_address-data-postal-data-standardaddress = true.
  move-corresponding:
    i_cc_deviant_adr-postal  to e_rel_address-data-postal.      "#EC ENHOK

  map_contact_version_to_rel(
    exporting
      i_contact_version = i_cc_deviant_adr-version
    importing
      e_rel_version     = e_rel_address-data-version
         ).

  move:
    i_cc_address-postal-data-floor_p     to e_rel_address-data-postal-data-floor,
    i_cc_address-postal-datax-floor_p    to e_rel_address-data-postal-datax-floor,
    i_cc_address-postal-data-room_no_p   to e_rel_address-data-postal-data-room_no,
    i_cc_address-postal-datax-room_no_p  to e_rel_address-data-postal-datax-room_no.

  map_cv_communication(
    exporting
      i_cvi_communication = i_cc_deviant_adr-communication
    importing
      e_bp_communication  = e_rel_address-data-communication ).

endmethod.


method GET_INSTANCE.

  if instance is not bound.
    create object instance.
  endif.
  r_instance = instance.

endmethod.


method GET_VC_ADDRESS.

  data:
    ls_customers_new  type cmds_ei_main,
    ls_customer_new   type cmds_ei_extern,
    ls_customers_read type cmds_ei_main,
    ls_customer_read  type cmds_ei_extern,
    ls_contact        type cmds_ei_contacts,
    ls_errors         type cvis_error,
    lv_guid_16        type guid_16,
    lcl_ka_cust       type ref to cvi_ka_bp_customer.

  lcl_ka_cust = cvi_ka_bp_customer=>get_instance( ).
  lv_guid_16 = i_organisation_guid.
  ls_customer_new-header-object_instance-kunnr =
     lcl_ka_cust->get_assigned_customer_for_bp( i_partner = lv_guid_16 ).
  ls_customer_new-header-object_task = task_update.
  append ls_customer_new to ls_customers_new-customers.

  clear ls_errors.
  cmd_ei_api_extract=>get_data(
    exporting
      is_master_data = ls_customers_new
    importing
      es_master_data = ls_customers_read
      es_error       = ls_errors
  ).
  if ls_errors-is_error = true.
    c_errors-is_error = true.
    append lines of ls_errors-messages to c_errors-messages.
    exit.
  else.
    read table ls_customers_read-customers into ls_customer_read index 1.
    read table ls_customer_read-central_data-contact-contacts into ls_contact
      with key data_key-parnr = i_vendor_contact_id.

    e_deviant_address = ls_contact-address_type_1.
    e_private_address = ls_contact-address_type_2.
    e_contact_address = ls_contact-address_type_3.
  endif.

endmethod.


method MAP_BP_ADDRESS.

  field-symbols:
    <address> like line of i_person-central_data-address-addresses.

  read table i_person-central_data-address-addresses assigning <address>
    with key currently_valid                  = true
             data-postal-data-standardaddress = true.
  if sy-subrc = 0.
    if not <address>-task is initial.
      v_contact-address_type_2-task = <address>-task.
    else.
      v_contact-address_type_2-task = task_modify.
    endif.

    move-corresponding:
      <address>-data-postal to v_contact-address_type_2-postal,"#EC ENHOK
      <address>-data-remark to v_contact-address_type_2-remark."#EC ENHOK

    map_bp_version_to_cc(
      exporting
        i_bp_version  = <address>-data-version
      importing
        e_cvi_version = v_contact-address_type_2-version
     ).

    map_bp_communication(
      exporting
        i_bp_communication  = <address>-data-communication
      importing
        e_cvi_communication = v_contact-address_type_2-communication
    ).

  else.
    clear v_contact-address_type_2.
  endif.

endmethod.


method MAP_BP_BUSINESS_ADDRESS.

  data: ls_relation        type burs_ei_extern,
        ls_address         type burs_ei_rel_address,
        ls_partner_address type bus_ei_bupa_address.

* this mapping covers changes of the address of the organisation only
* switching the standard address of the organisation is covered in standard step 6 before
  loop at i_partner-central_data-address-addresses into ls_partner_address
    where data-postal-data-standardaddress = false.

    read table ls_relation-central_data-address-addresses into ls_address
      with key data_key-guid = ls_partner_address-data_key-guid.
    if sy-subrc = 0 and ls_address-data-postal-data-standardaddress = true.
      if v_contact-address_type_1-task is initial.
        v_contact-address_type_1-task = task_update.
      endif.
*     delta move: no mapping of type 3 attributes and remarks and versions
*     relation data was not mapped before -> type 3 attributes can be cleared
      clear:
        ls_partner_address-data-postal-datax-location,
        ls_partner_address-data-postal-datax-building,
        ls_partner_address-data-postal-datax-floor,
        ls_partner_address-data-postal-datax-room_no,
        ls_partner_address-data-postal-datax-langu,
        ls_partner_address-data-postal-datax-comm_type.
      move-corresponding:
        ls_partner_address-data-postal  to v_contact-address_type_1-postal,
        ls_partner_address-data-remark  to v_contact-address_type_1-remark. "#EC ENHOK
    endif.
  endloop.

endmethod.


method MAP_BP_GENERAL_DATA.

  constants: lc_bp_male        type bu_sexid value '2',
             lc_bp_female      type bu_sexid value '1',
             lc_contact_male   type parge value '1',
             lc_contact_female type parge value '2'.

  check i_person is not initial.

  if v_contact-address_type_3-task is initial.
    v_contact-address_type_3-task = task_modify.
  endif.
  move-corresponding i_person-central_data-common-data-bp_person
             to v_contact-address_type_3-postal-data.       "#EC ENHOK
  v_contact-address_type_3-postal-data-birth_name = i_person-central_data-common-data-bp_person-birthname.
  v_contact-address_type_3-postal-data-namctryiso = i_person-central_data-common-data-bp_person-namcountryiso.
  v_contact-address_type_3-postal-data-langu_p    = i_person-central_data-common-data-bp_person-correspondlanguage.
  v_contact-address_type_3-postal-data-langup_iso = i_person-central_data-common-data-bp_person-correspondlanguageiso.
  v_contact-address_type_3-postal-data-fullname_x = i_person-central_data-common-data-bp_person-fullname_man.

  if i_person-central_data-common-data-bp_person-sex = lc_bp_male.
    v_contact-data-parge = lc_contact_male.
    v_contact-address_type_3-postal-data-sex = lc_contact_male.
  elseif i_person-central_data-common-data-bp_person-sex = lc_bp_female.
    v_contact-data-parge = lc_contact_female.
    v_contact-address_type_3-postal-data-sex = lc_contact_female.
  else.
    v_contact-data-parge = i_person-central_data-common-data-bp_person-sex.
    v_contact-address_type_3-postal-data-sex = i_person-central_data-common-data-bp_person-sex.
  endif.
*
  select single famst from cvic_marst_link into v_contact-data-famst
         where  marst      = i_person-central_data-common-data-bp_person-maritalstatus."#EC *

  v_contact-data-gbdat     = i_person-central_data-common-data-bp_person-birthdate.
*  c_contact-data-parla_iso = i_person-central_data-common-data-bp_person-correspondlanguageiso.

  v_contact-address_type_3-postal-data-sort1_p   = i_person-central_data-common-data-bp_centraldata-searchterm1.
  v_contact-address_type_3-postal-data-sort2_p   = i_person-central_data-common-data-bp_centraldata-searchterm2.
  v_contact-address_type_3-postal-data-title_p   = i_person-central_data-common-data-bp_centraldata-title_key.
*  v_contact-address_type_3-postal-data-comm_type = i_person-central_data-common-data-bp_centraldata-comm_type.

  v_contact-data-sortl = i_person-central_data-common-data-bp_centraldata-searchterm1.
*datax
  move-corresponding i_person-central_data-common-datax-bp_person
             to v_contact-address_type_3-postal-datax.      "#EC ENHOK
  v_contact-address_type_3-postal-datax-birth_name = i_person-central_data-common-datax-bp_person-birthname.
  v_contact-address_type_3-postal-datax-namctryiso = i_person-central_data-common-datax-bp_person-namcountryiso.
  v_contact-address_type_3-postal-datax-langu_p    = i_person-central_data-common-datax-bp_person-correspondlanguage.
  v_contact-address_type_3-postal-datax-langup_iso = i_person-central_data-common-datax-bp_person-correspondlanguageiso.
*  c_contact-address_type_3-postal-datax-fullname_x = i_person-central_data-common-datax-bp_person-fullname_man.

  v_contact-datax-parge = i_person-central_data-common-datax-bp_person-sex.

  v_contact-datax-gbdat     = i_person-central_data-common-datax-bp_person-birthdate.
  v_contact-datax-famst     = i_person-central_data-common-datax-bp_person-maritalstatus.
*  c_contact-datax-parla_iso = i_person-central_data-common-datax-bp_person-correspondlanguageiso.

  v_contact-address_type_3-postal-datax-sort1_p   = i_person-central_data-common-datax-bp_centraldata-searchterm1.
  v_contact-address_type_3-postal-datax-sort2_p   = i_person-central_data-common-datax-bp_centraldata-searchterm2.
  v_contact-address_type_3-postal-datax-title_p   = i_person-central_data-common-datax-bp_centraldata-title_key.
*  v_contact-address_type_3-postal-datax-comm_type = i_person-central_data-common-datax-bp_centraldata-comm_type.

  v_contact-datax-sortl = i_person-central_data-common-datax-bp_centraldata-searchterm1.

* type 2 address mapping only if type 2 address is updated
  check v_contact-address_type_2                     is not initial.
*  or
*        i_person-central_data-common-datax-bp_person is not initial.
*  check i_person-central_data-address-addresses is not initial.

  if v_contact-address_type_2-task is initial.
    v_contact-address_type_2-task = task_modify.
  endif.

  move-corresponding i_person-central_data-common-data-bp_person
             to v_contact-address_type_2-postal-data.       "#EC ENHOK
  v_contact-address_type_2-postal-data-birth_name = i_person-central_data-common-data-bp_person-birthname.
  v_contact-address_type_2-postal-data-namctryiso = i_person-central_data-common-data-bp_person-namcountryiso.
  v_contact-address_type_2-postal-data-langu_p    = i_person-central_data-common-data-bp_person-correspondlanguage.
  v_contact-address_type_2-postal-data-langup_iso = i_person-central_data-common-data-bp_person-correspondlanguageiso.
  v_contact-address_type_2-postal-data-fullname_x = i_person-central_data-common-data-bp_person-fullname_man.

  if i_person-central_data-common-data-bp_person-sex = lc_bp_male.
    v_contact-data-parge = lc_contact_male.
    v_contact-address_type_2-postal-data-sex = lc_contact_male.
  elseif i_person-central_data-common-data-bp_person-sex = lc_bp_female.
    v_contact-data-parge = lc_contact_female.
    v_contact-address_type_2-postal-data-sex = lc_contact_female.
  else.
    v_contact-data-parge = i_person-central_data-common-data-bp_person-sex.
    v_contact-address_type_2-postal-data-sex = i_person-central_data-common-data-bp_person-sex.
  endif.

  v_contact-address_type_2-postal-data-sort1_p   = i_person-central_data-common-data-bp_centraldata-searchterm1.
  v_contact-address_type_2-postal-data-sort2_p   = i_person-central_data-common-data-bp_centraldata-searchterm2.
  v_contact-address_type_2-postal-data-title_p   = i_person-central_data-common-data-bp_centraldata-title_key.
*  v_contact-address_type_2-postal-data-comm_type = i_person-central_data-common-data-bp_centraldata-comm_type.
* datax
  move-corresponding i_person-central_data-common-datax-bp_person
             to v_contact-address_type_2-postal-datax.      "#EC ENHOK
  v_contact-address_type_2-postal-datax-birth_name = i_person-central_data-common-datax-bp_person-birthname.
  v_contact-address_type_2-postal-datax-namctryiso = i_person-central_data-common-datax-bp_person-namcountryiso.
  v_contact-address_type_2-postal-datax-langu_p    = i_person-central_data-common-datax-bp_person-correspondlanguage.
  v_contact-address_type_2-postal-datax-langup_iso = i_person-central_data-common-datax-bp_person-correspondlanguageiso.
*  c_contact-address_type_2-postal-datax-fullname_x = i_person-central_data-common-datax-bp_person-fullname_man.

  v_contact-address_type_2-postal-datax-sort1_p   = i_person-central_data-common-datax-bp_centraldata-searchterm1.
  v_contact-address_type_2-postal-datax-sort2_p   = i_person-central_data-common-datax-bp_centraldata-searchterm2.
  v_contact-address_type_2-postal-datax-title_p   = i_person-central_data-common-datax-bp_centraldata-title_key.
*  v_contact-address_type_2-postal-datax-comm_type = i_person-central_data-common-datax-bp_centraldata-comm_type.

endmethod.


method MAP_BP_RELATION_ADDRESS.

  data:
    lv_dummy_guid      type bu_partner_guid,
    ls_but020          type but020,
    ls_address         type burs_ei_rel_address.

  check i_relation-central_data-address-addresses[] is not initial.
  if v_address_guid is initial.
* read from DB
    lv_dummy_guid = i_relation-header-object_instance-partner1-bpartnerguid.
    call function 'BUA_BUT020_SELECT_WITH_XDFADR'
      exporting
        i_partnerguid    = lv_dummy_guid
      importing
        e_but020         = ls_but020
      exceptions
        not_found        = 1
        wrong_parameters = 2
        internal_error   = 3
        not_valid        = 4
        others           = 5.

    if sy-subrc = 0.
      v_address_guid = ls_but020-address_guid.
    endif.
  endif.

  loop at i_relation-central_data-address-addresses into ls_address.
    if ls_address-data_key-guid = v_address_guid.
      v_contact-address_type_3-task = task_modify.
      if ls_address-task = task_delete.
        clear ls_address-data.
        translate ls_address-data-postal-datax using ' X'.
        ls_address-data-communication-phone-current_state = true.
        ls_address-data-communication-fax-current_state   = true.
        ls_address-data-communication-ttx-current_state   = true.
        ls_address-data-communication-tlx-current_state   = true.
        ls_address-data-communication-smtp-current_state  = true.
        ls_address-data-communication-rml-current_state   = true.
        ls_address-data-communication-x400-current_state  = true.
        ls_address-data-communication-rfc-current_state   = true.
        ls_address-data-communication-prt-current_state   = true.
        ls_address-data-communication-ssf-current_state   = true.
        ls_address-data-communication-uri-current_state   = true.
        ls_address-data-communication-pager-current_state = true.
        ls_address-data-version-current_state             = true.
      endif.
      move-corresponding ls_address-data-postal-data to v_contact-address_type_3-postal-data.
      v_contact-address_type_3-postal-data-floor_p    = ls_address-data-postal-data-floor.
      v_contact-address_type_3-postal-data-room_no_p  = ls_address-data-postal-data-room_no.
*     datax
      move-corresponding ls_address-data-postal-datax to v_contact-address_type_3-postal-datax.
      v_contact-address_type_3-postal-datax-floor_p    = ls_address-data-postal-datax-floor.
      v_contact-address_type_3-postal-datax-room_no_p  = ls_address-data-postal-datax-room_no.

      map_rel_version(
        exporting
          i_rel_version = ls_address-data-version
        importing
          e_cvi_version = v_contact-address_type_3-version
       ).

      map_bp_communication(
        exporting
          i_bp_communication  = ls_address-data-communication
        importing
          e_cvi_communication = v_contact-address_type_3-communication
          ).

      exit.
    endif.
  endloop.

endmethod.


method MAP_BP_RELATION_BUSINESS_HOURS.

  data:
    ls_business_hour type bus_ei_bupa_hours,
    ls_weekly        type bapibus1006_rule_w,
    lv_bp_from       like ls_weekly-monda_from,
    lv_bp_to         like ls_weekly-monday_to,
    lv_cc_ab1        like v_contact-data-moab1,
    lv_cc_bi1        like v_contact-data-mobi1,   "#EC NEEDED
    lv_cc_ab2        like v_contact-data-moab2,
    lv_cc_bi2        like v_contact-data-mobi2.   "#EC NEEDED
  constants:
    lc_noon(6)       type c value '120000',
    lc_initial(6)    type c value '000000'.

  check i_relation-central_data-business_hour is not initial.
*
  loop at i_relation-central_data-business_hour-business_hours into ls_business_hour.

    IF ls_business_hour-data_key-SCHEDULE_TYPE = 'C'.
*   morning
    read table ls_business_hour-data-weekly into ls_weekly index 1.
    if sy-subrc = 0.
      do 7 times
        varying lv_bp_from from ls_weekly-monda_from next ls_weekly-tuesd_from
        varying lv_bp_to   from ls_weekly-monday_to  next ls_weekly-tuesday_to
        varying lv_cc_ab1  from v_contact-data-moab1 next v_contact-data-diab1
        varying lv_cc_bi1  from v_contact-data-mobi1 next v_contact-data-dibi1
        varying lv_cc_ab2  from v_contact-data-moab2 next v_contact-data-diab2
        varying lv_cc_bi2  from v_contact-data-mobi2 next v_contact-data-dibi2.

        if lv_bp_from < lc_noon.
          if lv_cc_ab1 = lc_initial.
            lv_cc_ab1  = lv_bp_from.
            lv_cc_bi1  = lv_bp_to.
          endif.
        else.
          if lv_cc_ab2 = lc_initial.
            lv_cc_ab2  = lv_bp_from.
            lv_cc_bi2  = lv_bp_to.
          endif.
        endif.

      enddo.
    endif.
*   afternoon
    read table ls_business_hour-data-weekly into ls_weekly index 2.
    if sy-subrc = 0.
      do 7 times
        varying lv_bp_from from ls_weekly-monda_from next ls_weekly-tuesd_from
        varying lv_bp_to   from ls_weekly-monday_to  next ls_weekly-tuesday_to
        varying lv_cc_ab1  from v_contact-data-moab1 next v_contact-data-diab1
        varying lv_cc_bi1  from v_contact-data-mobi1 next v_contact-data-dibi1
        varying lv_cc_ab2  from v_contact-data-moab2 next v_contact-data-diab2
        varying lv_cc_bi2  from v_contact-data-mobi2 next v_contact-data-dibi2.

        if lv_bp_from < lc_noon.
          if lv_cc_ab1 = lc_initial.
            lv_cc_ab1  = lv_bp_from.
            lv_cc_bi1  = lv_bp_to.
          endif.
        else.
          if lv_cc_ab2 = lc_initial.
            lv_cc_ab2  = lv_bp_from.
            lv_cc_bi2  = lv_bp_to.
          endif.
        endif.

      enddo.
    endif.
*   datax
    v_contact-datax-mobi1 =
    v_contact-datax-moab1 =
    v_contact-datax-diab1 =
    v_contact-datax-dibi1 =
    v_contact-datax-miab1 =
    v_contact-datax-mibi1 =
    v_contact-datax-doab1 =
    v_contact-datax-dobi1 =
    v_contact-datax-frab1 =
    v_contact-datax-frbi1 =
    v_contact-datax-saab1 =
    v_contact-datax-sabi1 =
    v_contact-datax-soab1 =
    v_contact-datax-sobi1 =

    v_contact-datax-moab2 =
    v_contact-datax-mobi2 =
    v_contact-datax-diab2 =
    v_contact-datax-dibi2 =
    v_contact-datax-miab2 =
    v_contact-datax-mibi2 =
    v_contact-datax-doab2 =
    v_contact-datax-dobi2 =
    v_contact-datax-frab2 =
    v_contact-datax-frbi2 =
    v_contact-datax-saab2 =
    v_contact-datax-sabi2 =
    v_contact-datax-soab2 =
    v_contact-datax-sobi2 = true.
    ELSE.
      continue.
    ENDIF.
  endloop.

endmethod.


method MAP_BP_RELATION_DATA.

  check i_relation is not initial.

  select single abtnr from cvic_cp1_link into v_contact-data-abtnr
         where  gp_abtnr = i_relation-central_data-contact-central_data-data-department."#EC *
  select single pafkt from cvic_cp2_link into v_contact-data-pafkt
         where  gp_pafkt = i_relation-central_data-contact-central_data-data-function."#EC *
  select single parvo from cvic_cp3_link into v_contact-data-parvo
         where  paauth   = i_relation-central_data-contact-central_data-data-authority."#EC *
  select single pavip from cvic_cp4_link into v_contact-data-pavip
         where  gp_pavip = i_relation-central_data-contact-central_data-data-vip."#EC *

  v_contact-data-parau   = i_relation-central_data-contact-central_data-data-comments.

  v_contact-datax-abtnr = i_relation-central_data-contact-central_data-datax-department.
  v_contact-datax-pafkt = i_relation-central_data-contact-central_data-datax-function.
  v_contact-datax-parvo = i_relation-central_data-contact-central_data-datax-authority.
  v_contact-datax-pavip = i_relation-central_data-contact-central_data-datax-vip.
  v_contact-datax-parau = i_relation-central_data-contact-central_data-datax-comments.

endmethod.


method MAP_BP_REL_BUSINESS_ADDRESS.

  data:
    lv_dummy_guid      type bu_partner_guid,
    lv_person_name(81) type c,
    ls_but020          type but020,
    ls_address         type burs_ei_rel_address,
    ls_partner_address type bus_ei_bupa_address,
    ls_bps             type bus_ei_main,
    ls_errors          type cvis_error,
    ls_partner         type bus_ei_extern,
    ls_person          type bus_ei_extern.

  check i_relation-central_data-address-addresses[] is not initial.

  if v_address_guid is initial AND i_partner-header-object_task <> 'I'..
* read from DB
    lv_dummy_guid = i_partner-header-object_instance-bpartnerguid.
    call function 'BUA_BUT020_SELECT_WITH_XDFADR'
      exporting
        i_partnerguid    = lv_dummy_guid
      importing
        e_but020         = ls_but020
      exceptions
        not_found        = 1
        wrong_parameters = 2
        internal_error   = 3
        not_valid        = 4
        others           = 5.

    if sy-subrc = 0.
      v_address_guid = ls_but020-address_guid.
    endif.
  endif.

  read table i_relation-central_data-address-addresses into ls_address
    with key data-postal-data-standardaddress = true.
  if sy-subrc = 0.
    if ls_address-data_key-guid <> v_address_guid.
      v_contact-address_type_1-task = task_modify.
      if ls_address-task = task_delete.
        v_contact-address_type_1-task = task_delete.
      endif.

      append i_partner to ls_bps-partners.

      cl_bupa_current_data=>get_all(
        exporting
          is_business_partners = ls_bps
        importing
          es_business_partners = ls_bps
          es_error             = ls_errors
          ).

      if ls_errors is not initial.
        append lines of ls_errors-messages to c_errors-messages.
        check ls_errors-is_error = false.
      endif.
      read table ls_bps-partners into ls_partner index 1.
      read table ls_partner-central_data-address-addresses into ls_partner_address
        with key data_key-guid = ls_address-data_key-guid.
      if sy-subrc = 0.
        move-corresponding:
          ls_partner_address-data-postal  to v_contact-address_type_1-postal."#EC ENHOK
      endif.

*     mapping type 3 to type 1
      move-corresponding:
       ls_address-data-postal  to v_contact-address_type_1-postal.
*       ls_address-data-version to c_contact-address_type_1-version."#EC ENHOK
      map_rel_version(
        exporting
          i_rel_version = ls_address-data-version
        importing
          e_cvi_version = v_contact-address_type_1-version
             ).

      map_bp_communication(
         exporting
           i_bp_communication  = ls_address-data-communication
         importing
           e_cvi_communication = v_contact-address_type_1-communication
           ).

*     mapping person to type 1
      clear ls_bps.
      ls_person = i_person.
      if ls_person is initial.
        ls_person-header-object_instance-bpartnerguid = i_relation-header-object_instance-partner2-bpartnerguid.
        ls_person-header-object_instance-bpartner     = i_relation-header-object_instance-partner2-bpartner.
        ls_person-header-object_task = task_modify.
      endif.
      append ls_person to ls_bps-partners.

      cl_bupa_current_data=>get_all(
        exporting
          is_business_partners = ls_bps
        importing
          es_business_partners = ls_bps
          es_error             = ls_errors
          ).

      if ls_errors is not initial.
        append lines of ls_errors-messages to c_errors-messages.
        check ls_errors-is_error = false.
      endif.
      read table ls_bps-partners into ls_person index 1.
*
      v_contact-address_type_1-postal-data-title = ls_person-central_data-common-data-bp_centraldata-title_key.
      v_contact-address_type_1-postal-data-sort1 = ls_person-central_data-common-data-bp_centraldata-searchterm1.
      v_contact-address_type_1-postal-data-sort2 = ls_person-central_data-common-data-bp_centraldata-searchterm2.

      concatenate
         ls_person-central_data-common-data-bp_person-firstname
         ls_person-central_data-common-data-bp_person-lastname
         into lv_person_name
         in character mode separated by space respecting blanks.
      condense lv_person_name.
      if lv_person_name+40(40) is initial.
        v_contact-address_type_1-postal-data-name    = lv_person_name.
      else.
        v_contact-address_type_1-postal-data-name    = ls_person-central_data-common-data-bp_person-firstname.
        v_contact-address_type_1-postal-data-name_2  = ls_person-central_data-common-data-bp_person-lastname.
      endif.

      translate v_contact-address_type_1-postal-datax using ' X'.

    else.
      check ls_address-task <> task_insert.
      check ls_address-task <> task_delete.
      v_contact-address_type_1-task = task_delete.
    endif.
  endif.

endmethod.


method MAP_BP_REL_TO_VENDOR_CONTACT.

  data:
    lv_msgvar1    type symsgv,
    ls_message    type bapiret2.

  if i_relation-header-object_task <> task_insert and
     i_relation-header-object_task <> task_current_state and
     i_relation-header-object_task <> task_update and
     i_relation-header-object_task <> task_delete and
     i_relation-header-object_task <> task_modify and
     i_relation-header-object_task <> task_time.

    lv_msgvar1 = i_relation-header-object_task.
    ls_message = fsbp_generic_services=>new_message(
      i_class_id  = msg_class_cvi
      i_type      = fsbp_generic_services=>msg_error
      i_number    = '001'
      i_variable1 = lv_msgvar1
      i_variable2 = text-001
    ).
    append ls_message to e_errors-messages.
    e_errors-is_error = true.
    return.
  endif.

  map_bp_relation_data(
    exporting
      i_relation     = i_relation
    changing
      v_contact      = v_contact
  ).

  map_bp_relation_address(
    exporting
      i_relation     = i_relation
    changing
      v_address_guid = v_address_guid
      v_contact      = v_contact
  ).

  map_bp_relation_business_hours(
    exporting
      i_relation = i_relation
    changing
      v_contact  = v_contact
  ).

  map_bp_address(
    exporting
      i_person   = i_person
    changing
      v_contact  = v_contact
  ).

  map_bp_general_data(
    exporting
      i_person   = i_person
    changing
      v_contact  = v_contact
  ).

endmethod.


method MAP_PERSON_BUSINESS_ADDRESS.

  data:
    lv_person_name(81) type c.

* Mapping of person data
  v_contact-address_type_1-postal-data-title = i_person-central_data-common-data-bp_centraldata-title_key.
  v_contact-address_type_1-postal-data-sort1 = i_person-central_data-common-data-bp_centraldata-searchterm1.
  v_contact-address_type_1-postal-data-sort2 = i_person-central_data-common-data-bp_centraldata-searchterm2.

  concatenate
     i_person-central_data-common-data-bp_person-firstname
     i_person-central_data-common-data-bp_person-lastname
     into lv_person_name
     in character mode separated by space respecting blanks.
  condense lv_person_name.
  if lv_person_name+40(40) is initial.
    v_contact-address_type_1-postal-data-name    = lv_person_name.
  else.
    v_contact-address_type_1-postal-data-name    = i_person-central_data-common-data-bp_person-firstname.
    v_contact-address_type_1-postal-data-name_2  = i_person-central_data-common-data-bp_person-lastname.
  endif.
* X-Flags
  v_contact-address_type_1-postal-datax-title  = i_person-central_data-common-datax-bp_centraldata-title_key.
  v_contact-address_type_1-postal-datax-sort1  = i_person-central_data-common-datax-bp_centraldata-searchterm1.
  v_contact-address_type_1-postal-datax-sort2  = i_person-central_data-common-datax-bp_centraldata-searchterm2.

  v_contact-address_type_1-postal-datax-name   = i_person-central_data-common-datax-bp_person-firstname.
  v_contact-address_type_1-postal-datax-name_2 = i_person-central_data-common-datax-bp_person-lastname.

endmethod.


method MAP_PERSON_TO_VENDOR_CONTACT.

  data:
    lv_msgvar1    type symsgv,
    lv_msgvar2    type symsgv,
    ls_message    type bapiret2.

  if i_relation-header-object_task <> task_insert and
     i_relation-header-object_task <> task_current_state and
     i_relation-header-object_task <> task_update and
     i_relation-header-object_task <> task_delete and
     i_relation-header-object_task <> task_modify and
     i_relation-header-object_task <> task_time.

    lv_msgvar1 = i_relation-header-object_task.

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

  map_bp_relation_data(
    exporting
      i_relation     = i_relation
    changing
      v_contact      = v_contact
  ).

  map_bp_relation_address(
    exporting
      i_relation     = i_relation
    changing
      v_address_guid = v_address_guid
      v_contact      = v_contact
  ).

  map_bp_relation_business_hours(
    exporting
      i_relation = i_relation
    changing
      v_contact  = v_contact
  ).

  map_bp_address(
    exporting
      i_person   = i_person
    changing
      v_contact  = v_contact
  ).

  map_bp_general_data(
    exporting
      i_person   = i_person
    changing
      v_contact  = v_contact
  ).

endmethod.


method MAP_VC_BUSINESS_ADDRESS.

  data:
    lt_address        type table of bapibus1006002_addresses_i,
    lt_return         type bapiret2_t,
    ls_return         type bapiret2,                        "#EC NEEDED
    ls_but020         type but020,
    ls_but020_default type but020,
    ls_address        type bapibus1006002_addresses_i,
    ls_org_address    type bus_ei_bupa_address,
    ls_rel_address    type burs_ei_rel_address,
    ls_cc_deviant_adr type cvis_ei_address1,
    ls_cc_address     type cvis_ei_address3,
    lv_contact_guid   type bu_partner_guid,
    lv_partner_guid   type bu_partner_guid.

  check i_vendor_contact-address_type_1 is not initial.
  lv_contact_guid = c_relation-header-object_instance-partner2-bpartnerguid.
  lv_partner_guid = c_partner-header-object_instance-bpartnerguid.
  ls_cc_deviant_adr = i_vendor_contact-address_type_1.
  ls_cc_address     = i_vendor_contact-address_type_3.

  call function 'BUPR_CONTP_ADDRESSES_GET'
    EXPORTING
      iv_partner_guid       = lv_partner_guid
      iv_contactperson_guid = lv_contact_guid
    TABLES
      et_addresses          = lt_address
      et_return             = lt_return.

  loop at lt_return into ls_return                          "#EC NEEDED
      where type = msg_abort
         or type = msg_error.
  endloop.

  if sy-subrc = 0.
*   relation has no address
    check i_vendor_contact-address_type_1-task <> task_delete.
    if i_vendor_contact-address_type_1-task = task_update.
*   read address of contact
      get_vc_address(
        exporting
          i_organisation_guid   = c_partner-header-object_instance-bpartnerguid
          i_vendor_contact_id = i_vendor_contact-data_key-parnr
        importing
          e_deviant_address     = ls_cc_deviant_adr
          e_contact_address     = ls_cc_address
        changing
          c_errors              = c_errors
             ).
    endif.

    create_org_and_rel_address(
      exporting
        i_cc_deviant_adr = ls_cc_deviant_adr
        i_cc_address     = ls_cc_address
      importing
        e_rel_address    = ls_rel_address
        e_org_address    = ls_org_address
           ).

*   create a new address type 1 for the organisation with new guid
    append ls_org_address to c_partner-central_data-address-addresses.
*   create a new type 3 address for the relationship as standard address
    append ls_rel_address to c_relation-central_data-address-addresses.

  else.
*   relation already has an address
    read table lt_address into ls_address with key standardaddress = true.
    if sy-subrc = 0.
*     standardadress found
      call function 'BUA_BUT020_SELECT_WITH_GUID'
        EXPORTING
          i_partnerguid    = lv_partner_guid
          i_addrguid       = ls_address-addressguid
        IMPORTING
          e_but020         = ls_but020
        EXCEPTIONS
          not_found        = 1
          wrong_parameters = 2
          internal_error   = 3
          not_valid        = 4
          others           = 5.
      if sy-subrc = 0.
*       address also found at the BP
        call function 'BUA_BUT020_SELECT_WITH_XDFADR'
          EXPORTING
            i_partnerguid    = lv_partner_guid
          IMPORTING
            e_but020         = ls_but020_default
          EXCEPTIONS
            not_found        = 1
            wrong_parameters = 2
            internal_error   = 3
            not_valid        = 4
            others           = 5.
        if sy-subrc = 0 and ls_but020_default-addrnumber = ls_address-addr_number.
          check i_vendor_contact-address_type_1-task <> task_delete.
*         standard relationaddress is also standardaddress of the bp
          if i_vendor_contact-address_type_1-task = task_update.
*           read address of contact
            get_vc_address(
              exporting
                i_organisation_guid   = c_partner-header-object_instance-bpartnerguid
                i_vendor_contact_id = i_vendor_contact-data_key-parnr
              importing
                e_deviant_address     = ls_cc_deviant_adr
                e_contact_address     = ls_cc_address
              changing
                c_errors              = c_errors
                   ).
          endif.

          create_org_and_rel_address(
            exporting
              i_cc_deviant_adr = ls_cc_deviant_adr
              i_cc_address     = ls_cc_address
            importing
              e_rel_address    = ls_rel_address
              e_org_address    = ls_org_address
                 ).

*         create a new address type 1 for the organisation with new guid
          append ls_org_address to c_partner-central_data-address-addresses.
*         create a new type 3 address for the relationship as standard address
          append ls_rel_address to c_relation-central_data-address-addresses.

        else.
*         standard relationaddress is not standardaddress of the bp
          if i_vendor_contact-address_type_1-task = task_delete.
*           deletion
            ls_org_address-task = task_delete.
            ls_org_address-data_key-guid = ls_but020-address_guid.
            append ls_org_address to c_partner-central_data-address-addresses.
*           switch the standard address to organization standard address
            ls_rel_address-task = task_update.
            ls_rel_address-data_key-guid = ls_but020_default-address_guid.
            ls_rel_address-data-postal-data-standardaddress = 'X'.
            ls_rel_address-data-postal-datax-standardaddress = 'X'.
            append ls_rel_address to c_relation-central_data-address-addresses.
            clear ls_rel_address.
*           delete the business address from the relationship
            ls_rel_address-task = task_delete.
            ls_rel_address-data_key-guid = ls_but020-address_guid.
            append ls_rel_address to c_relation-central_data-address-addresses.
          else.
*         insert and update
            read table lt_address into ls_address
              with key addressguid = ls_but020_default-address_guid.
*           update type 1 and type 3 address
            ls_org_address-task = task_update.
            ls_org_address-data_key-guid = ls_but020-address_guid.
            move-corresponding:
            i_vendor_contact-address_type_1-postal to ls_org_address-data-postal,
            i_vendor_contact-address_type_1-remark to ls_org_address-data-remark. "#EC ENHOK
            append ls_org_address to c_partner-central_data-address-addresses.
*             change type 3 address for the relationship
            ls_rel_address-task = task_update.
            ls_rel_address-data_key-guid = ls_but020-address_guid.
            move-corresponding:
              i_vendor_contact-address_type_1-postal  to ls_rel_address-data-postal."#EC ENHOK

            map_contact_version_to_rel(
              exporting
                i_contact_version = i_vendor_contact-address_type_1-version
              importing
                e_rel_version     = ls_rel_address-data-version
                   ).

            map_cv_communication(
              exporting
                i_cvi_communication = i_vendor_contact-address_type_1-communication
              importing
                e_bp_communication  = ls_rel_address-data-communication ).

*             mapping to ls_relation_address
            append ls_rel_address to c_relation-central_data-address-addresses.
          endif.
        endif.
      endif.
    endif.
  endif.

endmethod.


method MAP_VC_BUSINESS_HOURS.

  data:
    ls_business_hour type bus_ei_bupa_hours,
    ls_weekly        type bapibus1006_rule_w,
    ls_combined      type bapibus1006_rule_r.

  constants: lc_and  type CHAR2  value 'RO'.

  check not i_contact-data is initial.

  if i_contact-data-moab1 is not initial or
     i_contact-data-mobi1 is not initial or
     i_contact-data-diab1 is not initial or
     i_contact-data-dibi1 is not initial or
     i_contact-data-miab1 is not initial or
     i_contact-data-mibi1 is not initial or
     i_contact-data-doab1 is not initial or
     i_contact-data-dobi1 is not initial or
     i_contact-data-frab1 is not initial or
     i_contact-data-frbi1 is not initial or
     i_contact-data-saab1 is not initial or
     i_contact-data-sabi1 is not initial or
     i_contact-data-soab1 is not initial or
     i_contact-data-sobi1 is not initial or
     i_contact-data-moab2 is not initial or
     i_contact-data-mobi2 is not initial or
     i_contact-data-diab2 is not initial or
     i_contact-data-dibi2 is not initial or
     i_contact-data-miab2 is not initial or
     i_contact-data-mibi2 is not initial or
     i_contact-data-doab2 is not initial or
     i_contact-data-dobi2 is not initial or
     i_contact-data-frab2 is not initial or
     i_contact-data-frbi2 is not initial or
     i_contact-data-saab2 is not initial or
     i_contact-data-sabi2 is not initial or
     i_contact-data-soab2 is not initial or
     i_contact-data-sobi2 is not initial.

*   morning
    ls_weekly-rule_ref   = '1'.
    ls_weekly-weeks      = '01'.
    ls_weekly-type       = 'W'.
    ls_weekly-start_date = '00000000'.
    ls_weekly-end_date   = '00000000'.
*
    ls_weekly-monda_from = i_contact-data-moab1.
    ls_weekly-monday_to  = i_contact-data-mobi1.
    ls_weekly-tuesd_from = i_contact-data-diab1.
    ls_weekly-tuesday_to = i_contact-data-dibi1.
    ls_weekly-wedne_from = i_contact-data-miab1.
    ls_weekly-wednesd_to = i_contact-data-mibi1.
    ls_weekly-thurs_from = i_contact-data-doab1.
    ls_weekly-thursda_to = i_contact-data-dobi1.
    ls_weekly-frida_from = i_contact-data-frab1.
    ls_weekly-friday_to  = i_contact-data-frbi1.
    ls_weekly-satur_from = i_contact-data-saab1.
    ls_weekly-saturda_to = i_contact-data-sabi1.
    ls_weekly-sunda_from = i_contact-data-soab1.
    ls_weekly-sunday_to  = i_contact-data-sobi1.

    ls_weekly-monday     =
    ls_weekly-tuesday    =
    ls_weekly-wednesday  =
    ls_weekly-thursday   =
    ls_weekly-friday     =
    ls_weekly-saturday   =
    ls_weekly-sunday     = true.

    ls_weekly-mond_tzone =
    ls_weekly-tues_tzone =
    ls_weekly-wedn_tzone =
    ls_weekly-thur_tzone =
    ls_weekly-frid_tzone =
    ls_weekly-satu_tzone =
    ls_weekly-sund_tzone = sy-zonlo.

    append ls_weekly to ls_business_hour-data-weekly.

*   afternoon
    ls_weekly-rule_ref   = '1'.
    ls_weekly-weeks      = '01'.
    ls_weekly-type       = 'W'.
    ls_weekly-start_date = '00000000'.
    ls_weekly-end_date   = '00000000'.
*
    ls_weekly-monda_from = i_contact-data-moab2.
    ls_weekly-monday_to  = i_contact-data-mobi2.
    ls_weekly-tuesd_from = i_contact-data-diab2.
    ls_weekly-tuesday_to = i_contact-data-dibi2.
    ls_weekly-wedne_from = i_contact-data-miab2.
    ls_weekly-wednesd_to = i_contact-data-mibi2.
    ls_weekly-thurs_from = i_contact-data-doab2.
    ls_weekly-thursda_to = i_contact-data-dobi2.
    ls_weekly-frida_from = i_contact-data-frab2.
    ls_weekly-friday_to  = i_contact-data-frbi2.
    ls_weekly-satur_from = i_contact-data-saab2.
    ls_weekly-saturda_to = i_contact-data-sabi2.
    ls_weekly-sunda_from = i_contact-data-soab2.
    ls_weekly-sunday_to  = i_contact-data-sobi2.

    ls_weekly-monday     =
    ls_weekly-tuesday    =
    ls_weekly-wednesday  =
    ls_weekly-thursday   =
    ls_weekly-friday     =
    ls_weekly-saturday   =
    ls_weekly-sunday     = true.

    ls_weekly-mond_tzone =
    ls_weekly-tues_tzone =
    ls_weekly-wedn_tzone =
    ls_weekly-thur_tzone =
    ls_weekly-frid_tzone =
    ls_weekly-satu_tzone =
    ls_weekly-sund_tzone = sy-zonlo.

    append ls_weekly to ls_business_hour-data-weekly.

    ls_business_hour-data_key-schedule_type = 'C'.
    ls_business_hour-task = task_insert.

*   fixed rule
    ls_combined-type      = lc_and.
    ls_combined-conflicts = 0.
    translate ls_combined-rule_id using ' 1'.
    append ls_combined to ls_business_hour-data-combined.
    append ls_business_hour to c_relation-central_data-business_hour-business_hours.

  else.
    c_relation-central_data-business_hour-current_state = true.
  endif.

endmethod.


method MAP_VC_CONTACT_ADDRESS.

  data:
        ls_but020           type but020,
        ls_relation_address type burs_ei_rel_address,
        lv_guid             type guid_32,
        lv_dummy_guid       type bu_partner_guid,
        lv_subrc            type sy-subrc.

  field-symbols:
    <address>               type bus_ei_bupa_address.

  check i_contact-address_type_3 is not initial.
  IF C_PARTNER-HEADER-OBJECT_TASK <> 'I'.
* mapping to c_person-central_data-common
  lv_dummy_guid = c_partner-header-object_instance-bpartnerguid.
  call function 'BUA_BUT020_SELECT_WITH_XDFADR'
    exporting
      i_partnerguid    = lv_dummy_guid
    importing
      e_but020         = ls_but020
    exceptions
      not_found        = 1
      wrong_parameters = 2
      internal_error   = 3
      not_valid        = 4
      others           = 5.

    lv_subrc = sy-subrc.
    IF lv_subrc = 0.
      ls_relation_address-data_key-guid = ls_but020-address_guid.
      ls_relation_address-task          = task_modify.
    ENDIF.
  ENDIF.
  IF lv_subrc <> 0 OR C_PARTNER-HEADER-OBJECT_TASK = 'I'.
    read table c_partner-central_data-address-addresses assigning <address> index 1.
    if sy-subrc = 0.
      if <address>-data_key-guid is initial.
        call function 'GUID_CREATE'
          importing
            ev_guid_32 = lv_guid.

        <address>-data_key-guid = lv_guid.
        <address>-task          = task_insert.
        clear <address>-data_key-operation.
        ls_relation_address-data_key-guid = lv_guid.
        ls_relation_address-task          = task_insert.
      else.
        ls_relation_address-data_key-guid = <address>-data_key-guid.
        ls_relation_address-task          = task_insert.
      endif.
    else.
*     this means: business partner has no address and
*     customer master´s address was not changed
*     so a business partner without address is existing and mapped to a customer master
*     in this case a type 3 address for the relation cannot be created -> no mapping!
      exit.
    endif.
  endif.

  move-corresponding:
    i_contact-address_type_3-postal  to ls_relation_address-data-postal."#EC ENHOK

  map_contact_version_to_rel(
    exporting
      i_contact_version = i_contact-address_type_3-version
    importing
      e_rel_version     = ls_relation_address-data-version
         ).

  move:
    i_contact-address_type_3-postal-data-floor_p    to ls_relation_address-data-postal-data-floor,
    i_contact-address_type_3-postal-datax-floor_p   to ls_relation_address-data-postal-datax-floor,
    i_contact-address_type_3-postal-data-room_no_p  to ls_relation_address-data-postal-data-room_no,
    i_contact-address_type_3-postal-datax-room_no_p to ls_relation_address-data-postal-datax-room_no.

  map_cv_communication(
    exporting
      i_cvi_communication = i_contact-address_type_3-communication
    importing
      e_bp_communication  = ls_relation_address-data-communication ).

* mapping to ls_relation_address
  append ls_relation_address to c_relation-central_data-address-addresses.

  if i_contact-task = 'C'.
    c_relation-central_data-address-current_state = i_contact-task.
  endif.
endmethod.


method MAP_VC_GENERAL_DATA.

  constants:
    lc_bp_male        type bu_sexid value '2',
    lc_bp_female      type bu_sexid value '1',
    lc_contact_male   type parge value '1',
    lc_contact_female type parge value '2'.

  if i_contact-address_type_3 is not initial.

    move-corresponding i_contact-address_type_3-postal-data to c_person-central_data-common-data-bp_person."#EC ENHOK
    if c_person-central_data-common-data-bp_person-fullname is not initial.
       clear c_person-central_data-common-data-bp_person-fullname.
    endif.
    c_person-central_data-common-data-bp_person-birthname             = i_contact-address_type_3-postal-data-birth_name.
    c_person-central_data-common-data-bp_person-namcountryiso         = i_contact-address_type_3-postal-data-namctryiso.
    c_person-central_data-common-data-bp_person-correspondlanguage    = i_contact-address_type_3-postal-data-langu_p.
    c_person-central_data-common-data-bp_person-correspondlanguageiso = i_contact-address_type_3-postal-data-langup_iso.
    c_person-central_data-common-data-bp_person-fullname_man          = i_contact-address_type_3-postal-data-fullname_x.

    c_person-central_data-common-data-bp_centraldata-searchterm1 = i_contact-address_type_3-postal-data-sort1_p.
    c_person-central_data-common-data-bp_centraldata-searchterm2 = i_contact-address_type_3-postal-data-sort2_p.
    c_person-central_data-common-data-bp_centraldata-title_key   = i_contact-address_type_3-postal-data-title_p.
    c_person-central_data-common-data-bp_centraldata-comm_type   = i_contact-address_type_3-postal-data-comm_type.

* datax
    if i_contact-task = task_current_state.
      translate c_person-central_data-common-datax-bp_person using ' X'.
       if c_person-central_data-common-datax-bp_person-fullname is not initial.
       clear c_person-central_data-common-datax-bp_person-fullname.
       endif.
      c_person-central_data-common-datax-bp_centraldata-searchterm1 = 'X'.
      c_person-central_data-common-datax-bp_centraldata-searchterm2 = 'X'.
      c_person-central_data-common-datax-bp_centraldata-title_key   = 'X'.
      c_person-central_data-common-datax-bp_centraldata-comm_type   = 'X'.

    else.
      move-corresponding i_contact-address_type_3-postal-datax to c_person-central_data-common-datax-bp_person."#EC ENHOK
      c_person-central_data-common-datax-bp_person-birthname             = i_contact-address_type_3-postal-datax-birth_name.
      c_person-central_data-common-datax-bp_person-namcountryiso         = i_contact-address_type_3-postal-datax-namctryiso.
      c_person-central_data-common-datax-bp_person-correspondlanguage    = i_contact-address_type_3-postal-datax-langu_p.
      c_person-central_data-common-datax-bp_person-correspondlanguageiso = i_contact-address_type_3-postal-datax-langup_iso.
*   c_person-central_data-common-datax-bp_person-fullname_man = i_contact-address_type_3-postal-datax-fullname_x.

      c_person-central_data-common-datax-bp_centraldata-searchterm1 = i_contact-address_type_3-postal-datax-sort1_p.
      c_person-central_data-common-datax-bp_centraldata-searchterm2 = i_contact-address_type_3-postal-datax-sort2_p.
      c_person-central_data-common-datax-bp_centraldata-title_key   = i_contact-address_type_3-postal-datax-title_p.
      c_person-central_data-common-datax-bp_centraldata-comm_type   = i_contact-address_type_3-postal-datax-comm_type.
    endif.
  endif.

  if i_contact-data is not initial.

    select single gp_abtnr from cvic_cp1_link into c_relation-central_data-contact-central_data-data-department
                          where abtnr            = i_contact-data-abtnr.
    select single gp_pafkt from cvic_cp2_link into c_relation-central_data-contact-central_data-data-function
                          where pafkt            = i_contact-data-pafkt.
    select single paauth   from cvic_cp3_link into c_relation-central_data-contact-central_data-data-authority
                          where parvo            = i_contact-data-parvo.
    select single gp_pavip from cvic_cp4_link into c_relation-central_data-contact-central_data-data-vip
                          where pavip            = i_contact-data-pavip.
    select single marst    from cvic_marst_link into c_person-central_data-common-data-bp_person-maritalstatus
                          where famst            = i_contact-data-famst.

    c_relation-central_data-contact-central_data-data-comments = i_contact-data-parau.
    c_person-central_data-common-data-bp_person-birthdate      = i_contact-data-gbdat.

  if i_contact-task = task_current_state.                                    "*1978621 i+
    c_relation-central_data-contact-central_data-datax-department =
    c_relation-central_data-contact-central_data-datax-function   =
    c_relation-central_data-contact-central_data-datax-authority  =
    c_relation-central_data-contact-central_data-datax-vip        =
    c_relation-central_data-contact-central_data-datax-comments   =
    c_person-central_data-common-datax-bp_person-sex              =
    c_person-central_data-common-datax-bp_person-birthdate        =
    c_person-central_data-common-datax-bp_person-maritalstatus    = 'X'.
  else.                                                                      "*1978621 i-
    c_relation-central_data-contact-central_data-datax-department = i_contact-datax-abtnr.
    c_relation-central_data-contact-central_data-datax-function   = i_contact-datax-pafkt.
    c_relation-central_data-contact-central_data-datax-authority  = i_contact-datax-parvo.
    c_relation-central_data-contact-central_data-datax-vip        = i_contact-datax-pavip.
    c_relation-central_data-contact-central_data-datax-comments   = i_contact-datax-parau.
    c_person-central_data-common-datax-bp_person-sex              = i_contact-datax-parge.
    c_person-central_data-common-datax-bp_person-birthdate        = i_contact-datax-gbdat.
    c_person-central_data-common-datax-bp_person-maritalstatus    = i_contact-datax-famst.
  endif.

* mapping to c_person-central_data-common
    if i_contact-data-parge = lc_contact_male.
      c_person-central_data-common-data-bp_person-sex = lc_bp_male.
    elseif i_contact-data-parge = lc_contact_female.
      c_person-central_data-common-data-bp_person-sex = lc_bp_female.
    else.
      c_person-central_data-common-data-bp_person-sex = i_contact-data-parge.
    endif.

  endif.

endmethod.


method MAP_VC_PRIVATE_ADDRESS.

  data:
    ls_address     type bus_ei_bupa_address,
    lv_parge       type parge,
    lv_title_datax type c.

  field-symbols:
    <address>      type bus_ei_bupa_address.

  check i_contact-address_type_2 is not initial.

  read table c_person-central_data-address-addresses assigning <address>
    with key data-postal-data-standardaddress = true.
  if sy-subrc <> 0.
    ls_address-task = task_standard.
    ls_address-data-postal-data-standardaddress = 'X'.
    append ls_address to c_person-central_data-address-addresses assigning <address>.
  endif.

  if <address> is assigned.
*   save the sex field that is already mapped to bp (mapped in address type 3 mapping)
    lv_parge = c_person-central_data-common-data-bp_person-sex.
*   save the datax value of the title field that is already mapped (mapped in address type 3 mapping)
    lv_title_datax = c_person-central_data-common-datax-bp_centraldata-title_key.

    move-corresponding i_contact-address_type_2-postal-data to c_person-central_data-common-data-bp_person."#EC ENHOK
    c_person-central_data-common-data-bp_person-birthname             = i_contact-address_type_2-postal-data-birth_name.
    c_person-central_data-common-data-bp_person-namcountryiso         = i_contact-address_type_2-postal-data-namctryiso.
    c_person-central_data-common-data-bp_person-correspondlanguage    = i_contact-address_type_2-postal-data-langu_p.
    c_person-central_data-common-data-bp_person-correspondlanguageiso = i_contact-address_type_2-postal-data-langup_iso.
    c_person-central_data-common-data-bp_person-fullname_man          = i_contact-address_type_2-postal-data-fullname_x.

  if NOT i_contact-address_type_2-postal-data-sort1_p IS INITIAL.
    c_person-central_data-common-data-bp_centraldata-searchterm1 = i_contact-address_type_2-postal-data-sort1_p.
  ENDIF.
  if NOT i_contact-address_type_2-postal-data-sort2_p IS INITIAL.
    c_person-central_data-common-data-bp_centraldata-searchterm2 = i_contact-address_type_2-postal-data-sort2_p.
  ENDIF.
    c_person-central_data-common-data-bp_centraldata-title_key   = i_contact-address_type_2-postal-data-title_p.
    c_person-central_data-common-data-bp_centraldata-comm_type   = i_contact-address_type_2-postal-data-comm_type.

* datax
    if i_contact-task = task_current_state.
      translate c_person-central_data-common-datax-bp_person using ' X'.
    else.
      move-corresponding i_contact-address_type_2-postal-datax to c_person-central_data-common-datax-bp_person."#EC ENHOK
      c_person-central_data-common-datax-bp_person-birthname             = i_contact-address_type_2-postal-datax-birth_name.
      c_person-central_data-common-datax-bp_person-namcountryiso         = i_contact-address_type_2-postal-datax-namctryiso.
      c_person-central_data-common-datax-bp_person-correspondlanguage    = i_contact-address_type_2-postal-datax-langu_p.
      c_person-central_data-common-datax-bp_person-correspondlanguageiso = i_contact-address_type_2-postal-datax-langup_iso.
*   c_person-central_data-common-datax-bp_person-fullname_man = i_contact-address_type_2-postal-datax-fullname_x.

    if NOT i_contact-address_type_2-postal-datax-sort1_p IS INITIAL.
      c_person-central_data-common-datax-bp_centraldata-searchterm1 = i_contact-address_type_2-postal-datax-sort1_p.
    ENDIF.
    if NOT i_contact-address_type_2-postal-datax-sort2_p IS INITIAL.
      c_person-central_data-common-datax-bp_centraldata-searchterm2 = i_contact-address_type_2-postal-datax-sort2_p.
    ENDIF.
      c_person-central_data-common-datax-bp_centraldata-title_key   = i_contact-address_type_2-postal-datax-title_p.
      c_person-central_data-common-datax-bp_centraldata-comm_type   = i_contact-address_type_2-postal-datax-comm_type.
    endif.
    move-corresponding:
      i_contact-address_type_2-postal  to <address>-data-postal,"#EC ENHOK
      i_contact-address_type_2-remark  to <address>-data-remark."#EC ENHOK
    <address>-data-postal-data-languiso = i_contact-address_type_2-postal-data-langup_iso.

    map_contact_version(
      exporting
        i_contact_version = i_contact-address_type_2-version
      importing
        e_bp_version      = <address>-data-version
           ).

    map_cv_communication(
      exporting
        i_cvi_communication = i_contact-address_type_2-communication
      importing
        e_bp_communication  = <address>-data-communication
    ).

* Reassign the sex field to bp
    c_person-central_data-common-data-bp_person-sex = lv_parge.
    c_person-central_data-common-datax-bp_centraldata-title_key = lv_title_datax.
  endif.

endmethod.


method MAP_VEND_CONT_TO_BP_AND_REL.

  data:
    lv_msgvar1    type symsgv,
    lv_msgvar2    type symsgv,
    ls_message    type bapiret2.

  if i_vendor_contact-task <> task_insert and
     i_vendor_contact-task <> task_current_state and
     i_vendor_contact-task <> task_update and
     i_vendor_contact-task <> task_delete and
     i_vendor_contact-task <> task_modify.

    lv_msgvar1 = i_vendor_contact-task.
    lv_msgvar2 = i_vendor_contact-data_key-parnr.

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
* deletion of a customer contact causes a deletion of the relation
  if i_vendor_contact-task = task_delete.
    c_relation-header-object_task = task_delete.
    return.
  endif.

  map_vc_general_data(
    exporting
      i_contact  = i_vendor_contact
    changing
      c_person   = c_person
      c_relation = c_relation
      ).

  map_vc_contact_address(
    exporting
      i_contact  = i_vendor_contact
    changing
      c_partner  = c_partner
      c_person   = c_person
      c_relation = c_relation
      ).

  map_vc_private_address(
     exporting
       i_contact  = i_vendor_contact
     changing
       c_person   = c_person
      ).

  map_vc_business_hours(
    exporting
      i_contact  = i_vendor_contact
    changing
      c_relation = c_relation
      ).

endmethod.
ENDCLASS.
