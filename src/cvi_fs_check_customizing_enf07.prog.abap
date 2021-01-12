*----------------------------------------------------------------------*
***INCLUDE CVI_FS_CHECK_CUSTOMIZING_ENF07.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form SET_DATA_VENDOR2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form set_data_vendor2 .

  data : lv_lfa1      type lfa1-lifnr,
         lv_lfb1      type lfb1-lifnr,
         lv_lfm1      type lfm1-lifnr,
         lv_vend_acgp type lfa1-kunnr.

  data: lt_dropdown_role type lvc_t_drop,
        ls_dropdown_role type lvc_s_drop.

  data: lt_tbc002 type table of tbc002,
        ls_tbc002 type tbc002.

  data: ls_role            like line of gt_role,
        ls_outtab_role     like line of gt_outtab_role,
        ls_outtab_log_role like line of gt_outtab_log_role,
        ls_outtab_log      like line of gt_outtab_log.

  refresh: gt_outtab_log_ac, gt_outtab_log ,gt_outtab_log_role,gt_outtab_log_ac_fin.

*  if gv_flag_insert is initial.
*    refresh gt_outtab_role.
*  endif.



  ls_dropdown_role-handle = '1'.
  ls_dropdown_role-value = ''.
  append ls_dropdown_role to lt_dropdown_role.


  select * from tbc002 into table lt_tbc002 where kred = 'X'.
  loop at lt_tbc002 into ls_tbc002.
    if ls_tbc002-rltyp <> 'FLVN00' and ls_tbc002-rltyp <> 'FLVN01'.
      ls_dropdown_role-handle = '1'.
      ls_dropdown_role-value = ls_tbc002-rltyp.
      append ls_dropdown_role to lt_dropdown_role.
    endif.
  endloop.






  loop at gt_role into ls_role.
    move-corresponding ls_role to ls_outtab_role.

    select single ktokk into lv_vend_acgp from t077k where  ktokk = ls_role-ac_gp.

    if sy-subrc = 0.

      select single lifnr from lfa1 into lv_lfa1 where ktokk = ls_role-ac_gp. "#EC CI_NOFIELD

      if sy-subrc = 0.

        select single lifnr from lfb1 into lv_lfb1 where lifnr = lv_lfa1.

        if sy-subrc = 0.
          read table lt_dropdown_role into ls_dropdown_role with key value = 'FLVN00' .
          if sy-subrc <> 0.
            ls_dropdown_role-handle = '1'.
            ls_dropdown_role-value = 'FLVN00'.
            append ls_dropdown_role to lt_dropdown_role.
          endif.
        else.
          select single lifnr from lfm1 into lv_lfm1 where lifnr = lv_lfb1.
          if sy-subrc = 0.
            read table lt_dropdown_role into ls_dropdown_role with key value = 'FLVN01' .
            if sy-subrc <> 0.
              ls_dropdown_role-handle = '1'.
              ls_dropdown_role-value = 'FLVN01'.
              append ls_dropdown_role to lt_dropdown_role.
            endif.
          else.
            read table lt_dropdown_role into ls_dropdown_role with key value = 'FLVN00' .
            if sy-subrc <> 0.
              ls_dropdown_role-handle = '1'.
              ls_dropdown_role-value = 'FLVN00'.
              append ls_dropdown_role to lt_dropdown_role.
            endif.
            read table lt_dropdown_role into ls_dropdown_role with key value = 'FLVN01' .
            if sy-subrc <> 0.
              ls_dropdown_role-handle = '1'.
              ls_dropdown_role-value = 'FLVN01'.
              append ls_dropdown_role to lt_dropdown_role.
            endif.
          endif.
        endif.
      endif.
    endif.
  endloop.

  data : lt_t077k_role type table of t077k,
         ls_t077k_role type t077k.

  data : lt_role_acgp type  table of cvic_vend_to_bp2,
         ls_role_acgp type cvic_vend_to_bp2.



  loop at gt_role into ls_role.
    move-corresponding ls_role to ls_outtab_role.
    select * from t077k into table lt_t077k_role where ktokk = ls_role-ac_gp.
    if sy-subrc = 0 .
      select * from cvic_vend_to_bp2 into table lt_role_acgp where account_group = ls_role-ac_gp.
      if sy-subrc = 0 .
        loop at lt_role_acgp into ls_role_acgp.
          delete lt_dropdown_role where value = ls_role_acgp-role.
*            delete from lt_dropdown_role where value = ls_role_acgp-role.
        endloop.
        ls_outtab_role-role = ls_dropdown_role-value.
        ls_outtab_role-drop_down_handle = '1'.
      else.
       if ls_dropdown_role-value = 'FLVN00'.
          ls_outtab_role-role = ls_dropdown_role-value.
          ls_outtab_role-drop_down_handle = '1'.
          ls_outtab_role-role_desc = 'Business Partner FI Supplier'.
        elseif ls_dropdown_role-value = 'FLVN01'.
          ls_outtab_role-role = ls_dropdown_role-value.
          ls_outtab_role-drop_down_handle = '1'.
          ls_outtab_role-role_desc = 'Business Partner Supplier'.
        else.
          ls_outtab_role-role = ls_dropdown_role-value.
          ls_outtab_role-drop_down_handle = '1'.
          ls_outtab_role-role_desc = ''.
        endif.
      endif.
      if gv_flag_insert is initial and  gv_count is initial.
        append ls_outtab_role to gt_outtab_role.
      endif.

    else.
      concatenate ls_role-ac_gp  text-029 into ls_outtab_log_role-log separated by space.
      ls_outtab_log_role-chk = 'CHK_BP_ROLE'.
      ls_outtab_log_role-icon = gv_icon_red.
      ls_outtab_log_role-value = ls_role-ac_gp.
      ls_outtab_log_role-table = 't077k'.
      append ls_outtab_log_role to gt_outtab_log_role.
      append ls_outtab_log_role to gt_outtab_log.
    endif.
  endloop.

if gv_flag_insert is initial.
 sort gt_outtab_role by ac_gp.
  delete adjacent duplicates from gt_outtab_role comparing ac_gp.
endif.

*  if gt_outtab_log[] is not initial.
*    clear ls_outtab_log.
*    read table  gt_outtab_log[] with key  chk = 'CHK_BP_ROLE' into ls_outtab_log.
*    if sy-subrc = 0.
**      ls_outtab_log-log = text-034.
*      ls_outtab_log-log = 'Customization error in Supplier Account Group->Role Mapping.Check Customizing '.
*      ls_outtab_log-icon = gv_icon_red.
*      ls_outtab_log-chk = 'CHK_BP_ROLE'.
**          ls_outtab_log-log = text-034.
*      append ls_outtab_log to gt_outtab_log_ac_fin.
*    endif.
*  else.
*    ls_outtab_log-log = 'No Customization error in Supplier Account Group->Role Mapping.'.
*    ls_outtab_log-icon = gv_icon_green.
*    ls_outtab_log-chk = 'CHK_BP_ROLE'.
**          ls_outtab_log-log = text-034.
*    append ls_outtab_log to gt_outtab_log_ac_fin.
*  endif.
  clear ls_outtab_log.
  if gt_outtab_role[] is not initial.

    ls_outtab_log-log = 'Supplier Account Group->Role Mapping is inconsistent'.
    ls_outtab_log-chk = 'CHK_BP_ROLE'.
    ls_outtab_log-icon = gv_icon_red.
    append ls_outtab_log to gt_outtab_log_ac_fin.
  else.
    ls_outtab_log-log = 'Supplier Account Group->Role Mapping in consistent'.
    ls_outtab_log-chk = 'CHK_BP_ROLE'.
    ls_outtab_log-icon = gv_icon_green.
    append ls_outtab_log to gt_outtab_log_ac_fin.

  endif.


if gr_alv_role is initial .
  create object gr_alv_role
    exporting
      i_parent = gr_cont_role.
endif.

  call method gr_alv_role->set_drop_down_table
    exporting
      it_drop_down = lt_dropdown_role.



  data: lt_dropdown_1 type lvc_t_drop,
        lt_dropdown_2 type lvc_t_drop,
        ls_dropdown type lvc_s_drop.

  data: lt_tb001 type table of tb001,
        ls_tb001 type tb001.

  data: ls_account_group like line of gt_account_group,
        ls_outtab        like line of gt_outtab.

  data: lt_t077k type table of t077k,
        ls_t077k type t077k,
        lt_nriv  type table of nriv,
        ls_nriv  type nriv.

*clear gt_outtab[].
*  clear ls_dropdown.

  ls_dropdown-handle = '1'.
  ls_dropdown-value = ''.
  append ls_dropdown to lt_dropdown_1.

  ls_dropdown-handle = '2'.
  ls_dropdown-value = ''.
  append ls_dropdown to lt_dropdown_2.



  select * from tb001 into table lt_tb001 where bu_group is not null and nrrng ne ''. "#EC CI_BYPASS.
  loop at lt_tb001 into ls_tb001.
    select * from nriv into table lt_nriv where nrrangenr = ls_tb001-nrrng and object = 'BU_PARTNER'.
    if sy-subrc eq '0'.
      loop at lt_nriv into ls_nriv.
      endloop.
      if ls_nriv-externind = 'X'.
        ls_dropdown-handle = '2'.
        ls_dropdown-value = ls_tb001-bu_group.
        append ls_dropdown to lt_dropdown_2.
    else.
      ls_dropdown-handle = '1'.
      ls_dropdown-value = ls_tb001-bu_group.
        append ls_dropdown to lt_dropdown_1.
      endif.
    endif.

*    if ls_tb001-xexst = 'X'.
*      ls_dropdown-handle = '2'.
*      ls_dropdown-value = ls_tb001-bu_group.
*      append ls_dropdown to lt_dropdown.
*    else.
*      ls_dropdown-handle = '1'.
*      ls_dropdown-value = ls_tb001-bu_group.
*      append ls_dropdown to lt_dropdown.
*    endif.
  endloop.


*  call method gr_alv_ac_gp->set_drop_down_table
*    exporting
*      it_drop_down = lt_dropdown.

*  clear gt_outtab.
  loop at gt_account_group into ls_account_group.
    move-corresponding ls_account_group to ls_outtab.
    select * from t077k into table lt_t077k where ktokk = ls_account_group-ac_gp.
    if sy-subrc = 0.
      loop at lt_t077k into ls_t077k.
        select * from nriv into table lt_nriv where nrrangenr = ls_t077k-numkr and object = 'KREDITOR'.
        loop at lt_nriv into ls_nriv.
        endloop.
        if ls_nriv-externind = 'X'.
          loop at lt_dropdown_2 into ls_dropdown where handle = '2'.
            if ls_dropdown-value is not initial.
              exit.
            endif.
          endloop.
*          ls_outtab-bp_gp = '0002'.
          ls_outtab-bp_gp = ls_dropdown-value.
          ls_outtab-drop_down_handle = '2'.
        else.
          loop at lt_dropdown_1 into ls_dropdown where handle = '1'.
            if ls_dropdown-value is not initial.
              exit.
            endif.
          endloop.
*          ls_outtab-bp_gp = '0001'.
          ls_outtab-bp_gp = ls_dropdown-value.
          ls_outtab-drop_down_handle = '1'.
        endif.
        if gv_count is initial.
        append ls_outtab to gt_outtab.
        endif.
      endloop.
    else.
      concatenate ls_account_group-ac_gp  text-029 into ls_outtab_log-log separated by space.
      ls_outtab_log-chk = 'CHK_BP_AC'.
      ls_outtab_log-icon = gv_icon_red.
      ls_outtab_log-value = ls_account_group-ac_gp.
      ls_outtab_log-table = 't077k'.
      append ls_outtab_log to gt_outtab_log.
      append ls_outtab_log to gt_outtab_log_ac.
    endif.
  endloop.

   sort gt_outtab by ac_gp.
  delete adjacent duplicates from gt_outtab comparing ac_gp.


*  if gt_outtab_log[] is not initial.
*    clear ls_outtab_log.
*    read table  gt_outtab_log[] with key  chk = 'CHK_BP_AC' into ls_outtab_log.
*    if sy-subrc = 0.
*      ls_outtab_log-log = 'Customization error in Supplier Account Group->BP Grouping Mapping.Check Customizing'.
*      ls_outtab_log-chk = 'CHK_BP_AC'.
*      ls_outtab_log-icon = gv_icon_red.
*      append ls_outtab_log to gt_outtab_log_ac_fin.
*    endif.
*  else.
*    ls_outtab_log-log = 'No Customization error in Supplier Account Group->BP Grouping Mapping.'.
*    ls_outtab_log-icon = gv_icon_green.
*    ls_outtab_log-chk = 'CHK_BP_AC'.
*    append ls_outtab_log to gt_outtab_log_ac_fin.
*  endif.
  clear ls_outtab_log.
  if gt_outtab[] is not initial.

    ls_outtab_log-log = 'Supplier Account Group->BP Grouping Mapping is inconsistent'.
    ls_outtab_log-chk = 'CHK_BP_AC'.
    ls_outtab_log-icon = gv_icon_red.
    append ls_outtab_log to gt_outtab_log_ac_fin.
  else.
    ls_outtab_log-log = 'Supplier Account Group->BP Grouping Mapping in consistent'.
    ls_outtab_log-chk = 'CHK_BP_AC'.
    ls_outtab_log-icon = gv_icon_green.
    append ls_outtab_log to gt_outtab_log_ac_fin.

  endif.


  if gr_alv_ac_gp is initial .
  create object gr_alv_ac_gp
    exporting
      i_parent = gr_cont_ac_gp.
  endif.

  call method gr_alv_ac_gp->set_drop_down_table
    EXPORTING
      it_drop_down = lt_dropdown_1.

  call method gr_alv_ac_gp->set_drop_down_table
    EXPORTING
      it_drop_down = lt_dropdown_2.

  gv_count = 1.
*  endif.
  sort gt_outtab_log by value.
  delete adjacent duplicates from gt_outtab_log[] comparing value.
endform.                    "set_data_vendor2
*&---------------------------------------------------------------------*
*& Form SET_DATA_VENDOR3
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form set_data_vendor3 .
  data: lt_t016t            type table of t016t with header line,
        ls_t016t            like line of lt_t016t,
        lt_tb038t           type table of tb038t with header line,
        ls_tb038t           like line of lt_tb038t,
        lv_index            type i,
        lv_flag             type bool value gc_false,
        ls_outtab_ind_in    like line of gt_outtab_ind_in,
        ls_outtab_ind_out   like line of gt_outtab_ind_out,
        lt_t016             type table of t016 with header line,
        ls_t016             like line of lt_t016,
        ls_outtab_cust_log2 like line of gt_outtab_cust_log2.
  data: lt_tb038a type table of tb038a,
        ls_tb038a type tb038a.
  data: lt_dropdown_ind_in type lvc_t_drop,
        ls_dropdown_ind_in type lvc_s_drop.

  data: lt_tp038m2 type table of tp038m2,
        ls_tp038m2 like line of lt_tp038m2.
  data: lt_tp038m1 type table of tp038m1,
      ls_tp038m1 like line of lt_tp038m1.
  data: lv_lines(5) type i.
  data : lv_log type bool value abap_false.
  data : ls_outtab_ind_sys like line of gt_outtab_ind_sys.
  refresh : gt_outtab_ind_in,gt_outtab_ind_out,gt_outtab_cust_log2.
  clear:  gt_outtab_log_ind[],gt_outtab_ind_sys[].

  select distinct istype bez30 from tb038t into corresponding fields of table lt_tb038t where langu = sy-langu . "#EC CI_BYPASS.

  loop at lt_tb038t into ls_tb038t.


    ls_outtab_ind_sys-indsys = ls_tb038t-istype.
    ls_outtab_ind_sys-desc = ls_tb038t-bez30.
    append ls_outtab_ind_sys to gt_outtab_ind_sys.

  endloop.
  clear  ls_outtab_ind_sys.
  "setting the currently selected industry system
  loop at gt_outtab_ind_sys into ls_outtab_ind_sys.
    if ls_outtab_ind_sys-indsys = gv_istype.
      ls_outtab_ind_sys-isys_check = 'X'.
      modify gt_outtab_ind_sys index sy-tabix from ls_outtab_ind_sys transporting isys_check.
    endif.
  endloop.

  "processing incoming/outgoing industry keys

  if ind_in = 'X'.
    if gt_industry_in is not initial.
 select brsch from TP038M2 into table lt_tp038m2."  where brsch is not null.
IF sy-subrc = 0.
delete lt_tp038m2 WHERE brsch is INITIAL.
ENDIF.

select * from t016t into table lt_t016t where spras = sy-langu.

      select * from t016 into  table lt_t016  .
      "check whether industry key is maintained in t016
      loop at gt_industry_in into ls_outtab_ind_in.
         read table lt_t016 into ls_t016 with key brsch = ls_outtab_ind_in-indkey .
        if sy-subrc = 0.
          read table lt_t016t into ls_t016t with key brsch = ls_outtab_ind_in-indkey .

          if ls_outtab_ind_in-indkey = ls_t016t-brsch.
            ls_outtab_ind_in-desc = ls_t016t-brtxt.

          endif.
          ls_outtab_ind_in-ikey_check = 'X'.
          append ls_outtab_ind_in to gt_outtab_ind_in.

        else.
          concatenate ls_outtab_ind_in-indkey text-043 into ls_outtab_cust_log2-log separated by space.
          ls_outtab_cust_log2-chk = 'CHK_CP_IND_IN'.
          ls_outtab_cust_log2-icon = gv_icon_red.
          ls_outtab_cust_log2-value = ls_outtab_ind_in-indkey .
          append ls_outtab_cust_log2 to gt_outtab_cust_log2.
        endif.
      endloop.
      "loading all avilable industry sectors for current industry system
      select * from tb038a into table lt_tb038a where istype = gv_istype.

if lt_tb038a is initial.
   clear ls_outtab_cust_log2.
        ls_outtab_cust_log2-chk = 'CHK_CP_IND_IN'.
        ls_outtab_cust_log2-icon = gv_icon_red.
        ls_outtab_cust_log2-log = 'Create new industry sector to maintain industry keys for Industry System.Click to navigate'.
        append ls_outtab_cust_log2 to gt_outtab_log_ind.
  endif.
      loop at lt_tb038a into ls_tb038a.

        ls_dropdown_ind_in-handle = '1'.
        ls_dropdown_ind_in-value = ls_tb038a-ind_sector.
        append ls_dropdown_ind_in to lt_dropdown_ind_in.
      endloop.
      lv_index = 1.
      loop at gt_outtab_ind_in into ls_outtab_ind_in .
        ls_outtab_ind_in-indsector = ls_dropdown_ind_in-value.
        ls_outtab_ind_in-drop_down_handle = '1'.
        modify gt_outtab_ind_in index lv_index from ls_outtab_ind_in transporting indsector drop_down_handle.
        lv_index = lv_index + 1.
      endloop.
    endif.
    if gt_outtab_cust_log2[] is not initial.
      clear ls_outtab_cust_log2.
      read table  gt_outtab_cust_log2[] with key  chk = 'CHK_CP_IND_IN' into ls_outtab_cust_log2.
      if sy-subrc = 0.
        ls_outtab_cust_log2-log = 'Customization error in assignment of Incoming Industries.Check Customization '.
        ls_outtab_cust_log2-chk = 'CHK_CP_IND_IN'.
        ls_outtab_cust_log2-icon = gv_icon_red.
        append ls_outtab_cust_log2 to gt_outtab_log_ind.
      endif.
    else.
      ls_outtab_cust_log2-log = 'No Customization error in Assignment of Incoming Industries'.
      ls_outtab_cust_log2-chk = 'CHK_CP_IND_IN'.
      ls_outtab_cust_log2-icon = gv_icon_green.
      append ls_outtab_cust_log2 to gt_outtab_log_ind.
    endif.
    clear ls_outtab_cust_log2.
    if gt_outtab_ind_in[] is not initial.

      ls_outtab_cust_log2-log = 'Inconsistencies in assignment of Incoming Industries '.
      ls_outtab_cust_log2-chk = 'CHK_CP_IND_IN'.
      ls_outtab_cust_log2-icon = gv_icon_red.
      append ls_outtab_cust_log2 to gt_outtab_log_ind.
    else.
      ls_outtab_cust_log2-log = 'Assignment of Incoming Industries is consistent'.
      ls_outtab_cust_log2-chk = 'CHK_CP_IND_IN'.
      ls_outtab_cust_log2-icon = gv_icon_green.
      append ls_outtab_cust_log2 to gt_outtab_log_ind.

    endif.
  else.
    if gt_industry_out is not initial.
 select * from t016t into corresponding fields of table lt_t016t where spras = sy-langu.

      select * from t016 into table lt_t016  .
      loop at gt_industry_out into ls_outtab_ind_in.
        select * from t016 into table lt_t016 where  brsch = ls_outtab_ind_in-indkey .
        if sy-subrc = 0.


 read table lt_t016t into ls_t016t with key  brsch = ls_outtab_ind_in-indkey .
          read table lt_t016 into ls_t016 with key brsch = ls_outtab_ind_in-indkey .


          if ls_outtab_ind_in-indkey = ls_t016t-brsch.
            ls_outtab_ind_in-desc = ls_t016t-brtxt.

          endif.
          ls_outtab_ind_in-ikey_check = 'X'.
          append ls_outtab_ind_in to gt_outtab_ind_in.



        else.
          concatenate ls_outtab_ind_in-indkey text-043 into ls_outtab_cust_log2-log separated by space.
          ls_outtab_cust_log2-chk = 'CHK_CP_IND_OUT'.
          ls_outtab_cust_log2-icon = gv_icon_red.
          ls_outtab_cust_log2-value = ls_outtab_ind_in-indkey .
          append ls_outtab_cust_log2 to gt_outtab_cust_log2.

        endif.


      endloop.
      clear  lt_tb038a.
      select * from tb038a into table lt_tb038a where istype = gv_istype and ind_sector not in ( select ind_sector from tp038m1 where istype = gv_istype  ) . "#EC CI_BUFFSUBQ.
if lt_tb038a is initial.
  lv_log = abap_true.
  endif.
      describe table lt_tb038a lines lv_lines.
      ls_dropdown_ind_in-handle = '1'.
      ls_dropdown_ind_in-value = ' '.
      append ls_dropdown_ind_in to lt_dropdown_ind_in.
      loop at lt_tb038a into ls_tb038a.

        ls_dropdown_ind_in-handle = '1'.
        ls_dropdown_ind_in-value = ls_tb038a-ind_sector.
        append ls_dropdown_ind_in to lt_dropdown_ind_in.
      endloop.
      lv_index = 1.
      loop at gt_outtab_ind_in into ls_outtab_ind_in .
        if lv_index <= lv_lines.
          read table lt_tb038a index sy-tabix into ls_tb038a.
          ls_outtab_ind_in-indsector = ls_tb038a-ind_sector."ls_dropdown_ind_in-value.

        else.
          ls_outtab_ind_in-indsector = ' '.
          lv_log = abap_true.
        endif.
        ls_outtab_ind_in-drop_down_handle = '1'.
        modify gt_outtab_ind_in index lv_index from ls_outtab_ind_in transporting indsector drop_down_handle.
        lv_index = lv_index + 1.
      endloop.
      if lv_log = abap_true.
        clear ls_outtab_cust_log2.
        ls_outtab_cust_log2-chk = 'CHK_CP_IND_OUT'.
        ls_outtab_cust_log2-icon = gv_icon_red.
        ls_outtab_cust_log2-log = 'Create new industry sector to maintain industry keys for Outgoing Industry.Click to navigate'.
        append ls_outtab_cust_log2 to gt_outtab_log_ind.
      endif.
    endif.
    if gt_outtab_cust_log2[] is not initial.
      clear ls_outtab_cust_log2.
      read table  gt_outtab_cust_log2[] with key  chk = 'CHK_CP_IND_OUT' into ls_outtab_cust_log2.
      if sy-subrc = 0.
        ls_outtab_cust_log2-log = 'Customization error in assignment of Outgoing Industries.Check Customisation '.
        ls_outtab_cust_log2-chk = 'CHK_CP_IND_OUT'.
        ls_outtab_cust_log2-icon = gv_icon_red.
        append ls_outtab_cust_log2 to gt_outtab_log_ind.
      endif.
    else.
      ls_outtab_cust_log2-log = 'No Customization error in Assignment of Outgoing Industries'.
      ls_outtab_cust_log2-chk = 'CHK_CP_IND_OUT'.
      ls_outtab_cust_log2-icon = gv_icon_green.
      append ls_outtab_cust_log2 to gt_outtab_log_ind.
    endif.
    clear ls_outtab_cust_log2.
    if gt_outtab_ind_in[] is not initial.

      ls_outtab_cust_log2-log = 'Inconsistencies in assignment of Outgoing Industries '.
      ls_outtab_cust_log2-chk = 'CHK_CP_IND_OUT'.
      ls_outtab_cust_log2-icon = gv_icon_red.
      append ls_outtab_cust_log2 to gt_outtab_log_ind.
    else.
      ls_outtab_cust_log2-log = 'Assignment of Outgoing Industries consistent'.
      ls_outtab_cust_log2-chk = 'CHK_CP_IND_OUT'.
      ls_outtab_cust_log2-icon = gv_icon_green.
      append ls_outtab_cust_log2 to gt_outtab_log_ind.

    endif.

  endif.
  create object gr_alv_ind_out
    exporting
      i_parent = gr_cont_ind_out.
  call method gr_alv_ind_out->set_drop_down_table
    exporting
      it_drop_down = lt_dropdown_ind_in.
endform.                    "set_data_vendor3
