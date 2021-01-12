*&---------------------------------------------------------------------*
*& Report  CVI_MAPPING_CONTACTS
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  CVI_MAPPING_CONTACTS message-id cvi_mapping.


include CVI_MAPPING_CONSTANTS.

data: lt_tsab  type table of tsab,
      ls_tsab like line of lt_tsab,
*
      lt_tsabt  type table of tsabt,
      ls_tsabt like line of lt_tsabt,
*
      lt_tb910 type table of tb910,
      ls_tb910 like line of lt_tb910,
*
      lt_tb911t type table of tb911,
      ls_tb911t like line of lt_tb911t,
*
      ls_CVIC_CP1_LINK type CVIC_CP1_LINK,
***********************************************
      lt_tpfk  type table of tpfk,
      ls_tpfk like line of lt_tpfk,
*
      lt_tpfkt  type table of tpfkt,
      ls_tpfkt like line of lt_tpfkt,
*
      lt_tb912 type table of tb912,
      ls_tb912 like line of lt_tb912,
*
      lt_tb913t type table of tb913,
      ls_tb913t like line of lt_tb913t,
*
      ls_CVIC_CP2_LINK type CVIC_CP2_LINK,
***********************************************
      lt_tvpv  type table of tvpv,
      ls_tvpv like line of lt_tvpv,
*
      lt_tvpvt  type table of tvpvt,
      ls_tvpvt like line of lt_tvpvt,
*
      lt_tb914 type table of tb914,
      ls_tb914 like line of lt_tb914,
*
      lt_tb915t type table of tb915,
      ls_tb915t like line of lt_tb915t,
*
      ls_CVIC_CP3_LINK type CVIC_CP3_LINK,
***********************************************
      lt_tvip  type table of tvip,
      ls_tvip like line of lt_tvip,
*
      lt_tvipt  type table of tvipt,
      ls_tvipt like line of lt_tvipt,
*
      lt_tb916 type table of tb916,
      ls_tb916 like line of lt_tb916,
*
      lt_tb917t type table of tb917,
      ls_tb917t like line of lt_tb917t,
*
      ls_CVIC_CP4_LINK type CVIC_CP4_LINK,
***********************************************
      lt_t502t type table of t502t,
      ls_t502t like line of lt_t502t,
*
      lt_tb027 type table of tb027,
      lt_tb027_temp TYPE TABLE OF tb027,
      ls_tb027 like line of lt_tb027,
*
      lt_tb027t type table of tb027t,
      lt_tb027t_temp type table of tb027t,
      ls_tb027t like line of lt_tb027t,
*
      lt_CVIC_MARST_LINK_temp type table of CVIC_MARST_LINK,
      ls_CVIC_MARST_LINK type CVIC_MARST_LINK.
***********************************************

data: lc_open_checkboxes type i value 10. "10 = number of radio boxes on screen

***********************************************
SELECTION-SCREEN BEGIN OF BLOCK p1
                          WITH FRAME TITLE title1.
parameters: p_ab_10 as checkbox,
            p_10_ab as checkbox.
SELECTION-SCREEN END OF BLOCK p1.

SELECTION-SCREEN BEGIN OF BLOCK p2
                          WITH FRAME TITLE title2.
parameters: p_fk_12 as checkbox,
            p_12_fk as checkbox.
SELECTION-SCREEN END OF BLOCK p2.

SELECTION-SCREEN BEGIN OF BLOCK p3
                          WITH FRAME TITLE title3.
parameters: p_pv_14 as checkbox,
            p_14_pv as checkbox.
SELECTION-SCREEN END OF BLOCK p3.

SELECTION-SCREEN BEGIN OF BLOCK p4
                          WITH FRAME TITLE title4.
parameters: p_ip_16 as checkbox,
            p_16_ip as checkbox.
SELECTION-SCREEN END OF BLOCK p4.

SELECTION-SCREEN BEGIN OF BLOCK p5
                          WITH FRAME TITLE title5.
parameters: p_02_27 as checkbox,
            p_27_02 as checkbox.
SELECTION-SCREEN END OF BLOCK p5.

*************************************************************

INITIALIZATION.
  title1 = 'Ansprechpartner: Standardabteilungen'(001). "#EC *
  title2 = 'Ansprechpartner: Funktionen'(002).          "#EC *
  title3 = 'Ansprechpartner: Vollmachten'(003).         "#EC *
  title4 = 'Ansprechpartner: VIP-Kennzeichen'(004).     "#EC *
  title5 = 'Familienstandsbezeichnungen'(005).          "#EC *


*************************************************************

load-of-program.

  authority-check object 'CVI_CUST'
           id 'CVI_ACTVT' field gc_authority_start_report.

  if sy-subrc <> 0.
    message s014 display like 'E'.
  endif.


  select * from: tsab   into table lt_tsab,
                 tsabt  into table lt_tsabt,
                 tb910  into table lt_tb910,
                 tb911  into table lt_tb911t,
                 tpfk   into table lt_tpfk,
                 tpfkt  into table lt_tpfkt,
                 tb912  into table lt_tb912,
                 tb913  into table lt_tb913t,
                 tvpv   into table lt_tvpv,
                 tvpvt  into table lt_tvpvt,
                 tb914  into table lt_tb914,
                 tb915  into table lt_tb915t,
                 tvip   into table lt_tvip,
                 tvipt   into table lt_tvipt,
                 tb916  into table lt_tb916,
                 tb917  into table lt_tb917t,
                 t502t  into table lt_t502t,            "#EC CI_GENBUFF
                 tb027  into table lt_tb027,
                 tb027t into table lt_tb027t.

*************************************************************


at selection-screen output.


  loop at screen.

    case screen-name.

      when 'P_02_27'.
        if not lt_tb027[] is initial.
          screen-input = '0'.
          lc_open_checkboxes = lc_open_checkboxes - 1.
        endif.
      when 'P_10_AB'.
        if not lt_tsab[] is initial.
          screen-input = '0'.
          lc_open_checkboxes = lc_open_checkboxes - 1.
        endif.
      when 'P_12_FK'.
        if not lt_tpfk[] is initial.
          screen-input = '0'.
          lc_open_checkboxes = lc_open_checkboxes - 1.
        endif.
      when 'P_14_PV'.
        if not lt_tvpv[] is initial.
          screen-input = '0'.
          lc_open_checkboxes = lc_open_checkboxes - 1.
        endif.
      when 'P_16_IP'.
        if not lt_tvip[] is initial.
          screen-input = '0'.
          lc_open_checkboxes = lc_open_checkboxes - 1.
        endif.
      when 'P_27_02'.
        if not lt_t502t[] is initial.
          screen-input = '0'.
          lc_open_checkboxes = lc_open_checkboxes - 1.
        endif.
      when 'P_AB_10'.
        if not lt_tb910[] is initial.
          screen-input = '0'.
          lc_open_checkboxes = lc_open_checkboxes - 1.
        endif.
      when 'P_FK_12'.
        if not lt_tb912[] is initial.
          screen-input = '0'.
          lc_open_checkboxes = lc_open_checkboxes - 1.
        endif.
      when 'P_IP_16'.
        if not lt_tb916[] is initial.
          screen-input = '0'.
          lc_open_checkboxes = lc_open_checkboxes - 1.
        endif.
      when 'P_PV_14'.
        if not lt_tb914[] is initial.
          screen-input = '0'.
          lc_open_checkboxes = lc_open_checkboxes - 1.
        endif.
      when others.
        "do nothing

    endcase.

    modify screen.

  endloop.


*********************************************************************


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


  if p_ab_10 is initial and
     p_10_ab is initial and
     p_fk_12 is initial and
     p_12_fk is initial and
     p_pv_14 is initial and
     p_14_pv is initial and
     p_ip_16 is initial and
     p_16_ip is initial and
     p_02_27 is initial and
     p_27_02 is initial.
* No checkbox selected.
    message s027 display like 'E'.
    return.
  endif.


  case 'X'.
*********************************************************************
    when p_ab_10.

* Main table
      loop at lt_tsab into ls_tsab.

        clear ls_tb910.
        ls_tb910-ABTNR = ls_tsab-ABTNR.

        insert tb910 from ls_tb910.
        if sy-subrc <> 0.
          perform error_handling using 'TB910'.
        endif.



        clear ls_CVIC_CP1_LINK.
        ls_CVIC_CP1_LINK-ABTNR    = ls_tsab-ABTNR.
        ls_CVIC_CP1_LINK-GP_ABTNR = ls_tb910-ABTNR.

        insert CVIC_CP1_LINK from ls_CVIC_CP1_LINK.

        if sy-subrc <> 0.
          perform error_handling using 'CVIC_CP1_LINK'.
        endif.

      endloop.


* Text table
      loop at lt_tsabt into ls_tsabt.

        clear ls_tb911t.
        ls_tb911t-spras = ls_tsabt-spras.
        ls_tb911t-ABTNR = ls_tsabt-ABTNR.
        ls_tb911t-bez20 = ls_tsabt-VTEXT.

        insert tb911 from ls_tb911t.
        if sy-subrc <> 0.
          perform error_handling using 'TB911'.
        endif.

      endloop.

*********************************************************************
    when p_10_ab.

* Main table
      loop at lt_tb910 into ls_tb910.

        clear ls_tsab.
        ls_tsab-ABTNR = ls_tb910-ABTNR.

        insert tsab from ls_tsab.
        if sy-subrc <> 0.
          perform error_handling using 'TSAB'.
        endif.


        clear ls_CVIC_CP1_LINK.
        ls_CVIC_CP1_LINK-ABTNR    = ls_tsab-ABTNR.
        ls_CVIC_CP1_LINK-GP_ABTNR = ls_tb910-ABTNR.

        insert CVIC_CP1_LINK from ls_CVIC_CP1_LINK.

        if sy-subrc <> 0.
          perform error_handling using 'CVIC_CP1_LINK'.
        endif.

      endloop.


* Text table
      loop at lt_tb911t into ls_tb911t.

        clear ls_tsabt.
        ls_tsabt-spras = ls_tb911t-spras.
        ls_tsabt-ABTNR = ls_tb911t-ABTNR.
        ls_tsabt-VTEXT = ls_tb911t-bez20.

        insert tsabt from ls_tsabt.
        if sy-subrc <> 0.
          perform error_handling using 'TSABT'.
        endif.

      endloop.

*********************************************************************
    when p_fk_12.

* Main table
      loop at lt_tpfk into ls_tpfk.

        clear ls_tb912.
        ls_tb912-PAFKT = ls_tpfk-PAFKT.

        insert tb912 from ls_tb912.
        if sy-subrc <> 0.
          perform error_handling using 'TB912'.
        endif.


        clear ls_CVIC_CP2_LINK.
        ls_CVIC_CP2_LINK-PAFKT    = ls_tpfk-PAFKT.
        ls_CVIC_CP2_LINK-gp_PAFKT = ls_tb912-PAFKT.

        insert CVIC_CP2_LINK from ls_CVIC_CP2_LINK.

        if sy-subrc <> 0.
          perform error_handling using 'CVIC_CP2_LINK'.
        endif.

      endloop.


* Text table
      loop at lt_tpfkt into ls_tpfkt.

        clear ls_tb913t.
        ls_tb913t-spras = ls_tpfkt-spras.
        ls_tb913t-PAFKT = ls_tpfkt-PAFKT.
        ls_tb913t-bez30 = ls_tpfkt-VTEXT.

        insert tb913 from ls_tb913t.
        if sy-subrc <> 0.
          perform error_handling using 'TB913'.
        endif.

      endloop.

*********************************************************************
    when p_12_fk.

* Main table
      loop at lt_tb912 into ls_tb912.

        clear ls_tpfk.
        ls_tpfk-PAFKT = ls_tb912-PAFKT .

        insert tpfk from ls_tpfk.
        if sy-subrc <> 0.
          perform error_handling using 'TPFK'.
        endif.


        clear ls_CVIC_CP2_LINK.
        ls_CVIC_CP2_LINK-PAFKT    = ls_tpfk-PAFKT.
        ls_CVIC_CP2_LINK-gp_PAFKT = ls_tb912-PAFKT.

        insert CVIC_CP2_LINK from ls_CVIC_CP2_LINK.

        if sy-subrc <> 0.
          perform error_handling using 'CVIC_CP2_LINK'.
        endif.

      endloop.


* Text table
      loop at lt_tb913t into ls_tb913t.

        clear ls_tpfkt.
        ls_tpfkt-spras = ls_tb913t-spras.
        ls_tpfkt-PAFKT = ls_tb913t-PAFKT.
        ls_tpfkt-VTEXT = ls_tb913t-bez30.

        insert tPFKT from ls_tPFKt.
        if sy-subrc <> 0.
          perform error_handling using 'TPFKT'.
        endif.

      endloop.


*********************************************************************
    when p_pv_14.

* Main table
      loop at lt_tvpv into ls_tvpv.

        clear ls_tb914.
        ls_tb914-PAAUTH = ls_tvpv-PARVO.

        insert tb914 from ls_tb914.
        if sy-subrc <> 0.
          perform error_handling using 'TB914'.
        endif.


        clear ls_CVIC_CP3_LINK.
        ls_CVIC_CP3_LINK-parvo  = ls_tvpv-PARVO.
        ls_CVIC_CP3_LINK-PAAUTH = ls_tb914-PAAUTH.

        insert CVIC_CP3_LINK from ls_CVIC_CP3_LINK.

        if sy-subrc <> 0.
          perform error_handling using 'CVIC_CP3_LINK'.
        endif.

      endloop.


* Text table
      loop at lt_tvpvt into ls_tvpvt.

        clear ls_tb915t.
        ls_tb915t-spras  = ls_tvpvt-spras.
        ls_tb915t-PAAUTH = ls_tvpvt-PARVO.
        ls_tb915t-bez20  = ls_tvpvt-VTEXT.

        insert tb915 from ls_tb915t.
        if sy-subrc <> 0.
          perform error_handling using 'TB915'.
        endif.

      endloop.

*********************************************************************
    when p_14_pv.

* Main table
      loop at lt_tb914 into ls_tb914.

        clear ls_tvpv.
        ls_tvpv-PARVO = ls_tb914-PAAUTH.

        insert tvpv from ls_tvpv.
        if sy-subrc <> 0.
          perform error_handling using 'TVPV'.
        endif.


        clear ls_CVIC_CP3_LINK.
        ls_CVIC_CP3_LINK-parvo  = ls_tvpv-PARVO.
        ls_CVIC_CP3_LINK-PAAUTH = ls_tb914-PAAUTH.

        insert CVIC_CP3_LINK from ls_CVIC_CP3_LINK.

        if sy-subrc <> 0.
          perform error_handling using 'CVIC_CP3_LINK'.
        endif.

      endloop.


* Text table
      loop at lt_tb915t into ls_tb915t.

        clear ls_tpfkt.
        ls_tvpvt-spras = ls_tb915t-spras.
        ls_tvpvt-parvo = ls_tb915t-PAAUTH.
        ls_tvpvt-VTEXT = ls_tb915t-bez20.

        insert tvpvt from ls_tvpvt.
        if sy-subrc <> 0.
          perform error_handling using 'TVPVT'.
        endif.

      endloop.


*********************************************************************

    when p_ip_16.

* Main table
      loop at lt_tvip into ls_tvip.

        clear ls_tb916.
        ls_tb916-PAVIP = ls_tvip-PAVIP.

        insert tb916 from ls_tb916.
        if sy-subrc <> 0.
          perform error_handling using 'TB916'.
        endif.


        clear ls_CVIC_CP4_LINK.
        ls_CVIC_CP4_LINK-PAVIP    = ls_tvip-PAVIP.
        ls_CVIC_CP4_LINK-GP_PAVIP = ls_tb916-PAVIP.

        insert CVIC_CP4_LINK from ls_CVIC_CP4_LINK.

        if sy-subrc <> 0.
          perform error_handling using 'CVIC_CP4_LINK'.
        endif.

      endloop.


* Text table
      loop at lt_tvipt into ls_tvipt.

        clear ls_tb917t.
        ls_tb917t-spras = ls_tvipt-spras.
        ls_tb917t-PAVIP = ls_tvipt-PAVIP.
        ls_tb917t-bez20 = ls_tvipt-VTEXT.

        insert tb917 from ls_tb917t.
        if sy-subrc <> 0.
          perform error_handling using 'TB917'.
        endif.

      endloop.

*********************************************************************
    when p_16_ip.

*Main table
      loop at lt_tb916 into ls_tb916.

        clear ls_tvip.
        ls_tvip-PAVIP = ls_tb916-PAVIP.

        insert tvip from ls_tvip.
        if sy-subrc <> 0.
          perform error_handling using 'TVIP'.
        endif.


        clear ls_CVIC_CP4_LINK.
        ls_CVIC_CP4_LINK-PAVIP    = ls_tvip-PAVIP.
        ls_CVIC_CP4_LINK-GP_PAVIP = ls_tb916-PAVIP.

        insert CVIC_CP4_LINK from ls_CVIC_CP4_LINK.

        if sy-subrc <> 0.
          perform error_handling using 'CVIC_CP4_LINK'.
        endif.

      endloop.


* Text table
      loop at lt_tb917t into ls_tb917t.

        clear ls_tvipt.
        ls_tvipt-spras = ls_tb917t-spras.
        ls_tvipt-PAVIP = ls_tb917t-PAVIP.
        ls_tvipt-VTEXT = ls_tb917t-bez20.

        insert tvipt from ls_tvipt.
        if sy-subrc <> 0.
          perform error_handling using 'TVIPT'.
        endif.

      endloop.

*********************************************************************
    when p_02_27.

* Main table (includes text table)
      loop at lt_t502t into ls_t502t.

        clear ls_tb027.
        ls_tb027-CLIENT = ls_t502t-MANDT.
        ls_tb027-MARST = ls_t502t-FAMST.

        INSERT ls_tb027 into TABLE lt_tb027_temp.

        clear ls_tb027t.
        ls_tb027t-CLIENT = ls_t502t-MANDT.
        ls_tb027t-SPRAS = ls_t502t-SPRSL.
        ls_tb027t-MARST = ls_t502t-FAMST.
        ls_tb027t-BEZ20 = ls_t502t-FTEXT.

        INSERT ls_tb027t into TABLE lt_tb027t_temp.

        clear ls_CVIC_marst_LINK.
        ls_CVIC_marst_LINK-CLIENT = ls_t502t-MANDT.
        ls_CVIC_marst_LINK-FAMST = ls_t502t-FAMST.
        ls_CVIC_marst_LINK-marst = ls_tb027-MARST.

        INSERT LS_CVIC_MARST_LINK INTO TABLE LT_CVIC_MARST_LINK_TEMP.

      endloop.

      SORT LT_TB027_TEMP.
      DELETE ADJACENT DUPLICATES FROM LT_TB027_TEMP.
      INSERT TB027 FROM TABLE LT_TB027_TEMP. "MAIN TABLE
      IF SY-SUBRC <> 0.
          PERFORM ERROR_HANDLING USING 'TB027'.
      ENDIF.

      SORT LT_TB027T_TEMP.
      DELETE ADJACENT DUPLICATES FROM LT_TB027T_TEMP.
      INSERT TB027T FROM TABLE LT_TB027T_TEMP. "MAIN TABLE
        IF SY-SUBRC <> 0.
          PERFORM ERROR_HANDLING USING 'TB027T'.
        ENDIF.

      SORT LT_CVIC_MARST_LINK_TEMP.
      DELETE ADJACENT DUPLICATES FROM LT_CVIC_MARST_LINK_TEMP.
      INSERT CVIC_MARST_LINK FROM TABLE LT_CVIC_MARST_LINK_TEMP. "MAIN TABLE
        IF SY-SUBRC <> 0.
          PERFORM ERROR_HANDLING USING 'CVIC_MARST_LINK'.
        ENDIF.
*********************************************************************

    when p_27_02.

* Main table (includes text table)
      loop at lt_tb027t into ls_tb027t.

        clear ls_t502t.
        ls_t502t-sprsl = ls_tb027t-spras.
        ls_t502t-FAMST = ls_tb027t-MARST.
        ls_t502t-FTEXT = ls_tb027t-BEZ20.

        insert t502t from ls_t502t.
        if sy-subrc <> 0.
          perform error_handling using 'T502T'.
        endif.


        clear ls_CVIC_marst_LINK.
        ls_CVIC_marst_LINK-FAMST = ls_t502t-FAMST.
        ls_CVIC_marst_LINK-marst = ls_tb027t-MARST.

        modify CVIC_marst_LINK from ls_CVIC_marst_LINK.

        if sy-subrc <> 0.
          perform error_handling using 'CVIC_MARST_LINK'.
        endif.

      endloop.

*********************************************************************

    when others.
      "do nothing.
  endcase.


*&---------------------------------------------------------------------*
*&      Form  error_handling
*&---------------------------------------------------------------------*
FORM error_handling USING VALUE(P_table). "#EC *


  rollback work.                                       "#EC CI_ROLLBACK
  message e008 with P_table.
  return.


ENDFORM.                    " error_handling
