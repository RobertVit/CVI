*----------------------------------------------------------------------*
***INCLUDE CVI_FS_CHECK_CUSTOMIZING_ENF10.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form SAVE_CUST_PRE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form save_cust_pre .

  data: lt_cvic_cust_to_bp2 type table of cvic_cust_to_bp2,
        ls_cvic_cust_to_bp2 type cvic_cust_to_bp2,
        lt_tbd001           type table of tbd001,
        ls_tbd001           type tbd001.

  data: ls_outtab_role like line of gt_outtab_role.


  if gr_alv_role is not initial.
    gr_alv_role->check_changed_data( ).
  endif.
  clear ls_outtab_role.

       loop at gt_outtab_role into ls_outtab_role.
    if ls_outtab_role-ac_gp is not initial and ls_outtab_role-role is not initial.
      select single * from cvic_cust_to_bp2 into ls_cvic_cust_to_bp2
        where role = ls_outtab_role-role and account_group = ls_outtab_role-ac_gp.
      if sy-subrc <> 0.
      ls_cvic_cust_to_bp2-client = sy-mandt.
      ls_cvic_cust_to_bp2-account_group = ls_outtab_role-ac_gp.
      ls_cvic_cust_to_bp2-role = ls_outtab_role-role.
      append ls_cvic_cust_to_bp2 to lt_cvic_cust_to_bp2.
      modify cvic_cust_to_bp2 from table lt_cvic_cust_to_bp2.
*      if sy-subrc eq 0.
*        ls_tbd001-client = sy-mandt.
*        ls_tbd001-ktokd = ls_outtab_role-ac_gp.
*        ls_tbd001-bu_group = ls_outtab-bp_gp.
*        ls_tbd001-xsamenumber = ls_outtab-s_no.
*        append ls_tbd001 to lt_tbd001.
*        modify tbd001 from table lt_tbd001.
*      endif.

      else.
         MESSAGE 'Choose Different Value From Role dropdown' TYPE 'S' display like 'E'.
      endif.
*     delete  gt_outtab_role where ac_gp = ls_outtab_role-ac_gp and role = ls_outtab_role-role.
*      if sy-subrc eq 0.
*        ls_tbd001-client = sy-mandt.
*        ls_tbd001-ktokd = ls_outtab_role-ac_gp.
*        append ls_tbd001 to lt_tbd001.
*        modify tbd001 from table lt_tbd001.
*      endif.
    endif.
  endloop.

  data: lt_cvic_cust_to_bp1 type table of cvic_cust_to_bp1,
        ls_cvic_cust_to_bp1 type cvic_cust_to_bp1.

  data: ls_outtab like line of gt_outtab.
  if gr_alv_ac_gp is not initial.
    gr_alv_ac_gp->check_changed_data( ).
  endif.
  clear ls_outtab.
  loop at gt_outtab into ls_outtab.
    if ls_outtab-bp_gp is not initial and ls_outtab-ac_gp is not initial.
      ls_cvic_cust_to_bp1-client = sy-mandt.
      ls_cvic_cust_to_bp1-account_group = ls_outtab-ac_gp.
      ls_cvic_cust_to_bp1-grouping = ls_outtab-bp_gp.
      ls_cvic_cust_to_bp1-same_number = ls_outtab-s_no.
      append ls_cvic_cust_to_bp1 to lt_cvic_cust_to_bp1.
      modify cvic_cust_to_bp1 from table lt_cvic_cust_to_bp1.

*      if sy-subrc eq 0.
*        ls_tbd001-client = sy-mandt.
*        ls_tbd001-ktokd = ls_outtab-ac_gp.
*        ls_tbd001-bu_group = ls_outtab-bp_gp.
*        ls_tbd001-xsamenumber = ls_outtab-s_no.
*        append ls_tbd001 to lt_tbd001.
*        modify tbd001 from table lt_tbd001.
*      endif.
    endif.
  endloop.


*  if gv_flag_insert is not initial and lv_flag = 'c'.
*  refresh gt_outtab.
*  clear gv_flag_insert.
*  clear gv_count.
*  else.
*   refresh gt_outtab_role.
*  clear gv_flag_insert.
*  clear gv_count.
*endif.


if gv_count is not initial OR gv_flag_insert is not initial and lv_flag = 'c'.
  refresh gt_outtab.
  clear gv_flag_insert.
  clear gv_count.
  refresh gt_outtab_role.
*  clear gv_flag_insert.
*  clear gv_count.
endif.

endform.

form save_vend_pre.


  data: lt_cvic_vend_to_bp2 type table of cvic_vend_to_bp2,
        ls_cvic_vend_to_bp2 type cvic_vend_to_bp2,
        lt_tbc001           type table of tbc001,
        ls_tbc001           type tbc001.

  data: ls_outtab_role like line of gt_outtab_role.
  if gr_alv_role is not initial.
    gr_alv_role->check_changed_data( ).
  endif.
  clear ls_outtab_role.
      loop at gt_outtab_role into ls_outtab_role.
    if ls_outtab_role-ac_gp is not initial and ls_outtab_role-role is not initial.
      select single * from cvic_vend_to_bp2 into ls_cvic_vend_to_bp2
        where role = ls_outtab_role-role and account_group = ls_outtab_role-ac_gp.
      if sy-subrc <> 0.
      ls_cvic_vend_to_bp2-client = sy-mandt.
      ls_cvic_vend_to_bp2-account_group = ls_outtab_role-ac_gp.
      ls_cvic_vend_to_bp2-role = ls_outtab_role-role.
      append ls_cvic_vend_to_bp2 to lt_cvic_vend_to_bp2.
      modify cvic_vend_to_bp2 from table lt_cvic_vend_to_bp2.
      else.
         MESSAGE 'Choose Different Value From Role dropdown' TYPE 'S' display like 'E'.
      endif.
*     delete  gt_outtab_role where ac_gp = ls_outtab_role-ac_gp and role = ls_outtab_role-role.
*      if sy-subrc eq 0.
*        ls_tbd001-client = sy-mandt.
*        ls_tbd001-ktokd = ls_outtab_role-ac_gp.
*        append ls_tbd001 to lt_tbd001.
*        modify tbd001 from table lt_tbd001.
*      endif.
    endif.
  endloop.




  data: lt_cvic_vend_to_bp1 type table of cvic_vend_to_bp1,
        ls_cvic_vend_to_bp1 type cvic_vend_to_bp1.

  data: ls_outtab like line of gt_outtab.
  if gr_alv_ac_gp is not initial.
    gr_alv_ac_gp->check_changed_data( ).
  endif.
  clear ls_outtab.
  loop at gt_outtab into ls_outtab.
    if ls_outtab-bp_gp is not initial and ls_outtab-ac_gp is not initial.
      ls_cvic_vend_to_bp1-client = sy-mandt.
      ls_cvic_vend_to_bp1-account_group = ls_outtab-ac_gp.
      ls_cvic_vend_to_bp1-grouping = ls_outtab-bp_gp.
      ls_cvic_vend_to_bp1-same_number = ls_outtab-s_no.
      append ls_cvic_vend_to_bp1 to lt_cvic_vend_to_bp1.
      modify cvic_vend_to_bp1 from table lt_cvic_vend_to_bp1.
*      if sy-subrc eq 0.
*        ls_tbc001-client = sy-mandt.
*        ls_tbc001-ktokk = ls_outtab-ac_gp.
*        ls_tbc001-bu_group = ls_outtab-bp_gp.
*        ls_tbc001-xsamenumber = ls_outtab-s_no.
*        append ls_tbc001 to lt_tbc001.
*        modify tbc001 from table lt_tbc001.
*      endif.
    endif.
  endloop.

if gv_count is not initial OR gv_flag_insert is not initial and lv_flag <> 'c'.
  refresh gt_outtab.
  clear gv_flag_insert.
  clear gv_count.
  refresh gt_outtab_role.
*  clear gv_flag_insert.
*  clear gv_count.
endif.

*if gv_flag_insert is not initial and lv_flag <> 'c'.
*  refresh gt_outtab.
*  clear gv_flag_insert.
*  clear gv_count.
*  else.
*   refresh gt_outtab_role.
*  clear gv_flag_insert.
*  clear gv_count.
*endif.
*
*
*if gv_count is not initial and lv_flag <> 'c'.
*  refresh gt_outtab.
*  clear gv_flag_insert.
*  clear gv_count.
*else.
*  refresh gt_outtab_role.
*  clear gv_flag_insert.
*  clear gv_count.
*endif.
endform.
form save_vend_mapping.
"vend value mapping
 data:        lt_tp038m1 type table of tp038m1,
        ls_tp038m1 like line of lt_tp038m1,
         lt_tp038m2 type table of tp038m2,
        ls_tp038m2 like line of lt_tp038m2.
data :lv_error type bool value abap_false.

  data:   ls_outtab_ind_sys like line of gt_outtab_ind_sys,
             ls_outtab_ind_in like line of gt_outtab_ind_in,
         lv_isys type bu_istype.


  "industry system and key save
   if gr_alv_ind_in is not initial.
    gr_alv_ind_in->check_changed_data( ).
  endif.
   if gr_alv_ind_out is not initial.
    gr_alv_ind_out->check_changed_data( ).
  endif.
  clear ls_outtab_ind_sys.
      loop at gt_outtab_ind_sys into ls_outtab_ind_sys.
        if ls_outtab_ind_sys-isys_check = 'X'.
          lv_isys = ls_outtab_ind_sys-indsys.
         endif.
       endloop.

      if ind_out = ' '.
         loop at gt_outtab_ind_in into ls_outtab_ind_in.
        if ls_outtab_ind_in-indkey is not initial and ls_outtab_ind_in-ikey_check = 'X' .
          ls_tp038m2-client = sy-mandt.
          ls_tp038m2-istype = lv_isys.
          ls_tp038m2-ind_sector = ls_outtab_ind_in-indsector.
          ls_tp038m2-brsch = ls_outtab_ind_in-indkey.
          append ls_tp038m2 to lt_tp038m2.
        endif.
      endloop.
           modify tp038m2 from table lt_tp038m2.
else.
   loop at gt_outtab_ind_in into ls_outtab_ind_in.
    clear lt_tp038m1.
        if ls_outtab_ind_in-indkey is not initial and ls_outtab_ind_in-ikey_check = 'X' .
          select * from tp038m1 into table lt_tp038m1 where istype = lv_isys and  ind_sector = ls_outtab_ind_in-indsector.
            if sy-subrc ne 0 and ls_outtab_ind_in-indsector is not initial.
              clear lt_tp038m1.
          ls_tp038m1-client = sy-mandt.
          ls_tp038m1-istype = lv_isys.
          ls_tp038m1-ind_sector = ls_outtab_ind_in-indsector.
          ls_tp038m1-brsch = ls_outtab_ind_in-indkey.
          append ls_tp038m1 to lt_tp038m1.
          modify tp038m1 from table lt_tp038m1.
          else.
            lv_error = abap_true.
          endif.
        endif.
      endloop.
*       modify tp038m1 from table lt_tp038m1.
      if lv_error = abap_true.
        message 'Industry Sector already exists for Industry system.Choose new Industry system or create New Industry sector' type 'S' display like 'E'.
      endif.
       if sy-subrc = 0.
         COMMIT WORK.
         endif.
      clear ls_tp038m1.
      refresh lt_tp038m1.
  endif.


endform.
*&---------------------------------------------------------------------*
*& Form SAVE_CUST_VALUE_PRE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form save_cust_value_pre .
 data: lt_cvic_cp1_link    type table of cvic_cp1_link,
        ls_cvic_cp1_link    like line of  lt_cvic_cp1_link,
        lt_cvic_cp2_link    type table of cvic_cp2_link,
        ls_cvic_cp2_link    like line of  lt_cvic_cp2_link,
        lt_cvic_cp3_link    type table of cvic_cp3_link,
        ls_cvic_cp3_link    like line of  lt_cvic_cp3_link,
        lt_cvic_cp4_link    type table of cvic_cp4_link,
        ls_cvic_cp4_link    like line of  lt_cvic_cp4_link,
        lt_cvic_marst_link  type table of cvic_marst_link,
        ls_cvic_marst_link  like line of  lt_cvic_marst_link,
        lt_cvic_ccid_link   type table of cvic_ccid_link,
        ls_cvic_ccid_link   like line of  lt_cvic_ccid_link,
        lt_cvic_legform_lnk type table of cvic_legform_lnk,
        ls_cvic_legform_lnk like line of  lt_cvic_legform_lnk,
         lt_cvic_map_contact type table of cvic_map_contact,
        ls_cvic_map_contact like line of  lt_cvic_map_contact.

  data: ls_outtab_d like line of gt_outtab_d,
         ls_outtab_fn like line of gt_outtab_fn,
         ls_outtab_au like line of gt_outtab_au,
         ls_outtab_vip like line of gt_outtab_vip,
         ls_outtab_marital like line of gt_outtab_marital,
         ls_outtab_legal like line of gt_outtab_legal,
         ls_outtab_pcard like line of gt_outtab_pcard,
         ls_cp like line of gt_cp,
         lv_legal_form_key type char2,
         lv_poa_bp_key type bu_paauth,
         lv_vip_bp_key type bu_pavip,
         lv_fn_bp_key type bu_pafkt,
         lv_dep_bp_key type bu_abtnr,
         lv_marst_bp_key TYPE bu_marst,
         lv_pcard_bp_key TYPE cc_institute.

"cp assign save
    if gr_alv_cpassign is not initial.
    gr_alv_cpassign->check_changed_data( ).
  endif.
  clear ls_cp.
  loop at gt_cp into ls_cp.
    if ls_cp-cp_assign is not initial.
        ls_cvic_map_contact-client = sy-mandt.
          ls_cvic_map_contact-map_contact = ls_cp-cp_assign.
          append ls_cvic_map_contact to lt_cvic_map_contact.
    endif.

  endloop.
  modify cvic_map_contact from table lt_cvic_map_contact.
  refresh gt_outtab_cp.


 "Modify link table for contact person deptartments
  if gr_alv_dept is not initial.
    gr_alv_dept->check_changed_data( ).
  endif.
  clear ls_outtab_d.

  loop at gt_outtab_d into ls_outtab_d WHERE bp_dept_text IS NOT INITIAL.
    if ls_outtab_d-dept is not initial and ls_outtab_d-dept_check = 'X'.
          ls_cvic_cp1_link-client = sy-mandt.
          ls_cvic_cp1_link-abtnr = ls_outtab_d-dept.
          lv_dep_bp_key = ls_outtab_d-bp_dept_text.
          ls_cvic_cp1_link-gp_abtnr = lv_dep_bp_key.
          append ls_cvic_cp1_link to lt_cvic_cp1_link.
        endif.
      endloop.
      modify cvic_cp1_link from table lt_cvic_cp1_link.
      refresh gt_outtab_d.
*if gr_alv_dept is not initial.
*    call method gr_alv_dept->free.
*    clear gr_alv_dept.
*  endif.
*if gr_cont_dept is not initial.
*    call method gr_cont_dept->free.
*    clear gr_cont_dept.
*  endif.

  "Modify link table for contact person functions
       if gr_alv_fn is not initial.
    gr_alv_fn->check_changed_data( ).
  endif.
  clear ls_outtab_fn.
  loop at gt_outtab_fn into ls_outtab_fn WHERE bp_fn_text IS NOT INITIAL.
  if ls_outtab_fn-fn is not initial and ls_outtab_fn-fn_check = 'X' .
          ls_cvic_cp2_link-client = sy-mandt.
          ls_cvic_cp2_link-pafkt = ls_outtab_fn-fn.
          lv_fn_bp_key = ls_outtab_fn-bp_fn_text.
          ls_cvic_cp2_link-gp_pafkt = lv_fn_bp_key.
          append ls_cvic_cp2_link to lt_cvic_cp2_link.
        endif.
      endloop.
      modify cvic_cp2_link from table lt_cvic_cp2_link.


  "Contact person authority assignment CVI to BP
   if gr_alv_au is not initial.
    gr_alv_au->check_changed_data( ).
  endif.
  clear ls_outtab_au.
  loop at gt_outtab_au into ls_outtab_au WHERE bp_poa_auth IS NOT INITIAL.

       if ls_outtab_au-auth is not initial and ls_outtab_au-auth_check = 'X' .
          ls_cvic_cp3_link-client = sy-mandt.
          ls_cvic_cp3_link-parvo = ls_outtab_au-auth.
          lv_poa_bp_key = ls_outtab_au-bp_poa_auth.
          ls_cvic_cp3_link-paauth = lv_poa_bp_key.
          append ls_cvic_cp3_link to lt_cvic_cp3_link.
        endif.
      endloop.

      modify cvic_cp3_link from table lt_cvic_cp3_link.
      modify tvpv from TABLE lt_cvic_cp3_link. " modify only PoA from this table
      refresh gt_outtab_au.


  "VIP Indicator assignment CVI to BP
     if gr_alv_vip is not initial.
    gr_alv_vip->check_changed_data( ).
  endif.
  clear ls_outtab_vip.
    loop at gt_outtab_vip into ls_outtab_vip WHERE bp_vip_text IS NOT INITIAL.
        if ls_outtab_vip-vip is not initial and ls_outtab_vip-vip_check = 'X' .
          ls_cvic_cp4_link-client = sy-mandt.
          ls_cvic_cp4_link-pavip = ls_outtab_vip-vip.
          lv_vip_bp_key = ls_outtab_vip-bp_vip_text.
          ls_cvic_cp4_link-gp_pavip = lv_vip_bp_key."ls_outtab_vip-vip.
          append ls_cvic_cp4_link to lt_cvic_cp4_link.
        endif.
      endloop.
      modify cvic_cp4_link from table lt_cvic_cp4_link.
refresh gt_outtab_vip.

  "Marital status assignment CVI to BP

      if gr_alv_marital is not initial.
    gr_alv_marital->check_changed_data( ).
  endif.
  clear ls_outtab_marital.
      loop at gt_outtab_marital into ls_outtab_marital WHERE bp_marst_text IS NOT INITIAL.
        if ls_outtab_marital-mstat is not initial and ls_outtab_marital-mstat_check = 'X' .
          ls_cvic_marst_link-client = sy-mandt.
          ls_cvic_marst_link-famst = ls_outtab_marital-mstat.
          lv_marst_bp_key = ls_outtab_marital-bp_marst_text.
          ls_cvic_marst_link-marst  = lv_marst_bp_key . " remove and ad 2 more lines
          append ls_cvic_marst_link to lt_cvic_marst_link.


        endif.
      endloop.
      modify cvic_marst_link from table lt_cvic_marst_link.
refresh gt_outtab_marital.

 "Save Customer Legal status to BP Legal form
   if gr_alv_legal is not initial.
    gr_alv_legal->check_changed_data( ).
  endif.
  clear ls_outtab_legal.
  loop at gt_outtab_legal into ls_outtab_legal WHERE legal_form_bp IS NOT INITIAL.
        if ls_outtab_legal-legal is not initial and ls_outtab_legal-legal_check = 'X' .
          ls_cvic_legform_lnk-client = sy-mandt.
          ls_cvic_legform_lnk-gform = ls_outtab_legal-legal.
          lv_legal_form_key = ls_outtab_legal-legal_form_bp.
          ls_cvic_legform_lnk-legal_enty = lv_legal_form_key."ls_outtab_legal-legal_form_bp .
          append ls_cvic_legform_lnk to lt_cvic_legform_lnk.


        endif.
      endloop.
     modify cvic_legform_lnk from table lt_cvic_legform_lnk.
refresh gt_outtab_legal.

 "Save Payment card type assignment CVI to BP
  if gr_alv_pcard is not initial.
    gr_alv_pcard->check_changed_data( ).
  endif.
  clear ls_outtab_pcard.
       loop at gt_outtab_pcard into ls_outtab_pcard WHERE bp_pcard_text IS NOT INITIAL .
        if ls_outtab_pcard-pcard is not initial and ls_outtab_pcard-pcard_check = 'X' .
          ls_cvic_ccid_link-client = sy-mandt.
          ls_cvic_ccid_link-ccins = ls_outtab_pcard-pcard.
          lv_pcard_bp_key = ls_outtab_pcard-bp_pcard_text.
          ls_cvic_ccid_link-pcid_bp  = lv_pcard_bp_key .
          append ls_cvic_ccid_link to lt_cvic_ccid_link.


        endif.
      endloop.
      modify cvic_ccid_link from table lt_cvic_ccid_link.
refresh gt_outtab_pcard.

endform.
*&---------------------------------------------------------------------*
*& Form SAVE_CUST_PRE_INDUSTRY
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form save_cust_pre_industry .
"customer value mapping - industries save

data:        lt_tp038m1 type table of tp038m1,
        ls_tp038m1 like line of lt_tp038m1,
         lt_tp038m2 type table of tp038m2,
        ls_tp038m2 like line of lt_tp038m2.

  data:   ls_outtab_ind_sys like line of gt_outtab_ind_sys,
             ls_outtab_ind_in like line of gt_outtab_ind_in,
         lv_isys type bu_istype.
data :lv_error type bool value abap_false.

  "industry system and key save
   if gr_alv_ind_in is not initial.
    gr_alv_ind_in->check_changed_data( ).
  endif.

    if gr_alv_ind_out is not initial.
    gr_alv_ind_out->check_changed_data( ).
  endif.

  clear ls_outtab_ind_sys.
      loop at gt_outtab_ind_sys into ls_outtab_ind_sys.
        if ls_outtab_ind_sys-isys_check = 'X'.
          lv_isys = ls_outtab_ind_sys-indsys.
         endif.
       endloop.


      if ind_out = ' '.
         loop at gt_outtab_ind_in into ls_outtab_ind_in.
        if ls_outtab_ind_in-indkey is not initial and ls_outtab_ind_in-ikey_check = 'X' .
          ls_tp038m2-client = sy-mandt.
          ls_tp038m2-istype = lv_isys.
          ls_tp038m2-ind_sector = ls_outtab_ind_in-indsector.
          ls_tp038m2-brsch = ls_outtab_ind_in-indkey.
          append ls_tp038m2 to lt_tp038m2.

        endif.
      endloop.
modify tp038m2 from table lt_tp038m2.
else.
   loop at gt_outtab_ind_in into ls_outtab_ind_in.
     clear lt_tp038m1.
        if ls_outtab_ind_in-indkey is not initial and ls_outtab_ind_in-ikey_check = 'X' .
          select * from tp038m1 into table lt_tp038m1 where istype = lv_isys and  ind_sector = ls_outtab_ind_in-indsector.
            if sy-subrc ne 0 and ls_outtab_ind_in-indsector is not initial.
              clear lt_tp038m1.
          ls_tp038m1-client = sy-mandt.
          ls_tp038m1-istype = lv_isys.
          ls_tp038m1-ind_sector = ls_outtab_ind_in-indsector.
          ls_tp038m1-brsch = ls_outtab_ind_in-indkey.
          append ls_tp038m1 to lt_tp038m1.
          modify tp038m1 from table lt_tp038m1.
          else.
            lv_error = abap_true.
          endif.
        endif.
      endloop.
*       modify tp038m1 from table lt_tp038m1.
      if lv_error = abap_true.
        message 'Industry Sector already exists for Industry system.Choose new Industry system or create New Industry sector' type 'S' display like 'E'.
      endif.
       if sy-subrc = 0.
         COMMIT WORK.
         endif.
      clear ls_tp038m1.
      refresh lt_tp038m1.
  endif.
      "outgoing industry save
*      if gr_alv_ind_out is not initial.
*    gr_alv_ind_out->check_changed_data( ).
*  endif.
*  clear ls_outtab_ind_in.
*      loop at gt_outtab_ind_out into ls_outtab_ind_in.
*        if ls_outtab_ind_in-isys_check = 'X'.
*          lv_isys = ls_outtab_ind_in-indsys.
*         endif.
*       endloop.
*       loop at gt_outtab_ind_out into ls_outtab_ind_in.
*        if ls_outtab_ind_in-indkey is not initial and ls_outtab_ind_in-ikey_check = 'X' .
*          ls_tp038m1-client = sy-mandt.
*          ls_tp038m1-istype = lv_isys.
*          ls_tp038m1-ind_sector = ls_outtab_ind_in-indsector.
*          ls_tp038m1-brsch = ls_outtab_ind_in-indkey.
*          append ls_tp038m1 to lt_tp038m1.
*
*
*        endif.
*      endloop.
*              modify tp038m1 from table lt_tp038m1.
endform.
