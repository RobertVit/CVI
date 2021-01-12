*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 24.07.2019 at 07:11:49
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: CVI_PRECHK_SUP..................................*
DATA:  BEGIN OF STATUS_CVI_PRECHK_SUP                .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_CVI_PRECHK_SUP                .
CONTROLS: TCTRL_CVI_PRECHK_SUP
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *CVI_PRECHK_SUP                .
TABLES: CVI_PRECHK_SUP                 .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
