class CL_DEF_IM_CVI_MAP_BANKDETAILS definition
  public
  inheriting from CVI_FIELD_MAPPING
  final
  create public .

*"* public components of class CL_DEF_IM_CVI_MAP_BANKDETAILS
*"* do not include other source files here!!!
public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_CVI_MAP_BANKDETAILS .
protected section.
*"* protected components of class CL_DEF_IM_CVI_MAP_BANKDETAILS
*"* do not include other source files here!!!
private section.
*"* private components of class CL_DEF_IM_CVI_MAP_BANKDETAILS
*"* do not include other source files here!!!
ENDCLASS.



CLASS CL_DEF_IM_CVI_MAP_BANKDETAILS IMPLEMENTATION.


method if_ex_cvi_map_bankdetails~map_bp_bankdetails_to_customer.
  data:
    lt_bp_bankdetails   like i_partner_bankdetails-bankdetails,
    ls_bp_bankdetails   like line of lt_bp_bankdetails,
    ls_cust_bankdetails like line of e_customer_bankdetails-bankdetails,
    ls_errors           LIKE e_errors,
    lt_knbk             TYPE TABLE OF knbk,
    ls_knbk             LIKE LINE OF lt_knbk,
    lv_bp_iban_only     TYPE c,
    lv_iban             type iban,
    lv_iban_valid_from  type iban_valfr
    .
  field-symbols:
    <bp_bankdetail>     like line of lt_bp_bankdetails,
    <bankdetails>       type bus_ei_bupa_bankdetail.
  CONSTANTS:
    lc_tech_acc(6)     TYPE c VALUE '<IBAN>'.

  check i_partner_bankdetails is not initial.

  if i_partner_bankdetails-current_state = true.
    lt_bp_bankdetails[] = i_partner_bankdetails-bankdetails[].
  else.
    read_all_bp_bankdetails(
      exporting
        i_partner_guid = i_partner_guid
        i_bankdetails  = i_partner_bankdetails-bankdetails[]
      importing
        e_bankdetails  = lt_bp_bankdetails[]
        e_errors       = ls_errors
    ).
    append lines of ls_errors-messages to e_errors-messages.
    e_errors-is_error = ls_errors-is_error.
    check e_errors-is_error = false.
  endif.

  e_customer_bankdetails-current_state = i_partner_bankdetails-current_state.
  sort lt_bp_bankdetails by task data-bank_ctry data-bank_ctryiso data-bank_key data-bank_acct.

*Check if IBAN ONLY is switched ON or OFF for Business Partners
  CALL FUNCTION 'BUP_TB056_SELECT_SINGLE'
    EXPORTING
      i_object        = 'BUPA'
      i_develop       = 'IBANONLY'
    IMPORTING
      e_dev_is_active = lv_bp_iban_only
    EXCEPTIONS
      not_found       = 1
      OTHERS          = 2.

  IF sy-subrc <> 0.
* do nothing
  ENDIF.

  LOOP AT lt_bp_bankdetails ASSIGNING <bp_bankdetail>.
      IF <bp_bankdetail>-DATA-BANKDETAILVALIDFROM = 00000000 AND
        <bp_bankdetail>-DATA-BANKDETAILVALIDTO = 00000000.
         <bp_bankdetail>-CURRENTLY_VALID = 'X'.
      ENDIF.
  ENDLOOP.

  LOOP AT lt_bp_bankdetails ASSIGNING <bp_bankdetail> WHERE currently_valid = 'X' OR currently_valid = 'I'..

*   eliminate double entries
    check <bp_bankdetail>-data-bank_ctry    <> ls_bp_bankdetails-data-bank_ctry    or
          <bp_bankdetail>-data-bank_ctryiso <> ls_bp_bankdetails-data-bank_ctryiso or
          <bp_bankdetail>-data-bank_key     <> ls_bp_bankdetails-data-bank_key     or
          <bp_bankdetail>-data-bank_acct    <> ls_bp_bankdetails-data-bank_acct    or
          <bp_bankdetail>-task              <> ls_bp_bankdetails-task              or
          <bp_bankdetail>-data-iban         <> ls_bp_bankdetails-data-iban.
    ls_bp_bankdetails = <bp_bankdetail>.

    ls_cust_bankdetails-data_key-banks = <bp_bankdetail>-data-bank_ctry.
    ls_cust_bankdetails-data_key-bankl = <bp_bankdetail>-data-bank_key.
    ls_cust_bankdetails-data_key-bankn = <bp_bankdetail>-data-bank_acct.
*    IF <bp_bankdetail>-data-bank_ctryiso IS NOT INITIAL.
*      ls_cust_bankdetails-data_key-banks = <bp_bankdetail>-data-bank_ctryiso.
*    ENDIF.
    ls_cust_bankdetails-data-bkont           = <bp_bankdetail>-data-ctrl_key.
    ls_cust_bankdetails-data-xezer           = <bp_bankdetail>-data-coll_auth.
    ls_cust_bankdetails-data-bkref           = <bp_bankdetail>-data-bank_ref.
    ls_cust_bankdetails-data-koinh           = <bp_bankdetail>-data-accountholder.
    ls_cust_bankdetails-data-iban            = <bp_bankdetail>-data-iban.
    IF <bp_bankdetail>-data-iban_from_date IS INITIAL AND <bp_bankdetail>-data-iban IS NOT INITIAL.
      ls_cust_bankdetails-data-iban_from_date = sy-datum.
* nt. 2253411 - unexpecteded change of the iban valid from date, we have to check
* if customer already has bank account with same iban if yes dont change iban validity
      IF lt_knbk[] IS INITIAL. " select only first time data are required
        SELECT * FROM knbk INTO TABLE lt_knbk
          WHERE kunnr = i_customer_id.
      ENDIF.
      LOOP AT lt_knbk INTO ls_knbk
        WHERE bankn(6) = lc_tech_acc.
        " check iban
        CALL FUNCTION 'READ_IBAN'
          EXPORTING
            I_BANKS = ls_knbk-banks
            I_BANKL = ls_knbk-bankl
            I_BANKN = ls_knbk-bankn
            I_BKONT = ls_knbk-bkont
            I_BKREF = ls_knbk-bkref
          IMPORTING
            E_IBAN            = lv_iban
            E_IBAN_VALID_FROM = lv_iban_valid_from
          EXCEPTIONS
            IBAN_NOT_FOUND          = 1
            OTHERS                  = 2
            .
        IF SY-SUBRC = 0 and lv_iban = <bp_bankdetail>-data-iban.
          ls_cust_bankdetails-data-iban_from_date = lv_iban_valid_from.
          EXIT.
        ENDIF.
      ENDLOOP.
    ELSE.
      ls_cust_bankdetails-data-iban_from_date  = <bp_bankdetail>-data-iban_from_date.
    ENDIF.
    ls_cust_bankdetails-data-bvtyp           = <bp_bankdetail>-data_key. "BKVID

    translate ls_cust_bankdetails-datax using ' X'.

    ls_cust_bankdetails-task = task_modify.
    if <bp_bankdetail>-task eq task_delete or <bp_bankdetail>-task eq '4'. "Logical Key Delete
      ls_cust_bankdetails-task = task_delete.
    endif.

    append ls_cust_bankdetails to e_customer_bankdetails-bankdetails.
    SORT e_customer_bankdetails-bankdetails BY task.

  ENDLOOP.

  loop at i_partner_bankdetails-bankdetails assigning <bankdetails>
    where task = task_insert or
          task = '1'.
    delete e_customer_bankdetails-bankdetails
      where task           = task_delete                  and
            data_key-banks = <bankdetails>-data-bank_ctry and
            data_key-bankl = <bankdetails>-data-bank_key  and
            data_key-bankn = <bankdetails>-data-bank_acct.
  endloop.

  IF lv_bp_iban_only IS INITIAL.
* IBAN ONLY switched OFF for Business Partners
* Special mapping : select all bankdetails with technical account number
* from knbk for this customer and fill the complex structure
  IF lt_knbk[] IS INITIAL. " select only first time data are required
  SELECT * FROM knbk INTO TABLE lt_knbk
    WHERE kunnr = i_customer_id.
  ENDIF.

  LOOP AT lt_knbk INTO ls_knbk
       WHERE bankn(6) = lc_tech_acc.

    CLEAR ls_cust_bankdetails.
    MOVE-CORRESPONDING ls_knbk TO ls_cust_bankdetails-data_key.
    MOVE-CORRESPONDING ls_knbk TO ls_cust_bankdetails-data.
    ls_cust_bankdetails-task = task_modify.
    TRANSLATE ls_cust_bankdetails-datax USING 'X'.
    APPEND ls_cust_bankdetails TO e_customer_bankdetails-bankdetails.
  ENDLOOP.
  SORT e_customer_bankdetails-bankdetails BY task.
  ENDIF.

ENDMETHOD.


method if_ex_cvi_map_bankdetails~map_bp_bankdetails_to_vendor.
  data:
    lt_bp_bankdetails   like i_partner_bankdetails-bankdetails,
    ls_bp_bankdetails   like line of lt_bp_bankdetails,
    ls_vend_bankdetails like line of e_vendor_bankdetails-bankdetails,
    ls_errors           LIKE e_errors,
    lt_lfbk             TYPE TABLE OF lfbk,
    ls_lfbk             LIKE LINE OF lt_lfbk,
    lv_bp_iban_only     TYPE c,
    lv_iban             type iban,
    lv_iban_valid_from  type iban_valfr
    .
  field-symbols:
    <bp_bankdetail>     like line of lt_bp_bankdetails,
    <bankdetails>       type bus_ei_bupa_bankdetail.
  CONSTANTS:
    lc_tech_acc(6)      TYPE c VALUE '<IBAN>'.

  check i_partner_bankdetails is not initial.

  if i_partner_bankdetails-current_state = true.
    lt_bp_bankdetails[] = i_partner_bankdetails-bankdetails[].
  else.
    read_all_bp_bankdetails(
      exporting
        i_partner_guid = i_partner_guid
        i_bankdetails  = i_partner_bankdetails-bankdetails[]
      importing
        e_bankdetails  = lt_bp_bankdetails[]
        e_errors       = ls_errors
    ).
    append lines of ls_errors-messages to e_errors-messages.
    e_errors-is_error = ls_errors-is_error.
    check e_errors-is_error = false.
  endif.

  e_vendor_bankdetails-current_state = i_partner_bankdetails-current_state.
  sort lt_bp_bankdetails by task data-bank_ctry data-bank_ctryiso data-bank_key data-bank_acct.

*Check if IBAN ONLY is switched ON or OFF for Business Partners
  CALL FUNCTION 'BUP_TB056_SELECT_SINGLE'
    EXPORTING
      i_object        = 'BUPA'
      i_develop       = 'IBANONLY'
    IMPORTING
      e_dev_is_active = lv_bp_iban_only
    EXCEPTIONS
      not_found       = 1
      OTHERS          = 2.

  IF sy-subrc <> 0.
* do nothing
  ENDIF.

 LOOP AT lt_bp_bankdetails ASSIGNING <bp_bankdetail>.
    IF <bp_bankdetail>-DATA-BANKDETAILVALIDFROM = 00000000 AND
      <bp_bankdetail>-DATA-BANKDETAILVALIDTO = 00000000.
       <bp_bankdetail>-CURRENTLY_VALID = 'X'.
    ENDIF.
ENDLOOP.

LOOP AT lt_bp_bankdetails ASSIGNING <bp_bankdetail> WHERE currently_valid = 'X' OR currently_valid = 'I'.

*   eliminate double entries
    check <bp_bankdetail>-data-bank_ctry    <> ls_bp_bankdetails-data-bank_ctry    or
          <bp_bankdetail>-data-bank_ctryiso <> ls_bp_bankdetails-data-bank_ctryiso or
          <bp_bankdetail>-data-bank_key     <> ls_bp_bankdetails-data-bank_key     or
          <bp_bankdetail>-data-bank_acct    <> ls_bp_bankdetails-data-bank_acct    or
          <bp_bankdetail>-task              <> ls_bp_bankdetails-task              or
          <bp_bankdetail>-data-iban         <> ls_bp_bankdetails-data-iban.
    ls_bp_bankdetails = <bp_bankdetail>.

    ls_vend_bankdetails-data_key-banks = <bp_bankdetail>-data-bank_ctry.
    ls_vend_bankdetails-data_key-bankl = <bp_bankdetail>-data-bank_key.
    ls_vend_bankdetails-data_key-bankn = <bp_bankdetail>-data-bank_acct.
*    IF <bp_bankdetail>-data-bank_ctryiso IS NOT INITIAL.
*      ls_vend_bankdetails-data_key-banks = <bp_bankdetail>-data-bank_ctryiso.
*    ENDIF.
    ls_vend_bankdetails-data-bkont          = <bp_bankdetail>-data-ctrl_key.
    ls_vend_bankdetails-data-xezer          = <bp_bankdetail>-data-coll_auth.
    ls_vend_bankdetails-data-bkref          = <bp_bankdetail>-data-bank_ref.
    ls_vend_bankdetails-data-koinh          = <bp_bankdetail>-data-accountholder.
    ls_vend_bankdetails-data-iban           = <bp_bankdetail>-data-iban.
    IF <bp_bankdetail>-data-iban_from_date IS INITIAL AND <bp_bankdetail>-data-iban IS NOT INITIAL.
      ls_vend_bankdetails-data-iban_from_date = sy-datum.
* nt. 2253411 - unexpecteded change of the iban valid from date, we have to check
* if vendor already has bank account with same iban if yes dont change iban validity
      IF lt_lfbk[] IS INITIAL. " select only first time data are required
        SELECT * FROM lfbk INTO TABLE lt_lfbk
         WHERE lifnr = i_vendor_id.
      ENDIF.
      LOOP AT lt_lfbk INTO ls_lfbk
        WHERE bankn(6) = lc_tech_acc.
        " check iban
        CALL FUNCTION 'READ_IBAN'
          EXPORTING
            I_BANKS = ls_lfbk-banks
            I_BANKL = ls_lfbk-bankl
            I_BANKN = ls_lfbk-bankn
            I_BKONT = ls_lfbk-bkont
            I_BKREF = ls_lfbk-bkref
          IMPORTING
            E_IBAN            = lv_iban
            E_IBAN_VALID_FROM = lv_iban_valid_from
          EXCEPTIONS
            IBAN_NOT_FOUND          = 1
            OTHERS                  = 2
            .
        IF SY-SUBRC = 0 and lv_iban = <bp_bankdetail>-data-iban.
          ls_vend_bankdetails-data-iban_from_date = lv_iban_valid_from.
          EXIT.
        ENDIF.
      ENDLOOP.
    ELSE.
      ls_vend_bankdetails-data-iban_from_date = <bp_bankdetail>-data-iban_from_date.
    ENDIF.
    ls_vend_bankdetails-data-bvtyp          = <bp_bankdetail>-data_key. "BKVID

    translate ls_vend_bankdetails-datax using ' X'.

    ls_vend_bankdetails-task = task_modify.
    if <bp_bankdetail>-task eq task_delete or <bp_bankdetail>-task eq '4'. "Logical Key Delete
      ls_vend_bankdetails-task = task_delete.
    endif.

    append ls_vend_bankdetails to e_vendor_bankdetails-bankdetails.
    SORT e_vendor_bankdetails-bankdetails BY task.

  ENDLOOP.

  loop at i_partner_bankdetails-bankdetails assigning <bankdetails>
     where task = task_insert or
           task = '1'.
    delete e_vendor_bankdetails-bankdetails
      where task           = task_delete                  and
            data_key-banks = <bankdetails>-data-bank_ctry and
            data_key-bankl = <bankdetails>-data-bank_key  and
            data_key-bankn = <bankdetails>-data-bank_acct.
  endloop.

  IF lv_bp_iban_only IS INITIAL.
* special mapping : select all bankdetails with technical account number
* from lfbk for this vendor and fill the complex structure
  IF lt_lfbk[] IS INITIAL. " select only first time data are required
  SELECT * FROM lfbk INTO TABLE lt_lfbk
    WHERE lifnr = i_vendor_id.
  ENDIF.

  LOOP AT lt_lfbk INTO ls_lfbk
       WHERE bankn(6) = lc_tech_acc.

    CLEAR ls_vend_bankdetails.
    MOVE-CORRESPONDING ls_lfbk TO ls_vend_bankdetails-data_key.
    MOVE-CORRESPONDING ls_lfbk TO ls_vend_bankdetails-data.
    ls_vend_bankdetails-task = task_modify.
    TRANSLATE ls_vend_bankdetails-datax USING 'X'.
    APPEND ls_vend_bankdetails TO e_vendor_bankdetails-bankdetails.
  ENDLOOP.
  SORT e_vendor_bankdetails-bankdetails BY task.
  ENDIF.

ENDMETHOD.


method if_ex_cvi_map_bankdetails~map_bp_bank_data_to_customer.
  data:
    lt_bp_bankdetails   like i_partner_bankdetails-bankdetails,
    ls_bp_bankdetails   like line of lt_bp_bankdetails,
    ls_cust_bankdetails like line of e_customer_bankdetails-bankdetails,
    ls_errors           LIKE e_errors,
    lt_knbk             TYPE TABLE OF knbk,
    ls_knbk             LIKE LINE OF lt_knbk,
    lv_bp_iban_only     TYPE c,
    lv_iban             type iban,
    lv_iban_valid_from  type iban_valfr
    .
  field-symbols:
    <bp_bankdetail>     like line of lt_bp_bankdetails,
    <bankdetails>       type bus_ei_bupa_bankdetail.
  CONSTANTS:
    lc_tech_acc(6)      TYPE c VALUE '<IBAN>'.

  check i_partner_bankdetails is not initial.

  if i_partner_bankdetails-current_state = true.
    lt_bp_bankdetails[] = i_partner_bankdetails-bankdetails[].
  else.
    read_all_bp_bankdetails(
      exporting
        i_partner_guid = i_partner_guid
        i_bankdetails  = i_partner_bankdetails-bankdetails[]
      importing
        e_bankdetails  = lt_bp_bankdetails[]
        e_errors       = ls_errors
    ).
    append lines of ls_errors-messages to e_errors-messages.
    e_errors-is_error = ls_errors-is_error.
    check e_errors-is_error = false.
  endif.

  e_customer_bankdetails-current_state = i_partner_bankdetails-current_state.
  sort lt_bp_bankdetails by task data-bank_ctry data-bank_ctryiso data-bank_key data-bank_acct.

*Check if IBAN ONLY is switched ON or OFF for Business Partners
  CALL FUNCTION 'BUP_TB056_SELECT_SINGLE'
    EXPORTING
      i_object        = 'BUPA'
      i_develop       = 'IBANONLY'
    IMPORTING
      e_dev_is_active = lv_bp_iban_only
    EXCEPTIONS
      not_found       = 1
      OTHERS          = 2.

  IF sy-subrc <> 0.
* do nothing
  ENDIF.

  LOOP AT lt_bp_bankdetails ASSIGNING <bp_bankdetail> WHERE currently_valid = true.

*   eliminate double entries
    check <bp_bankdetail>-data-bank_ctry    <> ls_bp_bankdetails-data-bank_ctry    or
          <bp_bankdetail>-data-bank_ctryiso <> ls_bp_bankdetails-data-bank_ctryiso or
          <bp_bankdetail>-data-bank_key     <> ls_bp_bankdetails-data-bank_key     or
          <bp_bankdetail>-data-bank_acct    <> ls_bp_bankdetails-data-bank_acct    or
          <bp_bankdetail>-task              <> ls_bp_bankdetails-task.
    ls_bp_bankdetails = <bp_bankdetail>.

    ls_cust_bankdetails-data_key-banks = <bp_bankdetail>-data-bank_ctry.
    ls_cust_bankdetails-data_key-bankl = <bp_bankdetail>-data-bank_key.
    ls_cust_bankdetails-data_key-bankn = <bp_bankdetail>-data-bank_acct.
    IF <bp_bankdetail>-data-bank_ctryiso IS NOT INITIAL.
      ls_cust_bankdetails-data_key-banks = <bp_bankdetail>-data-bank_ctryiso.
    ENDIF.
    ls_cust_bankdetails-data-bkont           = <bp_bankdetail>-data-ctrl_key.
    ls_cust_bankdetails-data-xezer           = <bp_bankdetail>-data-coll_auth.
    ls_cust_bankdetails-data-bkref           = <bp_bankdetail>-data-bank_ref.
    ls_cust_bankdetails-data-koinh           = <bp_bankdetail>-data-accountholder.
    ls_cust_bankdetails-data-iban            = <bp_bankdetail>-data-iban.
    IF <bp_bankdetail>-data-iban_from_date IS INITIAL and <bp_bankdetail>-data-iban is not initial.
    ls_cust_bankdetails-data-iban_from_date = sy-datum.
* nt. 2253411 - unexpecteded change of the inban valid from date, we have to check
* if customer already has bank account with same iban if yes dont change iban validity
      IF lt_knbk[] IS INITIAL. " select only first time data are required
        SELECT * FROM knbk INTO TABLE lt_knbk
          WHERE kunnr = i_customer_id.
      ENDIF.
      LOOP AT lt_knbk INTO ls_knbk
        WHERE bankn(6) = lc_tech_acc.
        " check iban
        CALL FUNCTION 'READ_IBAN'
          EXPORTING
            I_BANKS = ls_knbk-banks
            I_BANKL = ls_knbk-bankl
            I_BANKN = ls_knbk-bankn
            I_BKONT = ls_knbk-bkont
            I_BKREF = ls_knbk-bkref
          IMPORTING
            E_IBAN            = lv_iban
            E_IBAN_VALID_FROM = lv_iban_valid_from
          EXCEPTIONS
            IBAN_NOT_FOUND          = 1
            OTHERS                  = 2
            .
        IF SY-SUBRC = 0 and lv_iban = <bp_bankdetail>-data-iban.
          ls_cust_bankdetails-data-iban_from_date = lv_iban_valid_from.
          EXIT.
        ENDIF.
      ENDLOOP.
    ELSE.
      ls_cust_bankdetails-data-iban_from_date  = <bp_bankdetail>-data-iban_from_date.
    ENDIF.
    ls_cust_bankdetails-datax-bkont          = true.
    ls_cust_bankdetails-datax-xezer          = true.
    ls_cust_bankdetails-datax-bkref          = true.
    ls_cust_bankdetails-datax-koinh          = true.
    ls_cust_bankdetails-datax-iban           = true.
    ls_cust_bankdetails-datax-iban_from_date = true.

    ls_cust_bankdetails-task = task_modify.
    if <bp_bankdetail>-task eq task_delete or <bp_bankdetail>-task eq '4'. "Logical Key Delete
      ls_cust_bankdetails-task = task_delete.
    endif.

    append ls_cust_bankdetails to e_customer_bankdetails-bankdetails.
    SORT e_customer_bankdetails-bankdetails BY task.

  ENDLOOP.

  loop at i_partner_bankdetails-bankdetails assigning <bankdetails>
    where task = task_insert or
          task = '1'.
    delete e_customer_bankdetails-bankdetails
      where task           = task_delete                  and
            data_key-banks = <bankdetails>-data-bank_ctry and
            data_key-bankl = <bankdetails>-data-bank_key  and
            data_key-bankn = <bankdetails>-data-bank_acct.
  endloop.

  IF lv_bp_iban_only IS INITIAL.
* IBAN ONLY switched OFF for Business Partners
* Special mapping : select all bankdetails with technical account number
* from knbk for this customer and fill the complex structure
  IF lt_knbk[] IS INITIAL. " select only first time data are required
  SELECT * FROM knbk INTO TABLE lt_knbk
    WHERE kunnr = i_customer_id.
  ENDIF.

  LOOP AT lt_knbk INTO ls_knbk
       WHERE bankn(6) = lc_tech_acc.

    CLEAR ls_cust_bankdetails.
    MOVE-CORRESPONDING ls_knbk TO ls_cust_bankdetails-data_key.
    MOVE-CORRESPONDING ls_knbk TO ls_cust_bankdetails-data.
    ls_cust_bankdetails-task = task_modify.
    TRANSLATE ls_cust_bankdetails-datax USING 'X'.
    APPEND ls_cust_bankdetails TO e_customer_bankdetails-bankdetails.
  ENDLOOP.
  SORT e_customer_bankdetails-bankdetails BY task.
  ENDIF.

ENDMETHOD.


method if_ex_cvi_map_bankdetails~map_bp_bank_data_to_vendor.
  data:
    lt_bp_bankdetails   like i_partner_bankdetails-bankdetails,
    ls_bp_bankdetails   like line of lt_bp_bankdetails,
    ls_vend_bankdetails like line of e_vendor_bankdetails-bankdetails,
    ls_errors           LIKE e_errors,
    lt_lfbk             TYPE TABLE OF lfbk,
    ls_lfbk             LIKE LINE OF lt_lfbk,
    lv_bp_iban_only     TYPE c,
    lv_iban             type iban,
    lv_iban_valid_from  type iban_valfr
    .
  field-symbols:
    <bp_bankdetail>     like line of lt_bp_bankdetails,
    <bankdetails>       type bus_ei_bupa_bankdetail.
  CONSTANTS:
    lc_tech_acc(6)      TYPE c VALUE '<IBAN>'.

  check i_partner_bankdetails is not initial.

  if i_partner_bankdetails-current_state = true.
    lt_bp_bankdetails[] = i_partner_bankdetails-bankdetails[].
  else.
    read_all_bp_bankdetails(
      exporting
        i_partner_guid = i_partner_guid
        i_bankdetails  = i_partner_bankdetails-bankdetails[]
      importing
        e_bankdetails  = lt_bp_bankdetails[]
        e_errors       = ls_errors
    ).
    append lines of ls_errors-messages to e_errors-messages.
    e_errors-is_error = ls_errors-is_error.
    check e_errors-is_error = false.
  endif.

  e_vendor_bankdetails-current_state = i_partner_bankdetails-current_state.
  sort lt_bp_bankdetails by task data-bank_ctry data-bank_ctryiso data-bank_key data-bank_acct.

*Check if IBAN ONLY is switched ON or OFF for Business Partners
  CALL FUNCTION 'BUP_TB056_SELECT_SINGLE'
    EXPORTING
      i_object        = 'BUPA'
      i_develop       = 'IBANONLY'
    IMPORTING
      e_dev_is_active = lv_bp_iban_only
    EXCEPTIONS
      not_found       = 1
      OTHERS          = 2.

  IF sy-subrc <> 0.
* do nothing
  ENDIF.

  LOOP AT lt_bp_bankdetails ASSIGNING <bp_bankdetail> WHERE currently_valid = true.

*   eliminate double entries
    check <bp_bankdetail>-data-bank_ctry    <> ls_bp_bankdetails-data-bank_ctry    or
          <bp_bankdetail>-data-bank_ctryiso <> ls_bp_bankdetails-data-bank_ctryiso or
          <bp_bankdetail>-data-bank_key     <> ls_bp_bankdetails-data-bank_key     or
          <bp_bankdetail>-data-bank_acct    <> ls_bp_bankdetails-data-bank_acct    or
          <bp_bankdetail>-task              <> ls_bp_bankdetails-task.
    ls_bp_bankdetails = <bp_bankdetail>.

    ls_vend_bankdetails-data_key-banks = <bp_bankdetail>-data-bank_ctry.
    ls_vend_bankdetails-data_key-bankl = <bp_bankdetail>-data-bank_key.
    ls_vend_bankdetails-data_key-bankn = <bp_bankdetail>-data-bank_acct.
    IF <bp_bankdetail>-data-bank_ctryiso IS NOT INITIAL.
      ls_vend_bankdetails-data_key-banks = <bp_bankdetail>-data-bank_ctryiso.
    ENDIF.
    ls_vend_bankdetails-data-bkont          = <bp_bankdetail>-data-ctrl_key.
    ls_vend_bankdetails-data-xezer          = <bp_bankdetail>-data-coll_auth.
    ls_vend_bankdetails-data-bkref          = <bp_bankdetail>-data-bank_ref.
    ls_vend_bankdetails-data-koinh          = <bp_bankdetail>-data-accountholder.
    ls_vend_bankdetails-data-iban           = <bp_bankdetail>-data-iban.
    IF <bp_bankdetail>-data-iban_from_date IS INITIAL AND <bp_bankdetail>-data-iban IS NOT INITIAL.
      ls_vend_bankdetails-data-iban_from_date = sy-datum.
* nt. 2253411 - unexpecteded change of the iban valid from date, we have to check
* if vendor already has bank account with same iban if yes dont change iban validity
      IF lt_lfbk[] IS INITIAL. " select only first time data are required
        SELECT * FROM lfbk INTO TABLE lt_lfbk
         WHERE lifnr = i_vendor_id.
      ENDIF.
      LOOP AT lt_lfbk INTO ls_lfbk
        WHERE bankn(6) = lc_tech_acc.
        " check iban
        CALL FUNCTION 'READ_IBAN'
          EXPORTING
            I_BANKS = ls_lfbk-banks
            I_BANKL = ls_lfbk-bankl
            I_BANKN = ls_lfbk-bankn
            I_BKONT = ls_lfbk-bkont
            I_BKREF = ls_lfbk-bkref
          IMPORTING
            E_IBAN            = lv_iban
            E_IBAN_VALID_FROM = lv_iban_valid_from
          EXCEPTIONS
            IBAN_NOT_FOUND          = 1
            OTHERS                  = 2
            .
        IF SY-SUBRC = 0 and lv_iban = <bp_bankdetail>-data-iban.
          ls_vend_bankdetails-data-iban_from_date = lv_iban_valid_from.
          EXIT.
        ENDIF.
      ENDLOOP.
    ELSE.
      ls_vend_bankdetails-data-iban_from_date = <bp_bankdetail>-data-iban_from_date.
    ENDIF.
    ls_vend_bankdetails-data-bvtyp          = <bp_bankdetail>-data_key. "BKVID

    ls_vend_bankdetails-datax-bkont          = true.
    ls_vend_bankdetails-datax-xezer          = true.
    ls_vend_bankdetails-datax-bkref          = true.
    ls_vend_bankdetails-datax-koinh          = true.
    ls_vend_bankdetails-datax-iban           = true.
    ls_vend_bankdetails-datax-iban_from_date = true.

    ls_vend_bankdetails-task = task_modify.
    if <bp_bankdetail>-task eq task_delete or <bp_bankdetail>-task eq '4'. "Logical Key Delete
      ls_vend_bankdetails-task = task_delete.
    endif.

    append ls_vend_bankdetails to e_vendor_bankdetails-bankdetails.
    SORT e_vendor_bankdetails-bankdetails BY task.

  ENDLOOP.

  loop at i_partner_bankdetails-bankdetails assigning <bankdetails>
     where task = task_insert or
           task = '1'.
    delete e_vendor_bankdetails-bankdetails
      where task           = task_delete                  and
            data_key-banks = <bankdetails>-data-bank_ctry and
            data_key-bankl = <bankdetails>-data-bank_key  and
            data_key-bankn = <bankdetails>-data-bank_acct.
  endloop.

  IF lv_bp_iban_only IS INITIAL.
* special mapping : select all bankdetails with technical account number
* from lfbk for this vendor and fill the complex structure
  IF lt_lfbk[] IS INITIAL. " select only first time data are required
  SELECT * FROM lfbk INTO TABLE lt_lfbk
    WHERE lifnr = i_vendor_id.
  ENDIF.

  LOOP AT lt_lfbk INTO ls_lfbk
       WHERE bankn(6) = lc_tech_acc.

    CLEAR ls_vend_bankdetails.
    MOVE-CORRESPONDING ls_lfbk TO ls_vend_bankdetails-data_key.
    MOVE-CORRESPONDING ls_lfbk TO ls_vend_bankdetails-data.
    ls_vend_bankdetails-task = task_modify.
    TRANSLATE ls_vend_bankdetails-datax USING 'X'.
    APPEND ls_vend_bankdetails TO e_vendor_bankdetails-bankdetails.
  ENDLOOP.
  SORT e_vendor_bankdetails-bankdetails BY task.
  ENDIF.

ENDMETHOD.


method if_ex_cvi_map_bankdetails~map_customer_bankdetails.
  DATA:
    ls_bp_bankdetails   LIKE LINE OF e_partner_bankdetails-bankdetails,
    lv_bp_iban_only     TYPE c,
    lv_cntry_iso        LIKE ls_bp_bankdetails-data-bank_ctryiso.
  FIELD-SYMBOLS:
    <bankdetails>       LIKE LINE OF i_customer_bankdetails-bankdetails.

  IF i_customer_bankdetails-current_state = true.
    e_partner_bankdetails-current_state = true.
  ENDIF.

  LOOP AT i_customer_bankdetails-bankdetails ASSIGNING <bankdetails>.

    ls_bp_bankdetails-data-bank_ctry         = <bankdetails>-data_key-banks.
    ls_bp_bankdetails-data-bank_key          = <bankdetails>-data_key-bankl.
    ls_bp_bankdetails-data-bank_acct         = <bankdetails>-data_key-bankn.

    ls_bp_bankdetails-data-ctrl_key          = <bankdetails>-data-bkont.
    ls_bp_bankdetails-data-coll_auth         = <bankdetails>-data-xezer.
    ls_bp_bankdetails-data-bank_ref          = <bankdetails>-data-bkref.
    ls_bp_bankdetails-data-accountholder     = <bankdetails>-data-koinh.
    ls_bp_bankdetails-data-iban              = <bankdetails>-data-iban.
    ls_bp_bankdetails-data-iban_from_date    = <bankdetails>-data-iban_from_date.

     ls_bp_bankdetails-data_key = <bankdetails>-data-bvtyp.

  call function 'COUNTRY_CODE_SAP_TO_ISO'
    exporting
      sap_code        = <bankdetails>-data_key-banks
    importing
      iso_code        = lv_cntry_iso
    exceptions
      others          = 2.
    ls_bp_bankdetails-data-bank_ctryiso  = lv_cntry_iso.

*      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*        EXPORTING
*          input  = <bankdetails>-data-bvtyp
*        IMPORTING
*          output = ls_bp_bankdetails-data_key.



    ls_bp_bankdetails-datax-ctrl_key         = <bankdetails>-datax-bkont.
    ls_bp_bankdetails-datax-coll_auth        = <bankdetails>-datax-xezer.
    ls_bp_bankdetails-datax-bank_ref         = <bankdetails>-datax-bkref.
    ls_bp_bankdetails-datax-accountholder    = <bankdetails>-datax-koinh.
    ls_bp_bankdetails-datax-iban             = <bankdetails>-datax-iban.
    ls_bp_bankdetails-datax-iban_from_date   = <bankdetails>-datax-iban_from_date.

    CASE <bankdetails>-task.
      WHEN task_insert.
        ls_bp_bankdetails-task = 1.
      WHEN task_update.
        ls_bp_bankdetails-task = 2.
      WHEN task_delete.
        ls_bp_bankdetails-task = 4.
      WHEN task_modify.
        ls_bp_bankdetails-task = 1.
      WHEN OTHERS.
    ENDCASE.
    TRANSLATE ls_bp_bankdetails-datax USING ' X'.
    LS_BP_BANKDETAILS-DATAX-EXTERNALBANKID = ' '.
    APPEND ls_bp_bankdetails TO e_partner_bankdetails-bankdetails.
    CLEAR ls_bp_bankdetails.                                " n_1722094
  ENDLOOP.

*Check if IBAN ONLY is switched ON or OFF for Business Partner
  CALL FUNCTION 'BUP_TB056_SELECT_SINGLE'
    EXPORTING
      i_object        = 'BUPA'
      i_develop       = 'IBANONLY'
    IMPORTING
      e_dev_is_active = lv_bp_iban_only
    EXCEPTIONS
      not_found       = 1
      OTHERS          = 2.

  IF sy-subrc <> 0.
*do nothing
  ENDIF.

  IF lv_bp_iban_only IS INITIAL.
*IBAN ONLY is switched OFF for Business Partner.  Remove all the bankdetails which have technical
*account number
    DELETE e_partner_bankdetails-bankdetails WHERE data-bank_acct(6) EQ '<IBAN>'.

  ELSE.
*IBAN ONLY is switched ON for Business Partner.  Clear all technical account numbers since Business
*Partner does not support technical account numbers.
    LOOP AT e_partner_bankdetails-bankdetails INTO ls_bp_bankdetails
      WHERE data-bank_acct(6) EQ '<IBAN>'.
      CLEAR ls_bp_bankdetails-data-bank_acct.
      MODIFY e_partner_bankdetails-bankdetails FROM ls_bp_bankdetails INDEX sy-tabix
             TRANSPORTING data-bank_acct.

      CLEAR ls_bp_bankdetails.
    ENDLOOP.
  ENDIF.
endmethod.


method if_ex_cvi_map_bankdetails~map_customer_bank_data.
  data:
    ls_bp_bankdetails   LIKE LINE OF e_partner_bankdetails-bankdetails,
    lv_bp_iban_only     TYPE c.
  field-symbols:
    <bankdetails>       like line of i_customer_bankdetails-bankdetails.

  if i_customer_bankdetails-current_state = true.
    e_partner_bankdetails-current_state = true.
  endif.

  loop at i_customer_bankdetails-bankdetails assigning <bankdetails>.

    ls_bp_bankdetails-data-bank_ctry       = <bankdetails>-data_key-banks.
    ls_bp_bankdetails-data-bank_key        = <bankdetails>-data_key-bankl.
    ls_bp_bankdetails-data-bank_acct       = <bankdetails>-data_key-bankn.

    ls_bp_bankdetails-data-ctrl_key        = <bankdetails>-data-bkont.
    ls_bp_bankdetails-data-coll_auth       = <bankdetails>-data-xezer.
    ls_bp_bankdetails-data-bank_ref        = <bankdetails>-data-bkref.
    ls_bp_bankdetails-data-accountholder   = <bankdetails>-data-koinh.
    ls_bp_bankdetails-data-iban            = <bankdetails>-data-iban.
    ls_bp_bankdetails-data-iban_from_date  = <bankdetails>-data-iban_from_date.

    ls_bp_bankdetails-datax-ctrl_key       = <bankdetails>-datax-bkont.
    ls_bp_bankdetails-datax-coll_auth      = <bankdetails>-datax-xezer.
    ls_bp_bankdetails-datax-bank_ref       = <bankdetails>-datax-bkref.
    ls_bp_bankdetails-datax-accountholder  = <bankdetails>-datax-koinh.
    ls_bp_bankdetails-datax-iban           = <bankdetails>-datax-iban.
    ls_bp_bankdetails-datax-iban_from_date = <bankdetails>-datax-iban_from_date.

    case <bankdetails>-task.
      when task_insert.
        ls_bp_bankdetails-task = 1.
      when task_update.
        ls_bp_bankdetails-task = 2.
      when task_delete.
        ls_bp_bankdetails-task = 4.
      when task_modify.
        ls_bp_bankdetails-task = 1.
      when others.
    endcase.

    append ls_bp_bankdetails to e_partner_bankdetails-bankdetails.
    clear ls_bp_bankdetails.                                " n_1722094
  ENDLOOP.

*Check if IBAN ONLY is switched ON or OFF for Business Partner
  CALL FUNCTION 'BUP_TB056_SELECT_SINGLE'
    EXPORTING
      i_object        = 'BUPA'
      i_develop       = 'IBANONLY'
    IMPORTING
      e_dev_is_active = lv_bp_iban_only
    EXCEPTIONS
      not_found       = 1
      OTHERS          = 2.

  IF sy-subrc <> 0.
*do nothing
  ENDIF.

  IF lv_bp_iban_only IS INITIAL.
*IBAN ONLY is switched OFF for Business Partner.  Remove all the bankdetails which have technical
*account number
    DELETE e_partner_bankdetails-bankdetails WHERE data-bank_acct(6) EQ '<IBAN>'.

  ELSE.
*IBAN ONLY is switched ON for Business Partner.  Clear all technical account numbers since Business
*Partner does not support technical account numbers.
    LOOP AT e_partner_bankdetails-bankdetails INTO ls_bp_bankdetails
      WHERE data-bank_acct(6) EQ '<IBAN>'.
      CLEAR ls_bp_bankdetails-data-bank_acct.
      MODIFY e_partner_bankdetails-bankdetails FROM ls_bp_bankdetails INDEX sy-tabix
             TRANSPORTING data-bank_acct.

      CLEAR ls_bp_bankdetails.
    ENDLOOP.
  ENDIF.

endmethod.


method if_ex_cvi_map_bankdetails~map_vendor_bankdetails.
  DATA:
    ls_bp_bankdetails   LIKE LINE OF e_partner_bankdetails-bankdetails,
    lv_bp_iban_only     TYPE c,
    lv_cntry_iso        LIKE ls_bp_bankdetails-data-bank_ctryiso.
  FIELD-SYMBOLS:
    <bankdetails>       LIKE LINE OF i_vendor_bankdetails-bankdetails.

  IF i_vendor_bankdetails-current_state = true.
    e_partner_bankdetails-current_state = true.
  ENDIF.

  LOOP AT i_vendor_bankdetails-bankdetails ASSIGNING <bankdetails>.

    ls_bp_bankdetails-data-bank_ctry         = <bankdetails>-data_key-banks.
    ls_bp_bankdetails-data-bank_key          = <bankdetails>-data_key-bankl.
    ls_bp_bankdetails-data-bank_acct         = <bankdetails>-data_key-bankn.

    ls_bp_bankdetails-data-ctrl_key          = <bankdetails>-data-bkont.
    ls_bp_bankdetails-data-coll_auth         = <bankdetails>-data-xezer.
    ls_bp_bankdetails-data-bank_ref          = <bankdetails>-data-bkref.
    ls_bp_bankdetails-data-accountholder     = <bankdetails>-data-koinh.
    ls_bp_bankdetails-data-iban              = <bankdetails>-data-iban.
    ls_bp_bankdetails-data-iban_from_date    = <bankdetails>-data-iban_from_date.
    ls_bp_bankdetails-data_key = <bankdetails>-data-bvtyp.

  call function 'COUNTRY_CODE_SAP_TO_ISO'
    exporting
      sap_code        = <bankdetails>-data_key-banks
    importing
      iso_code        = lv_cntry_iso
    exceptions
      others          = 2.
    ls_bp_bankdetails-data-bank_ctryiso  = lv_cntry_iso.

*      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*        EXPORTING
*          INPUT  = <bankdetails>-data-bvtyp
*        IMPORTING
*          OUTPUT = ls_bp_bankdetails-data_key.



    ls_bp_bankdetails-datax-ctrl_key         = <bankdetails>-datax-bkont.
    ls_bp_bankdetails-datax-coll_auth        = <bankdetails>-datax-xezer.
    ls_bp_bankdetails-datax-bank_ref         = <bankdetails>-datax-bkref.
    ls_bp_bankdetails-datax-accountholder    = <bankdetails>-datax-koinh.
    ls_bp_bankdetails-datax-iban             = <bankdetails>-datax-iban.
    ls_bp_bankdetails-datax-iban_from_date   = <bankdetails>-datax-iban_from_date.

    CASE <bankdetails>-task.
      WHEN task_insert.
        ls_bp_bankdetails-task = 1.
      WHEN task_update.
        ls_bp_bankdetails-task = 2.
      WHEN task_delete.
        ls_bp_bankdetails-task = 4.
      WHEN task_modify.
        ls_bp_bankdetails-task = 1.
      WHEN OTHERS.
    ENDCASE.
    TRANSLATE ls_bp_bankdetails-datax USING ' X'.
    LS_BP_BANKDETAILS-DATAX-EXTERNALBANKID = ' '.
    APPEND ls_bp_bankdetails TO e_partner_bankdetails-bankdetails.
    CLEAR ls_bp_bankdetails.                                " n_1722094
  ENDLOOP.

*Check if IBAN ONLY is switched ON or OFF for Business Partner
  CALL FUNCTION 'BUP_TB056_SELECT_SINGLE'
    EXPORTING
      i_object        = 'BUPA'
      i_develop       = 'IBANONLY'
    IMPORTING
      e_dev_is_active = lv_bp_iban_only
    EXCEPTIONS
      not_found       = 1
      OTHERS          = 2.

  IF sy-subrc <> 0.
*do nothing
  ENDIF.

  IF lv_bp_iban_only IS INITIAL.
*IBAN ONLY is switched OFF for Business Partner.  Remove all the bankdetails which have technical
*account number
    DELETE e_partner_bankdetails-bankdetails WHERE data-bank_acct(6) EQ '<IBAN>'.

  ELSE.
*IBAN ONLY is switched ON for Business Partner.  Clear all technical account numbers since Business
*Partner does not support technical account numbers.
    LOOP AT e_partner_bankdetails-bankdetails INTO ls_bp_bankdetails
      WHERE data-bank_acct(6) EQ '<IBAN>'.
      CLEAR ls_bp_bankdetails-data-bank_acct.
      MODIFY e_partner_bankdetails-bankdetails FROM ls_bp_bankdetails INDEX sy-tabix
             TRANSPORTING data-bank_acct.

      CLEAR ls_bp_bankdetails.
    ENDLOOP.
  ENDIF.

endmethod.


method if_ex_cvi_map_bankdetails~map_vendor_bank_data.
  data:
    ls_bp_bankdetails   LIKE LINE OF e_partner_bankdetails-bankdetails,
    lv_bp_iban_only     TYPE c.
  field-symbols:
    <bankdetails>       like line of i_vendor_bankdetails-bankdetails.

  if i_vendor_bankdetails-current_state = true.
    e_partner_bankdetails-current_state = true.
  endif.

  loop at i_vendor_bankdetails-bankdetails assigning <bankdetails>.

    ls_bp_bankdetails-data-bank_ctry       = <bankdetails>-data_key-banks.
    ls_bp_bankdetails-data-bank_key        = <bankdetails>-data_key-bankl.
    ls_bp_bankdetails-data-bank_acct       = <bankdetails>-data_key-bankn.

    ls_bp_bankdetails-data-ctrl_key        = <bankdetails>-data-bkont.
    ls_bp_bankdetails-data-coll_auth       = <bankdetails>-data-xezer.
    ls_bp_bankdetails-data-bank_ref        = <bankdetails>-data-bkref.
    ls_bp_bankdetails-data-accountholder   = <bankdetails>-data-koinh.
    ls_bp_bankdetails-data-iban            = <bankdetails>-data-iban.
    ls_bp_bankdetails-data-iban_from_date  = <bankdetails>-data-iban_from_date.

    ls_bp_bankdetails-datax-ctrl_key       = <bankdetails>-datax-bkont.
    ls_bp_bankdetails-datax-coll_auth      = <bankdetails>-datax-xezer.
    ls_bp_bankdetails-datax-bank_ref       = <bankdetails>-datax-bkref.
    ls_bp_bankdetails-datax-accountholder  = <bankdetails>-datax-koinh.
    ls_bp_bankdetails-datax-iban           = <bankdetails>-datax-iban.
    ls_bp_bankdetails-datax-iban_from_date = <bankdetails>-datax-iban_from_date.

    case <bankdetails>-task.
      when task_insert.
        ls_bp_bankdetails-task = 1.
      when task_update.
        ls_bp_bankdetails-task = 2.
      when task_delete.
        ls_bp_bankdetails-task = 4.
      when task_modify.
        ls_bp_bankdetails-task = 1.
      when others.
    endcase.

    append ls_bp_bankdetails to e_partner_bankdetails-bankdetails.
    clear ls_bp_bankdetails.                                " n_1722094
  ENDLOOP.

*Check if IBAN ONLY is switched ON or OFF for Business Partner
  CALL FUNCTION 'BUP_TB056_SELECT_SINGLE'
    EXPORTING
      i_object        = 'BUPA'
      i_develop       = 'IBANONLY'
    IMPORTING
      e_dev_is_active = lv_bp_iban_only
    EXCEPTIONS
      not_found       = 1
      OTHERS          = 2.

  IF sy-subrc <> 0.
*do nothing
  ENDIF.

  IF lv_bp_iban_only IS INITIAL.
*IBAN ONLY is switched OFF for Business Partner.  Remove all the bankdetails which have technical
*account number
    DELETE e_partner_bankdetails-bankdetails WHERE data-bank_acct(6) EQ '<IBAN>'.

  ELSE.
*IBAN ONLY is switched ON for Business Partner.  Clear all technical account numbers since Business
*Partner does not support technical account numbers.
    LOOP AT e_partner_bankdetails-bankdetails INTO ls_bp_bankdetails
      WHERE data-bank_acct(6) EQ '<IBAN>'.
      CLEAR ls_bp_bankdetails-data-bank_acct.
      MODIFY e_partner_bankdetails-bankdetails FROM ls_bp_bankdetails INDEX sy-tabix
             TRANSPORTING data-bank_acct.

      CLEAR ls_bp_bankdetails.
    ENDLOOP.
  ENDIF.

endmethod.
ENDCLASS.
