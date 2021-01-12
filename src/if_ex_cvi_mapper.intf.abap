*"* components of interface IF_EX_CVI_MAPPER
interface IF_EX_CVI_MAPPER
  public .


  interfaces IF_BADI_INTERFACE .

  methods MAP_BPS_TO_CUSTOMERS
    importing
      !I_PARTNERS type BUS_EI_MAIN
    changing
      !C_ERRORS type CVIS_ERROR
      !C_CUSTOMERS type CMDS_EI_EXTERN_T .
  methods MAP_BPS_TO_VENDORS
    importing
      !I_PARTNERS type BUS_EI_MAIN
    changing
      !C_VENDORS type VMDS_EI_EXTERN_T
      !C_ERRORS type CVIS_ERROR .
  methods MAP_CUSTOMERS_TO_BPS
    importing
      !I_CUSTOMERS type CMDS_EI_EXTERN_T
    changing
      !C_ERRORS type CVIS_ERROR
      !C_PARTNERS type BUS_EI_MAIN .
  methods MAP_VENDORS_TO_BPS
    importing
      !I_VENDORS type VMDS_EI_EXTERN_T
    changing
      !C_ERRORS type CVIS_ERROR
      !C_PARTNERS type BUS_EI_MAIN .
endinterface.
