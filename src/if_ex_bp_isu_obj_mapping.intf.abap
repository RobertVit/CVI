interface IF_EX_BP_ISU_OBJ_MAPPING
  public .


  interfaces IF_BADI_INTERFACE .

  methods MAP_CUST_TO_PARTNER
    importing
      !IT_EOP_CHECK_PARTNERS type CVP_TT_EOP_CHECK_PARTNERS
    exporting
      !LT_PARTNER type BUPA_CUST_TT .
  methods MAP_PARTNER_TO_CUST
    importing
      !LT_PARTNER_GUID type BUP_PARTNER_GUID_T
    exporting
      !LT_PARTNER type BUPA_CUST_TT .
endinterface.
