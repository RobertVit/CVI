function cvi_init_cust_link_packages .
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     REFERENCE(I_LIMIT_HIGH) TYPE  BANK_DTE_PP_OBJNO
*"     REFERENCE(I_LIMIT_LOW) TYPE  BANK_DTE_PP_OBJNO
*"     REFERENCE(I_STR_PACKAGE_KEY) TYPE  BANK_STR_PP_PACKAGEKEY
*"----------------------------------------------------------------------

  cvi_convert_link_tables=>initialize_cust_link_package(
    exporting
      i_str_package_key = i_str_package_key
      i_limit_high      = i_limit_high
      i_limit_low       = i_limit_low
  ).

endfunction.
