*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_FG_PRECHK_SUP
*   generation date: 24.07.2019 at 07:11:48
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_FG_PRECHK_SUP      .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
