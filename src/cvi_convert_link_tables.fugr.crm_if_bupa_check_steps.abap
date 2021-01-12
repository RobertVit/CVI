FUNCTION CRM_IF_BUPA_CHECK_STEPS.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IM_GUID) TYPE  GUID_16
*"     VALUE(IV_SOURCE_OBJECT) TYPE  MDS_CTRL_OBJ_SOURCE
*"     VALUE(IV_TARGET_OBJECT) TYPE  MDS_CTRL_OBJ_SOURCE
*"  EXPORTING
*"     VALUE(EV_RELEVANT) TYPE  BOOLE_D
*"----------------------------------------------------------------------
**** Check the step.
CALL METHOD crm_if_loops_ctrl=>check_steps
  EXPORTING
    iv_source_object = IV_SOURCE_OBJECT
    iv_target_object = IV_TARGET_OBJECT
    iv_guid          = IM_GUID
  IMPORTING
    ev_relevant      = EV_RELEVANT
*    es_error         =
    .

ENDFUNCTION.
