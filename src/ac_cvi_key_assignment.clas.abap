class AC_CVI_KEY_ASSIGNMENT definition
  public
  abstract
  create public .

*"* public components of class AC_CVI_KEY_ASSIGNMENT
*"* do not include other source files here!!!
public section.

  interfaces IF_UKM_EASY .

  constants FALSE type BOOLE-BOOLE value SPACE. "#EC NOTEXT
  constants NROBJ_CUSTOMER type NROBJ value 'DEBITOR'. "#EC NOTEXT
  constants NROBJ_PARTNER type NROBJ value 'BU_PARTNER'. "#EC NOTEXT
  constants NROBJ_VENDOR type NROBJ value 'KREDITOR'. "#EC NOTEXT
  constants REQ_STATUS_NOT_REQ type CVI_REQ_STATUS value 'N'. "#EC NOTEXT
  constants REQ_STATUS_OPTIONAL type CVI_REQ_STATUS value 'O'. "#EC NOTEXT
  constants REQ_STATUS_REQUIRED type CVI_REQ_STATUS value 'R'. "#EC NOTEXT
  constants REQ_STATUS_SENDER type CVI_REQ_STATUS value 'S'. "#EC NOTEXT
  constants TRUE type BOOLE-BOOLE value 'X'. "#EC NOTEXT
  constants UKM_OBJECT_CUSTOMER type MDS_CTRL_OBJECT value 'CUSTOMER'. "#EC NOTEXT
  constants UKM_OBJECT_PARTNER type MDS_CTRL_OBJECT value 'BP'. "#EC NOTEXT
  constants UKM_OBJECT_VENDOR type MDS_CTRL_OBJECT value 'VENDOR'. "#EC NOTEXT

  methods FLUSH_ASSIGNMENTS
  abstract .
  methods GET_NRIV
    returning
      value(R_NRIV) type CVIS_NRIV_T .
  methods GET_NRIV_LINE
    importing
      !I_OBJECT_TYPE type NROBJ
      !I_NUMBER_RANGE type NRNR
    returning
      value(R_NRIV) type NRIV .
  methods GET_NRIV_TYPE
    importing
      !I_OBJECT_TYPE type NROBJ
      !I_NUMBER_RANGE type NRNR
    returning
      value(R_NRIV_TYPE) type NRIND .
  methods GET_PARTNER_GUID
    importing
      value(I_PARTNER_ID) type BU_PARTNER
    returning
      value(R_PARTNER_GUID) type BU_PARTNER_GUID .
  methods GET_PARTNER_ID
    importing
      !I_PARTNER_GUID type BU_PARTNER_GUID
    returning
      value(R_PARTNER_ID) type BU_PARTNER .
  methods IS_STRATEGY_ACTIVE
    importing
      !I_SOURCE_OBJECT type MDS_CTRL_OBJ_SOURCE
      !I_TARGET_OBJECT type MDS_CTRL_OBJ_TARGET
    returning
      value(R_RESULT) type BOOLE-BOOLE .
  methods NEW_PARTNER_ID
  final
    returning
      value(R_PARTNER_GUID) type BU_PARTNER_GUID .
protected section.
*"* protected components of class AC_CVI_KEY_ASSIGNMENT
*"* do not include other source files here!!!

  methods INITIALIZE_CUSTOMIZING .
  methods IS_CUSTOMIZING_READ
  final
    returning
      value(R_RESULT) type BOOLE-BOOLE .
private section.
*"* private components of class AC_CVI_KEY_ASSIGNMENT
*"* do not include other source files here!!!

  data CUSTOMIZING_READ type BOOLE-BOOLE .
  data MEM_NRIV type CVIS_NRIV_T .
  data MEM_STRATEGIES type MDS_CTRLS_SYNC_OPT_ACT .
ENDCLASS.



CLASS AC_CVI_KEY_ASSIGNMENT IMPLEMENTATION.


method get_nriv.

  if customizing_read is initial.
    initialize_customizing( ).
  endif.
  r_nriv[] = mem_nriv[].

endmethod.


method get_nriv_line.

  assert:
    i_object_type  is not initial,
    i_number_range is not initial.

  get_nriv( ).

  read table mem_nriv into r_nriv
    with key object    = i_object_type
             subobject = ' '
             nrrangenr = i_number_range
             toyear    = '0000'.

endmethod.


method get_nriv_type .

  data:
    ls_nriv type nriv.

  ls_nriv = get_nriv_line(
    i_object_type  = i_object_type
    i_number_range = i_number_range
  ).
  r_nriv_type = ls_nriv-externind.

endmethod.


method get_partner_guid.

  call function 'BUPA_NUMBERS_GET'
    exporting
      iv_partner      = i_partner_id
    importing
      ev_partner_guid = r_partner_guid
    exceptions
      others          = 0.

endmethod.


method get_partner_id.

  call function 'BUPA_NUMBERS_GET'
    exporting
      iv_partner_guid = i_partner_guid
    importing
      ev_partner      = r_partner_id
    exceptions
      others          = 0.

endmethod.


method if_ukm_easy~add.

  data
    ls_message type bapiret2.

  es_messages-general_message-message_type_indicator-type_warning = true.
  ls_message = fsbp_generic_services=>new_message(
    i_class_id  = cvi_mapper=>if_cvi_common_constants~msg_class_cvi
    i_type      = fsbp_generic_services=>msg_warning
    i_number    = '015'
  ).
  append ls_message to es_messages-general_message-messages.

endmethod.


method if_ukm_easy~cleanup.

  data
    ls_message type bapiret2.

  es_message-message_type_indicator-type_warning = true.
  ls_message = fsbp_generic_services=>new_message(
    i_class_id  = cvi_mapper=>if_cvi_common_constants~msg_class_cvi
    i_type      = fsbp_generic_services=>msg_warning
    i_number    = '015'
  ).
  append ls_message to es_message-messages.

endmethod.


method if_ukm_easy~delete.

  data
    ls_message type bapiret2.

  es_messages-general_message-message_type_indicator-type_warning = true.
  ls_message = fsbp_generic_services=>new_message(
    i_class_id  = cvi_mapper=>if_cvi_common_constants~msg_class_cvi
    i_type      = fsbp_generic_services=>msg_warning
    i_number    = '015'
  ).
  append ls_message to es_messages-general_message-messages.

endmethod.


method if_ukm_easy~get.

  data
    ls_message type bapiret2.

  es_messages-general_message-message_type_indicator-type_warning = true.
  ls_message = fsbp_generic_services=>new_message(
    i_class_id  = cvi_mapper=>if_cvi_common_constants~msg_class_cvi
    i_type      = fsbp_generic_services=>msg_warning
    i_number    = '015'
  ).
  append ls_message to es_messages-general_message-messages.

endmethod.


method if_ukm_easy~save.


  data
        ls_message type bapiret2.

  es_message-message_type_indicator-type_warning = true.
  ls_message = fsbp_generic_services=>new_message(
    i_class_id  = cvi_mapper=>if_cvi_common_constants~msg_class_cvi
    i_type      = fsbp_generic_services=>msg_warning
    i_number    = '015'
  ).
  append ls_message to es_message-messages.

endmethod.


method initialize_customizing.

  check customizing_read = false.

  select * from mdsc_ctrl_opt_a into table mem_strategies.

  IF mem_strategies[] IS NOT INITIAL.
    select *
      from nriv
      into table mem_nriv
     where object = nrobj_customer or
           object = nrobj_vendor   or
           object = nrobj_partner.

     customizing_read = true.
  ENDIF.


endmethod.


method is_customizing_read.

  r_result = customizing_read.

endmethod.


method is_strategy_active.

  initialize_customizing( ).
  read table mem_strategies transporting no fields
  with key sync_obj_source  = i_source_object
           sync_obj_target  = i_target_object
           active_indicator = true.
  check sy-subrc = 0.
  r_result = true.

endmethod.


method new_partner_id.

  call function 'GUID_CREATE'
    importing
      ev_guid_16 = r_partner_guid.

endmethod.
ENDCLASS.
