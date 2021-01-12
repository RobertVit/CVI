*----------------------------------------------------------------------*
***INCLUDE CVI_FS_CHECK_CUSTOMIZING_ENF18.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form SAVE_GEN_PRE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form save_gen_pre .

 data: lt_tfktaxnumtype type table of tfktaxnumtype,
        ls_tfktaxnumtype TYPE tfktaxnumtype,
        lt_tax_type_text TYPE TABLE OF tfktaxnumtype_t,
        ls_tax_type_text TYPE  tfktaxnumtype_t.


 data: ls_outtab_tax like line of gt_outtab_tax.

 if gr_alv_tax is not initial.
    gr_alv_tax->check_changed_data( ).
  endif.
  clear ls_outtab_tax.

  loop at gt_outtab_tax into ls_outtab_tax.
    if ls_outtab_tax-taxtype is not initial and ls_outtab_tax-checkfct is not initial and ls_outtab_tax-stcdt is not initial.
      CLEAR: ls_tfktaxnumtype, ls_tax_type_text.
      ls_tfktaxnumtype-client = ls_tax_type_text-client = sy-mandt.
      ls_tfktaxnumtype-taxtype = ls_tax_type_text-taxtype = ls_outtab_tax-taxtype.
      ls_tfktaxnumtype-checkfct = ls_outtab_tax-checkfct.
      ls_tfktaxnumtype-stcdt = ls_outtab_tax-stcdt.
      ls_tax_type_text-text = ls_outtab_tax-bptaxtypetxt.
      ls_tax_type_text-spras = sy-langu.
      APPEND  ls_tfktaxnumtype TO lt_tfktaxnumtype.
      MODIFY tfktaxnumtype FROM TABLE lt_tfktaxnumtype.
      IF sy-subrc = 0.
        APPEND ls_tax_type_text TO lt_tax_type_text.
        MODIFY tfktaxnumtype_t FROM TABLE lt_tax_type_text.
      ENDIF.
     endif.
   endloop.
endform.
