FUNCTION CVI_PRECHK_PPF_TASK .
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     VALUE(IV_RUNID) TYPE  CVI_PRECHK_RUNID
*"     VALUE(IV_OBJTYPE) TYPE  CVI_PRECHK_OBJTYPE
*"     VALUE(IR_OBJID_RANGE) TYPE  CVI_PRECHK_CVNUM_RTT
*"     VALUE(IR_CVGROUP_RANGE) TYPE  CVI_PRECHK_CVGRP_RTT
*"     VALUE(IV_SERVER_GROUP) TYPE  SPTA_RFCGR
*"     VALUE(IS_SCENARIO) TYPE  CVI_PRECHK_SCENARIO_S
*"  EXPORTING
*"     VALUE(EX_RETURN) TYPE  BAPIRET2
*"----------------------------------------------------------------------

  DATA: ls_ppf_param     TYPE if_cvi_prechk=>ty_ppf_param,
        lt_kna1          TYPE TABLE OF kna1,
        lt_lfa1          TYPE TABLE OF lfa1,
        ls_ppf_chk_data  TYPE if_cvi_prechk=>ty_prechk_master_data,
        lr_ppf_param     TYPE REF TO if_cvi_prechk=>ty_ppf_param,
        lv_subrc         TYPE sy-subrc,
        lt_kunnr         TYPE TABLE OF kna1-kunnr,
        lt_kunnr_per_run TYPE TABLE OF kna1-kunnr,
        lt_lifnr         TYPE TABLE OF lfa1-lifnr,
        lt_lifnr_per_run TYPE TABLE OF lfa1-lifnr.

  FIELD-SYMBOLS: <lf_kna1> type kna1,
                 <lf_lfa1> type lfa1.

  "All the fields except chk_data will be common for all parallel tasks.
  CLEAR ls_ppf_param.
  ls_ppf_param-objtype = iv_objtype.
  ls_ppf_param-runid = iv_runid.
  ls_ppf_param-scen = is_scenario.
  TRY.
  "If the object type is customer.
      IF iv_objtype EQ if_cvi_prechk=>gc_objtype_cust.
    CLEAR lt_kunnr.
        "Select all customer numbers and store in lt_kunnr.
        SELECT kunnr
          FROM kna1
          INTO TABLE lt_kunnr
          WHERE kunnr IN ir_objid_range
        AND ktokd IN ir_cvgroup_range "customer account group
        AND kunnr NOT IN ( SELECT customer FROM cvi_cust_link where customer IN ir_objid_range )
        ORDER BY kunnr.
        WHILE lt_kunnr IS NOT INITIAL.
          "Get set of records based on records per run (1,00,000)
          CLEAR lt_kna1.
          CLEAR lt_kunnr_per_run.
          "Get only records per run into lt_kunnr_per_run and delete the same from lt_kunnr.
          APPEND LINES OF lt_kunnr FROM 1 TO if_cvi_prechk=>record_per_run TO lt_kunnr_per_run.
          DELETE lt_kunnr FROM 1 TO if_cvi_prechk=>record_per_run.
          "Select the required fields from kna1 only for records per run.
          SELECT
              kunnr adrnr brsch land1 txjcd stceg stcdt ktokd
              stcd1 stcd2 stcd3 stcd4 stcd5 stkzn stkzu regio
          FROM kna1 INTO CORRESPONDING FIELDS OF TABLE lt_kna1
          FOR ALL ENTRIES IN lt_kunnr_per_run WHERE kunnr = lt_kunnr_per_run-table_line.

          "Filling the check data for parallel processing.
          LOOP AT lt_kna1 ASSIGNING <lf_kna1>.
            CLEAR ls_ppf_chk_data.
            MOVE-CORRESPONDING <lf_kna1> TO ls_ppf_chk_data.
            ls_ppf_chk_data-cvnum = <lf_kna1>-kunnr.
            ls_ppf_chk_data-acc_group = <lf_kna1>-ktokd.
        APPEND ls_ppf_chk_data TO ls_ppf_param-chk_data.
      ENDLOOP.

      GET REFERENCE OF ls_ppf_param INTO lr_ppf_param.

      "Start parallel processing for record_per_run.
          TEST-SEAM spta_call_customer.
            CALL FUNCTION 'SPTA_PARA_PROCESS_START_2'
        EXPORTING
          server_group             = iv_server_group
          before_rfc_callback_form = 'BEFORE_RFC'
          in_rfc_callback_form     = 'IN_RFC'
          after_rfc_callback_form  = 'AFTER_RFC'
              callback_prog            = 'CVI_MIGRATION_PRECHK'
        CHANGING
          user_param               = lr_ppf_param
        EXCEPTIONS
          invalid_server_group     = 1
          no_resources_available   = 2
          OTHERS                   = 3.
      lv_subrc = sy-subrc.
          END-TEST-SEAM.
      IF lv_subrc NE 0.
        CLEAR ex_return.
        ex_return-type = 'E'.
            ex_return-id = if_cvi_prechk=>GC_MESSAGE_CLASS.
        IF lv_subrc EQ 1.
          IF 1 = 2.
                MESSAGE e005(CVI_PRECHK).
          ENDIF.
          ex_return-number = '005'.
        ELSEIF lv_subrc EQ 2.
          IF 1 = 2.
                MESSAGE e006(CVI_PRECHK).
          ENDIF.
          ex_return-number = '006'.
        ELSEIF lv_subrc EQ 3.
          IF 1 = 2.
                MESSAGE e007(CVI_PRECHK).
          ENDIF.
          ex_return-number = '007'.
        ENDIF.
        MESSAGE ID ex_return-id TYPE ex_return-type NUMBER ex_return-number INTO ex_return-message.
        RETURN.
      ENDIF.

    ENDWHILE.
    "If the object type is vendor/supplier.
      ELSEIF iv_objtype EQ if_cvi_prechk=>gc_objtype_vend.
    CLEAR lt_lifnr.
        "Select all vendor numbers and store in lt_lifnr.
        SELECT lifnr
           FROM lfa1
          INTO TABLE lt_lifnr
          WHERE lifnr IN ir_objid_range
           AND ktokk IN ir_cvgroup_range
           AND lifnr NOT IN ( SELECT vendor FROM cvi_vend_link where vendor IN ir_objid_range )
          ORDER BY lifnr.
        WHILE lt_lifnr IS NOT INITIAL.
          "Get set of records based on records per run (1,00,000)
          CLEAR lt_lfa1.
          CLEAR lt_lifnr_per_run.
          "Get the lifnr_per_run based on record count per run and delete the same from lt_lifnr.
          APPEND LINES OF lt_lifnr FROM 1 TO if_cvi_prechk=>record_per_run TO lt_lifnr_per_run.
          DELETE lt_lifnr FROM 1 TO if_cvi_prechk=>record_per_run.
          "Select the lfa1 fields only for records per run.
          SELECT
               lifnr adrnr brsch land1  txjcd stceg stcdt ktokk
               stcd1 stcd2 stcd3 stcd4 stcd5 stkzn stkzu regio
           FROM lfa1
            INTO CORRESPONDING FIELDS OF TABLE lt_lfa1
            FOR ALL ENTRIES IN lt_lifnr_per_run WHERE lifnr = lt_lifnr_per_run-table_line.
          LOOP AT lt_lfa1 ASSIGNING <lf_lfa1>.
            CLEAR ls_ppf_chk_data.
            MOVE-CORRESPONDING <lf_lfa1> TO ls_ppf_chk_data.
            ls_ppf_chk_data-cvnum = <lf_lfa1>-lifnr.
            ls_ppf_chk_data-acc_group = <lf_lfa1>-ktokk.
        APPEND ls_ppf_chk_data TO ls_ppf_param-chk_data.
      ENDLOOP.

      GET REFERENCE OF ls_ppf_param INTO lr_ppf_param.

          TEST-SEAM spta_call_vendor.
            CALL FUNCTION 'SPTA_PARA_PROCESS_START_2'
        EXPORTING
          server_group             = iv_server_group
          before_rfc_callback_form = 'BEFORE_RFC'
          in_rfc_callback_form     = 'IN_RFC'
          after_rfc_callback_form  = 'AFTER_RFC'
              callback_prog            = 'CVI_MIGRATION_PRECHK'
        CHANGING
          user_param               = lr_ppf_param
        EXCEPTIONS
          invalid_server_group     = 1
          no_resources_available   = 2
          OTHERS                   = 3.
      lv_subrc = sy-subrc.
          END-TEST-SEAM.
      IF lv_subrc NE 0.
        CLEAR ex_return.
        ex_return-type = 'E'.
            ex_return-id = if_cvi_prechk=>GC_MESSAGE_CLASS.
        IF lv_subrc EQ 1.
          IF 1 = 2.
                MESSAGE e005(CVI_PRECHK).
          ENDIF.
          ex_return-number = '005'.
        ELSEIF lv_subrc EQ 2.
          IF 1 = 2.
                MESSAGE e006(CVI_PRECHK).
          ENDIF.
          ex_return-number = '006'.
        ELSEIF lv_subrc EQ 3.
          IF 1 = 2.
                MESSAGE e007(CVI_PRECHK).
          ENDIF.
          ex_return-number = '007'.
        ENDIF.
        MESSAGE ID ex_return-id TYPE ex_return-type NUMBER ex_return-number INTO ex_return-message.
        RETURN.
      ENDIF.
    ENDWHILE.
      ENDIF.
    CATCH cx_sy_open_sql_db.
      IF 1 = 2.
        MESSAGE e008(CVI_PRECHK).
      ENDIF.
      CLEAR ex_return.
      ex_return-type = 'E'.
      ex_return-id = if_cvi_prechk=>GC_MESSAGE_CLASS.
      ex_return-number = '008'.
      MESSAGE ID ex_return-id TYPE ex_return-type NUMBER ex_return-number INTO ex_return-message.
      RETURN.
  ENDTRY.


ENDFUNCTION.
