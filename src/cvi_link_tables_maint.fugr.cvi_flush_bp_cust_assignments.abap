FUNCTION CVI_FLUSH_BP_CUST_ASSIGNMENTS.
*"----------------------------------------------------------------------
*"*"Verbuchungsfunktionsbaustein:
*"
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     VALUE(IT_ASSIGNMENTS_NEW) TYPE  CVIS_CUST_LINK_T
*"     VALUE(IT_CT_ASSIGNMENTS_NEW) TYPE  CVIS_CUST_CT_LINK_T
*"     VALUE(IT_CT_ASSIGNMENTS_DEL) TYPE  CVIS_CUST_CT_LINK_T
*"----------------------------------------------------------------------
  delete:
    cvi_cust_ct_link from table it_ct_assignments_del.
  insert:
    cvi_cust_link    from table it_assignments_new ACCEPTING DUPLICATE KEYS ,
    cvi_cust_ct_link from table it_ct_assignments_new ACCEPTING DUPLICATE KEYS .

ENDFUNCTION.
