*----------------------------------------------------------------------*
***INCLUDE CVI_UPGRADE_CHECK_RESOLVE_SF03 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SHOW_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SHOW_LOG .


 data: ls_unsup_bprole_log like line of gt_unsup_bprole_log.

 clear gt_unsup_bprole_log.
 refresh gt_unsup_bprole_log.

LOOP AT SCREEN.

  if screen-name eq 'PARTNERS'.
  if gt_partners is INITIAL.
      ls_unsup_bprole_log-log = 'No Business Partners with unsupported role assignments'.
      ls_unsup_bprole_log-chk = 'CHK_BP_UNSUPP_ROLE'.
      ls_unsup_bprole_log-icon = gv_icon_green.
      append ls_unsup_bprole_log to gt_unsup_bprole_log.
      clear ls_unsup_bprole_log.
    else.
      ls_unsup_bprole_log-log = 'Unsupported role assigments: One or more Business Partner(s) contain unsupported role assignments'.
      ls_unsup_bprole_log-chk = 'CHK_BP_UNSUPP_ROLE'.
      ls_unsup_bprole_log-icon = gv_icon_red.
      append ls_unsup_bprole_log to gt_unsup_bprole_log.
      clear ls_unsup_bprole_log.
    endif.

ENDIF.

 if screen-name eq 'DELETE'.
      if gt_partners is INITIAL.
        screen-input = '0'.
        ELSE.
          screen-input = '1'.
        ENDIF.
        MODIFY SCREEN.
ENDIF.


  ENDLOOP.


  perform show_table_alv using   gr_partners_log_alv
                               gs_layout_cust_log
                      changing gt_unsup_bprole_log[]
                               gt_fieldcat_cust_log.

ENDFORM.                    " SHOW_LOG
