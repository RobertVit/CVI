class CVI_KA_BP_CUSTOMER definition
  public
  inheriting from AC_CVI_KEY_ASSIGNMENT
  final
  create private .

*"* public components of class CVI_KA_BP_CUSTOMER
*"* do not include other source files here!!!
public section.

  interfaces IF_CVI_COMMON_CONSTANTS .

  constants REL_TYPE_CONTACT type BU_RELTYP value 'BUR001' ##NO_TEXT.

  class-methods FACTORY
    returning
      value(RR_IF_UKM_EASY) type ref to IF_UKM_EASY .
  class-methods GET_INSTANCE
    returning
      value(R_INSTANCE) type ref to CVI_KA_BP_CUSTOMER .
  methods CHECK_ID_FOR_NEW_CUSTOMER
    importing
      !I_PARTNER_ID type BU_PARTNER
      !I_GROUP type BU_GROUP optional
      !I_CUSTOMER_ID type KUNNR
    returning
      value(R_ERROR) type CVIS_ERROR .
  methods DOES_CUSTOMER_EXIST
    importing
      !I_CUSTOMER_ID type KUNNR
    returning
      value(R_RESULT) type BOOLE-BOOLE .
  methods GET_ALL_CUST_CTS_FOR_BP
    importing
      !I_PARTNER_ID type BU_PARTNER optional
      !I_PARTNER_GUID type BU_PARTNER_GUID optional
    returning
      value(R_CUSTOMER_CONTACTS) type CVIS_CUST_CT_LINK_T .
  methods GET_ALL_CUST_CTS_FOR_PERSON
    importing
      !I_PERSON_ID type BU_PARTNER optional
      !I_PERSON_GUID type BU_PARTNER_GUID optional
    returning
      value(R_CUSTOMER_CONTACTS) type CVIS_CUST_CT_LINK_T .
  methods GET_ASSIGNED_BP_FOR_CUSTOMER
    importing
      !I_CUSTOMER type KUNNR
      !I_PERSISTED_ONLY type BOOLE-BOOLE optional
    returning
      value(R_PARTNER) type BU_PARTNER_GUID .
  methods GET_ASSIGNED_CONT_REL_FOR_CUST
    importing
      !I_CUSTOMER type KUNNR
      !I_PERSISTED_ONLY type BOOLE-BOOLE optional
    returning
      value(R_CONTACT_RELATIONS) type CVIS_CUST_CT_REL_KEY_T .
  methods GET_ASSIGNED_CUSTOMER_FOR_BP
    importing
      !I_PARTNER type BU_PARTNER_GUID
      !I_PERSISTED_ONLY type BOOLE-BOOLE optional
    returning
      value(R_CUSTOMER) type KUNNR .
  methods GET_ASSIGNED_CUST_CT_4_BP_REL
    importing
      !I_PARTNER_GUID type BU_PARTNER_GUID
      !I_PERSON_GUID type BU_PARTNER_GUID
      !I_PERSISTED_ONLY type BOOLE-BOOLE optional
    returning
      value(R_CUSTOMER_CONTACT) type CVI_CUSTOMER_CONTACT .
  methods GET_BP_4_CUSTOMER_ASSIGNMENT
    importing
      !I_CUSTOMER type KUNNR
      !I_PERSISTED_ONLY type BOOLE-BOOLE optional
    returning
      value(R_ASSIGNMENT) type CVI_CUST_LINK .
  methods GET_CT_ASSIGNMENTS_ALL
    importing
      !I_PARTNER_GUID type BU_PARTNER_GUID
      !I_PERSON_GUID type BU_PARTNER_GUID optional
    exporting
      !E_CUST_CT_ASSIGNMENTS type CVIS_CUST_CT_LINK_T .
  methods GET_CUSTOMER_4_BP_ASSIGNMENT
    importing
      !I_PARTNER type BU_PARTNER_GUID
      !I_PERSISTED_ONLY type BOOLE-BOOLE optional
    returning
      value(R_ASSIGNMENT) type CVI_CUST_LINK .
  methods GET_CVIC_CUST_TO_BP1
    returning
      value(R_CVIC_CUST_TO_BP1) type CVIS_CUST_TO_BP1_T .
  methods GET_CVIC_CUST_TO_BP1_LINE
    importing
      !I_ACCOUNT_GROUP type KTOKD
    returning
      value(R_CVIC_CUST_TO_BP1) type CVIC_CUST_TO_BP1 .
  methods GET_CVIC_CUST_TO_BP2
    returning
      value(R_CVIC_CUST_TO_BP2) type CVIS_CUST_TO_BP2_T .
  methods GET_CVIC_CUST_TO_BP2_LINES
    importing
      !I_ACCOUNT_GROUP type KTOKD
    returning
      value(R_CVIC_CUST_TO_BP2) type CVIC_CUST_TO_BP2_T .
  methods GET_T077D
    returning
      value(R_T077D) type CVIS_T077D_T .
  methods GET_T077D_LINE
    importing
      !I_ACCOUNT_GROUP type KTOKD
    returning
      value(R_T077D) type T077D .
  methods GET_TBD001
    returning
      value(R_TBD001) type CVIS_TBD001_T .
  methods GET_TBD001_LINE
    importing
      !I_GROUP type BU_GROUP
    returning
      value(R_TBD001) type TBD001 .
  methods GET_TBD002
    importing
      !I_ROLE_CATEGORIES type CVIS_ROLE_CATEGORY_T optional
    returning
      value(R_TBD002) type CVIS_TBD002_T .
  methods IS_BP_REQUIRED_FOR_CUSTOMER
    importing
      !I_CUSTOMER type KUNNR
      !I_ACCOUNT_GROUP type KTOKD
    returning
      value(R_REQ_STATUS) type CVI_REQ_STATUS .
  methods IS_BP_WITH_SAME_NUMBER
    importing
      !I_ACCOUNT_GROUP type KTOKD
    returning
      value(R_IS_SAME_NUMBER) type BOOLE-BOOLE .
  methods IS_CONSUMER_ACCOUNT_GROUP
    importing
      !I_ACCOUNT_GROUP type KTOKD
    returning
      value(R_IS_CONSUMER_ACCOUNT) type BOOLE-BOOLE .
  methods IS_CUSTOMER_ID_EXTERNAL
    importing
      !I_GROUPING type BU_GROUP
    returning
      value(R_RESULT) type BOOLE-BOOLE .
  methods IS_CUSTOMER_REQUIRED_FOR_BP
    importing
      !I_PARTNER_ID type BU_PARTNER optional
      !I_PARTNER_GUID type BU_PARTNER_GUID optional
      !I_ROLE_CATEGORIES type CVIS_ROLE_CATEGORY_T
    returning
      value(R_REQ_STATUS) type CVI_REQ_STATUS .
  methods IS_CUSTOMER_RETAIL_SITE
    importing
      !I_CUSTOMER type KUNNR
    returning
      value(R_IS_RETAIL_SITE) type BOOLE-BOOLE .
  methods IS_CUSTOMER_WITH_SAME_NUMBER
    importing
      !I_GROUPING type BU_GROUP
    returning
      value(R_RESULT) type BOOLE-BOOLE .
  methods NEW_ASSIGNMENT
    importing
      !I_PARTNER_GUID type BU_PARTNER_GUID
      !I_CUSTOMER_ID type KUNNR .
  methods NEW_CUSTOMER_CONTACT_ID
    returning
      value(R_CUSTOMER_CONTACT_ID) type PARNR .
  methods NEW_CUSTOMER_ID
    importing
      !I_PARTNER_ID type BU_PARTNER
      !I_GROUP type BU_GROUP
      !I_ROLE_CATEGORIES type CVIS_ROLE_CATEGORY_T
      !I_FLEXIBLE_GROUP type KTOKD optional
    exporting
      !E_CUSTOMER_ID type KUNNR
      !E_ERROR type CVIS_ERROR .
  methods NEW_CUST_CT_ASSIGNMENT
    importing
      !I_PARTNER_GUID type BU_PARTNER_GUID
      !I_PARTNER_CONTACT_GUID type BU_PARTNER_GUID
      !I_CUSTOMER_CONTACT_ID type PARNR .
  methods REMOVE_CUST_CT_ASSIGNMENT
    importing
      !I_CUST_CT_ASSIGNMENT type CVI_CUST_CT_LINK .
  methods UNDO_ASSIGNMENT
    importing
      !I_ASSIGNMENT type CVI_CUST_LINK
    returning
      value(R_UNASSIGNED) type BOOLE-BOOLE .
  methods UNDO_CUST_CT_ASSIGNMENT
    importing
      !I_ASSIGNMENT type CVI_CUST_CT_LINK
    returning
      value(R_UNASSIGNED) type BOOLE-BOOLE .
  methods UNREMOVE_CUST_CT_ASSIGNMENT
    importing
      !I_ASSIGNMENT type CVI_CUST_CT_LINK
    returning
      value(R_UNREMOVED) type BOOLE-BOOLE .
  methods IS_BP_IN_CUSTOMER_ROLE
    importing
      !I_PARTNER_ID type BU_PARTNER optional
      !I_PARTNER_GUID type BU_PARTNER_GUID optional
      !I_ROLE_CATEGORIES type CVIS_ROLE_CATEGORY_T
    returning
      value(R_REQ_STATUS) type CVI_REQ_STATUS .
  methods REFRESH_CT_ASSIGNMENTS .

  methods FLUSH_ASSIGNMENTS
    redefinition .
  methods IF_UKM_EASY~ADD
    redefinition .
  methods IF_UKM_EASY~DELETE
    redefinition .
  methods IF_UKM_EASY~GET
    redefinition .
protected section.
*"* protected components of class CVI_KA_BP_CUSTOMER
*"* do not include other source files here!!!
private section.
*"* private components of class CVI_KA_BP_CUSTOMER
*"* do not include other source files here!!!

  aliases MSG_CLASS_CVI
    for IF_CVI_COMMON_CONSTANTS~MSG_CLASS_CVI .

  class-data INSTANCE type ref to CVI_KA_BP_CUSTOMER .
  data:
    assignments_all type sorted table of cvi_cust_link
                              with non-unique key partner_guid
                            with non-unique sorted key customer
                              components customer .
  data ASSIGNMENTS_NEW type CVIS_CUST_LINK_T .
  data CT_ASSIGNMENTS_ALL type CVIS_CUST_CT_LINK_T .
  data CT_ASSIGNMENTS_DEL type CVIS_CUST_CT_LINK_T .
  data CT_ASSIGNMENTS_NEW type CVIS_CUST_CT_LINK_T .

  methods CHECK_EXISTENCE_METHOD
    importing
      !IV_CLASS_NAME type SEOCLSNAME
      !IV_METHOD_NAME type SEOCMPNAME
    returning
      value(RV_EXISTS) type ABAP_BOOL .
  methods CHECK_CUSTOMER_ID_AVAILABLE
    importing
      !I_CUSTOMER_ID type KUNNR
    returning
      value(R_ERRORS) type CVIS_ERROR .
  methods CHECK_CUSTOMER_ID_CORRECT
    importing
      !I_CUSTOMER_ID type KUNNR
      !I_ACCOUNT_GROUP type KTOKD
    returning
      value(R_ERRORS) type CVIS_ERROR .
  methods GET_EXTERNAL_CUSTOMER_ID
    importing
      !I_PARTNER_ID type BU_PARTNER
    returning
      value(R_CUSTOMER_ID) type KUNNR .
  methods GET_NEW_CUSTOMER_ID
    importing
      !I_ACCOUNT_GROUP type KTOKD
    exporting
      !E_CUSTOMER_ID type KUNNR
      !E_ERROR type CVIS_ERROR .
ENDCLASS.



CLASS CVI_KA_BP_CUSTOMER IMPLEMENTATION.


method check_customer_id_available.

  data:
    lv_customer      type kunnr,
    ls_cvi_cust_link type cvi_cust_link.
  field-symbols:
    <message>   type bapiret2.

  read table assignments_all into ls_cvi_cust_link
    with key customer components customer = i_customer_id.
  "assignments_all contains also not found entries (non-found buffer)
  "==> only process error if partner and customer both filled
  if sy-subrc = 0 and ls_cvi_cust_link-partner_guid is not initial.
    r_errors-is_error = true.
  endif.

  select single kunnr from kna1 into lv_customer
    where kunnr = i_customer_id.

  check sy-subrc = 0.
  r_errors-is_error = true.
  append initial line to r_errors-messages assigning <message>.
  <message>-type        = 'E'.
  <message>-id          = 'CVI_MAPPING'.
  <message>-number      = '042'.
  <message>-message_v1  = i_customer_id.
  <message>-field       = 'KUNNR'.

endmethod.


method check_customer_id_correct.

  data:
    ls_t077d  type t077d,
    ls_nriv   type nriv.
  field-symbols:
    <message> type bapiret2.

  CHECK i_customer_id IS NOT INITIAL AND i_customer_id(2) <> '##'.
  ls_t077d = get_t077d_line( i_account_group ).
  ls_nriv  = get_nriv_line(
    i_object_type  = nrobj_customer
    i_number_range = ls_t077d-numkr
  ).

  if i_customer_id < ls_nriv-fromnumber or
     i_customer_id > ls_nriv-tonumber.
    r_errors-is_error = true.
    append initial line to r_errors-messages assigning <message>.
    <message>-type        = 'E'.
    <message>-id          = 'CVI_MAPPING'.
    <message>-number      = '044'.
    <message>-message_v1  = ls_nriv-fromnumber.
    <message>-message_v2  = ls_nriv-tonumber.
    <message>-field       = 'KUNNR'.
  endif.

endmethod.


METHOD CHECK_EXISTENCE_METHOD.

  DATA: l_cmpkey TYPE seocmpkey.

  l_cmpkey-clsname = iv_class_name.
  l_cmpkey-cmpname = iv_method_name.

  CALL FUNCTION 'SEO_METHOD_EXISTENCE_CHECK'
    EXPORTING
      mtdkey            = l_cmpkey
    EXCEPTIONS
      clif_not_existing = 1
      not_specified     = 2
      not_existing      = 3
      is_event          = 4
      is_type           = 5
      is_attribute      = 6
      no_text           = 7
      inconsistent      = 8
      OTHERS            = 9.

  IF sy-subrc <> 0.
    rv_exists = abap_false.
  ELSE.
    rv_exists = abap_true.
  ENDIF.


ENDMETHOD.


method check_id_for_new_customer.

  data:
    ls_message  like line of r_error-messages,
    ls_error    like r_error,
    ls_tbd001   type tbd001,
    ls_t077d    type t077d,
    ls_nriv     type nriv,
    lv_group    type bu_group,
    lv_flexible type xfeld.

  field-symbols:
    <lv_flexible> type any.

  check i_customer_id is not initial and i_customer_id(2) <> '##'.

  assert i_partner_id is not initial.

  lv_group = i_group.
  if i_group is not supplied.
    call function 'BUPA_CENTRAL_GET_DETAIL'
      exporting
        iv_partner = i_partner_id
      importing
        ev_group   = lv_group.
  endif.

  ls_tbd001 = get_tbd001_line( lv_group ).
  ls_t077d  = get_t077d_line( ls_tbd001-ktokd ).
  ls_nriv   = get_nriv_line(
    i_object_type  = nrobj_customer
    i_number_range = ls_t077d-numkr
  ).

  assign component 'XFLEXIBLE' of structure ls_tbd001 to <lv_flexible>.
  if sy-subrc eq 0.
    lv_flexible = <lv_flexible>.
  endif.

  if lv_flexible = true.

    "flexible account grouping and numbering
    "take over the values as given
    r_error = check_customer_id_available( i_customer_id ).
    check r_error-is_error = false.

  elseif ls_tbd001-xsamenumber = true.

    "same numbers, BP ID is going to be mapped to customer ID
    if i_partner_id <> i_customer_id.
      ls_message = fsbp_generic_services=>new_message(
        i_class_id  = msg_class_cvi
        i_type      = fsbp_generic_services=>msg_error
        i_number    = '011'
      ).
      r_error-is_error = true.
      append ls_message to r_error-messages.
    else.
      ls_message = fsbp_generic_services=>new_message(
        i_class_id  = msg_class_cvi
        i_type      = fsbp_generic_services=>msg_info
        i_number    = '012'
      ).
      append ls_message to r_error-messages.
    endif.
    check r_error-is_error = false.

    r_error = check_customer_id_available( i_partner_id ).
    check r_error-is_error = false.

    ls_error = check_customer_id_correct(
      i_customer_id   = i_partner_id
      i_account_group = ls_tbd001-ktokd
    ).
    append lines of ls_error-messages to r_error-messages.
    r_error-is_error = ls_error-is_error.

    check r_error-is_error = false.

  elseif ls_nriv-externind = true.

    "external number assignment, get externally given id
    r_error = check_customer_id_available( i_customer_id ).
    check r_error-is_error = false.

    ls_error = check_customer_id_correct(
      i_customer_id   = i_customer_id
      i_account_group = ls_tbd001-ktokd
    ).
    append lines of ls_error-messages to r_error-messages.
    r_error-is_error = ls_error-is_error.

    check r_error-is_error = false.

  else.

    "internal number assignment
    ls_message = fsbp_generic_services=>new_message(
      i_class_id  = msg_class_cvi
      i_type      = fsbp_generic_services=>msg_error
      i_number    = '013'
    ).
    r_error-is_error = true.
    append ls_message to r_error-messages.

    check r_error-is_error = false.

  endif.

endmethod.


method does_customer_exist.

  data:
    lv_customer_id  like i_customer_id.

  select single kunnr from kna1 into lv_customer_id
    where kunnr = i_customer_id.

  check lv_customer_id is not initial.
  r_result = true.

endmethod.


method FACTORY.

  rr_if_ukm_easy ?= get_instance( ).

endmethod.


method flush_assignments.
  DATA : lt_assignments_del TYPE LINE OF cvis_cust_ct_link_t.
  call function 'CVI_FLUSH_BP_CUST_ASSIGNMENTS' in update task
    exporting
      it_assignments_new    = assignments_new
      it_ct_assignments_new = ct_assignments_new
      it_ct_assignments_del = ct_assignments_del.

** In INIT_EVENT the data is refreshed accordingly in Commit event %after_commit
** no refresh here.
*
*  LOOP at ct_assignments_del INTO lt_assignments_del.
*    DELETE ct_assignments_all WHERE partner_guid = lt_assignments_del-partner_guid AND
*                                    person_guid  = lt_assignments_del-person_guid.
*  ENDLOOP.
*
*  refresh: assignments_new, ct_assignments_new, ct_assignments_del.

endmethod.


method get_all_cust_cts_for_bp.

  data:
    lv_partner_guid like i_partner_guid.

  assert i_partner_guid is not initial or i_partner_id is not initial.

  if i_partner_guid is initial.
    lv_partner_guid = get_partner_guid( i_partner_id ).
  else.
    lv_partner_guid = i_partner_guid.
  endif.

  select * from cvi_cust_ct_link into table r_customer_contacts
    where partner_guid = lv_partner_guid.

endmethod.


method get_all_cust_cts_for_person.

  data:
    lv_person_guid like i_person_guid.

  assert i_person_guid is not initial or i_person_id is not initial.

  if i_person_guid is initial.
    lv_person_guid = get_partner_guid( i_person_id ).
  else.
    lv_person_guid = i_person_guid.
  endif.

  select * from cvi_cust_ct_link into table r_customer_contacts
    where person_guid = lv_person_guid.

endmethod.


method get_assigned_bp_for_customer.

  data:
    ls_assignment type cvi_cust_link.

  ls_assignment = get_bp_4_customer_assignment(
    i_customer       = i_customer
    i_persisted_only = i_persisted_only
  ).
  r_partner = ls_assignment-partner_guid.

endmethod.


method get_assigned_cont_rel_for_cust.

  data:
    lt_knvk  type table of knvk.

  check i_customer is not initial.

  call function 'KNVK_READ_CUSTOMER'
    exporting
      i_kunnr            = i_customer
      i_bypassing_buffer = i_persisted_only
    tables
      o_knvk             = lt_knvk
    exceptions
      others             = 1.

  check sy-subrc = 0.

  select partner_guid person_guid customer_cont from cvi_cust_ct_link
    into corresponding fields of table r_contact_relations
    for all entries in lt_knvk
    where customer_cont = lt_knvk-parnr.

endmethod.


method get_assigned_customer_for_bp.

  data:
    ls_assignment type cvi_cust_link.

  ls_assignment = get_customer_4_bp_assignment(
    i_partner        = i_partner
    i_persisted_only = i_persisted_only
  ).
  r_customer = ls_assignment-customer.

endmethod.


method get_assigned_cust_ct_4_bp_rel.

  data:
    ls_ct_assignment like line of ct_assignments_all.

  assert:
    i_partner_guid is not initial,
    i_person_guid  is not initial.

  if i_persisted_only is initial.
    read table ct_assignments_all into ls_ct_assignment
      with key partner_guid = i_partner_guid
               person_guid  = i_person_guid.
    if sy-subrc = 0.
      r_customer_contact = ls_ct_assignment-customer_cont.
      return.
    endif.
  endif.

  select single customer_cont from cvi_cust_ct_link
    into r_customer_contact
    where partner_guid = i_partner_guid
      and person_guid  = i_person_guid.

  check r_customer_contact is not initial.

  if i_persisted_only is not initial.
    read table ct_assignments_all into ls_ct_assignment
      with key partner_guid = i_partner_guid
               person_guid  = i_person_guid.
    check sy-subrc <> 0.
  endif.

  ls_ct_assignment-customer_cont = r_customer_contact.
  ls_ct_assignment-partner_guid  = i_partner_guid.
  ls_ct_assignment-person_guid   = i_person_guid.
  append ls_ct_assignment to ct_assignments_all.

endmethod.


method get_bp_4_customer_assignment.

  data:
    ls_bd001       type bd001,
    lv_lines       type i.

  check i_customer is not initial.

* check the size of assignment_all.  Refresh after it reaches size limit for performance
  describe table assignments_all lines lv_lines.
  if lv_lines > 10000. "10000 is a hypothetical number and not based on facts
                       "it is also not the optimal size limit for internal tables
    refresh assignments_all.
  endif.

  if i_persisted_only is initial.
    "check if assignment is already in buffer
    read table assignments_all into r_assignment
      with key customer components customer = i_customer.
  endif.

  if r_assignment is initial.

    "select only if customer has not yet been found in buffers
    select single * from cvi_cust_link into r_assignment
      where customer = i_customer.                          "#EC *
    if r_assignment is initial.
      "set customer in any case (non-found-buffer)
      r_assignment-customer     = i_customer.
      select single * from bd001 into ls_bd001
        where kunnr = i_customer.                           "#EC *
      if sy-subrc = 0.
        move-corresponding ls_bd001 to r_assignment.        "#EC ENHOK
        r_assignment-partner_guid = get_partner_guid( ls_bd001-partner ).
      endif.
    endif.

    "append entry in any case (non-found buffer)
    "check for existing entries because of i_persisted_only = true
    read table assignments_all transporting no fields
      with key customer components customer = i_customer.
    if sy-subrc <> 0.
      insert r_assignment into table assignments_all.
    endif.

  endif.

  "don't return assignment if it is a non-found-buffer entry
  if r_assignment-partner_guid is initial.
    clear r_assignment.
  endif.

endmethod.


method get_ct_assignments_all.

  data :
    ls_cust_ct_assignment type cvi_cust_ct_link.

  if i_person_guid is initial.
    loop at ct_assignments_all into ls_cust_ct_assignment
      where partner_guid = i_partner_guid.
      append ls_cust_ct_assignment to e_cust_ct_assignments.
    endloop.

  elseif i_person_guid is not initial.
    read table ct_assignments_all into ls_cust_ct_assignment
      with key partner_guid = i_partner_guid
               person_guid  = i_person_guid.
    append ls_cust_ct_assignment to e_cust_ct_assignments.
  endif.

endmethod.


method get_customer_4_bp_assignment.

  data:
    ls_bd001       type bd001,
    lv_lines       type i.

  check i_partner is not initial.

* check the size of assignment_all.  Refresh after it reaches size limit for performance
  describe table assignments_all lines lv_lines.
  if lv_lines > 10000. "10000 is a hypothetical number and not based on facts
                       "it is also not the optimal size limit for internal tables
    refresh assignments_all.
  endif.

  if i_persisted_only is initial.
    "check if assignment is already in buffer
    read table assignments_all into r_assignment
      with key partner_guid = i_partner.
  endif.

  if r_assignment is initial or r_assignment-customer is initial.

    "select only if customer has not yet been found in buffers
    select single * from cvi_cust_link into r_assignment
      where partner_guid = i_partner.                       "#EC *
    if r_assignment is initial.
      "set partner guid in any case (non-found-buffer)
      r_assignment-partner_guid = i_partner.
      ls_bd001-partner = get_partner_id( i_partner ).
      select single * from bd001 into ls_bd001
        where partner = ls_bd001-partner.                     "#EC *
      if sy-subrc = 0.
        move-corresponding ls_bd001 to r_assignment.        "#EC ENHOK
        r_assignment-customer = ls_bd001-kunnr.
    ENDIF.
  endif.

    "append entry in any case (non-found buffer)
    "check for existing entries because of i_persisted_only = true
    read table assignments_all transporting no fields
      with key partner_guid = i_partner.
    if sy-subrc <> 0.
      insert r_assignment into table assignments_all.
    endif.

  endif.

  "don't return assignment if it is a non-found-buffer entry
  if r_assignment-customer is initial.
    clear r_assignment.
  endif.

endmethod.


method get_cvic_cust_to_bp1.

  select * from cvic_cust_to_bp1
    into table r_cvic_cust_to_bp1.

endmethod.


method get_cvic_cust_to_bp1_line.

  assert i_account_group is not initial.

  select single * from cvic_cust_to_bp1
    into r_cvic_cust_to_bp1
    where account_group = i_account_group.

endmethod.


method get_cvic_cust_to_bp2.

  select * from cvic_cust_to_bp2
    into table r_cvic_cust_to_bp2.

endmethod.


method GET_CVIC_CUST_TO_BP2_LINES .

  assert i_account_group is not initial.

  select * from cvic_cust_to_bp2
    into table r_cvic_cust_to_bp2
    where account_group = i_account_group. "#EC *

endmethod.


method get_external_customer_id.

  data:
    lcl_bp_cust type ref to cvi_bp_customer.

  lcl_bp_cust = cvi_bp_customer=>get_instance( i_partner = i_partner_id ).
  r_customer_id = lcl_bp_cust->get_customer( ).

endmethod.


method get_instance.

  if instance is not bound.
    create object instance.
  endif.
  r_instance = instance.

endmethod.


method get_new_customer_id.

    cmd_ei_api=>get_number(
      exporting
        iv_ktokd = i_account_group
      importing
        ev_kunnr = e_customer_id
        es_error = e_error
    ).

endmethod.


method get_t077d.

  select * from t077d into table r_t077d.

endmethod.


method get_t077d_line.

  assert i_account_group is not initial.

  select single * from t077d into r_t077d
    where ktokd = i_account_group.

endmethod.


method get_tbd001.

  select * from tbd001 into table r_tbd001.

endmethod.


method get_tbd001_line.

  assert i_group is not initial.

  select single * from tbd001 into r_tbd001
    where bu_group = i_group.

endmethod.


method get_tbd002.

  check i_role_categories[] is not initial.

  select * from tbd002 into table r_tbd002
    for all entries in i_role_categories
    where rltyp = i_role_categories-category.

endmethod.


method if_ukm_easy~add.

  data:
    lt_missing     type mdst_missing_key_t,
    lt_keylist     type mdst_key_keylist_t,
    ls_message     type bapiret2,
    lv_partner     type bu_partner_guid,
    lv_customer    type kunnr,
    lv_object_key  type ukm_e_key_value,
    lv_msg_var1    type symsgv,
    lv_msg_var2    type symsgv,
    lv_msg_var3    type symsgv,
    lv_msg_var4    type symsgv.

  field-symbols:
    <keylist>     like line of lt_keylist,
    <missing>     type line of mdst_missing_key_t.

  check it_key_mapping[] is not initial.

  cl_mds_keymap_service=>data_map_from_ukms(
    exporting
      it_ukm_key_mapping    = it_key_mapping[]
    importing
      et_keylist            = lt_keylist[]
      et_missing_objecttype = lt_missing[]
  ).

  loop at lt_missing assigning <missing>.
    lv_msg_var1 = <missing>-objecttype.
    ls_message = fsbp_generic_services=>new_message(
      i_class_id  = cvi_mapper=>if_cvi_common_constants~msg_class_cvi
      i_type      = fsbp_generic_services=>msg_error
      i_number    = '016'
      i_variable1 = lv_msg_var1
    ).
    append ls_message to es_messages-general_message-messages.
  endloop.

  loop at lt_keylist assigning <keylist>.
    case <keylist>-source_objecttype.
      when ukm_object_partner.
        <keylist>-target_objecttype = ukm_object_customer.
        lv_partner = <keylist>-source_objectkey.
        lv_object_key = get_assigned_customer_for_bp( lv_partner ).
        if lv_object_key is not initial.
          if <keylist>-target_objectkey <> lv_object_key.
            lv_msg_var1 = <keylist>-source_objecttype.
            lv_msg_var2 = <keylist>-source_objectkey.
            lv_msg_var3 = <keylist>-target_objecttype.
            lv_msg_var4 = lv_object_key.
            ls_message = fsbp_generic_services=>new_message(
              i_class_id  = cvi_mapper=>if_cvi_common_constants~msg_class_cvi
              i_type      = fsbp_generic_services=>msg_error
              i_number    = '033'
              i_variable1 = lv_msg_var1
              i_variable2 = lv_msg_var2
              i_variable3 = lv_msg_var3
              i_variable4 = lv_msg_var4
            ).
            append ls_message to es_messages-general_message-messages.
          endif.
        else.
          lv_customer = <keylist>-target_objectkey.
          new_assignment(
            i_partner_guid = lv_partner
            i_customer_id  = lv_customer
          ).
        endif.
      when ukm_object_customer.
        <keylist>-target_objecttype = ukm_object_partner.
        lv_partner = <keylist>-source_objectkey.
        lv_object_key = get_assigned_bp_for_customer( lv_customer ).
        if lv_object_key is not initial.
          if <keylist>-target_objectkey <> lv_object_key.
            lv_msg_var1 = <keylist>-source_objecttype.
            lv_msg_var2 = <keylist>-source_objectkey.
            lv_msg_var3 = <keylist>-target_objecttype.
            lv_msg_var4 = lv_object_key.
            ls_message = fsbp_generic_services=>new_message(
              i_class_id  = cvi_mapper=>if_cvi_common_constants~msg_class_cvi
              i_type      = fsbp_generic_services=>msg_error
              i_number    = '033'
              i_variable1 = lv_msg_var1
              i_variable2 = lv_msg_var2
              i_variable3 = lv_msg_var3
              i_variable4 = lv_msg_var4
            ).
            append ls_message to es_messages-general_message-messages.
          endif.
        else.
          lv_partner = <keylist>-target_objectkey.
          new_assignment(
            i_partner_guid = lv_partner
            i_customer_id  = lv_customer
          ).
        endif.
      when others.
        lv_msg_var1 = <keylist>-target_objecttype.
        ls_message = fsbp_generic_services=>new_message(
          i_class_id  = cvi_mapper=>if_cvi_common_constants~msg_class_cvi
          i_type      = fsbp_generic_services=>msg_warning
          i_number    = '016'
          i_variable1 = lv_msg_var1
        ).
        append ls_message to es_messages-general_message-messages.
    endcase.
  endloop.

  check es_messages-general_message-messages is not initial.
  es_messages-general_message-message_type_indicator-type_warning = true.

endmethod.


method if_ukm_easy~delete.

  data:
    lt_missing     type mdst_missing_key_t,
    lt_keylist     type mdst_key_keylist_t,
    ls_message     type bapiret2,
    ls_assignment  type cvi_cust_link,
    lv_partner     type bu_partner_guid,
    lv_customer    type kunnr,
    lv_object_key  type ukm_e_key_value,
    lv_msg_var1    type symsgv,
    lv_msg_var2    type symsgv,
    lv_msg_var3    type symsgv,
    lv_msg_var4    type symsgv.

  field-symbols:
    <keylist>     like line of lt_keylist,
    <missing>     type line of mdst_missing_key_t.

  check it_key_mapping[] is not initial.

  cl_mds_keymap_service=>data_map_from_ukms(
    exporting
      it_ukm_key_mapping    = it_key_mapping[]
    importing
      et_keylist            = lt_keylist[]
      et_missing_objecttype = lt_missing[]
  ).

  loop at lt_missing assigning <missing>.
    lv_msg_var1 = <missing>-objecttype.
    ls_message = fsbp_generic_services=>new_message(
      i_class_id  = cvi_mapper=>if_cvi_common_constants~msg_class_cvi
      i_type      = fsbp_generic_services=>msg_error
      i_number    = '016'
      i_variable1 = lv_msg_var1
    ).
    append ls_message to es_messages-general_message-messages.
  endloop.

  loop at lt_keylist assigning <keylist>.
    case <keylist>-source_objecttype.
      when ukm_object_partner.
        <keylist>-target_objecttype = ukm_object_customer.
        lv_partner = <keylist>-source_objectkey.
        lv_object_key = get_assigned_customer_for_bp(
          i_partner        = lv_partner
        ).
        if lv_object_key is not initial.
          if <keylist>-target_objectkey <> lv_object_key.
            lv_msg_var1 = <keylist>-source_objecttype.
            lv_msg_var2 = <keylist>-source_objectkey.
            lv_msg_var3 = <keylist>-target_objecttype.
            lv_msg_var4 = lv_object_key.
            ls_message = fsbp_generic_services=>new_message(
              i_class_id  = cvi_mapper=>if_cvi_common_constants~msg_class_cvi
              i_type      = fsbp_generic_services=>msg_error
              i_number    = '033'
              i_variable1 = lv_msg_var1
              i_variable2 = lv_msg_var2
              i_variable3 = lv_msg_var3
              i_variable4 = lv_msg_var4
            ).
            append ls_message to es_messages-general_message-messages.
          else.
            ls_assignment-partner_guid = lv_partner.
            ls_assignment-customer     = <keylist>-target_objectkey.
            if undo_assignment( ls_assignment ) = false.
              lv_msg_var1 = <keylist>-source_objecttype.
              lv_msg_var2 = <keylist>-source_objectkey.
              lv_msg_var3 = <keylist>-target_objecttype.
              lv_msg_var4 = <keylist>-target_objectkey.
              ls_message = fsbp_generic_services=>new_message(
                i_class_id  = cvi_mapper=>if_cvi_common_constants~msg_class_cvi
                i_type      = fsbp_generic_services=>msg_error
                i_number    = '034'
                i_variable1 = lv_msg_var1
                i_variable2 = lv_msg_var2
                i_variable3 = lv_msg_var3
                i_variable4 = lv_msg_var4
              ).
              append ls_message to es_messages-general_message-messages.
            endif.
          endif.
        endif.
      when ukm_object_customer.
        <keylist>-target_objecttype = ukm_object_partner.
        lv_partner = <keylist>-source_objectkey.
        lv_object_key = get_assigned_bp_for_customer(
          i_customer       = lv_customer
        ).
        if lv_object_key is not initial.
          if <keylist>-target_objectkey <> lv_object_key.
            lv_msg_var1 = <keylist>-source_objecttype.
            lv_msg_var2 = <keylist>-source_objectkey.
            lv_msg_var3 = <keylist>-target_objecttype.
            lv_msg_var4 = lv_object_key.
            ls_message = fsbp_generic_services=>new_message(
              i_class_id  = cvi_mapper=>if_cvi_common_constants~msg_class_cvi
              i_type      = fsbp_generic_services=>msg_error
              i_number    = '033'
              i_variable1 = lv_msg_var1
              i_variable2 = lv_msg_var2
              i_variable3 = lv_msg_var3
              i_variable4 = lv_msg_var4
            ).
            append ls_message to es_messages-general_message-messages.
          endif.
        else.
          ls_assignment-partner_guid = <keylist>-target_objectkey.
          ls_assignment-customer     = lv_customer.
          if undo_assignment( ls_assignment ) = false.
            lv_msg_var1 = <keylist>-source_objecttype.
            lv_msg_var2 = <keylist>-source_objectkey.
            lv_msg_var3 = <keylist>-target_objecttype.
            lv_msg_var4 = <keylist>-target_objectkey.
            ls_message = fsbp_generic_services=>new_message(
              i_class_id  = cvi_mapper=>if_cvi_common_constants~msg_class_cvi
              i_type      = fsbp_generic_services=>msg_error
              i_number    = '034'
              i_variable1 = lv_msg_var1
              i_variable2 = lv_msg_var2
              i_variable3 = lv_msg_var3
              i_variable4 = lv_msg_var4
            ).
            append ls_message to es_messages-general_message-messages.
          endif.
        endif.
      when others.
        lv_msg_var1 = <keylist>-target_objecttype.
        ls_message = fsbp_generic_services=>new_message(
          i_class_id  = cvi_mapper=>if_cvi_common_constants~msg_class_cvi
          i_type      = fsbp_generic_services=>msg_warning
          i_number    = '016'
          i_variable1 = lv_msg_var1
        ).
        append ls_message to es_messages-general_message-messages.
    endcase.
  endloop.

  check es_messages-general_message-messages is not initial.
  es_messages-general_message-message_type_indicator-type_warning = true.

endmethod.


method if_ukm_easy~get.

  data:
    lt_missing     type mdst_missing_key_t,
    lt_keylist     type mdst_key_keylist_t,
    ls_key_mapping like line of ct_key_mapping,
    ls_message     type bapiret2,
    lv_partner     type bu_partner_guid,
    lv_customer    type kunnr,
    lv_msg_var1    type symsgv.

  field-symbols:
    <keylist>     like line of lt_keylist,
    <missing>     type line of mdst_missing_key_t.

  check ct_key_mapping[] is not initial.
  read table ct_key_mapping into ls_key_mapping index 1.

  cl_mds_keymap_service=>data_map_from_ukms(
    exporting
      it_ukm_key_mapping    = ct_key_mapping[]
    importing
      et_keylist            = lt_keylist[]
      et_missing_objecttype = lt_missing[]
  ).

  loop at lt_missing assigning <missing>.
    lv_msg_var1 = <missing>-objecttype.
    ls_message = fsbp_generic_services=>new_message(
      i_class_id  = cvi_mapper=>if_cvi_common_constants~msg_class_cvi
      i_type      = fsbp_generic_services=>msg_error
      i_number    = '016'
      i_variable1 = lv_msg_var1
    ).
    append ls_message to es_messages-general_message-messages.
  endloop.

  loop at lt_keylist assigning <keylist>.
    case <keylist>-source_objecttype.
      when ukm_object_partner.
        <keylist>-target_objecttype = ukm_object_customer.
        lv_partner = <keylist>-source_objectkey.
        <keylist>-target_objectkey  = get_assigned_customer_for_bp(
          i_partner        = lv_partner
          i_persisted_only = iv_read_buffer
        ).
      when ukm_object_customer.
        <keylist>-target_objecttype = ukm_object_partner.
        lv_partner = <keylist>-source_objectkey.
        <keylist>-target_objectkey  = get_assigned_bp_for_customer(
          i_customer       = lv_customer
          i_persisted_only = iv_read_buffer
        ).
      when others.
        lv_msg_var1 = <keylist>-target_objecttype.
        ls_message = fsbp_generic_services=>new_message(
          i_class_id  = cvi_mapper=>if_cvi_common_constants~msg_class_cvi
          i_type      = fsbp_generic_services=>msg_warning
          i_number    = '016'
          i_variable1 = lv_msg_var1
        ).
        append ls_message to es_messages-general_message-messages.
    endcase.
  endloop.

  cl_mds_keymap_service=>data_map_to_ukms(
    exporting
      iv_main_context_id = ls_key_mapping-main_context_id
      it_keylist         = lt_keylist
    importing
      et_ukm_key_mapping = ct_key_mapping[]
      et_missing_scheme  = lt_missing[]
  ).

  loop at lt_missing assigning <missing>.
    lv_msg_var1 = <keylist>-target_objecttype.
    ls_message = fsbp_generic_services=>new_message(
      i_class_id  = cvi_mapper=>if_cvi_common_constants~msg_class_cvi
      i_type      = fsbp_generic_services=>msg_warning
      i_number    = '016'
      i_variable1 = lv_msg_var1
    ).
    append ls_message to es_messages-general_message-messages.
  endloop.

  check es_messages-general_message-messages is not initial.
  es_messages-general_message-message_type_indicator-type_warning = true.

endmethod.


method IS_BP_IN_CUSTOMER_ROLE.
* this new method has ben created beacuse of a requirement from Real Estate and has been created
* exclusively for them. Please consult colleagues from AP-MD-BP-SYN before using this method
* for any process

  data:
    lt_tbd002      type table of tbd002,
    ls_tbd002      like line of lt_tbd002,
    lv_partner_id  like i_partner_id,
    lv_cust_req    type boole-boole,
    lcl_bo         type ref to fsbp_bo_cvi,
    lv_grouping    type bu_group,
    ls_tbd001      type tbd001,
    ls_but000      type bus000.

  r_req_status = req_status_not_req.

  if i_partner_id is initial.
    if i_partner_guid is not initial.
      lv_partner_id = get_partner_id( i_partner_guid = i_partner_guid ).
    endif.
  else.
    lv_partner_id = i_partner_id.
  endif.

  lt_tbd002 = get_tbd002( i_role_categories[] ).

  read table lt_tbd002 transporting no fields
    with key deb = true.
  if sy-subrc = 0.
    r_req_status = req_status_required.
  else.
    read table lt_tbd002 transporting no fields
      with key deb_flag = true.
    if sy-subrc = 0.
      r_req_status = req_status_optional.
    endif.
  endif.

* check if optional roles must be switched to customer based roles or
* if switch has been activated in dialogue
  check r_req_status = req_status_optional.
  loop at lt_tbd002 into ls_tbd002 where fname is not initial.
    try.
      call function ls_tbd002-fname
        exporting
          i_tbd002     = ls_tbd002
        importing
          flag_debitor = lv_cust_req.
    endtry.
    if sy-subrc = 0
      and r_req_status = req_status_optional
      and lv_cust_req  = true.
      r_req_status = req_status_required.
      return.
    endif.
  endloop.

* check if role has been changed in BP dialog
  check r_req_status = req_status_optional and lv_partner_id is not initial.
* call method from dialog memory
  lcl_bo ?= fsbp_business_factory=>get_instance( lv_partner_id ).
  if lcl_bo->is_optional_customer_set( ) = true.
    r_req_status = req_status_required.
  endif.

endmethod.


METHOD is_bp_required_for_customer.

  r_req_status = req_status_not_req.
  CHECK is_strategy_active(
          i_source_object = ukm_object_customer
          i_target_object = ukm_object_partner
        ) IS NOT INITIAL
    AND get_cvic_cust_to_bp1_line( i_account_group ) IS NOT INITIAL
    AND get_cvic_cust_to_bp2_lines( i_account_group ) IS NOT INITIAL
    AND is_consumer_account_group( i_account_group ) = false
    AND is_customer_retail_site( i_customer ) = false.
  r_req_status = req_status_required.



***********************************************************************************
*                 Begin of Enhancements for MDG Multiple Assignment Handling
***********************************************************************************
  CONSTANTS:
         lc_mlt_as_cvi_class            TYPE seoclsname VALUE 'CL_MDG_BS_BP_MLT_ASSGNMNT_CVI',
         lc_mlt_as_mlt_as_check_method  TYPE seocmpname VALUE 'CHECK_EXISTENCE_MLT_ASSGNMNT'.

  DATA: lv_mlt_as_exist                 TYPE abap_bool,
        lv_object_id                    TYPE string.

* in case customer is assigned to a business partner as non-standard object (multiple assignment)
* a BP must not be created!

* check if method exists to avoid dump
  IF me->check_existence_method( iv_class_name  = lc_mlt_as_cvi_class
                                 iv_method_name = lc_mlt_as_mlt_as_check_method ) = abap_true.

    lv_object_id = i_customer.
    TRY.
*       dynamic call due to decoupling of MDG_APPL and SAP_APPL objects
        CALL METHOD (lc_mlt_as_cvi_class)=>(lc_mlt_as_mlt_as_check_method)
          EXPORTING
            iv_assignment_cat = 'CUST'
        iv_object_id      = lv_object_id
        if_no_std_object  = abap_true       " check non standard customers only
      IMPORTING
        ef_exist          = lv_mlt_as_exist.
      CATCH cx_sy_dyn_call_illegal_class.  "catches are ignored 'on commit'
    ENDTRY.

    IF lv_mlt_as_exist = abap_true.
      r_req_status = req_status_not_req.
    ENDIF.

  ENDIF.

***********************************************************************************
*                 End of Enhancements for MDG Multiple Assignment Handling
***********************************************************************************
ENDMETHOD.


method is_bp_with_same_number.

  data:
    ls_cust_to_bp1 type cvic_cust_to_bp1.

  ls_cust_to_bp1 = get_cvic_cust_to_bp1_line( i_account_group ).
  check ls_cust_to_bp1-same_number is not initial.
  r_is_same_number = true.

endmethod.


method is_consumer_account_group.

  data:
    ls_t077d       type t077d.

  ls_t077d  = get_t077d_line( i_account_group ).
  check ls_t077d-dear6 is not initial.
  r_is_consumer_account = true.

endmethod.


method is_customer_id_external.

  data:
    ls_tbd001  type tbd001,
    ls_t077d   type t077d,
    ls_nriv    type nriv.

  check i_grouping is not initial.
  ls_tbd001 = get_tbd001_line( i_grouping ).
  check ls_tbd001-ktokd is not initial.
  ls_t077d = get_t077d_line( ls_tbd001-ktokd ).
  check ls_t077d-numkr is not initial.
  ls_nriv  = get_nriv_line(
    i_object_type  = nrobj_customer
    i_number_range = ls_t077d-numkr
  ).
  r_result = ls_nriv-externind.

endmethod.


method is_customer_required_for_bp.
* The changes to this method have been made on the request of Real Estate component.
* The changes do not affect synchronization process in anyway
*  data:
*    lt_tbd002      type table of tbd002,
*    ls_tbd002      like line of lt_tbd002,
*    lv_partner_id  like i_partner_id,
*    lv_cust_req    type boole-boole,
*    lcl_bo         type ref to fsbp_bo_cvi,
*    lv_grouping    type bu_group,
*    ls_tbd001      type tbd001,
*    ls_but000      type BUS000.
*
*  r_req_status = req_status_not_req.
  check is_strategy_active(
    i_source_object = ukm_object_partner
    i_target_object = ukm_object_customer
  ) is not initial.
  r_req_status = is_bp_in_customer_role(
        i_partner_id      = i_partner_id
        i_partner_guid    = i_partner_guid
        i_role_categories =  i_role_categories ).

*  if i_partner_id is initial.
*    if i_partner_guid is not initial.
*      lv_partner_id = get_partner_id( i_partner_guid = i_partner_guid ).
*    endif.
*  else.
*    lv_partner_id = i_partner_id.
*  endif.
*
*  lt_tbd002 = get_tbd002( i_role_categories[] ).
*
*  read table lt_tbd002 transporting no fields
*    with key deb = true.
*  if sy-subrc = 0.
*    r_req_status = req_status_required.
*  else.
*    read table lt_tbd002 transporting no fields
*      with key deb_flag = true.
*    if sy-subrc = 0.
*      r_req_status = req_status_optional.
*    endif.
*  endif.
*
** check if optional roles must be switched to customer based roles or
** if switch has been activated in dialogue
*  check r_req_status = req_status_optional.
*  loop at lt_tbd002 into ls_tbd002 where fname is not initial.
*    try.
*      call function ls_tbd002-fname
*        EXPORTING
*          i_tbd002     = ls_tbd002
*        IMPORTING
*          flag_debitor = lv_cust_req.
*    endtry.
*    if sy-subrc = 0
*      and r_req_status = req_status_optional
*      and lv_cust_req  = true.
*      r_req_status = req_status_required.
*      return.
*    endif.
*  endloop.
*
** check if role has been changed in BP dialog
*  check r_req_status = req_status_optional and lv_partner_id is not initial.
** call method from dialog memory
*  lcl_bo ?= fsbp_business_factory=>get_instance( lv_partner_id ).
*  if lcl_bo->is_optional_customer_set( ) = true.
*    r_req_status = req_status_required.
*  endif.

endmethod.


method is_customer_retail_site.

  data:
    ls_t001w type t001w.

  select single * from t001w into ls_t001w
    where kunnr = i_customer.   "#EC *

  check ls_t001w-vlfkz is not initial.
  r_is_retail_site = true.

endmethod.


method is_customer_with_same_number.

  data:
    ls_tbd001 type tbd001.

  ls_tbd001 = get_tbd001_line( i_grouping ).
  r_result = ls_tbd001-xsamenumber.

endmethod.


method new_assignment.

  data:
    ls_assignment like line of assignments_new,
    lv_lines type i.

  assert:
    i_partner_guid is not initial,
    i_customer_id  is not initial.

  ls_assignment-partner_guid = i_partner_guid.
  ls_assignment-customer     = i_customer_id.
  ls_assignment-cruser       = sy-uname.
  ls_assignment-crdat        = sy-datlo.
  ls_assignment-crtim        = sy-uzeit.

  "assignments_all is a sorted table, so update on key field partner_guid is not possible
  delete assignments_all where partner_guid = i_partner_guid.
  if sy-subrc <> 0.
    delete assignments_all using key customer where customer = i_customer_id.
  endif.

  insert ls_assignment into table assignments_all.
  append ls_assignment to assignments_new.

* check the size of assignment_all.  Refresh after it reaches size limit for performance
  describe table assignments_all lines lv_lines.
  if lv_lines > 10000. "10000 is a hypothetical number and not based on facts
                       "it is also not the optimal size limit for internal tables
    refresh assignments_all.
  endif.

endmethod.


method new_customer_contact_id.

  constants:
    lc_contact_numberrange        type numkr value 'AP',
    lc_numberrange_object_contact type nrobj value 'PARTNER'.

* hier fehlt noch die Methode von CMD_EI_API
  call function 'NUMBER_GET_NEXT'
    exporting
      nr_range_nr = lc_contact_numberrange
      object      = lc_numberrange_object_contact
    importing
      number      = r_customer_contact_id
    exceptions
      others      = 0.

endmethod.


method new_customer_id.

  data:
    ls_message         like line of e_error-messages,
    ls_error           like e_error,
    ls_tbd001          type tbd001,
    ls_t077d           type t077d,
    ls_nriv            type nriv,
    lv_ext_customer_id type kunnr,
    lv_ktokd           type ktokd,
    lv_flexible        type xfeld.

  field-symbols:
    <lv_flexible> type any.

  ls_tbd001 = get_tbd001_line( i_group ).
  assign component 'XFLEXIBLE' of structure ls_tbd001 to <lv_flexible>.
  if sy-subrc eq 0.
    lv_flexible = <lv_flexible>.
  endif.
  if lv_flexible = abap_true
    and i_flexible_group is not initial.
    "flexible handling has to use the given account group
    lv_ktokd = i_flexible_group.
  else.
    lv_ktokd = ls_tbd001-ktokd.
  endif.
  ls_t077d  = get_t077d_line( lv_ktokd ).
  ls_nriv   = get_nriv_line(
    i_object_type  = nrobj_customer
    i_number_range = ls_t077d-numkr
  ).

  if ls_tbd001-xsamenumber = true
    and lv_flexible = abap_false.
    "If same number option is active, externally given customer numbers
    "will be ignored.  Flexible numbering always uses the given customer
    "number.
    e_error = check_customer_id_available( i_partner_id ).
    check e_error-is_error = false.

    ls_error = check_customer_id_correct(
      i_customer_id   = i_partner_id
      i_account_group = lv_ktokd
    ).
    append lines of ls_error-messages to e_error-messages.
    e_error-is_error = ls_error-is_error.

    check e_error-is_error = false.
    e_customer_id = i_partner_id.

  elseif ls_nriv-externind = true.
    "external number assignment, get externally given id
    lv_ext_customer_id = get_external_customer_id( i_partner_id ).
    if lv_ext_customer_id is not initial and
       lv_ext_customer_id(2) <> if_fsbp_generic_constants=>bp_handle.
      e_error = check_customer_id_available( lv_ext_customer_id ).

      if e_error-is_error = false.
        "flexible numbering does not validate the given number
        if lv_flexible = abap_false.
          ls_error = check_customer_id_correct(
            i_customer_id   = lv_ext_customer_id
            i_account_group = ls_tbd001-ktokd
          ).
          append lines of ls_error-messages to e_error-messages.
          e_error-is_error = ls_error-is_error.
        endif.

        if e_error-is_error = false.
          e_customer_id = lv_ext_customer_id .
        endif.
      endif.
    else.
      ls_message = fsbp_generic_services=>new_message(
        i_class_id  = msg_class_cvi
        i_type      = fsbp_generic_services=>msg_error
        i_number    = '006'
      ).
      e_error-is_error = true.
      append ls_message to e_error-messages.
    endif.
  else.
    "internal number assignment
    get_new_customer_id(
      exporting
        i_account_group = lv_ktokd
      importing
        e_customer_id   = e_customer_id
        e_error         = e_error
    ).
  endif.

endmethod.


method new_cust_ct_assignment.

  data:
    ls_assignment    like line of ct_assignments_new,
    lcl_mapper       type ref to cvi_mapper.

  lcl_mapper = cvi_mapper=>get_instance( ).
  check lcl_mapper->is_mapping_for_contact_active( ) = true.

  assert:
    i_partner_guid         is not initial,
    i_partner_contact_guid is not initial,
    i_customer_contact_id  is not initial.

  ls_assignment-partner_guid  = i_partner_guid.
  ls_assignment-person_guid   = i_partner_contact_guid.
  ls_assignment-customer_cont = i_customer_contact_id.
  ls_assignment-cruser        = sy-uname.
  ls_assignment-crdat         = sy-datlo.
  ls_assignment-crtim         = sy-uzeit.
  append:
    ls_assignment to ct_assignments_new,
    ls_assignment to ct_assignments_all.

endmethod.


  method REFRESH_CT_ASSIGNMENTS.

    data: lt_assignments_del type LINE OF cvis_cust_ct_link_t.
*   refresh all ct tables based on updates
    LOOP at ct_assignments_del INTO lt_assignments_del.
      DELETE ct_assignments_all WHERE partner_guid = lt_assignments_del-partner_guid AND
                                      person_guid  = lt_assignments_del-person_guid.
    ENDLOOP.

**do not refresh ct_assignments_all
* refresh: ct_assignments_all.
  refresh: assignments_new, ct_assignments_new, ct_assignments_del.

  endmethod.


method remove_cust_ct_assignment.

  data:
    ls_assignment    like i_cust_ct_assignment,
    lcl_mapper       type ref to cvi_mapper.

  lcl_mapper = cvi_mapper=>get_instance( ).
  check lcl_mapper->is_mapping_for_contact_active( ) = true.

  assert:
    i_cust_ct_assignment-partner_guid  is not initial,
    i_cust_ct_assignment-person_guid   is not initial.

  ls_assignment = i_cust_ct_assignment.
  ls_assignment-client = sy-mandt.
  append ls_assignment to ct_assignments_del.

endmethod.


method undo_assignment.

  delete assignments_new
    where partner_guid = i_assignment-partner_guid
      and customer     = i_assignment-customer.
  check sy-subrc = 0.
  delete assignments_all
    where partner_guid = i_assignment-partner_guid
      and customer     = i_assignment-customer.
  r_unassigned = true.

endmethod.


method undo_cust_ct_assignment.

  delete ct_assignments_new
    where partner_guid  = i_assignment-partner_guid
      and person_guid   = i_assignment-person_guid
      and customer_cont = i_assignment-customer_cont.
  check sy-subrc = 0.
  delete ct_assignments_all
    where partner_guid  = i_assignment-partner_guid
      and person_guid   = i_assignment-person_guid
      and customer_cont = i_assignment-customer_cont.
  r_unassigned = true.

endmethod.


method unremove_cust_ct_assignment.

  delete ct_assignments_del
    where partner_guid  = i_assignment-partner_guid
      and person_guid   = i_assignment-person_guid.
  check sy-subrc = 0.
  r_unremoved = true.

endmethod.
ENDCLASS.
