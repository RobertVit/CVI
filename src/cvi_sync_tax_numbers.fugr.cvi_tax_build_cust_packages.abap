function cvi_tax_build_cust_packages.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     REFERENCE(I_STR_PARAM) TYPE  CVIS_CONVERSION_PARAMS
*"     REFERENCE(I_STR_PACKAGE_KEY) TYPE  BANK_STR_PP_PACKAGEKEY
*"  EXPORTING
*"     REFERENCE(E_LIMIT_HIGH) TYPE  BANK_DTE_PP_OBJNO
*"     REFERENCE(E_LIMIT_LOW) TYPE  BANK_DTE_PP_OBJNO
*"     REFERENCE(E_FLG_NO_PACKAGE) TYPE  XFELD
*"----------------------------------------------------------------------

  cvi_sync_cust_tax_numbers=>build_cust_packages(
    exporting  i_str_param       = i_str_param
               i_str_package_key = i_str_package_key
    importing  e_limit_high      = e_limit_high
               e_limit_low       = e_limit_low
               e_flg_no_package  = e_flg_no_package
  ).

endfunction.
