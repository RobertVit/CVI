FUNCTION CVI_FLUSH_BP_VEND_ASSIGNMENTS.
*"----------------------------------------------------------------------
*"*"Update Function Module:
*"
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IT_ASSIGNMENTS_NEW) TYPE  CVIS_VEND_LINK_T
*"     VALUE(IT_CT_ASSIGNMENTS_NEW) TYPE  CVIS_VEND_CT_LINK_T
*"     VALUE(IT_CT_ASSIGNMENTS_DEL) TYPE  CVIS_VEND_CT_LINK_T
*"----------------------------------------------------------------------
  delete:
    cvi_vend_ct_link from table it_ct_assignments_del.
  insert:
    cvi_vend_link from table it_assignments_new ACCEPTING DUPLICATE KEYS,
    cvi_vend_ct_link from table it_ct_assignments_new ACCEPTING DUPLICATE KEYS.

ENDFUNCTION.
