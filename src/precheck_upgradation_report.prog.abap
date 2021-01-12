report precheck_upgradation_report.

types : begin of ty_check,
          chkid(6) type c,
          chk_name type string,
          check    type char1,
          lt_styl  type lvc_t_styl,
        end of ty_check.

types : begin of ty_check_final,
          chkid(6) type c,
          chk_name type string,
          status   type icon_d,
          stat_chk type string,
          lt_styl  type lvc_t_styl,
          err_type type string,
          color type LVC_T_SCOL,
        end of ty_check_final.

types : begin of ty_msg,
          chkid(6) type c,
          status   type icon_d,
          msg_name type string,
          tabname  type string,
          client   type mandt,
          lt_styl  type lvc_t_styl,
        end of ty_msg.
types ty_return_code type i .
types:
  begin of ty_preprocessing_check_result,
    software_component    type dlvunit,
    check_id              type c length 40,   "to be chosen as needed
    description           type c length 255,  " must contain the SAP note that describes the check, provides further information and how to deal with possible problems.
    return_code           type ty_return_code,
    application_component type ufps_posid,    " Application component for BCP customer incident, if the customer has to open a ticket with questions about the check.
  end   of ty_preprocessing_check_result .
types:
  tt_preprocessing_check_results type standard table of ty_preprocessing_check_result.
data: gt_check_results type tt_preprocessing_check_results with header line,
      gs_check_results like line of gt_check_results.

data : gt_check_final type table of ty_check_final,
       gs_check_final like line of gt_check_final.
data : gt_fcat type lvc_t_fcat.
data : gt_fcat_final type lvc_t_fcat.

data : gt_check_msg type table of ty_msg,
       gt_msg_check type table of ty_msg,
       gs_msg_check like line of gt_msg_check,
       gs_check_msg like line of gt_check_msg,
       gt_fcat_msg  type lvc_t_fcat.

data : gt_check type table of ty_check.
data : gs_check like line of gt_check.
data : ok_code type sy-ucomm.
data : ok_code_200 type sy-ucomm.

data gt_check_msg_final type table of ty_msg.
data ok_code_0201 type sy-ucomm.
data gv_title type sy-title.

data : gs_input type i.

data : gv_kna1 type i,
       gv_lfa1 type i,
       gv_kna1_retail type i,
       gv_kna1_final type i,
       gv_lfa1_retail type i,
       gv_lfa1_final type i,
       gv_cust_link type i,
       gv_vend_link type i.

  data : gs_kna1 type string,
         gs_lfa1 type string,
         gs_kna1_final type string,
         gs_lfa1_final type string,
         gv_check_cust type string,
         gv_check_vend type string.

DATA  gv_current_client TYPE etonoff.
*&---------------------------------------------------------------------*

*& Class lcl_class
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
class lcl_class definition final.

  public section.
    class-methods on_toolbar for event toolbar of cl_gui_alv_grid importing e_object.

    class-methods : on_hotspot  for event hotspot_click   of cl_gui_alv_grid   importing e_row_id  .
    class-methods : on_hotspot_new  for event hotspot_click   of cl_gui_alv_grid   importing e_row_id  .
    class-methods : on_data_change for event data_changed of cl_gui_alv_grid importing   er_data_changed .
    class-methods : on_data_change_finished  for event data_changed_finished  of cl_gui_alv_grid importing    e_modified et_good_cells. .

endclass.                    "lcl_class DEFINITION

*----------------------------------------------------------------------*
*       CLASS lcl_class IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
class lcl_class implementation.
  method on_toolbar.
    data: ls_toolbar type stb_button.
    data : lv_disabled type c.
    include precheck_toolbar_include.
    delete table e_object->mt_toolbar with table key function = '&LOCAL&INSERT_ROW'.
    delete table e_object->mt_toolbar with table key function = '&LOCAL&DELETE_ROW'.
    clear ls_toolbar.

  endmethod.                    "on_toolbar

  method on_hotspot.
    data : ls_check_msg like line of gt_check_msg.
    refresh gt_check_msg_final.
    refresh gt_check_msg.
    read table gt_check_final into gs_check_final index e_row_id-index.
*    if sy-subrc = 0 and gs_check_final-stat_chk = 'E'.
    if sy-subrc = 0.
      if gv_current_client = 'X'.
         case gs_check_final-chkid .
        when 'CHK_1' or 'CHK_7'.
          gv_title =  'BP roles are not assigned to account groups' ."text-020.
           perform CHK_OP1_CLNT.
        when 'CHK_2' or 'CHK_8'.
          gv_title =  'BP Grouping is not available for account groups'."text-021.
           perform CHK_OP2_CLNT.
        when 'CHK_3' or 'CHK_9'.
          gv_title =  'CVI Mapping not maintained'. "text-023.
          perform chk_op3_clnt.
        when 'CHK_4'." or 'CHK_10'.
          gv_title =  'Customer Value Mapping not maintained'." (BP->Customer)'. "text-023.
          perform chk_op4_clnt.
        when 'CHK_5'.
          gv_title =  'Vendor Value Mapping not maintained'."text-024.
          perform chk_op5_clnt.
        when 'CHK_12'.
          gv_title = 'CVI_LINK not established'.
          perform chk_op12.
        when 'CHK_6' or 'CHK_11'.
          gv_title =  'Contact Person Mapping not maintained' ."text-029.
          perform chk_op6_clnt.
        when 'CHK_10'.
          gv_title =  'Customer and Vendor Value Mapping not maintained(BP->Customer or Vendor)'. "text-023.
          perform chk_op10_clnt.
      endcase.
      else.
      case gs_check_final-chkid .
        when 'CHK_1' or 'CHK_7'.
          gv_title =  'BP roles are not assigned to account groups' ."text-020.
          perform chk_op1.
        when 'CHK_2' or 'CHK_8'.
          gv_title =  'BP Grouping is not available for account groups'."text-021.
          perform chk_op2.
        when 'CHK_3' or 'CHK_9'.
          gv_title =  'CVI Mapping not maintained'. "text-023.
          perform chk_op3.
        when 'CHK_4'." or 'CHK_10'.
*          gv_title =  'Customer and Vendor Value mapping(BP->Customer or Vendor)'. "text-023.
          gv_title =  'Customer Value Mapping not maintained'." (BP->Customer)'. "text-023.
          perform chk_op4.
        when 'CHK_5'.
*          gv_title =  'Customer Value Mapping not maintained'."text-024.
          gv_title =  'Vendor Value Mapping not maintained'."text-024.
          perform chk_op5.
        when 'CHK_12'.
          gv_title = 'CVI_LINK not established'.
          perform chk_op12.
        when 'CHK_6' or 'CHK_11'.
          gv_title =  'Contact Person Mapping not maintained' ."text-029.
          perform chk_op6.
        when 'CHK_10'.
          gv_title =  'Customer and Vendor Value Mapping not maintained(BP->Customer or Vendor)'. "text-023.
          perform chk_op10.
      endcase.
endif.

      loop at gt_check_msg into ls_check_msg where chkid = gs_check_final-chkid.
        append ls_check_msg to gt_check_msg_final.
        clear ls_check_msg.
      endloop.

      call screen 0201 starting at 30 100.
    endif.
  endmethod.                    "on_hotspot

  method   on_data_change.
    data :  ls_cell         type        lvc_s_modi.

    loop at er_data_changed->mt_mod_cells into ls_cell.
      clear gs_check.
      read table gt_check into gs_check index ls_cell-row_id.
      if sy-subrc = 0 and ( gs_check-chkid <> 'CHK_3' and  gs_check-chkid <> 'CHK_6').
        gs_check-check = ls_cell-value.
        modify  gt_check from  gs_check index ls_cell-row_id  .
      endif.
    endloop.

  endmethod.                    "on_data_change

  method on_data_change_finished.
    data  : lt_data_modi type lvc_t_modi,
            ls_data_modi type lvc_s_modi.
    if e_modified = 'X'.
      lt_data_modi = et_good_cells.
      loop at lt_data_modi into ls_data_modi.
        clear gs_check.
        read table gt_check into gs_check index ls_data_modi-row_id.
        if sy-subrc = 0  and ( gs_check-chkid <> 'CHK_3' and  gs_check-chkid <> 'CHK_6' and gs_check-chkid <> 'CHK_12').

        else.
          gs_check-check = 'X'.
          modify  gt_check from  gs_check index ls_data_modi-row_id  transporting check .
          message 'Mandatory checks cannot be unchecked ' type 'S' display like 'E'.

        endif.
      endloop.
    endif.
    leave to screen 100.

  endmethod.                    "on_data_change_finished

  method on_hotspot_new.
    data : ls_check_msg like line of gt_check_msg_final.
    data : lt_img_activities type table of cus_imgach,
           ls_img_activities like line of lt_img_activities.

    read table gt_check_msg_final into ls_check_msg index e_row_id-index.
    if sy-subrc = 0 .
      if ls_check_msg-client eq sy-mandt.
        if ls_check_msg-tabname eq 'CVI_CUST_LINK' or
           ls_check_msg-tabname eq 'CVI_VEND_LINK' or
           ls_check_msg-tabname eq 'CVI_CUST_CT_LINK' or
           ls_check_msg-tabname eq 'CVI_VEND_CT_LINK'.
*        call TRANSACTION 'MDS_LOAD_COCKPIT'.
          call function 'ABAP4_CALL_TRANSACTION'
            exporting
              tcode = 'MDS_LOAD_COCKPIT'
*             SKIP_SCREEN                   = ' '
*             MODE_VAL                      = 'A'
*             UPDATE_VAL                    = 'A'
*         IMPORTING
*             SUBRC =
*         TABLES
*             USING_TAB                     =
*             SPAGPA_TAB                    =
*             MESS_TAB                      =
*         EXCEPTIONS
*             CALL_TRANSACTION_DENIED       = 1
*             TCODE_INVALID                 = 2
*             OTHERS                        = 3
            .
          if sy-subrc <> 0.
* Implement suitable error handling here
          endif.
        else.
          ls_img_activities-activity   = ls_check_msg-tabname.
          ls_img_activities-attributes = ls_check_msg-tabname.
          ls_img_activities-c_activity = ls_check_msg-tabname.
          append ls_img_activities to lt_img_activities.
          call function 'S_CUS_IMG_ENTRY_VIA_ACTIVITY'
            exporting
              project_number_obligatory = 'X'
              activity                  = 'M'
              language                  = sy-langu
            tables
              img_activities            = lt_img_activities
            exceptions
              no_activities_given       = 1
              not_found_in_img          = 2
              not_found_in_project      = 3
              others                    = 4.
        endif.
      endif.
    endif.
    clear : ls_img_activities.
    refresh : lt_img_activities.
  endmethod.                    "on_hotspot_new

endclass.                    "lcl_class IMPLEMENTATION


start-of-selection.

  call screen 100.

end-of-selection.

  include pre_check_upg_status_0100o01.

  include pre_check_upg_user_commani01.

  include pre_check_upgrade_bal_logf01.

INCLUDE PRECHECK_UPGRADATION_REPORTF01.
