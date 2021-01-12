*----------------------------------------------------------------------*
***INCLUDE CVI_UPGRADE_CHECK_RESOLVE_SO04 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_0220  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_0220 OUTPUT.
  SET PF-STATUS 'STATUS_0210'. " 'CVI_FS_C_G_G_DEFAULT'. changed to include 'Next' button
  SET TITLEBAR 'CVI_G_UNSUPPOR_ROLES'.
  PERFORM GET_BPS_WITH_UNSUP_ROLES.
  PERFORM CREATE_BPS_WITH_UNSUP_ROLES.
  PERFORM SHOW_BPS_WITH_UNSUP_ROLES.

  PERFORM GET_ROLES_FOR_UNASSIGNMENT.
  PERFORM PREP_ROLES_FOR_UNASSIGNMENT.
  PERFORM SHOW_ROLES_FOR_UNASSIGNMENT.

  PERFORM PREP_LOG.
  PERFORM SHOW_LOG.

ENDMODULE.                 " STATUS_0220  OUTPUT
