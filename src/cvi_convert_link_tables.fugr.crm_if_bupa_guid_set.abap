FUNCTION crm_if_bupa_guid_set.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_GUID) TYPE  GUID_16
*"----------------------------------------------------------------------
**** Store GUID in global varibale.
  gv_crm_if_guid = im_guid.

ENDFUNCTION.
