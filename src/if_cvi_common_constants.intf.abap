*"* components of interface IF_CVI_COMMON_CONSTANTS
interface IF_CVI_COMMON_CONSTANTS
  public .


  constants BP_AS_GROUP type BU_TYPE value '3'. "#EC NOTEXT
  constants BP_AS_ORG type BU_TYPE value '2'. "#EC NOTEXT
  constants BP_AS_PERSON type BU_TYPE value '1'. "#EC NOTEXT
  constants FALSE type BOOLE-BOOLE value SPACE. "#EC NOTEXT
  constants TASK_CURRENT_STATE type BUS_EI_OBJECT_TASK value 'C'. "#EC NOTEXT
  constants TASK_DELETE type BUS_EI_OBJECT_TASK value 'D'. "#EC NOTEXT
  constants TASK_TIME type BUS_EI_OBJECT_TASK value 'T'. "#EC NOTEXT
  constants TASK_INSERT type BUS_EI_OBJECT_TASK value 'I'. "#EC NOTEXT
  constants TASK_MODIFY type BUS_EI_OBJECT_TASK value 'M'. "#EC NOTEXT
  constants TASK_UPDATE type BUS_EI_OBJECT_TASK value 'U'. "#EC NOTEXT
  constants TASK_STANDARD type BUS_EI_ADDRESS_TASK value 'S'. "#EC NOTEXT
  constants TRUE type BOOLE-BOOLE value 'X'. "#EC NOTEXT
  constants MSG_CLASS_CVI type SYMSGID value 'CVI_MAPPING'. "#EC NOTEXT
  constants CVI_MAPPER_BADI_NAME type EXIT_DEF value 'CVI_CUSTOM_MAPPER'. "#EC NOTEXT
  constants CVI_MAP_BANKDETAILS_BADI_NAME type EXIT_DEF value 'CVI_MAP_BANKDETAILS'. "#EC NOTEXT
  constants CVI_MAP_CREDIT_CARDS_BADI_NAME type EXIT_DEF value 'CVI_MAP_CREDIT_CARDS'. "#EC NOTEXT
  constants CVI_MAP_TITLE_BADI_NAME type EXIT_DEF value 'CVI_MAP_TITLE'. "#EC NOTEXT
endinterface.
