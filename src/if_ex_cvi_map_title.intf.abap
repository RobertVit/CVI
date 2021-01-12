*"* components of interface IF_EX_CVI_MAP_TITLE
interface IF_EX_CVI_MAP_TITLE
  public .


  interfaces IF_BADI_INTERFACE .

  methods MAP_CUSTOMER_TITLE_BP_CREATE
    importing
      !I_CUSTOMER_ID type KUNNR
      !I_PARTNER_GUID type BU_PARTNER_GUID
      !I_CUSTOMER_TITLE type AD_TITLE
    exporting
      !E_PARTNER_TITLE_KEY type AD_TITLE
      !E_ERRORS type CVIS_ERROR
    changing
      !C_PARTNER_CATEGORY type BU_TYPE .
  methods MAP_CUSTOMER_TITLE_BP_CHANGE
    importing
      !I_CUSTOMER_ID type KUNNR
      !I_PARTNER_GUID type BU_PARTNER_GUID
      !I_CUSTOMER_TITLE type AD_TITLE
    exporting
      !E_PARTNER_TITLE_KEY type AD_TITLE
      !E_ERRORS type CVIS_ERROR .
  methods MAP_VENDOR_TITLE_BP_CREATE
    importing
      !I_VENDOR_ID type LIFNR
      !I_PARTNER_GUID type BU_PARTNER_GUID
      !I_VENDOR_TITLE type AD_TITLE
    exporting
      !E_PARTNER_TITLE_KEY type AD_TITLE
      !E_ERRORS type CVIS_ERROR
    changing
      !C_PARTNER_CATEGORY type BU_TYPE .
  methods MAP_VENDOR_TITLE_BP_CHANGE
    importing
      !I_VENDOR_ID type LIFNR
      !I_PARTNER_GUID type BU_PARTNER_GUID
      !I_VENDOR_TITLE type AD_TITLE
    exporting
      !E_PARTNER_TITLE_KEY type AD_TITLE
      !E_ERRORS type CVIS_ERROR .
endinterface.
