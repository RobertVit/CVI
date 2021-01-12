*&---------------------------------------------------------------------*
*& Report  CVI_MAPPING_LEGAL_FORM
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  CVI_MAPPING_LEGAL_FORM message-id cvi_mapping..

include CVI_MAPPING_CONSTANTS.

data: lt_tvgf  type table of tvgf,
      ls_tvgf  like line of lt_tvgf,
      lt_tvgft type table of tvgft,
      ls_tvgft like line of lt_tvgft.

data: lt_tb019 type table of tb019,
      ls_tb019 like line of lt_tb019,
      lt_tb020 type table of tb020,
      ls_tb020 like line  of lt_tb020.

data: ls_CVIC_LEGFORM_LNK type CVIC_LEGFORM_LNK.

data: lc_open_checkboxes type i value 2. "2 = number of radio boxes on screen

parameter: p_gf_19 as checkbox,
           p_19_gf as checkbox.


load-of-program.

  AUTHORITY-CHECK OBJECT 'CVI_CUST'
           ID 'CVI_ACTVT' FIELD gc_authority_start_report.

  if sy-subrc <> 0.
    message s014 display like 'E'.
  endif.


  select * from: tvgf  into table lt_tvgf,
                 tvgft into table lt_tvgft,
                 tb019 into table lt_tb019,
                 tb020 into table lt_tb020.


AT SELECTION-SCREEN OUTPUT.

  LOOP AT SCREEN.

    case screen-name.
      when 'P_GF_19'.
        if not lt_tb019[] is initial.
          screen-input = '0'.
          lc_open_checkboxes = lc_open_checkboxes - 1.
        endif.
      when 'P_19_GF'.
        if not lt_tvgf[] is initial.
          screen-input = '0'.
          lc_open_checkboxes = lc_open_checkboxes - 1.
        endif.
      when others.
        "do nothing.
    endcase.

    MODIFY SCREEN.

  ENDLOOP.



start-of-selection.

  authority-check object 'CVI_CUST'
           id 'CVI_ACTVT' field gc_authority_start_report.

  if sy-subrc <> 0.
    message s014 display like 'E'.
    return.
  endif.

  if lc_open_checkboxes = 0.
* Report cannot run if there is not a single radiobutton open for tipping
    message s028 display like 'E'.
    return.
  endif.

  if p_gf_19 is initial and
     p_19_gf is initial.
* No checkbox selected.
    message s027 display like 'E'.
    return.
  endif.


  case 'X'.
    when p_gf_19. "Table TVGF -> TB019


      loop at lt_tvgf into ls_tvgf.

* target table
        clear ls_tb019.
        ls_tb019-LEGAL_ENTY = ls_tvgf-GFORM.
        ls_tb019-CLIENT = ls_tvgf-MANDT.

        insert tb019 from ls_tb019.
        if sy-subrc <> 0.
          rollback work.                               "#EC CI_ROLLBACK
          message e008 with 'TB019'.
          return.
        endif.

*link table
        clear ls_CVIC_LEGFORM_LNK.
        ls_CVIC_LEGFORM_LNK-GFORM      = ls_tvgf-GFORM.
        ls_CVIC_LEGFORM_LNK-LEGAL_ENTY = ls_tvgf-GFORM. "the same

        insert CVIC_LEGFORM_LNK from ls_CVIC_LEGFORM_LNK.
        if sy-subrc <> 0.
          rollback work.                               "#EC CI_ROLLBACK
          message e008 with 'CVIC_LEGFORM_LNK'.
          return.
        endif.

      endloop.



* texts
      loop at lt_tvgft into ls_tvgft.

        clear ls_tb020.
        ls_tb020-SPRAS      = ls_tvgft-SPRAS.
        ls_tb020-LEGAL_ENTY = ls_tvgft-GFORM.
        ls_tb020-TEXTSHORT  = ls_tvgft-VTEXT.
        ls_tb020-TEXTLONG   = ls_tvgft-VTEXT.
        insert tb020 from ls_tb020.

        if sy-subrc <> 0.
          rollback work.                               "#EC CI_ROLLBACK
          message e008 with 'TB020'.
          return.
        endif.

      endloop.

      commit work.

      clear: p_gf_19,
                 p_19_gf.

      message s009.





    when p_19_gf. "Table TB019 -> TVGF

      loop at lt_tb019 into ls_tb019.

* target table
        clear ls_tvgf.
        ls_tvgf-GFORM = ls_tb019-LEGAL_ENTY.

        insert tvgf from ls_tvgf.
        if sy-subrc <> 0.
          rollback work.                               "#EC CI_ROLLBACK
          message e008 with 'TVGF'.
          return.
        endif.

* link table
        clear ls_CVIC_LEGFORM_LNK.
        ls_CVIC_LEGFORM_LNK-GFORM      = ls_tb019-LEGAL_ENTY.
        ls_CVIC_LEGFORM_LNK-LEGAL_ENTY = ls_tb019-LEGAL_ENTY. "the same

        insert CVIC_LEGFORM_LNK from ls_CVIC_LEGFORM_LNK.
        if sy-subrc <> 0.
          rollback work.                               "#EC CI_ROLLBACK
          message e008 with 'CVIC_LEGFORM_LNK'.
          return.
        endif.


      endloop.


* texts
      loop at lt_tb020 into ls_tb020.

        clear ls_tvgft.
        ls_tvgft-SPRAS = ls_tb020-SPRAS.
        ls_tvgft-GFORM = ls_tb020-LEGAL_ENTY.
        ls_tvgft-VTEXT = ls_tb020-TEXTSHORT.
        insert tvgft from ls_tvgft.

        if sy-subrc <> 0.
          rollback work.                               "#EC CI_ROLLBACK
          message e008 with 'TVGFT'.
          return.
        endif.

      endloop.

      commit work.

      clear: p_gf_19,
                 p_19_gf.

      message s009.

    when others.

      message s010.

  endcase.
