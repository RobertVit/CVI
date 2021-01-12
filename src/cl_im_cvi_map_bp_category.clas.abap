class CL_IM_CVI_MAP_BP_CATEGORY definition
  public
  final
  create public .

*"* public components of class CL_IM_CVI_MAP_BP_CATEGORY
*"* do not include other source files here!!!
public section.

  interfaces IF_CVI_COMMON_CONSTANTS .
  interfaces IF_EX_CVI_MAP_TITLE .
protected section.
*"* protected components of class CL_IM_CVI_MAP_BP_CATEGORY
*"* do not include other source files here!!!
private section.
*"* private components of class CL_IM_CVI_MAP_BP_CATEGORY
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
  aliases MAP_CUSTOMER_TITLE_BP_CHANGE
    for IF_EX_CVI_MAP_TITLE~MAP_CUSTOMER_TITLE_BP_CHANGE .
  aliases MAP_CUSTOMER_TITLE_BP_CREATE
    for IF_EX_CVI_MAP_TITLE~MAP_CUSTOMER_TITLE_BP_CREATE .
  aliases MAP_VENDOR_TITLE_BP_CHANGE
    for IF_EX_CVI_MAP_TITLE~MAP_VENDOR_TITLE_BP_CHANGE .
  aliases MAP_VENDOR_TITLE_BP_CREATE
    for IF_EX_CVI_MAP_TITLE~MAP_VENDOR_TITLE_BP_CREATE .
ENDCLASS.



CLASS CL_IM_CVI_MAP_BP_CATEGORY IMPLEMENTATION.


method if_ex_cvi_map_title~map_customer_title_bp_change.

  e_partner_title_key = i_customer_title.

endmethod.


method if_ex_cvi_map_title~map_customer_title_bp_create.

  data: ls_tsad3 type tsad3.

  e_partner_title_key = i_customer_title.

  select single * from tsad3 into ls_tsad3
    where title = i_customer_title.

  check sy-subrc = 0.

  if ls_tsad3-person = true and ls_tsad3-organizatn = false and ls_tsad3-xgroup = false.
    c_partner_category = bp_as_person.
  elseif ls_tsad3-person = false and ls_tsad3-organizatn = false and ls_tsad3-xgroup = true.
    c_partner_category = bp_as_group.
  endif.

endmethod.


method if_ex_cvi_map_title~map_vendor_title_bp_change.

  e_partner_title_key = i_vendor_title.

endmethod.


method if_ex_cvi_map_title~map_vendor_title_bp_create.

  data: ls_tsad3 type tsad3.

  e_partner_title_key = i_vendor_title.

  select single * from tsad3 into ls_tsad3
    where title = i_vendor_title.

  check sy-subrc = 0.

  if ls_tsad3-person = true and ls_tsad3-organizatn = false and ls_tsad3-xgroup = false.
    c_partner_category = bp_as_person.
  elseif ls_tsad3-person = false and ls_tsad3-organizatn = false and ls_tsad3-xgroup = true.
    c_partner_category = bp_as_group.
  endif.

endmethod.
ENDCLASS.
