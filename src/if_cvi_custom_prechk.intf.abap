interface IF_CVI_CUSTOM_PRECHK
  public .


  interfaces IF_BADI_INTERFACE .

  types:
    TT_KUNNR type TABLE OF kna1-kunnr .
  types:
    TT_lifnr type TABLE OF lfa1-lifnr .

  methods EXECUTE_CUSTOM_CHECK
    importing
      !IT_CUSTOMER type IF_CVI_CUSTOM_PRECHK=>TT_KUNNR
      !IT_VENDOR type IF_CVI_CUSTOM_PRECHK=>TT_LIFNR
    exporting
      !CT_ERROR type IF_CVI_PRECHK=>TT_PRECHK_ERROR .
endinterface.
