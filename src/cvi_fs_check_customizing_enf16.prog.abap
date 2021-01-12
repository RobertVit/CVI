*----------------------------------------------------------------------*
***INCLUDE CVI_FS_CHECK_CUSTOMIZING_ENF16.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form CHECK_CUSTOMER_DIRECTIONS_0700
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form check_customer_directions_0700 .
if gt_bp_to_customer_r is not initial.
    read table gt_mdsc_ctrl_opt_a with key sync_obj_source = gc_bp
                                     sync_obj_target = gc_customer
                                     active_indicator = gc_true transporting no fields.
    if sy-subrc <> 0.
      perform write_log_table_0700 using gv_icon_yellow 012 gc_false gc_false.
      message e012(cvi_fs_check_cust_en) into gv_dummy_msg.
      "BP Roles are marked as customer roles, but direction bp->customer is not active
    endif.
  endif.
  if gt_bp_to_customer_n is not initial.
    read table gt_mdsc_ctrl_opt_a with key sync_obj_source = gc_bp
                                     sync_obj_target = gc_customer
                                     active_indicator = gc_true transporting no fields.
    if sy-subrc <> 0.
      perform write_log_table_0700 using gv_icon_yellow 013 gc_false gc_false.
      message e013(cvi_fs_check_cust_en) into gv_dummy_msg."Numbers are assigned, but
      "direction bp->customer is not active
    endif.
  endif.

endform.
*&---------------------------------------------------------------------*
*& Form CHECK_CUSTOMER_EXISTENCE_0700
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form check_customer_existence_0700 .
*check whether bp roles still exist
  select * from tb003a into table gt_tb003a.
  loop at gt_bp_to_customer_r assigning <gt_bp_to_customer_r>.
    read table gt_tb003a with key rolecategory = <gt_bp_to_customer_r>-rltyp transporting no fields.
    if sy-subrc <> 0.
      perform write_log_table_0700 using gv_icon_red 016 text-016 <gt_bp_to_customer_r>-rltyp.
      message e016(cvi_fs_check_cust_en) with gc_false gc_false into gv_dummy_msg."BP Role has been deleted
    endif.
  endloop.

* Check missing describtion of bp role
  loop at gt_bp_to_customer_r assigning <gt_bp_to_customer_r>.
    if <gt_bp_to_customer_r>-rlctxt = ' '.
      perform write_log_table_0700 using gv_icon_yellow 037 text-016 <gt_bp_to_customer_r>-rltyp.
      message e037(cvi_fs_check_cust_en) with gc_false gc_false into gv_dummy_msg."BP Role has no describtion
    endif.
  endloop.

*Check whether account groups still exist
  loop at gt_bp_to_customer_n assigning <gt_bp_to_customer_n>.
    read table gt_t077d with key ktokd = <gt_bp_to_customer_n>-ktokd transporting no fields.
    if sy-subrc <> 0.
      perform write_log_table_0700 using gv_icon_red 017 text-016 <gt_bp_to_customer_n>-ktokd.
      message e017(cvi_fs_check_cust_en) with gc_false gc_false into gv_dummy_msg."Customer Account group has been deleted
    endif.
    read table gt_nriv with key nrrangenr = <gt_bp_to_customer_n>-numkr transporting no fields.
    if sy-subrc <> 0.
      perform write_log_table_0700 using gv_icon_red 018 <gt_bp_to_customer_n>-numkr text-014.
      message e018(cvi_fs_check_cust_en) with gc_false into gv_dummy_msg."Number Range has been deleted
    endif.
    read table gt_nriv with key nrrangenr = <gt_bp_to_customer_n>-nrrng transporting no fields.
    if sy-subrc <> 0.
      perform write_log_table_0700 using gv_icon_red 018 <gt_bp_to_customer_n>-nrrng text-013.
      message e018(cvi_fs_check_cust_en) with gc_false into gv_dummy_msg."Number Range has been deleted
    endif.
  endloop.


endform.
*&---------------------------------------------------------------------*
*& Form CHECK_CUSTOMER_ROLES_0700
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form check_customer_roles_0700 .
  if gt_bp_to_customer_r is not initial. "at least one entry exists
    if gt_bp_to_customer_n is initial.
      perform write_log_table_0700 using gv_icon_red 019 gc_false gc_false.
      message e019(cvi_fs_check_cust_en) into gv_dummy_msg.
      "BP Roles are marked as customer Roles, but no numbers are assigned
    endif.
  endif.


endform.
*&---------------------------------------------------------------------*
*& Form CHECK_CUSTOMER_NUMBERS_0700
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form check_customer_numbers_0700 .
*Check the number ranges
  data: ls_nr1 like line of gt_nriv,
        ls_nr2 like line of gt_nriv.

  loop at gt_bp_to_customer_n assigning <gt_bp_to_customer_n>.
    if <gt_bp_to_customer_n>-xsamenumber = gc_true.
      read table gt_nriv with key object = gc_bu_partner
                                nrrangenr = <gt_bp_to_customer_n>-nrrng into ls_nr1.
      read table gt_nriv with key object = gc_debitor
                                nrrangenr = <gt_bp_to_customer_n>-numkr into ls_nr2.
      if ls_nr1-fromnumber <> ls_nr2-fromnumber or
           ls_nr1-tonumber <> ls_nr2-tonumber.
        perform write_log_table_0700 using gv_icon_red 023 <gt_bp_to_customer_n>-nrrng
                                      <gt_bp_to_customer_n>-numkr.
        message e023(cvi_fs_check_cust_en) with gc_false gc_false into gv_dummy_msg.
        "Same Number flag is set, but Number Ranges don't match
      endif.
    endif.
  endloop.

endform.
*&---------------------------------------------------------------------*
*& Form write_log_table_0700_0700
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*      -->P_GV_ICON_GREEN  text
*      -->P_032    text
*      -->P_GC_FALSE  text
*      -->P_GC_FALSE  text
*&------
*&---------------------------------------------------------------------*
*& Form WRITE_LOG_TABLE_0700
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*      -->P_GV_ICON_GREEN  text
*      -->P_032    text
*      -->P_GC_FALSE  text
*      -->P_GC_FALSE  text
*&---------------------------------------------------------------------*
form write_log_table_0700 using  lv_icon type c
                           lv_msg_nr type sy-msgno
                           lv_text1 type c
                           lv_text2 type c.
  concatenate 'CVI_FS_CHECK_CUST_EN' lv_msg_nr into gs_log_table-msg.
  message id 'CVI_FS_CHECK_CUST_EN' type 'I' number lv_msg_nr with lv_text1 lv_text2 into gs_log_table-text.
  gs_log_table-longtext = gv_icon_help.
  gs_log_table-icon = lv_icon.
  append gs_log_table to gt_log_table_0700.
  clear gs_log_table..

endform.
