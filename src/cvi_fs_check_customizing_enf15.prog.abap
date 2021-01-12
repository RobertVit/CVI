*----------------------------------------------------------------------*
***INCLUDE CVI_FS_CHECK_CUSTOMIZING_ENF15.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form CUST_SAVE_POST
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form cust_save_post .

************TB038A outgoing**********************
  data: lt_tp038m2 type table of tp038m2,
        ls_tp038m2 type tp038m2,
        lt_tb038a        type table of tb038a,
        ls_tb038a          type tb038a.

  data: ls_tb038a_d like line of gt_tb038a_main.
  data: ls_tb038a_out_d like line of gt_tb038a_main_out.
  data : lt_tp038m2_db type table of tp038m2 with header line.
  data : ls_tp038m2_db like line  of lt_tp038m2.
  select * from tp038m2 into corresponding fields of table lt_tp038m2_db.
  if gt_tb038a_main_alv is not initial.
    gr_alv_tb038a_out->check_changed_data( ).
    clear ls_tb038a_d.
    if indin = 'X'.
      loop at gt_tb038a_main_alv into ls_tb038a_d.
        if ls_tb038a_d-istype_check is not initial.
          ls_tp038m2-client = sy-mandt.
          ls_tp038m2-istype = ls_tb038a_d-istype.
          ls_tp038m2-ind_sector = ls_tb038a_d-ind_sector.
          ls_tp038m2-brsch = ls_tb038a_d-indkey.
          read table lt_tp038m2_db into  ls_tp038m2_db with key istype = ls_tb038a_d-istype brsch = ls_tb038a_d-indkey.
          if sy-subrc = 0.
            message 'Industry Key already exists for Industry System. Choose new Industry Key or create New Industry Key' type 'S' display like 'E'.
          elseif ls_tb038a_d-indkey is initial.
            message 'Industry Keys not maintained. Maintain the keys by navigating from error log.' type 'S' display like 'E'.
          else.
            append ls_tp038m2 to lt_tp038m2.
          endif.
        endif.
      endloop.
    endif.
    if lt_tp038m2 is not initial.
      modify tp038m2 from table lt_tp038m2.
    endif.
  endif.


************TB038A incoming**********************
  data: lt_tp038m1 type table of tp038m1,
        ls_tp038m1 type tp038m1.
*        lt_tb038a       type table of tb038a,
*        ls_tb038a          type tb038a.

*  data: ls_tb038a_d like line of gt_tb038a_main_out.

  if gt_tb038a_main_out is not initial.
    gr_alv_tb038a_out->check_changed_data( ).
    clear ls_tb038a_d.
    if indout = 'X'.
      loop at gt_tb038a_main_alv into ls_tb038a_out_d.
        if ls_tb038a_out_d-istype_check is not initial.
          if ls_tb038a_out_d-istype_check is not initial.
            ls_tp038m1-client = sy-mandt.
            ls_tp038m1-istype = ls_tb038a_out_d-istype.
            ls_tp038m1-ind_sector = ls_tb038a_out_d-ind_sector.
            ls_tp038m2-brsch = ls_tb038a_out_d-indkey.
            append ls_tp038m1 to lt_tp038m1.
          endif.
        endif.
      endloop.
    endif.
    if lt_tp038m1 is not initial.
      modify tp038m1 from table lt_tp038m1.
    endif.
  endif.

endform.                    "cust_save_post
