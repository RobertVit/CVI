class CRM_IF_CMD_EOP_CHECK definition
  public
  create public .

public section.

  interfaces CVP_IF_CONST_DCPLD_I1 .
  interfaces CVP_IF_APPL_EOP_CHECK .
  interfaces CVP_IF_CONSTANTS .

  data GV_EOP_RUN_MODE type CVP_EOP_RUN_MODE .
  data GV_TEST_MODE type CVP_TEST_MODE .
  data GV_DETAIL_LOG type CVP_DETAIL_LOG .
  data GV_VALIDATE_NXTCHK_DATE type CVP_VALIDATE_NXTCHK_DATE .
  data GV_CHECK_PUR_COMPL_STATUS type CVP_CHECK_PUR_COMPL_STATUS .
  data GV_PROT_OUTPUT type CVP_PROT_OUTPUT .
  data GV_PUR_CMPLT_PARTNERS_FINAL type BU_BUTSORT_MAINT_T .
  data LC_X type CHAR1 value 'X' ##NO_TEXT.
  data LC_SPACE type CHAR1 value ' ' ##NO_TEXT.
  constants TASK_FINAL_SET type CHAR9 value 'FINAL_SET' ##NO_TEXT.
protected section.
private section.

  data GV_CRM_CONNECTED type BOOLE_D .
ENDCLASS.



CLASS CRM_IF_CMD_EOP_CHECK IMPLEMENTATION.


  method CVP_IF_APPL_EOP_CHECK~CHECK_CPD_PARTNERS.
  endmethod.


  METHOD cvp_if_appl_eop_check~check_partners.

    CONSTANTS:
              lc_fm    TYPE  rs38l_fnam VALUE 'BUPA_PREPARE_EOP_BLOCK_WF'.
*&---- Structure declaration
    TYPES :
      BEGIN OF ty_kunnr,    " To store customer and respective GUID
        custome_no TYPE kunnr,
        partn_guid TYPE bu_partner_guid,
      END OF ty_kunnr,

      BEGIN OF ty_co_kunnr, " To store Contact Person and respective GUID
        contact_no TYPE kunnr,
        org_guid   TYPE bu_partner_guid,
        person_gui TYPE bu_partner_guid,
      END OF ty_co_kunnr,

      BEGIN OF ty_cp_kunnr,
        contact_no TYPE parnr,
      END OF ty_cp_kunnr.

*&---- Variable declaration
    DATA: lr_cvi_ctrl_loop            TYPE REF TO cvi_ctrl_loop,
          lt_crmkunnr                 TYPE TABLE OF crmkunnr,
          lt_kunnr                    TYPE TABLE OF ty_kunnr,
          lt_co_kunnr                 TYPE TABLE OF ty_co_kunnr,
          lt_crmparnr                 TYPE TABLE OF crmparnr,
          lt_dcrmparnr                TYPE TABLE OF crmparnr,
          lt_regsys                   TYPE STANDARD TABLE OF butregsys_remote,
          lt_crmlifnr                 TYPE crmlifnr_t,
          ls_regsys                   TYPE  butregsys_remote,
          lt_partner                  TYPE bup_partner_guid_t,
          lt_partner_guid_remote      TYPE bup_partner_guid_t,
          lt_partners                 TYPE bu_partner_t,
          lt_partner_guid             TYPE bup_partnerguid_t,
          ls_partner_guid             TYPE bup_partnerguid_s,
          ls_crmparnr                 TYPE crmparnr,
          lt_eop_check_partners       TYPE cvp_tt_eop_check_partners,
          lt_sort_result              TYPE cvp_tt_sort_result,
          ls_sort_result              TYPE cvp_s_sort_result,
          ls_crmkunnr                 TYPE crmkunnr,
          ls_crmlifnr                 TYPE crmlifnr,
          ls_kunnr                    TYPE ty_kunnr,
          ls_co_kunnr                 TYPE ty_co_kunnr,
          ls_partner                  TYPE bupa_partner_guid,
          ls_partner_guid_remote      TYPE bupa_partner_guid,
          lv_intrim                   TYPE char1,
          lv_ovrall                   TYPE char1,
          lv_detlog                   TYPE char1,
          lv_applog                   TYPE char1,
          lv_tesrun                   TYPE char1,
          lt_bal_msg                  TYPE ty_t_bal_msg,
          ls_eop_check_partners       TYPE cvp_s_eop_check_partners,
          ls_eop_check_partners1      TYPE cvp_s_eop_check_partners,
          ls_sort_result_partners     TYPE cvp_s_sort_result,
          lt_pur_cmplt_partners_final TYPE bu_butsort_maint_t,
          ls_pur_cmplt_partners_final TYPE bubutsort_maint,
          lv_relevant                 TYPE boole_d,
          lv_partner_guid             TYPE raw16,
          ls_crmrfcpar                TYPE crmrfcpar,
          lt_eop_check_partners_cpd   TYPE  cvp_tt_eop_check_partners_cpd,
          lt_message                  TYPE cvp_tt_eop_check_messages,
          ls_message                  TYPE cvp_s_eop_check_messages,
          lt_cvi_messages             TYPE  buslocalmsg_t,
          ls_cvi_messages             TYPE  buslocalmsg,
          ls_bapiret2                 TYPE  bapiret2,
          lv_guid                     TYPE  guid_16,
          lt_cp_kunnr                 TYPE TABLE OF ty_cp_kunnr,
          ls_cp_kunnr                 TYPE ty_cp_kunnr. "

    DATA: lv_own_logical_system       TYPE tbdls-logsys.

* Only if the CRM system is connected to this ECC system, then continue further processing in the class!
  CHECK gv_crm_connected IS NOT INITIAL.

****&---- Checking EOP check done for BP to CUSTOMER or not.
    CALL FUNCTION 'CRM_IF_BUPA_GUID_GET'
      IMPORTING
        ex_guid = lv_guid.

    CALL METHOD crm_if_loops_ctrl=>check_steps
      EXPORTING
        iv_source_object = 'CUSTOMER'
        iv_target_object = 'BP'
        iv_guid          = lv_guid
      IMPORTING
        ev_relevant      = lv_relevant
*       es_error         =
      .

*&---- EOP check not done for BP to CUSTOMER
    IF lv_relevant = 'X' AND  it_eop_check_partners IS NOT INITIAL.

*&---- Getting Business Partner linked to Customer
      SELECT * FROM crmkunnr
        INTO TABLE lt_crmkunnr
        FOR ALL ENTRIES IN it_eop_check_partners
        WHERE custome_no = it_eop_check_partners-id.
      IF sy-subrc = 0.
**** Converting GUID to make compatible with BUT000
        LOOP AT lt_crmkunnr INTO ls_crmkunnr.
          lv_partner_guid = cl_ibase_service=>cl_convert_guid_32_16( ls_crmkunnr-partn_guid ).
          MOVE lv_partner_guid TO ls_kunnr-partn_guid.
          ls_kunnr-custome_no = ls_crmkunnr-custome_no.
          APPEND ls_kunnr TO lt_kunnr.

          MOVE lv_partner_guid TO ls_partner_guid-partner_guid.
          APPEND ls_partner_guid TO lt_partner_guid.

          MOVE ls_crmkunnr-partn_guid TO ls_partner-partner_guid.
          APPEND ls_partner TO lt_partner.
          CLEAR ls_partner.
          CLEAR: ls_partner_guid, ls_kunnr, ls_crmkunnr.
        ENDLOOP.

**** Getting Contact Person related to BP of Respective Customer.
        SELECT * FROM crmparnr
          INTO TABLE lt_crmparnr
          FOR ALL ENTRIES IN lt_crmkunnr
          WHERE org_guid = lt_crmkunnr-partn_guid.
        IF sy-subrc = 0.
**** Converting GUID to make compatible with BUT000
          LOOP AT lt_crmparnr INTO ls_crmparnr.
            lv_partner_guid = cl_ibase_service=>cl_convert_guid_32_16( ls_crmparnr-person_gui ).
            MOVE lv_partner_guid TO ls_co_kunnr-person_gui.
            ls_co_kunnr-contact_no = ls_crmkunnr-custome_no.
            APPEND ls_co_kunnr TO lt_co_kunnr.

            MOVE ls_crmparnr-person_gui TO ls_partner_guid-partner_guid.
            APPEND ls_partner_guid TO lt_partner_guid.

            MOVE ls_crmparnr-person_gui TO ls_partner-partner_guid.
            APPEND ls_partner TO lt_partner.
            CLEAR ls_partner.
            CLEAR: ls_partner_guid, ls_co_kunnr, ls_crmparnr.
          ENDLOOP.
        ENDIF.
      ENDIF.

*&---- Conversion from Char to NUMC
      LOOP AT it_eop_check_partners INTO ls_eop_check_partners1.
        CALL FUNCTION 'CHAR_NUMC_CONVERSION'
          EXPORTING
            input   = ls_eop_check_partners1-id
          IMPORTING
            numcstr = ls_cp_kunnr-contact_no.

        APPEND ls_cp_kunnr TO lt_cp_kunnr.
        CLEAR: ls_eop_check_partners, ls_cp_kunnr.
      ENDLOOP.

*&---- Getting Business Partners of Contact Person
      SELECT * FROM crmparnr
        INTO TABLE lt_dcrmparnr
        FOR ALL ENTRIES IN lt_cp_kunnr
        WHERE contact_no = lt_cp_kunnr-contact_no.
      IF sy-subrc = 0.

**** Converting GUID to make compatible with BUT000
        LOOP AT lt_dcrmparnr INTO ls_crmparnr.
          lv_partner_guid = cl_ibase_service=>cl_convert_guid_32_16( ls_crmparnr-person_gui ).
          MOVE lv_partner_guid TO ls_co_kunnr-person_gui.
          ls_co_kunnr-contact_no = ls_crmkunnr-custome_no.
          APPEND ls_co_kunnr TO lt_co_kunnr.

          MOVE ls_crmparnr-person_gui TO ls_partner_guid-partner_guid.
          APPEND ls_partner_guid TO lt_partner_guid.

          MOVE ls_crmparnr-person_gui TO ls_partner-partner_guid.
          APPEND ls_partner TO lt_partner.
          CLEAR ls_partner.
          CLEAR: ls_partner_guid, ls_co_kunnr, ls_crmparnr.
        ENDLOOP.
      ENDIF.

*&---- No BP releted to CUSTOMER or Contact Person found
      IF lt_crmkunnr IS INITIAL AND lt_dcrmparnr IS INITIAL.
*&--- Getting own logical system
        CALL FUNCTION 'OWN_LOGICAL_SYSTEM_GET'
          IMPORTING
            own_logical_system             = lv_own_logical_system   " Name of own logical system
          EXCEPTIONS
            own_logical_system_not_defined = 1
            OTHERS                         = 2.
        IF sy-subrc <> 0.
*         MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        ENDIF.

        LOOP AT it_eop_check_partners INTO ls_eop_check_partners.
          ls_sort_result_partners-id = ls_eop_check_partners-id.
          ls_sort_result_partners-id_type = ls_eop_check_partners-id_type.
          ls_sort_result_partners-bukrs = ls_eop_check_partners-bukrs.
          ls_sort_result_partners-vkorg =  ls_eop_check_partners-vkorg.
          IF iv_appl IS NOT INITIAL.
            ls_sort_result_partners-appl_name = iv_appl.
          ELSE.
            ls_sort_result_partners-appl_name = 'CRM_IF'.
          ENDIF.
          ls_sort_result_partners-business_system = lv_own_logical_system.
          ls_sort_result_partners-pur_cmpl_status = '1'.
          APPEND ls_sort_result_partners TO et_sort_result_partners.
          CLEAR ls_sort_result_partners.
          CLEAR ls_eop_check_partners.
        ENDLOOP.

        EXIT.
      ENDIF.

      CLEAR: lv_relevant.

*****&---- Checking EOP check done for BP to VENDOR or not.
*      CALL METHOD crm_if_loops_ctrl=>check_steps
*        EXPORTING
*          iv_source_object = 'BP'
*          iv_target_object = 'VENDOR'
*          iv_guid          = lv_guid
*        IMPORTING
*          ev_relevant      = lv_relevant
**         es_error         =
*        .
*      IF lt_crmkunnr IS NOT INITIAL.
***** Getting Vendor related to BP of Respective Customer.
*        SELECT vendor_no partn_guid FROM crmlifnr
*                                    INTO TABLE lt_crmlifnr
*                                    FOR ALL ENTRIES IN lt_crmkunnr
*                                    WHERE partn_guid = lt_crmkunnr-partn_guid.
*        IF sy-subrc = 0 AND lv_relevant = 'X'.
*****        LOOP AT lt_crmlifnr INTO ls_crmlifnr.
*****          ls_eop_check_partners-id = ls_crmlifnr-vendor_no.
*****          ls_eop_check_partners-id_type = '2'.
*****          APPEND ls_eop_check_partners TO lt_eop_check_partners.
*****          CLEAR: ls_crmlifnr, ls_eop_check_partners.
*****        ENDLOOP.
*          LOOP AT lt_crmlifnr INTO ls_crmlifnr.
*            MOVE ls_crmlifnr-partn_guid TO ls_partner-partner_guid.
*            APPEND ls_partner TO lt_partner.
*            CLEAR ls_partner.
*          ENDLOOP.
*
*          DELETE ADJACENT DUPLICATES FROM lt_partner.
***** Partners checks before calling CVP_PREPARE_EOP_BLOCK
*          CALL FUNCTION 'CVP_PREPARE_EOP_CHECK'
*            EXPORTING
*              it_crmlifnr              = lt_crmlifnr
*            IMPORTING
*              et_vend_eop_partners     = lt_eop_check_partners
*              et_vend_eop_partners_cpd = lt_eop_check_partners_cpd.
***** Fetching Vendor EOP check result.
*          CALL FUNCTION 'CVP_PREPARE_EOP_BLOCK' DESTINATION 'NONE'
*            EXPORTING
*              iv_eop_run_mode           = gv_eop_run_mode
*              iv_test_mode              = gv_test_mode
*              iv_validate_nxtchk_date   = gv_validate_nxtchk_date
*              iv_check_pur_compl_status = gv_check_pur_compl_status
*              iv_prot_output            = gv_prot_output
*              iv_detail_log             = gv_detail_log
*              it_eop_check_partners     = lt_eop_check_partners
*              it_eop_check_partners_cpd = lt_eop_check_partners_cpd
*            IMPORTING
*              et_sort_result_partners   = lt_sort_result
*              et_messages               = lt_message
**             EV_APPLOG_NUMBER          =
*            .
*          IF sy-subrc = 0.
*            CLEAR: ls_crmlifnr, ls_crmkunnr.
*            LOOP AT lt_sort_result INTO ls_sort_result.
*
*              READ TABLE lt_crmlifnr
*              INTO ls_crmlifnr
*              WITH KEY  vendor_no = ls_sort_result-id.
*              IF sy-subrc = 0.
*                READ TABLE lt_crmkunnr
*                INTO ls_crmkunnr
*                WITH KEY partn_guid = ls_crmlifnr-partn_guid.
*                IF sy-subrc = 0.
*                  ls_sort_result_partners-id                = ls_crmkunnr-custome_no.
*                  ls_sort_result_partners-id_type           = ls_sort_result-id_type.
*                  ls_sort_result_partners-bukrs             = ls_sort_result-bukrs.
*                  ls_sort_result_partners-vkorg             = ls_sort_result-vkorg.
*                  ls_sort_result_partners-business_system   = ls_sort_result-business_system.
*                  ls_sort_result_partners-appl_name         = ls_sort_result-appl_name.
*                  ls_sort_result_partners-appl_rule_variant = ls_sort_result-appl_rule_variant.
*                  ls_sort_result_partners-st_ret_date       = ls_sort_result-st_ret_date.
*                  ls_sort_result_partners-nextchkdt         = ls_sort_result-nextchkdt.
*                  ls_sort_result_partners-pur_cmpl_status   = ls_sort_result-pur_cmpl_status.
*                  APPEND ls_sort_result_partners TO et_sort_result_partners.
*                  CLEAR: ls_sort_result_partners, ls_crmlifnr, ls_crmkunnr, ls_sort_result.
*                ENDIF.
*              ENDIF.
*            ENDLOOP.
*          ENDIF.
*        ENDIF."End of Vendor EOP Check.
*      ENDIF.
**&---- Getting Business partner number with respect to BP GUID
*      SELECT partner partner_guid FROM but000
*        INTO TABLE lt_partner
*        FOR ALL ENTRIES IN lt_partner_guid
*        WHERE partner_guid = lt_partner_guid-partner_guid.
*      IF sy-subrc = 0.

**** Set the mode
      IF gv_eop_run_mode = '1'.
        lv_intrim = 'X'.
      ELSEIF gv_eop_run_mode = '2'.
        lv_ovrall = 'X'.
      ENDIF.

      IF gv_detail_log = '1'.
        lv_detlog = ' '.
      ELSEIF gv_detail_log = 'X'.
        lv_detlog = 'X'.
      ENDIF.

      IF gv_prot_output = ' '.
        lv_applog = ' '.
      ELSEIF gv_prot_output = '1'.
        lv_applog = 'X'.
      ELSEIF gv_prot_output = '2'.
        lv_applog = 'X'.
      ENDIF.


      lt_partners = lt_partner.

*&---- Getting RFC information
      CALL FUNCTION 'BUPA_EOP_REGSYS'
        EXPORTING
          IV_REPL_TYPE       = 'CV->BP'
        TABLES
          et_eopsys = lt_regsys.

**** Call FM in all remote system
      LOOP AT lt_regsys INTO ls_regsys WHERE rfcdes IS NOT INITIAL.
**** Check whether FM exist in remot system or not.
        CALL FUNCTION 'FUNCTION_EXISTS' DESTINATION ls_regsys-rfcdes
          EXPORTING
            funcname           = lc_fm
          EXCEPTIONS
            function_not_exist = 1
            OTHERS             = 2.

        IF sy-subrc = 0 AND gv_eop_run_mode = '2'.

*&---- Blocking the business partner
          CALL FUNCTION lc_fm DESTINATION ls_regsys-rfcdes
            EXPORTING
*             i_partnr                   = lt_partners
*             I_FILTER                   =
              i_intrim                   = lv_intrim
              i_ovrall                   = lv_ovrall
              i_chkdat                   = gv_validate_nxtchk_date
*             I_INTRES                   =
              i_applog                   = lv_applog
              i_detlog                   = lv_detlog
              i_tesrun                   = gv_test_mode
              i_chkeop                   = gv_check_pur_compl_status
*             I_BLOCKS                   =
              i_guid                     = lv_guid
              i_partner_guid             = lt_partner
            IMPORTING
              e_partner_guid             = lt_partner_guid_remote
              e_bal_msg                  = lt_bal_msg
              e_pur_cmplt_partners_final = lt_pur_cmplt_partners_final
              e_cvi_messages             = lt_cvi_messages.
          IF sy-subrc = 0.
**** Adding the Customer detail of the contact person
            LOOP AT lt_dcrmparnr INTO ls_crmparnr.
              CLEAR: ls_kunnr.
              ls_kunnr-partn_guid = ls_crmparnr-person_gui.
              ls_kunnr-custome_no = ls_crmparnr-contact_no.
              APPEND ls_kunnr TO lt_kunnr.
            ENDLOOP.
*&---- Mapping SORT result to exporting Parameter.
            LOOP AT lt_pur_cmplt_partners_final INTO ls_pur_cmplt_partners_final.

*&---- Read GUID of respective BP
              READ TABLE lt_partner_guid_remote
                   INTO  ls_partner_guid_remote
                   WITH KEY partner = ls_pur_cmplt_partners_final-partner.
*&---- Reading customer with respect to GUID.
              READ TABLE lt_kunnr
                   INTO ls_kunnr
                   WITH KEY partn_guid = ls_partner_guid_remote-partner_guid.
              IF sy-subrc = 0.
*                READ TABLE it_eop_check_partners
*                  INTO ls_eop_check_partners
*                  WITH KEY id = ls_kunnr-custome_no.
                LOOP AT it_eop_check_partners INTO ls_eop_check_partners WHERE id = ls_kunnr-custome_no.
                  ls_sort_result_partners-id                = ls_eop_check_partners-id.
                  ls_sort_result_partners-id_type           = ls_eop_check_partners-id_type.
                  ls_sort_result_partners-bukrs             = ls_eop_check_partners-bukrs.
                  ls_sort_result_partners-vkorg             = ls_eop_check_partners-vkorg.
                  ls_sort_result_partners-business_system   = ls_pur_cmplt_partners_final-business_system.
                  ls_sort_result_partners-appl_name         = ls_pur_cmplt_partners_final-appl_name.
                  ls_sort_result_partners-appl_rule_variant = ls_pur_cmplt_partners_final-appl_rule_variant.
                  ls_sort_result_partners-st_ret_date       = ls_pur_cmplt_partners_final-st_ret_date.
                  ls_sort_result_partners-nextchkdt         = ls_pur_cmplt_partners_final-nextchkdt.
                  ls_sort_result_partners-pur_cmpl_status   = ls_pur_cmplt_partners_final-pur_cmpl_status.
                  APPEND ls_sort_result_partners TO et_sort_result_partners.
                ENDLOOP.
                  CLEAR: ls_sort_result_partners, ls_eop_check_partners, ls_pur_cmplt_partners_final.
                  CLEAR: ls_partner_guid_remote, ls_crmkunnr.
              ELSE.
*&---- Read contact person GUID with respect to BP
                READ TABLE lt_co_kunnr
                  INTO ls_co_kunnr
                  WITH KEY person_gui = ls_partner_guid_remote-partner_guid.
*&---- Read customer GUID with respect to contact person GUID
                READ TABLE lt_kunnr
                INTO ls_kunnr
                WITH KEY partn_guid = ls_co_kunnr-org_guid.
*&--- Read importing data of the customer.
*                READ TABLE it_eop_check_partners
*                  INTO ls_eop_check_partners
*                  WITH KEY id = ls_kunnr-custome_no.
                LOOP AT it_eop_check_partners INTO ls_eop_check_partners WHERE id = ls_kunnr-custome_no.
                ls_sort_result_partners-id                = ls_eop_check_partners-id.
                ls_sort_result_partners-id_type           = ls_eop_check_partners-id_type.
                ls_sort_result_partners-bukrs             = ls_eop_check_partners-bukrs.
                ls_sort_result_partners-vkorg             = ls_eop_check_partners-vkorg.
                ls_sort_result_partners-business_system   = ls_pur_cmplt_partners_final-business_system.
                ls_sort_result_partners-appl_name         = ls_pur_cmplt_partners_final-appl_name.
                ls_sort_result_partners-appl_rule_variant = ls_pur_cmplt_partners_final-appl_rule_variant.
                ls_sort_result_partners-st_ret_date       = ls_pur_cmplt_partners_final-st_ret_date.
                ls_sort_result_partners-nextchkdt         = ls_pur_cmplt_partners_final-nextchkdt.
                ls_sort_result_partners-pur_cmpl_status   = ls_pur_cmplt_partners_final-pur_cmpl_status.
                APPEND ls_sort_result_partners TO et_sort_result_partners.
                ENDLOOP.
                CLEAR: ls_sort_result_partners, ls_eop_check_partners, ls_pur_cmplt_partners_final.
                CLEAR: ls_partner_guid_remote, ls_co_kunnr, ls_kunnr.
              ENDIF.
            ENDLOOP.

*&---- Mapping message to output.
            LOOP AT lt_cvi_messages INTO ls_cvi_messages.
*&---- Read GUID of respective BP
              READ TABLE lt_partner_guid_remote
                   INTO  ls_partner_guid_remote
                   WITH KEY partner = ls_cvi_messages-partnerid.
*&---- Reading customer with respect to GUID.
              READ TABLE lt_kunnr
                   INTO ls_kunnr
                   WITH KEY partn_guid = ls_partner_guid_remote-partner_guid.
              IF sy-subrc = 0.
                READ TABLE it_eop_check_partners
                  INTO ls_eop_check_partners
                  WITH KEY id = ls_kunnr-custome_no.
                ls_message-appl_name = ls_cvi_messages-appl_name.
                ls_message-appl_rule_variant = ls_cvi_messages-appl_rule_variant.
                ls_message-bukrs = ls_eop_check_partners-bukrs.
                ls_message-id = ls_eop_check_partners-id.
                ls_message-id_type = ls_eop_check_partners-id_type.
                ls_message-vkorg = ls_eop_check_partners-vkorg.
                MOVE-CORRESPONDING  ls_cvi_messages TO ls_bapiret2.
                APPEND ls_bapiret2 TO ls_message-messages.
                APPEND ls_message TO lt_message.
                CLEAR: ls_message, ls_eop_check_partners, ls_kunnr, ls_partner_guid_remote, ls_cvi_messages.
              ELSE.
*&---- Read contact person GUID with respect to BP
                READ TABLE lt_co_kunnr
                  INTO ls_co_kunnr
                  WITH KEY person_gui = ls_partner_guid_remote-partner_guid.
*&---- Read customer GUID with respect to contact person GUID
                READ TABLE lt_kunnr
                INTO ls_kunnr
                WITH KEY partn_guid = ls_co_kunnr-org_guid.
*&--- Read importing data of the customer.
                READ TABLE it_eop_check_partners
                  INTO ls_eop_check_partners
                  WITH KEY id = ls_kunnr-custome_no.
                ls_message-appl_name = ls_cvi_messages-appl_name.
                ls_message-appl_rule_variant = ls_cvi_messages-appl_rule_variant.
                ls_message-bukrs = ls_eop_check_partners-bukrs.
                ls_message-id = ls_eop_check_partners-id.
                ls_message-id_type = ls_eop_check_partners-id_type.
                ls_message-vkorg = ls_eop_check_partners-vkorg.
                MOVE-CORRESPONDING  ls_cvi_messages TO ls_bapiret2.
                APPEND ls_bapiret2 TO ls_message-messages.
                APPEND ls_message TO lt_message.
                CLEAR: ls_message, ls_eop_check_partners, ls_kunnr, ls_partner_guid_remote, ls_cvi_messages,ls_co_kunnr.
              ENDIF.
            ENDLOOP.
            APPEND LINES OF lt_message TO et_messages.
          ENDIF.
        ENDIF.
      ENDLOOP.
*      ENDIF.

*&---- Few CUSTOMER for which No BP are there
      LOOP AT it_eop_check_partners INTO ls_eop_check_partners.
        READ TABLE lt_kunnr
             INTO ls_kunnr
             WITH KEY  custome_no = ls_eop_check_partners-id.
        IF sy-subrc <> 0.
*&--- Getting own logical system
          CALL FUNCTION 'OWN_LOGICAL_SYSTEM_GET'
            IMPORTING
              own_logical_system             = lv_own_logical_system   " Name of own logical system
            EXCEPTIONS
              own_logical_system_not_defined = 1
              OTHERS                         = 2.
          IF sy-subrc <> 0.
*         MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
          ENDIF.
          ls_sort_result_partners-id      = ls_eop_check_partners-id.
          ls_sort_result_partners-id_type = ls_eop_check_partners-id_type.
          ls_sort_result_partners-bukrs   = ls_eop_check_partners-bukrs.
          ls_sort_result_partners-vkorg   = ls_eop_check_partners-vkorg.
          IF iv_appl IS NOT INITIAL.
            ls_sort_result_partners-appl_name = iv_appl.
          ELSE.
            ls_sort_result_partners-appl_name = 'CRM_IF'.
          ENDIF.
          ls_sort_result_partners-business_system = lv_own_logical_system.
          ls_sort_result_partners-pur_cmpl_status = '1'.
          APPEND ls_sort_result_partners TO et_sort_result_partners.
          CLEAR ls_sort_result_partners.
          CLEAR ls_eop_check_partners.
        ENDIF.

      ENDLOOP.
    ENDIF.
  ENDMETHOD.


  method CVP_IF_APPL_EOP_CHECK~FINALIZE.
  endmethod.


  method CVP_IF_APPL_EOP_CHECK~FINALIZE_UNBLOCK.
  endmethod.


  METHOD CVP_IF_APPL_EOP_CHECK~INITIALIZE.
  DATA ls_crmconsum TYPE crmconsum.
*&---- Global variable declarations
    gv_eop_run_mode = iv_eop_run_mode.
    gv_test_mode = iv_test_mode.
    gv_detail_log = iv_detail_log.
    gv_validate_nxtchk_date = iv_validate_nxtchk_date.
    IF iv_check_pur_compl_status = 'X'.
      gv_check_pur_compl_status = ' '.
    ELSE.
     gv_check_pur_compl_status = 'X'.
    ENDIF.
    gv_prot_output = iv_prot_output.

*   Check if CRM is connected to this ECC system
    SELECT SINGLE * FROM crmconsum INTO ls_crmconsum WHERE consumer = 'CRM' AND aktiv = abap_true.
     IF sy-subrc = 0.
       gv_crm_connected = abap_true.
     ELSE.
       gv_crm_connected = abap_false.
     ENDIF.

  ENDMETHOD.


  method CVP_IF_APPL_EOP_CHECK~INITIALIZE_UNBLOCK.
   DATA ls_crmconsum TYPE crmconsum.
*&---- Global variable declarations
    gv_test_mode = iv_test_mode.
    gv_detail_log = iv_detail_log.
    gv_prot_output = iv_prot_output.

*   Check if CRM is connected to this ECC system
    SELECT SINGLE * FROM crmconsum INTO ls_crmconsum WHERE consumer = 'CRM' AND aktiv = abap_true.
     IF sy-subrc = 0.
       gv_crm_connected = abap_true.
     ELSE.
       gv_crm_connected = abap_false.
     ENDIF.

  endmethod.


  METHOD cvp_if_appl_eop_check~partners_prep_purcmpl_reset.

    CONSTANTS:
              lc_fm    TYPE  rs38l_fnam VALUE 'BUPA_PREPARE_EOP_UNBLOCK_WF'.
*&---- Structure declaration
    TYPES :
      BEGIN OF ty_kunnr,    " To store customer and respective GUID
        custome_no TYPE kunnr,
        partn_guid TYPE bu_partner_guid,
      END OF ty_kunnr,

      BEGIN OF ty_co_kunnr, " To store Contact Person and respective GUID
        contact_no TYPE kunnr,
        org_guid   TYPE bu_partner_guid,
        person_gui TYPE bu_partner_guid,
      END OF ty_co_kunnr.

*&---- Variable declaration
    DATA: lr_cvi_ctrl_loop            TYPE REF TO cvi_ctrl_loop,
          lt_crmkunnr                 TYPE TABLE OF crmkunnr,
          lt_crmlifnr                 TYPE TABLE OF crmlifnr,
          lt_kunnr                    TYPE TABLE OF ty_kunnr,
          lt_co_kunnr                 TYPE TABLE OF ty_co_kunnr,
          lt_crmparnr                 TYPE TABLE OF crmparnr,
          lt_regsys                   TYPE STANDARD TABLE OF butregsys_remote,
          lt_partner_guid_remote      TYPE bup_partner_guid_t,
          ls_partner_guid_remote      TYPE bupa_partner_guid,
          ls_regsys                   TYPE  butregsys_remote,
          lt_partner                  TYPE bup_partner_guid_t,
          lt_partners                 TYPE bu_partner_t,
          lt_partner_guid             TYPE bup_partnerguid_t,
          ls_partner_guid             TYPE bup_partnerguid_s,
          ls_crmparnr                 TYPE crmparnr,
          lt_sort_result              TYPE cvp_tt_sort_result,
          ls_sort_result              TYPE cvp_s_sort_result,
          ls_crmkunnr                 TYPE crmkunnr,
          ls_crmlifnr                 TYPE crmlifnr,
          ls_kunnr                    TYPE ty_kunnr,
          ls_co_kunnr                 TYPE ty_co_kunnr,
          ls_partner                  TYPE bupa_partner_guid,
          lv_intrim                   TYPE char1,
          lv_ovrall                   TYPE char1,
          lv_detlog                   TYPE char1,
          lv_tesrun                   TYPE char1,
          lt_bal_msg                  TYPE ty_t_bal_msg,
          ls_eop_check_partners       TYPE cvp_s_eop_partner_purcmpl_exp,
          lt_unblk_check_vendor       TYPE cvp_tt_unblock_status,
          ls_unblk_check_vendor       TYPE cvp_s_unblock_status,
          lt_unblock_partners_final   TYPE cvp_tt_unblock_status,
          ls_unblock_partners_final   TYPE cvp_s_unblock_status,
          ls_sort_result_partners     TYPE cvp_s_unblock_status,
          ls_unblk_partner            TYPE cvp_s_unblock_status,
          lt_pur_cmplt_partners_final TYPE bupartner_unblk_statusremote_t,
          ls_pur_cmplt_partners_final TYPE bupartner_unblk_status_remote,
          lv_relevant                 TYPE boole_d,
          lv_partner_guid             TYPE raw16,
          ls_crmrfcpar                TYPE crmrfcpar,
          lt_eop_check_partners_cpd   TYPE  cvp_tt_eop_check_partners_cpd,
          lt_message                  TYPE cvp_tt_eop_check_messages,
          ls_message                  TYPE cvp_s_eop_check_messages,
          lt_messages                 TYPE cvp_tt_eop_check_messages,
          ls_messages                 TYPE cvp_s_eop_check_messages,
          lt_cvi_messages             TYPE  buslocalmsg_t,
          ls_cvi_messages             TYPE  buslocalmsg,
          ls_bapiret2                 TYPE  bapiret2,
          lv_guid                     TYPE  guid_16.

*   Only if the CRM system is connected to this ECC system, then continue further processing in the class!
    CHECK gv_crm_connected IS NOT INITIAL.

****&---- Checking EOP check done for BP to CUSTOMER or not.
    CALL FUNCTION 'CRM_IF_BUPA_GUID_GET'
      IMPORTING
        ex_guid = lv_guid.

    CALL METHOD crm_if_loops_ctrl=>check_steps
      EXPORTING
        iv_source_object = 'CUSTOMER'
        iv_target_object = 'BP'
        iv_guid          = lv_guid
      IMPORTING
        ev_relevant      = lv_relevant
*       es_error         =
      .

*&---- EOP check not done for BP to CUSTOMER
    IF lv_relevant = 'X' AND  it_partners IS NOT INITIAL.

*&---- Getting Business Partner linked to Customer
      SELECT * FROM crmkunnr
        INTO TABLE lt_crmkunnr
        FOR ALL ENTRIES IN it_partners
        WHERE custome_no = it_partners-id.
      IF sy-subrc = 0.
**** Converting GUID to make compatible with BUT000
        LOOP AT lt_crmkunnr INTO ls_crmkunnr.
          lv_partner_guid = cl_ibase_service=>cl_convert_guid_32_16( ls_crmkunnr-partn_guid ).
          MOVE lv_partner_guid TO ls_kunnr-partn_guid.
          ls_kunnr-custome_no = ls_crmkunnr-custome_no.
          APPEND ls_kunnr TO lt_kunnr.

          MOVE lv_partner_guid TO ls_partner_guid-partner_guid.
          APPEND ls_partner_guid TO lt_partner_guid.
          CLEAR: ls_partner_guid, ls_kunnr, ls_crmkunnr.
        ENDLOOP.

**** Getting Contact Person related to BP of Respective Customer.
        SELECT * FROM crmparnr
          INTO TABLE lt_crmparnr
          FOR ALL ENTRIES IN lt_crmkunnr
          WHERE org_guid = lt_crmkunnr-partn_guid.
        IF sy-subrc = 0.
**** Converting GUID to make compatible with BUT000
          LOOP AT lt_crmparnr INTO ls_crmparnr.
            lv_partner_guid = cl_ibase_service=>cl_convert_guid_32_16( ls_crmparnr-person_gui ).
            MOVE lv_partner_guid TO ls_co_kunnr-person_gui.
            ls_co_kunnr-contact_no = ls_crmkunnr-custome_no.
            APPEND ls_co_kunnr TO lt_co_kunnr.

            MOVE ls_crmparnr-person_gui TO ls_partner_guid-partner_guid.
            APPEND ls_partner_guid TO lt_partner_guid.
            CLEAR: ls_partner_guid, ls_co_kunnr, ls_crmparnr.
          ENDLOOP.
        ENDIF.

        CLEAR: lv_relevant.
********&---- Checking EOP check done for BP to CUSTOMER or not.
****        CALL METHOD crm_if_loops_ctrl=>check_steps
****          EXPORTING
****            iv_source_object = 'BP'
****            iv_target_object = 'VENDOR'
****            iv_guid          = lv_guid
****          IMPORTING
****            ev_relevant      = lv_relevant
*****           es_error         =
****          .
******** Getting Vendor related to BP of Respective Customer.
****        SELECT vendor_no partn_guid FROM crmlifnr
****                                    INTO TABLE lt_crmlifnr
****                                    FOR ALL ENTRIES IN lt_crmkunnr
****                                    WHERE partn_guid = lt_crmkunnr-partn_guid.
****        IF sy-subrc = 0 AND lv_relevant = 'X'.
****          LOOP AT lt_crmlifnr INTO ls_crmlifnr.
****            ls_unblk_check_vendor-id = ls_crmlifnr-vendor_no.
****            ls_unblk_check_vendor-id_type = '2'.
****            APPEND ls_unblk_check_vendor TO lt_unblk_check_vendor.
****            CLEAR: ls_crmlifnr, ls_unblk_check_vendor.
****          ENDLOOP.
****
******** Fetching customer EOP check result.
****          CALL FUNCTION 'CVP_PROCESS_UNBLOCK'
****            EXPORTING
****              iv_test_mode                = gv_test_mode
****              iv_prot_output              = gv_prot_output
****              iv_detail_log               = gv_detail_log
****              it_unblock_partners         = lt_unblk_check_vendor
****            IMPORTING
****              et_unblock_partners_results = lt_unblock_partners_final
****              et_messages                 = lt_messages.
****
****          IF sy-subrc = 0.
****            CLEAR: ls_crmlifnr, ls_crmkunnr.
****            LOOP AT lt_unblock_partners_final INTO ls_unblock_partners_final.
****              READ TABLE lt_crmlifnr
****              INTO ls_crmlifnr
****              WITH KEY  vendor_no = ls_unblock_partners_final-id.
****              IF sy-subrc = 0.
****                READ TABLE lt_crmkunnr
****                INTO ls_crmkunnr
****                WITH KEY partn_guid = ls_crmlifnr-partn_guid.
****                IF sy-subrc = 0.
****                  ls_sort_result_partners-id                = ls_crmkunnr-custome_no.
****                  ls_sort_result_partners-id_type           = ls_unblock_partners_final-id_type.
****                  ls_sort_result_partners-bukrs             = ls_unblock_partners_final-bukrs.
****                  ls_sort_result_partners-vkorg             = ls_unblock_partners_final-vkorg.
****                  ls_sort_result_partners-status            = ls_unblock_partners_final-status.
****                  APPEND ls_sort_result_partners TO et_partners.
****                  CLEAR: ls_sort_result_partners, ls_crmlifnr, ls_crmkunnr,ls_unblock_partners_final.
****                ENDIF.
****              ENDIF.
****            ENDLOOP.
****          ENDIF.
****        ENDIF."End of Vendor EOP Check.

**&---- Getting Business partner number with respect to BP GUID
*        SELECT partner partner_guid FROM but000
*          INTO TABLE lt_partner
*          FOR ALL ENTRIES IN lt_partner_guid
*          WHERE partner_guid = lt_partner_guid-partner_guid.
*        IF sy-subrc = 0.
        MOVE-CORRESPONDING lt_partner_guid TO lt_partner.
        lt_partners = lt_partner.
*&---- Getting RFC information
        CALL FUNCTION 'BUPA_EOP_REGSYS'
          EXPORTING
            IV_REPL_TYPE       = 'CV->BP'
          TABLES
            et_eopsys = lt_regsys.

**** Call FM in all remote system
        LOOP AT lt_regsys INTO ls_regsys WHERE rfcdes IS NOT INITIAL.
**** Check whether FM exist in remot system or not.
          CALL FUNCTION 'FUNCTION_EXISTS' DESTINATION ls_regsys-rfcdes
            EXPORTING
              funcname           = lc_fm
            EXCEPTIONS
              function_not_exist = 1
              OTHERS             = 2.

          IF sy-subrc = 0.

*&---- Blocking the business partner
            CALL FUNCTION lc_fm DESTINATION ls_regsys-rfcdes
              EXPORTING
                i_partner         = lt_partners
                i_guid            = lv_guid
                i_partner_guid    = lt_partner
              IMPORTING
                e_partner_guid             = lt_partner_guid_remote
                e_partner_unblock = lt_pur_cmplt_partners_final
                e_cvi_messages    = lt_cvi_messages.
            IF sy-subrc = 0.

*&---- Mapping SORT result to exporting Parameter.
              LOOP AT lt_pur_cmplt_partners_final INTO ls_pur_cmplt_partners_final.

*&---- Read GUID of respective BP
                READ TABLE lt_partner_guid_remote
                     INTO  ls_partner_guid_remote
                     WITH KEY partner = ls_pur_cmplt_partners_final-partner.
*&---- Reading customer with respect to GUID.
                READ TABLE lt_kunnr
                     INTO ls_kunnr
                     WITH KEY partn_guid = ls_partner_guid_remote-partner_guid.
                IF sy-subrc = 0.
                  READ TABLE it_partners
                    INTO ls_eop_check_partners
                    WITH KEY id = ls_kunnr-custome_no.
                  IF sy-subrc = 0.
                    ls_unblk_partner-id                = ls_eop_check_partners-id.
                    ls_unblk_partner-id_type           = ls_eop_check_partners-id_type.
                    ls_unblk_partner-bukrs             = ls_eop_check_partners-bukrs.
                    ls_unblk_partner-vkorg             = ls_eop_check_partners-vkorg.
                    IF ls_pur_cmplt_partners_final-unblk_status = 'X' .
                      ls_unblk_partner-status = 'A'.
                    ELSE.
                      ls_unblk_partner-status = 'R'.
                    ENDIF.
                    APPEND ls_unblk_partner TO et_partners.
                    CLEAR: ls_sort_result_partners, ls_eop_check_partners, ls_pur_cmplt_partners_final.
                    CLEAR: ls_partner_guid_remote, ls_crmkunnr.
                  ENDIF.
                ELSE.
*&---- Read contact person GUID with respect to BP
                  READ TABLE lt_co_kunnr
                    INTO ls_co_kunnr
                    WITH KEY person_gui = ls_partner_guid_remote-partner_guid.
*&---- Read customer GUID with respect to contact person GUID
                  READ TABLE lt_kunnr
                  INTO ls_kunnr
                  WITH KEY partn_guid = ls_co_kunnr-org_guid.
*&--- Read importing data of the customer.
                  READ TABLE it_partners
                    INTO ls_eop_check_partners
                    WITH KEY id = ls_kunnr-custome_no.
                  ls_unblk_partner-id                = ls_eop_check_partners-id.
                  ls_unblk_partner-id_type           = ls_eop_check_partners-id_type.
                  ls_unblk_partner-bukrs             = ls_eop_check_partners-bukrs.
                  ls_unblk_partner-vkorg             = ls_eop_check_partners-vkorg.
                  IF ls_pur_cmplt_partners_final-unblk_status = 'X' .
                    ls_unblk_partner-status = 'A'.
                  ELSE.
                    ls_unblk_partner-status = 'R'.
                  ENDIF.
                  APPEND ls_unblk_partner TO et_partners.
                  CLEAR: ls_sort_result_partners, ls_eop_check_partners, ls_pur_cmplt_partners_final.
                  CLEAR: ls_partner_guid_remote, ls_co_kunnr, ls_kunnr.
                ENDIF.
              ENDLOOP.

*&---- Mapping message to output.
              LOOP AT lt_cvi_messages INTO ls_cvi_messages.
*&---- Read GUID of respective BP
                READ TABLE lt_partner_guid_remote
                     INTO  ls_partner_guid_remote
                     WITH KEY partner = ls_cvi_messages-partnerid.
*&---- Reading customer with respect to GUID.
                READ TABLE lt_kunnr
                     INTO ls_kunnr
                     WITH KEY partn_guid = ls_partner_guid_remote-partner_guid.
                IF sy-subrc = 0.
                  READ TABLE it_partners
                    INTO ls_eop_check_partners
                    WITH KEY id = ls_kunnr-custome_no.
                  ls_message-appl_name = ls_cvi_messages-appl_name.
                  ls_message-appl_rule_variant = ls_cvi_messages-appl_rule_variant.
                  ls_message-bukrs = ls_eop_check_partners-bukrs.
                  ls_message-id = ls_eop_check_partners-id.
                  ls_message-id_type = ls_eop_check_partners-id_type.
                  ls_message-vkorg = ls_eop_check_partners-vkorg.
                  MOVE-CORRESPONDING  ls_cvi_messages TO ls_bapiret2.
                  APPEND ls_bapiret2 TO ls_message-messages.
                  APPEND ls_message TO lt_message.
                  CLEAR: ls_message, ls_unblk_check_vendor, ls_kunnr, ls_partner_guid_remote, ls_cvi_messages.
                ELSE.
*&---- Read contact person GUID with respect to BP
                  READ TABLE lt_co_kunnr
                    INTO ls_co_kunnr
                    WITH KEY person_gui = ls_partner_guid_remote-partner_guid.
*&---- Read customer GUID with respect to contact person GUID
                  READ TABLE lt_kunnr
                  INTO ls_kunnr
                  WITH KEY partn_guid = ls_co_kunnr-org_guid.
*&--- Read importing data of the customer.
                  READ TABLE it_partners
                    INTO ls_eop_check_partners
                    WITH KEY id = ls_kunnr-custome_no.
                  ls_message-appl_name = ls_cvi_messages-appl_name.
                  ls_message-appl_rule_variant = ls_cvi_messages-appl_rule_variant.
                  ls_message-bukrs = ls_unblk_check_vendor-bukrs.
                  ls_message-id = ls_unblk_check_vendor-id.
                  ls_message-id_type = ls_unblk_check_vendor-id_type.
                  ls_message-vkorg = ls_unblk_check_vendor-vkorg.
                  MOVE-CORRESPONDING  ls_cvi_messages TO ls_bapiret2.
                  APPEND ls_bapiret2 TO ls_message-messages.
                  APPEND ls_message TO lt_message.
                  CLEAR: ls_message, ls_eop_check_partners, ls_kunnr, ls_partner_guid_remote, ls_cvi_messages,ls_co_kunnr.
                ENDIF.
              ENDLOOP.
              APPEND LINES OF lt_message TO et_messages.
            ENDIF.
          ENDIF.
        ENDLOOP.
*        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD cvp_if_appl_eop_check~partners_purcmpl_export.

    DATA:    lt_crmkunnr             TYPE TABLE OF crmkunnr,
             lt_crmparnr             TYPE TABLE OF crmparnr,
             ls_crmkunnr             LIKE LINE OF lt_crmkunnr,
             ls_crmparnr             LIKE LINE OF lt_crmparnr,
             lt_partner_guid         TYPE bup_partner_guid_t,
             ls_partner_guid         LIKE LINE OF lt_partner_guid,
             lt_partner_guid_all     TYPE bup_partnerguid_t,
             ls_partner_guid_all     TYPE bup_partnerguid_s,
             lt_partner              TYPE bu_partner_t,
             lt_regsys               TYPE TABLE OF butregsys_remote,
             ls_regsys               LIKE LINE OF lt_regsys,
             lt_bubutsort_maint_guid TYPE bubutsort_maint_guid_t,
             ls_bubutsort_maint_guid TYPE bubutsort_maint_guid.

    DATA: lt_messages TYPE cvp_tt_eop_check_messages,
          ls_messages TYPE cvp_s_eop_check_messages,

          lt_purexp_temp TYPE TABLE OF CVP_S_EOP_PARTNER_PURCMPL_EXP,
          ls_purexp_temp TYPE CVP_S_EOP_PARTNER_PURCMPL_EXP.


    FIELD-SYMBOLS: <fs_pur_cmplt_partners_final> LIKE LINE OF gv_pur_cmplt_partners_final,
                   <fs_partnerguid>              LIKE LINE OF lt_partner_guid.

* Only if the CRM system is connected to this ECC system, then continue further processing in the class!
  CHECK gv_crm_connected IS NOT INITIAL.

  LOOP AT it_eop_partner_purcmpl_exp INTO ls_purexp_temp.
   IF ls_purexp_temp-BUKRS IS INITIAL AND
      ls_purexp_temp-VKORG IS INITIAL AND
      ls_purexp_temp-ID_TYPE = '1'.
      append ls_purexp_temp to lt_purexp_temp.
   ENDIF.
  ENDLOOP.
*----Executing blocking module by passing business partners.
IF  gv_test_mode IS INITIAL.

*    IF it_eop_partner_purcmpl_exp IS NOT INITIAL.
    IF lt_purexp_temp IS NOT INITIAL.
*--- Fetching Business partners linked to customer
      SELECT * FROM crmkunnr INTO TABLE lt_crmkunnr
                                  FOR ALL ENTRIES IN lt_purexp_temp"it_eop_partner_purcmpl_exp
                                  WHERE custome_no = lt_purexp_temp-id."it_eop_partner_purcmpl_exp-id.
      IF sy-subrc = 0.
        LOOP AT lt_crmkunnr INTO ls_crmkunnr.
          ls_partner_guid_all-partner_guid = ls_crmkunnr-partn_guid.
          APPEND ls_partner_guid_all TO lt_partner_guid_all.
        ENDLOOP.
*---- Fetching customer contact persons.
        SELECT * FROM crmparnr INTO TABLE lt_crmparnr
                                    FOR ALL ENTRIES IN lt_crmkunnr
                                    WHERE org_guid = lt_crmkunnr-partn_guid.
        IF sy-subrc = 0.
          LOOP AT lt_crmparnr INTO ls_crmparnr.
            ls_partner_guid_all-partner_guid = ls_crmparnr-person_gui.
            APPEND ls_partner_guid_all TO lt_partner_guid_all.
          ENDLOOP.
        ENDIF.
*---- Fetching business partners related to customers
        SELECT partner partner_guid FROM but000 INTO TABLE lt_partner_guid
                                    FOR ALL ENTRIES IN lt_partner_guid_all
                                    WHERE partner_guid = lt_partner_guid_all-partner_guid.
        IF sy-subrc = 0.
*--- Moving only business partners without GUID
          MOVE lt_partner_guid TO lt_partner.
          CLEAR: ls_partner_guid_all,
          lt_partner_guid_all.
          LOOP AT lt_partner_guid INTO ls_partner_guid.
            ls_partner_guid_all-partner_guid = ls_partner_guid-partner_guid.
            APPEND ls_partner_guid_all TO lt_partner_guid_all.
          ENDLOOP..
*&---- Get all the registered systems
          CALL FUNCTION 'BUPA_EOP_REGSYS'
            EXPORTING
              IV_REPL_TYPE       = 'CV->BP'
            TABLES
              et_eopsys = lt_regsys.

*&---- Update all the connected systems
          IF lt_regsys IS NOT INITIAL.
            CLEAR lt_bubutsort_maint_guid.
            LOOP AT gv_pur_cmplt_partners_final ASSIGNING <fs_pur_cmplt_partners_final>.
              READ TABLE lt_partner_guid WITH KEY partner = <fs_pur_cmplt_partners_final>-partner
                                        ASSIGNING <fs_partnerguid>.
              IF sy-subrc = 0.
                MOVE-CORRESPONDING <fs_pur_cmplt_partners_final> TO ls_bubutsort_maint_guid.
                ls_bubutsort_maint_guid-partner_guid = <fs_partnerguid>-partner_guid.
                APPEND ls_bubutsort_maint_guid TO lt_bubutsort_maint_guid.
              ENDIF.
              CLEAR ls_bubutsort_maint_guid.
            ENDLOOP.
*&--- Blocking the partners in cnnected systems.
            LOOP AT lt_regsys INTO ls_regsys WHERE rfcdes IS NOT INITIAL.

              CALL FUNCTION 'FUNCTION_EXISTS' DESTINATION ls_regsys-rfcdes
                EXPORTING
                  funcname           = 'CRM_IF_BUP_PURPOSE_SETTING'
                EXCEPTIONS
                  function_not_exist = 1
                  OTHERS             = 2.

              IF sy-subrc = 0.
                CALL FUNCTION 'CRM_IF_BUP_PURPOSE_SETTING' DESTINATION ls_regsys-rfcdes
                  EXPORTING
*                   it_partner      = lt_partner
                    it_partner_guid = lt_partner_guid_all
                    it_sort         = lt_bubutsort_maint_guid
*             IMPORTING
*                   E_CVI_MESSAGES  =
                  .
              ENDIF.
            ENDLOOP.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
 ENDIF.
  ENDMETHOD.


  method CVP_IF_APPL_EOP_CHECK~PARTNERS_PURCMPL_RESET.

    DATA: lt_crmkunnr         TYPE TABLE OF crmkunnr,
          lt_crmparnr         TYPE TABLE OF crmparnr,
          ls_crmkunnr         LIKE LINE OF lt_crmkunnr,
          ls_crmparnr         LIKE LINE OF lt_crmparnr,
          lt_partner_guid     TYPE bup_partner_guid_t,
          ls_partner_guid     LIKE LINE OF lt_partner_guid,
          lt_partner_guid_all TYPE bup_partnerguid_t,
          ls_partner_guid_all TYPE bup_partnerguid_s,
          lt_partner          TYPE bu_partner_t,
          lt_regsys           TYPE TABLE OF butregsys_remote,
          ls_regsys           LIKE LINE OF lt_regsys.

*   Only if the CRM system is connected to this ECC system, then continue further processing in the class!
    CHECK gv_crm_connected IS NOT INITIAL.

*----Executing blocking module by passing business partners.

IF  gv_test_mode IS INITIAL.
    IF it_partners IS NOT INITIAL.
*--- Fetching Business partners linked to customers
      SELECT * FROM crmkunnr INTO TABLE lt_crmkunnr
                                  FOR ALL ENTRIES IN it_partners
                                  WHERE custome_no = it_partners-id.
      IF sy-subrc = 0.
        LOOP AT lt_crmkunnr INTO ls_crmkunnr.
          ls_partner_guid_all-partner_guid = ls_crmkunnr-partn_guid.
          APPEND ls_partner_guid_all TO lt_partner_guid_all.
        ENDLOOP.
*---- Fetching customer contact persons.
        SELECT * FROM crmparnr INTO TABLE lt_crmparnr
                                    FOR ALL ENTRIES IN lt_crmkunnr
                                    WHERE org_guid = lt_crmkunnr-partn_guid.
        IF sy-subrc = 0.
          LOOP AT lt_crmparnr INTO ls_crmparnr.
            ls_partner_guid_all-partner_guid = ls_crmparnr-person_gui.
            APPEND ls_partner_guid_all TO lt_partner_guid_all.
          ENDLOOP.
        ENDIF.
*---- Fetching business partners related to customers
        SELECT partner partner_guid FROM but000 INTO TABLE lt_partner_guid
                                    FOR ALL ENTRIES IN lt_partner_guid_all
                                    WHERE partner_guid = lt_partner_guid_all-partner_guid.
        IF sy-subrc = 0.
*&---- Get all the registered systems
          CALL FUNCTION 'BUPA_EOP_REGSYS'
            EXPORTING
              IV_REPL_TYPE       = 'CV->BP'
            TABLES
              et_eopsys = lt_regsys.

*&---- Update all the connected systems
          IF lt_regsys IS NOT INITIAL.
*&--- Blocking the partners in cnnected systems.
            LOOP AT lt_regsys INTO ls_regsys WHERE rfcdes IS NOT INITIAL.
              CALL FUNCTION 'FUNCTION_EXISTS' DESTINATION ls_regsys-rfcdes
                EXPORTING
                  funcname           = 'CRM_IF_BUP_PURPOSE_RESETTING'
                EXCEPTIONS
                  function_not_exist = 1
                  OTHERS             = 2.
              IF sy-subrc = 0.

                CALL FUNCTION 'CRM_IF_BUP_PURPOSE_RESETTING' DESTINATION ls_regsys-rfcdes
                  EXPORTING
                    it_partner_guid = lt_partner_guid
*                IMPORTING
*                   e_cvi_messages  =
                  .
              ENDIF.
            ENDLOOP.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
  endmethod.
ENDCLASS.
