class CVI_CL_CUSTOMIZING_CHECKS definition
  public
  final
  create public .

public section.

  interfaces CVP_IF_TABLE_MAINTENANCE_EVENT .
  interfaces IF_BADI_INTERFACE .

  constants GC_APPL_NAME_CUSTOMER type CVP_APPL_NAME value 'CVI' ##NO_TEXT.
  constants GC_APPL_NAME_VENDOR type CVP_APPL_NAME value 'CVI' ##NO_TEXT.
  constants GC_APPL_NAME_CONTACT_PERSON type CVP_APPL_NAME value 'CVI' ##NO_TEXT.
  constants GC_TRUE type BOOLE_D value 'X' ##NO_TEXT.
protected section.
private section.
ENDCLASS.



CLASS CVI_CL_CUSTOMIZING_CHECKS IMPLEMENTATION.


  method CVP_IF_TABLE_MAINTENANCE_EVENT~EOPAPP_FILTER_SHLP_PRESELECT.
    DATA ls_selopt TYPE ddshselopt.
    CHECK is_callcontrol-step = 'PRESEL' OR is_callcontrol-step = 'PRESEL1'.
    ls_selopt-shlpname = cs_shlp-shlpname.
    ls_selopt-shlpfield = 'APPL_NAME'.
    ls_selopt-sign      = 'E'.
    ls_selopt-option    = 'EQ'.
    ls_selopt-low       = 'CVI'.
    ls_selopt-high      = space.
    COLLECT ls_selopt INTO cs_shlp-selopt.
    ls_selopt-shlpname = cs_shlp-shlpname.
    ls_selopt-shlpfield = 'APPL_NAME'.
    ls_selopt-sign      = 'E'.
    ls_selopt-option    = 'EQ'.
    ls_selopt-low       = 'CVI'.
    ls_selopt-high      = space.
    COLLECT ls_selopt INTO cs_shlp-selopt.
    ls_selopt-shlpname = cs_shlp-shlpname.
    ls_selopt-shlpfield = 'APPL_NAME'.
    ls_selopt-sign      = 'E'.
    ls_selopt-option    = 'EQ'.
    ls_selopt-low       = 'CVI'.
    ls_selopt-high      = space.
    COLLECT ls_selopt INTO cs_shlp-selopt.
  endmethod.


  method CVP_IF_TABLE_MAINTENANCE_EVENT~EOPARV_AT_CREATE.
    CASE cs_eoparv-appl_name.
      WHEN  gc_appl_name_customer OR gc_appl_name_vendor
        OR gc_appl_name_contact_person.
        MESSAGE e053(cvp_dp_ilm) WITH cs_eoparv-appl_name.
*       Rule Variant not supported for Application Name &1
    ENDCASE.
  endmethod.


  method CVP_IF_TABLE_MAINTENANCE_EVENT~EOPARV_BEFORE_SAVE.
*    CHECK iv_global_action NE 'D'. " Delete
    CHECK cs_flagtab-action NE 'D'.

    CASE cs_eoparv-appl_name.
      WHEN gc_appl_name_customer OR gc_appl_name_vendor
        OR gc_appl_name_contact_person.
        CLEAR cv_changed.
        cv_error = gc_true.
        MESSAGE s053(cvp_dp_ilm) WITH cs_eoparv-appl_name.
*     Rule Variant not supported for Application Name &1
    ENDCASE.

  endmethod.
ENDCLASS.
