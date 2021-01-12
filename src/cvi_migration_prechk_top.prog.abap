*&---------------------------------------------------------------------------------------------------*
*& Include CVI_MIGRATION_PRECHK_TOP                          Module Pool      CVI_MIGRATION_PRECHECK
*&
*&---------------------------------------------------------------------------------------------------*
PROGRAM cvi_migration_precheck MESSAGE-ID cvi_prechk.

TYPES :
      BEGIN of gty_so_dummy,
        run_on LIKE cvi_prechk-run_on,
        kunnr LIKE kna1-kunnr,
        ktokd LIKE kna1-ktokd,
        lifnr like lfa1-lifnr,
        ktokk LIKE lfa1-ktokk,
      END OF gty_so_dummy.
DATA :
      gs_so_dummy TYPE gty_so_dummy.
INCLUDE cvi_migration_prechk_sel       .  " subscreen code

*&----------------------------------------------------------------------------------------------------*
*&   structure for customer and vendor radio button in general selection box
*&----------------------------------------------------------------------------------------------------*
TYPES:
  BEGIN OF gty_gen_sel,
    cust TYPE cvi_prechk_objtype,
    vend TYPE cvi_prechk_objtype,
  END OF gty_gen_sel.


DATA:
  go_cvi_prechk_ui     TYPE REF TO cl_cvi_prechk_ui,
  gs_gen_sel       TYPE gty_gen_sel,
  gv_run_desc      TYPE cvi_prechk_run_desc,
  gs_run_details   TYPE if_cvi_prechk=>ty_log_gen_selection,
  gs_scenarios     TYPE if_cvi_prechk=>ty_scenario_selection,
  gv_selectall     TYPE cvi_prechk_selectall,
  gv_bg_mode       TYPE cvi_prechk_bgmode,
  gv_dynnr_gen_sel TYPE sy-dynnr,
  gv_ok_code       TYPE sy-ucomm,
  gv_server_grp    TYPE spta_rfcgr.

LOAD-OF-PROGRAM.
  gv_ok_code =  'INIT'.
