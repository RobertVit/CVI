*----------------------------------------------------------------------*
***INCLUDE CVI_UPGRADE_CHECK_RESOLVE_SF02 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SHOW_ROLES_FOR_UNASSIGNMENT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SHOW_ROLES_FOR_UNASSIGNMENT .

*
  call method gr_roles_alv->REGISTER_EDIT_EVENT
    EXPORTING
      I_EVENT_ID = CL_GUI_ALV_GRID=>MC_EVT_MODIFIED.

gs_layout_default-grid_title = 'Select roles'.




  perform show_table_alv  using    gr_roles_alv
                                   gs_layout_default
                          changing gt_roles
                                   gt_roles_fcat.


set handler lcl_event_handler=>on_data_change_role for gr_roles_alv.
set handler lcl_event_handler=>on_toolbar_unsupp_role for gr_roles_alv.



ENDFORM.                    " SHOW_ROLES_FOR_UNASSIGNMENT
