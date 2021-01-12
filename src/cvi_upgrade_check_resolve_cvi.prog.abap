*----------------------------------------------------------------------*
***INCLUDE CVI_UPGRADE_CHECK_RESOLVE_CVI .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SELECT_CVI
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM select_cvi .

  DATA: cl_chk_cvi          TYPE REF TO cl_s4_checks_bp_enh.
  DATA : lt_check_results  TYPE TABLE OF ty_preprocessing_check_result.
  refresh gt_cust.
  refresh gt_vend.
  refresh gt_cust_cont.
  refresh gt_vend_cont.

  CREATE OBJECT cl_chk_cvi.


  CALL METHOD cl_s4_checks_bp_enh=>check_cvi_mapping
  EXPORTING
     iv_cust_from = gv_cust_from
    iv_cust_to = gv_cust_to
    iv_vend_from = gv_vend_from
    iv_vend_to = gv_vend_to
    iv_no     = gv_no
  IMPORTING
    et_cust = gt_cust
    et_vend = gt_vend

    CHANGING
      ct_check_results = lt_check_results.

  CALL METHOD cl_s4_checks_bp_enh=>CHECK_CONTACT_PERSON_MAPPING
  EXPORTING
    iv_no = gv_no
  IMPORTING
    et_cust_cont = gt_cust_cont
    et_vend_cont = gt_vend_cont
    CHANGING
      ct_check_results = lt_check_results.

ENDFORM.                    " SELECT_CVI
*&---------------------------------------------------------------------*
*&      Form  CREATE_CVI
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CREATE_CVI .

refresh gt_fieldcat_cvi.
  gs_fcat-fieldname = 'KUNNR'.
  gs_fcat-tabname = 'KNA1'.
  gs_fcat-col_pos = 1.
*  gs_fcat-outputlen = 40.
   gs_fcat-coltext   = 'Customer'.
  gs_fcat-ROLLNAME = 'KUNNR'.
  gs_fcat-DATATYPE = 'KUNNR'.
  append gs_fcat to  gt_fieldcat_cvi.
  clear gs_fcat.

refresh gt_fieldcat_cont.
  gs_fcat-fieldname = 'KUNNR'.
  gs_fcat-tabname = 'KNA1'.
  gs_fcat-col_pos = 1.
*  gs_fcat-outputlen = 40.
  gs_fcat-coltext   = 'Customer'.
  gs_fcat-DATATYPE = 'KUNNR'.
  gs_fcat-ROLLNAME = 'KUNNR'.
  append gs_fcat to  gt_fieldcat_cont.
  clear gs_fcat.
*create container for Customer link
if gr_cvi_cc is initial.
  create object gr_cvi_cc
    exporting
      container_name = 'CVI_CUSTOM_CONTROL'.
endif.
*create ALV object for Customer link
if  gr_alv_cvi is initial.
  create object  gr_alv_cvi
    exporting
      i_parent = gr_cvi_cc.
endif.




*create container for Customer link
if gr_cvi_cc_cont is initial.
  create object gr_cvi_cc_cont
    exporting
      container_name = 'CVI_CUST_CONTACT'.
endif.
*create ALV object for Customer link
if  gr_alv_cvi_cont is initial.
  create object  gr_alv_cvi_cont
    exporting
      i_parent = gr_cvi_cc_cont.
endif.





refresh gt_fcat_vend_cont.
refresh gt_fcat_vend.


  gs_fcat-fieldname = 'LIFNR'.
  gs_fcat-tabname = 'LFA1'.
  gs_fcat-col_pos = 1.
*  gs_fcat-outputlen = 40.
  gs_fcat-coltext   = 'Supplier'.
  gs_fcat-ROLLNAME = 'LIFNR'.
  gs_fcat-DATATYPE = 'LIFNR'.
  append gs_fcat to  gt_fcat_vend.
  clear gs_fcat.

  gs_fcat-fieldname = 'LIFNR'.
  gs_fcat-tabname = 'LFA1'.
  gs_fcat-col_pos = 1.
*  gs_fcat-outputlen = 40.
  gs_fcat-coltext   = 'Supplier'.
  gs_fcat-ROLLNAME = 'LIFNR'.
  gs_fcat-DATATYPE = 'LIFNR'.
  append gs_fcat to  gt_fcat_vend_cont.
  clear gs_fcat.
*create container for Customer link
if gr_vend_cc is initial.
  create object gr_vend_cc
    exporting
      container_name = 'CVI_VEND_CONTROL'.
endif.
*create ALV object for Customer link
if  gr_alv_vend is initial.
  create object  gr_alv_vend
    exporting
      i_parent = gr_vend_cc.
endif.

*create container for Customer link
if gr_vend_cc_cont is initial.
  create object gr_vend_cc_cont
    exporting
      container_name = 'CVI_VEND_CONTACT'.
endif.
*create ALV object for Customer link
if  gr_alv_vend_cont is initial.
  create object  gr_alv_vend_cont
    exporting
      i_parent = gr_vend_cc_cont.
endif.


ENDFORM.                    " CREATE_CVI
*&---------------------------------------------------------------------*
*&      Form  SHOW_CVI
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SHOW_CVI .

  gs_layout_default-grid_title = text-037."Customers
  perform show_table_alv  using    gr_alv_cvi
                                   gs_layout_default
                          changing gt_cust
                                   gt_fieldcat_cvi.


  gs_layout_default-grid_title = text-038."Suppliers
  perform show_table_alv  using    gr_alv_vend
                                   gs_layout_default
                          changing gt_vend
                                   gt_fcat_vend.

  gs_layout_default-grid_title = text-037."Customers
  perform show_table_alv  using    gr_alv_cvi_cont
                                   gs_layout_default
                          changing gt_cust_cont
                                     gt_fieldcat_cont.

  gs_layout_default-grid_title = text-038."Suppliers
  perform show_table_alv  using    gr_alv_vend_cont
                                   gs_layout_default
                          changing gt_vend_cont
                                   gt_fcat_vend_cont.

ENDFORM.                    " SHOW_CVI
