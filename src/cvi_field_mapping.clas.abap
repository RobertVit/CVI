class CVI_FIELD_MAPPING definition
  public
  create protected .

*"* public components of class CVI_FIELD_MAPPING
*"* do not include other source files here!!!
public section.

  interfaces IF_CVI_COMMON_CONSTANTS .

  class-methods CLASS_CONSTRUCTOR .
protected section.
*"* protected components of class CVI_FIELD_MAPPING
*"* do not include other source files here!!!

  aliases BP_AS_GROUP
    for IF_CVI_COMMON_CONSTANTS~BP_AS_GROUP .
  aliases BP_AS_ORG
    for IF_CVI_COMMON_CONSTANTS~BP_AS_ORG .
  aliases BP_AS_PERSON
    for IF_CVI_COMMON_CONSTANTS~BP_AS_PERSON .
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
  aliases TASK_TIME
    for IF_CVI_COMMON_CONSTANTS~TASK_TIME .
  aliases TASK_UPDATE
    for IF_CVI_COMMON_CONSTANTS~TASK_UPDATE .
  aliases TRUE
    for IF_CVI_COMMON_CONSTANTS~TRUE .

  class-data BADI_REF_BANKDETAILS type ref to CVI_MAP_BANKDETAILS .
  class-data BADI_REF_CREDIT_CARDS type ref to CVI_MAP_CREDIT_CARDS .

  methods GET_BP_STANDARD_COUNTRY
    importing
      !I_PARTNER type BUS_EI_EXTERN
    exporting
      value(E_COUNTRY) type CHAR3
      !E_ERRORS type CVIS_ERROR .
  methods READ_ALL_BP_BANKDETAILS
    importing
      !I_PARTNER_GUID type BU_PARTNER_GUID_BAPI
      !I_BANKDETAILS type BUS_EI_BUPA_BANKDETAIL_T
    exporting
      !E_BANKDETAILS type BUS_EI_BUPA_BANKDETAIL_T
      !E_ERRORS type CVIS_ERROR .
  methods READ_ALL_BP_TAX_NUMBERS
    importing
      !I_PARTNER type BUS_EI_EXTERN
    exporting
      !E_TAX_NUMBERS type BUS_EI_BUPA_TAXNUMBER_T
      !E_ERRORS type CVIS_ERROR .
  methods MAP_BP_CV_ADDRESS
    importing
      !I_PARTNER type BUS_EI_EXTERN
    changing
      !C_ADDRESS type CVIS_EI_ADDRESS1
      !C_ERRORS type CVIS_ERROR .
  methods MAP_REL_VERSION
    importing
      !I_REL_VERSION type BURS_EI_BUPA_VERSION_DATA
    exporting
      !E_CVI_VERSION type ANY .
  methods MAP_CV_VERSION
    importing
      !I_CVI_VERSION type CVIS_EI_CVI_VERSION1
    exporting
      !E_BP_VERSION type BUS_EI_VERSION .
  methods MAP_CONTACT_VERSION_TO_REL
    importing
      !I_CONTACT_VERSION type ANY
    exporting
      !E_REL_VERSION type BURS_EI_BUPA_VERSION_DATA .
  methods MAP_CONTACT_VERSION
    importing
      !I_CONTACT_VERSION type ANY
    exporting
      !E_BP_VERSION type BUS_EI_VERSION .
  methods MAP_BP_VERSION_TO_CC
    importing
      !I_BP_VERSION type BUS_EI_VERSION
    exporting
      !E_CVI_VERSION type ANY .
  methods MAP_BP_VERSION
    importing
      !I_BP_VERSION type BUS_EI_VERSION
    exporting
      !E_CVI_VERSION type CVIS_EI_CVI_VERSION1 .
  methods MAP_BP_COMMUNICATION
    importing
      !I_BP_COMMUNICATION type BUS_EI_COMMUNICATION
    exporting
      !E_CVI_COMMUNICATION type CVIS_EI_CVI_COMMUNICATION .
  methods MAP_CV_COMMUNICATION
    importing
      !I_CVI_COMMUNICATION type CVIS_EI_CVI_COMMUNICATION
    exporting
      !E_BP_COMMUNICATION type BUS_EI_COMMUNICATION .
private section.
*"* private components of class CVI_FIELD_MAPPING
*"* do not include other source files here!!!

  aliases CVI_MAPPER_BADI_NAME
    for IF_CVI_COMMON_CONSTANTS~CVI_MAPPER_BADI_NAME .
  aliases CVI_MAP_BANKDETAILS_BADI_NAME
    for IF_CVI_COMMON_CONSTANTS~CVI_MAP_BANKDETAILS_BADI_NAME .
  aliases CVI_MAP_CREDIT_CARDS_BADI_NAME
    for IF_CVI_COMMON_CONSTANTS~CVI_MAP_CREDIT_CARDS_BADI_NAME .
  aliases CVI_MAP_TITLE_BADI_NAME
    for IF_CVI_COMMON_CONSTANTS~CVI_MAP_TITLE_BADI_NAME .
ENDCLASS.



CLASS CVI_FIELD_MAPPING IMPLEMENTATION.


method class_constructor.

  data:
    cvi_mapper_context type ref to cvi_mapper.

  class cl_exithandler definition load.

* get BAdI reference
  cvi_mapper_context = cvi_mapper=>get_instance( ).

TRY.
  get badi badi_ref_bankdetails
    context
      cvi_mapper_context.

 CATCH CX_BADI_NOT_IMPLEMENTED.  "no active implementation
ENDTRY.

TRY.
  get badi badi_ref_credit_cards
    context
      cvi_mapper_context.

 CATCH CX_BADI_NOT_IMPLEMENTED.  "no active implementation
ENDTRY.

endmethod.


method get_bp_standard_country.

  data:
   ls_errors   type cvis_error,
   ls_addr_in  type bus_ei_bupa_address,
   ls_address  type buss_address,
   ls_address2 type bus_ei_bupa_address,
   lt_address  type buss_address_t.

  read table i_partner-central_data-address-addresses into ls_addr_in
    with key currently_valid                  = true
             data-postal-data-standardaddress = true.
  e_country = ls_addr_in-data-postal-data-country.

  check e_country is initial and
        ls_address-header-object_task <> task_insert and
        ls_address-header-object_task <> task_current_state.

  move-corresponding i_partner-header to ls_address-header.
  append ls_address to lt_address.

  cl_bupa_current_data=>get_address(
    exporting
      it_address = lt_address
    importing
      et_address = lt_address
      es_error   = ls_errors
  ).

  append lines of ls_errors-messages to e_errors-messages.
  e_errors-is_error = ls_errors-is_error.
  check e_errors-is_error = false.

  clear ls_address.
  read table lt_address into ls_address index 1.
  read table ls_address-address-addresses into ls_address2 index 1.

  e_country = ls_address2-data-postal-data-country.

endmethod.


method map_bp_communication.

  data:
  ls_cvi_remark type cvis_ei_comrem,
  ls_cvi_phone  type cvis_ei_phone_str,
  ls_cvi_fax    type cvis_ei_fax_str,
  ls_cvi_ttx    type cvis_ei_ttx_str,
  ls_cvi_tlx    type cvis_ei_tlx_str,
  ls_cvi_smtp   type cvis_ei_smtp_str,
  ls_cvi_rml    type cvis_ei_rml_str,
  ls_cvi_x400   type cvis_ei_x400_str,
  ls_cvi_rfc    type cvis_ei_rfc_str,
  ls_cvi_prt    type cvis_ei_prt_str,
  ls_cvi_ssf    type cvis_ei_ssf_str,
  ls_cvi_uri    type cvis_ei_uri_str,
  ls_cvi_pager  type cvis_ei_pag_str,
  ls_cvi_comm   type cvis_ei_cvi_communication,

  ls_bp_remark type bus_ei_bupa_comrem,
  ls_bp_phone  type bus_ei_bupa_telephone,
  ls_bp_fax    type bus_ei_bupa_fax,
  ls_bp_ttx    type bus_ei_bupa_ttx,
  ls_bp_tlx    type bus_ei_bupa_tlx,
  ls_bp_smtp   type bus_ei_bupa_smtp,
  ls_bp_rml    type bus_ei_bupa_rml,
  ls_bp_x400   type bus_ei_bupa_x400,
  ls_bp_rfc    type bus_ei_bupa_rfc,
  ls_bp_prt    type bus_ei_bupa_prt,
  ls_bp_ssf    type bus_ei_bupa_ssf,
  ls_bp_uri    type bus_ei_bupa_uri,
  ls_bp_pager  type bus_ei_bupa_pag,
  ls_bp_comm   type bus_ei_communication.

  ls_bp_comm = i_bp_communication.

* PHONE
  move ls_bp_comm-phone-current_state to ls_cvi_comm-phone-current_state.
  loop at ls_bp_comm-phone-phone into ls_bp_phone where currently_valid is NOT INITIAL.
    move ls_bp_phone-contact              to ls_cvi_phone-contact.
    move ls_bp_phone-remark-current_state to ls_cvi_phone-remark-current_state.
    loop at ls_bp_phone-remark-remarks into ls_bp_remark.
      move ls_bp_remark-task             to ls_cvi_remark-task.
      move ls_bp_remark-data-langu       to ls_cvi_remark-data-langu.
      move ls_bp_remark-data-langu_iso   to ls_cvi_remark-data-langu_iso.
      move ls_bp_remark-data-comm_notes  to ls_cvi_remark-data-comm_notes.
      move ls_bp_remark-datax-langu      to ls_cvi_remark-datax-langu.
      move ls_bp_remark-datax-langu_iso  to ls_cvi_remark-datax-langu_iso.
      move ls_bp_remark-datax-comm_notes to ls_cvi_remark-datax-comm_notes.
      append ls_cvi_remark to ls_cvi_phone-remark-remarks.
    endloop.
    append ls_cvi_phone to ls_cvi_comm-phone-phone.
    clear ls_cvi_phone.
  endloop.
* FAX
  move ls_bp_comm-fax-current_state to ls_cvi_comm-fax-current_state.
  loop at ls_bp_comm-fax-fax into ls_bp_fax where currently_valid is NOT INITIAL.
    move ls_bp_fax-contact              to ls_cvi_fax-contact.
    move ls_bp_fax-remark-current_state to ls_cvi_fax-remark-current_state.
    loop at ls_bp_fax-remark-remarks into ls_bp_remark.
      move ls_bp_remark-task             to ls_cvi_remark-task.
      move ls_bp_remark-data-langu       to ls_cvi_remark-data-langu.
      move ls_bp_remark-data-langu_iso   to ls_cvi_remark-data-langu_iso.
      move ls_bp_remark-data-comm_notes  to ls_cvi_remark-data-comm_notes.
      move ls_bp_remark-datax-langu      to ls_cvi_remark-datax-langu.
      move ls_bp_remark-datax-langu_iso  to ls_cvi_remark-datax-langu_iso.
      move ls_bp_remark-datax-comm_notes to ls_cvi_remark-datax-comm_notes.
      append ls_cvi_remark to ls_cvi_fax-remark-remarks.
    endloop.
    append ls_cvi_fax to ls_cvi_comm-fax-fax.
    clear ls_cvi_fax.
  endloop.
* TTX
  move ls_bp_comm-ttx-current_state to ls_cvi_comm-ttx-current_state.
  loop at ls_bp_comm-ttx-ttx into ls_bp_ttx where currently_valid is NOT INITIAL.
    move ls_bp_ttx-contact              to ls_cvi_ttx-contact.
    move ls_bp_ttx-remark-current_state to ls_cvi_ttx-remark-current_state.
    loop at ls_bp_ttx-remark-remarks into ls_bp_remark.
      move ls_bp_remark-task             to ls_cvi_remark-task.
      move ls_bp_remark-data-langu       to ls_cvi_remark-data-langu.
      move ls_bp_remark-data-langu_iso   to ls_cvi_remark-data-langu_iso.
      move ls_bp_remark-data-comm_notes  to ls_cvi_remark-data-comm_notes.
      move ls_bp_remark-datax-langu      to ls_cvi_remark-datax-langu.
      move ls_bp_remark-datax-langu_iso  to ls_cvi_remark-datax-langu_iso.
      move ls_bp_remark-datax-comm_notes to ls_cvi_remark-datax-comm_notes.
      append ls_cvi_remark to ls_cvi_ttx-remark-remarks.
    endloop.
    append ls_cvi_ttx to ls_cvi_comm-ttx-ttx.
    clear ls_cvi_ttx.
  endloop.
* TLX
  move ls_bp_comm-tlx-current_state to ls_cvi_comm-tlx-current_state.
  loop at ls_bp_comm-tlx-tlx into ls_bp_tlx where currently_valid is NOT INITIAL.
    move ls_bp_tlx-contact              to ls_cvi_tlx-contact.
    move ls_bp_tlx-remark-current_state to ls_cvi_tlx-remark-current_state.
    loop at ls_bp_tlx-remark-remarks into ls_bp_remark.
      move ls_bp_remark-task             to ls_cvi_remark-task.
      move ls_bp_remark-data-langu       to ls_cvi_remark-data-langu.
      move ls_bp_remark-data-langu_iso   to ls_cvi_remark-data-langu_iso.
      move ls_bp_remark-data-comm_notes  to ls_cvi_remark-data-comm_notes.
      move ls_bp_remark-datax-langu      to ls_cvi_remark-datax-langu.
      move ls_bp_remark-datax-langu_iso  to ls_cvi_remark-datax-langu_iso.
      move ls_bp_remark-datax-comm_notes to ls_cvi_remark-datax-comm_notes.
      append ls_cvi_remark to ls_cvi_tlx-remark-remarks.
    endloop.
    append ls_cvi_tlx to ls_cvi_comm-tlx-tlx.
    clear ls_cvi_tlx.
  endloop.
* SMTP
  move ls_bp_comm-smtp-current_state to ls_cvi_comm-smtp-current_state.
  loop at ls_bp_comm-smtp-smtp into ls_bp_smtp where currently_valid is NOT INITIAL.
    move ls_bp_smtp-contact              to ls_cvi_smtp-contact.
    move ls_bp_smtp-remark-current_state to ls_cvi_smtp-remark-current_state.
    loop at ls_bp_smtp-remark-remarks into ls_bp_remark.
      move ls_bp_remark-task             to ls_cvi_remark-task.
      move ls_bp_remark-data-langu       to ls_cvi_remark-data-langu.
      move ls_bp_remark-data-langu_iso   to ls_cvi_remark-data-langu_iso.
      move ls_bp_remark-data-comm_notes  to ls_cvi_remark-data-comm_notes.
      move ls_bp_remark-datax-langu      to ls_cvi_remark-datax-langu.
      move ls_bp_remark-datax-langu_iso  to ls_cvi_remark-datax-langu_iso.
      move ls_bp_remark-datax-comm_notes to ls_cvi_remark-datax-comm_notes.
      append ls_cvi_remark to ls_cvi_smtp-remark-remarks.
    endloop.
    append ls_cvi_smtp to ls_cvi_comm-smtp-smtp.
    clear ls_cvi_smtp.
  endloop.
* RML
  move ls_bp_comm-rml-current_state to ls_cvi_comm-rml-current_state.
  loop at ls_bp_comm-rml-rml into ls_bp_rml where currently_valid is NOT INITIAL.
    move ls_bp_rml-contact              to ls_cvi_rml-contact.
    move ls_bp_rml-remark-current_state to ls_cvi_rml-remark-current_state.
    loop at ls_bp_rml-remark-remarks into ls_bp_remark.
      move ls_bp_remark-task             to ls_cvi_remark-task.
      move ls_bp_remark-data-langu       to ls_cvi_remark-data-langu.
      move ls_bp_remark-data-langu_iso   to ls_cvi_remark-data-langu_iso.
      move ls_bp_remark-data-comm_notes  to ls_cvi_remark-data-comm_notes.
      move ls_bp_remark-datax-langu      to ls_cvi_remark-datax-langu.
      move ls_bp_remark-datax-langu_iso  to ls_cvi_remark-datax-langu_iso.
      move ls_bp_remark-datax-comm_notes to ls_cvi_remark-datax-comm_notes.
      append ls_cvi_remark to ls_cvi_rml-remark-remarks.
    endloop.
    append ls_cvi_rml to ls_cvi_comm-rml-rml.
    clear ls_cvi_rml.
  endloop.
* X400
  move ls_bp_comm-x400-current_state to ls_cvi_comm-x400-current_state.
  loop at ls_bp_comm-x400-x400 into ls_bp_x400 where currently_valid is NOT INITIAL.
    move ls_bp_x400-contact              to ls_cvi_x400-contact.
    move ls_bp_x400-remark-current_state to ls_cvi_x400-remark-current_state.
    loop at ls_bp_x400-remark-remarks into ls_bp_remark.
      move ls_bp_remark-task             to ls_cvi_remark-task.
      move ls_bp_remark-data-langu       to ls_cvi_remark-data-langu.
      move ls_bp_remark-data-langu_iso   to ls_cvi_remark-data-langu_iso.
      move ls_bp_remark-data-comm_notes  to ls_cvi_remark-data-comm_notes.
      move ls_bp_remark-datax-langu      to ls_cvi_remark-datax-langu.
      move ls_bp_remark-datax-langu_iso  to ls_cvi_remark-datax-langu_iso.
      move ls_bp_remark-datax-comm_notes to ls_cvi_remark-datax-comm_notes.
      append ls_cvi_remark to ls_cvi_x400-remark-remarks.
    endloop.
    append ls_cvi_x400 to ls_cvi_comm-x400-x400.
    clear ls_cvi_x400.
  endloop.
* RFC
  move ls_bp_comm-rfc-current_state to ls_cvi_comm-rfc-current_state.
  loop at ls_bp_comm-rfc-rfc into ls_bp_rfc where currently_valid is NOT INITIAL.
    move ls_bp_rfc-contact              to ls_cvi_rfc-contact.
    move ls_bp_rfc-remark-current_state to ls_cvi_rfc-remark-current_state.
    loop at ls_bp_rfc-remark-remarks into ls_bp_remark.
      move ls_bp_remark-task             to ls_cvi_remark-task.
      move ls_bp_remark-data-langu       to ls_cvi_remark-data-langu.
      move ls_bp_remark-data-langu_iso   to ls_cvi_remark-data-langu_iso.
      move ls_bp_remark-data-comm_notes  to ls_cvi_remark-data-comm_notes.
      move ls_bp_remark-datax-langu      to ls_cvi_remark-datax-langu.
      move ls_bp_remark-datax-langu_iso  to ls_cvi_remark-datax-langu_iso.
      move ls_bp_remark-datax-comm_notes to ls_cvi_remark-datax-comm_notes.
      append ls_cvi_remark to ls_cvi_rfc-remark-remarks.
    endloop.
    append ls_cvi_rfc to ls_cvi_comm-rfc-rfc.
    clear ls_cvi_rfc.
  endloop.
* PRT
  move ls_bp_comm-prt-current_state to ls_cvi_comm-prt-current_state.
  loop at ls_bp_comm-prt-prt into ls_bp_prt where currently_valid is NOT INITIAL.
    move ls_bp_prt-contact              to ls_cvi_prt-contact.
    move ls_bp_prt-remark-current_state to ls_cvi_prt-remark-current_state.
    loop at ls_bp_prt-remark-remarks into ls_bp_remark.
      move ls_bp_remark-task             to ls_cvi_remark-task.
      move ls_bp_remark-data-langu       to ls_cvi_remark-data-langu.
      move ls_bp_remark-data-langu_iso   to ls_cvi_remark-data-langu_iso.
      move ls_bp_remark-data-comm_notes  to ls_cvi_remark-data-comm_notes.
      move ls_bp_remark-datax-langu      to ls_cvi_remark-datax-langu.
      move ls_bp_remark-datax-langu_iso  to ls_cvi_remark-datax-langu_iso.
      move ls_bp_remark-datax-comm_notes to ls_cvi_remark-datax-comm_notes.
      append ls_cvi_remark to ls_cvi_prt-remark-remarks.
    endloop.
    append ls_cvi_prt to ls_cvi_comm-prt-prt.
    clear ls_cvi_prt.
  endloop.
* SSF
  move ls_bp_comm-ssf-current_state to ls_cvi_comm-ssf-current_state.
  loop at ls_bp_comm-ssf-ssf into ls_bp_ssf where currently_valid is NOT INITIAL.
    move ls_bp_ssf-contact              to ls_cvi_ssf-contact.
    move ls_bp_ssf-remark-current_state to ls_cvi_ssf-remark-current_state.
    loop at ls_bp_ssf-remark-remarks into ls_bp_remark.
      move ls_bp_remark-task             to ls_cvi_remark-task.
      move ls_bp_remark-data-langu       to ls_cvi_remark-data-langu.
      move ls_bp_remark-data-langu_iso   to ls_cvi_remark-data-langu_iso.
      move ls_bp_remark-data-comm_notes  to ls_cvi_remark-data-comm_notes.
      move ls_bp_remark-datax-langu      to ls_cvi_remark-datax-langu.
      move ls_bp_remark-datax-langu_iso  to ls_cvi_remark-datax-langu_iso.
      move ls_bp_remark-datax-comm_notes to ls_cvi_remark-datax-comm_notes.
      append ls_cvi_remark to ls_cvi_ssf-remark-remarks.
    endloop.
    append ls_cvi_ssf to ls_cvi_comm-ssf-ssf.
    clear ls_cvi_ssf.
  endloop.
* URI
  move ls_bp_comm-uri-current_state to ls_cvi_comm-uri-current_state.
  loop at ls_bp_comm-uri-uri into ls_bp_uri where currently_valid is NOT INITIAL.
    move ls_bp_uri-contact              to ls_cvi_uri-contact.
    move ls_bp_uri-remark-current_state to ls_cvi_uri-remark-current_state.
    loop at ls_bp_uri-remark-remarks into ls_bp_remark.
      move ls_bp_remark-task             to ls_cvi_remark-task.
      move ls_bp_remark-data-langu       to ls_cvi_remark-data-langu.
      move ls_bp_remark-data-langu_iso   to ls_cvi_remark-data-langu_iso.
      move ls_bp_remark-data-comm_notes  to ls_cvi_remark-data-comm_notes.
      move ls_bp_remark-datax-langu      to ls_cvi_remark-datax-langu.
      move ls_bp_remark-datax-langu_iso  to ls_cvi_remark-datax-langu_iso.
      move ls_bp_remark-datax-comm_notes to ls_cvi_remark-datax-comm_notes.
      append ls_cvi_remark to ls_cvi_uri-remark-remarks.
    endloop.
    append ls_cvi_uri to ls_cvi_comm-uri-uri.
    clear ls_cvi_uri.
  endloop.
* PAGER
  move ls_bp_comm-pager-current_state to ls_cvi_comm-pager-current_state.
  loop at ls_bp_comm-pager-pager into ls_bp_pager where currently_valid is NOT INITIAL.
    move ls_bp_pager-contact              to ls_cvi_pager-contact.
    move ls_bp_pager-remark-current_state to ls_cvi_pager-remark-current_state.
    loop at ls_bp_pager-remark-remarks into ls_bp_remark.
      move ls_bp_remark-task             to ls_cvi_remark-task.
      move ls_bp_remark-data-langu       to ls_cvi_remark-data-langu.
      move ls_bp_remark-data-langu_iso   to ls_cvi_remark-data-langu_iso.
      move ls_bp_remark-data-comm_notes  to ls_cvi_remark-data-comm_notes.
      move ls_bp_remark-datax-langu      to ls_cvi_remark-datax-langu.
      move ls_bp_remark-datax-langu_iso  to ls_cvi_remark-datax-langu_iso.
      move ls_bp_remark-datax-comm_notes to ls_cvi_remark-datax-comm_notes.
      append ls_cvi_remark to ls_cvi_pager-remark-remarks.
    endloop.
    append ls_cvi_pager to ls_cvi_comm-pager-pager.
    clear ls_cvi_pager.
  endloop.

  e_cvi_communication = ls_cvi_comm.

endmethod.


method MAP_BP_CV_ADDRESS.

  data:
    lv_obj_task        type bus_ei_object_task,
    lv_mark_all        type boole-boole,
    ls_message         type bapiret2.
  field-symbols:
    <address>          like line of i_partner-central_data-address-addresses.
  constants:
    currently_valid    like <address>-currently_valid value 'X',
    newly_valid        like <address>-currently_valid value 'I'.

  check c_errors-is_error = false.

  lv_obj_task = i_partner-header-object_task.
  if i_partner-central_data-address-current_state = true.
    lv_obj_task = task_current_state.
  endif.

  loop at i_partner-central_data-address-addresses assigning <address>
    where ( currently_valid  = currently_valid or
            currently_valid  = newly_valid )
      and data-postal-data-standardaddress = true
      and ( task = task_insert or
            ( data-postal-data-standardaddress = true and
              ( task = task_modify or task = task_update ) ) ).
    exit.
  endloop.
  if <address> is not assigned.
     if sy-datum <> sy-datlo.
       loop at i_partner-central_data-address-addresses assigning <address>
         where data-postal-data-validfromdate = sy-datlo
         and ( task = task_insert or task = task_modify or task = task_update ).
         endloop.
      endif.
   endif.

  if ( lv_obj_task = task_update or
       lv_obj_task = task_modify or
       lv_obj_task = task_time ) and
      <address> is not assigned.

    read table i_partner-central_data-address-addresses assigning <address>
      with key currently_valid                  = true
               data-postal-data-standardaddress = true
               task                             = task_delete.

    if <address> is not assigned.
         ls_message = fsbp_generic_services=>new_message(
        i_class_id  = 'CVI_MAPPING'
        i_type      = fsbp_generic_services=>msg_warning
        i_number    = '046'
      ).
      append ls_message to c_errors-messages.
      return.
    else.
      unassign <address>.
    endif.
  elseif <address> is not assigned.
    ls_message = fsbp_generic_services=>new_message(
    i_class_id  = 'CVI_MAPPING'
    i_type      = fsbp_generic_services=>msg_warning
    i_number    = '046'
    ).
    append ls_message to c_errors-messages.
    return.
  endif.

  if <address> is assigned.
    c_address-task = task_modify.
    move-corresponding:
      <address>-data-postal         to c_address-postal,    "#EC ENHOK
      <address>-data-remark         to c_address-remark.    "#EC ENHOK

    IF cl_vs_switch_check=>cmd_vmd_tr_sfw_01( ) IS NOT INITIAL.
      move <address>-data-postal-data-county to c_address-postal-data-county.
      move <address>-data-postal-data-county_no to c_address-postal-data-county_code.
      move <address>-data-postal-data-township to c_address-postal-data-township.
      move <address>-data-postal-data-township_no to c_address-postal-data-township_code.
    ENDIF.

* check if busines partner is of type 'Person'
* if yes, then assign language from common structure
    IF i_partner-central_data-common-data-bp_control-category = '1'.
      c_address-postal-DATA-langu_iso =
        i_partner-central_data-common-data-bp_person-correspondlanguageiso.
      c_address-postal-DATAX-langu_iso =
        i_partner-central_data-common-datax-bp_person-correspondlanguageiso.
*assign langu field
      c_address-postal-DATA-langu =
        i_partner-central_data-common-data-bp_person-correspondlanguage.
      c_address-postal-DATAX-langu =
        i_partner-central_data-common-datax-bp_person-correspondlanguage.
    ELSE.
      c_address-postal-data-langu_iso  = <address>-data-postal-data-languiso.
      c_address-postal-datax-langu_iso = <address>-data-postal-datax-langu_iso.
    ENDIF.

    map_bp_version(
      exporting
        i_bp_version  = <address>-data-version
      importing
        e_cvi_version = c_address-version
        ).

    map_bp_communication(
       exporting
         i_bp_communication  = <address>-data-communication
       importing
         e_cvi_communication = c_address-communication
     ).
*    only change of standardaddress
    lv_mark_all = true.
  else.
*    deletion
    lv_mark_all = true.
  endif.

* special check for postal code data
* if one of the postal field's (POSTL_COD2 , POSTL_COD3 , PO_BOX)
* datax is set, then set datax for all the other postal fields

  IF c_address-postal-datax-postl_cod2 = 'X'
    OR c_address-postal-datax-postl_cod3 = 'X'
    OR c_address-postal-datax-po_box = 'X'.

    c_address-postal-datax-postl_cod2 = 'X'.
    c_address-postal-datax-postl_cod3 = 'X'.
    c_address-postal-datax-po_box     = 'X'.
  ENDIF.

  check lv_mark_all = true.
  translate c_address-postal-datax using ' X'.
  c_address-remark-current_state =
  c_address-communication-phone-current_state =
  c_address-communication-fax-current_state =
  c_address-communication-ttx-current_state =
  c_address-communication-tlx-current_state =
  c_address-communication-smtp-current_state =
  c_address-communication-rml-current_state =
  c_address-communication-x400-current_state =
  c_address-communication-rfc-current_state =
  c_address-communication-prt-current_state =
  c_address-communication-ssf-current_state =
  c_address-communication-uri-current_state =
  c_address-communication-pager-current_state =
  c_address-version-current_state = true.

endmethod.


method map_bp_version.

  data:
    lv_person_name(81) type c,
    ls_cvi_versions    type cvi_ei_version_type1,
    ls_cvi_vers        type cvis_ei_cvi_version1,
    ls_bp_versions     type bus_ei_bupa_version.

  move i_bp_version-current_state to ls_cvi_vers-current_state.
  loop at i_bp_version-versions into ls_bp_versions.
    move ls_bp_versions-task             to ls_cvi_versions-task.
    if ls_bp_versions-data-organization  is not initial or
       ls_bp_versions-datax-organization is not initial.
      move-corresponding:
       ls_bp_versions-data-organization  to ls_cvi_versions-data,
       ls_bp_versions-datax-organization to ls_cvi_versions-datax.
    elseif ls_bp_versions-data-person  is not initial or
           ls_bp_versions-datax-person is not initial.
      move-corresponding:
       ls_bp_versions-data-person        to ls_cvi_versions-data,
       ls_bp_versions-datax-person       to ls_cvi_versions-datax.

       ls_cvi_versions-data-title = ls_bp_versions-data-person-title_p.
       ls_cvi_versions-data-sort1 = ls_bp_versions-data-person-sort1_p.
       ls_cvi_versions-data-sort2 = ls_bp_versions-data-person-sort2_p.

       ls_cvi_versions-datax-title = ls_bp_versions-datax-person-title_p.
       ls_cvi_versions-datax-sort1 = ls_bp_versions-datax-person-sort1_p.
       ls_cvi_versions-datax-sort2 = ls_bp_versions-datax-person-sort2_p.

      concatenate
        ls_bp_versions-data-person-firstname
        ls_bp_versions-data-person-lastname
        into lv_person_name
        in character mode separated by space respecting blanks.
      condense lv_person_name.

      if lv_person_name+40(40) is initial.
        ls_cvi_versions-data-name    = lv_person_name.
        ls_cvi_versions-data-name_2  = space.
      else.
        ls_cvi_versions-data-name    = ls_bp_versions-data-person-firstname.
        ls_cvi_versions-data-name_2  = ls_bp_versions-data-person-lastname.
      endif.
      ls_cvi_versions-datax-name   = ls_bp_versions-datax-person-firstname.
      ls_cvi_versions-datax-name_2 = ls_bp_versions-datax-person-lastname.

    endif.
    append ls_cvi_versions to ls_cvi_vers-versions.
    clear ls_cvi_versions.
  endloop.

  e_cvi_version = ls_cvi_vers.

endmethod.


method map_bp_version_to_cc.

  data:
    lr_data         type ref to data.
  field-symbols:
    <bp_versions>   type bus_ei_bupa_version,
    <cvi_versions>  type any,
    <versions>      type standard table,
    <versions_line> type any,
    <target>        type any.

  create data lr_data like e_cvi_version.
  assign lr_data->* to <cvi_versions>.
  assign component 'VERSIONS' of structure <cvi_versions> to <versions>.
  create data lr_data like line of <versions>.
  assign lr_data->* to <versions_line>.

  assign component 'CURRENT_STATE' of structure <cvi_versions> to <target>.
  move i_bp_version-current_state to <target>.
  unassign <target>.
  loop at i_bp_version-versions assigning <bp_versions>.
    assign component 'TASK' of structure <versions_line> to <target>.
    move <bp_versions>-task to <target>.
    unassign <target>.
    if <bp_versions>-data-organization  is not initial or
       <bp_versions>-datax-organization is not initial.
      assign component 'DATA' of structure <versions_line> to <target>.
      move-corresponding <bp_versions>-data-organization  to <target>.
      unassign <target>.
      assign component 'DATAX' of structure <versions_line> to <target>.
      move-corresponding <bp_versions>-datax-organization  to <target>.
      unassign <target>.
    elseif <bp_versions>-data-person  is not initial or
           <bp_versions>-datax-person is not initial.
      assign component 'DATA' of structure <versions_line> to <target>.
      move-corresponding <bp_versions>-data-person  to <target>.
      unassign <target>.
      assign component 'DATAX' of structure <versions_line> to <target>.
      move-corresponding <bp_versions>-datax-person  to <target>.
      unassign <target>.
      append <versions_line> to <versions>.
    endif.
  endloop.

  e_cvi_version = <cvi_versions>.

endmethod.


method map_contact_version.

  data:
    ls_bp_vers      type bus_ei_version,
    ls_bp_versions  type bus_ei_bupa_version.
  field-symbols:
    <versions>      type standard table,
    <versions_line> type any,
    <target>        type any.

  assign component 'VERSIONS' of structure i_contact_version to <versions>.
  assign component 'CURRENT_STATE' of structure i_contact_version to <target>.
  ls_bp_vers-current_state = <target>.
  unassign <target>.

  loop at <versions> assigning <versions_line>.
    assign component 'TASK' of structure <versions_line> to <target>.
    ls_bp_versions-task = <target>.
    unassign <target>.
    assign component 'DATA' of structure <versions_line> to <target>.
    move-corresponding:
     <target>  to ls_bp_versions-data-organization,
     <target>  to ls_bp_versions-data-person.
    unassign <target>.
    assign component 'DATAX' of structure <versions_line> to <target>.
    move-corresponding:
     <target>  to ls_bp_versions-datax-organization,
     <target>  to ls_bp_versions-datax-person.
    unassign <target>.
    append ls_bp_versions to ls_bp_vers-versions.
    clear ls_bp_versions.
  endloop.

  e_bp_version = ls_bp_vers.

endmethod.


method map_contact_version_to_rel.

  data:
    ls_bp_vers      type burs_ei_bupa_version_data,
    ls_bp_versions  type burs_ei_bupa_version.
  field-symbols:
    <versions>      type any table,
    <versions_line> type any,
    <target>        type any.

  assign component 'VERSIONS' of structure i_contact_version to <versions>.
  assign component 'CURRENT_STATE' of structure i_contact_version to <target>.
  move <target> to ls_bp_vers-current_state.
  unassign <target>.

  loop at <versions> assigning <versions_line>.
    assign component 'TASK' of structure <versions_line> to <target>.
    move <target> to ls_bp_versions-task.
    unassign <target>.
    assign component 'DATA' of structure <versions_line> to <target>.
    move-corresponding:
     <target>  to ls_bp_versions-data.
    unassign <target>.
    assign component 'DATAX' of structure <versions_line> to <target>.
    move-corresponding:
     <target>  to ls_bp_versions-datax.
    unassign <target>.
    append ls_bp_versions to ls_bp_vers-versions.
    clear ls_bp_versions.
  endloop.

  e_rel_version = ls_bp_vers.

endmethod.


method MAP_CV_COMMUNICATION .

  data:
  ls_vend_remark type cvis_ei_comrem,
  ls_vend_phone  type cvis_ei_phone_str,
  ls_vend_fax    type cvis_ei_fax_str,
  ls_vend_ttx    type cvis_ei_ttx_str,
  ls_vend_tlx    type cvis_ei_tlx_str,
  ls_vend_smtp   type cvis_ei_smtp_str,
  ls_vend_rml    type cvis_ei_rml_str,
  ls_vend_x400   type cvis_ei_x400_str,
  ls_vend_rfc    type cvis_ei_rfc_str,
  ls_vend_prt    type cvis_ei_prt_str,
  ls_vend_ssf    type cvis_ei_ssf_str,
  ls_vend_uri    type cvis_ei_uri_str,
  ls_vend_pager  type cvis_ei_pag_str,
  ls_vend_comm   type cvis_ei_cvi_communication,

  ls_part_remark type bus_ei_bupa_comrem,
  ls_part_phone  type bus_ei_bupa_telephone,
  ls_part_fax    type bus_ei_bupa_fax,
  ls_part_ttx    type bus_ei_bupa_ttx,
  ls_part_tlx    type bus_ei_bupa_tlx,
  ls_part_smtp   type bus_ei_bupa_smtp,
  ls_part_rml    type bus_ei_bupa_rml,
  ls_part_x400   type bus_ei_bupa_x400,
  ls_part_rfc    type bus_ei_bupa_rfc,
  ls_part_prt    type bus_ei_bupa_prt,
  ls_part_ssf    type bus_ei_bupa_ssf,
  ls_part_uri    type bus_ei_bupa_uri,
  ls_part_pager  type bus_ei_bupa_pag,
  ls_part_comm   type bus_ei_communication.

  ls_vend_comm = i_cvi_communication.

* PHONE
  move ls_vend_comm-phone-current_state to ls_part_comm-phone-current_state.
  loop at ls_vend_comm-phone-phone into ls_vend_phone.
    move ls_vend_phone-contact              to ls_part_phone-contact.
    move ls_vend_phone-remark-current_state to ls_part_phone-remark-current_state.
    loop at ls_vend_phone-remark-remarks into ls_vend_remark.
      move ls_vend_remark-task to ls_part_remark-task.
      move ls_vend_remark-data-langu       to ls_part_remark-data-langu.
      move ls_vend_remark-data-langu_iso   to ls_part_remark-data-langu_iso.
      move ls_vend_remark-data-comm_notes  to ls_part_remark-data-comm_notes.
      move ls_vend_remark-datax-langu      to ls_part_remark-datax-langu.
      move ls_vend_remark-datax-langu_iso  to ls_part_remark-datax-langu_iso.
      move ls_vend_remark-datax-comm_notes to ls_part_remark-datax-comm_notes.
      append ls_part_remark to ls_part_phone-remark-remarks.
    endloop.
    append ls_part_phone to ls_part_comm-phone-phone.
    clear ls_part_phone.
  endloop.
* FAX
  move ls_vend_comm-fax-current_state to ls_part_comm-fax-current_state.
  loop at ls_vend_comm-fax-fax into ls_vend_fax.
    move ls_vend_fax-contact              to ls_part_fax-contact.
    move ls_vend_fax-remark-current_state to ls_part_fax-remark-current_state.
    loop at ls_vend_fax-remark-remarks into ls_vend_remark.
      move ls_vend_remark-task to ls_part_remark-task.
      move ls_vend_remark-data-langu       to ls_part_remark-data-langu.
      move ls_vend_remark-data-langu_iso   to ls_part_remark-data-langu_iso.
      move ls_vend_remark-data-comm_notes  to ls_part_remark-data-comm_notes.
      move ls_vend_remark-datax-langu      to ls_part_remark-datax-langu.
      move ls_vend_remark-datax-langu_iso  to ls_part_remark-datax-langu_iso.
      move ls_vend_remark-datax-comm_notes to ls_part_remark-datax-comm_notes.
      append ls_part_remark to ls_part_fax-remark-remarks.
    endloop.
    append ls_part_fax to ls_part_comm-fax-fax.
    clear ls_part_fax.
  endloop.
* TTX
  move ls_vend_comm-ttx-current_state to ls_part_comm-ttx-current_state.
  loop at ls_vend_comm-ttx-ttx into ls_vend_ttx.
    move ls_vend_ttx-contact              to ls_part_ttx-contact.
    move ls_vend_ttx-remark-current_state to ls_part_ttx-remark-current_state.
    loop at ls_vend_ttx-remark-remarks into ls_vend_remark.
      move ls_vend_remark-task to ls_part_remark-task.
      move ls_vend_remark-data-langu       to ls_part_remark-data-langu.
      move ls_vend_remark-data-langu_iso   to ls_part_remark-data-langu_iso.
      move ls_vend_remark-data-comm_notes  to ls_part_remark-data-comm_notes.
      move ls_vend_remark-datax-langu      to ls_part_remark-datax-langu.
      move ls_vend_remark-datax-langu_iso  to ls_part_remark-datax-langu_iso.
      move ls_vend_remark-datax-comm_notes to ls_part_remark-datax-comm_notes.
      append ls_part_remark to ls_part_ttx-remark-remarks.
    endloop.
    append ls_part_ttx to ls_part_comm-ttx-ttx.
    clear ls_part_ttx.
  endloop.
* TLX
  move ls_vend_comm-tlx-current_state to ls_part_comm-tlx-current_state.
  loop at ls_vend_comm-tlx-tlx into ls_vend_tlx.
    move ls_vend_tlx-contact              to ls_part_tlx-contact.
    move ls_vend_tlx-remark-current_state to ls_part_tlx-remark-current_state.
    loop at ls_vend_tlx-remark-remarks into ls_vend_remark.
      move ls_vend_remark-task to ls_part_remark-task.
      move ls_vend_remark-data-langu       to ls_part_remark-data-langu.
      move ls_vend_remark-data-langu_iso   to ls_part_remark-data-langu_iso.
      move ls_vend_remark-data-comm_notes  to ls_part_remark-data-comm_notes.
      move ls_vend_remark-datax-langu      to ls_part_remark-datax-langu.
      move ls_vend_remark-datax-langu_iso  to ls_part_remark-datax-langu_iso.
      move ls_vend_remark-datax-comm_notes to ls_part_remark-datax-comm_notes.
      append ls_part_remark to ls_part_tlx-remark-remarks.
    endloop.
    append ls_part_tlx to ls_part_comm-tlx-tlx.
    clear ls_part_tlx.
  endloop.
* SMTP
  move ls_vend_comm-smtp-current_state to ls_part_comm-smtp-current_state.
  loop at ls_vend_comm-smtp-smtp into ls_vend_smtp.
    move ls_vend_smtp-contact              to ls_part_smtp-contact.
    move ls_vend_smtp-remark-current_state to ls_part_smtp-remark-current_state.
    loop at ls_vend_smtp-remark-remarks into ls_vend_remark.
      move ls_vend_remark-task to ls_part_remark-task.
      move ls_vend_remark-data-langu       to ls_part_remark-data-langu.
      move ls_vend_remark-data-langu_iso   to ls_part_remark-data-langu_iso.
      move ls_vend_remark-data-comm_notes  to ls_part_remark-data-comm_notes.
      move ls_vend_remark-datax-langu      to ls_part_remark-datax-langu.
      move ls_vend_remark-datax-langu_iso  to ls_part_remark-datax-langu_iso.
      move ls_vend_remark-datax-comm_notes to ls_part_remark-datax-comm_notes.
      append ls_part_remark to ls_part_smtp-remark-remarks.
    endloop.
    append ls_part_smtp to ls_part_comm-smtp-smtp.
    clear ls_part_smtp.
  endloop.
* RML
  move ls_vend_comm-rml-current_state to ls_part_comm-rml-current_state.
  loop at ls_vend_comm-rml-rml into ls_vend_rml.
    move ls_vend_rml-contact              to ls_part_rml-contact.
    move ls_vend_rml-remark-current_state to ls_part_rml-remark-current_state.
    loop at ls_vend_rml-remark-remarks into ls_vend_remark.
      move ls_vend_remark-task to ls_part_remark-task.
      move ls_vend_remark-data-langu       to ls_part_remark-data-langu.
      move ls_vend_remark-data-langu_iso   to ls_part_remark-data-langu_iso.
      move ls_vend_remark-data-comm_notes  to ls_part_remark-data-comm_notes.
      move ls_vend_remark-datax-langu      to ls_part_remark-datax-langu.
      move ls_vend_remark-datax-langu_iso  to ls_part_remark-datax-langu_iso.
      move ls_vend_remark-datax-comm_notes to ls_part_remark-datax-comm_notes.
      append ls_part_remark to ls_part_rml-remark-remarks.
    endloop.
    append ls_part_rml to ls_part_comm-rml-rml.
    clear ls_part_smtp.
  endloop.
* X400
  move ls_vend_comm-x400-current_state to ls_part_comm-x400-current_state.
  loop at ls_vend_comm-x400-x400 into ls_vend_x400.
    move ls_vend_x400-contact              to ls_part_x400-contact.
    move ls_vend_x400-remark-current_state to ls_part_x400-remark-current_state.
    loop at ls_vend_x400-remark-remarks into ls_vend_remark.
      move ls_vend_remark-task to ls_part_remark-task.
      move ls_vend_remark-data-langu       to ls_part_remark-data-langu.
      move ls_vend_remark-data-langu_iso   to ls_part_remark-data-langu_iso.
      move ls_vend_remark-data-comm_notes  to ls_part_remark-data-comm_notes.
      move ls_vend_remark-datax-langu      to ls_part_remark-datax-langu.
      move ls_vend_remark-datax-langu_iso  to ls_part_remark-datax-langu_iso.
      move ls_vend_remark-datax-comm_notes to ls_part_remark-datax-comm_notes.
      append ls_part_remark to ls_part_x400-remark-remarks.
    endloop.
    append ls_part_x400 to ls_part_comm-x400-x400.
    clear ls_part_x400.
  endloop.
* RFC
  move ls_vend_comm-rfc-current_state to ls_part_comm-rfc-current_state.
  loop at ls_vend_comm-rfc-rfc into ls_vend_rfc.
    move ls_vend_rfc-contact              to ls_part_rfc-contact.
    move ls_vend_rfc-remark-current_state to ls_part_rfc-remark-current_state.
    loop at ls_vend_rfc-remark-remarks into ls_vend_remark.
      move ls_vend_remark-task to ls_part_remark-task.
      move ls_vend_remark-data-langu       to ls_part_remark-data-langu.
      move ls_vend_remark-data-langu_iso   to ls_part_remark-data-langu_iso.
      move ls_vend_remark-data-comm_notes  to ls_part_remark-data-comm_notes.
      move ls_vend_remark-datax-langu      to ls_part_remark-datax-langu.
      move ls_vend_remark-datax-langu_iso  to ls_part_remark-datax-langu_iso.
      move ls_vend_remark-datax-comm_notes to ls_part_remark-datax-comm_notes.
      append ls_part_remark to ls_part_rfc-remark-remarks.
    endloop.
    append ls_part_rfc to ls_part_comm-rfc-rfc.
    clear ls_part_rfc.
  endloop.
* PRT
  move ls_vend_comm-prt-current_state to ls_part_comm-prt-current_state.
  loop at ls_vend_comm-prt-prt into ls_vend_prt.
    move ls_vend_prt-contact              to ls_part_prt-contact.
    move ls_vend_prt-remark-current_state to ls_part_prt-remark-current_state.
    loop at ls_vend_prt-remark-remarks into ls_vend_remark.
      move ls_vend_remark-task to ls_part_remark-task.
      move ls_vend_remark-data-langu       to ls_part_remark-data-langu.
      move ls_vend_remark-data-langu_iso   to ls_part_remark-data-langu_iso.
      move ls_vend_remark-data-comm_notes  to ls_part_remark-data-comm_notes.
      move ls_vend_remark-datax-langu      to ls_part_remark-datax-langu.
      move ls_vend_remark-datax-langu_iso  to ls_part_remark-datax-langu_iso.
      move ls_vend_remark-datax-comm_notes to ls_part_remark-datax-comm_notes.
      append ls_part_remark to ls_part_prt-remark-remarks.
    endloop.
    append ls_part_prt to ls_part_comm-prt-prt.
    clear ls_part_rfc.
  endloop.
* SSF
  move ls_vend_comm-ssf-current_state to ls_part_comm-ssf-current_state.
  loop at ls_vend_comm-ssf-ssf into ls_vend_ssf.
    move ls_vend_ssf-contact              to ls_part_ssf-contact.
    move ls_vend_ssf-remark-current_state to ls_part_ssf-remark-current_state.
    loop at ls_vend_ssf-remark-remarks into ls_vend_remark.
      move ls_vend_remark-task to ls_part_remark-task.
      move ls_vend_remark-data-langu       to ls_part_remark-data-langu.
      move ls_vend_remark-data-langu_iso   to ls_part_remark-data-langu_iso.
      move ls_vend_remark-data-comm_notes  to ls_part_remark-data-comm_notes.
      move ls_vend_remark-datax-langu      to ls_part_remark-datax-langu.
      move ls_vend_remark-datax-langu_iso  to ls_part_remark-datax-langu_iso.
      move ls_vend_remark-datax-comm_notes to ls_part_remark-datax-comm_notes.
      append ls_part_remark to ls_part_ssf-remark-remarks.
    endloop.
    append ls_part_ssf to ls_part_comm-ssf-ssf.
    clear ls_part_ssf.
  endloop.
* URI
  move ls_vend_comm-uri-current_state to ls_part_comm-uri-current_state.
  loop at ls_vend_comm-uri-uri into ls_vend_uri.
    move ls_vend_uri-contact              to ls_part_uri-contact.
    move ls_vend_uri-remark-current_state to ls_part_uri-remark-current_state.
    loop at ls_vend_uri-remark-remarks into ls_vend_remark.
      move ls_vend_remark-task to ls_part_remark-task.
      move ls_vend_remark-data-langu       to ls_part_remark-data-langu.
      move ls_vend_remark-data-langu_iso   to ls_part_remark-data-langu_iso.
      move ls_vend_remark-data-comm_notes  to ls_part_remark-data-comm_notes.
      move ls_vend_remark-datax-langu      to ls_part_remark-datax-langu.
      move ls_vend_remark-datax-langu_iso  to ls_part_remark-datax-langu_iso.
      move ls_vend_remark-datax-comm_notes to ls_part_remark-datax-comm_notes.
      append ls_part_remark to ls_part_uri-remark-remarks.
    endloop.
    append ls_part_uri to ls_part_comm-uri-uri.
    clear ls_part_uri.
  endloop.
* PAGER
  move ls_vend_comm-pager-current_state to ls_part_comm-pager-current_state.
  loop at ls_vend_comm-pager-pager into ls_vend_pager.
    move ls_vend_pager-contact              to ls_part_pager-contact.
    move ls_vend_pager-remark-current_state to ls_part_pager-remark-current_state.
    loop at ls_vend_pager-remark-remarks into ls_vend_remark.
      move ls_vend_remark-task to ls_part_remark-task.
      move ls_vend_remark-data-langu       to ls_part_remark-data-langu.
      move ls_vend_remark-data-langu_iso   to ls_part_remark-data-langu_iso.
      move ls_vend_remark-data-comm_notes  to ls_part_remark-data-comm_notes.
      move ls_vend_remark-datax-langu      to ls_part_remark-datax-langu.
      move ls_vend_remark-datax-langu_iso  to ls_part_remark-datax-langu_iso.
      move ls_vend_remark-datax-comm_notes to ls_part_remark-datax-comm_notes.
      append ls_part_remark to ls_part_pager-remark-remarks.
    endloop.
    append ls_part_pager to ls_part_comm-pager-pager.
    clear ls_part_pager.
  endloop.

  e_bp_communication = ls_part_comm.

endmethod.


method map_cv_version.

  data:
    ls_cvi_versions type cvi_ei_version_type1,
    ls_bp_vers      type bus_ei_version,
    ls_bp_versions  type bus_ei_bupa_version.

  move i_cvi_version-current_state to ls_bp_vers-current_state.
  loop at i_cvi_version-versions into ls_cvi_versions.
    move ls_cvi_versions-task to ls_bp_versions-task.
    move-corresponding:
     ls_cvi_versions-data  to ls_bp_versions-data-organization,
     ls_cvi_versions-datax to ls_bp_versions-datax-organization,
     ls_cvi_versions-data  to ls_bp_versions-data-person,
     ls_cvi_versions-datax to ls_bp_versions-datax-person.
*data fields for person structure
    ls_bp_versions-data-person-title_p = ls_cvi_versions-data-title.
    ls_bp_versions-data-person-firstname = ls_cvi_versions-data-name.
    ls_bp_versions-data-person-lastname = ls_cvi_versions-data-name_2.
    ls_bp_versions-data-person-sort1_p = ls_cvi_versions-data-sort1.
    ls_bp_versions-data-person-sort2_p = ls_cvi_versions-data-sort2.
*datax fields for person structure
    ls_bp_versions-datax-person-title_p = ls_cvi_versions-datax-title.
    ls_bp_versions-datax-person-firstname = ls_cvi_versions-datax-name.
    ls_bp_versions-datax-person-lastname = ls_cvi_versions-datax-name_2.
    ls_bp_versions-datax-person-sort1_p = ls_cvi_versions-datax-sort1.
    ls_bp_versions-datax-person-sort2_p = ls_cvi_versions-datax-sort2.
    append ls_bp_versions to ls_bp_vers-versions.
    clear ls_bp_versions.
  endloop.

  e_bp_version = ls_bp_vers.

endmethod.


method map_rel_version.

  data:
    lr_data         type ref to data.
  field-symbols:
    <rel_versions>  type burs_ei_bupa_version,
    <cvi_versions>  type any,
    <versions>      type standard table,
    <versions_line> type any,
    <target>        type any.

  create data lr_data like e_cvi_version.
  assign lr_data->* to <cvi_versions>.
  assign component 'VERSIONS' of structure <cvi_versions> to <versions>.
  create data lr_data like line of <versions>.
  assign lr_data->* to <versions_line>.

  assign component 'CURRENT_STATE' of structure <cvi_versions> to <target>.
  move i_rel_version-current_state to <target>.
  unassign <target>.
  loop at i_rel_version-versions assigning <rel_versions>.
    assign component 'TASK' of structure <versions_line> to <target>.
    move <rel_versions>-task to <target>.
    unassign <target>.
    if <rel_versions>-data  is not initial or
       <rel_versions>-datax is not initial.
      assign component 'DATA' of structure <versions_line> to <target>.
      move-corresponding <rel_versions>-data  to <target>.
      unassign <target>.
      assign component 'DATAX' of structure <versions_line> to <target>.
      move-corresponding <rel_versions>-datax  to <target>.
      unassign <target>.
      append <versions_line> to <versions>.
    endif.
  endloop.

  e_cvi_version = <cvi_versions>.

endmethod.


method READ_ALL_BP_BANKDETAILS.

  data:
    lt_bankdetail   type buss_bankdetail_t,
    ls_bankdetail   like line of lt_bankdetail,
    lv_partner_id   type bu_partner,
    lv_partner_guid type bu_partner_guid.

*------ BAPI-GUID in internes Format konvertieren ----------------------
  move i_partner_guid to lv_partner_guid.

  call function 'BUPA_NUMBERS_GET'
    exporting
      iv_partner_guid = lv_partner_guid
    importing
      ev_partner      = lv_partner_id
    exceptions
      others          = 0.


  ls_bankdetail-header-object_instance-bpartnerguid = i_partner_guid.
  ls_bankdetail-header-object_instance-bpartner     = lv_partner_id.
  ls_bankdetail-bankdetail-bankdetails              = i_bankdetails.
  append ls_bankdetail to lt_bankdetail.

  call method cl_bupa_current_data=>get_bankdetail
    exporting
      it_bankdetail = lt_bankdetail
    importing
      et_bankdetail = lt_bankdetail
      es_error      = e_errors.
  check e_errors-is_error = false and
        lt_bankdetail[] is not initial.

  read table lt_bankdetail into ls_bankdetail index 1.
  e_bankdetails[] = ls_bankdetail-bankdetail-bankdetails[].

endmethod.


method read_all_bp_tax_numbers .

  data:
    lt_taxnumber type buss_taxnumber_t,
    ls_taxnumber like line of lt_taxnumber.

  ls_taxnumber-header    = i_partner-header.
  ls_taxnumber-taxnumber = i_partner-central_data-taxnumber.
  append ls_taxnumber to lt_taxnumber.

  cl_bupa_current_data=>get_taxnumber(
    exporting
      it_taxnumber = lt_taxnumber
    importing
      et_taxnumber = lt_taxnumber
      es_error     = e_errors
  ).

  check e_errors-is_error = false and
        lt_taxnumber[] is not initial.

  read table lt_taxnumber into ls_taxnumber index 1.
  e_tax_numbers[] = ls_taxnumber-taxnumber-taxnumbers[].

endmethod.
ENDCLASS.
