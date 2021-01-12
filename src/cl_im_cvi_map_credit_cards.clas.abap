class CL_IM_CVI_MAP_CREDIT_CARDS definition
  public
  final
  create public .

*"* public components of class CL_IM_CVI_MAP_CREDIT_CARDS
*"* do not include other source files here!!!
public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_CVI_COMMON_CONSTANTS .
  interfaces IF_EX_CVI_MAP_CREDIT_CARDS .
protected section.
*"* protected components of class CL_IM_CVI_MAP_CREDIT_CARDS
*"* do not include other source files here!!!
private section.
*"* private components of class CL_IM_CVI_MAP_CREDIT_CARDS
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
  aliases IGNORE_DUPLICATES
    for IF_EX_CVI_MAP_CREDIT_CARDS~IGNORE_DUPLICATES .
  aliases MAP_BP_CREDIT_CARDS
    for IF_EX_CVI_MAP_CREDIT_CARDS~MAP_BP_CREDIT_CARDS .
  aliases MAP_CUSTOMER_CREDIT_CARDS
    for IF_EX_CVI_MAP_CREDIT_CARDS~MAP_CUSTOMER_CREDIT_CARDS .

  methods MAP_ENCRYPTED_CC_DATA
    importing
      !IV_CARD_GUID type CARD_GUID
      !IV_DEFAULT_CARD type BU_CCDEF
      !IV_TASK type CMD_EI_CREDITCARD_TASK optional
    changing
      !C_CUSTOMER_CREDIT_CARDS type CMDS_EI_CMD_CREDITCARD
      !C_ERRORS type CVIS_ERROR .
ENDCLASS.



CLASS CL_IM_CVI_MAP_CREDIT_CARDS IMPLEMENTATION.


method if_ex_cvi_map_credit_cards~ignore_duplicates.

  r_status = false.

endmethod.


method if_ex_cvi_map_credit_cards~map_bp_credit_cards.

  data:
    ls_creditcard  like line of e_customer_credit_cards-creditcard,
    ls_message     type bapiret2,
    lv_var1        type symsgv,
    ls_block_reason  type BUS_EI_BLOCKING_REASON,
    lt_block_reasons type BUS_EI_BUPA_BLOCKINGREASONS_T ,
    wa_block_reasons like line of lt_block_reasons,
    lv_cclock        type CC_LOCK.
  field-symbols:
    <paycard>      like line of i_partner_credit_cards-paycards.
 clear: ls_block_reason, lt_block_reasons, lv_cclock.
  e_customer_credit_cards-current_state = i_partner_credit_cards-current_state.

  loop at i_partner_credit_cards-paycards assigning <paycard>.

    case <paycard>-task.
      when '1' or 'I'.
        if <paycard>-data-valid_to ge sy-datlo.
          ls_creditcard-task = task_insert.
        else.
          continue.
        endif.
      when '2' or 'U'.
*        if <paycard>-data-valid_to ge sy-datlo. "all credit card details should be passed irrespective of validity.
          ls_creditcard-task = task_update.
*        else.
*          continue.
*        endif.
      when '4' or 'D'.
        ls_creditcard-task = task_delete.
      when others.
        continue.
    endcase.



    if <paycard>-data-card_guid is not initial.
     call method MAP_ENCRYPTED_CC_DATA(
      exporting
        iv_card_guid    = <paycard>-data-card_guid
        iv_default_card = <paycard>-data-defaultcard
        iv_task         = ls_creditcard-task
      changing
        c_customer_credit_cards = e_customer_credit_cards
        c_errors                = e_errors ).

    else.
    select single ccins from cvic_ccid_link into ls_creditcard-data_key-ccins
      where pcid_bp = <paycard>-data-card_type.
    if sy-subrc <> 0.
      write <paycard>-data-card_type to lv_var1.
      ls_message = FSBP_generic_services=>new_message(
        i_class_id  = 'CVI_MAPPING'
        i_type      = 'E'
        i_number    = '032'
        i_variable1 = lv_var1
      ).
      append ls_message to e_errors-messages.
      e_errors-is_error = true.
      continue.
    endif.
    ls_block_reason =  <paycard>-data-block_reason_info.
    lt_block_reasons = ls_block_reason-block_reasons.
    clear lv_cclock.
    loop at lt_block_reasons into wa_block_reasons where currently_valid = 'X' or
      currently_valid = 'I'.
    lv_cclock = wa_block_reasons-data_key.
    endloop.
    ls_creditcard-data_key-ccnum = <paycard>-data-card_number.
    ls_creditcard-data-ccdef     = <paycard>-data-defaultcard.
    ls_creditcard-data-ccname    = <paycard>-data-stamp_name.
    ls_creditcard-data-datab     = <paycard>-data-valid_from.
    ls_creditcard-data-datbi     = <paycard>-data-valid_to.
    ls_creditcard-data-cclock    = lv_cclock.
    append ls_creditcard to e_customer_credit_cards-creditcard[].
    clear ls_creditcard.
    endif.
  endloop.
endmethod.


method if_ex_cvi_map_credit_cards~map_customer_credit_cards.

  data:
    ls_paycard     like line of e_partner_credit_cards-paycards,
    ls_message     type bapiret2,
    lv_var1        type symsgv,
    ls_block_reason  type bus_ei_blocking_reason,
    lt_block_reasons type bus_ei_bupa_blockingreasons_t ,
    wa_block_reasons like line of lt_block_reasons.
  field-symbols:
    <creditcard>   like line of i_customer_credit_cards-creditcard.


  e_partner_credit_cards-current_state = i_customer_credit_cards-current_state.

  loop at i_customer_credit_cards-creditcard assigning <creditcard>.

    select single pcid_bp from cvic_ccid_link into ls_paycard-data-card_type
      where ccins = <creditcard>-data_key-ccins.            "#EC *
    if sy-subrc <> 0.
      write <creditcard>-data_key-ccins to lv_var1.
      ls_message = FSBP_generic_services=>new_message(
        i_class_id  = 'CVI_MAPPING'
        i_type      = 'E'
        i_number    = '032'
        i_variable1 = lv_var1
      ).
      append ls_message to e_errors-messages.
      e_errors-is_error = true.
      continue.
    endif.
    CLEAR lt_block_reasons.
    IF <creditcard>-data-cclock is NOT INITIAL.
    wa_block_reasons-data_key =  <creditcard>-data-cclock.
    wa_block_reasons-task = 'I'.
    wa_block_reasons-currently_valid = 'X'.
    Append wa_block_reasons to lt_block_reasons.
    ENDIF.
    ls_block_reason-current_state = 'X'.
    ls_block_reason-block_reasons = lt_block_reasons.
    ls_paycard-data-block_reason_info = ls_block_reason.
    ls_paycard-data-card_number = <creditcard>-data_key-ccnum.
    ls_paycard-data-defaultcard = <creditcard>-data-ccdef.
    ls_paycard-data-stamp_name  = <creditcard>-data-ccname.
    ls_paycard-data-valid_from  = <creditcard>-data-datab.
    ls_paycard-data-valid_to    = <creditcard>-data-datbi.
** to set datax flag
    ls_paycard-datax-defaultcard = <creditcard>-datax-ccdef.
    ls_paycard-datax-stamp_name  = <creditcard>-datax-ccname.
    ls_paycard-datax-valid_from  = <creditcard>-datax-datab.
    ls_paycard-datax-valid_to    = <creditcard>-datax-datbi.
    case <creditcard>-task.
      when task_insert.
        ls_paycard-task = '1'.
      when task_update.
        ls_paycard-task = '2'.
      when task_delete.
        ls_paycard-task = '4'.
      when others.
*       do nothing.
    endcase.

    append ls_paycard to e_partner_credit_cards-paycards.

    clear ls_paycard.

  endloop.


endmethod.


method MAP_ENCRYPTED_CC_DATA.
  DATA: lv_card_guid_out TYPE card_guid,
        lv_card_guid_in  TYPE card_guid_map,
        lv_ccnum         TYPE ccnum,
        lv_var1          TYPE symsgv,
        ls_pca_master    TYPE pca_master_data,
        ls_ccard         TYPE ccard,
        ls_message       TYPE bapiret2,
        ls_creditcard    LIKE LINE OF c_customer_credit_cards-creditcard,
        lt_block         TYPE pcat_bus_block_t.

  lv_card_guid_in = iv_card_guid.

  CALL FUNCTION 'CCA_READ_BP_CARD_DATA'
    EXPORTING
      i_card_guid         = lv_card_guid_in
    IMPORTING
      e_pca_master_data   = ls_pca_master
      e_ccard             = ls_ccard
      e_card_guid         = lv_card_guid_out
      e_block_t           = lt_block
    EXCEPTIONS
      card_data_not_found = 1
      invalid_parameters  = 2
      OTHERS              = 3.

  IF sy-subrc <> 0.
    return.
  ENDIF.

  CALL FUNCTION 'CCSECA_CCNUM_DECRYPTION'
    EXPORTING
      i_enctype         = '1'
      i_guid            = lv_card_guid_out
    IMPORTING
      e_ccnum           = lv_ccnum
    EXCEPTIONS
      decryption_error  = 1
      invalid_card_guid = 2
      OTHERS            = 3.

  IF sy-subrc <> 0.
    return.
  ENDIF.

  SELECT SINGLE ccins FROM cvic_ccid_link INTO ls_creditcard-data_key-ccins
  WHERE pcid_bp = ls_pca_master-card_type.
  IF sy-subrc <> 0.
    WRITE ls_pca_master-card_type TO lv_var1.
    ls_message = fsbp_generic_services=>new_message(
      i_class_id  = 'CVI_MAPPING'
      i_type      = 'E'
      i_number    = '032'
      i_variable1 = lv_var1
    ).
    APPEND ls_message TO c_errors-messages.
    c_errors-is_error = true.
    return.
  ENDIF.

  ls_creditcard-data_key-ccnum = lv_ccnum.
  ls_creditcard-data-ccdef     = iv_default_card.
  ls_creditcard-data-ccname    = ls_pca_master-stamp_name.
  ls_creditcard-data-datab     = ls_ccard-datab.
  ls_creditcard-data-datbi     = ls_ccard-datbi.
  ls_creditcard-task           = iv_task.
  APPEND ls_creditcard TO c_customer_credit_cards-creditcard[].
  CLEAR ls_creditcard.

endmethod.
ENDCLASS.
