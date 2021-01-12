*&---------------------------------------------------------------------*
*& Report  CVI_ANALYZE_VEND_TAX_NUMBERS
*&
*&---------------------------------------------------------------------*

report  cvi_analyze_vend_tax_numbers.

include emsg.

tables:
  sscrfields.

type-pools:
  eemsg.

constants:
  true                type boole-boole value 'X',
  false               type boole-boole value space.

data:
  lt_jobs             type bank_tab_jc_jobkey,
  ls_appl_params      type cvis_conversion_params,
  ls_params           type eemsg_parm_open,
  lv_msg_handle       type emsg_gen-handle,
  lv_title            type lvc_title,
  lv_application_type type bank_dte_pp_paapplcatg,
  lv_run_ext_id       type bank_dte_pp_runid_ext,
  lv_log_ext_id       type balnrext,
  lt_log              type bank_tab_jc_appl_log_data,
  ls_log              like line of lt_log,
  lt_job_distrib      type bank_tab_grp_srv.

* application type for parallel processing tool
* -------------------------------------------------------
lv_application_type = 'CVI_AVETAX'.                         "#EC NOTEXT
* -------------------------------------------------------

* _______________________________________________________
*
* selection screen
* _______________________________________________________
selection-screen function key 1.

parameters:
  p_runid(30)  type c obligatory,
  p_psize      type cvi_packet_size obligatory.

at selection-screen.

  case sy-ucomm.
    when 'FC01'.
      call function 'BANK_MAP_PP_EDIT_JOBDIST'
        changing
          c_tab_jobdist = lt_job_distrib[].
  endcase.


* _______________________________________________________
*
initialization.
* _______________________________________________________
  p_psize = 500.        "set standard package size
  sscrfields-functxt_01 = text-002.


* _______________________________________________________
*
start-of-selection.
* _______________________________________________________

  ls_appl_params-package_size = p_psize.

  lv_log_ext_id = lv_run_ext_id = p_runid.

  ls_params-appl_log = 'FS_PROT'.
  ls_params-extnumber = lv_log_ext_id.


  ls_log-object = 'FS_PROT'.
  ls_log-flg_standard_log = true.
  ls_log-extnumber = lv_log_ext_id.
  append ls_log to lt_log.

  call function 'MSG_OPEN'
    exporting
      x_log        = true
      x_next_msg   = true
    importing
      y_msg_handle = lv_msg_handle
    changing
      xy_parm      = ls_params
    exceptions
      failed       = 1
      subs_invalid = 2
      log_invalid  = 3
      others       = 4.

  if sy-subrc <> 0.
    message id sy-msgid type sy-msgty number sy-msgno with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  endif.

  call function 'BANK_MAP_PP_START'
    exporting
      i_runid_ext         = lv_run_ext_id
      i_flg_force_new_run = false
      i_flg_unique_extid  = true
      i_applcatg          = lv_application_type
      i_str_appl_param    = ls_appl_params
      i_xlog              = true
      i_logextnumber      = lv_log_ext_id
      i_tab_log           = lt_log[]
      i_x_sync            = false
      i_x_use_dialog_wp   = false
      i_tab_jobdist       = lt_job_distrib[]
    importing
      e_tab_jobs          = lt_jobs
    exceptions
      no_out_of_sync      = 1
      no_export_allowed   = 2
      packman_invalid     = 3
      prepare_failed      = 4
      start_failed        = 5
      others              = 6.

  if sy-subrc <> 0.
    message id sy-msgid type sy-msgty number sy-msgno with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  endif.

  call function 'MSG_ACTION'
    exporting
      x_msg_handle = lv_msg_handle
      x_action     = co_msg_save.

  concatenate lv_log_ext_id ':' text-001 into lv_title separated by space.

  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
      i_structure_name = 'BANK_STR_JC_JOBKEY'
      i_grid_title     = lv_title
    tables
      t_outtab         = lt_jobs.
