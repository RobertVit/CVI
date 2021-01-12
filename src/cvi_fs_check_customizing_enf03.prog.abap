*----------------------------------------------------------------------*
***INCLUDE CVI_FS_CHECK_CUSTOMIZING_ENF03.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form SHOW_DATA_CUSTOMER2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM show_data_customer2 .

  DATA: lv_text      TYPE string,
        lv_text_role TYPE string.
*



*  set handler gr_event_handler->on_toolbar_role for gr_alv_log.
*  if gt_outtab[] is not initial.
*    gs_layout_default-grid_title = 'CHK_BP_AC'.
  gs_layout_default-cwidth_opt = gc_false.

  PERFORM show_table_alv  USING    gr_alv_ac_gp
                                   gs_layout_default
                          CHANGING gt_outtab[]
                                   gt_fieldcat_ac_gp.

  SET HANDLER lcl_event_handler=>on_click_acgp FOR gr_alv_ac_gp.



*  else.
*
*    if gt_outtab_log_ac[] is not initial.
*      lv_text = 'CHK_BP_AC: Maintain Account Groups from Error Log'.
*    else.
*      lv_text = 'CHK_BP_AC: All entries are Synchronized'.
*    endif.
*
*    perform show_text_element using gr_cont_ac_gp
*                                    lv_text.
*
*  endif.




  SET HANDLER lcl_event_handler=>on_toolbar_role FOR gr_alv_role.

  gs_layout_role-grid_title = 'Display Settings for Business Partner Roles'.
  gs_layout_role-cwidth_opt = gc_false.




  gr_alv_role->register_edit_event( EXPORTING i_event_id = cl_gui_alv_grid=>mc_evt_modified ).

  gr_alv_role->register_edit_event( EXPORTING i_event_id = cl_gui_alv_grid=>mc_evt_enter ).

  PERFORM show_table_alv  USING    gr_alv_role
                                     gs_layout_role
                            CHANGING gt_outtab_role[]
                                    gt_fieldcat_role.

  SET HANDLER lcl_event_handler=>on_data_change FOR gr_alv_role.
  SET HANDLER lcl_event_handler=>on_handle_user_command FOR gr_alv_role.
  SET HANDLER lcl_event_handler=>on_click_role FOR gr_alv_role.

  SET HANDLER lcl_event_responder=>refresh_table_change_role FOR gr_alv_role.

*  set handler lcl_event_handler=>on_click_role_out for gr_alv_role.



*  else.
*    if gt_outtab_log_role[] is not initial.
**      concatenate gv_icon_red  'CHK_BP_ROLE :Error log account groups need to be maintained' into lv_text_role separated by space.
*        lv_text_role = 'CHK_BP_ROLE: Maintain Account Groups from Error Log'.
*    else.
*      lv_text_role = 'CHK_BP_ROLE :ALL ENTRIES ARE SYNCHRONISED'.
*    endif.
*    perform show_text_element using gr_cont_role
*                                    lv_text_role.
*  endif.
*
*  if gt_outtab_log[] is not initial.
*    if gt_outtab_role[] is not initial.
*      concatenate gv_icon_red  'CHK_BP_ROLE :Roles need to be maintained for error log account groups' into lv_text_role separated by space.
*       perform show_text_element using gr_cont_log2
*                                    lv_text_role.
*    else .
*        concatenate gv_icon_red  'CHK_BP_ROLE :ALL ENTRIES ARE SYNCHRONISED' into lv_text_role separated by space.
*       perform show_text_element using gr_cont_log2
*                                    lv_text_role.
*    endif.

  DATA : ls_outtab_log LIKE LINE OF gt_outtab_log_ac_fin.

  REFRESH : gt_outtab_log_fin[].




  IF gv_checkid IS NOT INITIAL.
    LOOP AT gt_outtab_log_ac_fin INTO ls_outtab_log .
      IF ls_outtab_log-chk = gv_checkid.
        APPEND ls_outtab_log TO gt_outtab_log_fin.
      ENDIF.
    ENDLOOP.
  ELSE.
    LOOP AT gt_outtab_log_ac_fin INTO ls_outtab_log .
      APPEND ls_outtab_log TO gt_outtab_log_fin.
    ENDLOOP.
  ENDIF.

*clear : gv_checkid.
*gr_alv_log2->refresh_table_display( ).
  gs_layout_log-grid_title = 'Error'.
  PERFORM show_table_alv USING     gr_alv_log2
                                   gs_layout_log
                          CHANGING gt_outtab_log_fin[]
                                   gt_fieldcat_log2.

*    set handler lcl_event_handler=>on_hotspot_log1 for gr_alv_log2.
*  endif.

ENDFORM.                    "show_data_customer2
*&---------------------------------------------------------------------*
*& Form SET_DATA_CUSTOMER3
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM show_data_customer3 .
  DATA: lv_text TYPE string.

  DATA: lt_drpdwn_bp_dep TYPE lvc_t_drop,
        ls_drpdwn_bp_dep TYPE lvc_s_drop,
        lt_tb910         TYPE TABLE OF tb910,
        ls_tb910         LIKE LINE OF lt_tb910,
        lt_tb911         TYPE TABLE OF tb911,
        ls_tb911         LIKE LINE OF lt_tb911,
        lv_bp_dep_desc   TYPE bu_text20.

  SELECT * FROM tb910 INTO CORRESPONDING FIELDS OF TABLE lt_tb910." WHERE abtnr IS NOT NULL.
    IF sy-subrc = 0.
      delete lt_tb910 where abtnr is initial.
    ENDIF.
  SELECT * FROM tb911 INTO CORRESPONDING FIELDS OF TABLE lt_tb911 WHERE spras = sy-langu." AND abtnr IS NOT NULL.
    IF sy-subrc = 0.
      delete lt_tb911 where abtnr is initial.
    ENDIF.

  LOOP AT lt_tb910 INTO ls_tb910.
    READ TABLE lt_tb911 INTO ls_tb911 WITH KEY abtnr = ls_tb910-abtnr.
    CONCATENATE ls_tb910-abtnr ls_tb911-bez20 INTO lv_bp_dep_desc SEPARATED BY space.
    ls_drpdwn_bp_dep-handle = '2'.
    ls_drpdwn_bp_dep-value = lv_bp_dep_desc.
    APPEND ls_drpdwn_bp_dep TO lt_drpdwn_bp_dep.
  ENDLOOP.

  "text-026 --> 'Missing'
  "text-029 --> 'Department Numbers for Contact Person'
  CONCATENATE TEXT-026 TEXT-029 INTO gs_layout_default_map-grid_title SEPARATED BY space.
  gs_layout_default_map-cwidth_opt = gc_false.
  gs_layout_default_map-smalltitle = '1'.

  IF gr_alv_dept IS INITIAL.
    CREATE OBJECT gr_alv_dept
      EXPORTING
        i_parent = gr_cont_dept.
  ENDIF.

  IF gr_alv_dept IS BOUND.
    CALL METHOD gr_alv_dept->set_drop_down_table
      EXPORTING
        it_drop_down = lt_drpdwn_bp_dep.
  ENDIF.

  PERFORM show_table_alv  USING    gr_alv_dept
                                 gs_layout_default_map
                        CHANGING gt_outtab_d[]
                                 gt_fieldcat_dept.


  SET HANDLER lcl_event_handler=>on_click_dept FOR gr_alv_dept.


  DATA : lt_drpdwn_bp_fn TYPE lvc_t_drop,
         ls_drpdwn_bp_fn TYPE lvc_s_drop,
         lt_tb912        TYPE TABLE OF tb912,
         ls_tb912        LIKE LINE OF lt_tb912,
         lt_tb913        TYPE TABLE OF tb913,
         ls_tb913        LIKE LINE OF lt_tb913,
         lv_bp_fn_desc   TYPE bu_bez30.

  SELECT * FROM tb912 INTO CORRESPONDING FIELDS OF TABLE lt_tb912." WHERE pafkt IS NOT NULL.
    IF sy-subrc = 0.
      delete lt_tb912 where pafkt is INITIAL.
    ENDIF.
  SELECT * FROM tb913 INTO CORRESPONDING FIELDS OF TABLE lt_tb913 WHERE spras = sy-langu. " AND pafkt IS NOT NULL.
    IF sy-subrc = 0.
      delete lt_tb913 where pafkt is INITIAL.
    ENDIF.

  LOOP AT lt_tb912 INTO ls_tb912.
    READ TABLE lt_tb913 INTO ls_tb913 WITH KEY pafkt = ls_tb912-pafkt.
    CONCATENATE ls_tb912-pafkt ls_tb913-bez30 INTO lv_bp_fn_desc SEPARATED BY space.
    ls_drpdwn_bp_fn-handle = '2'.
    ls_drpdwn_bp_fn-value = lv_bp_fn_desc.
    APPEND ls_drpdwn_bp_fn TO lt_drpdwn_bp_fn.
  ENDLOOP.

  "text-033 --> 'Functions of Contact Person'
  "text-026 --> 'Missing'
  CONCATENATE TEXT-026 TEXT-033 INTO gs_layout_default_fn-grid_title SEPARATED BY space.
  gs_layout_default_fn-cwidth_opt = gc_false.
  gs_layout_default_fn-smalltitle = '1'.
  IF gr_alv_fn IS INITIAL.
    CREATE OBJECT gr_alv_fn
      EXPORTING
        i_parent = gr_cont_fn.
  ENDIF.

  IF gr_alv_fn IS BOUND.
    CALL METHOD gr_alv_fn->set_drop_down_table
      EXPORTING
        it_drop_down = lt_drpdwn_bp_fn.
  ENDIF.
  PERFORM show_table_alv  USING    gr_alv_fn
                                  gs_layout_default_fn
                         CHANGING gt_outtab_fn[]
                                  gt_fieldcat_fn.
  SET HANDLER lcl_event_handler=>on_click_fn FOR gr_alv_fn.



  DATA: lt_drpdwn_bp_poa TYPE lvc_t_drop,
        ls_drpdwn_bp_poa TYPE lvc_s_drop,
        lt_tb914         TYPE TABLE OF tb914,
        ls_tb914         LIKE LINE OF lt_tb914,
        lt_tb915         TYPE TABLE OF tb915,
        ls_tb915         LIKE LINE OF lt_tb915,
        lv_bp_poa_desc   TYPE bu_text20.

  SELECT * FROM tb914 INTO CORRESPONDING FIELDS OF TABLE lt_tb914." WHERE paauth IS NOT NULL.
    IF sy-subrc = 0.
      delete lt_tb914 where paauth is INITIAL.
    ENDIF.
  SELECT * FROM tb915 INTO CORRESPONDING FIELDS OF TABLE lt_tb915 WHERE spras = sy-langu." AND paauth IS NOT NULL.
    IF sy-subrc = 0.
      delete lt_tb915 where paauth is INITIAL.
    ENDIF.

  LOOP AT lt_tb914 INTO ls_tb914.
    READ TABLE lt_tb915 INTO ls_tb915 WITH KEY paauth = ls_tb914-paauth.
    CONCATENATE ls_tb914-paauth ls_tb915-bez20 INTO lv_bp_poa_desc SEPARATED BY space.
    ls_drpdwn_bp_poa-handle = '2'.
    ls_drpdwn_bp_poa-value = lv_bp_poa_desc.
    APPEND ls_drpdwn_bp_poa TO lt_drpdwn_bp_poa.
  ENDLOOP.

  "text-026 --> 'Missing'
  "text-028 --> 'Authority of Contact Person (CVI) to BP (PoA)'
  CONCATENATE TEXT-026 TEXT-028 INTO gs_layout_default_au-grid_title SEPARATED BY space.
  gs_layout_default_au-cwidth_opt = gc_false.
  gs_layout_default_au-smalltitle = '1'.

  IF gr_alv_au IS INITIAL.
    CREATE OBJECT gr_alv_au
      EXPORTING
        i_parent = gr_cont_au.
  ENDIF.

  IF gr_alv_au IS BOUND.
    CALL METHOD gr_alv_au->set_drop_down_table
      EXPORTING
        it_drop_down = lt_drpdwn_bp_poa.
  ENDIF.

  PERFORM show_table_alv  USING    gr_alv_au
                                  gs_layout_default_au
                         CHANGING gt_outtab_au[]
                                  gt_fieldcat_au.
  SET HANDLER lcl_event_handler=>on_click_auth FOR gr_alv_au.


  DATA: lt_tb916         TYPE TABLE OF tb916,
        ls_tb916         LIKE LINE OF lt_tb916,
        lt_tb917         TYPE TABLE OF tb917,
        ls_tb917         LIKE LINE OF lt_tb917,
        lt_drpdwn_bp_vip TYPE lvc_t_drop,
        ls_drpdwn_bp_vip TYPE lvc_s_drop,
        lv_bp_vip_desc   TYPE bu_text20.

  SELECT * FROM tb916 INTO CORRESPONDING FIELDS OF TABLE lt_tb916." WHERE pavip IS NOT NULL.
    IF sy-subrc = 0.
      delete lt_tb916 where pavip is INITIAL.
    ENDIF.
  SELECT * FROM tb917 INTO CORRESPONDING FIELDS OF TABLE lt_tb917 WHERE spras = sy-langu." AND pavip IS NOT NULL.
    IF sy-subrc = 0.
      delete lt_tb917 where pavip is INITIAL.
    ENDIF.

  LOOP AT lt_tb916 INTO ls_tb916.
    READ TABLE lt_tb917 INTO ls_tb917 WITH KEY pavip = ls_tb916-pavip.
    CONCATENATE ls_tb916-pavip ls_tb917-bez20 INTO lv_bp_vip_desc SEPARATED BY space.
    ls_drpdwn_bp_vip-handle = '2'.
    ls_drpdwn_bp_vip-value = lv_bp_vip_desc.
    APPEND ls_drpdwn_bp_vip TO lt_drpdwn_bp_vip.
  ENDLOOP.

  "text-026 --> 'Missing'
  "text-034 --> 'VIP Indicator for Contact Person'
  CONCATENATE TEXT-026 TEXT-034 INTO gs_layout_vip-grid_title SEPARATED BY space.
  gs_layout_vip-cwidth_opt = gc_false.
  gs_layout_vip-smalltitle = '1'.
  IF gr_alv_vip IS INITIAL .
    CREATE OBJECT gr_alv_vip
      EXPORTING
        i_parent = gr_cont_vip.
  ENDIF.

  IF gr_alv_vip IS BOUND.
    CALL METHOD gr_alv_vip->set_drop_down_table
      EXPORTING
        it_drop_down = lt_drpdwn_bp_vip.
  ENDIF.

  PERFORM show_table_alv  USING    gr_alv_vip
                                  gs_layout_vip
                         CHANGING gt_outtab_vip[]
                                  gt_fieldcat_vip.
  SET HANDLER lcl_event_handler=>on_click_vip FOR gr_alv_vip.


    DATA: lt_tb027         TYPE TABLE OF tb027,
        ls_tb027         LIKE LINE OF lt_tb027,
        lt_tb027t         TYPE TABLE OF tb027t,
        ls_tb027t         LIKE LINE OF lt_tb027t,
        lt_drpdwn_bp_marst TYPE lvc_t_drop,
        ls_drpdwn_bp_marst TYPE lvc_s_drop,
        lv_bp_marst_desc   TYPE bu_bez20.

  SELECT * FROM tb027 INTO CORRESPONDING FIELDS OF TABLE lt_tb027." WHERE marst IS NOT NULL.
    IF sy-subrc = 0.
      delete lt_tb027 where marst is initial.
    ENDIF.
  SELECT * FROM tb027t INTO CORRESPONDING FIELDS OF TABLE lt_tb027t WHERE spras = sy-langu." AND marst IS NOT NULL.
    IF sy-subrc = 0.
      delete lt_tb027t where marst is initial.
    ENDIF.

  LOOP AT lt_tb027 INTO ls_tb027 .
    READ TABLE lt_tb027t INTO ls_tb027t WITH KEY marst = ls_tb027-marst.
    CONCATENATE ls_tb027-marst ls_tb027t-bez20 INTO lv_bp_marst_desc SEPARATED BY space.
    ls_drpdwn_bp_marst-handle = '2'.
    ls_drpdwn_bp_marst-value = lv_bp_marst_desc.
    APPEND ls_drpdwn_bp_marst TO lt_drpdwn_bp_marst.
  ENDLOOP.

    "text-026 --> 'Missing'
  "text-035 --> 'Marital Status'

  CONCATENATE TEXT-026 TEXT-035 INTO gs_layout_marital-grid_title SEPARATED BY space.
  gs_layout_marital-cwidth_opt = gc_false.
  gs_layout_marital-smalltitle = '1'.

  IF gr_alv_marital IS INITIAL.
    CREATE OBJECT gr_alv_marital
      EXPORTING
        i_parent = gr_cont_marital.
  ENDIF.

  IF gr_alv_marital IS BOUND.
        CALL METHOD gr_alv_marital->set_drop_down_table
      EXPORTING
        it_drop_down = lt_drpdwn_bp_marst.
    ENDIF.

  PERFORM show_table_alv  USING    gr_alv_marital
                                  gs_layout_marital
                         CHANGING gt_outtab_marital[]
                                  gt_fieldcat_marital.
  SET HANDLER lcl_event_handler=>on_click_marital FOR gr_alv_marital.

  DATA : lt_drpdwn_legal_form TYPE lvc_t_drop,
         ls_drpdwn_legal_form TYPE lvc_s_drop,
         lt_tb019             TYPE TABLE OF tb019,
         ls_tb019             LIKE LINE OF lt_tb019,
         lt_tb020             TYPE TABLE OF tb020,
         ls_tb020             LIKE LINE OF lt_tb020,
         lv_bp_form_desc      TYPE char40.


  SELECT * FROM tb019 INTO CORRESPONDING FIELDS OF TABLE lt_tb019." WHERE legal_enty IS NOT NULL. "and legal_enty not in ( select legal_enty from cvic_legform_lnk ).
    IF sy-subrc = 0.
      delete lt_tb019 where legal_enty is initial.
    ENDIF.
  SELECT * FROM tb020 INTO CORRESPONDING FIELDS OF TABLE lt_tb020 WHERE spras = sy-langu." AND legal_enty IS NOT NULL.
        IF sy-subrc = 0.
      delete lt_tb020 where legal_enty is initial.
    ENDIF.

  LOOP AT lt_tb019 INTO ls_tb019.

    READ TABLE lt_tb020 INTO ls_tb020 WITH KEY legal_enty = ls_tb019-legal_enty.
    CONCATENATE ls_tb019-legal_enty ls_tb020-textshort INTO lv_bp_form_desc SEPARATED BY space.
    ls_drpdwn_legal_form-handle = '2'."lv_handle_counter.
    ls_drpdwn_legal_form-value = lv_bp_form_desc."ls_tb019-legal_enty.".
    APPEND ls_drpdwn_legal_form TO lt_drpdwn_legal_form.
  ENDLOOP.

  "text-026 --> 'Missing'
  "text-027 --> 'Legal Status to Legal Form'
  CONCATENATE TEXT-026 TEXT-027 INTO gs_layout_legal-grid_title SEPARATED BY space.
  gs_layout_legal-cwidth_opt = gc_false.
  gs_layout_legal-smalltitle = '1'.

  IF gr_alv_legal IS INITIAL.
    CREATE OBJECT gr_alv_legal
      EXPORTING
        i_parent = gr_cont_legal.
  ENDIF.

  IF gr_alv_legal IS BOUND .
    CALL METHOD gr_alv_legal->set_drop_down_table
      EXPORTING
        it_drop_down = lt_drpdwn_legal_form.
  ENDIF.

  PERFORM show_table_alv  USING    gr_alv_legal
                                  gs_layout_legal
                         CHANGING gt_outtab_legal[]
                                  gt_fieldcat_legal.
  SET HANDLER lcl_event_handler=>on_click_legal FOR gr_alv_legal.


  DATA: lt_tb033           TYPE TABLE OF tb033,
        ls_tb033           LIKE LINE OF lt_tb033,
        lt_tb033t          TYPE TABLE OF tb033t,
        ls_tb033t          LIKE LINE OF lt_tb033t,
        lt_drpdwn_bp_pcard TYPE lvc_t_drop,
        ls_drpdwn_bp_pcard TYPE lvc_s_drop,
        lv_bp_pcard        TYPE bu_bez30.

  SELECT * FROM tb033 INTO CORRESPONDING FIELDS OF TABLE lt_tb033." WHERE ccins IS NOT NULL.
    IF sy-subrc = 0.
      delete lt_tb033 where ccins is INITIAL.
    ENDIF.
  SELECT * FROM tb033t INTO CORRESPONDING FIELDS OF TABLE lt_tb033t WHERE spras = sy-langu." AND ccins IS NOT NULL.
    IF sy-subrc = 0.
      delete lt_tb033t where ccins is INITIAL.
    ENDIF.

  LOOP AT lt_tb033 INTO ls_tb033.
    READ TABLE lt_tb033t INTO ls_tb033t WITH KEY ccins = ls_tb033-ccins.
    CONCATENATE ls_tb033-ccins ls_tb033t-bez30 INTO lv_bp_pcard SEPARATED BY space.
    ls_drpdwn_bp_pcard-handle = '2'.
    ls_drpdwn_bp_pcard-value = lv_bp_pcard.
    APPEND ls_drpdwn_bp_pcard TO lt_drpdwn_bp_pcard.
  ENDLOOP.

  "text-026 --> 'Missing'
  "text-036 --> 'Payment Cards'
  CONCATENATE TEXT-026 TEXT-036 INTO gs_layout_pcard-grid_title SEPARATED BY space.
  gs_layout_pcard-cwidth_opt = gc_false.
  gs_layout_pcard-smalltitle = '1'.
  IF gr_alv_pcard IS INITIAL.
    CREATE OBJECT gr_alv_pcard
      EXPORTING
        i_parent = gr_cont_pcard.
  ENDIF.

  IF gr_alv_pcard IS BOUND.
    CALL METHOD gr_alv_pcard->set_drop_down_table
      EXPORTING
        it_drop_down = lt_drpdwn_bp_pcard.
  ENDIF.

  PERFORM show_table_alv  USING    gr_alv_pcard
                                  gs_layout_pcard
                         CHANGING gt_outtab_pcard[]
                                  gt_fieldcat_pcard.
  SET HANDLER lcl_event_handler=>on_click_pcard FOR gr_alv_pcard.

  DATA : ls_cp LIKE LINE OF gt_cp.
  DATA : lt_color TYPE lvc_t_scol.
  DATA :  ls_color    TYPE lvc_s_scol.
  gs_layout_cpassign-grid_title = 'Activate Assignment of Contact Persons'.
  gs_layout_cpassign-cwidth_opt = gc_false.
  gs_layout_cpassign-smalltitle = '1'.


  "Error log
  IF gr_alv_cpassign IS INITIAL.
    CREATE OBJECT gr_alv_cpassign
      EXPORTING
        i_parent = gr_cont_cpassign.
  ENDIF.
  PERFORM show_table_alv  USING    gr_alv_cpassign
                                  gs_layout_cpassign
                         CHANGING gt_cp[]
                                  gt_fieldcat_cpassign.
  SET HANDLER lcl_event_handler=>on_click_cpassign FOR gr_alv_cpassign.

  DATA: ls_log LIKE LINE OF gt_outtab_log_custvalue.
  CLEAR  gt_outtab_cust_log_filter[].
  gs_layout_cust_log-grid_title = 'Error'.
  gs_layout_cust_log-cwidth_opt = gc_false.
  gs_layout_cust_log-smalltitle = '1'.

  IF gv_checkid IS INITIAL.
    gt_outtab_cust_log_filter[] = gt_outtab_log_custvalue[].
  ELSE.
    gv_click = gc_false.
    LOOP AT gt_outtab_log_custvalue INTO ls_log WHERE chk = gv_checkid.
      APPEND ls_log TO gt_outtab_cust_log_filter.
    ENDLOOP.
  ENDIF.

  IF gr_alv_cust_log IS INITIAL.
    CREATE OBJECT gr_alv_cust_log
      EXPORTING
        i_parent = gr_cont_cust_log.
  ENDIF.
  PERFORM show_table_alv USING     gr_alv_cust_log
                                 gs_layout_cust_log
                        CHANGING gt_outtab_cust_log_filter[]
                                 gt_fieldcat_cust_log.

ENDFORM.                    "show_data_customer3
*&---------------------------------------------------------------------*
*& Form SHOW_DATA_CUSTOMER4
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM show_data_customer4 .
  DATA: lv_text TYPE string.
  DATA: lt_rows TYPE lvc_t_row.
  DATA: l_row   TYPE lvc_s_row.

*  if gt_outtab_ind_in[] is not initial.
  gs_layout_ind_in-grid_title = 'Select Industry system'.
  gs_layout_ind_in-cwidth_opt = gc_false.
  gs_layout_ind_in-smalltitle = '1'.
  IF gr_alv_ind_in IS INITIAL.
    CREATE OBJECT gr_alv_ind_in
      EXPORTING
        i_parent = gr_cont_ind_in.
  ENDIF.
  gr_alv_ind_in->register_edit_event( EXPORTING i_event_id = cl_gui_alv_grid=>mc_evt_enter ).
  gr_alv_ind_in->register_edit_event( EXPORTING i_event_id = cl_gui_alv_grid=>mc_evt_modified ).

  PERFORM show_table_alv  USING    gr_alv_ind_in
                                  gs_layout_ind_in
                         CHANGING gt_outtab_ind_sys[]
                                   gt_fieldcat_ind_in.
  SET HANDLER lcl_event_responder=>refresh_changed_data_in FOR  gr_alv_ind_in.
  SET HANDLER lcl_event_responder=>refresh_table_change_in FOR  gr_alv_ind_in.

*
*  else.
*    if gt_outtab_log_ind_in[] is not initial.
*      lv_text                        = 'CHK_CP_IND_IN :Error log Incoming Industry  need to be maintained '.
**
*    else.
*      lv_text = 'CHK_CP_IND_IN (Incoming Industry Mapping) :ALL ENTRIES ARE SYNCHRONISED'.
*    endif.
*    perform show_text_element using gr_cont_ind_in
*                                    lv_text.
*
*  endif.


*  if gt_outtab_ind_out[] is not initial.
  gs_layout_ind_out-grid_title = 'Missing Industry Keys'.
  gs_layout_ind_out-cwidth_opt = gc_false.
  gs_layout_ind_out-smalltitle = '1'.
*create object gr_alv_ind_out
*                    exporting
*                      i_parent = gr_cont_ind_out.

*    gr_alv_ind_out->register_edit_event( exporting i_event_id = cl_gui_alv_grid=>mc_evt_enter ).
*    gr_alv_ind_out->register_edit_event( exporting i_event_id = cl_gui_alv_grid=>mc_evt_modified ).

  PERFORM show_table_alv  USING    gr_alv_ind_out
                                  gs_layout_ind_out
                         CHANGING gt_outtab_ind_in[]
                                  gt_fieldcat_ind_out.
*
*    set handler lcl_event_responder=>refresh_changed_data_out for  gr_alv_ind_out.
*    set handler lcl_event_responder=>refresh_table_change_out for  gr_alv_ind_out.


*  else.
*    if gt_outtab_log_ind_out[] is not initial.
*      lv_text                        = 'CHK_CP_IND_OUT :Error log Outgoing Industry  need to be maintained '.
**
*    else.
*      lv_text = 'CHK_CP_IND_OUT (Outgoing Industry Mapping) : ALL ENTRIES ARE SYNCHRONISED'.
*    endif.
*    perform show_text_element using gr_cont_ind_out
*                                    lv_text.
*  endif.
*  if gt_outtab_cust_log2[] is not initial.
  gs_layout_cust_log2-grid_title = 'Error'.
  gs_layout_cust_log2-cwidth_opt = gc_false.
  gs_layout_cust_log2-smalltitle = '1'.
  CREATE OBJECT gr_alv_cust_log2
    EXPORTING
      i_parent = gr_cont_cust_log2.

  PERFORM show_table_alv USING     gr_alv_cust_log2
                                 gs_layout_cust_log2
                        CHANGING gt_outtab_log_ind[]
                                 gt_fieldcat_cust_log2.
  SET HANDLER lcl_event_handler=>on_hotspot_cust_log2 FOR gr_alv_cust_log2.
*     else.
*      lv_text = 'CUST_ERROR_LOG2 :NO ENTRIES TO MAINTAIN'.
*
*    perform show_text_element using gr_cont_cust_log2
*                                    lv_text.
*  endif.
ENDFORM.                    "show_data_customer4
*&---------------------------------------------------------------------*
*& Form SHOW_DATA_CHK_CUST
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM show_data_chk_cust .
  gs_layout_cust_log-grid_title = 'Customizing Error'.
  gs_layout_cust_log-cwidth_opt = gc_false.
  gs_layout_cust_log-smalltitle = '1'.

  IF gv_gen_flag IS INITIAL.
    PERFORM show_table_alv USING     gr_alv_cust_log
                                 gs_layout_cust_log
                        CHANGING gt_outtab_chk_cust_log[]
                                 gt_fieldcat_cust_log.
    SET HANDLER lcl_event_handler=>on_hotspot_cust_log1 FOR gr_alv_cust_log.
  ELSE.
    PERFORM show_table_alv USING     gr_alv_cust_log
                                  gs_layout_cust_log
                         CHANGING gt_outtab_chk_gen_log[]
                                  gt_fieldcat_cust_log.
    SET HANDLER lcl_event_handler=>on_hotspot_gen_tax_log FOR gr_alv_cust_log.
  ENDIF.
*     set handler lcl_event_handler=>on_hotspot_log1 for gr_alv_cust_log.
ENDFORM.                    "show_data_chk_cust
*&---------------------------------------------------------------------*
*&      Form  SHOW_DATA_CUST_EXISTING
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM show_data_cust_existing .

  DATA: lv_text TYPE string.
  "text-025 --> 'Existing'
  "text-029 --> 'Department Numbers for Contact Person'
  CONCATENATE TEXT-025 TEXT-029 INTO gs_layout_default_map-grid_title SEPARATED BY space.
  gs_layout_default_map-cwidth_opt = gc_false.
  gs_layout_default_map-smalltitle = '1'.

  IF gr_alv_dept IS INITIAL.
    CREATE OBJECT gr_alv_dept
      EXPORTING
        i_parent = gr_cont_dept.
  ENDIF.

  PERFORM show_table_alv  USING    gr_alv_dept
                                   gs_layout_default_map
                          CHANGING gt_outtab_d[]
                                   gt_fieldcat_dept.


  SET HANDLER lcl_event_handler=>on_click_dept FOR gr_alv_dept.

  "text-033 --> 'Functions of Contact Person'
  "text-025 --> 'Existing'
  CONCATENATE TEXT-025 TEXT-033 INTO gs_layout_default_fn-grid_title SEPARATED BY space.
  gs_layout_default_fn-cwidth_opt = gc_false.
  gs_layout_default_fn-smalltitle = '1'.
  IF gr_alv_fn IS INITIAL.
    CREATE OBJECT gr_alv_fn
      EXPORTING
        i_parent = gr_cont_fn.
  ENDIF.
  PERFORM show_table_alv  USING    gr_alv_fn
                                  gs_layout_default_fn
                         CHANGING gt_outtab_fn[]
                                  gt_fieldcat_fn.
  SET HANDLER lcl_event_handler=>on_click_fn FOR gr_alv_fn.

  "text-025 --> 'Existing'
  "text-028 --> 'Authority of Contact Person (CVI) to BP (PoA)'
  CONCATENATE TEXT-025 TEXT-028 INTO gs_layout_default_au-grid_title SEPARATED BY space.
  gs_layout_default_au-cwidth_opt = gc_false.
  gs_layout_default_au-smalltitle = '1'.
  IF gr_alv_au IS INITIAL.
    CREATE OBJECT gr_alv_au
      EXPORTING
        i_parent = gr_cont_au.
  ENDIF.
  PERFORM show_table_alv  USING    gr_alv_au
                                  gs_layout_default_au
                         CHANGING gt_outtab_au[]
                                  gt_fieldcat_au.
  SET HANDLER lcl_event_handler=>on_click_auth FOR gr_alv_au.

  "text-025 --> 'Existing'
  "text-034 --> 'VIP Indicator for Contact Person'
  CONCATENATE TEXT-025 TEXT-034 INTO gs_layout_vip-grid_title SEPARATED BY space.
  gs_layout_vip-cwidth_opt = gc_false.
  gs_layout_vip-smalltitle = '1'.
  IF gr_alv_vip IS INITIAL .
    CREATE OBJECT gr_alv_vip
      EXPORTING
        i_parent = gr_cont_vip.
  ENDIF.
  PERFORM show_table_alv  USING    gr_alv_vip
                                  gs_layout_vip
                         CHANGING gt_outtab_vip[]
                                  gt_fieldcat_vip.
  SET HANDLER lcl_event_handler=>on_click_vip FOR gr_alv_vip.

  "text-025 --> 'Existing'
  "text-035 --> 'Marital Status'
  CONCATENATE TEXT-025 TEXT-035 INTO gs_layout_marital-grid_title SEPARATED BY space.
  gs_layout_marital-grid_title = 'Existing Marital statuses'.
  gs_layout_marital-cwidth_opt = gc_false.
  gs_layout_marital-smalltitle = '1'.
  IF gr_alv_marital IS INITIAL.
    CREATE OBJECT gr_alv_marital
      EXPORTING
        i_parent = gr_cont_marital.
  ENDIF.
  PERFORM show_table_alv  USING    gr_alv_marital
                                  gs_layout_marital
                         CHANGING gt_outtab_marital[]
                                  gt_fieldcat_marital.
  SET HANDLER lcl_event_handler=>on_click_marital FOR gr_alv_marital.

  "text-025 --> 'Existing'
  "text-027 --> 'Legal Status to Legal Form'
  CONCATENATE TEXT-025 TEXT-027 INTO gs_layout_legal-grid_title SEPARATED BY space.
  gs_layout_legal-cwidth_opt = gc_false.
  gs_layout_legal-smalltitle = '1'.
  IF gr_alv_legal IS INITIAL.
    CREATE OBJECT gr_alv_legal
      EXPORTING
        i_parent = gr_cont_legal.
  ENDIF.
  PERFORM show_table_alv  USING    gr_alv_legal
                                  gs_layout_legal
                         CHANGING gt_outtab_legal[]
                                  gt_fieldcat_legal.
  SET HANDLER lcl_event_handler=>on_click_legal FOR gr_alv_legal.

  "text-025 --> 'Existing'
  "text-036 --> 'Payment Cards'
  CONCATENATE TEXT-025 TEXT-036 INTO gs_layout_pcard-grid_title SEPARATED BY space.
  gs_layout_pcard-cwidth_opt = gc_false.
  gs_layout_pcard-smalltitle = '1'.
  IF gr_alv_pcard IS INITIAL.
    CREATE OBJECT gr_alv_pcard
      EXPORTING
        i_parent = gr_cont_pcard.
  ENDIF.
  PERFORM show_table_alv  USING    gr_alv_pcard
                                  gs_layout_pcard
                         CHANGING gt_outtab_pcard[]
                                  gt_fieldcat_pcard.
  SET HANDLER lcl_event_handler=>on_click_pcard FOR gr_alv_pcard.

  DATA : ls_cp LIKE LINE OF gt_cp.
  DATA : lt_color TYPE lvc_t_scol.
  DATA :  ls_color    TYPE lvc_s_scol.
  gs_layout_cpassign-grid_title = 'Activate Assignment of Contact Persons'.
  gs_layout_cpassign-cwidth_opt = gc_false.
  gs_layout_cpassign-smalltitle = '1'.


  "Error log
  IF gr_alv_cpassign IS INITIAL.
    CREATE OBJECT gr_alv_cpassign
      EXPORTING
        i_parent = gr_cont_cpassign.
  ENDIF.
  PERFORM show_table_alv  USING    gr_alv_cpassign
                                  gs_layout_cpassign
                         CHANGING gt_cp[]
                                  gt_fieldcat_cpassign.
  SET HANDLER lcl_event_handler=>on_click_cpassign FOR gr_alv_cpassign.

  DATA: ls_log LIKE LINE OF gt_outtab_log_custvalue.
  CLEAR  gt_outtab_cust_log_filter[].
  gs_layout_cust_log-grid_title = 'Error'.
  gs_layout_cust_log-cwidth_opt = gc_false.
  gs_layout_cust_log-smalltitle = '1'.

  IF gv_checkid IS INITIAL.
    gt_outtab_cust_log_filter[] = gt_outtab_log_custvalue[].
  ELSE.
    gv_click = gc_false.
    LOOP AT gt_outtab_log_custvalue INTO ls_log WHERE chk = gv_checkid.
      APPEND ls_log TO gt_outtab_cust_log_filter.
    ENDLOOP.
  ENDIF.

  IF gr_alv_cust_log IS INITIAL.
    CREATE OBJECT gr_alv_cust_log
      EXPORTING
        i_parent = gr_cont_cust_log.
  ENDIF.
  PERFORM show_table_alv USING     gr_alv_cust_log
                                 gs_layout_cust_log
                        CHANGING gt_outtab_cust_log_filter[]
                                 gt_fieldcat_cust_log.

ENDFORM.                    " SHOW_DATA_CUST_EXISTING
