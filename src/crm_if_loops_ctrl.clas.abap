class CRM_IF_LOOPS_CTRL definition
  public
  create public .

public section.

  types:
    BEGIN OF ts_steps,
        sync_obj_source  TYPE mds_ctrl_obj_source,
        sync_obj_target  TYPE mds_ctrl_object,
        active_indicator TYPE mds_ctrl_opt_act_ind,
        mode(1), " 'L' = locking, 'S' = synchronization
      END   OF ts_steps .
  types:
    tt_steps TYPE STANDARD TABLE OF ts_steps .

  class-methods CHECK_STEPS
    importing
      !IV_SOURCE_OBJECT type MDS_CTRL_OBJ_SOURCE
      !IV_TARGET_OBJECT type MDS_CTRL_OBJ_SOURCE
      !IV_GUID type GUID_16
    exporting
      !EV_RELEVANT type BOOLE_D
      !ES_ERROR type MDS_CTRLS_ERROR .
  class-methods REFRESH_DATABASE_BUFFER
    importing
      !IV_GUID type GUID_16 .
protected section.
private section.
ENDCLASS.



CLASS CRM_IF_LOOPS_CTRL IMPLEMENTATION.


  METHOD check_steps.
    DATA: lt_active_options TYPE mds_ctrls_sync_opt_act,
          ls_active_options LIKE LINE OF lt_active_options,
          ls_steps          TYPE ts_steps,
          lt_steps          TYPE tt_steps,
          wa_indx           TYPE indx,
          lv_guid           TYPE c LENGTH 16.

**** initialize the GUID.
    lv_guid = iv_guid.

***** determine active synchronisation steps to source object
*    CALL METHOD mds_ctrl_customizing=>act_steps_sync_object_read
*      EXPORTING
*        iv_source_object  = iv_source_object
*      IMPORTING
*        et_active_options = lt_active_options
*        es_error          = es_error.
*
*    IF es_error-is_error = 'X'.
*      RETURN.
*    ENDIF.
*
*    IF lt_active_options[] IS INITIAL.
*      RETURN.
*    ENDIF.
*
***** Check if active synchronization exist.
*    ls_active_options-sync_obj_source = iv_source_object.
*    ls_active_options-sync_obj_target = iv_target_object.
*    READ TABLE lt_active_options  FROM ls_active_options
*                                  COMPARING sync_obj_source sync_obj_target
*                                  INTO ls_active_options.
*    IF sy-subrc = 0.
**** Get the table from the database.
      IMPORT lt_steps TO lt_steps FROM DATABASE indx(hk) ID lv_guid.
**** Check entry exist in the table.
      READ TABLE lt_steps WITH KEY
                     sync_obj_source = iv_target_object
                     sync_obj_target = iv_source_object
                     TRANSPORTING NO FIELDS.
      IF sy-subrc <> 0.
****  It is not a loop so add the value in database and return relevant flag = 'X'
        ls_steps-sync_obj_source = iv_source_object.
        ls_steps-sync_obj_target = iv_target_object.
        APPEND ls_steps TO lt_steps.
        "DELETE FROM DATABASE indx(hk) ID lv_guid.
        EXPORT lt_steps FROM lt_steps TO DATABASE indx(hk) ID lv_guid FROM wa_indx.
        ev_relevant = 'X'.
      ELSE.
        ev_relevant = ' '.
      ENDIF.
*    ENDIF.
  ENDMETHOD.


  METHOD refresh_database_buffer.
    DATA:
          lv_guid TYPE c LENGTH 16.

**** Clear the database buffer.
    lv_guid = iv_guid.
    DELETE FROM DATABASE indx(hk) ID lv_guid.
  ENDMETHOD.
ENDCLASS.
