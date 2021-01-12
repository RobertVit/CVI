*----------------------------------------------------------------------*
***INCLUDE LCVI_VIEW_MAINTF01 .
*----------------------------------------------------------------------*
form FORM_25.


  AUTHORITY-CHECK OBJECT 'CVI_CUST'
           ID 'CVI_ACTVT' FIELD gc_authority_change_data.

  if sy-subrc <> 0.
    vim_auth_rc = 4.
    vim_auth_msgid = 'SV'.
    vim_auth_msgno = '051'.
  endif.


endform.                                                    "FORM_25
