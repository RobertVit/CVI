*----------------------------------------------------------------------*
***INCLUDE CVI_UPGRADE_CHECK_RESOLVE_CF02 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  CREATE_BPS_WITH_UNSUP_ROLES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CREATE_BPS_WITH_UNSUP_ROLES .


  refresh gt_partners_fcat.
  gs_fcat-fieldname = 'PARTNER'.
  gs_fcat-tabname = 'BUT100'.
  gs_fcat-col_pos = 1.
  gs_fcat-outputlen = 20.
  gs_fcat-coltext   = 'Business Partner Number'(040).
  gs_fcat-ROLLNAME = 'PARTNER'.
  gs_fcat-DATATYPE = 'BU_PARTNER'.
  append gs_fcat to  gt_partners_fcat.
  clear gs_fcat.

  gs_fcat-fieldname = 'RLTYP'.
  gs_fcat-tabname = 'BUT100'.
  gs_fcat-col_pos = 2.
  gs_fcat-outputlen = 13.
  gs_fcat-coltext   = 'BP Role'(003).
  gs_fcat-ROLLNAME = 'RLTYP'.
  gs_fcat-DATATYPE = 'BU_PARTNERROLE'.
  append gs_fcat to  gt_partners_fcat.
  clear gs_fcat.


* create container for partners display

if gr_partners_cc is initial.
  create object gr_partners_cc
    exporting
      container_name = 'PARTNERS_CUSTOM_CONTROL'.
endif.
*create ALV object for partners
if  gr_partners_alv is initial.
  create object  gr_partners_alv
    exporting
      i_parent = gr_partners_cc.
endif.



*ENDIF.
ENDFORM.                    " CREATE_BPS_WITH_UNSUP_ROLES
