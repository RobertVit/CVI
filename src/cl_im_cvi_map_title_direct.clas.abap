class CL_IM_CVI_MAP_TITLE_DIRECT definition
  public
  final
  create public .

*"* public components of class CL_IM_CVI_MAP_TITLE_DIRECT
*"* do not include other source files here!!!
public section.

  interfaces IF_EX_CVI_MAP_TITLE .
protected section.
*"* protected components of class CL_IM_CVI_MAP_TITLE_DIRECT
*"* do not include other source files here!!!
private section.
*"* private components of class CL_IM_CVI_MAP_TITLE_DIRECT
*"* do not include other source files here!!!
ENDCLASS.



CLASS CL_IM_CVI_MAP_TITLE_DIRECT IMPLEMENTATION.


method if_ex_cvi_map_title~map_customer_title_bp_change.

  e_partner_title_key = i_customer_title.

endmethod.


method if_ex_cvi_map_title~map_customer_title_bp_create.

  e_partner_title_key = i_customer_title.

endmethod.


method if_ex_cvi_map_title~map_vendor_title_bp_change.

  e_partner_title_key = i_vendor_title.

endmethod.


method if_ex_cvi_map_title~map_vendor_title_bp_create.

  e_partner_title_key = i_vendor_title.

endmethod.
ENDCLASS.
