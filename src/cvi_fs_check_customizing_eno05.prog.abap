*----------------------------------------------------------------------*
***INCLUDE CVI_FS_CHECK_CUSTOMIZING_ENO05.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module PBO_1100_CUST_MAP OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
module pbo_1100_cust_map output.
  set pf-status 'CVI_FS_C_C_PREV_NEXT'.
*  set titlebar 'CVI_FS_C_C_CUSTOMER'.

  perform select_data_customer_post.
  perform create_alv_customer_post.
  perform set_data_customer_post.
  perform show_data_customer_post.
endmodule.
