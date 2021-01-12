class CL_IM_CVI_ASSIGN_CUST_VEND definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_CVI_CUSTOM_MAPPER .

  class-data TRUE type BOOLE_D value 'X' ##NO_TEXT.
protected section.
private section.
ENDCLASS.



CLASS CL_IM_CVI_ASSIGN_CUST_VEND IMPLEMENTATION.


method IF_EX_CVI_CUSTOM_MAPPER~MAP_BP_REL_TO_CUSTOMER_CONTACT.
endmethod.


method IF_EX_CVI_CUSTOM_MAPPER~MAP_BP_REL_TO_VENDOR_CONTACT.
endmethod.


method if_ex_cvi_custom_mapper~map_bp_to_customer.

  data:
    lv_partner      type bu_partner,
    lv_vendor       type lifnr,
    lcl_fsbp_bo_cvi type ref to fsbp_bo_cvi,
    lcl_bp_vendor   type ref to cvi_bp_vendor.


  lv_partner = i_partner-header-object_instance-bpartner.
  lcl_fsbp_bo_cvi ?= fsbp_business_factory=>get_instance( lv_partner ).
  lcl_bp_vendor   = lcl_fsbp_bo_cvi->vendor.

  "only continue, in case there is a vendor assigned to the bp
  lv_vendor = lcl_bp_vendor->get_vendor( ).
  if lv_vendor is not initial.
    c_customer-central_data-central-data-lifnr = lv_vendor.
    c_customer-central_data-central-datax-lifnr = true.
  endif.

endmethod.


method IF_EX_CVI_CUSTOM_MAPPER~MAP_BP_TO_CUSTOMER_CONTACT.
endmethod.


method if_ex_cvi_custom_mapper~map_bp_to_vendor.

  data:
    lv_partner      type bu_partner,
    lv_customer     type kunnr,
    lcl_fsbp_bo_cvi type ref to fsbp_bo_cvi,
    lcl_bp_customer type ref to cvi_bp_customer.

  lv_partner = i_partner-header-object_instance-bpartner.
  lcl_fsbp_bo_cvi ?= fsbp_business_factory=>get_instance( lv_partner ).
  lcl_bp_customer = lcl_fsbp_bo_cvi->customer.
  lv_customer = lcl_bp_customer->get_customer( ).
  "only continue, in case there is a customer assigned to the bp
  if lv_customer is not initial.
    c_vendor-central_data-central-data-kunnr = lv_customer.
    c_vendor-central_data-central-datax-kunnr = true.
  endif.

endmethod.


method IF_EX_CVI_CUSTOM_MAPPER~MAP_BP_TO_VENDOR_CONTACT.
endmethod.


method IF_EX_CVI_CUSTOM_MAPPER~MAP_CUSTOMER_TO_BP.
endmethod.


method IF_EX_CVI_CUSTOM_MAPPER~MAP_CUST_CONT_TO_BP_AND_REL.
endmethod.


method IF_EX_CVI_CUSTOM_MAPPER~MAP_PERSON_TO_CUSTOMER_CONTACT.
endmethod.


method IF_EX_CVI_CUSTOM_MAPPER~MAP_PERSON_TO_VENDOR_CONTACT.
endmethod.


method IF_EX_CVI_CUSTOM_MAPPER~MAP_VENDOR_TO_BP.
endmethod.


method IF_EX_CVI_CUSTOM_MAPPER~MAP_VEND_CONT_TO_BP_AND_REL.
endmethod.
ENDCLASS.
