interface IF_CVI_PRECHK
  public .


  types:
    BEGIN OF ty_alv_result_tab_out,
      serial_num  TYPE i,
      objectid    TYPE cvi_prechk_cvnum,
      scenario    TYPE char30,
      fieldname   TYPE fieldname,
      value       TYPE sxda_fvalu,
      error       TYPE bapi_msg,
    END OF ty_alv_result_tab_out .
  types:
    tt_alv_result_tab_out TYPE TABLE OF ty_alv_result_tab_out .
  types:
    BEGIN OF ty_log_gen_selection,
      date_rn         TYPE RANGE OF datum,
      created_by      TYPE uname,
      status          TYPE cvi_prechk_status,
      is_customer_sel TYPE char1,
      is_vendor_sel   TYPE char1,
    END OF ty_log_gen_selection .
  types:
    BEGIN OF ty_prechk_master_data,
      cvnum     TYPE cvi_prechk_cvnum,
      acc_group TYPE char4,
      brsch     TYPE brsch,
      land1     TYPE land1_gp,
      adrnr     TYPE adrnr,
      txjcd     TYPE txjcd,
      stceg     TYPE stceg,
      stcdt     TYPE j_1atoid,  "STCDT type not available in the system
      stcd1     TYPE stcd1,
      stcd2     TYPE stcd2,
      stcd3     TYPE stcd3,
      stcd4     TYPE stcd4,
      stcd5     TYPE stcd5,
      stkzn     TYPE stkzn,
      stkzu     TYPE stkzu,
      regio     TYPE regio,
    END OF ty_prechk_master_data .
  types:
    tt_prechk_master_data TYPE TABLE OF ty_prechk_master_data WITH DEFAULT KEY .
  types:
    tt_prechk_error TYPE TABLE OF cvi_prechk_det WITH DEFAULT KEY .
  types:
    BEGIN OF ty_ppf_param,
      runid    TYPE cvi_prechk_runid,
      objtype  TYPE cvi_prechk_objtype,
      chk_data TYPE tt_prechk_master_data,
      scen     TYPE cvi_prechk_scenario_s,
      error    TYPE tt_prechk_error, "needs to be a table type, so made tt_prechk_error with default key
    END OF ty_ppf_param .
  types:
    BEGIN OF ty_runid_status,
      runid  TYPE cvi_prechk_runid,
      status TYPE cvi_prechk_status,
    END OF ty_runid_status .
  types:
    tt_ruinid_status TYPE TABLE OF ty_runid_status .
  types:
    tt_cvi_prechk_mig TYPE TABLE OF cvi_prechk .
  types:
    BEGIN OF ty_alv_result_tab,
      objectid  TYPE cvi_prechk_cvnum,
      scenario  TYPE cvi_prechk_scenario,
      fieldname TYPE fieldname,
      value     TYPE sxda_fvalu,
      error     TYPE bapi_msg,
    END OF ty_alv_result_tab .
  types:
    tt_alv_result_tab TYPE TABLE OF ty_alv_result_tab .
  types:
    BEGIN OF ty_alv_log_tab,
      runid     TYPE cvi_prechk_runid,
      rundesc   TYPE cvi_prechk_run_desc,
      status         TYPE cvi_prechk_status,
      status_icon    TYPE tv_image,
      objectype TYPE domvalue_l,
      objectype_desc TYPE domvalue_l,
      runby          TYPE ernam_rf,
      runon     TYPE erdat_rf,
*      detail    TYPE icon_d,
      detail    TYPE tv_image,
      rec_count TYPE cvi_prechk_tot_rec,
    END OF ty_alv_log_tab .
  types:
    tt_alv_log_tab TYPE TABLE OF ty_alv_log_tab .
  types TT_CVI_PRECHK_CVNUM type CVI_PRECHK_CVNUM .
  types:
    BEGIN OF ty_general_selection,
      objtype         TYPE cvi_prechk_objtype,
      objid_rn        TYPE RANGE OF cvi_prechk_cvnum,
      cv_group        TYPE RANGE OF char4,
      bgmode          TYPE sap_bool,
      server_group    TYPE spta_rfcgr,
      run_description TYPE cvi_prechk_run_desc,
    END OF ty_general_selection .
  types TY_SCENARIO_SELECTION type CVI_PRECHK_SCENARIO_S .

  constants RECORD_PER_RUN type SY-TABIX value 100000 ##NO_TEXT.
  constants PACKAGE_SIZE type SY-TABIX value 10000 ##NO_TEXT.
  constants MAX_RECORD_PROCESS type SY-TABIX value 1000000 ##NO_TEXT.
  class-data GENERAL_SELECTION type TY_GENERAL_SELECTION .
  class-data SCENARIO_SELECTION type TY_SCENARIO_SELECTION .
  class-data LOG_GEN_SELECTION type TY_LOG_GEN_SELECTION .
  constants GC_DEBITOR type NROBJ value 'DEBITOR' ##NO_TEXT.
  constants GC_KREDEBITOR type NROBJ value 'KREDITOR' ##NO_TEXT.
  constants GC_MESSAGE_CLASS type SYMSGID value 'CVI_PRECHK' ##NO_TEXT.
  constants:
    gc_scenrios(9) TYPE c value 'XXXXXXXXX' ##NO_TEXT.
  constants GC_OBJTYPE_CUST type CVI_PRECHK_OBJTYPE value 'C' ##NO_TEXT.
  constants GC_OBJTYPE_VEND type CVI_PRECHK_OBJTYPE value 'V' ##NO_TEXT.
endinterface.
