*----------------------------------------------------------------------*
***INCLUDE CVI_UPGRADE_CHECK_RESOLVE_NR03 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SHOW_NEW_NUMBER_RANGES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SHOW_NEW_NUMBER_RANGES .

  DATA: ls_all_new_nriv like line of gt_all_new_nriv,
        lt_bp_ranges TYPE TABLE OF NRIV,
        lv_new_range TYPE NRIV-NRRANGENR.

  FIELD-SYMBOLS: <fs_new_edit_nriv> LIKE LINE OF gt_new_edit_nriv.

  CLEAR ls_all_new_nriv.

  lv_new_range = 'AA'.

  IF gv_common NE 'X'.

    APPEND LINES OF gt_source_nriv TO gt_all_new_nriv.
    CALL METHOD CL_S4_CHECKS_BP_ENH=>DETERMINE_NEW_NRIV
      EXPORTING
        IV_ACT_IND             = ' '
*        IV_ALPHA_IND           =
        IT_OVERLAPPING_NRIV    = gt_overlap_nriv
        IT_NO_OVERLAPPING_NRIV = gt_non_overlap_nriv
      CHANGING
        CV_NR_FACTOR           = gv_factor
        CT_NEW_NRIV            = gt_all_new_nriv
      EXCEPTIONS
        INVALID_NUMBER         = 1
        EXCEEDS_NUMBER         = 2
        others                 = 4
            .
    IF SY-SUBRC <> 0.
*     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*                WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

    IF NOT gt_src_alpha_nriv IS INITIAL.

      DATA: lv_index TYPE sy-tabix,
            ls_nriv LIKE LINE OF gt_new_num_alpha_nriv,
            ls_nriv2 LIKE LINE OF gt_src_alpha_nriv.
*      APPEND gt_src_alpha_nriv TO
      LOOP AT gt_new_num_alpha_nriv INTO ls_nriv.
        lv_index = sy-tabix.
        READ TABLE gt_src_alpha_nriv INTO ls_nriv2 WITH KEY  object  = ls_nriv-object.
        IF sy-subrc NE 0.
          DELETE gt_new_num_alpha_nriv INDEX lv_index.
        ELSE.
          ls_nriv-src_fromnr  = ls_nriv2-fromnumber.
          ls_nriv-src_tonr  = ls_nriv2-tonumber.
        ENDIF.
      ENDLOOP.
      CL_S4_CHECKS_BP_ENH=>determine_new_nriv(
             EXPORTING
               iv_act_ind                = ' '
               iv_alpha_ind              = abap_true
               it_overlapping_nriv    = gt_alpha_ov_nriv_res
              it_no_overlapping_nriv = gt_alpha_nriv_no_res
             CHANGING
               cv_nr_factor               = gv_factor
               ct_new_nriv            = gt_new_num_alpha_nriv

      EXCEPTIONS
         invalid_number          = 1
       exceeds_number          = 2
       OTHERS                     = 3    ).

      IF  sy-subrc =  0.
        CL_S4_CHECKS_BP_ENH=>convert_num_toalpha_nriv(
           EXPORTING
             it_number_nriv = gt_new_num_alpha_nriv
           IMPORTING
             et_alpha_nriv  = gt_new_alpha_nriv
           EXCEPTIONS
             interval_not_found = 1
             OTHERS             = 2 ) .

      ENDIF.

      APPEND LINES OF gt_new_alpha_nriv to gt_all_new_nriv.

    ENDIF.

    SELECT * FROM NRIV INTO TABLE lt_bp_ranges WHERE OBJECT = 'BU_PARTNER'.

    loop at gt_all_new_nriv into ls_all_new_nriv.
      if ls_all_new_nriv-nr_new eq 'X'.
        ls_all_new_nriv-depd_nr = ls_all_new_nriv-nrrangenr.
        do.
          read table lt_bp_ranges WITH KEY nrrangenr = lv_new_range TRANSPORTING NO FIELDS.
          if sy-subrc NE 0.
            ls_all_new_nriv-nrrangenr = lv_new_range.
            if lv_new_range+1(1) EQ 'Z'.
              lv_new_range+1(1) = 'A'.
              perform counter_change changing lv_new_range+0(1).
            else.
              perform counter_change changing lv_new_range+1(1).
            endif.
            exit.
          else.
            if lv_new_range+1(1) EQ 'Z'.
              lv_new_range+1(1) = 'A'.
              perform counter_change changing lv_new_range+0(1).
            else.
              perform counter_change changing lv_new_range+1(1).
            endif.
          endif.
        enddo.
        ls_all_new_nriv-depd_object = ls_all_new_nriv-object.
        ls_all_new_nriv-object = 'BU_PARTNER'.
        READ TABLE gt_all_overlaps WITH KEY DEPD_NR = ls_all_new_nriv-depd_nr TRANSPORTING NO FIELDS.
        IF sy-subrc EQ 0.
          append ls_all_new_nriv to gt_new_nriv.
        ENDIF.
      endif.
    endloop.

  ELSE.

    DATA: lv_char          TYPE char20,
          lv_fromnumber    TYPE numc10,
          lv_tonumber      TYPE numc10,
          ls_wa            TYPE ts_nriv_res,
          lt_new_requ_nriv TYPE nriv_tt,
          lt_new_nriv      TYPE nriv_tt,
          ls_new_nriv      LIKE LINE OF lt_new_nriv.

    ls_wa-fromnumber = gv_start.
    ls_wa-nrlevel =     gv_end.
    ls_wa-tonumber =      gv_end.
    ls_wa-object =  'tmp'.
    ls_wa-nrrangenr = lv_new_range.

    IF  NOT gv_start  CA sy-abcde.

*      ls_wa-tonumber =    lv_tonumber.
      APPEND ls_wa TO lt_new_requ_nriv.
      CL_S4_CHECKS_BP_ENH=>compare_detm_new_cmn_nriv(
           EXPORTING
             iv_bp_ind = 'X'
             it_new_requ_nriv = lt_new_requ_nriv
           IMPORTING
             et_new_cmn_nriv  = lt_new_nriv
           EXCEPTIONS
             invalid_nr       = 1
             OTHERS           = 2 ).
      IF sy-subrc <> 0.
*     Implement suitable error handling here
      ENDIF.
      LOOP AT lt_new_nriv INTO ls_new_nriv.
        ls_all_new_nriv-object = ls_new_nriv-object.
        ls_all_new_nriv-nrrangenr = ls_new_nriv-nrrangenr.
        ls_all_new_nriv-fromnumber = ls_new_nriv-fromnumber.
        ls_all_new_nriv-tonumber = ls_new_nriv-tonumber.
      ENDLOOP.

    ELSE.


      APPEND ls_wa TO lt_new_requ_nriv.
      CL_S4_CHECKS_BP_ENH=>comp_detm_alpha_new_cmn_nriv(
        EXPORTING
          iv_bp_ind = 'X'
          it_new_requ_nriv = lt_new_requ_nriv
        IMPORTING
          et_new_cmn_nriv  = lt_new_nriv
        EXCEPTIONS
          invalid_nr       = 1
          OTHERS           = 2 ).
      IF sy-subrc <> 0.
*     Implement suitable error handling here
      ENDIF.

      DATA: lt_new_num_nriv   TYPE tt_nriv_res,
            lt_new_alpha_nriv TYPE tt_nriv_res,
            ls_new_alpha_nriv LIKE LINE OF lt_new_alpha_nriv.

      CLEAR ls_wa.

      LOOP AT lt_new_nriv INTO  ls_wa.
        CLEAR ls_wa-depd_nrlevel.
        APPEND ls_wa TO  lt_new_num_nriv.
      ENDLOOP.

      CL_S4_CHECKS_BP_ENH=>convert_num_toalpha_nriv(
        EXPORTING
          it_number_nriv = lt_new_num_nriv
        IMPORTING
          et_alpha_nriv  = lt_new_alpha_nriv
        EXCEPTIONS
          interval_not_found = 1
          OTHERS             = 2 ) .
      IF sy-subrc = 1.
*   Implement suitable error handling here
      ENDIF.
      LOOP AT lt_new_alpha_nriv INTO ls_new_alpha_nriv.
        ls_all_new_nriv-object = ls_new_alpha_nriv-object.
        ls_all_new_nriv-nrrangenr = ls_new_alpha_nriv-nrrangenr.
        ls_all_new_nriv-fromnumber = ls_new_alpha_nriv-fromnumber.
        ls_all_new_nriv-tonumber = ls_new_alpha_nriv-tonumber.
      ENDLOOP.

    ENDIF.

    SELECT * FROM NRIV INTO TABLE lt_bp_ranges WHERE OBJECT = 'BU_PARTNER' OR OBJECT = 'DEBITOR' OR OBJECT = 'KREDITOR'.
    SORT lt_bp_ranges BY nrrangenr.
    DELETE ADJACENT DUPLICATES FROM lt_bp_ranges COMPARING nrrangenr.

     if ls_all_new_nriv-object EQ 'tmp'.
       do.
         read table lt_bp_ranges WITH KEY nrrangenr = lv_new_range TRANSPORTING NO FIELDS.
         if sy-subrc NE 0.
           ls_all_new_nriv-nrrangenr = lv_new_range.
           exit.
         else.
           if lv_new_range+1(1) EQ 'Z'.
             lv_new_range+1(1) = 'A'.
             perform counter_change changing lv_new_range+0(1).
           else.
             perform counter_change changing lv_new_range+1(1).
           endif.
         endif.
       enddo.
       ls_all_new_nriv-object = 'BU_PARTNER'.
       append ls_all_new_nriv to gt_new_nriv.
       ls_all_new_nriv-object = 'DEBITOR'.
       append ls_all_new_nriv to gt_new_nriv.
       ls_all_new_nriv-object = 'KREDITOR'.
       append ls_all_new_nriv to gt_new_nriv.
     endif.

  ENDIF.

  APPEND LINES OF gt_new_nriv TO gt_new_edit_nriv.
  LOOP AT gt_new_edit_nriv ASSIGNING <fs_new_edit_nriv>.
    <fs_new_edit_nriv>-select = 'X'.
  ENDLOOP.

  refresh gt_new_nriv_fcat.

  gs_fcat-fieldname = 'OBJECT'.
  gs_fcat-tabname = 'NRIV'.
  gs_fcat-col_pos = 1.
  gs_fcat-outputlen = 20.
  gs_fcat-coltext   = 'Number Range Object'.
  gs_fcat-ROLLNAME = 'OBJECT'.
  gs_fcat-DATATYPE = 'NROBJ'.
  append gs_fcat to  gt_new_nriv_fcat.
  clear gs_fcat.

  gs_fcat-fieldname = 'NRRANGENR'.
  gs_fcat-tabname = 'NRIV'.
  gs_fcat-col_pos = 2.
  gs_fcat-outputlen = 20.
  gs_fcat-edit = 'X'.
  gs_fcat-coltext   = 'Number Range Number'.
  gs_fcat-ROLLNAME = 'NRRANGENR'.
  gs_fcat-DATATYPE = 'NRNR'.
  append gs_fcat to  gt_new_nriv_fcat.
  clear gs_fcat.

  gs_fcat-fieldname = 'FROMNUMBER'.
  gs_fcat-tabname = 'NRIV'.
  gs_fcat-col_pos = 3.
  gs_fcat-outputlen = 40.
  gs_fcat-coltext   = 'From Number'.
  gs_fcat-ROLLNAME = 'FROMNUMBER'.
  gs_fcat-DATATYPE = 'NRFROM'.
  append gs_fcat to  gt_new_nriv_fcat.
  clear gs_fcat.

  gs_fcat-fieldname = 'TONUMBER'.
  gs_fcat-tabname = 'NRIV'.
  gs_fcat-col_pos = 4.
  gs_fcat-outputlen = 40.
  gs_fcat-coltext   = 'To Number'.
  gs_fcat-ROLLNAME = 'TONUMBER'.
  gs_fcat-DATATYPE = 'NRTO'.
  append gs_fcat to  gt_new_nriv_fcat.
  clear gs_fcat.

  gs_fcat-fieldname = 'DEPD_OBJECT'.
  gs_fcat-tabname = 'NRIV'.
  gs_fcat-col_pos = 5.
  gs_fcat-outputlen = 20.
  gs_fcat-coltext   = 'Overlapping Object'.
  gs_fcat-ROLLNAME = 'OBJECT'.
  gs_fcat-DATATYPE = 'NROBJ'.
  append gs_fcat to  gt_new_nriv_fcat.
  clear gs_fcat.

  gs_fcat-fieldname = 'DEPD_NR'.
  gs_fcat-tabname = 'NRIV'.
  gs_fcat-col_pos = 6.
  gs_fcat-outputlen = 20.
  gs_fcat-coltext   = 'Overlapping Range Number'.
  gs_fcat-ROLLNAME = 'NRRANGENR'.
  gs_fcat-DATATYPE = 'NRNR'.
  append gs_fcat to  gt_new_nriv_fcat.
  clear gs_fcat.

  gs_fcat-fieldname = 'SELECT'.
  gs_fcat-tabname = 'NRIV'.
  gs_fcat-checkbox = 'X'.
  gs_fcat-edit = 'X'.
  gs_fcat-col_pos = 7.
  gs_fcat-outputlen = 20.
  gs_fcat-coltext   = 'Select'.
  gs_fcat-ROLLNAME = 'CHECK'.
  gs_fcat-DATATYPE = 'BOOLEAN'.
  append gs_fcat to  gt_new_nriv_fcat.
  clear gs_fcat.

**  gs_fcat-fieldname = 'NR_NEW'.
***  gs_fcat-tabname = 'NRIV'.
**  gs_fcat-col_pos = 5.
**  gs_fcat-outputlen = 20.
**  gs_fcat-coltext   = 'New'.
**  gs_fcat-ROLLNAME = 'NR_NEW'.
***  gs_fcat-DATATYPE = 'NRTO'.
**  append gs_fcat to  gt_new_nriv_fcat.
**  clear gs_fcat.



* create container for existing number ranges
  if gr_new_nriv_cc is initial.
    create object gr_new_nriv_cc
      exporting
        container_name = 'CC_NEW_NR'.
  endif.

*create ALV object for existing number ranges
  if  gr_new_nriv_alv is initial.
    create object  gr_new_nriv_alv
      exporting
        i_parent = gr_new_nriv_cc.
  endif.

  gs_layout_default-grid_title = 'Proposed New Number Ranges'.

  perform show_table_alv  using    gr_new_nriv_alv
                                   gs_layout_default
                          changing gt_new_edit_nriv
                                   gt_new_nriv_fcat.

ENDFORM.                    " SHOW_NEW_NUMBER_RANGES

FORM counter_change CHANGING p_counter.

  DATA: l_seq(26) type c Value 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
        l_pointer type i.

  search l_seq for p_counter.
  l_pointer = sy-fdpos + 1.
  p_counter = l_seq+l_pointer(1).

ENDFORM.
