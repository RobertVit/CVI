**----------------------------------------------------------------------*
****INCLUDE CVI_UPGRADE_CHECK_RESOLVE_GF01 .
**----------------------------------------------------------------------*
**&---------------------------------------------------------------------*
**&      Form  GET_COMPONENT
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
**      <--P_GV_COMPONENT  text
**----------------------------------------------------------------------*
*FORM get_component  CHANGING c_component  TYPE any.
*
*  DATA: l_tcode     TYPE /sappo/dte_tcode,
*        l_component TYPE /sappo/dte_component.
*
*  l_tcode = sy-tcode.
*
*  CALL FUNCTION '/SAPPO/API_TCODE_GETDETAIL'
*    EXPORTING
*      i_tcode     = l_tcode
*    IMPORTING
*      e_component = l_component
*    EXCEPTIONS
*      not_found   = 1
*      OTHERS      = 2.
*
*  IF sy-subrc <> 0.
*    CLEAR c_component.
*  ELSE.
*    c_component = l_component.
*  ENDIF.
*
*
*ENDFORM.
**&---------------------------------------------------------------------*
**&      Form  GET_COMPONENT_DETAIL
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
**      <--P_G_FLG_DISPLAY_MODE  text
**      <--P_GV_CUST_DEF_COUNT  text
**      <--P_GV_CUST_MAX_COUNT  text
**----------------------------------------------------------------------*
*FORM get_component_detail  CHANGING c_flg_display_mode  TYPE any
*                                    c_cust_def_count    TYPE any
*                                    c_cust_max_count    TYPE any.
*
*  DATA: l_tcode        TYPE /sappo/dte_tcode,
*        l_tcode_disp   TYPE /sappo/dte_tcode_disp,
*        l_cnt_def      TYPE /sappo/dte_cnt_order_def,
*        l_cnt_max      TYPE /sappo/dte_cnt_order_def,
*        l_wl_mode_disp TYPE /sappo/dte_wl_mode_disp,
*        l_wl_mode_edit TYPE /sappo/dte_wl_mode_edit.
*
*  IF gv_component IS INITIAL.
*    l_tcode      = '/SAPPO/PPO2'.
*    l_tcode_disp = '/SAPPO/PPO3'.
*    c_cust_def_count = 500.
*    c_cust_max_count = 10000.
*
*  ELSE.
*    CALL FUNCTION '/SAPPO/API_COMPONENT_GETDETAIL'
*      EXPORTING
*        i_component    = gv_component
*      IMPORTING
*        e_tcode        = l_tcode
*        e_tcode_disp   = l_tcode_disp
*        e_cnt_def      = l_cnt_def
*        e_cnt_max      = l_cnt_max
*        e_wl_mode_disp = l_wl_mode_disp
*        e_wl_mode_edit = l_wl_mode_edit
*      EXCEPTIONS
*        not_found      = 1
*        OTHERS         = 2.
*    IF sy-subrc <> 0.
*      MESSAGE e005(/sappo/msg) WITH gv_component.
*    ENDIF.
*  ENDIF.
*
*  c_cust_def_count = l_cnt_def.
*  c_cust_max_count = l_cnt_max.
*
*  CASE sy-tcode.
*    WHEN l_tcode.
*      c_flg_display_mode = ' '.
*      g_worklist_mode = l_wl_mode_edit.
*    WHEN l_tcode_disp.
*      c_flg_display_mode = 'X'.
*      g_worklist_mode = l_wl_mode_disp.
*    WHEN OTHERS.
*      MESSAGE e415(/sappo/msg).
**     Der Transaktionscode wurde keiner Komponente zugeordnet
*  ENDCASE.
*
*  IF g_worklist_mode IS INITIAL.
*    g_worklist_mode = '2'.
*  ENDIF.
*
*ENDFORM.                    " get_component_detail
**&---------------------------------------------------------------------*
**&      Form  CHECK_AUTHORITY_FOR_COMPONENT
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
**      -->P_GV_COMPONENT  text
**      -->P_G_FLG_DISPLAY_MODE  text
**----------------------------------------------------------------------*
*FORM check_authority_for_component  USING    u_component
*                                             TYPE /sappo/dte_component
*                                             u_flg_display_mode
*                                             TYPE c.
*
*
*  DATA: l_activity TYPE activ_auth,
*        l_component TYPE /sappo/dte_component.
*
*  IF u_flg_display_mode IS INITIAL.
*    l_activity = '02'.
*  ELSE.
*    l_activity = '03'.
*  ENDIF.
*
*  IF u_component ne 'CVI_01'.
*    l_component = 'DUMMY'.
*  ELSEIF u_component ne 'CVI_02'.
*    l_component = 'DUMMY'.
*  ELSE.
*    l_component = u_component.
*  ENDIF.
*
*  CALL FUNCTION '/SAPPO/API_AUTH_CHECK_ORDER'
*    EXPORTING
**     I_FLG_AUTH_CHECK   = '1'
*      i_component        = l_component
*      i_business_process = 'DUMMY'
*      i_activity         = l_activity
*    EXCEPTIONS
*      not_authorised     = 1
*      OTHERS             = 2.
*  IF sy-subrc <> 0.
*    IF u_flg_display_mode IS INITIAL.
**   no right to change orders - exit transaction
*      MESSAGE s418(/sappo/msg).
**   Keine Berechtigung zum Ändern von Nachbearbeitungsaufträgen
*    ELSE.
**   no right to display orders -  exit transaction
*      MESSAGE s419(/sappo/msg).
**   Keine Berechtigung zum Anzeigen von Nachbearbeitungsaufträgen
*    ENDIF.
*  ENDIF.
*
*ENDFORM.                    " check_authority_for_component
**&---------------------------------------------------------------------*
**&      Form  CHECK_DISPLAY_LOGSYS
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
**      -->P_GV_COMPONENT  text
**      <--P_G_FLG_LOGSYS  text
**----------------------------------------------------------------------*
*  FORM check_display_logsys  USING    u_component   TYPE any
*                           CHANGING c_flg_logsys  TYPE any.
*
*  DATA: l_str_component  TYPE /sappo/str_component_rng,
*        l_rng_component  TYPE /sappo/rng_component,
*        l_tab_components TYPE /sappo/tab_logsys_component,
*        lv_logsys        TYPE logsys.
*
*
** get local system
*  CALL FUNCTION 'OWN_LOGICAL_SYSTEM_GET'
*    IMPORTING
*      own_logical_system             = lv_logsys
*    EXCEPTIONS
*      own_logical_system_not_defined = 1
*      OTHERS                         = 2.
*  IF sy-subrc <> 0.
*    CLEAR lv_logsys.
*  ENDIF.
*
** move component into range
*  IF u_component <> CVI_01 or u_component <> CVI_02.
*    l_str_component-sign   = 'I'.
*    l_str_component-option = 'EQ'.
*    l_str_component-low    = u_component.
*    APPEND l_str_component TO l_rng_component.
*  ENDIF.
*
** get logical systems for component(s)
*  CALL FUNCTION '/SAPPO/API_LGSYS_GET'
*    EXPORTING
*      i_rng_component        = l_rng_component
**     I_RNG_ORDER_LOGSYS     =
*    IMPORTING
*      e_tab_logsys_component = l_tab_components
*    EXCEPTIONS
*      OTHERS                 = 1.
*
*  IF sy-subrc <> 0.
**   not found
*    c_flg_logsys = ' '.
*  ELSE.
**   check if more than one system is defined for component(s)
*    LOOP AT l_tab_components                "#EC NEEDED
*      TRANSPORTING NO FIELDS
*      WHERE component IN l_rng_component
*      AND   logsys <> lv_logsys.
*    ENDLOOP.
*    IF sy-subrc = 0.
*      c_flg_logsys = 'X'.
*    ELSE.
*      c_flg_logsys = ' '.
*    ENDIF.
*  ENDIF.
*
*ENDFORM.                    " check_display_logsys
**&---------------------------------------------------------------------*
**&      Form  CHECK_DISPLAY_OBJLOGSYS
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
**      -->P_GV_COMPONENT  text
**      <--P_G_FLG_OBJLOGSYS  text
**----------------------------------------------------------------------*
*FORM check_display_objlogsys  USING    u_component      TYPE any
*                              CHANGING c_flg_objlogsys  TYPE any.
*
*  DATA: l_tab_logsys     TYPE /sappo/tab_objlogsys,
*        l_tab_logsys_all TYPE /sappo/tab_objlogsys,
*
*
*        l_tab_component  TYPE /sappo/tas_c_cmpnt_t,
*        l_str_component  TYPE /sappo/str_c_cmpnt_t.
*
*  DATA: l_component      TYPE  /sappo/dte_component,
*        l_lines          TYPE i.
*
*
*
*  IF gv_component = AP-MD.
*
**   get components in system
*    CALL FUNCTION '/SAPPO/DB_CMPNT_GET'
*      EXPORTING
*        i_language       = sy-langu
*        i_refresh_buffer = ' '
*      IMPORTING
*        e_tas_cmpnt_t    = l_tab_component.
*
**    DELETE l_tab_component WHERE component = /sappo/if_ppo_constants=>con_system_component.
*    DELETE l_tab_component WHERE component = AP-MD.
*
*  ELSE.
*
**   only one component
*    MOVE u_component TO l_str_component-component.
*    APPEND l_str_component TO l_tab_component.
*
*  ENDIF.
*
*  LOOP AT l_tab_component INTO l_str_component.
*
**   get systems per component
*    l_component = l_str_component-component.
*
*    CALL FUNCTION '/SAPPO/API_LGSYS_BY_COMP_GET'
*      EXPORTING
*        i_component     = l_component
*      IMPORTING
*        e_tab_objlogsys = l_tab_logsys.
*
*    APPEND LINES OF l_tab_logsys TO l_tab_logsys_all.
*
*  ENDLOOP.
*
** delete duplicates
*  SORT l_tab_logsys_all BY objlogsys.
*  DELETE ADJACENT DUPLICATES FROM l_tab_logsys_all.
*
** if only one system is customized, do not display this field
*  DESCRIBE TABLE l_tab_logsys_all LINES l_lines.
*  IF l_lines <= 1.
*    c_flg_objlogsys = ' '.
*  ELSE.
*    c_flg_objlogsys = 'X'.
*  ENDIF.
*
*ENDFORM.                    " check_display_objlogsys
**&---------------------------------------------------------------------*
**&      Form  CHECK_AUTHORITY_FOR_FILTER
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
**      -->P_GV_COMPONENT  text
**      <--P_GV_AUTHORITY  text
**----------------------------------------------------------------------*
*FORM check_authority_for_filter USING u_component    TYPE /sappo/dte_component
*                                CHANGING c_authority TYPE any.
*
*  DATA: l_subrc        TYPE sy-subrc,
*        l_authority(4) TYPE c,
*        l_component    TYPE /sappo/dte_component.
*
**  IF u_component = /sappo/if_ppo_constants=>con_system_component.
*  IF u_component <> AP-MD.
*    l_component = 'DUMMY'.
*  ELSE.
*    l_component = u_component.
*  ENDIF.
*
*  PERFORM auth_check_filter USING '02'
*                                  l_component
*                                  'ALL'
*                                  CHANGING l_subrc.
*  IF l_subrc IS INITIAL.
*    l_authority = 'ALL'.
*  ELSE.
*    PERFORM auth_check_filter USING '02'
*                                    l_component
*                                    'OWN'
*                                    CHANGING l_subrc.
*    IF l_subrc IS INITIAL.
*      l_authority = 'OWN'.
*    ELSE.
*      CLEAR l_authority.
*    ENDIF.
*  ENDIF.
*
*  c_authority = l_authority.
*
*ENDFORM.
**&---------------------------------------------------------------------*
**&      Form  CHECK_DISPLAY_FA_FIELDS
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
**      -->P_GV_COMPONENT  text
**----------------------------------------------------------------------*
*FORM check_display_fa_fields USING    u_component
*                                      TYPE /sappo/dte_component.
*
*  DATA: l_tab_component     TYPE /sappo/tas_c_cmpnt_t,
*        l_str_component     TYPE /sappo/str_c_cmpnt_t,
*        l_str_fa_fields     TYPE /sappo/str_fa_fields_db,
*        l_tab_fa_fields     TYPE /sappo/tab_fa_fields_db,
*        l_str_fa_fields_all TYPE /sappo/str_fa_fields_db,
*        l_tab_fa_fields_all TYPE /sappo/tab_fa_fields_db,
*        l_tabix             TYPE sytabix.
*  DATA: AP-MD TYPE /sappo/dte_component.
*  DATA : l_tab_fa_fields_dfies  TYPE /sappo/tab_fa_fields_dfies,
*         l_tab_fa_fields_fcat   TYPE /sappo/tab_fa_fields_fcat.
*
*  DATA: l_flg_fa_amnt TYPE xfeld,
*        l_flg_fa_curr TYPE xfeld.
*
**  IF u_component <> /sappo/if_ppo_constants=>con_system_component.
*   IF u_component <> AP-MD.
**   get fa fields for component
*    CALL FUNCTION '/SAPPO/API_FA_GETDETAIL'
*      EXPORTING
*        i_component           = u_component
*      IMPORTING
*        e_tab_fa_fields_db    = l_tab_fa_fields_all
*        e_tab_fa_fields_dfies = l_tab_fa_fields_dfies
*        e_tab_fa_fields_fcat  = l_tab_fa_fields_fcat.
*
*
*  ELSE.
** get components in system
*    CALL FUNCTION '/SAPPO/DB_CMPNT_GET'
*      EXPORTING
*        i_language       = sy-langu
*        i_refresh_buffer = ' '
*      IMPORTING
*        e_tas_cmpnt_t    = l_tab_component.
*
** delete global component from list
**    DELETE l_tab_component WHERE component = /sappo/if_ppo_constants=>con_system_component.
*    DELETE l_tab_component WHERE component = AP-MD.
*
** check if any fa fields are the same for all components
*    LOOP AT l_tab_component INTO l_str_component.
*
**   get fa fields for component
*      CALL FUNCTION '/SAPPO/API_FA_GETDETAIL'
*        EXPORTING
*          i_component           = l_str_component-component
*        IMPORTING
*          e_tab_fa_fields_db    = l_tab_fa_fields
*          e_tab_fa_fields_dfies = l_tab_fa_fields_dfies
*          e_tab_fa_fields_fcat  = l_tab_fa_fields_fcat.
*
*      IF l_tab_fa_fields_all IS INITIAL.
**     first component, store field values as reference table
*        APPEND LINES OF l_tab_fa_fields TO l_tab_fa_fields_all.
*        SORT l_tab_fa_fields_all BY fa_field.
*      ELSE.
*
**     check if fields are the same.
*        LOOP AT l_tab_fa_fields INTO l_str_fa_fields.
*
**       read corresponding line from reference table
*          READ TABLE l_tab_fa_fields_all
*          INTO l_str_fa_fields_all
*            WITH KEY fa_field = l_str_fa_fields-fa_field
*            BINARY SEARCH.
*
*          l_tabix = sy-tabix.
*
**       field already disabled (not enabled)
*          CHECK l_str_fa_fields_all-not_customized <> 'X'.
*
**       check if field binding is the same
*          IF ( l_str_fa_fields-fa_struc_asgt
*               <> l_str_fa_fields_all-fa_struc_asgt )
*             OR ( l_str_fa_fields-fa_field_asgt
*                  <> l_str_fa_fields_all-fa_field_asgt ).
*
**         different, disable field
*            l_str_fa_fields_all-not_customized = 'X'.
*            MODIFY l_tab_fa_fields_all FROM l_str_fa_fields_all
*              INDEX l_tabix TRANSPORTING not_customized.
*
**         delete dfies entries for not costomized fields
*            DELETE l_tab_fa_fields_dfies
*              WHERE fa_field = l_str_fa_fields_all-fa_field.
*
**         delete fcat entries for not costomized fields
*            DELETE l_tab_fa_fields_fcat
*              WHERE fa_field = l_str_fa_fields_all-fa_field.
*
*          ENDIF.
*        ENDLOOP.
*      ENDIF.
*
*    ENDLOOP.
*  ENDIF.
*
** set global variables
*  LOOP AT l_tab_fa_fields_all INTO l_str_fa_fields_all.
*
*    CHECK l_str_fa_fields_all-not_customized <> 'X'.
*
*    CASE l_str_fa_fields_all-fa_field.
*      WHEN 'FA_AMNT'.
*        l_flg_fa_amnt = 'X'.
*      WHEN 'FA_CURR'.
*        l_flg_fa_curr = 'X'.
*      WHEN 'FA1'.
*        g_flg_display_fa1 = 'X'.
*      WHEN 'FA2'.
*        g_flg_display_fa2 = 'X'.
*      WHEN 'FA3'.
*        g_flg_display_fa3 = 'X'.
*      WHEN 'FA4'.
*        g_flg_display_fa4 = 'X'.
*      WHEN 'FA5'.
*        g_flg_display_fa5 = 'X'.
*      WHEN 'FA6'.
*        g_flg_display_fa6 = 'X'.
*    ENDCASE.
*  ENDLOOP.
*
*  IF l_flg_fa_amnt = 'X' AND l_flg_fa_curr = 'X'.
*    g_flg_display_fa_ac = 'X'.
*  ENDIF.
*
** store table as reference table
*  g_tab_fa_fields_db    = l_tab_fa_fields_all.
*  g_tab_fa_fields_dfies = l_tab_fa_fields_dfies.
*  g_tab_fa_fields_fcat  = l_tab_fa_fields_fcat.
*
*ENDFORM.                    " check_display_fa_fields
**&---------------------------------------------------------------------*
**&      Form  CREATE_DEFAULT
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
**      -->P_G_STR_KEY_TABNAME  text
**      <--P_G_TAB_OUTTAB  text
**----------------------------------------------------------------------*
*FORM create_default USING l_structure_name
*                          TYPE tabname
*                    CHANGING c_tab_outtab
*                             TYPE lvc_t_fcat.
*
*  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
*    EXPORTING
*      i_structure_name       = l_structure_name
*    CHANGING
*      ct_fieldcat            = c_tab_outtab
*    EXCEPTIONS
*      inconsistent_interface = 1
*      program_error          = 2
*      OTHERS                 = 3.
*
*  IF sy-subrc <> 0.
*    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*  ENDIF.
*
*ENDFORM.
**&---------------------------------------------------------------------*
**&      Form  GET_RESTRICTIONS
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
**      -->P_G_STR_KEY_TABNAME  text
**      <--P_G_TAB_RESTRICTION  text
**----------------------------------------------------------------------*
*FORM get_restrictions USING     u_tabname         TYPE tabname
*                      CHANGING  c_tab_restriction TYPE /sappo/tab_restriction.
*
*  DATA : l_str_restriction TYPE /sappo/str_restriction,
*         l_str_selopt TYPE /sappo/str_rsdsselopt.
*
** perform set_restriction using tabname
**                               fieldname
**                               L_STR_SELOPT
**                               NO_INTERVALLS
**                               NO_OPTION
**                               NO_SEARCHHELP
**                               NO_DISPLAY
**                               NO_MULTIPLE
**                               NO_INT_CHECK
**                               ONLY_SINGLE
**                               FIELDGROUP
**                         changing l_str_restriction.
*  CLEAR : l_str_selopt.
*  l_str_selopt-sign = 'I'.
*  l_str_selopt-option = 'BT'.
*  l_str_selopt-low = '1'.
*  l_str_selopt-high = '2'.
*  PERFORM set_restriction USING u_tabname
*                                 'STATUS'
*                                 l_str_selopt
*                                 ' '
*                                 ' '
*                                 ' '
*                                 ' '
*                                 ' '
*                                 ' '
*                                 ' '
*                                 '  '
*                            CHANGING l_str_restriction.
*  APPEND l_str_restriction TO c_tab_restriction.
*
*  CLEAR : l_str_selopt.
*  PERFORM set_restriction USING u_tabname
*                                 'CREATE_DATE'
*                                 l_str_selopt
*                                 ' '
*                                 'X'
*                                 ' '
*                                 ' '
*                                 'X'
*                                 ' '
*                                 ' '
*                                 '04'
*                            CHANGING l_str_restriction.
*  APPEND l_str_restriction TO c_tab_restriction.
*
*
*      CLEAR : l_str_selopt.
*    l_str_selopt-sign = 'I'.
*    l_str_selopt-option = 'EQ'.
*    l_str_selopt-low = gv_component.
*    PERFORM set_restriction USING u_tabname
*                                 'COMPONENT'
*                                 l_str_selopt
*                                 ' '
*                                 ' '
*                                 ' '
*                                 'X'
*                                 ' '
*                                 ' '
*                                 ' '
*                                 '  '
*                            CHANGING l_str_restriction.
*    APPEND l_str_restriction TO c_tab_restriction.
*
**  ENDIF.
*
*  PERFORM get_restrictions_new_fields
*                    USING    u_tabname
*                    CHANGING c_tab_restriction.
*
*
*ENDFORM.                    " get_restrictions
**&---------------------------------------------------------------------*
**&      Form  SET_RESTRICTION
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
**      -->P_U_TABNAME  text
**      -->P_0946   text
**      -->P_L_STR_SELOPT  text
**      -->P_0948   text
**      -->P_0949   text
**      -->P_0950   text
**      -->P_0951   text
**      -->P_0952   text
**      -->P_0953   text
**      -->P_0954   text
**      -->P_0955   text
**      <--P_L_STR_RESTRICTION  text
**----------------------------------------------------------------------*
*FORM set_restriction USING    u_tabname           TYPE any
*                              u_fieldname         TYPE any
*                              u_str_selopt        TYPE /sappo/str_rsdsselopt
*                              u_no_intervalls     TYPE any
*                              u_no_option         TYPE any
*                              u_no_searchhelp     TYPE any
*                              u_no_display        TYPE any
*                              u_no_multiple       TYPE any
*                              u_no_int_check      TYPE any
*                              u_only_singles      TYPE any
*                              u_fieldgroup        TYPE any
*                     CHANGING c_str_restriction   TYPE /sappo/str_restriction.
*
*  CLEAR : c_str_restriction.
*  c_str_restriction-tabname        = u_tabname.
*  c_str_restriction-fieldname      = u_fieldname.
*  c_str_restriction-l_str_selopt   = u_str_selopt.
*  c_str_restriction-no_intervalls  = u_no_intervalls.
*  c_str_restriction-no_option      = u_no_option.
*  c_str_restriction-no_searchhelp  = u_no_searchhelp.
*  c_str_restriction-no_display     = u_no_display.
*  c_str_restriction-no_multiple    = u_no_multiple.
*  c_str_restriction-no_int_check   = u_no_int_check.
*  c_str_restriction-only_singles   = u_only_singles.
*  c_str_restriction-fieldgroup     = u_fieldgroup.
*
*ENDFORM.                    " set_restriction
*
**&---------------------------------------------------------------------*
**&      Form  SELECT_VARIANT
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
**      -->P_G_STR_KEY  text
**      -->P_G_TAB_RESTRICTION  text
**      <--P_G_TAB_OUTTAB  text
**      <--P_G_TAB_FIELDRANGE  text
**----------------------------------------------------------------------*
*FORM select_variant USING    u_str_key          TYPE /sappo/str_filter_key
*                             u_tab_restriction  TYPE /sappo/tab_restriction
*                    CHANGING c_tab_outtab       TYPE lvc_t_fcat
*                             c_tab_fieldrange   TYPE /sappo/tab_filter_fieldrange.
*
*  CALL FUNCTION '/SAPPO/API_FILTER_SELECT_VAR'
*    EXPORTING
*      i_str_key         = u_str_key
*      i_tab_restriction = u_tab_restriction
*    IMPORTING
*      e_tab_outtab      = c_tab_outtab
*      e_tab_fieldrange  = c_tab_fieldrange
*    EXCEPTIONS
*      no_valid_variant  = 1
*      OTHERS            = 2.
*
*  gv_variantname = u_str_key-variantname.
*
*ENDFORM.
**&---------------------------------------------------------------------*
**&      Form  UPDATE_SELECTOPTIONS
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
**      -->P_G_STR_KEY  text
**      -->P_G_TAB_OUTTAB  text
**      -->P_G_TAB_FIELDRANGE  text
**----------------------------------------------------------------------*
*FORM update_selectoptions USING u_str_key        TYPE /sappo/str_filter_key
*                                u_tab_outtab     TYPE lvc_t_fcat
*                                u_tab_fieldrange TYPE /sappo/tab_filter_fieldrange.
*
*  DATA: l_str_fa TYPE /sappo/str_fa_fields_db,
*        l_str_fieldrange TYPE /sappo/str_filter_fieldrange,
*        l_str_range      TYPE /sappo/str_rsdsselopt,
*        l_str_outtab     TYPE lvc_s_fcat.
*
*  DATA: selname(20) TYPE c,
*        dynname(20) TYPE c,
*        l_tabix TYPE sytabix.
*
*  FIELD-SYMBOLS: <f1> TYPE any,
*                 <f2> TYPE any.
*
*  DATA: l_string(10) TYPE c.
*
*  PERFORM initialize_selectoptions.
*
*  LOOP AT u_tab_outtab INTO l_str_outtab.
*
*    READ TABLE g_tab_reftab
*      WITH KEY fieldname = l_str_outtab-fieldname
*      TRANSPORTING NO FIELDS.
*
*    l_tabix = sy-tabix.
*
*    WRITE l_tabix TO l_string LEFT-JUSTIFIED.
*
*    CONCATENATE 'gf_dynnr' l_string INTO dynname.         "#EC NOTEXT
*    ASSIGN (dynname) TO <f1>.
*
*    CONCATENATE 'SELNAME' l_string INTO selname.
*    ASSIGN (selname) TO <f2>.
*
*    IF l_str_outtab-fieldname CS 'FA' AND
*       l_str_outtab-fieldname <> 'FAIL_MODE'.
*
*      READ TABLE g_tab_fa_fields_db INTO l_str_fa
*        WITH KEY fa_field = l_str_outtab-fieldname
*        BINARY SEARCH.
*
*      IF sy-subrc <> 0.
*        <f1> = 200.
*      ELSE.
*        IF l_str_fa-not_customized = 'X'.
*          <f1> = 200.
*        ELSE.
*          <f1> = 200 + l_tabix.
*          CONCATENATE l_str_fa-fa_struc_asgt
*                      '-'
*                      l_str_fa-fa_field_asgt
*                      INTO <f2>.
*        ENDIF.
*      ENDIF.
*    ELSE.
*      <f1> = 200 + l_tabix.
*      CONCATENATE u_str_key-tabname
*                  '-'
*                  l_str_outtab-fieldname
*                  INTO <f2>.
*
*    ENDIF.
*
*    READ TABLE u_tab_fieldrange INTO l_str_fieldrange
*      WITH KEY tabname   = u_str_key-tabname
*               fieldname = l_str_outtab-fieldname.
*
*    IF sy-subrc = 0.
*
*      LOOP AT l_str_fieldrange-range INTO l_str_range.
*        CASE l_tabix.
*
**          WHEN 3.
**            MOVE-CORRESPONDING l_str_range TO s_sel3.
**            APPEND s_sel3.
**          WHEN 18.
**            MOVE-CORRESPONDING l_str_range TO s_sel18.
**            APPEND s_sel18.
*
*        ENDCASE.
*      ENDLOOP.
*    ENDIF.
*  ENDLOOP.
*
*  gv_variantname = g_str_key-variantname.
*
*ENDFORM.                    " update_selectoptions
**&---------------------------------------------------------------------*
**&      Form  FILL_DEFAULT
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
**  -->  p1        text
**  <--  p2        text
**----------------------------------------------------------------------*
*FORM FILL_DEFAULT .
**DATA: l_str_fieldrange TYPE /sappo/str_filter_fieldrange,
**        l_str_range      TYPE /sappo/str_rsdsselopt.
**
**  IF gv_component = 'AP-MD'.
**    REFRESH l_str_fieldrange-range.
**    CLEAR: l_str_range, l_str_fieldrange.
**
**    l_str_fieldrange-tabname   = g_str_key-tabname.
**    l_str_fieldrange-fieldname = 'COMPONENT'.
**    l_str_range-sign   = 'I'.
**    l_str_range-option = 'EQ'.
**    l_str_range-low    = gv_component.
**
**    APPEND l_str_range TO l_str_fieldrange-range.
**    APPEND l_str_fieldrange TO g_tab_fieldrange.
**  ENDIF.
**
*** set default status
**  REFRESH l_str_fieldrange-range.
**  CLEAR: l_str_range, l_str_fieldrange.
**
**  l_str_fieldrange-tabname   = g_str_key-tabname.
**  l_str_fieldrange-fieldname = 'STATUS'.
**  l_str_range-sign   = 'I'.
**  l_str_range-option = 'BT'.
**  l_str_range-low    = '1'.
**  l_str_range-high   = '2'.
**
**  APPEND l_str_range TO l_str_fieldrange-range.
**  APPEND l_str_fieldrange TO g_tab_fieldrange.
**
*** set default processing method
**  REFRESH l_str_fieldrange-range.
**  CLEAR: l_str_range, l_str_fieldrange.
**
**  l_str_fieldrange-tabname   = g_str_key-tabname.
**  l_str_fieldrange-fieldname = 'PROCMETH'.
**  l_str_range-sign   = 'I'.
**  l_str_range-option = 'BT'.
**  l_str_range-low    = '2'.
**  l_str_range-high   = '3'.
**
**  APPEND l_str_range TO l_str_fieldrange-range.
**  APPEND l_str_fieldrange TO g_tab_fieldrange.
**
*** set default object category
**  REFRESH l_str_fieldrange-range.
**  CLEAR: l_str_range, l_str_fieldrange.
**
**  l_str_fieldrange-tabname   = g_str_key-tabname.
**  l_str_fieldrange-fieldname = 'OBJ_CAT'.
**  l_str_range-sign   = 'I'.
**  l_str_range-option = 'EQ'.
**  l_str_range-low    = '1'.
**
**  APPEND l_str_range TO l_str_fieldrange-range.
**  APPEND l_str_fieldrange TO g_tab_fieldrange.
**
*** set default worklist mode
**  REFRESH l_str_fieldrange-range.
**  CLEAR: l_str_range, l_str_fieldrange.
**
**  l_str_fieldrange-tabname   = g_str_key-tabname.
**  l_str_fieldrange-fieldname = 'WORKLIST'.
**  l_str_range-sign   = 'I'.
**  l_str_range-option = 'EQ'.
**  l_str_range-low    = g_worklist_mode.
**
**  APPEND l_str_range TO l_str_fieldrange-range.
**  APPEND l_str_fieldrange TO g_tab_fieldrange.
**
**
*** !!! remove object category IF other object fields are removed
**
**  IF g_flg_display_fa1 IS INITIAL.
**    DELETE g_tab_outtab
**      WHERE fieldname = 'FA1'.
**  ENDIF.
**
**  IF g_flg_display_fa2 IS INITIAL.
**    DELETE g_tab_outtab
**      WHERE fieldname = 'FA2'.
**  ENDIF.
**
**  IF g_flg_display_fa3 IS INITIAL.
**    DELETE g_tab_outtab
**      WHERE fieldname = 'FA3'.
**  ENDIF.
**
**  IF g_flg_display_fa4 IS INITIAL.
**    DELETE g_tab_outtab
**      WHERE fieldname = 'FA4'.
**  ENDIF.
**
**  IF g_flg_display_fa5 IS INITIAL.
**    DELETE g_tab_outtab
**      WHERE fieldname = 'FA5'.
**  ENDIF.
**
**  IF g_flg_display_fa6 IS INITIAL.
**    DELETE g_tab_outtab
**      WHERE fieldname = 'FA6'.
**  ENDIF.
**
**  IF g_flg_display_fa_ac IS INITIAL.
**    DELETE g_tab_outtab
**      WHERE fieldname = 'FA_AMNT'
**         OR fieldname = 'FA_CURR'.
**  ENDIF.
*
*
*ENDFORM.                    " FILL_DEFAULT
*&---------------------------------------------------------------------*
*&      Module  STATUS_1143  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_1143 OUTPUT.
  SET PF-STATUS 'STAT'.
*  SET TITLEBAR 'xxx'.

ENDMODULE.                 " STATUS_1143  OUTPUT
