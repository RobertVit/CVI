*"* components of interface IF_EX_CVI_MAP_CREDIT_CARDS
interface IF_EX_CVI_MAP_CREDIT_CARDS
  public .


  interfaces IF_BADI_INTERFACE .

  methods IGNORE_DUPLICATES
    returning
      value(R_STATUS) type BOOLE-BOOLE .
  methods MAP_BP_CREDIT_CARDS
    importing
      !I_PARTNER_GUID type BU_PARTNER_GUID_BAPI
      !I_CUSTOMER_ID type KUNNR
      !I_PARTNER_CREDIT_CARDS type BUS_EI_CREDITCARD
    exporting
      !E_CUSTOMER_CREDIT_CARDS type CMDS_EI_CMD_CREDITCARD
      !E_ERRORS type CVIS_ERROR .
  methods MAP_CUSTOMER_CREDIT_CARDS
    importing
      !I_CUSTOMER_ID type KUNNR
      !I_PARTNER_GUID type BU_PARTNER_GUID_BAPI
      !I_CUSTOMER_CREDIT_CARDS type CMDS_EI_CMD_CREDITCARD
    exporting
      !E_PARTNER_CREDIT_CARDS type BUS_EI_CREDITCARD
      !E_ERRORS type CVIS_ERROR .
endinterface.
