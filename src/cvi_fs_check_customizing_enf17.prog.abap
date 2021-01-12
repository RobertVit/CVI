*----------------------------------------------------------------------*
***INCLUDE CVI_FS_CHECK_CUSTOMIZING_ENF17.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form CHECK_VENDOR_DIRECTIONS_0800
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form check_vendor_directions_0800 .
if gt_bp_to_vendor_r is not initial.
    read table gt_mdsc_ctrl_opt_a with key sync_obj_source = gc_bp
                                     sync_obj_target = gc_vendor
                                     active_indicator = gc_true transporting no fields.
    if sy-subrc <> 0.
      perform write_log_table_0800 using gv_icon_yellow 024 gc_false gc_false.
      message e024(cvi_fs_check_cust_en) into gv_dummy_msg."BP Roles are marked as vendor roles
      "but direction bp->vendor is not active
    endif.
  endif.
  if gt_bp_to_vendor_n is not initial.
    read table gt_mdsc_ctrl_opt_a with key sync_obj_source = gc_bp
                                     sync_obj_target = gc_vendor
                                     active_indicator = gc_true transporting no fields.
    if sy-subrc <> 0.
      perform write_log_table_0800 using gv_icon_yellow 025 gc_false gc_false.
      message e025(cvi_fs_check_cust_en) into gv_dummy_msg."Numbers are assigned, but
      "direction bp->vendor is not active
    endif.
  endif.

endform.
*&---------------------------------------------------------------------*
*& Form CHECK_VENDOR_EXISTENCE_0800
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form check_vendor_existence_0800 .
  select * from tb003a into table gt_tb003a.
  loop at gt_bp_to_vendor_r assigning <gt_bp_to_vendor_r>.
    read table gt_tb003a with key rolecategory = <gt_bp_to_vendor_r>-rltyp transporting no fields.
    if sy-subrc <> 0.
      perform write_log_table_0800 using gv_icon_red 016 text-018 <gt_bp_to_vendor_r>-rltyp.
      message e016(cvi_fs_check_cust_en) with gc_false gc_false into gv_dummy_msg."BP Role has been deleted
    endif.
  endloop.

* Check missing describtion of bp role
  loop at gt_bp_to_vendor_r assigning <gt_bp_to_vendor_r>.
    if <gt_bp_to_vendor_r>-rlctxt = ' '.
      perform write_log_table_0800 using gv_icon_yellow 037 text-018 <gt_bp_to_vendor_r>-rltyp.
      message e037(cvi_fs_check_cust_en) with gc_false gc_false into gv_dummy_msg."BP Role has no describtion
    endif.
  endloop.

*Check whether account groups and number ranges still exist
  loop at gt_bp_to_vendor_n assigning <gt_bp_to_vendor_n>.
    read table gt_t077k with key ktokk = <gt_bp_to_vendor_n>-ktokk transporting no fields.
    if sy-subrc <> 0.
      perform write_log_table_0800 using gv_icon_red 017 text-018 <gt_bp_to_vendor_n>-ktokk.
      message e017(cvi_fs_check_cust_en) with gc_false gc_false into gv_dummy_msg."Vendor Account group has been deleted
    endif.
    read table gt_nriv with key nrrangenr = <gt_bp_to_vendor_n>-numkr transporting no fields.
    if sy-subrc <> 0.
      perform write_log_table_0800 using gv_icon_red 018 <gt_bp_to_vendor_n>-numkr text-015.
      message e018(cvi_fs_check_cust_en) with gc_false into gv_dummy_msg."Number Range has been deleted
    endif.
    read table gt_nriv with key nrrangenr = <gt_bp_to_vendor_n>-nrrng transporting no fields.
    if sy-subrc <> 0.
      perform write_log_table_0800 using gv_icon_red 018 <gt_bp_to_vendor_n>-nrrng text-013.
      message e018(cvi_fs_check_cust_en) with gc_false into gv_dummy_msg."Number Range has been deleted
    endif.
  endloop.

endform.
*&---------------------------------------------------------------------*
*& Form CHECK_VENDOR_ROLES_0800
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form check_vendor_roles_0800 .
*Check whether the bp role has an assigned vendor account group
  if gt_bp_to_vendor_r is not initial. "at least one entry exists
    if gt_bp_to_vendor_n is initial.
      perform write_log_table_0800 using gv_icon_red 028 gc_false gc_false.
      message e028(cvi_fs_check_cust_en) into gv_dummy_msg.
      "BP Roles are marked as Vendor Roles, but no numbers are assigned
    endif.
  endif.
endform.
*&---------------------------------------------------------------------*
*& Form CHECK_VENDOR_NUMBERS_0800
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form check_vendor_numbers_0800 .
 data: ls_nr1 like line of gt_nriv,
        ls_nr2 like line of gt_nriv.

  loop at gt_bp_to_vendor_n assigning <gt_bp_to_vendor_n>.
    if <gt_bp_to_vendor_n>-xsamenumber = gc_true.
      read table gt_nriv with key object = gc_bu_partner
                                nrrangenr = <gt_bp_to_vendor_n>-nrrng into ls_nr1.
      read table gt_nriv with key object = gc_kreditor
                                nrrangenr = <gt_bp_to_vendor_n>-numkr into ls_nr2.
      if ls_nr1-fromnumber <> ls_nr2-fromnumber or
           ls_nr1-tonumber <> ls_nr2-tonumber.
        perform write_log_table_0800 using gv_icon_red 023 <gt_bp_to_vendor_n>-nrrng
                                      <gt_bp_to_vendor_n>-numkr.
        message e023(cvi_fs_check_cust_en) with gc_false gc_false into gv_dummy_msg.
        "Same Number flag is set, but Number Ranges don't match
      endif.
    endif.
  endloop.
endform.
*&---------------------------------------------------------------------*
*& Form write_log_table_0800
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*      -->P_GV_ICON_GREEN  text
*      -->P_032    text
*      -->P_GC_FALSE  text
*      -->P_GC_FALSE  text
*&---------------------------------------------------------------------*
form write_log_table_0800  using    lv_icon type c
                           lv_msg_nr type sy-msgno
                           lv_text1 type c
                           lv_text2 type c.
  concatenate 'CVI_FS_CHECK_CUST_EN' lv_msg_nr into gs_log_table-msg.
  message id 'CVI_FS_CHECK_CUST_EN' type 'I' number lv_msg_nr with lv_text1 lv_text2 into gs_log_table-text.
  gs_log_table-longtext = gv_icon_help.
  gs_log_table-icon = lv_icon.
  append gs_log_table to gt_log_table_0800.
  clear gs_log_table.

endform.
