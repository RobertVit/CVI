class CL_IM_CVI_MAP_BUSINESS_ADDRESS definition
  public
  final
  create public .

*"* public components of class CL_IM_CVI_MAP_BUSINESS_ADDRESS
*"* do not include other source files here!!!
public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_CVI_CUSTOM_MAPPER .

  methods CONSTRUCTOR .
protected section.
*"* protected components of class CL_IM_CVI_MAP_BUSINESS_ADDRESS
*"* do not include other source files here!!!
private section.
*"* private components of class CL_IM_CVI_MAP_BUSINESS_ADDRESS
*"* do not include other source files here!!!

  data FM_BP_CUSTOMER_CONTACT type ref to CVI_FM_BP_CUSTOMER_CONTACT .
  data FM_BP_VENDOR_CONTACT type ref to CVI_FM_BP_VENDOR_CONTACT .
ENDCLASS.



CLASS CL_IM_CVI_MAP_BUSINESS_ADDRESS IMPLEMENTATION.


method CONSTRUCTOR.

* initialize field mapper objects
  fm_bp_customer_contact = cvi_fm_bp_customer_contact=>get_instance( ).
  fm_bp_vendor_contact   = cvi_fm_bp_vendor_contact=>get_instance( ).

endmethod.


method IF_EX_CVI_CUSTOM_MAPPER~MAP_BP_REL_TO_CUSTOMER_CONTACT.

  FM_BP_CUSTOMER_CONTACT->MAP_BP_REL_BUSINESS_ADDRESS(
    EXPORTING
      I_PARTNER      = i_partner
      I_PERSON       = i_person
      I_RELATION     = i_relation
    CHANGING
      C_ADDRESS_GUID = c_address_guid
      C_ERRORS       = c_errors
      C_CONTACT      = c_customer_contact
  ).

endmethod.


method IF_EX_CVI_CUSTOM_MAPPER~MAP_BP_REL_TO_VENDOR_CONTACT.

  FM_BP_VENDOR_CONTACT->MAP_BP_REL_BUSINESS_ADDRESS(
    EXPORTING
      I_PARTNER      = i_partner
      I_PERSON       = i_person
      I_RELATION     = i_relation
    CHANGING
      V_ADDRESS_GUID = c_address_guid
      C_ERRORS       = c_errors
      V_CONTACT      = c_vendor_contact
  ).

endmethod.


method IF_EX_CVI_CUSTOM_MAPPER~MAP_BP_TO_CUSTOMER.
*
                                                            "#EC NEEDED
endmethod.


method IF_EX_CVI_CUSTOM_MAPPER~MAP_BP_TO_CUSTOMER_CONTACT.

  FM_BP_CUSTOMER_CONTACT->MAP_BP_BUSINESS_ADDRESS(
    EXPORTING
      I_PARTNER  = i_partner
      I_RELATION = i_relation
    CHANGING
      C_ERRORS   = c_errors
      C_CONTACT  = c_customer_contact
  ).

endmethod.


method IF_EX_CVI_CUSTOM_MAPPER~MAP_BP_TO_VENDOR.
*
                                                            "#EC NEEDED
endmethod.


method IF_EX_CVI_CUSTOM_MAPPER~MAP_BP_TO_VENDOR_CONTACT.

IF FM_BP_VENDOR_CONTACT IS NOT INITIAL.
  FM_BP_VENDOR_CONTACT->MAP_BP_BUSINESS_ADDRESS(
      EXPORTING
        I_PARTNER  = i_partner
        I_RELATION = i_relation
      CHANGING
        C_ERRORS   = c_errors
        V_CONTACT  = c_vendor_contact
    ).
ENDIF.

endmethod.


method IF_EX_CVI_CUSTOM_MAPPER~MAP_CUSTOMER_TO_BP.
*
                                                            "#EC NEEDED
endmethod.


method IF_EX_CVI_CUSTOM_MAPPER~MAP_CUST_CONT_TO_BP_AND_REL.

  FM_BP_CUSTOMER_CONTACT->MAP_CC_BUSINESS_ADDRESS(
    EXPORTING
      I_CUSTOMER_CONTACT = i_customer_contact
    CHANGING
      C_ERRORS           = c_errors
      C_PARTNER          = c_partner
      C_PERSON           = c_person
      C_RELATION         = c_relation
  ).

endmethod.


method IF_EX_CVI_CUSTOM_MAPPER~MAP_PERSON_TO_CUSTOMER_CONTACT.

  FM_BP_CUSTOMER_CONTACT->MAP_PERSON_BUSINESS_ADDRESS(
    EXPORTING
      I_PERSON  = i_person
    CHANGING
      C_ERRORS  = c_errors
      C_CONTACT = c_contact
  ).


endmethod.


method IF_EX_CVI_CUSTOM_MAPPER~MAP_PERSON_TO_VENDOR_CONTACT.
endmethod.


method IF_EX_CVI_CUSTOM_MAPPER~MAP_VENDOR_TO_BP.
*
                                                            "#EC NEEDED
endmethod.


method IF_EX_CVI_CUSTOM_MAPPER~MAP_VEND_CONT_TO_BP_AND_REL.

    FM_BP_VENDOR_CONTACT->MAP_VC_BUSINESS_ADDRESS(
    EXPORTING
      I_VENDOR_CONTACT = i_vendor_contact
    CHANGING
      C_ERRORS           = c_errors
      C_PARTNER          = c_partner
      C_PERSON           = c_person
      C_RELATION         = c_relation
  ).
endmethod.
ENDCLASS.
