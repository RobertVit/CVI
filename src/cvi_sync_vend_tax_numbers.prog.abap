*&---------------------------------------------------------------------*
*& Report  CVI_SYNC_CUST_TAX_NUMBERS
*&
*&---------------------------------------------------------------------*

report  cvi_sync_tax_numbers.

include emsg.

tables:
  sscrfields.

type-pools:
  eemsg.

constants:
  true                type boole-boole value 'X',
  false               type boole-boole value space,

* application type for parallel processing tool
* -------------------------------------------------------
  application_type    type bank_dte_pp_paapplcatg value 'CVI_SVETAX',"#EC NOTEXT
* -------------------------------------------------------

  direction_constant  type char6 value 'CVISVT'. " CVI Sync Vendor Tax data  "#EC NOTEXT

data:
  lt_jobs             type bank_tab_jc_jobkey,
  ls_bpconst          type bpconstants,
  ls_appl_params      type cvis_conversion_params,
  ls_params           type eemsg_parm_open,
  lv_msg_handle       type emsg_gen-handle,
  lv_title            type lvc_title,
  lv_run_ext_id       type bank_dte_pp_runid_ext,
  lv_log_ext_id       type balnrext,
  lt_log              type bank_tab_jc_appl_log_data,
  ls_log              like line of lt_log,
  lt_job_distrib      type bank_tab_grp_srv.


* _______________________________________________________
*
* selection screen
* _______________________________________________________
selection-screen function key 1.

parameters:
  p_runid(30)  type c obligatory,
  p_psize      type cvi_packet_size obligatory.

selection-screen begin of block b1 with frame title text-003.
parameters:
  p_nodir  type c radiobutton group dir modif id md1,   "no direction selected - error
  p_bpvend type c radiobutton group dir modif id md1,
  p_vendbp type c radiobutton group dir modif id md1.
selection-screen skip.
parameters:
  p_soft_d type c as checkbox modif id md1.             "soft decision - direction can be changed if one object has initial data
selection-screen end of block b1.


at selection-screen on radiobutton group dir.

  if p_nodir is not initial.
    message e007(cvi_sync_tax_number).
  endif.

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

  select single * from bpconstants into ls_bpconst
    where constant = direction_constant.

start-of-selection.
* _______________________________________________________

  ls_appl_params-package_size = p_psize.
  if p_bpvend is not initial.
    ls_appl_params-tax_mapping_direction = '3'.
  else.
    ls_appl_params-tax_mapping_direction = '4'.
  endif.
  ls_appl_params-auto_direction_change = p_soft_d.

  lv_run_ext_id = p_runid.
  lv_log_ext_id = p_runid.

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

* log: the run was started
  perform log_run_start.

  if ls_bpconst is initial.
*   save the direction to BPCONSTANTS table
    ls_bpconst-constant   = direction_constant.
    ls_bpconst-value(1)   = p_bpvend .
    ls_bpconst-value+1(1) = p_vendbp .
    ls_bpconst-value+2(1) = p_soft_d .
    insert bpconstants from ls_bpconst.

    perform log_direction using true.

  else.
    perform log_direction using false.
  endif.

  call function 'BANK_MAP_PP_START'
    exporting
      i_runid_ext         = lv_run_ext_id
      i_flg_force_new_run = false
      i_flg_unique_extid  = true
      i_applcatg          = application_type
      i_str_appl_param    = ls_appl_params
      i_xlog              = true
      i_logextnumber      = lv_log_ext_id
      i_tab_log           = lt_log[]
      i_x_sync            = true
      i_x_use_dialog_wp   = true
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







**********************************************************************
* FORM    :  log_run_start
**********************************************************************
form log_run_start.

  data:
    ls_message   type bapiret2.

  ls_message-type       = 'S'.
  ls_message-id         = 'CVI_SYNC_TAX_NUMBER'.
  ls_message-number     = '009'.
  ls_message-message_v1 = p_runid.
  call function 'CVI_EMSG_LOG_PUT_MESSAGE'
    exporting
      i_message = ls_message.

endform. "log_run_start

**********************************************************************
* FORM    :  log_direction
**********************************************************************
form log_direction
  using saved_to_db type boole_d.

  data:
    ls_message   type bapiret2.

  ls_message-type       = 'S'.
  ls_message-id         = 'CVI_SYNC_TAX_NUMBER'.

  if saved_to_db = true.
    ls_message-number     = '010'.
    call function 'CVI_EMSG_LOG_PUT_MESSAGE'
      exporting
        i_message = ls_message.
  endif.

  if p_bpvend is not initial.
    ls_message-number     = '036'.
  else.
    ls_message-number     = '037'.
  endif.
  call function 'CVI_EMSG_LOG_PUT_MESSAGE'
    exporting
      i_message = ls_message.

  if p_soft_d is not initial.
    ls_message-number     = '013'.
  else.
    ls_message-number     = '014'.
  endif.
  call function 'CVI_EMSG_LOG_PUT_MESSAGE'
    exporting
      i_message = ls_message.

endform. "log_direction
at selection-screen output.

  if ls_bpconst is not initial.
*     the direction is already set for current client!
*     format: 123 where character 1-p_bpvend 2-p_vendbp 3-p_soft_d
    p_bpvend = ls_bpconst-value(1).
    p_vendbp = ls_bpconst-value+1(1).
    p_soft_d = ls_bpconst-value+2(1).
    assert p_bpvend <> p_vendbp.
    loop at screen.
      if screen-group1 = 'MD1'.
        screen-input   = '0'.
        modify screen.
      endif.
    endloop.
  endif.

* _______________________________________________________
*
