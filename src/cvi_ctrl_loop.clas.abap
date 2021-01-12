class CVI_CTRL_LOOP definition
  public
  create private .

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

  methods CHECK_STEPS
    importing
      !IV_SOURCE_OBJECT type MDS_CTRL_OBJ_SOURCE
      !IV_TARGET_OBJECT type MDS_CTRL_OBJ_SOURCE
    exporting
      !EV_RELEVANT type BOOLE_D
      !ES_ERROR type MDS_CTRLS_ERROR .
  class-methods GET_INSTANCE
    exporting
      !ER_OBJECT type ref to CVI_CTRL_LOOP .
protected section.
private section.

  data GT_STEPS type TT_STEPS .
  class-data GR_STRATEGY type ref to CVI_CTRL_LOOP .

  methods CONSTRUCTOR .
ENDCLASS.



CLASS CVI_CTRL_LOOP IMPLEMENTATION.


  METHOD check_steps.

    DATA: lt_active_options     TYPE mds_ctrls_sync_opt_act,
          ls_steps              TYPE ts_steps,
          lv_boolean            TYPE sap_bool,
          lv_caller_async_type  TYPE  sy-batch,
          lv_caller_destination TYPE  rfcdisplay-rfcdest.


    CALL FUNCTION 'RFC_GET_ATTRIBUTES'
      IMPORTING
        caller_destination        = lv_caller_destination
        caller_async_type         = lv_caller_async_type
      EXCEPTIONS
        system_call_not_supported = 1
        no_rfc_communication      = 2
        internal_error            = 3
        OTHERS                    = 4.
    IF sy-subrc = 0 AND lv_caller_async_type = 0.
      CALL METHOD cl_rfc=>check_rfc_external
        RECEIVING
          external_call    = lv_boolean
        EXCEPTIONS
          kernel_too_old   = 1
          unexpected_error = 2
          OTHERS           = 3.
      IF sy-subrc <> 0.
*   Implement suitable error handling here
      ELSEIF lv_boolean = ' '.
        CALL FUNCTION 'CVI_GET_CTRL_LOOP' DESTINATION 'BACK'
          EXPORTING
            iv_source_object = iv_source_object
            iv_target_object = iv_target_object
          IMPORTING
            ev_relevant      = ev_relevant.
      ELSEIF lv_boolean = abap_true.
        READ TABLE gt_steps WITH KEY
                       sync_obj_source = iv_target_object
                       sync_obj_target = iv_source_object
                       TRANSPORTING NO FIELDS.
        IF sy-subrc <> 0.
          ls_steps-sync_obj_source = iv_source_object.
          ls_steps-sync_obj_target = iv_target_object.
          APPEND ls_steps TO gt_steps.
          ev_relevant = 'X'.
        ELSE.
          ev_relevant = ' '.
        ENDIF.
      ENDIF.
    ELSEIF sy-subrc = 2 or lv_caller_async_type <> 0.

***** determine active synchronisation steps to source object
*      CALL METHOD mds_ctrl_customizing=>act_steps_sync_object_read
*        EXPORTING
*          iv_source_object  = iv_source_object
*        IMPORTING
*          et_active_options = lt_active_options
*          es_error          = es_error.
*
*      IF es_error-is_error = 'X'.
*        RETURN.
*      ENDIF.
*
*      IF lt_active_options[] IS INITIAL.
*        RETURN.
*      ENDIF.

***** Check if active synchronization exist.
*      READ TABLE lt_active_options  WITH KEY
*                       sync_obj_source = iv_source_object
*                       sync_obj_target = iv_target_object
*                       TRANSPORTING NO FIELDS.
*      IF sy-subrc = 0.
**** Check entry exist in the table.
        READ TABLE gt_steps WITH KEY
                       sync_obj_source = iv_target_object
                       sync_obj_target = iv_source_object
                       TRANSPORTING NO FIELDS.
        IF sy-subrc <> 0.
          ls_steps-sync_obj_source = iv_source_object.
          ls_steps-sync_obj_target = iv_target_object.
          APPEND ls_steps TO gt_steps.
          ev_relevant = 'X'.
        ELSE.
          ev_relevant = ' '.
        ENDIF.
*      ENDIF.
    ENDIF.
  ENDMETHOD.


  method CONSTRUCTOR.
  endmethod.


  METHOD get_instance.
    DATA:
          lv_boolean TYPE sap_bool.
**** Create object if not exist.
    IF gr_strategy IS NOT BOUND.
      CREATE OBJECT gr_strategy.
      er_object = gr_strategy.
    ELSE.
      er_object = gr_strategy.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
