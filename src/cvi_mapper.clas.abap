class CVI_MAPPER definition
  public
  final
  create private .

public section.

  interfaces IF_BADI_CONTEXT .
  interfaces IF_CVI_COMMON_CONSTANTS .

  constants TEMP_HANDLE type CHAR2 value '##' ##NO_TEXT.
  data BADI_SYNTYPE_REF type ref to CVI_SYN_TYPE .

  class-methods GET_INSTANCE
    returning
      value(R_INSTANCE) type ref to CVI_MAPPER .
  methods CONSTRUCTOR .
  methods FLUSH_ASSIGNMENTS .
  methods GET_ASSIGNED_BPS_FOR_CUSTOMERS
    importing
      !I_CUSTOMERS type CVIS_CUSTOMER_T
    returning
      value(R_PARTNERS) type CVIS_CUST_LINK_T .
  methods GET_ASSIGNED_BPS_FOR_VENDORS
    importing
      !I_VENDORS type CVIS_VENDOR_T
    returning
      value(R_PARTNERS) type CVIS_VEND_LINK_T .
  methods GET_ASSIGNED_CONT_RELS_4_CUSTS
    importing
      !I_CUSTOMERS type CVIS_CUSTOMER_T
    returning
      value(R_CONTACT_RELATIONS) type CVIS_CUST_CT_REL_KEY_T .
  methods GET_ASSIGNED_CUSTOMERS_FOR_BPS
    importing
      !I_PARTNER_IDS type BU_PARTNER_T optional
      !I_PARTNER_GUIDS type BU_PARTNER_GUID_T optional
    returning
      value(R_CUSTOMERS) type CVIS_CUST_LINK_T .
  methods GET_ASSIGNED_CUST_CT_4_BP_RELS
    importing
      !I_CONTACT_RELATIONS type CVIS_CONTACT_RELATION_T
    returning
      value(R_CUSTOMER_CONTACTS) type CVIS_CUST_CT_REL_KEY_T .
  methods GET_ASSIGNED_VENDORS_FOR_BPS
    importing
      !I_PARTNER_IDS type BU_PARTNER_T optional
      !I_PARTNER_GUIDS type BU_PARTNER_GUID_T optional
    returning
      value(R_VENDORS) type CVIS_VEND_LINK_T .
  methods IS_MAPPING_FOR_CONTACT_ACTIVE
    returning
      value(R_RESULT) type CVI_MAP_CONTACT .
  methods MAP_BPS_TO_CUSTOMERS
    importing
      !I_PARTNERS type BUS_EI_MAIN
    exporting
      !E_CUSTOMERS type CMDS_EI_EXTERN_T
      !E_ERRORS type CVIS_ERROR .
  methods MAP_BPS_TO_VENDORS
    importing
      !I_PARTNERS type BUS_EI_MAIN
    exporting
      !E_VENDORS type VMDS_EI_EXTERN_T
      !E_ERRORS type CVIS_ERROR .
  methods MAP_CUSTOMERS_TO_BPS
    importing
      !I_CUSTOMERS type CMDS_EI_EXTERN_T
    exporting
      !E_PARTNERS type BUS_EI_MAIN
      !E_ERRORS type CVIS_ERROR .
  methods MAP_VENDORS_TO_BPS
    importing
      !I_VENDORS type VMDS_EI_EXTERN_T
    exporting
      !E_PARTNERS type BUS_EI_MAIN
      !E_ERRORS type CVIS_ERROR .
  methods UNDO_ASSIGNMENTS
    importing
      !I_FOR_PARTNERS type BU_PARTNER_GUID_T optional
      !I_FOR_CUSTOMERS type CVIS_CUSTOMER_T optional
      !I_FOR_VENDORS type CVIS_VENDOR_T optional
    returning
      value(R_MESSAGES) type CVIS_ERROR .
  methods GET_KA_REFERENCE
    importing
      !I_KA_OBJECT_NAME type CVI_KA_OBJECT_NAME
    returning
      value(R_REFERENCE) type ref to AC_CVI_KEY_ASSIGNMENT .
  methods GET_ASSIGNED_CONT_RELS_4_VENDS
    importing
      !I_VENDORS type CVIS_VENDOR_T
    returning
      value(R_CONTACT_RELATIONS) type CVIS_CUST_CT_REL_KEY_T .
  methods GET_ASSIGNED_VEND_CT_4_BP_RELS
    importing
      !I_CONTACT_RELATIONS type CVIS_CONTACT_RELATION_T
    returning
      value(R_VENDOR_CONTACTS) type CVIS_CUST_CT_REL_KEY_T .
protected section.
*"* protected components of class CVI_MAPPER
*"* do not include other source files here!!!
private section.

*"* private components of class CVI_MAPPER
*"* do not include other source files here!!!
  aliases BP_AS_GROUP
    for IF_CVI_COMMON_CONSTANTS~BP_AS_GROUP .
  aliases BP_AS_ORG
    for IF_CVI_COMMON_CONSTANTS~BP_AS_ORG .
  aliases BP_AS_PERSON
    for IF_CVI_COMMON_CONSTANTS~BP_AS_PERSON .
  aliases CVI_MAPPER_BADI_NAME
    for IF_CVI_COMMON_CONSTANTS~CVI_MAPPER_BADI_NAME .
  aliases CVI_MAP_BANKDETAILS_BADI_NAME
    for IF_CVI_COMMON_CONSTANTS~CVI_MAP_BANKDETAILS_BADI_NAME .
  aliases CVI_MAP_CREDIT_CARDS_BADI_NAME
    for IF_CVI_COMMON_CONSTANTS~CVI_MAP_CREDIT_CARDS_BADI_NAME .
  aliases CVI_MAP_TITLE_BADI_NAME
    for IF_CVI_COMMON_CONSTANTS~CVI_MAP_TITLE_BADI_NAME .
  aliases FALSE
    for IF_CVI_COMMON_CONSTANTS~FALSE .
  aliases MSG_CLASS_CVI
    for IF_CVI_COMMON_CONSTANTS~MSG_CLASS_CVI .
  aliases TASK_CURRENT_STATE
    for IF_CVI_COMMON_CONSTANTS~TASK_CURRENT_STATE .
  aliases TASK_DELETE
    for IF_CVI_COMMON_CONSTANTS~TASK_DELETE .
  aliases TASK_INSERT
    for IF_CVI_COMMON_CONSTANTS~TASK_INSERT .
  aliases TASK_MODIFY
    for IF_CVI_COMMON_CONSTANTS~TASK_MODIFY .
  aliases TASK_STANDARD
    for IF_CVI_COMMON_CONSTANTS~TASK_STANDARD .
  aliases TASK_UPDATE
    for IF_CVI_COMMON_CONSTANTS~TASK_UPDATE .
  aliases TRUE
    for IF_CVI_COMMON_CONSTANTS~TRUE .

  data GT_RETURN_VENDOR_CANDIDATES type CVIS_CUSTOMER_T .
  constants CUSTOMER_MAPPING type CVI_KA_OBJECT_NAME value 'CUSTOMER' ##NO_TEXT.
  constants VENDOR_MAPPING type CVI_KA_OBJECT_NAME value 'VENDOR' ##NO_TEXT.
  data BADI_REF_TITLE type ref to CVI_MAP_TITLE .
  class-data INSTANCE type ref to CVI_MAPPER .
  data FM_BP_CUSTOMER type ref to CVI_FM_BP_CUSTOMER .
  data FM_BP_CUSTOMER_CONTACT type ref to CVI_FM_BP_CUSTOMER_CONTACT .
  data FM_BP_VENDOR type ref to CVI_FM_BP_VENDOR .
  data KA_REFS type CVIS_KA_OBJECT_T .
  data BADI_REF type ref to CVI_CUSTOM_MAPPER .
  data FM_BP_VENDOR_CONTACT type ref to CVI_FM_BP_VENDOR_CONTACT .

  methods DETERMINE_BP_CUST_ASSIGNMENTS
    importing
      !I_KA_OBJECT type ref to CVI_KA_BP_CUSTOMER
      !I_PARTNER type BUS_EI_EXTERN
    exporting
      !E_CUST_LINK type CVI_CUST_LINK
      !E_NEW_LINK type BOOLE-BOOLE
      !E_ERROR type CVIS_ERROR .
  methods DETERMINE_BP_VEND_ASSIGNMENTS
    importing
      !I_KA_OBJECT type ref to CVI_KA_BP_VENDOR
      !I_PARTNER type BUS_EI_EXTERN
    exporting
      !E_VEND_LINK type CVI_VEND_LINK
      !E_NEW_LINK type BOOLE-BOOLE
      !E_ERROR type CVIS_ERROR .
  methods EXTRACT_VALID_ROLE_CATEGORIES
    importing
      !I_ROLES type BUS_EI_BUPA_ROLES_T
    returning
      value(R_ROLE_CATEGORIES) type CVIS_ROLE_CATEGORY_T .
  methods FIND_CUSTOMER
    importing
      !I_CUSTOMER_ID type KUNNR
      !I_CUSTOMERS type CMDS_EI_EXTERN_T
    exporting
      !E_CUSTOMER type CMDS_EI_EXTERN .
  methods HANDLE_ERROR
    importing
      !IT_COUNT type CVIS_MESSAGE_ROW_T
      !IS_ERRORS type CVIS_ERROR
      !IS_CUSTOMERS type CMDS_EI_EXTERN
    changing
      !E_ERRORS type CVIS_ERROR .
ENDCLASS.



CLASS CVI_MAPPER IMPLEMENTATION.


method constructor.

  class cl_exithandler definition load.

  data:
    ls_ka_refs like line of ka_refs.

* initialize key mapper objects
  ls_ka_refs-name = customer_mapping.
  ls_ka_refs-ref  = cvi_ka_bp_customer=>get_instance( ).
  append ls_ka_refs to ka_refs.

  ls_ka_refs-name = vendor_mapping.
  ls_ka_refs-ref  = cvi_ka_bp_vendor=>get_instance( ).
  append ls_ka_refs to ka_refs.

** register Init modules for Customer mapping and Vendor mapping
  CALL FUNCTION 'INIT_EVENT_REGISTER'
    EXPORTING
      FUNCNAME       = 'CVI_BUFFER_REFRESH_VENDOR'.
  CALL FUNCTION 'INIT_EVENT_REGISTER'
    EXPORTING
      FUNCNAME       = 'CVI_BUFFER_REFRESH_CUSTOMER'.

* initialize field mapper objects
  fm_bp_customer_contact = cvi_fm_bp_customer_contact=>get_instance( ).
  fm_bp_customer         = cvi_fm_bp_customer=>get_instance( ).
  fm_bp_vendor           = cvi_fm_bp_vendor=>get_instance( ).
  fm_bp_vendor_contact   = cvi_fm_bp_vendor_contact=>get_instance( ).
* initialize BAdIs
  try.
    get badi badi_ref
      context
        me.

    catch CX_BADI_NOT_IMPLEMENTED. "no active implementation
  endtry.

  try.
    get badi badi_ref_title
      context
        me.

    catch CX_BADI_NOT_IMPLEMENTED. "no active implementation
  endtry.

  try.
    get badi badi_syntype_ref.

    catch CX_BADI_NOT_IMPLEMENTED. "no active implementation
  endtry.
endmethod.


method determine_bp_cust_assignments.

  data:
    lt_role_cat     type fsbp_tb003a_tty,
    lt_cvi_role_cat type cvis_role_category_t,
    lcl_bo_cvi      type ref to fsbp_bo_cvi,
    lv_grouping     type bu_group.

  field-symbols:
    <role_cat>          like line of lt_role_cat.

  move i_partner-header-object_instance-bpartnerguid to e_cust_link-partner_guid.
  e_cust_link-customer = i_ka_object->get_assigned_customer_for_bp( e_cust_link-partner_guid ).

  if e_cust_link-customer is initial.

    "new FSBP services in ERP set BO BUSINESS_PARTNER which leads to a move-cast-error here
    "==> enforce BUSINESS_PARTNER_CLASSIC instance - note 2167052
    lcl_bo_cvi ?= fsbp_business_factory=>get_instance(
      i_partner = i_partner-header-object_instance-bpartner
      i_name    = 'BUSINESS_PARTNER_CLASSIC'
    ).
    lt_role_cat = lcl_bo_cvi->get_role_cat_ext( i_partner-central_data-role-roles ).
    loop at lt_role_cat assigning <role_cat>.
      append <role_cat>-rolecategory to lt_cvi_role_cat.
    endloop.

    if i_ka_object->is_customer_required_for_bp(
        i_partner_id      = i_partner-header-object_instance-bpartner
        i_partner_guid    = e_cust_link-partner_guid
        i_role_categories = lt_cvi_role_cat
      ) = i_ka_object->req_status_required.

      e_cust_link-customer = lcl_bo_cvi->customer->get_customer( ).
      if e_cust_link-customer is initial or
         e_cust_link-customer(2) = temp_handle.
        lv_grouping = lcl_bo_cvi->get_grouping( ).
        i_ka_object->new_customer_id(
          exporting
            i_partner_id       = i_partner-header-object_instance-bpartner
            i_group            = lv_grouping
            i_role_categories  = lt_cvi_role_cat
          importing
            e_customer_id      = e_cust_link-customer
            e_error            = e_error
        ).

        if e_error-is_error = true.
          clear e_cust_link.
          exit.
        endif.
      endif.

      i_ka_object->new_assignment(
        i_partner_guid = e_cust_link-partner_guid
        i_customer_id  = e_cust_link-customer
      ).
      e_new_link = true.

    else.
      clear e_cust_link.
    endif.

  endif.

endmethod.


method determine_bp_vend_assignments.

  data:
    lt_role_cat     type fsbp_tb003a_tty,
    lt_cvi_role_cat type cvis_role_category_t,
    lcl_bo_cvi      type ref to fsbp_bo_cvi,
    lv_grouping     type bu_group.

  field-symbols:
    <role_cat>         like line of lt_role_cat.

  move i_partner-header-object_instance-bpartnerguid to e_vend_link-partner_guid.
  e_vend_link-vendor = i_ka_object->get_assigned_vendor_for_bp( e_vend_link-partner_guid ).

  if e_vend_link-vendor is initial.

    "new FSBP services in ERP set BO BUSINESS_PARTNER which leads to a move-cast-error here
    "==> enforce BUSINESS_PARTNER_CLASSIC instance - note 2167052
    lcl_bo_cvi ?= fsbp_business_factory=>get_instance(
      i_partner = i_partner-header-object_instance-bpartner
      i_name    = 'BUSINESS_PARTNER_CLASSIC'
    ).
    lt_role_cat = lcl_bo_cvi->get_role_cat_ext( i_partner-central_data-role-roles ).
    loop at lt_role_cat assigning <role_cat>.
      append <role_cat>-rolecategory to lt_cvi_role_cat.
    endloop.

    if i_ka_object->is_vendor_required_for_bp(
        i_partner_id      = i_partner-header-object_instance-bpartner
        i_partner_guid    = e_vend_link-partner_guid
        i_role_categories = lt_cvi_role_cat
      ) = i_ka_object->req_status_required.

      e_vend_link-vendor = lcl_bo_cvi->vendor->get_vendor( ).
      if e_vend_link-vendor is initial or
         e_vend_link-vendor(2) = temp_handle.
        lv_grouping = lcl_bo_cvi->get_grouping( ).
        i_ka_object->new_vendor_id(
          exporting
            i_partner_id       = i_partner-header-object_instance-bpartner
            i_group            = lv_grouping
            i_role_categories  = lt_cvi_role_cat
          importing
            e_vendor_id        = e_vend_link-vendor
            e_error            = e_error
        ).

        if e_error-is_error = true.
          clear e_vend_link.
          exit.
        endif.
      endif.

      i_ka_object->new_assignment(
        i_partner_guid = e_vend_link-partner_guid
        i_vendor_id    = e_vend_link-vendor
      ).
      e_new_link = true.

    else.
      clear e_vend_link.
    endif.

  endif.

endmethod.


method extract_valid_role_categories.

  data:
    ls_role_categories like line of r_role_categories.
  field-symbols:
    <role>             like line of i_roles.

  loop at i_roles assigning <role>.
    check <role>-data-valid_to >= sy-datum or
          <role>-data-valid_to is initial.
    ls_role_categories-category = <role>-data-rolecategory.
    append ls_role_categories to r_role_categories.
  endloop.

endmethod.


method find_customer.

  assert:
    i_customer_id is not initial.

  read table i_customers into e_customer
    with key header-object_instance-kunnr = i_customer_id.

endmethod.


method flush_assignments.

  data:
    ls_ka_refs like line of ka_refs.

  loop at ka_refs into ls_ka_refs.
    ls_ka_refs-ref->flush_assignments( ).
  endloop.

endmethod.


method get_assigned_bps_for_customers.

  data:
    lcl_ka_customer type ref to cvi_ka_bp_customer,
    ls_partner      like line of r_partners.
  field-symbols:
    <customer>  like line of i_customers.

  lcl_ka_customer ?= get_ka_reference( customer_mapping ).

  loop at i_customers assigning <customer>.
    ls_partner = lcl_ka_customer->get_bp_4_customer_assignment( <customer> ).
    check ls_partner is not initial.
    append ls_partner to r_partners.
  endloop.

endmethod.


method get_assigned_bps_for_vendors.

  data:
    lcl_ka_vendor   type ref to cvi_ka_bp_vendor,
    ls_partner      like line of r_partners.
  field-symbols:
    <vendor>  like line of i_vendors.

  lcl_ka_vendor ?= get_ka_reference( vendor_mapping ).

  loop at i_vendors assigning <vendor>.
    ls_partner = lcl_ka_vendor->get_bp_4_vendor_assignment( <vendor> ).
    check ls_partner is not initial.
    append ls_partner to r_partners.
  endloop.

endmethod.


method get_assigned_cont_rels_4_custs.

  data:
    ls_customers         like line of i_customers,
    lt_contact_relations like r_contact_relations,
    lcl_ka_customer      type ref to cvi_ka_bp_customer.

  lcl_ka_customer ?= get_ka_reference( customer_mapping ).

  loop at i_customers into ls_customers.
    lt_contact_relations[] = lcl_ka_customer->get_assigned_cont_rel_for_cust( ls_customers ).
    append lines of lt_contact_relations to r_contact_relations.
  endloop.

endmethod.


method GET_ASSIGNED_CONT_RELS_4_VENDS.

  data:
    ls_vendors           like line of i_vendors,
    lt_contact_relations like r_contact_relations,
    lcl_ka_vendor      type ref to cvi_ka_bp_vendor.

  lcl_ka_vendor ?= get_ka_reference( vendor_mapping ).

  loop at i_vendors into ls_vendors.
    lt_contact_relations[] = lcl_ka_vendor->get_assigned_cont_rel_for_vend( ls_vendors ).
    append lines of lt_contact_relations to r_contact_relations.
  endloop.

endmethod.


method get_assigned_customers_for_bps.

  data:
    lcl_ka_customer  type ref to cvi_ka_bp_customer,
    lt_partner_guids like i_partner_guids,
    lv_partner_guid  like line of i_partner_guids,
    ls_customer      like line of r_customers.
  field-symbols:
    <partner_id>     like line of i_partner_ids,
    <partner_guid>   like line of i_partner_guids.

  lcl_ka_customer ?= get_ka_reference( customer_mapping ).

  lt_partner_guids[] = i_partner_guids[].
  loop at i_partner_ids assigning <partner_id>.
    lv_partner_guid = lcl_ka_customer->get_partner_guid( <partner_id>-partner ).
    if lv_partner_guid is not initial.
      append lv_partner_guid to lt_partner_guids.
    endif.
  endloop.

  loop at lt_partner_guids assigning <partner_guid>.
    ls_customer = lcl_ka_customer->get_customer_4_bp_assignment( <partner_guid> ).
    check ls_customer is not initial.
    append ls_customer to r_customers.
  endloop.

endmethod.


method get_assigned_cust_ct_4_bp_rels.

  data:
    ls_relation          like line of i_contact_relations,
    ls_customer_contact  like line of r_customer_contacts,
    lcl_ka_customer      type ref to cvi_ka_bp_customer.

  lcl_ka_customer ?= get_ka_reference( customer_mapping ).

  loop at i_contact_relations into ls_relation.
    if ls_relation-partner_guid is initial.
      ls_customer_contact-partner_guid = lcl_ka_customer->get_partner_guid( ls_relation-partner1 ).
    else.
      ls_customer_contact-partner_guid = ls_relation-partner_guid.
    endif.
    if ls_relation-partner_guid is initial.
      ls_customer_contact-person_guid  = lcl_ka_customer->get_partner_guid( ls_relation-partner2 ).
    else.
      ls_customer_contact-person_guid  = ls_relation-person_guid.
    endif.
    ls_customer_contact-customer_cont  = lcl_ka_customer->get_assigned_cust_ct_4_bp_rel(
      i_partner_guid = ls_customer_contact-partner_guid
      i_person_guid  = ls_customer_contact-person_guid
    ).
    append ls_customer_contact to r_customer_contacts.
  endloop.

endmethod.


method get_assigned_vendors_for_bps.

  data:
    lcl_ka_vendor    type ref to cvi_ka_bp_vendor,
    lt_partner_guids like i_partner_guids,
    ls_vendor        like line of r_vendors,
    lv_partner_guid  type bu_partner_guid.
  field-symbols:
    <partner_id>     like line of i_partner_ids,
    <partner_guid>   like line of i_partner_guids.

  lcl_ka_vendor ?= get_ka_reference( vendor_mapping ).

  lt_partner_guids[] = i_partner_guids[].
  loop at i_partner_ids assigning <partner_id>.
    lv_partner_guid = lcl_ka_vendor->get_partner_guid( <partner_id>-partner ).
    if lv_partner_guid is not initial.
      append lv_partner_guid to lt_partner_guids.
    endif.
  endloop.

  loop at lt_partner_guids assigning <partner_guid>.
    ls_vendor = lcl_ka_vendor->get_vendor_4_bp_assignment( <partner_guid> ).
    check ls_vendor is not initial.
    append ls_vendor to r_vendors.
  endloop.

endmethod.


method GET_ASSIGNED_VEND_CT_4_BP_RELS.

   data:
    ls_relation          like line of i_contact_relations,
    ls_vendor_contact    like line of r_vendor_contacts,
    lcl_ka_vendor        type ref to cvi_ka_bp_vendor.

  lcl_ka_vendor ?= get_ka_reference( vendor_mapping ).

  loop at i_contact_relations into ls_relation.
    if ls_relation-partner_guid is initial.
      ls_vendor_contact-partner_guid = lcl_ka_vendor->get_partner_guid( ls_relation-partner1 ).
    else.
      ls_vendor_contact-partner_guid = ls_relation-partner_guid.
    endif.
    if ls_relation-partner_guid is initial.
      ls_vendor_contact-person_guid  = lcl_ka_vendor->get_partner_guid( ls_relation-partner2 ).
    else.
      ls_vendor_contact-person_guid  = ls_relation-person_guid.
    endif.
    ls_vendor_contact-customer_cont  = lcl_ka_vendor->get_assigned_vend_ct_4_bp_rel(
      i_partner_guid = ls_vendor_contact-partner_guid
      i_person_guid  = ls_vendor_contact-person_guid
    ).
    append ls_vendor_contact to r_vendor_contacts.
  endloop.

endmethod.


method get_instance.

  if instance is not bound.
    create object instance.
  endif.
  r_instance = instance.

endmethod.


method get_ka_reference.

  data:
    ls_ref   like line of ka_refs.

  assert i_ka_object_name is not initial.

  read table ka_refs into ls_ref
    with key name = i_ka_object_name.

  r_reference = ls_ref-ref.

endmethod.


method HANDLE_ERROR.
data :
  ls_messages          TYPE bapiret2,
  ls_count_row         TYPE cvis_message_row.

  READ TABLE     it_count
          INTO     ls_count_row
          WITH KEY customer = is_customers-header-object_instance-kunnr.
  LOOP AT is_errors-messages INTO ls_messages.
    ls_messages-row = ls_count_row-line.
    APPEND ls_messages TO e_errors-messages.
  ENDLOOP.

  e_errors-is_error = is_errors-is_error.

endmethod.


method is_mapping_for_contact_active.

  select single map_contact from cvic_map_contact into r_result.

endmethod.


method map_bps_to_customers.

  data:
    lt_count              type cvis_message_row_t,
    lt_partners           like i_partners-partners,
    lt_relations          like i_partners-relations,
    lt_partners_new       like i_partners-partners,
    lt_cust_link          type cvis_cust_link_t,
    lt_cust_link_new      type cvis_cust_link_t,
    lt_cust_ct_links      type cvis_cust_ct_link_t,
    lt_cust_ct_links_p    type cvis_cust_ct_link_t,

    ls_count_row          type cvis_message_row,
    ls_messages           type bapiret2,
*    ls_tbd001             type tbd001,
    ls_cust_link          like line of lt_cust_link_new,
    ls_customers          like line of e_customers,
    ls_person             type bus_ei_extern,
    ls_partner            type bus_ei_extern,
    ls_relation           type burs_ei_extern,
    ls_relation_tmp        TYPE burs_ei_extern,
    ls_main_relation      type burs_ei_extern,
    ls_errors             like e_errors,
    ls_bus_ei_main        type bus_ei_main,
    ls_contacts           like line of ls_customers-central_data-contact-contacts,
    ls_address            type bus_ei_bupa_address,
    ls_cust_ct_assignment type cvi_cust_ct_link,
    ls_cust_ct_link       type cvi_cust_ct_link,
    ls_addresses          type line of bus_ei_bupa_address_t,
    ls_partners           like line of i_partners-partners,

*    lv_group              type bu_group,
    lv_partner_guid       type bu_partner_guid,
    lv_partner_number     type bu_partner,
    lv_person_number      type bu_partner,
    lv_person_guid        type bu_partner_guid,
    lv_is_new             type boole-boole,
    lv_ct_is_new          type boole-boole,
    lv_cust_is_new        type boole-boole,
    lv_existing_contact   type boole-boole,
    lv_customer_contact   type cvi_customer_contact,
    lv_customer_id        type kunnr,
    lv_standardaddr_guid  type sysuuid_c,
    lv_text(60)           type c,
    lv_msgtext(60)        type c,

    lcl_ka_customer       type ref to cvi_ka_bp_customer,
    ls_bus_ei_main_rel    type bus_ei_main.

  field-symbols:
    <partners>            like line of i_partners-partners,
    <relation>            like line of i_partners-relations,
    <cust_ct_link>        like line of lt_cust_ct_links,
    <contact>             like line of ls_customers-central_data-contact-contacts,
    <addresses>           like line of <partners>-central_data-address-addresses,
    <customer>            like ls_customers.

* Initialize exporting parameters
  clear : e_customers,
          e_errors.

* STEP 0: prep work
  lcl_ka_customer ?= get_ka_reference( customer_mapping ).

* STEP 1: determine new and existing asignments and map key data for customers
  loop at i_partners-partners assigning <partners>.

    ls_count_row-line = ls_count_row-line + 1.
    ls_count_row-partner_guid = <partners>-header-object_instance-bpartnerguid.
    append ls_count_row to lt_count.

    determine_bp_cust_assignments(
      exporting
        i_ka_object = lcl_ka_customer
        i_partner   = <partners>
      importing
        e_cust_link = ls_cust_link
        e_new_link  = lv_is_new
        e_error     = ls_errors
    ).
    if ls_errors is not initial.
      clear ls_messages.
      loop at ls_errors-messages into ls_messages.
        ls_messages-row = ls_count_row-line.
        append ls_messages to e_errors-messages.
      endloop.
      e_errors-is_error = ls_errors-is_error.
      check e_errors-is_error = false.
    endif.
    clear ls_partners.
    move-corresponding <partners>   to ls_partners.
    if lv_is_new = true.
      append:
         <partners>   to lt_partners_new,
         ls_cust_link to lt_cust_link_new,
         ls_cust_link to lt_cust_link.
      loop at ls_partners-central_data-address-addresses into ls_addresses where task = 'U' and currently_valid <> 'X'.
        clear ls_addresses-data-postal-datax .
        modify ls_partners-central_data-address-addresses from ls_addresses.
      endloop.
    elseif ls_cust_link-customer is not initial.
      append ls_cust_link to lt_cust_link.
    endif.
    clear: lv_is_new,
           ls_cust_link,
           ls_errors,
           ls_addresses,
           ls_messages.
    append ls_partners to ls_bus_ei_main-partners.

  endloop.

* STEP 1.1: determine existing customer contact asignments and map key data (note 1411483)
  loop at i_partners-partners assigning <partners>.
    if <partners>-central_data-common-data-bp_control-category
            = if_cvi_common_constants~bp_as_person.
      lv_person_guid     = <partners>-header-object_instance-bpartnerguid.
      lt_cust_ct_links_p = lcl_ka_customer->get_all_cust_cts_for_person(
                           i_person_guid = lv_person_guid ).
      if lt_cust_ct_links_p is not initial.
        "==> customer contact assignment exists
        append lines of lt_cust_ct_links_p to lt_cust_ct_links.
        if i_partners-relations is not initial. "consider the scope of Synchronization
        loop at lt_cust_ct_links_p into ls_cust_ct_link.
          "check if business partner has been transferred to synchronization
          read table ls_bus_ei_main-partners transporting no fields
            with key header-object_instance-bpartnerguid
              = ls_cust_ct_link-partner_guid.
          if sy-subrc ne 0.
            "if not add bp to list of partners to be synchronized and to cust link table
            "this is necessary in order to avoid errors due to incomplete data
            clear ls_partners.
            ls_partners-header-object_instance-bpartnerguid = ls_cust_ct_link-partner_guid.
            ls_partners-header-object                       = 'BusinessPartner'.
            ls_partners-header-object_task                  = 'U'.
            call function 'BUPA_NUMBERS_GET'
              exporting
                iv_partner_guid = ls_cust_ct_link-partner_guid
              importing
                ev_partner      = ls_partners-header-object_instance-bpartner.
            append ls_partners to ls_bus_ei_main-partners.
            determine_bp_cust_assignments(
              exporting
                i_ka_object = lcl_ka_customer
                i_partner   = ls_partners
              importing
                e_cust_link = ls_cust_link
                e_new_link  = lv_is_new
            ).
            if lv_is_new is not initial.
              append ls_cust_link to: lt_cust_link, lt_cust_link_new.
            elseif ls_cust_link is not initial.
              append ls_cust_link to lt_cust_link.
            endif.
            clear: ls_cust_link, lv_is_new.
          endif.
        endloop.
        endif.
      endif.
      clear: lv_person_guid, lt_cust_ct_links_p.
    endif.
  endloop.
* STEP 1.2: determine new customer contact asignments and map key data
  lt_relations = i_partners-relations.
  loop at lt_relations assigning <relation>
    where header-object_instance-relat_category = cvi_ka_bp_customer=>rel_type_contact
      and header-object_task                    = task_insert.
    lv_partner_guid = <relation>-header-object_instance-partner1-bpartnerguid.
    "check if business partner has been transferred to synchronization
    read table ls_bus_ei_main-partners transporting no fields
      with key header-object_instance-bpartnerguid = lv_partner_guid.
    if sy-subrc ne 0.
      "if not add bp to list of partners to be synchronized and to cust_link table
      "this is necessary in order to avoid errors due to incomplete data
      clear ls_partners.
      ls_partners-header-object_instance-bpartnerguid = lv_partner_guid.
      ls_partners-header-object                       = 'BusinessPartner'.
      ls_partners-header-object_task                  = 'U'.
      call function 'BUPA_NUMBERS_GET'
        exporting
          iv_partner_guid = lv_partner_guid
        importing
          ev_partner      = ls_partners-header-object_instance-bpartner.
      append ls_partners to ls_bus_ei_main-partners.
      determine_bp_cust_assignments(
        exporting
          i_ka_object = lcl_ka_customer
          i_partner   = ls_partners
        importing
          e_cust_link = ls_cust_link
          e_new_link  = lv_is_new
      ).
      if lv_is_new is not initial.
        append ls_cust_link to: lt_cust_link, lt_cust_link_new.
      elseif ls_cust_link is not initial.
        append ls_cust_link to lt_cust_link.
      endif.
      clear: ls_cust_link, lv_is_new.
    endif.
  endloop.
  clear: lt_relations, lv_partner_guid.
  unassign <relation>.

* check if customer or customer contact data need to be updated
  if lt_cust_link is initial and lt_cust_ct_links is initial.
** if we do not go out, number range will be losted one number
    loop at i_partners-relations transporting no fields where header-object_instance-relat_category = cvi_ka_bp_customer=>rel_type_contact.
      exit.
    endloop.
    if sy-subrc <> 0.
      return.
    endif.
  endif.
  clear: lt_cust_ct_links.

* STEP 2: fill up data for new assignments
  cl_bupa_current_data=>get_all(
    exporting
      is_business_partners = ls_bus_ei_main
    importing
      es_business_partners = ls_bus_ei_main
      es_error             = ls_errors
  ).
  if ls_errors is not initial.
    append lines of ls_errors-messages to e_errors-messages.
    e_errors-is_error = ls_errors-is_error.
    check ls_errors-is_error = false.
    clear ls_errors.
  endif.
  append lines of ls_bus_ei_main-partners to lt_partners.

* STEP 3: map fields for relevant partner<->customer assignments
  loop at lt_partners assigning <partners>.
    clear:
      ls_cust_link,
      ls_customers.
    lv_partner_guid = <partners>-header-object_instance-bpartnerguid.
    read table lt_cust_link into ls_cust_link
      with key partner_guid = lv_partner_guid.
    check sy-subrc = 0.
    ls_customers-header-object_instance-kunnr = ls_cust_link-customer.
    read table lt_cust_link_new into ls_cust_link
      with key partner_guid = lv_partner_guid.
    if sy-subrc = 0.
      ls_customers-header-object_task = task_modify.
      "To support the flexible handling of account groups and numbering
      "the defaulting of the account group is not done anymore. The
      "final determination is moved to CVI_FM_BP_CUSTOMER in method
      "GET_ENHANCEMENT_DATA.
*      lv_group  = <partners>-central_data-common-data-bp_control-grouping.
*      ls_tbd001 = lcl_ka_customer->get_tbd001_line( lv_group ).
*      ls_customers-central_data-central-data-ktokd = ls_tbd001-ktokd.
    else.
      ls_customers-header-object_task              = task_update.
      clear ls_errors.
      cmd_ei_api=>get_ktokd(
        exporting
          iv_kunnr  = ls_customers-header-object_instance-kunnr
        importing
          ev_ktokd  = ls_customers-central_data-central-data-ktokd
          es_error  = ls_errors
      ).
      clear ls_messages.
      read table     lt_count
              into     ls_count_row
              with key partner_guid = lv_partner_guid.
      loop at ls_errors-messages into ls_messages.
        ls_messages-row = ls_count_row-line.
        append ls_messages to e_errors-messages.
      endloop.
      e_errors-is_error = ls_errors-is_error.
      check e_errors-is_error = false.
    endif.

    fm_bp_customer->map_bp_to_customer(
      exporting
        i_partner  = <partners>
      importing
        e_errors   = ls_errors
      changing
        c_customer = ls_customers
    ).
    clear ls_messages.
    read table     lt_count
            into     ls_count_row
            with key partner_guid = <partners>-header-object_instance-bpartnerguid.
    loop at ls_errors-messages into ls_messages.
      ls_messages-row = ls_count_row-line.
      append ls_messages to e_errors-messages.
    endloop.
    e_errors-is_error = ls_errors-is_error.
    check e_errors-is_error = false.

*   call BAdI CVI_CUSTOM_MAPPER
    clear ls_errors.
    if badi_ref is not initial.
      call badi badi_ref->map_bp_to_customer
        exporting
          i_partner  = <partners>
        changing
          c_customer = ls_customers
          c_errors   = ls_errors.
    endif.
    clear ls_messages.
    read table     lt_count
            into     ls_count_row
            with key partner_guid = <partners>-header-object_instance-bpartnerguid.
    loop at ls_errors-messages into ls_messages.
      ls_messages-row = ls_count_row-line.
      append ls_messages to e_errors-messages.
    endloop.
    e_errors-is_error = ls_errors-is_error.
    check e_errors-is_error = false.

    append ls_customers to e_customers.

  endloop.

* STEP 4: detect business partner relations that correspond to customer contacts
  check is_mapping_for_contact_active( ) = true.

  lt_relations = i_partners-relations.
* determine former relations of newly assigned customers
  loop at ls_bus_ei_main-relations into ls_main_relation
        where header-object_instance-relat_category = cvi_ka_bp_customer=>rel_type_contact.
    read table lt_partners_new with key
       header-object_instance-bpartnerguid = ls_main_relation-header-object_instance-partner1-bpartnerguid
       transporting no fields.
    if sy-subrc = 0.
    read table lt_relations with key
       header-object_instance-partner1-bpartnerguid = ls_main_relation-header-object_instance-partner1-bpartnerguid
       header-object_instance-partner2-bpartnerguid = ls_main_relation-header-object_instance-partner2-bpartnerguid
       header-object_instance-relat_category        = ls_main_relation-header-object_instance-relat_category
       transporting no fields.
    if sy-subrc <> 0.
      append ls_main_relation to lt_relations.
    endif.

    else.
      lv_partner_guid  = ls_main_relation-header-object_instance-partner1-bpartnerguid.
      lv_person_guid   = ls_main_relation-header-object_instance-partner2-bpartnerguid.

      lv_customer_contact = lcl_ka_customer->get_assigned_cust_ct_4_bp_rel(
       i_partner_guid  = lv_partner_guid
       i_person_guid   = lv_person_guid
    ).

    IF lv_customer_contact IS INITIAL.
      read table lt_relations with key
       header-object_instance-partner1-bpartnerguid = ls_main_relation-header-object_instance-partner1-bpartnerguid
       header-object_instance-partner2-bpartnerguid = ls_main_relation-header-object_instance-partner2-bpartnerguid
       header-object_instance-relat_category        = ls_main_relation-header-object_instance-relat_category
       transporting no fields.
    if sy-subrc <> 0.
      append ls_main_relation to lt_relations.
    endif.
    ENDIF.

    clear lv_partner_guid.
    clear lv_person_guid.
    clear lv_customer_contact.

    endif.
  endloop.

  loop at LT_RELATIONS ASSIGNING <relation> where header-object_task = task_update.

     lv_partner_guid  = <relation>-header-object_instance-partner1-bpartnerguid.
     lv_person_guid   = <relation>-header-object_instance-partner2-bpartnerguid.

    lv_customer_contact = lcl_ka_customer->get_assigned_cust_ct_4_bp_rel(
      i_partner_guid  = lv_partner_guid
      i_person_guid   = lv_person_guid
    ).

    if lv_customer_contact is INITIAL.
      <relation>-header-object_task = 'C'.
      ENDIF.
    clear lv_partner_guid.
    clear lv_person_guid.
    clear LV_CUSTOMER_CONTACT.

    ENDLOOP.

   LOOP AT i_partners-relations assigning <relation> where header-object_task = task_insert.
    read table lt_relations with key header-object_task = task_delete header-object_instance-partner1 = <relation>-header-object_instance-partner1
    header-object_instance-partner2 = <relation>-header-object_instance-partner2 transporting no fields.
    IF sy-subrc = 0.
      delete lt_relations where header-object_instance-partner1 = <relation>-header-object_instance-partner1 and
      header-object_instance-partner2 = <relation>-header-object_instance-partner2.
      move-corresponding <relation> to ls_relation.
      ls_relation-header-object_task = task_update.

      insert ls_relation into table lt_relations.
   ENDIF.
  ENDLOOP.

* loop at i_partners-relations assigning <relation>
  loop at lt_relations assigning <relation>
    where header-object_instance-relat_category = cvi_ka_bp_customer=>rel_type_contact.

    lv_partner_guid  = <relation>-header-object_instance-partner1-bpartnerguid.
    lv_partner_number = <relation>-header-object_instance-partner1-bpartner.
    lv_person_number  = <relation>-header-object_instance-partner2-bpartner.
    lv_person_guid   = <relation>-header-object_instance-partner2-bpartnerguid.

*   get customer number
    lv_customer_id = lcl_ka_customer->get_assigned_customer_for_bp( lv_partner_guid ).
    check lv_customer_id is not initial and sy-subrc = 0.

*   fill customer structure if necessary
    read table e_customers assigning <customer>
      with key header-object_instance-kunnr = lv_customer_id.
    if <customer> is not assigned.
      clear ls_customers.
      ls_customers-header-object_instance-kunnr = lv_customer_id.
      ls_customers-header-object_task           = task_update.
      assign ls_customers to <customer>.
      lv_cust_is_new = true.
    endif.

*   check contact keymapping
    lv_customer_contact = lcl_ka_customer->get_assigned_cust_ct_4_bp_rel(
      i_partner_guid  = lv_partner_guid
      i_person_guid   = lv_person_guid
    ).
    if lv_customer_contact is initial.
*     new contact: deletion will be ignored
      check <relation>-header-object_task <> task_delete.

      cvi_ei_api=>get_contact_partner_number(
       importing
         ev_parnr = lv_customer_contact
         es_error = ls_errors
      ).

      clear ls_messages.
      read table     lt_count
              into     ls_count_row
              with key partner_guid = lv_partner_guid.
      loop at ls_errors-messages into ls_messages.
        ls_messages-row = ls_count_row-line.
        append ls_messages to e_errors-messages.
      endloop.
      e_errors-is_error = ls_errors-is_error.
      check e_errors-is_error = false.

      if lv_customer_contact is not initial.
        lcl_ka_customer->new_cust_ct_assignment(
          i_partner_guid         = lv_partner_guid
          i_partner_contact_guid = lv_person_guid
          i_customer_contact_id  = lv_customer_contact
        ).
      endif.
*     new contact: update is an error
      if <relation>-header-object_task = task_update.
        clear ls_messages.
        read table     lt_count
              into     ls_count_row
              with key partner_guid = lv_partner_guid.
        ls_messages-row        = ls_count_row-line.
        ls_messages-type       = fsbp_generic_services=>msg_error.
        ls_messages-id         = msg_class_cvi.
        ls_messages-number     = '001'.
        ls_messages-message_v1 = <relation>-header-object_task.
        ls_messages-message_v2 = text-001.
        ls_messages-message_v3 = 'header-object-task'.
        append ls_messages to e_errors-messages.
        e_errors-is_error = 'X'.
        check e_errors-is_error = false.
      endif.
      ls_contacts-task = task_insert.
      ls_contacts-data_key-parnr = lv_customer_contact.
      append ls_contacts to <customer>-central_data-contact-contacts.
    else.
*     existing contact: insert is an error
      if <relation>-header-object_task = task_insert.
        clear ls_messages.
        read table     lt_count
              into     ls_count_row
              with key partner_guid = lv_partner_guid.
        ls_messages-row        = ls_count_row-line.
        ls_messages-type       = fsbp_generic_services=>msg_error.
        ls_messages-id         = msg_class_cvi.
        ls_messages-number     = '001'.
        ls_messages-message_v1 = <relation>-header-object_task.
        ls_messages-message_v2 = text-001.
        ls_messages-message_v3 = 'header-object-task'.
        append ls_messages to e_errors-messages.
        e_errors-is_error = 'X'.
        check e_errors-is_error = false.
      endif.
*   fill contact structure if necessary
      read table <customer>-central_data-contact-contacts
          with key data_key-parnr = lv_customer_contact
          transporting no fields.
      if sy-subrc <> 0.
        ls_contacts-task = task_update.
        ls_contacts-data_key-parnr = lv_customer_contact.
        append ls_contacts to <customer>-central_data-contact-contacts.
      endif.
    endif.

*   assign contact structure
    read table <customer>-central_data-contact-contacts assigning <contact>
        with key data_key-parnr = lv_customer_contact.
*   map deletions
    if <relation>-header-object_task = task_delete.
      <contact>-task = task_delete.
      ls_cust_ct_assignment-partner_guid = <relation>-header-object_instance-partner1-bpartnerguid.
      ls_cust_ct_assignment-person_guid  = <relation>-header-object_instance-partner2-bpartnerguid.
      lcl_ka_customer->remove_cust_ct_assignment( ls_cust_ct_assignment ).
    endif.

*   get person data: from structure
    clear ls_person.
    read table lt_partners into ls_person
        with key header-object_instance-bpartnerguid = lv_person_guid. "#EC *
    if  sy-subrc <> 0 and <contact>-task = task_insert.
*     get person data: from DB
      clear ls_bus_ei_main.
      ls_person-header-object_instance-bpartnerguid = lv_person_guid.
      ls_person-header-object_instance-bpartner     = lv_person_number.
      append ls_person to ls_bus_ei_main-partners.
*     get data from DB
      clear ls_errors.
      cl_bupa_current_data=>get_all(
        exporting
          is_business_partners = ls_bus_ei_main
        importing
          es_business_partners = ls_bus_ei_main
          es_error             = ls_errors
      ).
      if ls_errors is not initial.
        clear ls_messages.
        read table     lt_count
                into     ls_count_row
                with key partner_guid = lv_person_guid.
        loop at ls_errors-messages into ls_messages.
          ls_messages-row = ls_count_row-line.
          append ls_messages to e_errors-messages.
        endloop.
        e_errors-is_error = ls_errors-is_error.
        check e_errors-is_error = false.
      endif.
      read table ls_bus_ei_main-partners into ls_person index 1.
    endif.

*   get org default address from structure if available
    read table i_partners-partners into ls_partner
        with key header-object_instance-bpartnerguid = lv_partner_guid. "#EC *
    if sy-subrc = 0.
      read table ls_partner-central_data-address-addresses
           into  ls_address
           with key currently_valid = true
                    data-postal-data-standardaddress = 'X'.
      if sy-subrc = 0.
        lv_standardaddr_guid = ls_address-data_key-guid.
      else.
        clear lv_standardaddr_guid.
      endif.
    else.
      clear lv_standardaddr_guid.
      ls_partner-header-object_instance-bpartnerguid = lv_partner_guid.
      ls_partner-header-object_instance-bpartner     = lv_partner_number.
    endif.

*   mapping
    clear ls_errors.
    fm_bp_customer_contact->map_bp_rel_to_customer_contact(
      exporting
        i_person       = ls_person
        i_relation     = <relation>
      importing
        e_errors       = ls_errors
      changing
        c_address_guid = lv_standardaddr_guid
        c_contact      = <contact>
    ).

    clear ls_messages.
    read table     lt_count
            into     ls_count_row
            with key partner_guid = lv_partner_guid.
    loop at ls_errors-messages into ls_messages.
      ls_messages-row = ls_count_row-line.
      append ls_messages to e_errors-messages.
    endloop.
    e_errors-is_error = ls_errors-is_error.
    check e_errors-is_error = false.

    assert <contact> is assigned.
*   call BAdI CVI_CUSTOM_MAPPER
    clear ls_errors.
    if badi_ref is not initial.
      call badi badi_ref->map_bp_rel_to_customer_contact
        exporting
          i_partner          = ls_partner
          i_person           = ls_person
          i_relation         = <relation>
        changing
          c_errors           = ls_errors
          c_address_guid     = lv_standardaddr_guid
          c_customer_contact = <contact>.
    endif.
    clear ls_messages.
    read table     lt_count
            into     ls_count_row
            with key partner_guid = lv_partner_guid.
    loop at ls_errors-messages into ls_messages.
      ls_messages-row = ls_count_row-line.
      append ls_messages to e_errors-messages.
    endloop.
    e_errors-is_error = ls_errors-is_error.
    check e_errors-is_error = false.

    if lv_cust_is_new = true.
      append <customer> to e_customers.
      clear lv_cust_is_new.
    endif.

    unassign <customer>.
    clear: lv_partner_guid, lv_person_guid, lv_partner_number, lv_person_number.
  endloop.

  loop at i_partners-partners assigning <partners>.
*   STEP 5: map fields from contact business partner to customer contacts
    move <partners>-header-object_instance-bpartnerguid to lv_person_guid.
    lt_cust_ct_links[] = lcl_ka_customer->get_all_cust_cts_for_person( i_person_guid = lv_person_guid ).
    if lt_cust_ct_links[] is initial.
      move <partners>-header-object_instance-bpartnerguid to lv_partner_guid.
      lt_cust_ct_links[] = lcl_ka_customer->get_all_cust_cts_for_bp( i_partner_guid = lv_partner_guid ).
    endif.

    loop at lt_cust_ct_links assigning <cust_ct_link>.

      clear lv_standardaddr_guid.
      lv_partner_guid = <cust_ct_link>-partner_guid.
      lv_person_guid  = <cust_ct_link>-person_guid.
      lv_customer_contact = <cust_ct_link>-customer_cont.
      read table i_partners-relations with key
           header-object_instance-partner1-bpartnerguid = lv_partner_guid "#EC *
           header-object_instance-partner2-bpartnerguid = lv_person_guid "#EC *
           header-object_instance-relat_category = cvi_ka_bp_customer=>rel_type_contact
           transporting no fields.
      if sy-subrc = 0.
*       already processed in step 4
        continue.
      else.
*       get customer number
        lv_customer_id = lcl_ka_customer->get_assigned_customer_for_bp( lv_partner_guid ).
        check sy-subrc = 0.

*       fill customer structure if necessary
        read table e_customers assigning <customer>
          with key header-object_instance-kunnr = lv_customer_id.
        if <customer> is not assigned.
          clear ls_customers.
          ls_customers-header-object_instance-kunnr = lv_customer_id.
          ls_customers-header-object_task           = task_update.
          assign ls_customers to <customer>.
          lv_ct_is_new = true.
        endif.

*     existing contact: insert is an error
        if <partners>-header-object_task = task_insert.
          clear ls_messages.
          read table     lt_count
                into     ls_count_row
                with key partner_guid = lv_partner_guid.
          ls_messages-row        = ls_count_row-line.
          ls_messages-type       = fsbp_generic_services=>msg_error.
          ls_messages-id         = msg_class_cvi.
          ls_messages-number     = '001'.
          ls_messages-message_v1 = <partners>-header-object_task.
          ls_messages-message_v2 = text-005.
          ls_messages-message_v3 = 'header-object-task'.
          append ls_messages to e_errors-messages.
          e_errors-is_error = 'X'.
          check e_errors-is_error = false.
        endif.
*       fill contact structure if necessary
        read table <customer>-central_data-contact-contacts
            with key data_key-parnr = lv_customer_contact
            transporting no fields.
        if sy-subrc <> 0.
          ls_contacts-task = task_update.
          ls_contacts-data_key-parnr = lv_customer_contact.
          append ls_contacts to <customer>-central_data-contact-contacts.
        endif.
      endif.

*     assign contact structure
      read table <customer>-central_data-contact-contacts assigning <contact>
          with key data_key-parnr = lv_customer_contact.

*     continue with mapping only in case of a person
      check <partners>-central_data-common-data-bp_control-category
              = if_cvi_common_constants~bp_as_person.

*     fill basic relation data
      ls_relation-header-object_task = task_update.
      ls_relation-header-object_instance-partner1-bpartnerguid = lv_partner_guid.
      ls_relation-header-object_instance-partner2-bpartnerguid = lv_person_guid.
      ls_relation-header-object_instance-relat_category = cvi_ka_bp_customer=>rel_type_contact.

      READ TABLE LS_BUS_EI_MAIN-RELATIONS into ls_relation_tmp with KEY
          HEADER-OBJECT_INSTANCE-PARTNER1-BPARTNERGUID =  lv_partner_guid
          HEADER-OBJECT_INSTANCE-PARTNER2-BPARTNERGUID =  lv_person_guid.
      IF sy-subrc EQ 0.
        MOVE-CORRESPONDING ls_relation_tmp-central_data TO ls_relation-central_data.
      ENDIF.

*     mapping
      clear ls_errors.
      fm_bp_customer_contact->map_person_to_customer_contact(
        exporting
          i_person       = <partners>
          i_relation     = ls_relation
        importing
          e_errors       = ls_errors
        changing
          c_address_guid = lv_standardaddr_guid
          c_contact      = <contact>
      ).

      clear ls_messages.
      read table     lt_count
              into     ls_count_row
              with key partner_guid = lv_partner_guid.
      loop at ls_errors-messages into ls_messages.
        ls_messages-row = ls_count_row-line.
        append ls_messages to e_errors-messages.
      endloop.
      e_errors-is_error = ls_errors-is_error.
      check e_errors-is_error = false.

      assert <contact> is assigned.
*     call BAdI CVI_CUSTOM_MAPPER
      clear ls_errors.
      if badi_ref is not initial.
        call badi badi_ref->map_person_to_customer_contact
          exporting
            i_person       = <partners>
            i_relation     = ls_relation
          changing
            c_errors       = ls_errors
            c_address_guid = lv_standardaddr_guid
            c_contact      = <contact>.
      endif.
      clear ls_messages.
      read table     lt_count
              into     ls_count_row
              with key partner_guid = lv_partner_guid.
      loop at ls_errors-messages into ls_messages.
        ls_messages-row = ls_count_row-line.
        append ls_messages to e_errors-messages.
      endloop.
      e_errors-is_error = ls_errors-is_error.
      check e_errors-is_error = false.

      if lv_ct_is_new = true.
        append <customer> to e_customers.
        clear lv_ct_is_new.
      endif.

      unassign <customer>.

    endloop.

*   STEP 6: map address changes of business partner to customer contacts
    clear lt_cust_ct_links.
    move <partners>-header-object_instance-bpartnerguid to lv_partner_guid.
    lt_cust_ct_links[] = lcl_ka_customer->get_all_cust_cts_for_bp( i_partner_guid = lv_partner_guid ).

    if lt_cust_ct_links[] is not initial.
*       fill up data for relations
      clear ls_errors.
      clear: ls_person, ls_bus_ei_main_rel.
      ls_person-header-object_instance-bpartnerguid = <partners>-header-object_instance-bpartnerguid.
      ls_person-header-object_instance-bpartner = <partners>-header-object_instance-bpartner.
      append ls_person to ls_bus_ei_main_rel-partners.

      cl_bupa_current_data=>get_all(
        exporting
          is_business_partners = ls_bus_ei_main_rel
        importing
          es_business_partners = ls_bus_ei_main_rel
        es_error             = ls_errors
    ).
    if ls_errors is not initial.
      append lines of ls_errors-messages to e_errors-messages.
      e_errors-is_error = ls_errors-is_error.
      if ls_errors-is_error = false.
        continue.
        endif.
      endif.
    endif.

    loop at lt_cust_ct_links assigning <cust_ct_link>.
      clear ls_relation.
*       get existing relation data
      lv_person_guid = <cust_ct_link>-person_guid.
      read table i_partners-relations with key
           header-object_instance-partner1-bpartnerguid = lv_partner_guid "#EC *
           header-object_instance-partner2-bpartnerguid = lv_person_guid "#EC *
           header-object_instance-relat_category = cvi_ka_bp_customer=>rel_type_contact
           into ls_relation.
      if sy-subrc = 0.
*         already processed in step 4
        continue.
      endif.

**     fill up data for relations
*      clear ls_errors.
*      cl_bupa_current_data=>get_all(
*        exporting
*          is_business_partners = ls_bus_ei_main
*        importing
*          es_business_partners = ls_bus_ei_main
*          es_error             = ls_errors
*      ).
*      if ls_errors is not initial.
*        append lines of ls_errors-messages to e_errors-messages.
*        e_errors-is_error = ls_errors-is_error.
*        if ls_errors-is_error = false.
*          continue.
*        endif.
*      endif.
      READ TABLE ls_bus_ei_main_rel-relations WITH KEY
         HEADER-OBJECT_INSTANCE-PARTNER1-BPARTNERGUID =  lv_partner_guid
         HEADER-OBJECT_INSTANCE-PARTNER2-BPARTNERGUID =  lv_person_guid
           INTO ls_relation.
      if sy-subrc <> 0.
        continue.
      endif.

*     fill customer structure
      lv_customer_id = lcl_ka_customer->get_assigned_customer_for_bp( lv_partner_guid ).
      check sy-subrc = 0.
      read table e_customers assigning <customer>
        with key header-object_instance-kunnr = lv_customer_id.
      check <customer> is assigned.

*     get standardaddress
      read table <partners>-central_data-address-addresses into ls_address
           with key data-postal-data-standardaddress = true.
      if  sy-subrc = 0
      and ( ls_address-data-postal-datax-standardaddress = true
            or <partners>-central_data-address-current_state = true ). "#EC NEEDED

*       get person data: from structure
        clear ls_person.
        read table lt_partners into ls_person
            with key header-object_instance-bpartnerguid = lv_person_guid. "#EC *

        lv_standardaddr_guid = ls_address-data_key-guid.

*       fill basic contact data
        ls_contacts-task = task_update.
        ls_contacts-data_key-parnr = <cust_ct_link>-customer_cont.

*       mapping
        clear ls_errors.
        fm_bp_customer_contact->map_bp_rel_to_customer_contact(
          exporting
            i_person       = ls_person
            i_relation     = ls_relation
          importing
            e_errors       = ls_errors
          changing
            c_address_guid = lv_standardaddr_guid
            c_contact      = ls_contacts
        ).

        clear ls_messages.
        read table     lt_count
                into     ls_count_row
                with key partner_guid = lv_partner_guid.
        loop at ls_errors-messages into ls_messages.
          ls_messages-row = ls_count_row-line.
          append ls_messages to e_errors-messages.
        endloop.
        e_errors-is_error = ls_errors-is_error.
        check e_errors-is_error = false.

*       call BAdI CVI_CUSTOM_MAPPER
        clear ls_errors.
        if badi_ref is not initial.
          call badi badi_ref->map_bp_rel_to_customer_contact
            exporting
              i_partner          = <partners>
              i_person           = ls_person
              i_relation         = ls_relation
            changing
              c_errors           = ls_errors
              c_address_guid     = lv_standardaddr_guid
              c_customer_contact = ls_contacts.
        endif.
        clear ls_messages.
        read table     lt_count
                into     ls_count_row
                with key partner_guid = lv_partner_guid.
        loop at ls_errors-messages into ls_messages.
          ls_messages-row = ls_count_row-line.
          append ls_messages to e_errors-messages.
        endloop.
        e_errors-is_error = ls_errors-is_error.
        check e_errors-is_error = false.

*       fill contact structure
        read table <customer>-central_data-contact-contacts
            with key data_key-parnr = <cust_ct_link>-customer_cont
            assigning <contact>.
        if sy-subrc = 0.
          <contact> = ls_contacts.

        elseif ls_contacts is not initial.
          append ls_contacts to <customer>-central_data-contact-contacts.
        endif.
        continue.

      endif.                                                "#EC NEEDED
*     fill contact structure
      read table <customer>-central_data-contact-contacts
          with key data_key-parnr = <cust_ct_link>-customer_cont
          assigning <contact>.
      if sy-subrc = 0.
        lv_existing_contact = true.
      else.
        lv_existing_contact = false.
        clear ls_contacts.

        assign ls_contacts to <contact>.
      endif.
*     call BAdI CVI_CUSTOM_MAPPER
      clear ls_errors.
      if badi_ref is not initial.
        call badi badi_ref->map_bp_to_customer_contact
          exporting
            i_partner          = <partners>
            i_relation         = ls_relation
          changing
            c_customer_contact = <contact>
            c_errors           = ls_errors.
      endif.
      clear ls_messages.
      read table     lt_count
              into     ls_count_row
              with key partner_guid = lv_partner_guid.
      loop at ls_errors-messages into ls_messages.
        ls_messages-row = ls_count_row-line.
        append ls_messages to e_errors-messages.
      endloop.
      e_errors-is_error = ls_errors-is_error.
      check e_errors-is_error = false.
      if lv_existing_contact = false and ls_contacts is not initial.
        append ls_contacts to <customer>-central_data-contact-contacts.
      endif.
    endloop.

  endloop.

endmethod.


method map_bps_to_vendors.

  data:
    lt_count           type cvis_message_row_t,
    lt_partners        like i_partners-partners,
    lt_partners_new    like i_partners-partners,
    lt_vend_link       type cvis_vend_link_t,
    lt_vend_link_new   type cvis_vend_link_t,
    lt_relations       like i_partners-relations,
    lt_vend_ct_links   type cvis_cust_ct_link_t,
    lt_vend_ct_links_p    type cvis_vend_ct_link_t,

    ls_messages        type bapiret2,
    ls_count_row       type cvis_message_row,
    ls_errors          like e_errors,
    ls_vend_link       like line of lt_vend_link,
    ls_vendors         like line of e_vendors,
    ls_bus_ei_main     type bus_ei_main,
*    ls_tbc001          type tbc001,
    ls_addresses          type line of BUS_EI_BUPA_ADDRESS_T,
    ls_partners           LIKE LINE OF i_partners-partners,
*    lv_group           type bu_group,
    lv_partner_guid    type bu_partner_guid,
    lv_is_new          type boole-boole,
    ls_person          type bus_ei_extern,
    ls_partner         type bus_ei_extern,
    ls_relation        type burs_ei_extern,
    ls_relation_tmp    type burs_ei_extern,
    ls_main_relation   type burs_ei_extern,
    ls_contacts           like line of ls_vendors-central_data-contact-contacts,
    ls_address            type bus_ei_bupa_address,
    ls_vend_ct_assignment type cvi_vend_ct_link,
    ls_vend_ct_link       type cvi_vend_ct_link,

    lv_person_number      type bu_partner,
    lv_person_guid        type bu_partner_guid,
    lv_ct_is_new          type boole-boole,
    lv_vend_is_new        type boole-boole,
    lv_existing_contact   type boole-boole,
    lv_vendor_contact     type cvi_customer_contact,
    lv_vendor_id          type lifnr,
    lv_standardaddr_guid  type sysuuid_c,
    lv_text(60)           type c,
    lv_msgtext(60)        type c,
    lcl_ka_vendor      type ref to cvi_ka_bp_vendor.

  field-symbols:
    <partners>         like line of i_partners-partners,
    <relation>         like line of i_partners-relations,
    <vend_ct_link>     like line of lt_vend_ct_links,
    <contact>          like line of ls_vendors-central_data-contact-contacts,
    <addresses>        like line of <partners>-CENTRAL_DATA-ADDRESS-ADDRESSES,
    <vendor>           like ls_vendors.


* STEP 0: prep work
  lcl_ka_vendor ?= get_ka_reference( vendor_mapping ).

* STEP 1: determine new and existing asignments and map key data for vendors
  loop at i_partners-partners assigning <partners>.

    ls_count_row-line = ls_count_row-line + 1.
    ls_count_row-partner_guid = <partners>-header-object_instance-bpartnerguid.
    append ls_count_row to lt_count.

    determine_bp_vend_assignments(
      exporting
        i_ka_object = lcl_ka_vendor
        i_partner   = <partners>
      importing
        e_vend_link = ls_vend_link
        e_new_link  = lv_is_new
        e_error     = ls_errors
    ).
    if ls_errors is not initial.
      clear ls_messages.
      loop at ls_errors-messages into ls_messages.
        ls_messages-row = ls_count_row-line.
        append ls_messages to e_errors-messages.
        e_errors-is_error = ls_errors-is_error.
      endloop.
      check e_errors-is_error = true.
      exit.
    endif.
   clear ls_partners.
   MOVE-CORRESPONDING <partners>   to ls_partners.
    if lv_is_new = true.
      append:
        <partners>   to lt_partners_new,
        ls_vend_link to lt_vend_link_new,
        ls_vend_link to lt_vend_link.
      loop at ls_partners-central_data-address-addresses into ls_addresses where task = 'U' and currently_valid <> 'X'.
        clear ls_addresses-data-postal-datax .
        modify ls_partners-central_data-address-addresses from ls_addresses.
      endloop.
    elseif ls_vend_link-vendor is not initial.
      append:
        ls_vend_link to lt_vend_link.
    endif.
    clear: lv_is_new,
           ls_vend_link,
           ls_errors,
           ls_messages,
           ls_addresses.
    append ls_partners to ls_bus_ei_main-partners.
  endloop.
* STEP 1.1: determine existing vendor contact asignments and map key data
  loop at i_partners-partners assigning <partners>.
    if <partners>-central_data-common-data-bp_control-category
            = if_cvi_common_constants~bp_as_person.
      lv_person_guid     = <partners>-header-object_instance-bpartnerguid.
      lt_vend_ct_links_p = lcl_ka_vendor->get_all_vend_cts_for_person(
                           i_person_guid = lv_person_guid ).
      if lt_vend_ct_links_p is not initial.
        "==> vendor contact assignment exists
        append lines of lt_vend_ct_links_p to lt_vend_ct_links.
        if i_partners-relations is not initial. "consider the scope of Synchronization
        loop at lt_vend_ct_links_p into ls_vend_ct_link.
          "check if business partner has been transferred to synchronization
          read table ls_bus_ei_main-partners transporting no fields
            with key header-object_instance-bpartnerguid
              = ls_vend_ct_link-partner_guid.
          if sy-subrc ne 0.
            "if not add bp to list of partners to be synchronized and to cust link table
            "this is necessary in order to avoid errors due to incomplete data
            clear ls_partners.
            ls_partners-header-object_instance-bpartnerguid = ls_vend_ct_link-partner_guid.
            ls_partners-header-object                       = 'BusinessPartner'.
            ls_partners-header-object_task                  = 'U'.
            call function 'BUPA_NUMBERS_GET'
              exporting
                iv_partner_guid = ls_vend_ct_link-partner_guid
              importing
                ev_partner      = ls_partners-header-object_instance-bpartner.
            append ls_partners to ls_bus_ei_main-partners.
            determine_bp_vend_assignments(
              exporting
                i_ka_object = lcl_ka_vendor
                i_partner   = ls_partners
              importing
                e_vend_link = ls_vend_link
                e_new_link  = lv_is_new
            ).
            if lv_is_new is not initial.
              append ls_vend_link to: lt_vend_link, lt_vend_link_new.
            elseif ls_vend_link is not initial.
              append ls_vend_link to lt_vend_link.
            endif.
            clear: ls_vend_link, lv_is_new.
          endif.
        endloop.
        endif.
      endif.
      clear: lv_person_guid, lt_vend_ct_links_p.
    endif.
  endloop.
* STEP 1.2: determine new customer contact asignments and map key data
  lt_relations = i_partners-relations.
  loop at lt_relations assigning <relation>
    where header-object_instance-relat_category = cvi_ka_bp_vendor=>rel_type_contact
      and header-object_task                    = task_insert.
    lv_partner_guid = <relation>-header-object_instance-partner1-bpartnerguid.
    "check if business partner has been transferred to synchronization
    read table ls_bus_ei_main-partners transporting no fields
      with key header-object_instance-bpartnerguid = lv_partner_guid.
    if sy-subrc ne 0.
      "if not add bp to list of partners to be synchronized and to cust_link table
      "this is necessary in order to avoid errors due to incomplete data
      clear ls_partners.
      ls_partners-header-object_instance-bpartnerguid = lv_partner_guid.
      ls_partners-header-object                       = 'BusinessPartner'.
      ls_partners-header-object_task                  = 'U'.
      call function 'BUPA_NUMBERS_GET'
        exporting
          iv_partner_guid = lv_partner_guid
        importing
          ev_partner      = ls_partners-header-object_instance-bpartner.
      append ls_partners to ls_bus_ei_main-partners.
      determine_bp_vend_assignments(
        exporting
          i_ka_object = lcl_ka_vendor
          i_partner   = ls_partners
        importing
          e_vend_link = ls_vend_link
          e_new_link  = lv_vend_is_new
      ).
      if lv_is_new is not initial.
        append ls_vend_link to: lt_vend_link, lt_vend_link_new.
      elseif ls_vend_link is not initial.
        append ls_vend_link to lt_vend_link.
      endif.
      clear: ls_vend_link, lv_is_new.
    endif.
  endloop.
  clear: lt_relations, lv_partner_guid.
  unassign <relation>.

*  clear: lt_vend_ct_links.
** if we do not go out, number range will be losted one number
  if lt_vend_link is initial and lt_vend_ct_links is initial.
    loop at i_partners-relations transporting no fields where header-object_instance-relat_category = cvi_ka_bp_vendor=>rel_type_contact.
      exit.
    endloop.
    if sy-subrc <> 0.
      return.
    endif.
  endif.
  clear: lt_vend_ct_links.

* STEP 2: fill up data for new assignments
  cl_bupa_current_data=>get_all(
    exporting
      is_business_partners = ls_bus_ei_main
    importing
      es_business_partners = ls_bus_ei_main
      es_error             = ls_errors
  ).
  if ls_errors is not initial.
    append lines of ls_errors-messages to e_errors-messages.
    e_errors-is_error = ls_errors-is_error.
    check ls_errors-is_error = false.
  endif.
  append lines of ls_bus_ei_main-partners to lt_partners.


* STEP 3: map fields for relevant partner<->vendor assignments
  loop at lt_partners assigning <partners>.
    clear:
      ls_vendors,
      ls_vend_link.
    lv_partner_guid = <partners>-header-object_instance-bpartnerguid.
    read table lt_vend_link into ls_vend_link
      with key partner_guid = lv_partner_guid.
    check sy-subrc = 0.
    ls_vendors-header-object_instance-lifnr = ls_vend_link-vendor.
    read table lt_vend_link_new into ls_vend_link
      with key partner_guid = lv_partner_guid.
    if sy-subrc = 0.
      ls_vendors-header-object_task = task_modify.
      "To support the flexible handling of account groups and numbering
      "the defaulting of the account group is not done anymore. The
      "final determination is moved to CVI_FM_BP_VENDOR in method
      "GET_ENHANCEMENT_DATA.
*      lv_group = <partners>-central_data-common-data-bp_control-grouping.
*      ls_tbc001 = lcl_ka_vendor->get_tbc001_line( lv_group ).
*      ls_vendors-central_data-central-data-ktokk = ls_tbc001-ktokk.
    else.
      ls_vendors-header-object_task              = task_update.
      clear ls_errors.
      vmd_ei_api=>get_ktokk(
        exporting
          iv_lifnr  = ls_vendors-header-object_instance-lifnr
        importing
          ev_ktokk  = ls_vendors-central_data-central-data-ktokk
          es_error  = ls_errors
      ).
      clear ls_messages.
      loop at ls_errors-messages into ls_messages.
        read table     lt_count
              into     ls_count_row
              with key partner_guid = lv_partner_guid.
        ls_messages-row = ls_count_row-line.
        append ls_messages to e_errors-messages.
        e_errors-is_error = ls_errors-is_error.
      endloop.
      e_errors-is_error = ls_errors-is_error.
      check e_errors-is_error = false.

    endif.

    fm_bp_vendor->map_bp_to_vendor(
      exporting
        i_partner  = <partners>
      importing
        e_errors   = ls_errors
      changing
        c_vendor   = ls_vendors
    ).

    clear ls_messages.
    loop at ls_errors-messages into ls_messages.
      read table     lt_count
            into     ls_count_row
            with key partner_guid = <partners>-header-object_instance-bpartnerguid.
      ls_messages-row = ls_count_row-line.
      append ls_messages to e_errors-messages.
      e_errors-is_error = ls_errors-is_error.
    endloop.
    e_errors-is_error = ls_errors-is_error.
    check e_errors-is_error = false.

*   call BAdI CVI_CUSTOM_MAPPER
    clear ls_errors.
    if badi_ref is not initial.
      call badi badi_ref->map_bp_to_vendor
        EXPORTING
          i_partner = <partners>
        CHANGING
          c_vendor  = ls_vendors
          c_errors  = ls_errors.
    endif.
    clear ls_messages.
    loop at ls_errors-messages into ls_messages.
      read table     lt_count
            into     ls_count_row
            with key partner_guid = <partners>-header-object_instance-bpartnerguid.
      ls_messages-row = ls_count_row-line.
      append ls_messages to e_errors-messages.
      e_errors-is_error = ls_errors-is_error.
    endloop.

    e_errors-is_error = ls_errors-is_error.
    check e_errors-is_error = false.

    append ls_vendors to e_vendors.

  endloop.

if CL_OPS_SWITCH_CHECK=>VENDOR_SFWS_SC2( ) eq abap_true.
* STEP 4: detect business partner relations that correspond to vendor contacts
  check is_mapping_for_contact_active( ) = true.
  lt_relations = i_partners-relations.

  clear lv_partner_guid.
  clear lv_person_guid.
  clear lv_vendor_contact.
* determine former relations of newly assigned vendors
  loop at ls_bus_ei_main-relations into ls_main_relation
        where header-object_instance-relat_category = cvi_ka_bp_vendor=>rel_type_contact.
    read table lt_partners_new with key
       header-object_instance-bpartnerguid = ls_main_relation-header-object_instance-partner1-bpartnerguid
       transporting no fields.
    if sy-subrc = 0.
    read table lt_relations with key
       header-object_instance-partner1-bpartnerguid = ls_main_relation-header-object_instance-partner1-bpartnerguid
       header-object_instance-partner2-bpartnerguid = ls_main_relation-header-object_instance-partner2-bpartnerguid
       header-object_instance-relat_category        = ls_main_relation-header-object_instance-relat_category
       transporting no fields.
    if sy-subrc <> 0.
      append ls_main_relation to lt_relations.
    endif.

    else.

     lv_partner_guid  = ls_main_relation-header-object_instance-partner1-bpartnerguid.
     lv_person_guid   = ls_main_relation-header-object_instance-partner2-bpartnerguid.

     lv_vendor_contact = lcl_ka_vendor->get_assigned_vend_ct_4_bp_rel(
      i_partner_guid  = lv_partner_guid
      i_person_guid   = lv_person_guid
    ).

    IF lv_vendor_contact IS INITIAL.
      read table lt_relations with key
       header-object_instance-partner1-bpartnerguid = ls_main_relation-header-object_instance-partner1-bpartnerguid
       header-object_instance-partner2-bpartnerguid = ls_main_relation-header-object_instance-partner2-bpartnerguid
       header-object_instance-relat_category        = ls_main_relation-header-object_instance-relat_category
       transporting no fields.
    if sy-subrc <> 0.
      append ls_main_relation to lt_relations.
    endif.
    ENDIF.

    clear lv_partner_guid.
    clear lv_person_guid.
    clear lv_vendor_contact.

    endif.

  endloop.
    loop at LT_RELATIONS ASSIGNING <relation> where header-object_task = task_update.

     lv_partner_guid  = <relation>-header-object_instance-partner1-bpartnerguid.
     lv_person_guid   = <relation>-header-object_instance-partner2-bpartnerguid.

     lv_vendor_contact = lcl_ka_vendor->get_assigned_vend_ct_4_bp_rel(
      i_partner_guid  = lv_partner_guid
      i_person_guid   = lv_person_guid
    ).

    if lv_vendor_contact is INITIAL.
      <relation>-header-object_task = 'C'.
      ENDIF.
    clear lv_partner_guid.
    clear lv_person_guid.
    clear lv_vendor_contact.

    ENDLOOP.
* loop at i_partners-relations assigning <relation>
  loop at lt_relations assigning <relation>
    where header-object_instance-relat_category = cvi_ka_bp_vendor=>rel_type_contact.

    lv_partner_guid  = <relation>-header-object_instance-partner1-bpartnerguid.
    lv_person_number = <relation>-header-object_instance-partner2-bpartner.
    lv_person_guid   = <relation>-header-object_instance-partner2-bpartnerguid.

*   get vendor number
    lv_vendor_id = lcl_ka_vendor->get_assigned_vendor_for_bp( lv_partner_guid ).
    check lv_vendor_id is not initial and sy-subrc = 0.
*   fill vendor structure if necessary
    read table e_vendors assigning <vendor>
      with key header-object_instance-lifnr = lv_vendor_id.
    if <vendor> is not assigned.
      clear ls_vendors.
      ls_vendors-header-object_instance-lifnr = lv_vendor_id.
      ls_vendors-header-object_task           = task_update.
      assign ls_vendors to <vendor>.
      lv_vend_is_new = true.
    endif.
*   check contact keymapping
      lv_vendor_contact = lcl_ka_vendor->get_assigned_vend_ct_4_bp_rel(
      i_partner_guid  = lv_partner_guid
      i_person_guid   = lv_person_guid
    ).
    if lv_vendor_contact is initial.
*     new contact: deletion will be ignored
      check <relation>-header-object_task <> task_delete.

      cvi_ei_api=>get_contact_partner_number(
       importing
         ev_parnr = lv_vendor_contact
         es_error = ls_errors
      ).

      clear ls_messages.
      read table     lt_count
              into     ls_count_row
              with key partner_guid = lv_partner_guid.
      loop at ls_errors-messages into ls_messages.
        ls_messages-row = ls_count_row-line.
        append ls_messages to e_errors-messages.
      endloop.
      e_errors-is_error = ls_errors-is_error.
      check e_errors-is_error = false.
      if lv_vendor_contact is not initial.
        lcl_ka_vendor->new_vend_ct_assignment(
          i_partner_guid         = lv_partner_guid
          i_partner_contact_guid = lv_person_guid
          i_vendor_contact_id  = lv_vendor_contact
        ).
      endif.
*     new contact: update is an error
      if <relation>-header-object_task = task_update.
        clear ls_messages.
        read table     lt_count
              into     ls_count_row
              with key partner_guid = lv_partner_guid.
        ls_messages-row        = ls_count_row-line.
        ls_messages-type       = fsbp_generic_services=>msg_error.
        ls_messages-id         = msg_class_cvi.
        ls_messages-number     = '001'.
        ls_messages-message_v1 = <relation>-header-object_task.
        ls_messages-message_v2 = text-001.
        ls_messages-message_v3 = 'header-object-task'.
        append ls_messages to e_errors-messages.
        e_errors-is_error = 'X'.
        check e_errors-is_error = false.
      endif.
      ls_contacts-task = task_insert.
      ls_contacts-data_key-parnr = lv_vendor_contact.
      append ls_contacts to <vendor>-central_data-contact-contacts.
    else.
*     existing contact: insert is an error
      if <relation>-header-object_task = task_insert.
        clear ls_messages.
        read table     lt_count
              into     ls_count_row
              with key partner_guid = lv_partner_guid.
        ls_messages-row        = ls_count_row-line.
        ls_messages-type       = fsbp_generic_services=>msg_error.
        ls_messages-id         = msg_class_cvi.
        ls_messages-number     = '001'.
        ls_messages-message_v1 = <relation>-header-object_task.
        ls_messages-message_v2 = text-001.
        ls_messages-message_v3 = 'header-object-task'.
        append ls_messages to e_errors-messages.
        e_errors-is_error = 'X'.
        check e_errors-is_error = false.
      endif.
*   fill contact structure if necessary
      read table <vendor>-central_data-contact-contacts
          with key data_key-parnr = lv_vendor_contact
          transporting no fields.
      if sy-subrc <> 0.
        ls_contacts-task = task_update.
        ls_contacts-data_key-parnr = lv_vendor_contact.
        append ls_contacts to <vendor>-central_data-contact-contacts.
      endif.
    endif.

*   assign contact structure
    read table <vendor>-central_data-contact-contacts assigning <contact>
        with key data_key-parnr = lv_vendor_contact.
*   map deletions
    if <relation>-header-object_task = task_delete.
      <contact>-task = task_delete.
      ls_vend_ct_assignment-partner_guid = <relation>-header-object_instance-partner1-bpartnerguid.
      ls_vend_ct_assignment-person_guid  = <relation>-header-object_instance-partner2-bpartnerguid.
      lcl_ka_vendor->remove_vend_ct_assignment( ls_vend_ct_assignment ).
    endif.
*   get person data: from structure
    clear ls_person.
    read table lt_partners into ls_person
        with key header-object_instance-bpartnerguid = lv_person_guid."#EC *
    if  sy-subrc <> 0 and <contact>-task = task_insert.
*     get person data: from DB
      clear ls_bus_ei_main.
      ls_person-header-object_instance-bpartnerguid = lv_person_guid.
      ls_person-header-object_instance-bpartner     = lv_person_number.
      append ls_person to ls_bus_ei_main-partners.
*     get data from DB
      clear ls_errors.
      cl_bupa_current_data=>get_all(
        exporting
          is_business_partners = ls_bus_ei_main
        importing
          es_business_partners = ls_bus_ei_main
          es_error             = ls_errors
      ).
      if ls_errors is not initial.
        clear ls_messages.
        read table     lt_count
                into     ls_count_row
                with key partner_guid = lv_person_guid.
        loop at ls_errors-messages into ls_messages.
          ls_messages-row = ls_count_row-line.
          append ls_messages to e_errors-messages.
        endloop.
        e_errors-is_error = ls_errors-is_error.
        check e_errors-is_error = false.
      endif.
      read table ls_bus_ei_main-partners into ls_person index 1.
    endif.
*   get org default address from structure if available
    read table i_partners-partners into ls_partner
        with key header-object_instance-bpartnerguid = lv_partner_guid."#EC *
    if sy-subrc = 0.
      read table ls_partner-central_data-address-addresses
           into  ls_address
           with key currently_valid = true
                    data-postal-data-standardaddress = 'X'.
      if sy-subrc = 0.
        lv_standardaddr_guid = ls_address-data_key-guid.
      else.
        clear lv_standardaddr_guid.
      endif.
    else.
      clear lv_standardaddr_guid.
      ls_partner-header-object_instance-bpartnerguid = lv_partner_guid.
    endif.
*   mapping
    clear ls_errors.
    fm_bp_vendor_contact->map_bp_rel_to_vendor_contact(
      exporting
        i_person       = ls_person
        i_relation     = <relation>
      importing
        e_errors       = ls_errors
      changing
        v_address_guid = lv_standardaddr_guid
        v_contact      = <contact>
    ).
   clear ls_messages.
    read table     lt_count
            into     ls_count_row
            with key partner_guid = lv_partner_guid.
    loop at ls_errors-messages into ls_messages.
      ls_messages-row = ls_count_row-line.
      append ls_messages to e_errors-messages.
    endloop.
    e_errors-is_error = ls_errors-is_error.
    check e_errors-is_error = false.

    assert <contact> is assigned.
*   call BAdI CVI_CUSTOM_MAPPER
    clear ls_errors.
    if badi_ref is not initial.
        call badi badi_ref->map_bp_rel_to_vendor_contact
          EXPORTING
            i_partner          = ls_partner
            i_person           = ls_person
            i_relation         = <relation>
          CHANGING
            c_errors           = ls_errors
            c_address_guid     = lv_standardaddr_guid
            c_vendor_contact = <contact>.
    endif.
    clear ls_messages.
    read table     lt_count
            into     ls_count_row
            with key partner_guid = lv_partner_guid.
    loop at ls_errors-messages into ls_messages.
      ls_messages-row = ls_count_row-line.
      append ls_messages to e_errors-messages.
    endloop.
    e_errors-is_error = ls_errors-is_error.
    check e_errors-is_error = false.

    if lv_vend_is_new = true.
      append <vendor> to e_vendors.
      clear lv_vend_is_new.
    endif.

    unassign <vendor>.

  endloop.

  loop at i_partners-partners assigning <partners>.
*   STEP 5: map fields from contact business partner to vendor contacts
    move <partners>-header-object_instance-bpartnerguid to lv_person_guid.
    lt_vend_ct_links[] = lcl_ka_vendor->get_all_vend_cts_for_person( i_person_guid = lv_person_guid ).

    loop at lt_vend_ct_links assigning <vend_ct_link>.

      clear lv_standardaddr_guid.
      lv_partner_guid = <vend_ct_link>-partner_guid.
      lv_vendor_contact = <vend_ct_link>-customer_cont.
      read table i_partners-relations with key
           header-object_instance-partner1-bpartnerguid = lv_partner_guid"#EC *
           header-object_instance-partner2-bpartnerguid = lv_person_guid"#EC *
           header-object_instance-relat_category = cvi_ka_bp_vendor=>rel_type_contact
           transporting no fields.
      if sy-subrc = 0.
*       already processed in step 4
        continue.
      else.
*       get customer number
        lv_vendor_id = lcl_ka_vendor->get_assigned_vendor_for_bp( lv_partner_guid ).
        check sy-subrc = 0.

*       fill customer structure if necessary
        read table e_vendors assigning <vendor>
          with key header-object_instance-lifnr = lv_vendor_id.
        if <vendor> is not assigned.
          clear ls_vendors.
          ls_vendors-header-object_instance-lifnr = lv_vendor_id.
          ls_vendors-header-object_task           = task_update.
          assign ls_vendors to <vendor>.
          lv_ct_is_new = true.
        endif.
*     existing contact: insert is an error
        if <partners>-header-object_task = task_insert.
          clear ls_messages.
          read table     lt_count
                into     ls_count_row
                with key partner_guid = lv_partner_guid.
          ls_messages-row        = ls_count_row-line.
          ls_messages-type       = fsbp_generic_services=>msg_error.
          ls_messages-id         = msg_class_cvi.
          ls_messages-number     = '001'.
          ls_messages-message_v1 = <partners>-header-object_task.
          ls_messages-message_v2 = text-005.
          ls_messages-message_v3 = 'header-object-task'.
          append ls_messages to e_errors-messages.
          e_errors-is_error = 'X'.
          check e_errors-is_error = false.
        endif.
*       fill contact structure if necessary
        read table <vendor>-central_data-contact-contacts
            with key data_key-parnr = lv_vendor_contact
            transporting no fields.
        if sy-subrc <> 0.
          ls_contacts-task = task_update.
          ls_contacts-data_key-parnr = lv_vendor_contact.
          append ls_contacts to <vendor>-central_data-contact-contacts.
        endif.
      endif.

*     assign contact structure
      read table <vendor>-central_data-contact-contacts assigning <contact>
          with key data_key-parnr = lv_vendor_contact.

*     fill basic relation data
      ls_relation-header-object_task = task_update.
      ls_relation-header-object_instance-partner1-bpartnerguid = lv_partner_guid.
      ls_relation-header-object_instance-partner2-bpartnerguid = lv_person_guid.
      ls_relation-header-object_instance-relat_category = cvi_ka_bp_vendor=>rel_type_contact.

      READ TABLE LS_BUS_EI_MAIN-RELATIONS into ls_relation_tmp with KEY
        HEADER-OBJECT_INSTANCE-PARTNER1-BPARTNERGUID =  lv_partner_guid
        HEADER-OBJECT_INSTANCE-PARTNER2-BPARTNERGUID =  lv_person_guid.

      IF sy-subrc EQ 0.
         MOVE-CORRESPONDING ls_relation_tmp-central_data TO ls_relation-central_data.
      ENDIF.

*     mapping
      clear ls_errors.
      fm_bp_vendor_contact->map_person_to_vendor_contact(
        exporting
          i_person       = <partners>
          i_relation     = ls_relation
        importing
          e_errors       = ls_errors
        changing
          v_address_guid = lv_standardaddr_guid
          v_contact      = <contact>
      ).

      clear ls_messages.
      read table     lt_count
              into     ls_count_row
              with key partner_guid = lv_partner_guid.
      loop at ls_errors-messages into ls_messages.
        ls_messages-row = ls_count_row-line.
        append ls_messages to e_errors-messages.
      endloop.
      e_errors-is_error = ls_errors-is_error.
      check e_errors-is_error = false.

      assert <contact> is assigned.
*     call BAdI CVI_CUSTOM_MAPPER
      clear ls_errors.
      if badi_ref is not initial.
          call badi badi_ref->map_person_to_vendor_contact
            EXPORTING
              i_person       = <partners>
              i_relation     = ls_relation
            CHANGING
              c_errors       = ls_errors
              c_address_guid = lv_standardaddr_guid
              c_contact      = <contact>.
      endif.
      clear ls_messages.
      read table     lt_count
              into     ls_count_row
              with key partner_guid = lv_partner_guid.
      loop at ls_errors-messages into ls_messages.
        ls_messages-row = ls_count_row-line.
        append ls_messages to e_errors-messages.
      endloop.
      e_errors-is_error = ls_errors-is_error.
      check e_errors-is_error = false.

      if lv_ct_is_new = true.
        append <vendor> to e_vendors.
        clear lv_ct_is_new.
      endif.

      unassign <vendor>.
    endloop.

*   STEP 6: map address changes of business partner to customer contacts
    clear lt_vend_ct_links.
    move <partners>-header-object_instance-bpartnerguid to lv_partner_guid.
    lt_vend_ct_links[] = lcl_ka_vendor->get_all_vend_cts_for_bp( i_partner_guid = lv_partner_guid ).

    loop at lt_vend_ct_links assigning <vend_ct_link>.
      clear ls_relation.
*       get existing relation data
      lv_person_guid = <vend_ct_link>-person_guid.
      read table i_partners-relations with key
           header-object_instance-partner1-bpartnerguid = lv_partner_guid"#EC *
           header-object_instance-partner2-bpartnerguid = lv_person_guid"#EC *
           header-object_instance-relat_category = cvi_ka_bp_vendor=>rel_type_contact
           into ls_relation.
      if sy-subrc = 0.
*         already processed in step 4
        continue.
      endif.

*      clear ls_bus_ei_main.
*      append ls_relation to ls_bus_ei_main-relations.
*
**     fill up data for relations
*      clear ls_errors.
*      cl_bupa_current_data=>get_all(
*        exporting
*          is_business_partners = ls_bus_ei_main
*        importing
*          es_business_partners = ls_bus_ei_main
*          es_error             = ls_errors
*      ).
*      if ls_errors is not initial.
*        append lines of ls_errors-messages to e_errors-messages.
*        e_errors-is_error = ls_errors-is_error.
*        if ls_errors-is_error = false.
*          continue.
*        endif.
*      endif.
      READ TABLE ls_bus_ei_main-relations INTO ls_relation WITH KEY
        HEADER-OBJECT_INSTANCE-PARTNER1-BPARTNERGUID =  lv_partner_guid
        HEADER-OBJECT_INSTANCE-PARTNER2-BPARTNERGUID =  lv_person_guid.

      if sy-subrc <> 0.
        continue.
      endif.

*     fill vendor structure
      lv_vendor_id = lcl_ka_vendor->get_assigned_vendor_for_bp( lv_partner_guid ).
      check sy-subrc = 0.
      read table e_vendors assigning <vendor>
        with key header-object_instance-lifnr = lv_vendor_id.
      check <vendor> is assigned.

*     get standardaddress
      read table <partners>-central_data-address-addresses into ls_address
           with key data-postal-data-standardaddress = true.
      if  sy-subrc = 0
      and ( ls_address-data-postal-datax-standardaddress = true
            or <partners>-central_data-address-current_state = true )."#EC NEEDED

*       get person data: from structure
        clear ls_person.
        read table lt_partners into ls_person
            with key header-object_instance-bpartnerguid = lv_person_guid."#EC *

        lv_standardaddr_guid = ls_address-data_key-guid.

*       fill basic contact data
        ls_contacts-task = task_update.
        ls_contacts-data_key-parnr = <vend_ct_link>-customer_cont.

*       mapping
        clear ls_errors.
        fm_bp_vendor_contact->map_bp_rel_to_vendor_contact(
          exporting
            i_person       = ls_person
            i_relation     = ls_relation
          importing
            e_errors       = ls_errors
          changing
            v_address_guid = lv_standardaddr_guid
            v_contact      = ls_contacts
        ).

        clear ls_messages.
        read table     lt_count
                into     ls_count_row
                with key partner_guid = lv_partner_guid.
        loop at ls_errors-messages into ls_messages.
          ls_messages-row = ls_count_row-line.
          append ls_messages to e_errors-messages.
        endloop.
        e_errors-is_error = ls_errors-is_error.
        check e_errors-is_error = false.

*       call BAdI CVI_CUSTOM_MAPPER
        clear ls_errors.
        if badi_ref is not initial.
            call badi badi_ref->map_bp_rel_to_vendor_contact
              EXPORTING
                i_partner          = <partners>
                i_person           = ls_person
                i_relation         = ls_relation
              CHANGING
                c_errors           = ls_errors
                c_address_guid     = lv_standardaddr_guid
                c_vendor_contact = ls_contacts.
        endif.
        clear ls_messages.
        read table     lt_count
                into     ls_count_row
                with key partner_guid = lv_partner_guid.
        loop at ls_errors-messages into ls_messages.
          ls_messages-row = ls_count_row-line.
          append ls_messages to e_errors-messages.
        endloop.
        e_errors-is_error = ls_errors-is_error.
        check e_errors-is_error = false.

*       fill contact structure
        read table <vendor>-central_data-contact-contacts
            with key data_key-parnr = <vend_ct_link>-customer_cont
            assigning <contact>.
        if sy-subrc = 0.
          <contact> = ls_contacts.
        elseif ls_contacts is not initial.
          append ls_contacts to <vendor>-central_data-contact-contacts.
        endif.
        continue.

      endif.                                                "#EC NEEDED
*     fill contact structure
      read table <vendor>-central_data-contact-contacts
          with key data_key-parnr = <vend_ct_link>-customer_cont
          assigning <contact>.
      if sy-subrc = 0.
        lv_existing_contact = true.
      else.
        lv_existing_contact = false.
        clear ls_contacts.

        assign ls_contacts to <contact>.
      endif.
*     call BAdI CVI_CUSTOM_MAPPER
      clear ls_errors.
      if badi_ref is not initial.
          call badi badi_ref->map_bp_to_vendor_contact
            EXPORTING
              i_partner          = <partners>
              i_relation         = ls_relation
            CHANGING
              c_vendor_contact = <contact>
              c_errors           = ls_errors.
      endif.
      clear ls_messages.
      read table     lt_count
              into     ls_count_row
              with key partner_guid = lv_partner_guid.
      loop at ls_errors-messages into ls_messages.
        ls_messages-row = ls_count_row-line.
        append ls_messages to e_errors-messages.
      endloop.
      e_errors-is_error = ls_errors-is_error.
      check e_errors-is_error = false.
      if lv_existing_contact = false and ls_contacts is not initial.
        append ls_contacts to <vendor>-central_data-contact-contacts.
      endif.
    endloop.

endloop.
endif.
endmethod.


method map_customers_to_bps.

  data:
    lt_count              type cvis_message_row_t,
    lt_customers          like i_customers,
    lt_partners           type bus_ei_main,
    lt_address            type bus_ei_bupa_address_t,
    ls_customers_new      type cmds_ei_main,
    ls_customers_read     type cmds_ei_main,
    lt_contact_rels       type cvis_cust_ct_rel_key_t,
    lt_cust_link          type table of cvi_cust_link,
    lt_cust_link_new      like lt_cust_link,
    lt_cvic_cust_to_bp2   type cvic_cust_to_bp2_t,


    ls_count_row          type cvis_message_row,
    ls_messages           type bapiret2,
    ls_errors             like e_errors,
    ls_cust_link          like line of lt_cust_link,
    ls_partners           like line of e_partners-partners,
    ls_partners_header    type bus_ei_header,
    ls_address            type bus_ei_bupa_address,
    ls_person             like line of e_partners-partners,
    ls_relation           like line of e_partners-relations,
    ls_roles              type bus_ei_bupa_roles,
    ls_contact_rel        like line of lt_contact_rels,
    ls_cvic_cust_to_bp1   type cvic_cust_to_bp1,
    ls_cvic_cust_to_bp2   type cvic_cust_to_bp2,
    ls_cust_ct_assignment type cvi_cust_ct_link,

    lv_account_group      type ktokd,
    lv_customer_id        type kunnr,

    lcl_ka_customer       type ref to cvi_ka_bp_customer,
    ls_customers          type cmds_ei_main,
    lv_syntype            type boolean,
    lt_roles_getdetail    TYPE TABLE OF bapibus1006_bproles,
    ls_roles_getdetail    LIKE LINE OF lt_roles_getdetail,
    lt_return             TYPE TABLE OF bapiret2,
    ls_return             TYPE bapiret2,
    lv_error_role         TYPE bu_boolean,
    ls_sales              TYPE cmds_ei_sales.

  field-symbols:
    <customers>           like line of i_customers,
    <contact>             like line of <customers>-central_data-contact-contacts.

  DATA :
    lt_bps_guid TYPE bup_partnerguid_t,
    ls_bp_guid  TYPE bup_partnerguid_s,
    lt_bps      TYPE bup_xpcpt_t,
    lv_index    TYPE i,
    lv_delete   TYPE c,
    ls_contacts TYPE cmds_ei_contacts,
    ls_company  TYPE cmds_ei_company.

  FIELD-SYMBOLS : <fs_cust_link> TYPE cvi_cust_link,
                  <fs_bp>        TYPE bup_s_xpcpt.

* STEP 0: prep work
  lcl_ka_customer ?= get_ka_reference( customer_mapping ).

* STEP 1: determine new and existing asignments and map key data for partners
  loop at i_customers assigning <customers>.

    ls_count_row-line = ls_count_row-line + 1.
    ls_count_row-customer = <customers>-header-object_instance-kunnr.
    append ls_count_row to lt_count.

    ls_cust_link-customer     = <customers>-header-object_instance-kunnr.
    ls_cust_link-partner_guid = lcl_ka_customer->get_assigned_bp_for_customer( ls_cust_link-customer ).

    if ls_cust_link-partner_guid is initial.
      if <customers>-central_data-central-data-ktokd is initial.
        clear ls_errors.
        cmd_ei_api=>get_ktokd(
          exporting
            iv_kunnr  = ls_cust_link-customer
          importing
            ev_ktokd  = lv_account_group
            es_error  = ls_errors
        ).
        clear ls_messages.

        handle_error(
          EXPORTING
            it_count     = lt_count
            is_errors    = ls_errors
            is_customers = <customers>
          CHANGING
            e_errors     = e_errors
            ).

        check e_errors-is_error = false.
      else.
        lv_account_group = <customers>-central_data-central-data-ktokd.
      endif.
      if lcl_ka_customer->is_bp_required_for_customer(
           i_customer      = <customers>-header-object_instance-kunnr
           i_account_group = lv_account_group
         ) = lcl_ka_customer->req_status_required.
        ls_cust_link-partner_guid = lcl_ka_customer->new_partner_id( ).
        lcl_ka_customer->new_assignment(
          i_partner_guid = ls_cust_link-partner_guid
          i_customer_id  = ls_cust_link-customer
        ).
        append:
          ls_cust_link to lt_cust_link_new,
          <customers> to ls_customers-customers.
      else.
        clear ls_cust_link.
        continue.
      endif.
    else.
      append:
        ls_cust_link to lt_cust_link,
        <customers> to ls_customers-customers.
    ENDIF.

  ENDLOOP.

  LOOP AT lt_cust_link ASSIGNING <fs_cust_link>.
    ls_bp_guid-partner_guid = <fs_cust_link>-partner_guid.
    APPEND ls_bp_guid TO lt_bps_guid.
  ENDLOOP.

  CALL FUNCTION 'BUPA_XPCPT_GET'
    EXPORTING
      it_partner_guid = lt_bps_guid
    IMPORTING
      et_xpcpt        = lt_bps.

  SORT lt_bps BY partner_guid.
  lv_delete = abap_false.
  LOOP AT ls_customers-customers ASSIGNING <customers>.
    lv_index = sy-tabix.
    READ TABLE  lt_cust_link ASSIGNING <fs_cust_link> WITH KEY customer = <customers>-header-object_instance-kunnr.

    CHECK sy-subrc = 0.
    READ TABLE lt_bps ASSIGNING <fs_bp> WITH KEY partner_guid = <fs_cust_link>-partner_guid BINARY SEARCH.

    CHECK <fs_bp> IS ASSIGNED.
    IF <fs_bp>-xpcpt = abap_true AND sy-subrc = 0.
      DELETE ls_customers-customers INDEX lv_index.
    ELSEIF <fs_bp>-xpcpt = abap_false AND sy-subrc = 0.
*     Customer blocking
      IF <customers>-central_data-central-data-cvp_xblck = abap_true AND <customers>-central_data-central-datax-cvp_xblck = abap_true.
        lv_delete = abap_true.
      ENDIF.

*     Company Code blocking
      LOOP AT <customers>-company_data-company INTO ls_company.
        IF ls_company-data-cvp_xblck_b = abap_true AND ls_company-datax-cvp_xblck_b = abap_true.
          lv_delete = abap_true.
        ENDIF.
      ENDLOOP.

*     Contact Person blocking
      LOOP AT <customers>-central_data-contact-contacts INTO ls_contacts.
        IF ls_contacts-data-cvp_xblck_k = abap_true AND ls_contacts-datax-cvp_xblck_k = abap_true.
          lv_delete = abap_true.
        ENDIF.
      ENDLOOP.

*     Sales Area blocking
      LOOP AT <customers>-sales_data-sales INTO ls_sales.
        IF ls_sales-data-cvp_xblck_v = abap_true AND ls_sales-datax-cvp_xblck_v = abap_true.
          lv_delete = abap_true.
        ENDIF.
      ENDLOOP.

      IF lv_delete = abap_true.
        DELETE ls_customers-customers INDEX lv_index.
        lv_delete = abap_false.
      ENDIF.
    ENDIF.
  ENDLOOP.

* STEP 2: complete data
  clear ls_errors.

*   call BAdI CVI_SYN_TYPE
    if badi_syntype_ref is not initial.
        call badi badi_syntype_ref->set_syn_type
          CHANGING
            syntype = lv_syntype.
    endif.

  IF lv_syntype IS INITIAL OR lt_cust_link_new IS NOT INITIAL.       "1723603
*   Handle return vendor candidates
    LOOP AT ls_customers-customers ASSIGNING <customers>.
      CASE <customers>-header-object_task.
        WHEN if_cvi_common_constants=>task_insert.
          READ TABLE gt_return_vendor_candidates
            WITH KEY table_line  = <customers>-header-object_instance
            TRANSPORTING NO FIELDS.
          IF sy-subrc NE 0.
            APPEND <customers>-header-object_instance TO gt_return_vendor_candidates.
          ENDIF.
        WHEN OTHERS.
          READ TABLE gt_return_vendor_candidates
            WITH KEY table_line  = <customers>-header-object_instance
            TRANSPORTING NO FIELDS.
          IF sy-subrc = 0 AND <customers>-central_data-address IS INITIAL.
            APPEND <customers> TO lt_customers.
            DELETE ls_customers-customers.
          ENDIF.
      ENDCASE.
    ENDLOOP.
*
    cmd_ei_api_extract=>get_data(
      exporting
        is_master_data = ls_customers
      importing
        es_master_data = ls_customers_read
        es_error       = ls_errors
       ).
      if ls_errors is not initial.
    append lines of ls_errors-messages to e_errors-messages.
    e_errors-is_error = ls_errors-is_error.
    check ls_errors-is_error = false.
  endif.

  append lines of ls_customers_read-customers to lt_customers.
    ELSE.
      append lines of ls_customers-customers to lt_customers.
    ENDIF.

* STEP 3: map fields for relevant partner<->customer assignments
  LOOP AT lt_customers ASSIGNING <customers>.

    lv_customer_id = <customers>-header-object_instance-kunnr.
    lv_account_group = <customers>-central_data-central-data-ktokd.

    read table lt_cust_link_new into ls_cust_link
      with key customer = lv_customer_id.
    if sy-subrc = 0.
      ls_partners-header-object_task = task_insert.
      ls_partners-header-object_instance-bpartnerguid = ls_cust_link-partner_guid.
       if <customers>-central_data-central-data-ktokd is initial.
        clear ls_errors.
        cmd_ei_api=>get_ktokd(
          exporting
            iv_kunnr  = ls_cust_link-customer
          importing
            ev_ktokd  = lv_account_group
            es_error  = ls_errors
        ).
        clear ls_messages.

        handle_error(
          EXPORTING
            it_count     = lt_count
            is_errors    = ls_errors
            is_customers = <customers>
          CHANGING
            e_errors     = e_errors
            ).

        check e_errors-is_error = false.
      else.
        lv_account_group = <customers>-central_data-central-data-ktokd.
      endif.
      if lcl_ka_customer->is_bp_with_same_number( lv_account_group ) = true.
        ls_partners-header-object_instance-bpartner = lv_customer_id.
      endif.
      ls_partners-central_data-common-data-bp_control-category = bp_as_org.

*     call BAdI CVI_MAP_TITLE
      clear ls_errors.
      if badi_ref_title is not initial.
          call badi badi_ref_title->map_customer_title_bp_create
            EXPORTING
              i_customer_id       = ls_cust_link-customer
              i_partner_guid      = ls_cust_link-partner_guid
              i_customer_title    = <customers>-central_data-address-postal-data-title
            IMPORTING
              e_partner_title_key = ls_partners-central_data-common-data-bp_centraldata-title_key
              e_errors            = ls_errors
            CHANGING
              c_partner_category  = ls_partners-central_data-common-data-bp_control-category.
      endif.
      clear ls_messages.

      handle_error(
        EXPORTING
          it_count     = lt_count
          is_errors    = ls_errors
          is_customers = <customers>
        CHANGING
          e_errors     = e_errors
          ).

      if e_errors-is_error = true.
        continue.
      endif.
      ls_cvic_cust_to_bp1 = lcl_ka_customer->get_cvic_cust_to_bp1_line( lv_account_group ).
      ls_partners-central_data-common-data-bp_control-grouping = ls_cvic_cust_to_bp1-grouping.

      lt_cvic_cust_to_bp2 = lcl_ka_customer->get_cvic_cust_to_bp2_lines( lv_account_group ).

      loop at lt_cvic_cust_to_bp2 into ls_cvic_cust_to_bp2.
        ls_roles-data_key = ls_cvic_cust_to_bp2-role.
        append ls_roles to ls_partners-central_data-role-roles.
      endloop.

    else.
      read table lt_cust_link into ls_cust_link
      with key customer = lv_customer_id.
      ls_partners-header-object_instance-bpartnerguid = ls_cust_link-partner_guid.

      ls_partners-header-object_task = task_update.
      if ( <customers>-header-object_task = task_update and <customers>-central_data-address-postal-datax-title = true )
      or ( <customers>-header-object_task = task_current_state ).
*       call BAdI CVI_MAP_TITLE
        clear ls_errors.
        if badi_ref_title is not initial.
            call badi badi_ref_title->map_customer_title_bp_change
              EXPORTING
                i_customer_id       = ls_cust_link-customer
                i_partner_guid      = ls_cust_link-partner_guid
                i_customer_title    = <customers>-central_data-address-postal-data-title
              IMPORTING
                e_partner_title_key = ls_partners-central_data-common-data-bp_centraldata-title_key
                e_errors            = ls_errors.
        endif.
        clear ls_messages.

        handle_error(
          EXPORTING
            it_count     = lt_count
            is_errors    = ls_errors
            is_customers = <customers>
          CHANGING
            e_errors     = e_errors
            ).

        if e_errors-is_error = true.
          continue.
        endif.
        ls_partners-central_data-common-datax-bp_centraldata-title_key = true.
      endif.

      if lv_account_group is INITIAL.
        cmd_ei_api=>get_ktokd(
            exporting
              iv_kunnr  = lv_customer_id
            importing
              ev_ktokd  = lv_account_group
              es_error  = ls_errors
          ).
        clear ls_errors.
      endif.
*     Adding roles to BP
      lt_cvic_cust_to_bp2 = lcl_ka_customer->get_cvic_cust_to_bp2_lines( lv_account_group ).

      CALL FUNCTION 'BUPA_ROLES_GET_2'
       EXPORTING
         IV_PARTNER_GUID       = ls_cust_link-partner_guid
         IV_DATE               = '00000000'
       TABLES
         ET_PARTNERROLES       = lt_roles_getdetail
         ET_RETURN             = lt_return.

      LOOP AT lt_return INTO ls_return WHERE type CA 'EA'.
        lv_error_role = 'X'.
      ENDLOOP.

      IF lv_error_role <> 'X'.
        LOOP AT lt_cvic_cust_to_bp2 INTO ls_cvic_cust_to_bp2.
          READ TABLE lt_roles_getdetail INTO ls_roles_getdetail WITH KEY partnerrole = ls_cvic_cust_to_bp2-role.
          IF sy-subrc <> 0.
            ls_roles-data_key = ls_cvic_cust_to_bp2-role.
            ls_roles-task = 'I'.
            APPEND ls_roles TO ls_partners-central_data-role-roles.
          ENDIF.
        ENDLOOP.
      ENDIF.
    endif.

    fm_bp_customer->map_customer_to_bp(
      exporting
        i_customer  = <customers>
      importing
        e_errors  = ls_errors
      changing
        c_partner = ls_partners
    ).

    clear ls_messages.

    handle_error(
      EXPORTING
        it_count     = lt_count
        is_errors    = ls_errors
        is_customers = <customers>
      CHANGING
        e_errors     = e_errors
        ).

    if e_errors-is_error = true.
      clear ls_partners.
      continue.
    endif.

    clear ls_errors.
*   call BAdI CVI_CUSTOM_MAPPER
    if badi_ref is not initial.
        call badi badi_ref->map_customer_to_bp
          EXPORTING
            i_customer = <customers>
          CHANGING
            c_partner  = ls_partners
            c_errors   = ls_errors.
    endif.
    clear ls_messages.

    handle_error(
      EXPORTING
        it_count     = lt_count
        is_errors    = ls_errors
        is_customers = <customers>
      CHANGING
        e_errors     = e_errors
        ).

    if e_errors-is_error = true.
      CALL METHOD LCL_KA_CUSTOMER->UNDO_ASSIGNMENT
           EXPORTING
             I_ASSIGNMENT = ls_cust_link.
         clear ls_partners.
      continue.
    endif.

* STEP 4: determine bp_relation for customer contact
    if is_mapping_for_contact_active( ) = true.

      lt_contact_rels[] = lcl_ka_customer->get_assigned_cont_rel_for_cust( i_customer = lv_customer_id
      i_persisted_only ='X').

      loop at <customers>-central_data-contact-contacts assigning <contact>.
        clear:
          ls_contact_rel,
          ls_person,
          ls_relation.
*       Handling of current_state for contact person
        if <customers>-header-object_task = task_current_state
        and <contact>-task NE task_delete.                                       "n_1518526
          <contact>-task = task_current_state.
        endif.

        read table lt_contact_rels into ls_contact_rel
          with key customer_cont = <contact>-data_key-parnr.

        if sy-subrc <> 0 and <contact>-task = task_delete.
          continue.
        endif.

        if sy-subrc <> 0.
*       new contact and new assignment
          ls_contact_rel-partner_guid  = lcl_ka_customer->get_assigned_bp_for_customer( lv_customer_id ).
          ls_contact_rel-customer_cont = <contact>-data_key-parnr.
          ls_contact_rel-person_guid   = lcl_ka_customer->new_partner_id( ).
          lcl_ka_customer->new_cust_ct_assignment(
            i_partner_guid         = ls_contact_rel-partner_guid
            i_partner_contact_guid = ls_contact_rel-person_guid
            i_customer_contact_id  = ls_contact_rel-customer_cont
          ).

          ls_person-header-object_task                           = task_insert.
          ls_person-header-object_instance-bpartnerguid          = ls_contact_rel-person_guid.
          ls_person-central_data-common-data-bp_control-category = bp_as_person.

          ls_relation-header-object_task                           = task_insert.
          ls_relation-header-object_instance-partner1-bpartnerguid = ls_contact_rel-partner_guid.
          ls_relation-header-object_instance-partner2-bpartnerguid = ls_contact_rel-person_guid.
          ls_relation-header-object_instance-relat_category        = cvi_ka_bp_customer=>rel_type_contact.

        else.
*       existing contact and existing assignment
          read table e_partners-partners into ls_person
            with key header-object_instance-bpartnerguid = ls_contact_rel-person_guid."#EC *
          if sy-subrc <> 0.
            ls_person-header-object_task                  = task_update.
            ls_person-header-object_instance-bpartnerguid = ls_contact_rel-person_guid.
          endif.

          if <contact>-task = task_delete.
            ls_relation-header-object_task                         = task_delete.
            ls_cust_ct_assignment-partner_guid                     = ls_contact_rel-partner_guid.
            ls_cust_ct_assignment-person_guid                      = ls_contact_rel-person_guid.
            lcl_ka_customer->remove_cust_ct_assignment( ls_cust_ct_assignment ).
          else.
            ls_relation-header-object_task                         = task_update.
          endif.
          ls_relation-header-object_instance-partner1-bpartnerguid = ls_contact_rel-partner_guid.
          ls_relation-header-object_instance-partner2-bpartnerguid = ls_contact_rel-person_guid.
          ls_relation-header-object_instance-relat_category        = cvi_ka_bp_customer=>rel_type_contact.

        endif.

* STEP 5: map fields of customer contact to bp_relation
        fm_bp_customer_contact->map_cust_cont_to_bp_and_rel(
          exporting
            i_customer_contact = <contact>
          importing
            e_errors           = ls_errors
          changing
            c_partner          = ls_partners
            c_person           = ls_person
            c_relation         = ls_relation
        ).
*       Handling of current_state for contact person
        if <contact>-task = task_current_state.
          clear <contact>-task.
        endif.

        clear ls_messages.

        handle_error(
          EXPORTING
            it_count     = lt_count
            is_errors    = ls_errors
            is_customers = <customers>
          CHANGING
            e_errors     = e_errors
            ).

        if e_errors-is_error = true.
          continue.
        endif.

*     call BAdI CVI_CUSTOM_MAPPER
        clear ls_errors.
        if badi_ref is not initial.
            call badi badi_ref->map_cust_cont_to_bp_and_rel
              EXPORTING
                i_customer_contact = <contact>
              CHANGING
                c_errors           = ls_errors
                c_partner          = ls_partners
                c_person           = ls_person
                c_relation         = ls_relation.
        endif.
        clear ls_messages.

        handle_error(
          EXPORTING
            it_count     = lt_count
            is_errors    = ls_errors
            is_customers = <customers>
          CHANGING
            e_errors     = e_errors
            ).

        if e_errors-is_error = true.
          continue.
        endif.
*       update person and relation
        read table e_partners-partners
          with key header-object_instance-bpartnerguid = ls_contact_rel-person_guid"#EC *
          transporting no fields.
        if sy-subrc = 0.
          modify e_partners-partners from ls_person index sy-tabix.
        else.
          append ls_person to e_partners-partners.
        endif.
        append ls_relation to e_partners-relations.

      endloop.
    endif. "map contact

    read table e_partners-partners
      with key header-object_instance-bpartnerguid = ls_partners-header-object_instance-bpartnerguid
      transporting no fields.
    if sy-subrc = 0.
      modify e_partners-partners from ls_partners index sy-tabix.
    else.
      append ls_partners to e_partners-partners.
    endif.

    clear ls_partners.

  endloop.

*Split the addresses to be deleted from other ones based on the task field

    loop at e_partners-partners into ls_partners.

      loop at ls_partners-central_data-address-addresses into ls_address.

        if ls_address-task = 'D'.

          append ls_address to lt_address.

          delete table ls_partners-central_data-address-addresses from ls_address.

        endif.

        clear ls_address.

      endloop.

      append ls_partners to lt_partners-partners.

      if lt_address is not initial.

        ls_partners_header = ls_partners-header.

        clear ls_partners.

        ls_partners-header = ls_partners_header.

        ls_partners-central_data-address-addresses = lt_address.

        append ls_partners to lt_partners-partners.

        clear lt_address.

      endif.

      clear ls_partners.

    endloop.

    clear e_partners-partners.

    e_partners-partners = lt_partners-partners.

endmethod.                    "map_customers_to_bps


method map_vendors_to_bps.

  data:
    lt_count             type cvis_message_row_t,
    lt_cvic_vend_to_bp2  type cvic_vend_to_bp2_t,
    lt_vendors           like i_vendors,
    ls_vendors_new       type vmds_ei_main,
    ls_vendors_read      type vmds_ei_main,
    lt_vend_link         type table of cvi_vend_link,
    lt_vend_link_new     like lt_vend_link,
    lt_address           type bus_ei_bupa_address_t,
    lt_contact_rels      type cvis_cust_ct_rel_key_t,
    lt_partners           type bus_ei_main,
    lt_contact_vend_rels TYPE cvis_vend_ct_rel_key_t,

    ls_count_row         type cvis_message_row,
    ls_messages          type bapiret2,
    ls_errors            like e_errors,
    ls_vend_link         like line of lt_vend_link,
    ls_partners          like line of e_partners-partners,
    ls_roles             type bus_ei_bupa_roles,
    ls_cvic_vend_to_bp1  type cvic_vend_to_bp1,
    ls_cvic_vend_to_bp2  type cvic_vend_to_bp2,
    ls_partners_header   type bus_ei_header,
    ls_address           type bus_ei_bupa_address,
    ls_person            like line of e_partners-partners,
    ls_relation          like line of e_partners-relations,
    ls_vend_ct_assignment type cvi_vend_ct_link,
    ls_contact_rel        like line of lt_contact_vend_rels,

    lv_vendor_id         type lifnr,
    lv_account_group     type ktokk,

    lcl_ka_vendor        type ref to cvi_ka_bp_vendor,
    ls_vendors           type vmds_ei_main,
    lv_syntype           type boolean,
    lt_roles_getdetail   TYPE TABLE OF bapibus1006_bproles,
    ls_roles_getdetail   LIKE LINE OF lt_roles_getdetail,
    lt_return            TYPE TABLE OF bapiret2,
    ls_return            TYPE bapiret2,
    lv_error_role         TYPE bu_boolean,
    ls_contacts           TYPE vmds_ei_contacts,
    ls_company            TYPE vmds_ei_company.

  DATA :
    lt_bps_guid TYPE bup_partnerguid_t,
    ls_bp_guid  TYPE bup_partnerguid_s,
    lt_bps      TYPE bup_xpcpt_t,
    lv_index    TYPE i,
    lv_delete   TYPE c.

  FIELD-SYMBOLS : <fs_vend_link> TYPE cvi_vend_link,
                  <fs_bp>        TYPE bup_s_xpcpt,
    <vendors>         like line of i_vendors,
    <contact>             like line of <vendors>-central_data-contact-contacts.

* STEP 0: prep work
  lcl_ka_vendor ?= get_ka_reference( vendor_mapping ).

* STEP 1: determine new and existing asignments and map key data for partners
  loop at i_vendors assigning <vendors>.

    ls_count_row-line = ls_count_row-line + 1.
    ls_count_row-vendor = <vendors>-header-object_instance-lifnr.
    append ls_count_row to lt_count.

    ls_vend_link-vendor       = <vendors>-header-object_instance-lifnr.
    ls_vend_link-partner_guid = lcl_ka_vendor->get_assigned_bp_for_vendor( ls_vend_link-vendor ).

    if ls_vend_link-partner_guid is initial.
      if <vendors>-central_data-central-data-ktokk is initial.
        clear ls_errors.
        vmd_ei_api=>get_ktokk(
          exporting
            iv_lifnr  = ls_vend_link-vendor
          importing
            ev_ktokk  = lv_account_group
            es_error  = ls_errors
        ).
        clear ls_messages.
        loop at ls_errors-messages into ls_messages.
          read table     lt_count
                into     ls_count_row
                with key vendor = <vendors>-header-object_instance-lifnr.
          ls_messages-row = ls_count_row-line.
          append ls_messages to e_errors-messages.
          e_errors-is_error = ls_errors-is_error.
        endloop.
        e_errors-is_error = ls_errors-is_error.
        check e_errors-is_error = false.
      else.
        lv_account_group = <vendors>-central_data-central-data-ktokk.
      endif.
      If LV_ACCOUNT_GROUP is INITIAL.
        CONTINUE.
      Endif.
      if lcl_ka_vendor->is_bp_required_for_vendor(
           i_vendor        = <vendors>-header-object_instance-lifnr
           i_account_group = lv_account_group
         ) = lcl_ka_vendor->req_status_required.
        ls_vend_link-partner_guid = lcl_ka_vendor->new_partner_id( ).
        lcl_ka_vendor->new_assignment(
          i_partner_guid = ls_vend_link-partner_guid
          i_vendor_id    = ls_vend_link-vendor
        ).
        append:
          <vendors> to ls_vendors-vendors,
          ls_vend_link to lt_vend_link_new.
      else.
        clear ls_vend_link.
        exit.
      endif.
    else.
      append:
        <vendors> to ls_vendors-vendors,
        ls_vend_link to lt_vend_link.
    ENDIF.

  ENDLOOP.

  LOOP AT lt_vend_link INTO ls_vend_link.
    ls_bp_guid-partner_guid = ls_vend_link-partner_guid.
    APPEND ls_bp_guid TO lt_bps_guid.
  ENDLOOP.

  CALL FUNCTION 'BUPA_XPCPT_GET'
    EXPORTING
      it_partner_guid = lt_bps_guid
    IMPORTING
      et_xpcpt        = lt_bps.

  SORT lt_bps BY partner_guid.
  lv_delete = abap_false.
  LOOP AT ls_vendors-vendors ASSIGNING <vendors>.
    lv_index = sy-tabix.
    READ TABLE  lt_vend_link ASSIGNING <fs_vend_link> WITH KEY vendor = <vendors>-header-object_instance-lifnr.

    CHECK sy-subrc = 0.
    READ TABLE lt_bps ASSIGNING <fs_bp> WITH KEY partner_guid = <fs_vend_link>-partner_guid BINARY SEARCH.

    CHECK <fs_bp> IS ASSIGNED.
    IF <fs_bp>-xpcpt = abap_true AND sy-subrc = 0.
      DELETE ls_vendors-vendors INDEX lv_index.
    ELSEIF <fs_bp>-xpcpt = abap_false AND sy-subrc = 0.
*     Vendor blocking
      IF <vendors>-central_data-central-data-cvp_xblck = abap_true AND <vendors>-central_data-central-datax-cvp_xblck = abap_true.
        lv_delete = abap_true.
      ENDIF.

*     Company Code blocking
      LOOP AT <vendors>-company_data-company INTO ls_company.
        IF ls_company-data-cvp_xblck_b = abap_true AND ls_company-datax-cvp_xblck_b = abap_true.
          lv_delete = abap_true.
        ENDIF.
      ENDLOOP.

*     Contact Person blocking
      LOOP AT <vendors>-central_data-contact-contacts INTO ls_contacts.
        IF ls_contacts-data-cvp_xblck_k = abap_true AND ls_contacts-datax-cvp_xblck_k = abap_true.
          lv_delete = abap_true.
        ENDIF.
      ENDLOOP.

      IF lv_delete = abap_true.
        DELETE ls_vendors-vendors INDEX lv_index.
        lv_delete = abap_false.
      ENDIF.
    ENDIF.
  ENDLOOP.

* STEP 2: complete data
  clear ls_errors.

*   call BAdI CVI_SYN_TYPE
    if badi_syntype_ref is not initial.
        call badi badi_syntype_ref->set_syn_type
          CHANGING
            syntype = lv_syntype.
    endif.

    IF lv_syntype IS INITIAL OR lt_vend_link_new IS NOT INITIAL.
      vmd_ei_api_extract=>get_data(
    exporting
      is_master_data = ls_vendors
    importing
      es_master_data = ls_vendors_read
      es_error       = ls_errors
     ).
  if ls_errors is not initial.
    append lines of ls_errors-messages to e_errors-messages.
    e_errors-is_error = ls_errors-is_error.
    check ls_errors-is_error = false.
  endif.

      append lines of ls_vendors_read-vendors to lt_vendors.
    ELSE.
      append lines of ls_vendors-vendors to lt_vendors.
  ENDIF.

* STEP 3: map fields for relevant partner<->vendor assignments
  LOOP AT lt_vendors ASSIGNING <vendors>.

    lv_vendor_id = <vendors>-header-object_instance-lifnr.
    lv_account_group = <vendors>-central_data-central-data-ktokk.

    read table lt_vend_link into ls_vend_link
      with key vendor = lv_vendor_id.
    ls_partners-header-object_instance-bpartnerguid = ls_vend_link-partner_guid.

    read table lt_vend_link_new into ls_vend_link
      with key vendor = <vendors>-header-object_instance-lifnr.
    if sy-subrc = 0.
      ls_partners-header-object_task = task_insert.
      ls_partners-header-object_instance-bpartnerguid = ls_vend_link-partner_guid.
      if <vendors>-central_data-central-data-ktokk is initial.
        clear ls_errors.
        vmd_ei_api=>get_ktokk(
          exporting
            iv_lifnr  = ls_vend_link-vendor
          importing
            ev_ktokk  = lv_account_group
            es_error  = ls_errors
        ).
        clear ls_messages.
        loop at ls_errors-messages into ls_messages.
          read table     lt_count
                into     ls_count_row
                with key vendor = <vendors>-header-object_instance-lifnr.
          ls_messages-row = ls_count_row-line.
          append ls_messages to e_errors-messages.
          e_errors-is_error = ls_errors-is_error.
        endloop.
        e_errors-is_error = ls_errors-is_error.
        check e_errors-is_error = false.
      else.
        lv_account_group = <vendors>-central_data-central-data-ktokk.
      endif.
      if lcl_ka_vendor->is_bp_with_same_number( lv_account_group ) = true.
        ls_partners-header-object_instance-bpartner = lv_vendor_id.
      endif.
      ls_partners-central_data-common-data-bp_control-category = bp_as_org.

*     call BAdI CVI_MAP_TITLE
      clear ls_errors.
      if badi_ref_title is not initial.
          call badi badi_ref_title->map_vendor_title_bp_create
            exporting
              i_vendor_id         = ls_vend_link-vendor
              i_partner_guid      = ls_vend_link-partner_guid
              i_vendor_title      = <vendors>-central_data-address-postal-data-title
            importing
              e_partner_title_key = ls_partners-central_data-common-data-bp_centraldata-title_key
              e_errors            = ls_errors
            changing
              c_partner_category  = ls_partners-central_data-common-data-bp_control-category.
      endif.
      clear ls_messages.
      loop at ls_errors-messages into ls_messages.
        read table     lt_count
              into     ls_count_row
              with key vendor = <vendors>-header-object_instance-lifnr.
        ls_messages-row = ls_count_row-line.
        append ls_messages to e_errors-messages.
        e_errors-is_error = ls_errors-is_error.
      endloop.
      e_errors-is_error = ls_errors-is_error.
      if e_errors-is_error = true.
        exit.
      endif.

      ls_cvic_vend_to_bp1 = lcl_ka_vendor->get_cvic_vend_to_bp1_line( lv_account_group ).
      ls_partners-central_data-common-data-bp_control-grouping = ls_cvic_vend_to_bp1-grouping.

      lt_cvic_vend_to_bp2 = lcl_ka_vendor->get_cvic_vend_to_bp2_lines( lv_account_group ).

      loop at lt_cvic_vend_to_bp2 into ls_cvic_vend_to_bp2.
        ls_roles-data_key = ls_cvic_vend_to_bp2-role.
        append ls_roles to ls_partners-central_data-role-roles.
      endloop.

    else.
      ls_partners-header-object_task = task_update.
      if <vendors>-header-object_task = task_update and <vendors>-central_data-address-postal-datax-title = true or
         <vendors>-header-object_task = task_current_state.
*       call BAdI CVI_MAP_TITLE
        clear ls_errors.
        if badi_ref_title is not initial.
            call badi badi_ref_title->map_vendor_title_bp_change
              exporting
                i_vendor_id         = ls_vend_link-vendor
                i_partner_guid      = ls_vend_link-partner_guid
                i_vendor_title      = <vendors>-central_data-address-postal-data-title
              importing
                e_partner_title_key = ls_partners-central_data-common-data-bp_centraldata-title_key
                e_errors            = ls_errors.
        endif.
        clear ls_messages.
        loop at ls_errors-messages into ls_messages.
          read table     lt_count
                into     ls_count_row
                with key vendor = <vendors>-header-object_instance-lifnr.
          ls_messages-row = ls_count_row-line.
          append ls_messages to e_errors-messages.
          e_errors-is_error = ls_errors-is_error.
        endloop.
        e_errors-is_error = ls_errors-is_error.
        if e_errors-is_error = true.
          exit.
        endif.
        ls_partners-central_data-common-datax-bp_centraldata-title_key = true.
      endif.

      if lv_account_group is INITIAL.
        cmd_ei_api=>get_ktokd(
            exporting
              iv_kunnr  = lv_vendor_id
            importing
              ev_ktokd  = lv_account_group
              es_error  = ls_errors
          ).
        clear ls_errors.
      endif.
*     Adding roles to BP
      lt_cvic_vend_to_bp2 = lcl_ka_vendor->get_cvic_vend_to_bp2_lines( lv_account_group ).

      CALL FUNCTION 'BUPA_ROLES_GET_2'
       EXPORTING
         IV_PARTNER_GUID       = ls_vend_link-partner_guid
         IV_DATE               = '00000000'
       TABLES
         ET_PARTNERROLES       = lt_roles_getdetail
         ET_RETURN             = lt_return.

      LOOP AT lt_return INTO ls_return WHERE type CA 'EA'.
        lv_error_role = 'X'.
      ENDLOOP.

      IF lv_error_role <> 'X'.
        LOOP AT lt_cvic_vend_to_bp2 INTO ls_cvic_vend_to_bp2.
          READ TABLE lt_roles_getdetail INTO ls_roles_getdetail WITH KEY partnerrole = ls_cvic_vend_to_bp2-role.
          IF sy-subrc <> 0.
            ls_roles-data_key = ls_cvic_vend_to_bp2-role.
            ls_roles-task = 'I'.
            APPEND ls_roles TO ls_partners-central_data-role-roles.
          ENDIF.
        ENDLOOP.
      ENDIF.
    endif.

    fm_bp_vendor->map_vendor_to_bp(
      exporting
        i_vendor  = <vendors>
      importing
        e_errors  = ls_errors
      changing
        c_partner = ls_partners
    ).
    clear ls_messages.
    loop at ls_errors-messages into ls_messages.
      read table     lt_count
            into     ls_count_row
            with key vendor = <vendors>-header-object_instance-lifnr.
      ls_messages-row = ls_count_row-line.
      append ls_messages to e_errors-messages.
      e_errors-is_error = ls_errors-is_error.
    endloop.
    e_errors-is_error = ls_errors-is_error.

    if e_errors-is_error = true.
      clear ls_partners.
      continue.
    endif.

    clear ls_errors.
*   call BAdI CVI_CUSTOM_MAPPER
    if badi_ref is not initial.
        call badi badi_ref->map_vendor_to_bp
          exporting
            i_vendor  = <vendors>
          changing
            c_partner = ls_partners
            c_errors  = ls_errors.
    endif.
    clear ls_messages.
    loop at ls_errors-messages into ls_messages.
      read table     lt_count
            into     ls_count_row
            with key vendor = <vendors>-header-object_instance-lifnr.
      ls_messages-row = ls_count_row-line.
      append ls_messages to e_errors-messages.
      e_errors-is_error = ls_errors-is_error.
    endloop.
    e_errors-is_error = ls_errors-is_error.
    if e_errors-is_error = true.
      clear ls_partners.
      continue.
    endif.

*    append ls_partners to e_partners-partners.
*    clear ls_partners.


  if CL_OPS_SWITCH_CHECK=>VENDOR_SFWS_SC2( ) eq abap_true.
* STEP 4: determine bp_relation for customer contact
    if is_mapping_for_contact_active( ) = true.

        lt_contact_vend_rels[] = lcl_ka_vendor->get_assigned_cont_rel_for_vend( i_vendor = lv_vendor_id i_persisted_only ='X' ).

      loop at <vendors>-central_data-contact-contacts assigning <contact>.
        clear:
          ls_contact_rel,
          ls_person,
          ls_relation.
*       Handling of current_state for contact person
          if <vendors>-header-object_task = task_current_state and <contact>-task NE task_delete.
          <contact>-task = task_current_state.
        endif.

          read table lt_contact_vend_rels into ls_contact_rel
            with key vendor_cont = <contact>-data_key-parnr.
        if sy-subrc <> 0.
*       new contact and new assignment
          ls_contact_rel-partner_guid  = lcl_ka_vendor->get_assigned_bp_for_vendor( lv_vendor_id ).
            ls_contact_rel-vendor_cont = <contact>-data_key-parnr.
          ls_contact_rel-person_guid   = lcl_ka_vendor->new_partner_id( ).
          lcl_ka_vendor->new_vend_ct_assignment(
            i_partner_guid         = ls_contact_rel-partner_guid
            i_partner_contact_guid = ls_contact_rel-person_guid
              i_vendor_contact_id  = ls_contact_rel-vendor_cont
          ).

          ls_person-header-object_task                           = task_insert.
          ls_person-header-object_instance-bpartnerguid          = ls_contact_rel-person_guid.
          ls_person-central_data-common-data-bp_control-category = bp_as_person.

          ls_relation-header-object_task                           = task_insert.
          ls_relation-header-object_instance-partner1-bpartnerguid = ls_contact_rel-partner_guid.
          ls_relation-header-object_instance-partner2-bpartnerguid = ls_contact_rel-person_guid.
          ls_relation-header-object_instance-relat_category        = cvi_ka_bp_vendor=>rel_type_contact.
        else.
*       existing contact and existing assignment
          read table e_partners-partners into ls_person
            with key header-object_instance-bpartnerguid = ls_contact_rel-person_guid."#EC *
          if sy-subrc <> 0.
            ls_person-header-object_task                  = task_update.
            ls_person-header-object_instance-bpartnerguid = ls_contact_rel-person_guid.
          endif.

          if <contact>-task = task_delete.
            ls_relation-header-object_task                         = task_delete.
            ls_vend_ct_assignment-partner_guid                     = ls_contact_rel-partner_guid.
            ls_vend_ct_assignment-person_guid                      = ls_contact_rel-person_guid.
            lcl_ka_vendor->remove_vend_ct_assignment( ls_vend_ct_assignment ).
          else.
            ls_relation-header-object_task                         = task_update.
          endif.
          ls_relation-header-object_instance-partner1-bpartnerguid = ls_contact_rel-partner_guid.
          ls_relation-header-object_instance-partner2-bpartnerguid = ls_contact_rel-person_guid.
          ls_relation-header-object_instance-relat_category        = cvi_ka_bp_vendor=>rel_type_contact.

        endif.

* STEP 5: map fields of vendor contact to bp_relation
        fm_bp_vendor_contact->map_vend_cont_to_bp_and_rel(
          exporting
            i_vendor_contact = <contact>
          importing
            e_errors           = ls_errors
          changing
            c_partner          = ls_partners
            c_person           = ls_person
            c_relation         = ls_relation
        ).
*       Handling of current_state for contact person
        if <contact>-task = task_current_state.
          clear <contact>-task.
        endif.

        clear ls_messages.

   loop at ls_errors-messages into ls_messages.
      read table     lt_count
            into     ls_count_row
            with key vendor = <vendors>-header-object_instance-lifnr.
      ls_messages-row = ls_count_row-line.
      append ls_messages to e_errors-messages.
      e_errors-is_error = ls_errors-is_error.
    endloop.
    e_errors-is_error = ls_errors-is_error.
    if e_errors-is_error = true.
    continue.
    endif.

**     call BAdI CVI_CUSTOM_MAPPER
        clear ls_errors.
        if badi_ref is not initial.
            call badi badi_ref->map_vend_cont_to_bp_and_rel
              EXPORTING
                i_vendor_contact = <contact>
              CHANGING
                c_errors           = ls_errors
                c_partner          = ls_partners
                c_person           = ls_person
                c_relation         = ls_relation.
        endif.
        clear ls_messages.

   loop at ls_errors-messages into ls_messages.
      read table     lt_count
            into     ls_count_row
            with key vendor = <vendors>-header-object_instance-lifnr.
      ls_messages-row = ls_count_row-line.
      append ls_messages to e_errors-messages.
      e_errors-is_error = ls_errors-is_error.
    endloop.
    e_errors-is_error = ls_errors-is_error.
    if e_errors-is_error = true.
    continue.
    endif.

        if e_errors-is_error = true.
          continue.
        endif.
*       update person and relation
        read table e_partners-partners
          with key header-object_instance-bpartnerguid = ls_contact_rel-person_guid"#EC *
          transporting no fields.
        if sy-subrc = 0.
          modify e_partners-partners from ls_person index sy-tabix.
        else.
          append ls_person to e_partners-partners.
        endif.
        append ls_relation to e_partners-relations.

      endloop.
    endif. "map contact

    read table e_partners-partners
      with key header-object_instance-bpartnerguid = ls_partners-header-object_instance-bpartnerguid
      transporting no fields.
    if sy-subrc = 0.
      modify e_partners-partners from ls_partners index sy-tabix.
    else.
      append ls_partners to e_partners-partners.
    endif.

    clear ls_partners.
else.

  read table e_partners-partners
      with key header-object_instance-bpartnerguid = ls_partners-header-object_instance-bpartnerguid
      transporting no fields.
    if sy-subrc = 0.
      modify e_partners-partners from ls_partners index sy-tabix.
    else.
      append ls_partners to e_partners-partners.
    endif.

    clear ls_partners.

   endif.
  endloop.
if CL_OPS_SWITCH_CHECK=>VENDOR_SFWS_SC2( ) eq abap_true.
*Split the addresses to be deleted from other ones based on the task field

    loop at e_partners-partners into ls_partners.

      loop at ls_partners-central_data-address-addresses into ls_address.

        if ls_address-task = 'D'.

          append ls_address to lt_address.

          delete table ls_partners-central_data-address-addresses from ls_address.

        endif.

        clear ls_address.

      endloop.

      append ls_partners to lt_partners-partners.

      if lt_address is not initial.

        ls_partners_header = ls_partners-header.

        clear ls_partners.

        ls_partners-header = ls_partners_header.

        ls_partners-central_data-address-addresses = lt_address.

        append ls_partners to lt_partners-partners.

        clear lt_address.

      endif.

      clear ls_partners.

    endloop.

    clear e_partners-partners.

    e_partners-partners = lt_partners-partners.
endif.
endmethod.


method undo_assignments.

  data:
    lt_cust_link     type table of cvi_cust_link,
    lt_cust_link2    type table of cvi_cust_link,
    lt_cust_ct       type table of cvi_cust_ct_link,
    lt_vend_ct       type table of cvi_vend_ct_link,
    lt_vend_link     type table of cvi_vend_link,
    lt_vend_link2    type table of cvi_vend_link,
    lv_variable1     type symsgv,
    lv_variable2     type symsgv,
    lcl_ka_cust      type ref to cvi_ka_bp_customer,
    lcl_ka_vend      type ref to cvi_ka_bp_vendor.
  field-symbols:
    <cust_link>        like line of lt_cust_link,
    <cust_ct_link>     like line of lt_cust_ct,
    <vend_link>        like line of lt_vend_link,
    <vend_ct_link>     like line of lt_vend_ct.

* anything to do?
  check i_for_partners[]  is not initial or
        i_for_customers[] is not initial or
        i_for_vendors[] is not initial.

* collect bp-customer assignments
  lt_cust_link[]  = get_assigned_customers_for_bps( i_partner_guids = i_for_partners[] ).
  lt_cust_link2[] = get_assigned_bps_for_customers( i_for_customers[] ).

  append lines of lt_cust_link2 to lt_cust_link.
  sort lt_cust_link.
  delete adjacent duplicates from lt_cust_link.

  lcl_ka_cust ?= get_ka_reference( i_ka_object_name = customer_mapping ).
  loop at lt_cust_link assigning <cust_link>.
    lcl_ka_cust->undo_assignment( <cust_link> ).
    lcl_ka_cust->get_ct_assignments_all(
      exporting
        i_partner_guid        = <cust_link>-partner_guid
      importing
        e_cust_ct_assignments = lt_cust_ct
    ).
    if lt_cust_ct is not initial.
      loop at lt_cust_ct assigning <cust_ct_link>.
        lcl_ka_cust->undo_cust_ct_assignment( <cust_ct_link> ).
      endloop.
      clear lt_cust_ct.
    endif.
  endloop.

  if sy-subrc <> 0.
    lv_variable1 = text-002.
    lv_variable2 = text-003.
    fsbp_generic_services=>new_message(
        i_class_id  = msg_class_cvi
        i_type      = fsbp_generic_services=>msg_warning
        i_number    = '017'
        i_variable1 = lv_variable1
        i_variable2 = lv_variable2
    ).
  endif.

* collect bp-vendor assignments
  lt_vend_link[]  = get_assigned_vendors_for_bps( i_partner_guids = i_for_partners[] ).
  lt_vend_link2[] = get_assigned_bps_for_vendors( i_for_vendors[] ).

  append lines of lt_vend_link2 to lt_vend_link.
  sort lt_vend_link.
  delete adjacent duplicates from lt_vend_link.

  lcl_ka_vend ?= get_ka_reference( i_ka_object_name = vendor_mapping ).
  loop at lt_vend_link assigning <vend_link>.
    lcl_ka_vend->undo_assignment( <vend_link> ).
    lcl_ka_vend->get_ct_assignments_all(
      exporting
        i_partner_guid        = <vend_link>-partner_guid
      importing
        e_vend_ct_assignments = lt_vend_ct
    ).
    if lt_vend_ct is not initial.
      loop at lt_vend_ct assigning <vend_ct_link>.
        lcl_ka_vend->undo_vend_ct_assignment( <vend_ct_link> ).
      endloop.
      clear lt_vend_ct.
    endif.
  endloop.
  if sy-subrc <> 0.
    lv_variable1 = text-002.
    lv_variable2 = text-004.
    fsbp_generic_services=>new_message(
        i_class_id  = msg_class_cvi
        i_type      = fsbp_generic_services=>msg_warning
        i_number    = '017'
        i_variable1 = lv_variable1
        i_variable2 = lv_variable2
    ).
  endif.
endmethod.
ENDCLASS.
