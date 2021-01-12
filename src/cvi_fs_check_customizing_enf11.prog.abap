*----------------------------------------------------------------------*
***INCLUDE CVI_FS_CHECK_CUSTOMIZING_ENF11.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form CREATE_ALV_CUSTOMER_POST
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form create_alv_customer_post .

*******************************************TB910 START*********************


  gs_fcat_map-fieldname = 'abtnr'.
  gs_fcat_map-coltext   = 'Department'.
  gs_fcat_map-col_pos = 1.
  gs_fcat_map-outputlen = 6.
  gs_fcat_map-dd_outlen = 6.
*  gs_fcat_map-col_opt = 'X'.
  append gs_fcat_map to gt_fieldcat_tb910.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'desc'.
  gs_fcat_map-coltext   = 'Description'.
  gs_fcat_map-col_pos = 2.
  gs_fcat_map-outputlen = 26.
  gs_fcat_map-edit = ' '.
  append gs_fcat_map to gt_fieldcat_tb910.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'abtnr_check'.
  gs_fcat_map-coltext   = 'Select department'.
  gs_fcat_map-col_pos = 3.
  gs_fcat_map-outputlen = 4.
  gs_fcat_map-checkbox = 'X'.
  gs_fcat_map-edit = 'X'.
  append gs_fcat_map to gt_fieldcat_tb910.
  clear gs_fcat_map.

*  gs_fcat_map-fieldname = 'CVI_DEPT_TEXT'.
*  gs_fcat_map-coltext   = 'Department(CVI)'.
*  gs_fcat_map-col_pos = 4.
*  gs_fcat_map-outputlen = 20.
*  gs_fcat_map-dd_outlen = 20.
*  gs_fcat_map-drdn_field = 'DROPDOWN_CVI_DEPT'.
*  gs_fcat_map-edit = 'X'.
*  append gs_fcat_map to gt_fieldcat_tb910.
*  clear gs_fcat_map.

if gr_cont_tb910 is INITIAL.
  create object gr_cont_tb910
    exporting
      container_name = 'CP_TB910'.
endif.
*******************************************TB910 END*********************

*******************************************TB912 START*********************

clear gs_fcat_map.
  gs_fcat_map-fieldname = 'pafkt'.
  gs_fcat_map-coltext   = 'Function of partner'.
  gs_fcat_map-col_pos = 1.
  gs_fcat_map-outputlen = 6.
  gs_fcat_map-dd_outlen = 6.
*  gs_fcat_map-col_opt = 'X'.
  append gs_fcat_map to gt_fieldcat_tb912.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'desc'.
  gs_fcat_map-coltext   = 'Description'.
  gs_fcat_map-col_pos = 2.
  gs_fcat_map-outputlen = 26.
  gs_fcat_map-edit = ' '.
  append gs_fcat_map to gt_fieldcat_tb912.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'pafkt_check'.
  gs_fcat_map-coltext   = 'Select Function of partner'.
  gs_fcat_map-col_pos = 3.
  gs_fcat_map-outputlen = 4.
  gs_fcat_map-checkbox = 'X'.
  gs_fcat_map-edit = 'X'.
  append gs_fcat_map to gt_fieldcat_tb912.
  clear gs_fcat_map.

*  gs_fcat_map-fieldname = 'CVI_FN_TEXT'.
*  gs_fcat_map-coltext   = 'Function(CVI)'.
*  gs_fcat_map-col_pos = 4.
*  gs_fcat_map-outputlen = 22.
*  gs_fcat_map-dd_outlen = 22.
*  gs_fcat_map-drdn_field = 'DROPDOWN_CVI_FN'.
*  gs_fcat_map-edit = 'X'.
*  append gs_fcat_map to gt_fieldcat_tb912.
*  clear gs_fcat_map.

if gr_cont_tb912 is INITIAL.
  create object gr_cont_tb912
    exporting
      container_name = 'CP_TB912'.
endif.
*******************************************TB912 END*********************


*******************************************TB914 START*********************
*if gr_cont_tb914 is NOT INITIAL.
*  gr_cont_tb914->free( ).
*  clear  gr_cont_tb914.
*endif.
clear gs_fcat_map.
  gs_fcat_map-fieldname = 'bu_paauth'.
  gs_fcat_map-coltext   = 'Pwr of Att.(BP)'.
  gs_fcat_map-col_pos = 1.
  gs_fcat_map-outputlen = 6.
  gs_fcat_map-dd_outlen = 6.
*  gs_fcat_map-col_opt = 'X'.
  append gs_fcat_map to gt_fieldcat_tb914.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'desc'.
  gs_fcat_map-coltext   = 'Description'.
  gs_fcat_map-col_pos = 2.
  gs_fcat_map-outputlen = 26.
  gs_fcat_map-edit = ' '.
  append gs_fcat_map to gt_fieldcat_tb914.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'bu_paauth_check'.
  gs_fcat_map-coltext   = 'Select Partner Authority'.
  gs_fcat_map-col_pos = 3.
  gs_fcat_map-outputlen = 6.
  gs_fcat_map-checkbox = 'X'.
  gs_fcat_map-edit = 'X'.
  append gs_fcat_map to gt_fieldcat_tb914.
  clear gs_fcat_map.

*  gs_fcat_map-fieldname = 'CVI_POA_AUTH'.
*  gs_fcat_map-coltext   = 'Authority'.
*  gs_fcat_map-col_pos = 4.
*  gs_fcat_map-outputlen = 13.
*  gs_fcat_map-dd_outlen = 13.
*  gs_fcat_map-drdn_field = 'DROPDOWN_CVI_AUTH'.
*  gs_fcat_map-edit = 'X'.
*  append gs_fcat_map to gt_fieldcat_tb914.
*  clear gs_fcat_map.

if gr_cont_tb914 is INITIAL.
  create object gr_cont_tb914
    exporting
      container_name = 'CP_TB914'.
ENDIF.
*  create object gr_alv_tb914
*    exporting
*      i_parent = gr_cont_tb914.


*******************************************TB914 END*********************


*******************************************TB916 START*********************
*if gr_cont_tb916 is NOT INITIAL.
*  gr_cont_tb916->free( ).
*  clear  gr_cont_tb916.
*endif.
clear gs_fcat_map.
  gs_fcat_map-fieldname = 'pavip'.
  gs_fcat_map-coltext   = 'VIP Partner'.
  gs_fcat_map-col_pos = 1.
  gs_fcat_map-outputlen = 6.
  gs_fcat_map-dd_outlen = 6.
*  gs_fcat_map-col_opt = 'X'.
  append gs_fcat_map to gt_fieldcat_tb916.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'desc'.
  gs_fcat_map-coltext   = 'Description'.
  gs_fcat_map-col_pos = 2.
  gs_fcat_map-outputlen = 26.
  gs_fcat_map-edit = ' '.
  append gs_fcat_map to gt_fieldcat_tb916.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'pavip_check'.
  gs_fcat_map-coltext   = 'Select VIP Partner'.
  gs_fcat_map-col_pos = 3.
  gs_fcat_map-outputlen = 6.
  gs_fcat_map-checkbox = 'X'.
  gs_fcat_map-edit = 'X'.
  append gs_fcat_map to gt_fieldcat_tb916.
  clear gs_fcat_map.

*  gs_fcat_map-fieldname = 'CVI_VIP_TEXT'.
*  gs_fcat_map-coltext   = 'VIP Indicator(CVI)'.
*  gs_fcat_map-col_pos = 4.
*  gs_fcat_map-outputlen = 15.
*  gs_fcat_map-dd_outlen = 15.
*  gs_fcat_map-drdn_field = 'DROPDOWN_CVI_VIP'.
*  gs_fcat_map-edit = 'X'.
*  append gs_fcat_map to gt_fieldcat_tb916.
*  clear gs_fcat_map.

 if gr_cont_tb916 is INITIAL.
  create object gr_cont_tb916
    exporting
      container_name = 'CP_TB916'.
ENDIF.



*******************************************TB916 END*********************

*******************************************TB027 START*********************

clear gs_fcat_map.
  gs_fcat_map-fieldname = 'bu_marst'.
  gs_fcat_map-coltext   = 'Marital Status of Business Partner'.
  gs_fcat_map-col_pos = 1.
  gs_fcat_map-outputlen = 2.
  gs_fcat_map-dd_outlen = 6.
*  gs_fcat_map-col_opt = 'X'.
  append gs_fcat_map to gt_fieldcat_tb027.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'desc'.
  gs_fcat_map-coltext   = 'Description'.
  gs_fcat_map-col_pos = 2.
  gs_fcat_map-outputlen = 26.
  gs_fcat_map-edit = ' '.
  append gs_fcat_map to gt_fieldcat_tb027.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'bu_marst_check'.
  gs_fcat_map-coltext   = 'Select Marital Status of Business Partner'.
  gs_fcat_map-col_pos = 3.
  gs_fcat_map-outputlen = 2.
  gs_fcat_map-checkbox = 'X'.
  gs_fcat_map-edit = 'X'.
  append gs_fcat_map to gt_fieldcat_tb027.
  clear gs_fcat_map.

*  gs_fcat_map-fieldname = 'CVI_FAMST_TEXT'.
*  gs_fcat_map-coltext   = 'Marital Status(CVI)'.
*  gs_fcat_map-col_pos = 4.
*  gs_fcat_map-outputlen = 15.
*  gs_fcat_map-dd_outlen = 15.
*  gs_fcat_map-drdn_field = 'DROPDOWN_CVI_FAMST'.
*  gs_fcat_map-edit = 'X'.
*  append gs_fcat_map to gt_fieldcat_tb027.
*  clear gs_fcat_map.

if gr_cont_tb027 is INITIAL.
  create object gr_cont_tb027
    exporting
      container_name = 'CP_TB027'.
ENDIF.

*******************************************TB027 END*********************


*******************************************TB019 START*********************

clear gs_fcat_map.
  gs_fcat_map-fieldname = 'bu_legenty'.
  gs_fcat_map-coltext   = 'BP: Legal form of organization'.
  gs_fcat_map-col_pos = 1.
  gs_fcat_map-outputlen = 6.
  gs_fcat_map-dd_outlen = 6.
*  gs_fcat_map-col_opt = 'X'.
  append gs_fcat_map to gt_fieldcat_tb019.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'desc'.
  gs_fcat_map-coltext   = 'Description'.
  gs_fcat_map-col_pos = 2.
  gs_fcat_map-outputlen = 26.
  gs_fcat_map-edit = ' '.
  append gs_fcat_map to gt_fieldcat_tb019.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'bu_legenty_check'.
  gs_fcat_map-coltext   = 'Select BP: Legal form of organization'.
  gs_fcat_map-col_pos = 3.
  gs_fcat_map-outputlen = 6.
  gs_fcat_map-checkbox = 'X'.
  gs_fcat_map-edit = 'X'.
  append gs_fcat_map to gt_fieldcat_tb019.
  clear gs_fcat_map.

*  gs_fcat_map-fieldname = 'LEGAL_STAT_CVI'.
*  gs_fcat_map-coltext   = 'Legal Status'.
*  gs_fcat_map-col_pos = 4.
*  gs_fcat_map-outputlen = 12.
*  gs_fcat_map-dd_outlen = 12.
*  gs_fcat_map-drdn_field = 'DROPDOWN_CVI_STAT'.
*  gs_fcat_map-edit = 'X'.
*  append gs_fcat_map to gt_fieldcat_tb019.
*  clear gs_fcat_map.

if gr_cont_tb019 is INITIAL.
  create object gr_cont_tb019
    exporting
      container_name = 'CP_TB019'.
ENDIF.
*  create object gr_alv_tb019
*    exporting
*      i_parent = gr_cont_tb019.


*******************************************TB019 END*********************




*******************************************TB033 START*********************
*if gr_cont_tb033 is NOT INITIAL.
*  gr_cont_tb033->free( ).
*  clear  gr_cont_tb033.
*endif.
clear gs_fcat_map.
  gs_fcat_map-fieldname = 'ccins'.
  gs_fcat_map-coltext   = 'Payment card type'.
  gs_fcat_map-col_pos = 1.
  gs_fcat_map-outputlen = 6.
  gs_fcat_map-dd_outlen = 6.
*  gs_fcat_map-col_opt = 'X'.
  append gs_fcat_map to gt_fieldcat_tb033.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'desc'.
  gs_fcat_map-coltext   = 'Description'.
  gs_fcat_map-col_pos = 2.
  gs_fcat_map-outputlen = 26.
  gs_fcat_map-edit = ' '.
  append gs_fcat_map to gt_fieldcat_tb033.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'ccins_check'.
  gs_fcat_map-coltext   = 'Select Payment card type'.
  gs_fcat_map-col_pos = 3.
  gs_fcat_map-outputlen = 6.
  gs_fcat_map-checkbox = 'X'.
  gs_fcat_map-edit = 'X'.
  append gs_fcat_map to gt_fieldcat_tb033.
  clear gs_fcat_map.

*  gs_fcat_map-fieldname = 'CVI_PCARD_TEXT'.
*  gs_fcat_map-coltext   = 'Card Type(CVI)'.
*  gs_fcat_map-col_pos = 4.
*  gs_fcat_map-outputlen = 15.
*  gs_fcat_map-dd_outlen = 15.
*  gs_fcat_map-drdn_field = 'DROPDOWN_CVI_PCARD'.
*  gs_fcat_map-edit = 'X'.
*    append gs_fcat_map to gt_fieldcat_tb033.
*  clear gs_fcat_map.

if gr_cont_tb033 is INITIAL.
  create object gr_cont_tb033
    exporting
      container_name = 'CP_TB033'.
ENDIF.
*  create object gr_alv_tb033
*    exporting
*      i_parent = gr_cont_tb033.


*******************************************TB033 END*********************


********************************************TB038a START*********************
*if gr_cont_tb038a is NOT INITIAL.
*  gr_cont_tb038a->free( ).
*  clear  gr_cont_tb038a.
*endif.
*clear gs_fcat_map.
*  gs_fcat_map-fieldname = 'istype'.
*  gs_fcat_map-coltext   = 'Industry System'.
*  gs_fcat_map-col_pos = 1.
*  gs_fcat_map-outputlen = 6.
*  gs_fcat_map-dd_outlen = 6.
**  gs_fcat_map-col_opt = 'X'.
*  append gs_fcat_map to gt_fieldcat_tb038a.
*  clear gs_fcat_map.
*
*  gs_fcat_map-fieldname = 'desc'.
*  gs_fcat_map-coltext   = 'Description'.
*  gs_fcat_map-col_pos = 2.
*  gs_fcat_map-outputlen = 26.
*  gs_fcat_map-edit = ' '.
*  append gs_fcat_map to gt_fieldcat_tb038a.
*  clear gs_fcat_map.
*
*  gs_fcat_map-fieldname = 'istype_check'.
*  gs_fcat_map-coltext   = 'Industry System'.
*  gs_fcat_map-col_pos = 3.
*  gs_fcat_map-outputlen = 6.
*  gs_fcat_map-checkbox = 'X'.
*  gs_fcat_map-edit = 'X'.
*  append gs_fcat_map to gt_fieldcat_tb038a.
*  clear gs_fcat_map.
*
*  create object gr_cont_tb038a
*    exporting
*      container_name = 'CP_TB038A'.
*
**  create object gr_alv_tb038a
**    exporting
**      i_parent = gr_cont_tb038a.
*
*
********************************************TB038a END*********************



***************ERROR START******************************************
clear gs_fcat_map.
  gs_fcat_map-fieldname = 'ICON'.
  gs_fcat_map-coltext   = 'Ty.'.
  gs_fcat_map-col_pos = 1.
  gs_fcat_map-outputlen = 3.
  gs_fcat_map-icon = 'X'.
  append gs_fcat_map to gt_fieldcat_post_log1100.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'CHK'.
  gs_fcat_map-coltext   = 'Check ID'.
  gs_fcat_map-col_pos = 2.
  gs_fcat_map-outputlen = 30.
  append gs_fcat_map to gt_fieldcat_post_log1100.
  clear gs_fcat_map.

  gs_fcat_map-fieldname = 'LOG'.
  gs_fcat_map-coltext   = 'Error Log'.
  gs_fcat_map-col_pos = 2.
  gs_fcat_map-outputlen = 85.
*  gs_fcat_map-hotspot = 'X'.
  append gs_fcat_map to gt_fieldcat_post_log1100.
  clear gs_fcat_map.

if gr_cont_post_log1100 is INITIAL.
  create object gr_cont_post_log1100
    exporting
      container_name = 'CUST_ERROR_1100'.

  ENDIF.
* create ALV object for log table
  if gr_alv_post_log1100 is INITIAL.
  create object gr_alv_post_log1100
    exporting
      i_parent = gr_cont_post_log1100.
  endif.
*
*****************ERROR END***********************

endform.
*&---------------------------------------------------------------------*
*& Module STYLING_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
module styling_0100 output.
* SET PF-STATUS 'xxxxxxxx'.
* SET TITLEBAR 'xxx'.


endmodule.
