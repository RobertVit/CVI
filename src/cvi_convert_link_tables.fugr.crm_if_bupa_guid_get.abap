FUNCTION CRM_IF_BUPA_GUID_GET.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  EXPORTING
*"     REFERENCE(EX_GUID) TYPE  GUID_16
*"----------------------------------------------------------------------
DATA:
        ref_cx_uuid_error TYPE REF TO cx_uuid_error.

  IF gv_crm_if_guid IS INITIAL.
    TRY.
        gv_crm_if_guid = cl_system_uuid=>if_system_uuid_static~create_uuid_x16( ).
      CATCH cx_uuid_error INTO  ref_cx_uuid_error.
    ENDTRY.
  ENDIF.

  ex_guid = gv_crm_if_guid.

ENDFUNCTION.
