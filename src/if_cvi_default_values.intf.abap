*"* components of interface IF_CVI_DEFAULT_VALUES
interface IF_CVI_DEFAULT_VALUES
  public .


  interfaces IF_BADI_INTERFACE .

  class-methods GET_DEFAULTS_FOR_CUST
    importing
      !I_ROLE_CATEGORIES type CVIS_ROLE_CATEGORY_T
    changing
      !C_CENTRAL type CMDS_EI_VMD_CENTRAL_DATA optional
      !C_TAX_GROUPING type CVIS_CUST_TAX_GROUPING_T optional
      !C_TAX_INDICATORS type CVIS_CUST_TAX_IND_T optional
      !C_EXPORT type CVIS_CUST_EXPORT_T optional
      !C_LOADING type CVIS_CUST_LOADING_T optional
      !C_DEFAULT_COMPANY_CODES type CVIS_COMPANY_CODE_T optional
      !C_DEFAULT_SALES_AREAS type CVIS_SALES_AREA_T optional .
  class-methods GET_DEFAULTS_FOR_CUST_CC
    importing
      !I_ROLE_CATEGORIES type CVIS_ROLE_CATEGORY_T
      !I_NEW_COMPANY_CODE type BUKRS
    changing
      !C_COMPANY_DATA type CMDS_EI_COMPANY_DATA optional
      !C_DUNNING type CVIS_CUST_CC_DUNNING_T optional
      !C_WTAX_TYPE type CVIS_CUST_CC_WTAX_TYPE_T optional .
  class-methods GET_DEFAULTS_FOR_CUST_SALES
    importing
      !I_GROUPING type BU_GROUP
      !I_ROLE_CATEGORIES type CVIS_ROLE_CATEGORY_T
      !I_NEW_SALES_AREA type CVIS_SALES_AREA
    changing
      !C_SALES_AREA type CMDS_EI_SALES_DATA optional
      !C_FUNCTIONS type CVIS_CUST_FUNCTIONS_T optional
      !C_TAX_IND type CVIS_CUST_TAX_IND_T optional .
  class-methods GET_DEFAULTS_FOR_VEND
    importing
      !I_ROLE_CATEGORIES type CVIS_ROLE_CATEGORY_T
    changing
      !C_CENTRAL type VMDS_EI_VMD_CENTRAL_DATA optional
      !C_TAX_GROUPING type CVIS_VEND_TAX_GROUPING_T optional
      !C_DEFAULT_COMPANY_CODES type CVIS_COMPANY_CODE_T optional
      !C_DEFAULT_PURCHASING_ORGS type CVIS_PURCHASING_ORG_T optional .
  class-methods GET_DEFAULTS_FOR_VEND_CC
    importing
      !I_ROLE_CATEGORIES type CVIS_ROLE_CATEGORY_T
      !I_NEW_COMPANY_CODE type BUKRS
    changing
      !C_COMPANY_DATA type VMDS_EI_COMPANY_DATA optional
      !C_DUNNING type CVIS_VEND_CC_DUNNING_T optional
      !C_WTAX_TYPE type CVIS_VEND_CC_WTAX_TYPE_T optional .
  class-methods GET_DEFAULTS_FOR_VEND_PORG
    importing
      !I_GROUPING type BU_GROUP
      !I_ROLE_CATEGORIES type CVIS_ROLE_CATEGORY_T
      !I_NEW_PURCHASING_ORG type CVIS_PURCHASING_ORG
    changing
      !C_PURCHASING_ORG type VMDS_EI_PURCHASING_DATA optional
      !C_FUNCTIONS type CVIS_VEND_FUNCTIONS_T optional .
endinterface.
