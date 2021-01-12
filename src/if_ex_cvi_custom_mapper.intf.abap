*"* components of interface IF_EX_CVI_CUSTOM_MAPPER
interface IF_EX_CVI_CUSTOM_MAPPER
  public .


  interfaces IF_BADI_INTERFACE .

  methods MAP_BP_TO_CUSTOMER
    importing
      !I_PARTNER type BUS_EI_EXTERN
    changing
      !C_CUSTOMER type CMDS_EI_EXTERN
      !C_ERRORS type CVIS_ERROR .
  methods MAP_BP_REL_TO_CUSTOMER_CONTACT
    importing
      !I_PARTNER type BUS_EI_EXTERN
      !I_PERSON type BUS_EI_EXTERN
      !I_RELATION type BURS_EI_EXTERN
    changing
      !C_ERRORS type CVIS_ERROR
      !C_ADDRESS_GUID type SYSUUID_C
      !C_CUSTOMER_CONTACT type CMDS_EI_CONTACTS .
  methods MAP_BP_TO_CUSTOMER_CONTACT
    importing
      !I_PARTNER type BUS_EI_EXTERN
      !I_RELATION type BURS_EI_EXTERN
    changing
      !C_CUSTOMER_CONTACT type CMDS_EI_CONTACTS
      !C_ERRORS type CVIS_ERROR .
  methods MAP_BP_TO_VENDOR
    importing
      !I_PARTNER type BUS_EI_EXTERN
    changing
      !C_VENDOR type VMDS_EI_EXTERN
      !C_ERRORS type CVIS_ERROR .
  methods MAP_CUSTOMER_TO_BP
    importing
      !I_CUSTOMER type CMDS_EI_EXTERN
    changing
      !C_PARTNER type BUS_EI_EXTERN
      !C_ERRORS type CVIS_ERROR .
  methods MAP_CUST_CONT_TO_BP_AND_REL
    importing
      !I_CUSTOMER_CONTACT type CMDS_EI_CONTACTS
    changing
      !C_ERRORS type CVIS_ERROR
      !C_PARTNER type BUS_EI_EXTERN
      !C_PERSON type BUS_EI_EXTERN
      !C_RELATION type BURS_EI_EXTERN .
  methods MAP_VENDOR_TO_BP
    importing
      !I_VENDOR type VMDS_EI_EXTERN
    changing
      !C_PARTNER type BUS_EI_EXTERN
      !C_ERRORS type CVIS_ERROR .
  methods MAP_PERSON_TO_CUSTOMER_CONTACT
    importing
      !I_PERSON type BUS_EI_EXTERN
      !I_RELATION type BURS_EI_EXTERN
    changing
      !C_ERRORS type CVIS_ERROR
      !C_ADDRESS_GUID type SYSUUID_C
      !C_CONTACT type CMDS_EI_CONTACTS .
  methods MAP_BP_REL_TO_VENDOR_CONTACT
    importing
      !I_PARTNER type BUS_EI_EXTERN
      !I_PERSON type BUS_EI_EXTERN
      !I_RELATION type BURS_EI_EXTERN
    changing
      !C_ERRORS type CVIS_ERROR
      !C_ADDRESS_GUID type SYSUUID_C
      !C_VENDOR_CONTACT type VMDS_EI_CONTACTS .
  methods MAP_VEND_CONT_TO_BP_AND_REL
    importing
      !I_VENDOR_CONTACT type VMDS_EI_CONTACTS
    changing
      !C_ERRORS type CVIS_ERROR
      !C_PARTNER type BUS_EI_EXTERN
      !C_PERSON type BUS_EI_EXTERN
      !C_RELATION type BURS_EI_EXTERN .
  methods MAP_BP_TO_VENDOR_CONTACT
    importing
      !I_PARTNER type BUS_EI_EXTERN
      !I_RELATION type BURS_EI_EXTERN
    changing
      !C_VENDOR_CONTACT type VMDS_EI_CONTACTS
      !C_ERRORS type CVIS_ERROR .
  methods MAP_PERSON_TO_VENDOR_CONTACT
    importing
      !I_PERSON type BUS_EI_EXTERN
      !I_RELATION type BURS_EI_EXTERN
    changing
      !C_ERRORS type CVIS_ERROR
      !C_ADDRESS_GUID type SYSUUID_C
      !C_CONTACT type VMDS_EI_CONTACTS .
endinterface.
