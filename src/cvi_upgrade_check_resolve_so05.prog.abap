*----------------------------------------------------------------------*
***INCLUDE CVI_UPGRADE_CHECK_RESOLVE_SO05 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_0230  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_0230 OUTPUT.

  SET PF-STATUS 'CVI_FS_C_G_G_DEFAULT'.
  SET TITLEBAR 'CVI_G_NUMBER_RANGE'.

  PERFORM SHOW_ALL_NUMBER_RANGES.
  PERFORM SHOW_OVERLAP_NUMBER_RANGES.
  PERFORM SHOW_NEW_NUMBER_RANGES.


ENDMODULE.                 " STATUS_0230  OUTPUT
