FUNCTION CVI_TAX_SET_VEND_CURR_OBJLIST.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     REFERENCE(I_STR_APPLPARAM) TYPE  CVIS_CONVERSION_PARAMS
*"     REFERENCE(I_STR_PACKAGE_KEY) TYPE  BANK_STR_PP_PACKAGEKEY
*"     REFERENCE(I_LIMIT_LOW) TYPE  BANK_DTE_PP_OBJNO
*"     REFERENCE(I_LIMIT_HIGH) TYPE  BANK_DTE_PP_OBJNO
*"     REFERENCE(I_XRESTART) TYPE  XFELD
*"     REFERENCE(I_FLG_ABORTED) TYPE  XFELD
*"----------------------------------------------------------------------

  cvi_sync_vend_tax_numbers=>set_vend_current_objlist(
    exporting
      i_str_param         = i_str_applparam
      i_str_package_key   = i_str_package_key
      i_limit_low         = i_limit_low
      i_limit_high        = i_limit_high
      i_xrestart          = i_xrestart
      i_flg_aborted       = i_flg_aborted
  ).

endfunction.
