FUNCTION CVI_ANALYSE_VEND_TAX_DATA.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  EXPORTING
*"     REFERENCE(E_TAB_STATUS_CHANGE) TYPE  BANK_TAB_PP_STATUS_CHANGE
*"----------------------------------------------------------------------

  data:
    lv_error   type boole_d,
    ls_message type bapiret2,
    ls_status  like line of e_tab_status_change[].

  lv_error = cvi_sync_vend_tax_numbers=>analyze_vend_tax_data( ).

  if lv_error = cvi_sync_vend_tax_numbers=>true.

    ls_message-type       = cvi_sync_vend_tax_numbers=>msg_error.
    ls_message-id         = cvi_sync_vend_tax_numbers=>messageclass.
    ls_message-number     = '004'.
    ls_message-message_v1 = cvi_sync_vend_tax_numbers=>current_package_key-packageno.
    cvi_sync_vend_tax_numbers=>log_message( ls_message ).

    ls_status-objcatg = 'PCKG'.
    ls_status-objno   = cvi_sync_vend_tax_numbers=>current_package_key-packageno. "package number
    ls_status-status  = '1'.  "package flagged for restart
    append ls_status to e_tab_status_change[].

  endif.

endfunction.
