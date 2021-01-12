*----------------------------------------------------------------------*
***INCLUDE ZTEST_PRE_CHECK_BAL_LOGF01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form CHK_OP1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM chk_op1  .
  DATA:
    l_log_handle TYPE balloghndl,
    l_s_log      TYPE bal_s_log,
    l_s_msg      TYPE bal_s_msg,
    l_msgno      TYPE symsgno,
    lv_var       TYPE sy-msgv1.

  DATA : lt_kna1 TYPE TABLE OF kna1.
  DATA : ls_kna1 LIKE LINE OF lt_kna1.
  DATA : lt_acc_grp TYPE STANDARD TABLE OF t077d.
  DATA : ls_acc_grp LIKE LINE OF lt_acc_grp.
  DATA : lt_cviv_cust_to_bp2 TYPE STANDARD TABLE OF cvic_cust_to_bp2.
  DATA :ls_cviv_cust LIKE LINE OF  lt_cviv_cust_to_bp2 .
  DATA : lt_cviv_vend_to_bp2 TYPE STANDARD TABLE OF cvic_vend_to_bp2.
  DATA :ls_cviv_vend LIKE LINE OF  lt_cviv_vend_to_bp2 .
  DATA : lt_cviv_cust_to_bp TYPE TABLE OF cviv_cust_to_bp2.
  DATA : ls_cviv_cust_to_bp LIKE LINE OF lt_cviv_cust_to_bp2 .
  DATA : lt_lfa1 TYPE STANDARD TABLE OF lfa1.
  DATA : ls_lfa1 LIKE LINE OF lt_lfa1.
  FIELD-SYMBOLS : <ls_final> LIKE LINE OF gt_check_final.
*  BP roles are assigned to account groups

  DATA : lt_keys TYPE  cmds_kna1_t .
  DATA : ls_key LIKE LINE OF lt_keys.
  DATA : lt_kna1_temp TYPE cmds_kna1_t.
  DATA : ls_kna1_temp LIKE LINE OF lt_kna1_temp.
  DATA : lt_kna1_key  TYPE cmds_customer_numbers_s_t.
  DATA : ls_kna1_key LIKE LINE OF lt_kna1_key.

  DATA : lt_keys_vend TYPE  vmds_lfa1_t .
  DATA : ls_key_vend LIKE LINE OF lt_keys_vend.
  DATA : lt_lfa1_temp TYPE vmds_lfa1_t.
  DATA : ls_lfa1_temp LIKE LINE OF lt_lfa1_temp.
  DATA : lt_lfa1_key  TYPE vmds_vendor_numbers_s_t.
  DATA : ls_lfa1_key LIKE LINE OF lt_lfa1_key.



*  select * from kna1 client specified into corresponding fields of table lt_kna1.
*  sort lt_kna1 by mandt kunnr.
*  loop at lt_kna1 into ls_kna1.
*    ls_key-kunnr = ls_kna1-kunnr .
*    append ls_key to lt_keys.
*    move-corresponding ls_kna1 to ls_kna1_temp.
*    append ls_kna1 to lt_kna1_temp.
*    clear ls_key.
*    clear ls_kna1_temp.
*    clear ls_kna1.
*  endloop.

  DATA : p_psize       TYPE integer VALUE '1000',
         s_cursor      TYPE cursor,
         s_cursor_lfa1 TYPE cursor,
         gv_kna1       TYPE c,
         gv_lfa1       TYPE c.  " Package size

*  if s_cursor is initial.
*    if gs_input is not initial.
*      open cursor: s_cursor for select distinct * from kna1 as a client specified up to gs_input rows
*        where ktokd is not null and ktokd not in ( select  account_group  from cvic_cust_to_bp1 as b client specified where a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ. " mandt lifnr ktokd
*    else.
*      open cursor: s_cursor for select distinct * from kna1 as a client specified
*          where ktokd is not null and ktokd not in ( select  account_group  from cvic_cust_to_bp1 as b client specified where a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ. " mandt lifnr ktokd
*    endif.
*  endif.

  TRY.

    IF s_cursor IS INITIAL.
      IF gs_input IS NOT INITIAL.

        OPEN CURSOR: s_cursor FOR
*        select distinct * from kna1 as a client specified up to gs_input rows
*            where ktokd is not null and ktokd not in ( select  account_group  from cvic_cust_to_bp2 as b client specified where a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ. " mandt kunnr ktokd

         SELECT DISTINCT * FROM kna1 AS a CLIENT SPECIFIED UP TO gs_input ROWS
           WHERE ktokd IS NOT NULL AND ktokd NOT IN ( SELECT account_group FROM cvic_cust_to_bp2 AS b CLIENT SPECIFIED WHERE a~mandt = b~client AND a~ktokd = b~account_group ). "#EC CI_NOWHERE "#EC CI_BUFFSUB endif. "mandt kunnr ktokd

      ELSE.
        OPEN CURSOR: s_cursor FOR
*        select distinct * from kna1 as a client specified
*            where ktokd is not null and ktokd not in ( select  account_group  from cvic_cust_to_bp2 as b client specified where a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ. " mandt kunnr ktokd

 SELECT DISTINCT * FROM kna1 AS a CLIENT SPECIFIED
   WHERE ktokd IS NOT NULL AND ktokd NOT IN ( SELECT account_group FROM cvic_cust_to_bp2 AS b CLIENT SPECIFIED WHERE a~mandt = b~client AND a~ktokd = b~account_group ). "#EC CI_NOWHERE "#EC CI_BUFFSUB endif. "mandt kunnr ktokd

      ENDIF.
    ENDIF.

    DO.
      FETCH NEXT CURSOR s_cursor INTO TABLE lt_kna1 PACKAGE SIZE p_psize.
      IF sy-subrc NE 0 .
        CLOSE CURSOR s_cursor.
        gv_kna1 = 'X'.
        EXIT .
      ELSE.
        SORT lt_kna1 BY mandt kunnr.
        LOOP AT lt_kna1 INTO ls_kna1.
          ls_key-kunnr = ls_kna1-kunnr .
          ls_key-mandt = ls_kna1-mandt .
          APPEND ls_key TO lt_keys.
          MOVE-CORRESPONDING ls_kna1 TO ls_kna1_temp.
          APPEND ls_kna1 TO lt_kna1_temp.
          CLEAR ls_key.
          CLEAR ls_kna1_temp.
          CLEAR ls_kna1.
        ENDLOOP.
      ENDIF.


*      call method cmd_ei_api_check=>check_cust_part_of_retail_site
*        EXPORTING
*          it_keys         = lt_keys
*          it_kna1         = lt_kna1_temp
*        IMPORTING
*          et_part_of_site = lt_kna1_key.

      PERFORM check_cust_part_of_retail_site USING lt_keys lt_kna1_temp CHANGING lt_kna1_key.

      SORT lt_kna1 BY  mandt ktokd.
      DELETE ADJACENT DUPLICATES FROM lt_kna1 COMPARING  mandt ktokd.

      LOOP AT lt_kna1 INTO ls_kna1.
        READ TABLE lt_kna1_key INTO ls_kna1_key WITH KEY kunnr = ls_kna1-kunnr.
        IF sy-subrc = 0.
          DELETE TABLE lt_kna1 FROM ls_kna1.
        ENDIF.
        CLEAR ls_kna1.
        CLEAR ls_kna1_key.
      ENDLOOP.


      LOOP AT lt_kna1 INTO ls_kna1 WHERE ktokd IS NOT INITIAL .

        READ TABLE gt_check_final ASSIGNING <ls_final> WITH KEY chkid = 'CHK_1'.
        IF sy-subrc = 0.
          gs_check_msg-chkid = <ls_final>-chkid.
          gs_check_msg-status = '@0A@'.
          gs_check_msg-tabname = 'CVIV_CUST_TO_BP2'.
          gs_check_msg-client = ls_kna1-mandt.
*          concatenate ls_kna1-ktokd  'Not Assigned to any Role in table CVIC_CUST_TO BP2 in client ' ls_kna1-mandt into gs_check_msg-msg_name separated by space.
          CONCATENATE ls_kna1-ktokd  'Customer Account group is not maintained in table' 'CVIC_CUST_TO_BP2 in client' ls_kna1-mandt  'kindly refer note 2210486'
          INTO gs_check_msg-msg_name IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT
          APPEND  gs_check_msg TO gt_check_msg.
          <ls_final>-status = '@0A@'.
          <ls_final>-stat_chk = 'E'.
        ENDIF.

        CLEAR ls_cviv_cust.
        CLEAR ls_acc_grp.

      ENDLOOP.
      REFRESH lt_kna1.
      REFRESH lt_kna1_temp.
      REFRESH lt_kna1_key.
      REFRESH lt_keys.

      FREE: lt_kna1, lt_kna1_temp, lt_kna1_key, lt_keys.
    ENDDO.


*  select * from lfa1 client specified into corresponding fields of table lt_lfa1.
*  sort lt_lfa1 by mandt lifnr.
*  loop at lt_lfa1 into ls_lfa1.
*    ls_key_vend-lifnr = ls_lfa1-kunnr .
*    append ls_key_vend to lt_keys_vend.
*    move-corresponding ls_lfa1 to ls_lfa1_temp.
*    append ls_lfa1 to lt_lfa1_temp.
*    clear ls_key_vend.
*    clear ls_lfa1_temp.
*    clear ls_lfa1.
*  endloop.

    IF s_cursor_lfa1 IS INITIAL.
      IF gs_input IS NOT INITIAL.
        OPEN CURSOR: s_cursor_lfa1 FOR
*        select distinct * from lfa1 as a client specified up to gs_input rows
*       where ktokk is not null  and ktokk  not in ( select  account_group  from cvic_vend_to_bp2 as b client specified  where a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ. " mandt lifnr ktokk

        SELECT DISTINCT * FROM lfa1 AS a CLIENT SPECIFIED UP TO gs_input ROWS
          WHERE ktokk IS NOT NULL AND ktokk NOT IN ( SELECT account_group FROM cvic_vend_to_bp2 AS b CLIENT SPECIFIED WHERE a~mandt = b~client AND a~ktokk = b~account_group ). "#EC CI_NOWHERE "#EC CI_BUFFSUB endif. "mandt kunnr ktokd

      ELSE.
        OPEN CURSOR: s_cursor_lfa1 FOR
*        select distinct * from lfa1 as a client specified
*         where ktokk is not null  and ktokk  not in ( select  account_group  from cvic_vend_to_bp2 as b client specified  where a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ. " mandt lifnr ktokk

        SELECT DISTINCT * FROM lfa1 AS a CLIENT SPECIFIED
          WHERE ktokk IS NOT NULL AND ktokk NOT IN ( SELECT account_group FROM cvic_vend_to_bp2 AS b CLIENT SPECIFIED WHERE a~mandt = b~client AND a~ktokk = b~account_group ). "#EC CI_NOWHERE "#EC CI_BUFFSUB endif. "mandt kunnr ktokd

      ENDIF.
    ENDIF.
    DO.
      FETCH NEXT CURSOR s_cursor_lfa1 INTO TABLE lt_lfa1 PACKAGE SIZE p_psize.
      IF sy-subrc NE 0 .
        CLOSE CURSOR s_cursor_lfa1.
        gv_lfa1 = 'X'.
        EXIT .
      ELSE.
        SORT lt_lfa1 BY mandt lifnr .
        LOOP AT lt_lfa1 INTO ls_lfa1.
          ls_key_vend-lifnr = ls_lfa1-lifnr .
          ls_key_vend-mandt = ls_lfa1-mandt .
          APPEND ls_key_vend TO lt_keys_vend.
          MOVE-CORRESPONDING ls_lfa1 TO ls_lfa1_temp.
          APPEND ls_lfa1 TO lt_lfa1_temp.
          CLEAR ls_key_vend.
          CLEAR ls_lfa1_temp.
          CLEAR ls_lfa1.
        ENDLOOP.
      ENDIF.

*
*      call method vmd_ei_api_check=>check_vend_part_of_retail_site
*        EXPORTING
*          it_keys         = lt_keys_vend
*          it_lfa1         = lt_lfa1_temp
*        IMPORTING
*          et_part_of_site = lt_lfa1_key.

      PERFORM check_vend_part_of_retail_site USING lt_keys_vend lt_lfa1_temp CHANGING lt_lfa1_key.

      SORT lt_lfa1 BY mandt ktokk.
      DELETE ADJACENT DUPLICATES FROM lt_lfa1 COMPARING mandt ktokk.
      LOOP AT lt_lfa1 INTO ls_lfa1.
        READ TABLE lt_lfa1_key INTO ls_lfa1_key WITH KEY lifnr = ls_lfa1-lifnr.
        IF sy-subrc = 0.
          DELETE TABLE lt_lfa1 FROM ls_lfa1.
        ENDIF.
        CLEAR ls_lfa1.
        CLEAR ls_lfa1_key.
      ENDLOOP.

      LOOP AT lt_lfa1 INTO ls_lfa1 WHERE ktokk IS NOT INITIAL.
        READ TABLE gt_check_final ASSIGNING <ls_final> WITH KEY chkid = 'CHK_1'.
        IF sy-subrc = 0.
          gs_check_msg-chkid = <ls_final>-chkid.
          gs_check_msg-status = '@0A@'.
          gs_check_msg-tabname = 'CVIV_VEND_TO_BP2'.
          gs_check_msg-client = ls_lfa1-mandt.
*          concatenate ls_lfa1-ktokk  'Not Assigned to any Role in table CVIC_VEND_TO BP2 in client ' ls_lfa1-mandt into gs_check_msg-msg_name separated by space.
          CONCATENATE ls_lfa1-ktokk  'Vendor Account Group is not maintained in table' 'CVIC_VEND_TO_BP2 in client' ls_lfa1-mandt 'kindly refer note 2210486'
          INTO gs_check_msg-msg_name IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT
          APPEND  gs_check_msg TO gt_check_msg.
          <ls_final>-status = '@0A@'.
          <ls_final>-stat_chk = 'E'.
        ENDIF.
        CLEAR ls_cviv_cust.
        CLEAR ls_acc_grp.
      ENDLOOP.
      REFRESH lt_lfa1.
      REFRESH lt_lfa1_temp.
      REFRESH lt_lfa1_key.
      REFRESH lt_keys_vend.

      FREE: lt_lfa1, lt_lfa1_temp, lt_lfa1_key, lt_keys_vend.

    ENDDO.

*  select distinct kunnr ktokd from kna1  into corresponding fields of table lt_kna1
*    where ktokd is not null and ktokd not in ( select  account_group  from cvic_cust_to_bp2  ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
*
*
*  select distinct lifnr ktokk from lfa1 into corresponding fields of table lt_lfa1
*                          where ktokk is not null  and ktokk  not in ( select  account_group  from cvic_vend_to_bp2 ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

*  sort lt_kna1 by  mandt ktokd.
*  delete adjacent duplicates from lt_kna1 comparing  mandt ktokd.
*
*  loop at lt_kna1 into ls_kna1.
*    read table lt_kna1_key into ls_kna1_key with key kunnr = ls_kna1-kunnr.
*    if sy-subrc = 0.
*      delete table lt_kna1 from ls_kna1.
*    endif.
*    clear ls_kna1.
*    clear ls_kna1_key.
*  endloop.
*
*
*  loop at lt_kna1 into ls_kna1 where ktokd is not initial .
*
*    read table gt_check_final assigning <ls_final> with key chkid = 'CHK_1'.
*    if sy-subrc = 0.
*      gs_check_msg-chkid = <ls_final>-chkid.
*      gs_check_msg-status = '@0A@'.
*      concatenate ls_kna1-ktokd  'Not Assigned to any Role in table CVIC_CUST_TO BP2 ' into gs_check_msg-msg_name separated by space.
*      append  gs_check_msg to gt_check_msg.
*      <ls_final>-status = '@0A@'.
*      <ls_final>-stat_chk = 'E'.
*    endif.
*
*    clear ls_cviv_cust.
*    clear ls_acc_grp.
*
*  endloop.

*  sort lt_lfa1 by mandt ktokk.
*  delete adjacent duplicates from lt_lfa1 comparing mandt ktokk.
*  loop at lt_lfa1 into ls_lfa1.
*    read table lt_lfa1_key into ls_lfa1_key with key lifnr = ls_lfa1-lifnr.
*    if sy-subrc = 0.
*      delete table lt_lfa1 from ls_lfa1.
*    endif.
*    clear ls_lfa1.
*    clear ls_lfa1_key.
*  endloop.
*
*  loop at lt_lfa1 into ls_lfa1 where ktokk is not initial.
*    read table gt_check_final assigning <ls_final> with key chkid = 'CHK_1'.
*    if sy-subrc = 0.
*      gs_check_msg-chkid = <ls_final>-chkid.
*      gs_check_msg-status = '@0A@'.
*      concatenate ls_lfa1-ktokk  'Not Assigned to any Role in table CVIC_VEND_TO BP2 ' into gs_check_msg-msg_name separated by space.
*      append  gs_check_msg to gt_check_msg.
*      <ls_final>-status = '@0A@'.
*      <ls_final>-stat_chk = 'E'.
*    endif.
*    clear ls_cviv_cust.
*    clear ls_acc_grp.
*  endloop.

*    sort gt_check_msg by client msg_name.
*    delete adjacent duplicates from gt_check_msg comparing msg_name.

    SORT gt_check_msg BY chkid(6) status msg_name tabname client."   type mandt,
    DELETE ADJACENT DUPLICATES FROM gt_check_msg COMPARING chkid(6) status msg_name tabname client.

    IF gt_check_msg IS NOT INITIAL.
      READ TABLE gt_check_msg INTO gs_msg_check INDEX 1.
      IF sy-subrc = 0.
        APPEND gs_msg_check TO gt_msg_check.
      ENDIF.
      CLEAR gs_msg_check.
    ENDIF.

    LOOP AT gt_check_final ASSIGNING <ls_final> WHERE chkid = 'CHK_1' .
      IF <ls_final>-stat_chk <> 'E'.
        <ls_final>-status = '@08@'.
      ENDIF.

    ENDLOOP.




  ENDTRY.
ENDFORM.                    "chk_op1
*&---------------------------------------------------------------------*
*& Form CHK_OP2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM chk_op2 .

*	For every account group a BP Grouping must be available
  DATA:
    l_log_handle1 TYPE balloghndl,
    l_s_log1      TYPE bal_s_log,
    l_s_msg1      TYPE bal_s_msg,
    l_msgno1      TYPE symsgno,
    lv_var1       TYPE sy-msgv1.

*  BP roles are assigned to account groups
  DATA : lt_acc_grp TYPE STANDARD TABLE OF t077d.
  DATA : ls_acc_grp LIKE LINE OF lt_acc_grp.
  DATA : lt_cviv_cust_to_bp1 TYPE STANDARD TABLE OF cvic_cust_to_bp1.
  DATA :ls_cviv_cust LIKE LINE OF  lt_cviv_cust_to_bp1 .
  DATA : lt_cviv_vend_to_bp1 TYPE STANDARD TABLE OF cvic_vend_to_bp1.
  DATA : ls_cviv_vend_to_bp1 LIKE LINE OF lt_cviv_vend_to_bp1 .
  FIELD-SYMBOLS : <ls_final> LIKE LINE OF gt_check_final.
  DATA : lt_kna1 TYPE STANDARD TABLE OF kna1.
  DATA : ls_kna1 LIKE LINE OF lt_kna1.
  DATA : lt_lfa1 TYPE STANDARD TABLE OF lfa1.
  DATA : ls_lfa1 LIKE LINE OF lt_lfa1.

  CLEAR gs_check_msg.

  DATA : lt_keys TYPE  cmds_kna1_t .
  DATA : ls_key LIKE LINE OF lt_keys.
  DATA : lt_kna1_temp TYPE cmds_kna1_t.
  DATA : ls_kna1_temp LIKE LINE OF lt_kna1_temp.
  DATA : lt_kna1_key  TYPE cmds_customer_numbers_s_t.

  DATA : lt_keys_vend TYPE  vmds_lfa1_t .
  DATA : ls_key_vend LIKE LINE OF lt_keys_vend.
  DATA : lt_lfa1_temp TYPE vmds_lfa1_t.
  DATA : ls_lfa1_temp LIKE LINE OF lt_lfa1_temp.
  DATA : lt_lfa1_key  TYPE vmds_vendor_numbers_s_t.
  DATA : ls_kna1_key LIKE LINE OF lt_kna1_key.
  DATA : ls_lfa1_key LIKE LINE OF lt_lfa1_key.

  DATA : p_psize       TYPE integer VALUE '1000',
         s_cursor      TYPE cursor,
         s_cursor_lfa1 TYPE cursor,
         gv_kna1       TYPE c,
         gv_lfa1       TYPE c.  " Package size

*  select * from kna1 into corresponding fields of table lt_kna1.
*  sort lt_kna1 by mandt kunnr.
*  loop at lt_kna1 into ls_kna1.
*    ls_key-kunnr = ls_kna1-kunnr .
*    append ls_key to lt_keys.
*    move-corresponding ls_kna1 to ls_kna1_temp.
*    append ls_kna1 to lt_kna1_temp.
*    clear ls_key.
*    clear ls_kna1_temp.
*    clear ls_kna1.
*  endloop.
*
*  call method cmd_ei_api_check=>check_cust_part_of_retail_site
*    EXPORTING
*      it_keys         = lt_keys
*      it_kna1         = lt_kna1_temp
*    IMPORTING
*      et_part_of_site = lt_kna1_key.

  TRY.

    IF s_cursor IS INITIAL.
      IF gs_input IS NOT INITIAL.
        OPEN CURSOR: s_cursor FOR
*        select distinct * from kna1 as a client specified up to gs_input rows
*           where ktokd is not null and ktokd not in ( select  account_group  from cvic_cust_to_bp1 as b client specified where a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ. " mandt lifnr ktokd

SELECT DISTINCT * FROM kna1 AS a CLIENT SPECIFIED UP TO gs_input ROWS
           WHERE ktokd IS NOT NULL AND ktokd NOT IN ( SELECT  account_group  FROM cvic_cust_to_bp1 AS b CLIENT SPECIFIED WHERE a~mandt = b~client AND a~ktokd = b~account_group ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ. " mandt lifnr ktokd

      ELSE.
        OPEN CURSOR: s_cursor FOR
*        select distinct * from kna1 as a client specified
*            where ktokd is not null and ktokd not in ( select  account_group  from cvic_cust_to_bp1 as b client specified where a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ. " mandt lifnr ktokd

        SELECT DISTINCT * FROM kna1 AS a CLIENT SPECIFIED
            WHERE ktokd IS NOT NULL AND ktokd NOT IN ( SELECT  account_group  FROM cvic_cust_to_bp1 AS b CLIENT SPECIFIED WHERE a~mandt = b~client AND a~ktokd = b~account_group ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ. " mandt lifnr ktokd

      ENDIF.
    ENDIF.

    DO.
      FETCH NEXT CURSOR s_cursor INTO TABLE lt_kna1 PACKAGE SIZE p_psize.
      IF sy-subrc NE 0 .
        CLOSE CURSOR s_cursor.
        gv_kna1 = 'X'.
        EXIT .
      ELSE.
        SORT lt_kna1 BY mandt kunnr.
        LOOP AT lt_kna1 INTO ls_kna1.
          ls_key-kunnr = ls_kna1-kunnr .
          ls_key-mandt = ls_kna1-mandt .
          APPEND ls_key TO lt_keys.
          MOVE-CORRESPONDING ls_kna1 TO ls_kna1_temp.
          APPEND ls_kna1 TO lt_kna1_temp.
          CLEAR ls_key.
          CLEAR ls_kna1_temp.
          CLEAR ls_kna1.
        ENDLOOP.
      ENDIF.


*      call method cmd_ei_api_check=>check_cust_part_of_retail_site
*        EXPORTING
*          it_keys         = lt_keys
*          it_kna1         = lt_kna1_temp
*        IMPORTING
*          et_part_of_site = lt_kna1_key.

      PERFORM check_cust_part_of_retail_site USING lt_keys lt_kna1_temp CHANGING lt_kna1_key.

      SORT lt_kna1 BY ktokd mandt.
      DELETE ADJACENT DUPLICATES FROM lt_kna1 COMPARING ktokd mandt.

      LOOP AT lt_kna1 INTO ls_kna1.
        READ TABLE lt_kna1_key INTO ls_kna1_key WITH KEY kunnr = ls_kna1-kunnr.
        IF sy-subrc = 0.
          DELETE TABLE lt_kna1 FROM ls_kna1.
        ENDIF.
        CLEAR ls_kna1.
        CLEAR ls_kna1_key.
      ENDLOOP.


      LOOP AT lt_kna1 INTO ls_kna1 WHERE ktokd IS NOT INITIAL.
        READ TABLE gt_check_final ASSIGNING <ls_final> WITH KEY chkid = 'CHK_2'.
        IF sy-subrc = 0.
          gs_check_msg-chkid = <ls_final>-chkid.
          gs_check_msg-status = '@0A@'.
          gs_check_msg-tabname = 'CVIV_CUST_TO_BP1'.
          gs_check_msg-client = ls_kna1-mandt.
*          concatenate ls_kna1-ktokd  'Not Assigned to any Group' into gs_check_msg-msg_name separated by space.
          CONCATENATE ls_kna1-ktokd  'Customer account group is not maintained in table' 'CVIC_CUST_TO_BP1 in client' ls_kna1-mandt ' kindly refer note 2210486'
          INTO gs_check_msg-msg_name IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT

          APPEND  gs_check_msg TO gt_check_msg.
          <ls_final>-status = '@0A@'.
          <ls_final>-stat_chk = 'E'.

        ENDIF.
      ENDLOOP.
      REFRESH lt_kna1.
      REFRESH lt_kna1_temp.
      REFRESH lt_kna1_key.
      REFRESH lt_keys.

      FREE: lt_kna1, lt_kna1_temp, lt_kna1_key, lt_keys.

    ENDDO.


*      select * from lfa1 into corresponding fields of table lt_lfa1.
*      sort lt_lfa1 by mandt lifnr.
*      loop at lt_lfa1 into ls_lfa1.
*        ls_key_vend-lifnr = ls_lfa1-kunnr .
*        append ls_key_vend to lt_keys_vend.
*        move-corresponding ls_lfa1 to ls_lfa1_temp.
*        append ls_lfa1 to lt_lfa1_temp.
*        clear ls_key_vend.
*        clear ls_lfa1_temp.
*        clear ls_lfa1.
*      endloop.
*
*      call method vmd_ei_api_check=>check_vend_part_of_retail_site
*        EXPORTING
*          it_keys         = lt_keys_vend
*          it_lfa1         = lt_lfa1_temp
*        IMPORTING
*          et_part_of_site = lt_lfa1_key.


*  select distinct kunnr ktokd from kna1  into corresponding fields of table lt_kna1
*             where ktokd is not null and ktokd not in ( select account_group from  cvic_cust_to_bp1 ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

*  sort lt_kna1 by ktokd mandt.
*  delete adjacent duplicates from lt_kna1 comparing ktokd mandt.

    IF s_cursor_lfa1 IS INITIAL.
      IF gs_input IS NOT INITIAL.
        OPEN CURSOR: s_cursor_lfa1 FOR
*        select distinct * from lfa1 as a client specified up to gs_input rows
*       where ktokk is not null  and ktokk  not in ( select  account_group  from cvic_vend_to_bp1 as b client specified  where a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

        SELECT DISTINCT * FROM lfa1 AS a CLIENT SPECIFIED UP TO gs_input ROWS
       WHERE ktokk IS NOT NULL  AND ktokk  NOT IN ( SELECT  account_group  FROM cvic_vend_to_bp1 AS b CLIENT SPECIFIED  WHERE a~mandt = b~client AND a~ktokk = b~account_group ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

      ELSE.
        OPEN CURSOR: s_cursor_lfa1 FOR
*        select distinct * from lfa1 as a client specified
*         where ktokk is not null  and ktokk  not in ( select  account_group  from cvic_vend_to_bp1 as b client specified  where a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

        SELECT DISTINCT * FROM lfa1 AS a CLIENT SPECIFIED
         WHERE ktokk IS NOT NULL  AND ktokk  NOT IN ( SELECT  account_group  FROM cvic_vend_to_bp1 AS b CLIENT SPECIFIED  WHERE a~mandt = b~client AND a~ktokk = b~account_group ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

      ENDIF.
    ENDIF.
    DO.
      FETCH NEXT CURSOR s_cursor_lfa1 INTO TABLE lt_lfa1 PACKAGE SIZE p_psize.
      IF sy-subrc NE 0 .
        CLOSE CURSOR s_cursor_lfa1.
        gv_lfa1 = 'X'.
        EXIT .
      ELSE.
        SORT lt_lfa1 BY mandt lifnr .
        LOOP AT lt_lfa1 INTO ls_lfa1.
          ls_key_vend-lifnr = ls_lfa1-lifnr .
          ls_key_vend-mandt = ls_lfa1-mandt .
          APPEND ls_key_vend TO lt_keys_vend.
          MOVE-CORRESPONDING ls_lfa1 TO ls_lfa1_temp.
          APPEND ls_lfa1 TO lt_lfa1_temp.
          CLEAR ls_key_vend.
          CLEAR ls_lfa1_temp.
          CLEAR ls_lfa1.
        ENDLOOP.
      ENDIF.


*      call method vmd_ei_api_check=>check_vend_part_of_retail_site
*        EXPORTING
*          it_keys         = lt_keys_vend
*          it_lfa1         = lt_lfa1_temp
*        IMPORTING
*          et_part_of_site = lt_lfa1_key.

      PERFORM check_vend_part_of_retail_site USING lt_keys_vend lt_lfa1_temp CHANGING lt_lfa1_key.


      SORT lt_lfa1 BY mandt ktokk.
      DELETE ADJACENT DUPLICATES FROM lt_lfa1 COMPARING mandt ktokk .
      LOOP AT lt_lfa1 INTO ls_lfa1.
        READ TABLE lt_lfa1_key INTO ls_lfa1_key WITH KEY lifnr = ls_lfa1-lifnr.
        IF sy-subrc = 0.
          DELETE TABLE lt_lfa1 FROM ls_lfa1.
        ENDIF.
        CLEAR ls_lfa1.
        CLEAR ls_lfa1_key.
      ENDLOOP.


      LOOP AT lt_lfa1 INTO ls_lfa1 WHERE ktokk IS  NOT INITIAL.
        READ TABLE gt_check_final ASSIGNING <ls_final> WITH KEY chkid = 'CHK_2'.
        IF sy-subrc = 0.
          gs_check_msg-chkid = <ls_final>-chkid.
          gs_check_msg-status = '@0A@'.
          gs_check_msg-tabname = 'CVIV_VEND_TO_BP1'.
          gs_check_msg-client = ls_lfa1-mandt.
*          concatenate ls_lfa1-ktokk  'Not Assigned to any Group' into gs_check_msg-msg_name separated by space.
          CONCATENATE ls_lfa1-ktokk  'Vendor account group is not maintained in table' 'CVIC_VEND_TO_BP1 in client' ls_lfa1-mandt 'kindly refer note 2210486'
          INTO gs_check_msg-msg_name IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT
          APPEND  gs_check_msg TO gt_check_msg.
          <ls_final>-status = '@0A@'.
          <ls_final>-stat_chk = 'E'.

        ENDIF.

      ENDLOOP.
      REFRESH lt_lfa1.
      REFRESH lt_lfa1_temp.
      REFRESH lt_lfa1_key.
      REFRESH lt_keys_vend.

      FREE: lt_lfa1, lt_lfa1_temp, lt_lfa1_key, lt_keys_vend.

    ENDDO.



*      select distinct lifnr ktokk from lfa1  into corresponding fields of table lt_lfa1
*                              where  ktokk is not null  and ktokk not in ( select account_group from  cvic_vend_to_bp1  ). "#EC CI_NOWHERE "#ECCI_BUFFSUBQ.
*

*      sort lt_lfa1 by mandt ktokk.
*      delete adjacent duplicates from lt_lfa1 comparing mandt ktokk .


*  loop at lt_kna1 into ls_kna1.
*    read table lt_kna1_key into ls_kna1_key with key kunnr = ls_kna1-kunnr.
*    if sy-subrc = 0.
*      delete table lt_kna1 from ls_kna1.
*    endif.
*    clear ls_kna1.
*    clear ls_kna1_key.
*  endloop.
*
*
*  loop at lt_kna1 into ls_kna1 where ktokd is not initial.
*    read table gt_check_final assigning <ls_final> with key chkid = 'CHK_2'.
*    if sy-subrc = 0.
*      gs_check_msg-chkid = <ls_final>-chkid.
*      gs_check_msg-status = '@0A@'.
*      concatenate ls_kna1-ktokd  'Not Assigned to any Group' into gs_check_msg-msg_name separated by space.
*      append  gs_check_msg to gt_check_msg.
*      <ls_final>-status = '@0A@'.
*      <ls_final>-stat_chk = 'E'.
*
*    endif.
*
*  endloop.



*      loop at lt_lfa1 into ls_lfa1.
*        read table lt_lfa1_key into ls_lfa1_key with key lifnr = ls_lfa1-lifnr.
*        if sy-subrc = 0.
*          delete table lt_lfa1 from ls_lfa1.
*        endif.
*        clear ls_lfa1.
*        clear ls_lfa1_key.
*      endloop.
*
*
*      loop at lt_lfa1 into ls_lfa1 where ktokk is  not initial.
*        read table gt_check_final assigning <ls_final> with key chkid = 'CHK_2'.
*        if sy-subrc = 0.
*          gs_check_msg-chkid = <ls_final>-chkid.
*          gs_check_msg-status = '@0A@'.
*          concatenate ls_lfa1-ktokk  'Not Assigned to any Group' into gs_check_msg-msg_name separated by space.
*          append  gs_check_msg to gt_check_msg.
*          <ls_final>-status = '@0A@'.
*          <ls_final>-stat_chk = 'E'.
*
*        endif.
*
*      endloop.

*    sort gt_check_msg by client msg_name.
*    delete adjacent duplicates from gt_check_msg comparing msg_name.

    SORT gt_check_msg BY chkid(6) status msg_name tabname client."   type mandt,
    DELETE ADJACENT DUPLICATES FROM gt_check_msg COMPARING chkid(6) status msg_name tabname client.

    IF gt_check_msg IS NOT INITIAL.
      READ TABLE gt_check_msg INTO gs_msg_check INDEX 1.
      IF sy-subrc = 0.
        APPEND gs_msg_check TO gt_msg_check.
      ENDIF.
      CLEAR gs_msg_check.
    ENDIF.

    LOOP AT gt_check_final ASSIGNING <ls_final> WHERE chkid = 'CHK_2' .
      IF <ls_final>-stat_chk <> 'E'.
        <ls_final>-status = '@08@'.
      ENDIF.

    ENDLOOP.
  ENDTRY.
ENDFORM.                    "chk_op2
*&---------------------------------------------------------------------*
*& Form CHK_OP3
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM chk_op3 .
  DATA : lt_kna1 TYPE STANDARD TABLE OF kna1.
  DATA : ls_kna1 LIKE LINE OF lt_kna1.
  DATA : lt_lfa1 TYPE STANDARD TABLE OF lfa1.
  DATA : ls_lfa1 LIKE LINE OF lt_lfa1.
  DATA : lt_cust_link TYPE STANDARD TABLE OF cvi_cust_link.
  DATA : ls_cust_link LIKE LINE OF lt_cust_link.
  DATA : lt_vend_link TYPE STANDARD TABLE OF cvi_vend_link.
  DATA : ls_vend_link LIKE LINE OF   lt_vend_link.
  FIELD-SYMBOLS : <ls_final> LIKE LINE OF gt_check_final.


  DATA : lt_keys TYPE  cmds_kna1_t .
  DATA : ls_key LIKE LINE OF lt_keys.
  DATA : lt_kna1_temp TYPE cmds_kna1_t.
  DATA : ls_kna1_temp LIKE LINE OF lt_kna1_temp.
  DATA : lt_kna1_key  TYPE cmds_customer_numbers_s_t.

  DATA : lt_keys_vend TYPE  vmds_lfa1_t .
  DATA : ls_key_vend LIKE LINE OF lt_keys_vend.
  DATA : lt_lfa1_temp TYPE vmds_lfa1_t.
  DATA : ls_lfa1_temp LIKE LINE OF lt_lfa1_temp.
  DATA : lt_lfa1_key  TYPE vmds_vendor_numbers_s_t.
  DATA : ls_kna1_key LIKE LINE OF lt_kna1_key.
  DATA : ls_lfa1_key LIKE LINE OF lt_lfa1_key.



  DATA : p_psize       TYPE integer VALUE '1000',
         s_cursor      TYPE cursor,
         s_cursor_lfa1 TYPE cursor,
         gv_kna1       TYPE c,
         gv_lfa1       TYPE c,
         lv_cust_count TYPE integer VALUE 1,
         lv_vend_count TYPE integer VALUE 1.  " Package size

  TRY.

    IF s_cursor IS INITIAL.
      IF gs_input IS NOT INITIAL.
        OPEN CURSOR: s_cursor FOR
*      select * from kna1 as a client specified up to gs_input rows where lifnr = '' and  kunnr not in
*      ( select customer from cvi_cust_link as b client specified where a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

      SELECT * FROM kna1 AS a CLIENT SPECIFIED UP TO gs_input ROWS
*        WHERE lifnr = '' AND  kunnr NOT IN ( SELECT customer FROM cvi_cust_link AS b CLIENT SPECIFIED WHERE a~mandt = b~client AND a~kunnr = b~customer ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
        WHERE kunnr NOT IN ( SELECT customer FROM cvi_cust_link AS b CLIENT SPECIFIED WHERE a~mandt = b~client AND a~kunnr = b~customer ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

      ELSE.
        OPEN CURSOR: s_cursor FOR
*        select * from kna1 as a client specified where lifnr = '' and  kunnr not in
*        ( select customer from cvi_cust_link as b client specified where a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

      SELECT * FROM kna1 AS a CLIENT SPECIFIED
*         WHERE lifnr = '' AND  kunnr NOT IN ( SELECT customer FROM cvi_cust_link AS b CLIENT SPECIFIED WHERE a~mandt = b~client AND a~kunnr = b~customer ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
         WHERE kunnr NOT IN ( SELECT customer FROM cvi_cust_link AS b CLIENT SPECIFIED WHERE a~mandt = b~client AND a~kunnr = b~customer ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

      ENDIF.
    ENDIF.

    DO.
      FETCH NEXT CURSOR s_cursor INTO TABLE lt_kna1 PACKAGE SIZE p_psize.
      IF sy-subrc NE 0 .
        CLOSE CURSOR s_cursor.
        gv_kna1 = 'X'.
        EXIT .
      ELSE.
        SORT lt_kna1 BY mandt kunnr.
        LOOP AT lt_kna1 INTO ls_kna1.
          ls_key-kunnr = ls_kna1-kunnr .
          ls_key-mandt = ls_kna1-mandt .
          APPEND ls_key TO lt_keys.
          MOVE-CORRESPONDING ls_kna1 TO ls_kna1_temp.
          APPEND ls_kna1 TO lt_kna1_temp.
          CLEAR ls_key.
          CLEAR ls_kna1_temp.
          CLEAR ls_kna1.
        ENDLOOP.
      ENDIF.


*      call method cmd_ei_api_check=>check_cust_part_of_retail_site
*        EXPORTING
*          it_keys         = lt_keys
*          it_kna1         = lt_kna1_temp
*        IMPORTING
*          et_part_of_site = lt_kna1_key.

      PERFORM check_cust_part_of_retail_site USING lt_keys lt_kna1_temp CHANGING lt_kna1_key.

      SORT lt_kna1 BY  mandt ktokd.
*      DELETE ADJACENT DUPLICATES FROM lt_kna1 COMPARING  mandt ktokd.

      LOOP AT lt_kna1 INTO ls_kna1.
        READ TABLE lt_kna1_key INTO ls_kna1_key WITH KEY kunnr = ls_kna1-kunnr.
        IF sy-subrc = 0.
          DELETE TABLE lt_kna1 FROM ls_kna1.
        ENDIF.
        CLEAR ls_kna1.
        CLEAR ls_kna1_key.
      ENDLOOP.


      LOOP AT lt_kna1 INTO ls_kna1 WHERE kunnr IS NOT INITIAL.

*      if lv_cust_count le 1000.
*      if ls_kna1-dear6 is NOT INITIAL.
        READ TABLE gt_check_final ASSIGNING <ls_final> WITH KEY chkid = 'CHK_3'.
        IF sy-subrc = 0.
          gs_check_msg-chkid = <ls_final>-chkid.
          gs_check_msg-status = '@0A@'.
          gs_check_msg-tabname = 'CVI_CUST_LINK'.
          gs_check_msg-client = ls_kna1-mandt.
*          concatenate ls_kna1-kunnr 'Customer Not having CVI Mapping' into gs_check_msg-msg_name separated by space.
          CONCATENATE ls_kna1-kunnr  'is not having CVI mapping check the table'  'CVI_CUST_LINK in client' ls_kna1-mandt ' kindly refer note 2210486'
          INTO gs_check_msg-msg_name IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT

          APPEND  gs_check_msg TO gt_check_msg.

          <ls_final>-status = '@0A@'.
          <ls_final>-stat_chk = 'E'.
        ENDIF.
*        lv_cust_count = lv_cust_count + 1.
*      endif.
*        endif.
        CLEAR ls_kna1.

      ENDLOOP.

      REFRESH lt_kna1.
      REFRESH lt_kna1_temp.
      REFRESH lt_kna1_key.
      REFRESH lt_keys.
*    clear lv_cust_count.

      FREE : lt_kna1,
             lt_kna1_temp,
             lt_kna1_key,
             lt_keys.
    ENDDO.





*
*  select * from kna1 into corresponding fields of table lt_kna1.
*  sort lt_kna1 by mandt kunnr.
*  loop at lt_kna1 into ls_kna1.
*    ls_key-kunnr = ls_kna1-kunnr .
*    append ls_key to lt_keys.
*    move-corresponding ls_kna1 to ls_kna1_temp.
*    append ls_kna1 to lt_kna1_temp.
*    clear ls_key.
*    clear ls_kna1_temp.
*    clear ls_kna1.
*  endloop.

*  call method cmd_ei_api_check=>check_cust_part_of_retail_site
*    EXPORTING
*      it_keys         = lt_keys
*      it_kna1         = lt_kna1_temp
*    IMPORTING
*      et_part_of_site = lt_kna1_key.


    IF s_cursor_lfa1 IS INITIAL.
      IF gs_input IS NOT INITIAL.
        OPEN CURSOR: s_cursor_lfa1 FOR
*        select * from lfa1 as a client specified up to gs_input rows
*         where kunnr = '' and lifnr not in
*         ( select vendor from cvi_vend_link as b client specified where a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

        SELECT * FROM lfa1 AS a CLIENT SPECIFIED UP TO gs_input ROWS
*           WHERE kunnr = '' AND lifnr NOT IN ( SELECT vendor FROM cvi_vend_link AS b CLIENT SPECIFIED WHERE a~mandt = b~client AND a~lifnr = b~vendor ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
           WHERE lifnr NOT IN ( SELECT vendor FROM cvi_vend_link AS b CLIENT SPECIFIED WHERE a~mandt = b~client AND a~lifnr = b~vendor ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

      ELSE.
        OPEN CURSOR: s_cursor_lfa1 FOR
*        select * from lfa1 as a client specified
*            where kunnr = '' and lifnr not in
*            ( select vendor from cvi_vend_link as b client specified where a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

        SELECT * FROM lfa1 AS a CLIENT SPECIFIED
*           WHERE kunnr = '' AND lifnr NOT IN ( SELECT vendor FROM cvi_vend_link AS b CLIENT SPECIFIED WHERE a~mandt = b~client AND a~lifnr = b~vendor ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
           WHERE lifnr NOT IN ( SELECT vendor FROM cvi_vend_link AS b CLIENT SPECIFIED WHERE a~mandt = b~client AND a~lifnr = b~vendor ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

      ENDIF.
    ENDIF.
    DO.
      FETCH NEXT CURSOR s_cursor_lfa1 INTO TABLE lt_lfa1 PACKAGE SIZE p_psize.
      IF sy-subrc NE 0 .
        CLOSE CURSOR s_cursor_lfa1.
        gv_lfa1 = 'X'.
        EXIT .
      ELSE.
        SORT lt_lfa1 BY mandt lifnr .
        LOOP AT lt_lfa1 INTO ls_lfa1.
          ls_key_vend-lifnr = ls_lfa1-lifnr .
          ls_key_vend-mandt = ls_lfa1-mandt .
          APPEND ls_key_vend TO lt_keys_vend.
          MOVE-CORRESPONDING ls_lfa1 TO ls_lfa1_temp.
          APPEND ls_lfa1 TO lt_lfa1_temp.
          CLEAR ls_key_vend.
          CLEAR ls_lfa1_temp.
          CLEAR ls_lfa1.
        ENDLOOP.
      ENDIF.


*      call method vmd_ei_api_check=>check_vend_part_of_retail_site
*        EXPORTING
*          it_keys         = lt_keys_vend
*          it_lfa1         = lt_lfa1_temp
*        IMPORTING
*          et_part_of_site = lt_lfa1_key.

      PERFORM check_vend_part_of_retail_site USING lt_keys_vend lt_lfa1_temp CHANGING lt_lfa1_key.


      LOOP AT lt_lfa1 INTO ls_lfa1.
        READ TABLE lt_lfa1_key INTO ls_lfa1_key WITH KEY lifnr = ls_lfa1-lifnr.
        IF sy-subrc = 0.
          DELETE TABLE lt_lfa1 FROM ls_lfa1.
        ENDIF.
        CLEAR ls_lfa1.
        CLEAR ls_lfa1_key.
      ENDLOOP.

*      DELETE ADJACENT DUPLICATES FROM lt_lfa1 COMPARING mandt ktokk.

      LOOP AT lt_lfa1 INTO ls_lfa1 WHERE lifnr IS NOT INITIAL .
*        if lv_vend_count le 1000.
        READ TABLE gt_check_final ASSIGNING <ls_final> WITH KEY chkid = 'CHK_3'.
        IF sy-subrc = 0.
          gs_check_msg-chkid = <ls_final>-chkid.
          gs_check_msg-status = '@0A@'.
          gs_check_msg-tabname = 'CVI_VEND_LINK'.
          gs_check_msg-client = ls_lfa1-mandt.
*          concatenate ls_lfa1-lifnr  'Vendor not having CVI Mapping' into gs_check_msg-msg_name separated by space.
          CONCATENATE ls_lfa1-lifnr 'is not having CVI mapping check the table'  'CVI_VEND_LINK in client' ls_lfa1-mandt ' kindly refer note 2210486'
          INTO gs_check_msg-msg_name IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT

          APPEND  gs_check_msg TO gt_check_msg.

          <ls_final>-status = '@0A@'.
          <ls_final>-stat_chk = 'E'.

        ENDIF.
*          lv_vend_count = lv_vend_count + 1.
*        endif.

      ENDLOOP.
      REFRESH lt_lfa1.
      REFRESH lt_lfa1_temp.
      REFRESH lt_lfa1_key.
      REFRESH lt_keys_vend.
*      clear lv_vend_count.

      FREE: lt_lfa1, lt_lfa1_temp, lt_lfa1_key, lt_keys_vend.
    ENDDO.







*      select * from lfa1 into corresponding fields of table lt_lfa1.
*      sort lt_lfa1 by mandt lifnr.
*      loop at lt_lfa1 into ls_lfa1.
*        ls_key_vend-lifnr = ls_lfa1-kunnr .
*        append ls_key_vend to lt_keys_vend.
*        move-corresponding ls_lfa1 to ls_lfa1_temp.
*        append ls_lfa1 to lt_lfa1_temp.
*        clear ls_key_vend.
*        clear ls_lfa1_temp.
*        clear ls_lfa1.
*      endloop.

*      call method vmd_ei_api_check=>check_vend_part_of_retail_site
*        EXPORTING
*          it_keys         = lt_keys_vend
*          it_lfa1         = lt_lfa1_temp
*        IMPORTING
*          et_part_of_site = lt_lfa1_key.




*      select * from kna1 into corresponding fields of table lt_kna1 where kunnr  not in ( select customer from cvi_cust_link ). "#EC CI_NOWHERE  "#EC CI_BUFFSUBQ.


*      data : ls_kna1_key like line of lt_kna1_key.


*      loop at lt_kna1 into ls_kna1.
*        read table lt_kna1_key into ls_kna1_key with key kunnr = ls_kna1-kunnr.
*        if sy-subrc = 0.
*          delete table lt_kna1 from ls_kna1.
*        endif.
*        clear ls_kna1.
*        clear ls_kna1_key.
*      endloop.
*
*
*      loop at lt_kna1 into ls_kna1 where kunnr is not initial.
*
*        read table gt_check_final assigning <ls_final> with key chkid = 'CHK_3'.
*        if sy-subrc = 0.
*          gs_check_msg-chkid = <ls_final>-chkid.
*          gs_check_msg-status = '@0A@'.
*          concatenate ls_kna1-kunnr 'Customer Not having CVI Mapping' into gs_check_msg-msg_name separated by space.
*          append  gs_check_msg to gt_check_msg.
*
*          <ls_final>-status = '@0A@'.
*          <ls_final>-stat_chk = 'E'.
*        endif.
*        clear ls_kna1.
*
*      endloop.



*      select * from lfa1 into corresponding fields of table  lt_lfa1  where lifnr not in ( select vendor from cvi_vend_link ). "#EC CI_NOWHERE  "#EC CI_BUFFSUBQ.


*     data : ls_lfa1_key like line of lt_lfa1_key.

*      loop at lt_lfa1 into ls_lfa1.
*        read table lt_lfa1_key into ls_lfa1_key with key lifnr = ls_lfa1-lifnr.
*        if sy-subrc = 0.
*          delete table lt_lfa1 from ls_lfa1.
*        endif.
*        clear ls_lfa1.
*        clear ls_lfa1_key.
*      endloop.


*      loop at lt_lfa1 into ls_lfa1 where lifnr is not initial .
*
*        read table gt_check_final assigning <ls_final> with key chkid = 'CHK_3'.
*        if sy-subrc = 0.
*          gs_check_msg-chkid = <ls_final>-chkid.
*          gs_check_msg-status = '@0A@'.
*          concatenate ls_lfa1-lifnr  'Vendor not having CVI Mapping' into gs_check_msg-msg_name separated by space.
*          append  gs_check_msg to gt_check_msg.
*
*          <ls_final>-status = '@0A@'.
*          <ls_final>-stat_chk = 'E'.
*
*        endif.


*      endloop.
*    sort gt_check_msg by client msg_name.
*    delete adjacent duplicates from gt_check_msg comparing msg_name.
    SORT gt_check_msg BY chkid(6) status msg_name tabname client."   type mandt,
    DELETE ADJACENT DUPLICATES FROM gt_check_msg COMPARING chkid(6) status msg_name tabname client.


    IF gt_check_msg IS NOT INITIAL.
      READ TABLE gt_check_msg INTO gs_msg_check INDEX 1.
      IF sy-subrc = 0.
        APPEND gs_msg_check TO gt_msg_check.
      ENDIF.
      CLEAR gs_msg_check.
    ENDIF.

    LOOP AT gt_check_final ASSIGNING <ls_final> WHERE chkid = 'CHK_3' .
      IF <ls_final>-stat_chk <> 'E'.
        <ls_final>-status = '@08@'.
      ENDIF.

    ENDLOOP.

  ENDTRY.
ENDFORM.                    "chk_op3
*&---------------------------------------------------------------------*
*& Form CHK_OP4
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM chk_op4 .

  DATA : lt_knvk TYPE TABLE OF knvk.
  DATA : ls_knvk LIKE LINE OF lt_knvk.
  DATA : lt_kna1 TYPE TABLE OF kna1.
  DATA : ls_kna1 LIKE LINE OF lt_kna1.
  DATA : lt_cvic_cp1_link TYPE TABLE OF cvic_cp1_link.
  DATA : ls_cviv_cp1_link LIKE LINE OF  lt_cvic_cp1_link.
  DATA : ls_map_contact TYPE cvic_map_contact.
  FIELD-SYMBOLS : <ls_final> LIKE LINE OF gt_check_final.
  DATA :ls_cvic_cp1_link LIKE LINE OF lt_cvic_cp1_link.
  DATA : lt_cvic_cp2_link TYPE TABLE OF cvic_cp2_link.
  DATA : ls_cvic_cp2_link LIKE LINE OF lt_cvic_cp2_link.
  DATA : lt_cvic_cp3_link TYPE TABLE OF cvic_cp3_link.
  DATA : ls_cvic_cp3_link LIKE LINE OF lt_cvic_cp3_link.
  DATA : lt_cvic_cp4_link TYPE TABLE OF cvic_cp4_link.
  DATA : ls_cvic_cp4_link LIKE LINE OF lt_cvic_cp4_link.
  DATA: lt_cvic_marst_link  TYPE STANDARD TABLE OF cvic_marst_link .
  DATA: ls_cvic_marst_link  LIKE LINE OF lt_cvic_marst_link .
  DATA : lt_cvic_legform_lnk TYPE STANDARD TABLE OF cvic_legform_lnk.
  DATA: ls_cvic_legform_lnk LIKE LINE OF lt_cvic_legform_lnk.
  DATA : lt_tp038m2  TYPE STANDARD TABLE OF tp038m2 .
  DATA : ls_tp038m2  LIKE LINE OF lt_tp038m2 .
  DATA : lt_tsab TYPE STANDARD TABLE OF tsab.
  DATA : ls_tsab LIKE LINE OF lt_tsab.
  DATA : lt_tpfk TYPE STANDARD TABLE OF tpfk.
  DATA : ls_tpfk LIKE LINE OF lt_tpfk.
  DATA : lt_tvpv TYPE STANDARD TABLE OF tvpv.
  DATA : ls_tvpv LIKE LINE OF lt_tvpv.
  DATA : lt_martial TYPE TABLE OF t502t.
  DATA : ls_martial LIKE LINE OF lt_martial.
  DATA : lt_tvip TYPE STANDARD TABLE OF tvip.
  DATA : ls_tvip LIKE LINE OF lt_tvip.
  DATA :lt_tvgf TYPE STANDARD TABLE OF tvgf.
  DATA : ls_tvgf LIKE LINE OF lt_tvgf.
  DATA : lt_keys TYPE  cmds_kna1_t .
  DATA : ls_key LIKE LINE OF lt_keys.
  DATA : lt_kna1_temp TYPE cmds_kna1_t.
  DATA : ls_kna1_temp LIKE LINE OF lt_kna1_temp.
  DATA : lt_kna1_key  TYPE cmds_customer_numbers_s_t.


*  select * from kna1 into corresponding fields of table lt_kna1.
*  sort lt_kna1 by mandt kunnr.
*  loop at lt_kna1 into ls_kna1.
*    ls_key-kunnr = ls_kna1-kunnr .
*    append ls_key to lt_keys.
*    move-corresponding ls_kna1 to ls_kna1_temp.
*    append ls_kna1 to lt_kna1_temp.
*    clear ls_key.
*    clear ls_kna1_temp.
*    clear ls_kna1.
*  endloop.
*
*  call method cmd_ei_api_check=>check_cust_part_of_retail_site
*    EXPORTING
*      it_keys         = lt_keys
*      it_kna1         = lt_kna1_temp
*    IMPORTING
*      et_part_of_site = lt_kna1_key.




* a.  Activate Assignment of Contact Persons

  SELECT SINGLE * FROM cvic_map_contact CLIENT SPECIFIED INTO ls_map_contact .
  IF ls_map_contact-map_contact IS INITIAL.
    READ TABLE gt_check_final ASSIGNING <ls_final> WITH KEY chkid = 'CHK_4'.
    IF sy-subrc = 0.
      gs_check_msg-chkid = <ls_final>-chkid.
      gs_check_msg-status = '@0A@'.
      gs_check_msg-tabname = 'CVIC_MAP_CONTACT'.
      gs_check_msg-client = ls_map_contact-client.
*      concatenate  'Contact person Assignment not activated' ' ' into gs_check_msg-msg_name separated by space.
      CONCATENATE 'Contact person Assignment not activated and not maintained in table' 'CVIC_MAP_CONTACT in client' ls_map_contact-client 'kindly refer note 2210486'
      INTO gs_check_msg-msg_name IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT

      APPEND  gs_check_msg TO gt_check_msg.

      <ls_final>-status = '@0A@'.
      <ls_final>-stat_chk = 'E'.
    ENDIF.
  ENDIF.




*b.	Assign Department Numbers for Contact Person

*    select distinct * from knvk into corresponding fields of table lt_knvk where abtnr is not null and abtnr not in ( select abtnr from cvic_cp1_link ). "#EC CI_NOWHERE  "#EC CI_BUFFSUBQ.
*
*    loop at  lt_knvk into ls_knvk  where abtnr is not initial  .
*      read table gt_check_final assigning <ls_final> with key chkid = 'CHK_4'.
*      if sy-subrc = 0.
*        gs_check_msg-chkid = <ls_final>-chkid.
*        gs_check_msg-status = '@0A@'.
*        concatenate ls_knvk-abtnr  'Department number not maintained' into gs_check_msg-msg_name separated by space.
*        append  gs_check_msg to gt_check_msg.
*
*        <ls_final>-status = '@0A@'.
*        <ls_final>-stat_chk = 'E'.
*      endif.
*
*    endloop.
*    refresh lt_knvk.


  DATA : p_psize_knvk  TYPE integer VALUE '1000',
         s_cursor_knvk TYPE cursor.  " Package size

  IF s_cursor_knvk IS INITIAL.
    IF gs_input IS NOT INITIAL.
      OPEN CURSOR : s_cursor_knvk FOR
*      select distinct * from knvk as a client specified up to gs_input rows
*                                    where abtnr is not null and abtnr not in ( select abtnr from cvic_cp1_link as b client specified where a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

       SELECT DISTINCT * FROM knvk AS a CLIENT SPECIFIED UP TO gs_input ROWS
          WHERE abtnr IS NOT NULL AND abtnr NOT IN ( SELECT abtnr FROM cvic_cp1_link AS b CLIENT SPECIFIED WHERE a~mandt = b~client AND a~abtnr = b~abtnr ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

    ELSE.
      OPEN CURSOR : s_cursor_knvk FOR
*      select distinct * from knvk as a client specified
*                                      where abtnr is not null and abtnr not in ( select abtnr from cvic_cp1_link as b client specified where a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

       SELECT DISTINCT * FROM knvk AS a CLIENT SPECIFIED
          WHERE abtnr IS NOT NULL AND abtnr NOT IN ( SELECT abtnr FROM cvic_cp1_link AS b CLIENT SPECIFIED WHERE a~mandt = b~client AND a~abtnr = b~abtnr ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

    ENDIF.
  ENDIF.
  DO.
    FETCH NEXT CURSOR s_cursor_knvk  INTO TABLE lt_knvk PACKAGE SIZE p_psize_knvk.
    IF sy-subrc NE 0 .
      CLOSE CURSOR s_cursor_knvk.
      EXIT .
    ELSE.

      LOOP AT  lt_knvk INTO ls_knvk  WHERE abtnr IS NOT INITIAL  .
        READ TABLE gt_check_final ASSIGNING <ls_final> WITH KEY chkid = 'CHK_4'.
        IF sy-subrc = 0.
          gs_check_msg-chkid = <ls_final>-chkid.
          gs_check_msg-status = '@0A@'.
          gs_check_msg-tabname = 'CVIV_CP1_LINK'.
          gs_check_msg-client = ls_knvk-mandt.
*          concatenate ls_knvk-abtnr  'Department number not maintained' into gs_check_msg-msg_name separated by space.
          CONCATENATE ls_knvk-abtnr 'Department not maintained in table' 'CVIC_CP1_LINK in client' ls_knvk-mandt 'kindly refer note 2210486'
          INTO gs_check_msg-msg_name IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT
          APPEND  gs_check_msg TO gt_check_msg.

          <ls_final>-status = '@0A@'.
          <ls_final>-stat_chk = 'E'.
        ENDIF.
        CLEAR ls_knvk.
      ENDLOOP.
      REFRESH lt_knvk.
      FREE lt_knvk.
    ENDIF.
  ENDDO.



*c.	Assign Functions of Contact Person

*  select  distinct * from knvk into corresponding fields of table lt_knvk where pafkt is not null and pafkt not in ( select pafkt from cvic_cp2_link ). "#EC CI_NOWHERE  "#EC CI_BUFFSUBQ.
*
*  loop at lt_knvk into ls_knvk where pafkt is not initial.
*    read table gt_check_final assigning <ls_final> with key chkid = 'CHK_4'.
*    if sy-subrc = 0.
*      gs_check_msg-chkid = <ls_final>-chkid.
*      gs_check_msg-status = '@0A@'.
*      concatenate ls_knvk-pafkt  'Function not assigned' into gs_check_msg-msg_name separated by space.
*      append  gs_check_msg to gt_check_msg.
*      <ls_final>-status = '@0A@'.
*      <ls_final>-stat_chk = 'E'.
*    endif.
*  endloop.
*  refresh lt_knvk.

  DATA : s_cursor_knvk6 TYPE cursor.
  DATA : p_psize_knvk6 TYPE integer VALUE '1000'.
  IF s_cursor_knvk6 IS INITIAL.
    IF gs_input IS   NOT  INITIAL.
      OPEN CURSOR : s_cursor_knvk6 FOR
*      select distinct * from knvk as a client specified up to gs_input rows
*                                           where pafkt is not null and pafkt not in
*                                           ( select pafkt from cvic_cp2_link as b client specified where a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

       SELECT DISTINCT * FROM knvk AS a CLIENT SPECIFIED UP TO gs_input ROWS
          WHERE pafkt IS NOT NULL AND pafkt NOT IN ( SELECT pafkt FROM cvic_cp2_link AS b CLIENT SPECIFIED WHERE a~mandt = b~client AND a~pafkt = b~pafkt ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

    ELSE.
      OPEN CURSOR : s_cursor_knvk6 FOR
*      select distinct * from knvk as a client specified
*                                             where pafkt is not null and pafkt not in
*                                             ( select pafkt from cvic_cp2_link as b client specified where a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

       SELECT DISTINCT * FROM knvk AS a CLIENT SPECIFIED
          WHERE pafkt IS NOT NULL AND pafkt NOT IN ( SELECT pafkt FROM cvic_cp2_link AS b CLIENT SPECIFIED WHERE a~mandt = b~client AND a~pafkt = b~pafkt ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

    ENDIF.
  ENDIF.
  DO.
    FETCH NEXT CURSOR s_cursor_knvk6  INTO TABLE lt_knvk PACKAGE SIZE p_psize_knvk6.
    IF sy-subrc NE 0 .
      CLOSE CURSOR s_cursor_knvk6.
      EXIT .
    ELSE.
      LOOP AT lt_knvk INTO ls_knvk WHERE pafkt IS NOT INITIAL.
        READ TABLE gt_check_final ASSIGNING <ls_final> WITH KEY chkid = 'CHK_4'.
        IF sy-subrc = 0.
          gs_check_msg-chkid = <ls_final>-chkid.
          gs_check_msg-status = '@0A@'.
          gs_check_msg-tabname = 'CVIV_CP2_LINK'.
          gs_check_msg-client = ls_knvk-mandt.
*          concatenate ls_knvk-pafkt  'Function not assigned' into gs_check_msg-msg_name separated by space.
          CONCATENATE ls_knvk-pafkt 'Function not maintained in table' 'CVIC_CP2_LINK in client' ls_knvk-mandt 'kindly refer note 2210486'
          INTO gs_check_msg-msg_name IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT
          APPEND  gs_check_msg TO gt_check_msg.
          <ls_final>-status = '@0A@'.
          <ls_final>-stat_chk = 'E'.
        ENDIF.
        CLEAR ls_knvk.
      ENDLOOP.
      REFRESH lt_knvk.
      FREE lt_knvk.
    ENDIF.
  ENDDO.


*d.	Assign Authority of Contact Person

*  select  distinct * from knvk into corresponding fields of table lt_knvk where parvo is not null and parvo  not in ( select parvo from cvic_cp3_link ). "#EC CI_NOWHERE  "#EC CI_BUFFSUBQ.
*  loop at  lt_knvk into ls_knvk where parvo is not initial.
*    read table gt_check_final assigning <ls_final> with key chkid = 'CHK_4'.
*    if sy-subrc = 0.
*      gs_check_msg-chkid = <ls_final>-chkid.
*      gs_check_msg-status = '@0A@'.
*      concatenate ls_knvk-parvo 'Authority of Contact Person Not maintained' into gs_check_msg-msg_name separated by space.
*      append  gs_check_msg to gt_check_msg.
*      <ls_final>-status = '@0A@'.
*      <ls_final>-stat_chk = 'E'.
*    endif.
*  endloop.
*  refresh lt_knvk.

  DATA : s_cursor_knvk1 TYPE cursor.
  DATA : p_psize_knvk1 TYPE integer VALUE '1000'.
  IF s_cursor_knvk1 IS INITIAL.
    IF gs_input IS NOT INITIAL.
      OPEN CURSOR : s_cursor_knvk1 FOR
*      select distinct * from knvk as a client specified up to gs_input rows
*                                                               where parvo is not null and parvo  not in ( select parvo from cvic_cp3_link as b client specified where a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

       SELECT DISTINCT * FROM knvk AS a CLIENT SPECIFIED UP TO gs_input ROWS
          WHERE parvo IS NOT NULL AND parvo NOT IN ( SELECT parvo FROM cvic_cp3_link AS b CLIENT SPECIFIED WHERE a~mandt = b~client AND a~parvo = b~parvo ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

    ELSE.
      OPEN CURSOR : s_cursor_knvk1 FOR
*      select distinct * from knvk as a client specified
*                                                                 where parvo is not null and parvo  not in ( select parvo from cvic_cp3_link as b client specified where a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

       SELECT DISTINCT * FROM knvk AS a CLIENT SPECIFIED
          WHERE parvo IS NOT NULL AND parvo NOT IN ( SELECT parvo FROM cvic_cp3_link AS b CLIENT SPECIFIED WHERE a~mandt = b~client AND a~parvo = b~parvo ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

    ENDIF.
  ENDIF.
  DO.
    FETCH NEXT CURSOR s_cursor_knvk1  INTO TABLE lt_knvk PACKAGE SIZE p_psize_knvk1.
    IF sy-subrc NE 0 .
      CLOSE CURSOR s_cursor_knvk1.
      EXIT .
    ELSE.
      LOOP AT  lt_knvk INTO ls_knvk WHERE parvo IS NOT INITIAL.
        READ TABLE gt_check_final ASSIGNING <ls_final> WITH KEY chkid = 'CHK_4'.
        IF sy-subrc = 0.
          gs_check_msg-chkid = <ls_final>-chkid.
          gs_check_msg-status = '@0A@'.
          gs_check_msg-tabname = 'CVIV_CP3_LINK'.
          gs_check_msg-client = ls_knvk-mandt.
*          concatenate ls_knvk-parvo 'Authority of Contact Person Not maintained' into gs_check_msg-msg_name separated by space.
          CONCATENATE ls_knvk-parvo 'Authority not mainatined in table' 'CVIC_CP3_LINK in client' ls_knvk-mandt  'kindly refer note 2210486'
          INTO gs_check_msg-msg_name IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT
          APPEND  gs_check_msg TO gt_check_msg.
          <ls_final>-status = '@0A@'.
          <ls_final>-stat_chk = 'E'.
        ENDIF.
        CLEAR ls_knvk.
      ENDLOOP.
      REFRESH lt_knvk.
      FREE lt_knvk.
    ENDIF.
  ENDDO.


*e.	Assign VIP Indicator for Contact Person
*  select distinct * from knvk into corresponding fields of table lt_knvk where pavip is not null and pavip  not in ( select pavip from cvic_cp4_link ). "#EC CI_NOWHERE  "#EC CI_BUFFSUBQ.
*  loop at lt_knvk into ls_knvk  where pavip is not initial .
*    read table gt_check_final assigning <ls_final> with key chkid = 'CHK_4'.
*    if sy-subrc = 0.
*      gs_check_msg-chkid = <ls_final>-chkid.
*      gs_check_msg-status = '@0A@'.
*      concatenate ls_tvip-pavip  'VIP Indicator not assigned' into gs_check_msg-msg_name separated by space.
*      append  gs_check_msg to gt_check_msg.
*      <ls_final>-status = '@0A@'.
*      <ls_final>-stat_chk = 'E'.
*    endif.
*  endloop.
*  refresh lt_knvk.

  DATA : s_cursor_knvk2 TYPE cursor.
  DATA : p_psize_knvk2 TYPE integer VALUE '1000'.
  IF s_cursor_knvk2 IS INITIAL.
    IF gs_input IS NOT INITIAL.
      OPEN CURSOR : s_cursor_knvk2 FOR
*      select distinct * from knvk as a client specified up to gs_input rows
*                                               where pavip is not null and pavip  not in ( select pavip from cvic_cp4_link as b client specified where a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

       SELECT DISTINCT * FROM knvk AS a CLIENT SPECIFIED UP TO gs_input ROWS
          WHERE pavip IS NOT NULL AND pavip  NOT IN ( SELECT pavip FROM cvic_cp4_link AS b CLIENT SPECIFIED WHERE a~mandt = b~client AND a~pavip = b~pavip ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

    ELSE.
      OPEN CURSOR : s_cursor_knvk2 FOR
*      select distinct * from knvk as a client specified
*                                                 where pavip is not null and pavip  not in ( select pavip from cvic_cp4_link as b client specified where a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

       SELECT DISTINCT * FROM knvk AS a CLIENT SPECIFIED
          WHERE pavip IS NOT NULL AND pavip  NOT IN ( SELECT pavip FROM cvic_cp4_link AS b CLIENT SPECIFIED WHERE a~mandt = b~client AND a~pavip = b~pavip ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

    ENDIF.
  ENDIF.
  DO.
    FETCH NEXT CURSOR s_cursor_knvk2  INTO TABLE lt_knvk PACKAGE SIZE p_psize_knvk2.
    IF sy-subrc NE 0 .
      CLOSE CURSOR s_cursor_knvk2.
      EXIT .
    ELSE.
      LOOP AT lt_knvk INTO ls_knvk  WHERE pavip IS NOT INITIAL .
        READ TABLE gt_check_final ASSIGNING <ls_final> WITH KEY chkid = 'CHK_4'.
        IF sy-subrc = 0.
          gs_check_msg-chkid = <ls_final>-chkid.
          gs_check_msg-status = '@0A@'.
          gs_check_msg-tabname = 'CVIV_CP4_LINK'.
          gs_check_msg-client = ls_knvk-mandt.
*          concatenate ls_tvip-pavip  'VIP Indicator not assigned' into gs_check_msg-msg_name separated by space.
          CONCATENATE ls_knvk-pavip 'VIP Indicator not mainatined in table' 'CVIC_CP4_LINK in client'ls_knvk-mandt 'Kindly refer note 2210486'
          ls_knvk-mandt  INTO gs_check_msg-msg_name IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT
          APPEND  gs_check_msg TO gt_check_msg.
          <ls_final>-status = '@0A@'.
          <ls_final>-stat_chk = 'E'.
        ENDIF.
        CLEAR ls_knvk.
      ENDLOOP.
      REFRESH lt_knvk.
      FREE lt_knvk.
    ENDIF.
  ENDDO.


*a.	Assign Marital Statuses
*  select  distinct * from knvk into corresponding fields of table lt_knvk where famst is not null and famst not in ( select famst from  cvic_marst_link ). "#EC CI_NOWHERE  "#EC CI_BUFFSUBQ.
*
*  loop at  lt_knvk into ls_knvk where famst is not initial .
*    read table gt_check_final assigning <ls_final> with key chkid = 'CHK_4'.
*    if sy-subrc = 0.
*      gs_check_msg-chkid = <ls_final>-chkid.
*      gs_check_msg-status = '@0A@'.
*      concatenate ls_martial-famst 'Martial status not maintained' into gs_check_msg-msg_name separated by space.
*      append  gs_check_msg to gt_check_msg.
*      <ls_final>-status = '@0A@'.
*      <ls_final>-stat_chk = 'E'.
*    endif.
*
*
*  endloop.
*
*  refresh lt_knvk.
  DATA : s_cursor_knvk3 TYPE cursor.
  DATA : p_psize_knvk3 TYPE integer VALUE '1000'.
  IF s_cursor_knvk3 IS INITIAL.
    IF gs_input IS NOT INITIAL.
      OPEN CURSOR : s_cursor_knvk3 FOR
*      select distinct * from knvk as a  client specified up to gs_input rows
*                                  where famst is not null and famst not in ( select famst from  cvic_marst_link as b client specified where a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ

       SELECT DISTINCT * FROM knvk AS a  CLIENT SPECIFIED UP TO gs_input ROWS
          WHERE famst IS NOT NULL AND famst NOT IN ( SELECT famst FROM  cvic_marst_link AS b CLIENT SPECIFIED WHERE a~mandt = b~client AND a~famst = b~famst ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ

    ELSE.
      OPEN CURSOR : s_cursor_knvk3 FOR
*      select distinct * from knvk as a  client specified
*                                    where famst is not null and famst not in ( select famst from  cvic_marst_link as b client specified where a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ

       SELECT DISTINCT * FROM knvk AS a  CLIENT SPECIFIED
          WHERE famst IS NOT NULL AND famst NOT IN ( SELECT famst FROM  cvic_marst_link AS b CLIENT SPECIFIED WHERE a~mandt = b~client AND a~famst = b~famst ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ

    ENDIF.
  ENDIF.
  DO.
    FETCH NEXT CURSOR s_cursor_knvk3  INTO TABLE lt_knvk PACKAGE SIZE p_psize_knvk3.
    IF sy-subrc NE 0 .
      CLOSE CURSOR s_cursor_knvk3.
      EXIT .
    ELSE.
      LOOP AT  lt_knvk INTO ls_knvk WHERE famst IS NOT INITIAL .
        READ TABLE gt_check_final ASSIGNING <ls_final> WITH KEY chkid = 'CHK_4'.
        IF sy-subrc = 0.
          gs_check_msg-chkid = <ls_final>-chkid.
          gs_check_msg-status = '@0A@'.
          gs_check_msg-tabname = 'CVIV_MARST_LINK'.
          gs_check_msg-client = ls_knvk-mandt.
*      concatenate ls_martial-famst 'Martial status not maintained' into gs_check_msg-msg_name separated by space.
          CONCATENATE ls_knvk-famst 'Marital Status not mainatined in table' 'CVIC_MARST_LINK in client' ls_knvk-mandt 'kindly refer note 2210486'
          INTO gs_check_msg-msg_name IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT
          APPEND  gs_check_msg TO gt_check_msg.
          <ls_final>-status = '@0A@'.
          <ls_final>-stat_chk = 'E'.
        ENDIF.
      ENDLOOP.
      REFRESH lt_knvk.
      FREE lt_knvk.
    ENDIF.
  ENDDO.



*b.	Assign Legal Form to Legal Status

*  select  distinct * from kna1 into corresponding fields of table lt_kna1  where gform is not null and gform  not in ( select gform  from  cvic_legform_lnk  ). "#EC CI_NOWHERE  "#EC CI_BUFFSUBQ.
*  loop at lt_kna1 into ls_kna1.
*    read table lt_kna1_key into ls_kna1_key with key kunnr = ls_kna1-kunnr.
*    if sy-subrc = 0.
*      delete table lt_kna1 from ls_kna1.
*    endif.
*    clear ls_kna1.
*    clear ls_kna1_key.
*  endloop.
*  loop at lt_kna1 into ls_kna1 where gform is not initial .
*    read table gt_check_final assigning <ls_final> with key chkid = 'CHK_4'.
*    if sy-subrc = 0.
*      gs_check_msg-chkid = <ls_final>-chkid.
*      gs_check_msg-status = '@0A@'.
*      concatenate ls_kna1-gform  'Legal form to legal status is not assigned' into gs_check_msg-msg_name separated by space.
*      append  gs_check_msg to gt_check_msg.
*      <ls_final>-status = '@0A@'.
*      <ls_final>-stat_chk = 'E'.
*    endif.
*  endloop.
*  refresh lt_kna1.
  DATA : ls_kna1_key LIKE LINE OF lt_kna1_key.
  DATA : p_psize_kna1 TYPE integer VALUE '1000'.  " Package size
  DATA : p_psize_kna1_1 TYPE integer VALUE '1000'.
  DATA : s_cursor_kna1_val_map TYPE cursor.
  DATA : gv_kna1_value_mapping TYPE c.
  IF s_cursor_kna1_val_map IS INITIAL.
    IF gs_input IS NOT INITIAL.
      OPEN CURSOR: s_cursor_kna1_val_map FOR
*      select distinct * from kna1 as a client specified  up to gs_input rows where gform is not null and gform  not in
*         ( select gform  from  cvic_legform_lnk as b client specified where a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

       SELECT DISTINCT * FROM kna1 AS a CLIENT SPECIFIED  UP TO gs_input ROWS
          WHERE gform IS NOT NULL AND gform  NOT IN ( SELECT gform  FROM  cvic_legform_lnk AS b CLIENT SPECIFIED WHERE a~mandt = b~client AND a~gform = b~gform ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

    ELSE.
      OPEN CURSOR: s_cursor_kna1_val_map FOR
*      select distinct * from kna1 as a client specified  where gform is not null and gform  not in
*           ( select gform  from  cvic_legform_lnk as b client specified where a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

       SELECT DISTINCT * FROM kna1 AS a CLIENT SPECIFIED
          WHERE gform IS NOT NULL AND gform  NOT IN ( SELECT gform  FROM  cvic_legform_lnk AS b CLIENT SPECIFIED WHERE a~mandt = b~client AND a~gform = b~gform ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

    ENDIF.
  ENDIF.
  DO.
    FETCH NEXT CURSOR s_cursor_kna1_val_map INTO TABLE lt_kna1 PACKAGE SIZE p_psize_kna1.
    IF sy-subrc NE 0 .
      CLOSE CURSOR s_cursor_kna1_val_map.
      gv_kna1_value_mapping = 'X'.
      EXIT .
    ELSE.
      SORT lt_kna1 BY mandt kunnr.
      LOOP AT lt_kna1 INTO ls_kna1.
        ls_key-kunnr = ls_kna1-kunnr .
        ls_key-mandt = ls_kna1-mandt.
        APPEND ls_key TO lt_keys.
        READ TABLE lt_kna1_key INTO ls_kna1_key WITH KEY kunnr = ls_kna1-kunnr.
        IF sy-subrc = 0.
          DELETE TABLE lt_kna1 FROM ls_kna1.
        ENDIF.
        CLEAR ls_kna1.
        CLEAR ls_kna1_key.
      ENDLOOP.
      LOOP AT lt_kna1 INTO ls_kna1 WHERE gform IS NOT INITIAL .
        READ TABLE gt_check_final ASSIGNING <ls_final> WITH KEY chkid = 'CHK_4'.
        IF sy-subrc = 0.
          gs_check_msg-chkid = <ls_final>-chkid.
          gs_check_msg-status = '@0A@'.
          gs_check_msg-tabname = 'CVIV_LEGFORM_LNK'.
          gs_check_msg-client = ls_kna1-mandt.
*          concatenate ls_kna1-gform  'Legal form to legal status is not assigned' into gs_check_msg-msg_name separated by space.
          CONCATENATE ls_kna1-gform 'Legal form not maintained in table' 'CVIC_LEGFORM_LNK in client' ls_kna1-mandt 'kindly refer note 2210486'
          INTO gs_check_msg-msg_name IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT
          APPEND  gs_check_msg TO gt_check_msg.
          <ls_final>-status = '@0A@'.
          <ls_final>-stat_chk = 'E'.
        ENDIF.
      ENDLOOP.
    ENDIF.

    PERFORM check_cust_part_of_retail_site USING lt_keys lt_kna1_temp CHANGING lt_kna1_key.

    REFRESH lt_kna1.
    REFRESH lt_kna1_temp.
    REFRESH lt_kna1_key.
    REFRESH lt_keys.
    FREE: lt_kna1, lt_kna1_temp, lt_kna1_key, lt_keys.
  ENDDO.





*	Assign Payment Cards
  DATA : lt_payment TYPE STANDARD TABLE OF vckun.
  DATA : ls_payment LIKE LINE OF lt_payment.
  DATA: lt_cvic_ccid_link TYPE STANDARD TABLE OF cvic_ccid_link.
  DATA : ls_cvic_ccid_link LIKE LINE OF lt_cvic_ccid_link.

  SELECT  * FROM vckun CLIENT SPECIFIED INTO CORRESPONDING FIELDS OF TABLE lt_payment WHERE ccins IS NOT NULL AND ccins NOT IN ( SELECT ccins FROM cvic_ccid_link ). "#EC CI_NOWHERE  "#EC CI_BUFFSUBQ.

  LOOP AT lt_payment INTO ls_payment WHERE ccins IS NOT INITIAL .

    READ TABLE gt_check_final ASSIGNING <ls_final> WITH KEY chkid = 'CHK_4'.
    IF sy-subrc = 0.
      gs_check_msg-chkid = <ls_final>-chkid.
      gs_check_msg-status = '@0A@'.
      gs_check_msg-tabname = 'CVIC_CCID_LINK'.
      gs_check_msg-client = ls_payment-mandt.
      CONCATENATE ls_payment-ccins 'Payment Card not maintained in table' 'CVIC_CCID_LINK in client' ls_payment-mandt 'kindly refer note 2210486'
      INTO gs_check_msg-msg_name SEPARATED BY space.
      APPEND  gs_check_msg TO gt_check_msg.
      <ls_final>-status = '@0A@'.
      <ls_final>-stat_chk = 'E'.
    ENDIF.
  ENDLOOP.


* d.  Assign Industries
  DATA : lt_tb038 TYPE STANDARD TABLE OF tb038.
  DATA : ls_tb038 LIKE LINE OF lt_tb038.
  DATA : lt_t016 TYPE STANDARD TABLE OF t016.
  DATA : ls_t016 LIKE   LINE OF lt_t016.
*  data : ls_kna1_key like line of lt_kna1_key.
*
*  select * from kna1 into corresponding fields of table lt_kna1  where brsch is not null and  brsch not in ( select brsch from tp038m2 ). "#EC CI_NOWHERE  "#EC CI_BUFFSUBQ.
*
*
*  loop at lt_kna1 into ls_kna1.
*    read table lt_kna1_key into ls_kna1_key with key kunnr = ls_kna1-kunnr.
*    if sy-subrc = 0.
*      delete table lt_kna1 from ls_kna1.
*    endif.
*    clear ls_kna1.
*    clear ls_kna1_key.
*  endloop.
*
*
*  loop at lt_kna1 into ls_kna1 where brsch is not initial .
*    read table gt_check_final assigning <ls_final> with key chkid = 'CHK_4'.
*    if sy-subrc = 0.
*      gs_check_msg-chkid = <ls_final>-chkid.
*      gs_check_msg-status = '@0A@'.
*      concatenate ls_kna1-brsch 'Industry key not assigned' into gs_check_msg-msg_name separated by space.
*      append  gs_check_msg to gt_check_msg.
*      <ls_final>-status = '@0A@'.
*      <ls_final>-stat_chk = 'E'.
*
*    endif.
*
*
*  endloop.
*
*  refresh lt_kna1.


  DATA : s_cursor_kna1_val_map1 TYPE cursor.
  DATA : gv_kna1_value_mapping1 TYPE c.
  IF s_cursor_kna1_val_map IS INITIAL.
    IF gs_input IS NOT INITIAL.
      OPEN CURSOR: s_cursor_kna1_val_map1 FOR
*      select distinct * from kna1 as a client specified up to gs_input rows
*    where brsch is not null and brsch not in ( select brsch from tp038m2 as b client specified where a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

     SELECT DISTINCT * FROM kna1 AS a CLIENT SPECIFIED UP TO gs_input ROWS
        WHERE brsch IS NOT NULL AND brsch NOT IN ( SELECT brsch FROM tp038m2 AS b CLIENT SPECIFIED WHERE a~mandt = b~client AND a~brsch = b~brsch ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

    ELSE.
      OPEN CURSOR: s_cursor_kna1_val_map1 FOR
*      select distinct * from kna1 as a client specified
*      where brsch is not null and brsch not in ( select brsch from tp038m2 as b client specified where a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

     SELECT DISTINCT * FROM kna1 AS a CLIENT SPECIFIED
        WHERE brsch IS NOT NULL AND brsch NOT IN ( SELECT brsch FROM tp038m2 AS b CLIENT SPECIFIED WHERE a~mandt = b~client AND a~brsch = b~brsch ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

    ENDIF.
  ENDIF.
  DO.
    FETCH NEXT CURSOR s_cursor_kna1_val_map1 INTO TABLE lt_kna1 PACKAGE SIZE p_psize_kna1.
    IF sy-subrc NE 0 .
      CLOSE CURSOR s_cursor_kna1_val_map1.
      gv_kna1_value_mapping1 = 'X'.
      EXIT .
    ELSE.
      SORT lt_kna1 BY mandt kunnr.
      LOOP AT lt_kna1 INTO ls_kna1.
        ls_key-kunnr = ls_kna1-kunnr .
        ls_key-mandt = ls_kna1-mandt.
        APPEND ls_key TO lt_keys.
        READ TABLE lt_kna1_key INTO ls_kna1_key WITH KEY kunnr = ls_kna1-kunnr.
        IF sy-subrc = 0.
          DELETE TABLE lt_kna1 FROM ls_kna1.
        ENDIF.
        CLEAR ls_kna1.
        CLEAR ls_kna1_key.
      ENDLOOP.
      LOOP AT lt_kna1 INTO ls_kna1 WHERE brsch IS NOT INITIAL .
        READ TABLE gt_check_final ASSIGNING <ls_final> WITH KEY chkid = 'CHK_4'.
        IF sy-subrc = 0.
          gs_check_msg-chkid = <ls_final>-chkid.
          gs_check_msg-status = '@0A@'.
          gs_check_msg-tabname = 'VC_TP038M'.
          gs_check_msg-client = ls_kna1-mandt.
*          concatenate ls_kna1-brsch 'Industry key not assigned' into gs_check_msg-msg_name separated by space.
          CONCATENATE ls_kna1-brsch 'Industry Not maintained in table ' 'TP038M2 in client'  ls_kna1-mandt 'kindly refer note 2210486'
          INTO gs_check_msg-msg_name IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT
          APPEND  gs_check_msg TO gt_check_msg.
          <ls_final>-status = '@0A@'.
          <ls_final>-stat_chk = 'E'.
        ENDIF.
      ENDLOOP.
    ENDIF.
    PERFORM check_cust_part_of_retail_site USING lt_keys lt_kna1_temp CHANGING lt_kna1_key.
    REFRESH lt_kna1.
    REFRESH lt_kna1_temp.
    REFRESH lt_kna1_key.
    REFRESH lt_keys.
    FREE: lt_kna1, lt_kna1_temp, lt_kna1_key, lt_keys.
  ENDDO.





*  select * from kna1 into corresponding fields of table lt_kna1  where brsch is not null and  brsch not in ( select brsch from tp038m1 ). "#EC CI_NOWHERE  "#EC CI_BUFFSUBQ.

*  loop at lt_kna1 into ls_kna1.
*    read table lt_kna1_key into ls_kna1_key with key kunnr = ls_kna1-kunnr.
*    if sy-subrc = 0.
*      delete table lt_kna1 from ls_kna1.
*    endif.
*    clear ls_kna1.
*    clear ls_kna1_key.
*  endloop.
*  loop at lt_kna1 into ls_kna1 where brsch is not initial .
*    read table gt_check_final assigning <ls_final> with key chkid = 'CHK_4'.
*    if sy-subrc = 0.
*      gs_check_msg-chkid = <ls_final>-chkid.
*      gs_check_msg-status = '@0A@'.
*      concatenate ls_kna1-brsch 'Industry key not assigned' into gs_check_msg-msg_name separated by space.
*      append  gs_check_msg to gt_check_msg.
*      <ls_final>-status = '@0A@'.
*      <ls_final>-stat_chk = 'E'.
*
*    endif.
*
*
*  endloop.

  DATA : s_cursor_kna1_val_map2 TYPE cursor.
  DATA : gv_kna1_value_mapping2 TYPE c.
  IF s_cursor_kna1_val_map IS INITIAL.
    IF gs_input IS   NOT INITIAL.
      OPEN CURSOR: s_cursor_kna1_val_map2 FOR
*      select distinct * from kna1 as a  client specified up to gs_input rows
*            where  brsch is not null and brsch not in ( select brsch from tp038m1 as b client specified  where a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ

       SELECT DISTINCT * FROM kna1 AS a  CLIENT SPECIFIED UP TO gs_input ROWS
          WHERE  brsch IS NOT NULL AND brsch NOT IN ( SELECT brsch FROM tp038m1 AS b CLIENT SPECIFIED  WHERE a~mandt = b~client AND a~brsch = b~brsch ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ

    ELSE.
      OPEN CURSOR: s_cursor_kna1_val_map2 FOR
*      select distinct * from kna1 as a  client specified
*              where  brsch is not null and brsch not in ( select brsch from tp038m1 as b client specified  where a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ

       SELECT DISTINCT * FROM kna1 AS a  CLIENT SPECIFIED
          WHERE  brsch IS NOT NULL AND brsch NOT IN ( SELECT brsch FROM tp038m1 AS b CLIENT SPECIFIED  WHERE a~mandt = b~client AND a~brsch = b~brsch ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ

    ENDIF.
  ENDIF.
  DO.
    FETCH NEXT CURSOR s_cursor_kna1_val_map2 INTO TABLE lt_kna1 PACKAGE SIZE p_psize_kna1.
    IF sy-subrc NE 0 .
      CLOSE CURSOR s_cursor_kna1_val_map2.
      gv_kna1_value_mapping2 = 'X'.
      EXIT .
    ELSE.
      SORT lt_kna1 BY mandt kunnr.
      LOOP AT lt_kna1 INTO ls_kna1.
        READ TABLE lt_kna1_key INTO ls_kna1_key WITH KEY kunnr = ls_kna1-kunnr.
        IF sy-subrc = 0.
          DELETE TABLE lt_kna1 FROM ls_kna1.
        ENDIF.
        CLEAR ls_kna1.
        CLEAR ls_kna1_key.
      ENDLOOP.
      LOOP AT lt_kna1 INTO ls_kna1 WHERE brsch IS NOT INITIAL .
        READ TABLE gt_check_final ASSIGNING <ls_final> WITH KEY chkid = 'CHK_4'.
        IF sy-subrc = 0.
          gs_check_msg-chkid = <ls_final>-chkid.
          gs_check_msg-status = '@0A@'.
          gs_check_msg-tabname = 'VC_TP038M'.
          gs_check_msg-client = ls_kna1-mandt.
*          concatenate ls_kna1-brsch 'Industry key not assigned' into gs_check_msg-msg_name separated by space.
          CONCATENATE ls_kna1-brsch 'Industry Not maintained in table ' 'TP038M1 in client' ls_kna1-mandt 'kindly refer note 2210486'
          INTO gs_check_msg-msg_name IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT

          APPEND  gs_check_msg TO gt_check_msg.
          <ls_final>-status = '@0A@'.
          <ls_final>-stat_chk = 'E'.

        ENDIF.


      ENDLOOP.
    ENDIF.
    REFRESH lt_kna1.
    REFRESH lt_kna1_temp.
    REFRESH lt_kna1_key.
    REFRESH lt_keys.
    FREE: lt_kna1, lt_kna1_temp, lt_kna1_key, lt_keys.
  ENDDO.

  SORT gt_check_msg BY chkid(6) status msg_name tabname client."   type mandt,
  DELETE ADJACENT DUPLICATES FROM gt_check_msg COMPARING chkid(6) status msg_name tabname client.

  IF gt_check_msg IS NOT INITIAL.
    READ TABLE gt_check_msg INTO gs_msg_check INDEX 1.
    IF sy-subrc = 0.
      APPEND gs_msg_check TO gt_msg_check.
    ENDIF.
    CLEAR gs_msg_check.
  ENDIF.



  LOOP AT gt_check_final ASSIGNING <ls_final> WHERE chkid = 'CHK_4' .
    IF <ls_final>-stat_chk <> 'E'.
      <ls_final>-status = '@08@'.
    ENDIF.

  ENDLOOP.

ENDFORM.                    "chk_op4
*&---------------------------------------------------------------------*
*& Form CHK_op5
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM chk_op5 .
  DATA : lt_lfa1 TYPE STANDARD TABLE OF lfa1.
  DATA : ls_lfa1 LIKE LINE OF lt_lfa1.
  DATA : lt_tp038m2  TYPE STANDARD TABLE OF tp038m2 .
  DATA : ls_tp038m2  LIKE LINE OF lt_tp038m2 .
  DATA : lt_t016 TYPE STANDARD TABLE OF t016.
  DATA : ls_t016 LIKE   LINE OF lt_t016.

  FIELD-SYMBOLS : <ls_final> LIKE LINE OF gt_check_final.

  DATA : lt_keys TYPE  cmds_customer_numbers_t .
  DATA : ls_key LIKE LINE OF lt_keys.
  DATA : lt_kna1_temp TYPE cmds_kna1_t.
  DATA : ls_kna1_temp LIKE LINE OF lt_kna1_temp.
  DATA : lt_kna1_key  TYPE cmds_customer_numbers_s_t.

  DATA : lt_keys_vend TYPE  vmds_lfa1_t .
  DATA : ls_key_vend LIKE LINE OF lt_keys_vend.
  DATA : lt_lfa1_temp TYPE vmds_lfa1_t.
  DATA : ls_lfa1_temp LIKE LINE OF lt_lfa1_temp.
  DATA : lt_lfa1_key  TYPE vmds_vendor_numbers_s_t.


*  select * from lfa1 into corresponding fields of table lt_lfa1.
*  sort lt_lfa1 by mandt lifnr.
*  loop at lt_lfa1 into ls_lfa1.
*    ls_key_vend-lifnr = ls_lfa1-kunnr .
*    append ls_key_vend to lt_keys_vend.
*    move-corresponding ls_lfa1 to ls_lfa1_temp.
*    append ls_lfa1 to lt_lfa1_temp.
*    clear ls_key_vend.
*    clear ls_lfa1_temp.
*    clear ls_lfa1.
*  endloop.
*
*  call method vmd_ei_api_check=>check_vend_part_of_retail_site
*    EXPORTING
*      it_keys         = lt_keys_vend
*      it_lfa1         = lt_lfa1_temp
*    IMPORTING
*      et_part_of_site = lt_lfa1_key.


*  select * from lfa1  into corresponding fields of table lt_lfa1   where  brsch is not null and brsch not in ( select brsch from tp038m2 ). "#EC CI_NOWHERE  "#EC CI_BUFFSUBQ.


  DATA : ls_lfa1_key             LIKE LINE OF lt_lfa1_key,
         s_cursor_lfa1_vend_map  TYPE cursor,
         s_cursor_lfa1_vend_map1 TYPE cursor,
         gv_lfa1_vend_mapping    TYPE c,
         gv_lfa1_vend_mapping1   TYPE c.
  DATA : p_psize_lfa1 TYPE integer VALUE '1000'.


*  loop at lt_lfa1 into ls_lfa1.
*    read table lt_lfa1_key into ls_lfa1_key with key lifnr = ls_lfa1-lifnr.
*    if sy-subrc = 0.
*      delete table lt_lfa1 from ls_lfa1.
*    endif.
*    clear ls_lfa1.
*    clear ls_lfa1_key.
*  endloop.
*
*  loop at  lt_lfa1  into ls_lfa1 where brsch is not initial  .
*
*    read table gt_check_final assigning <ls_final> with key chkid = 'CHK_5'.
*    if sy-subrc = 0.
*      gs_check_msg-chkid = <ls_final>-chkid.
*      gs_check_msg-status = '@0A@'.
*      concatenate ls_lfa1-brsch 'Industry key not assigned' into gs_check_msg-msg_name separated by space.
*      append  gs_check_msg to gt_check_msg.
*      <ls_final>-status = '@0A@'.
*      <ls_final>-stat_chk = 'E'.
*    endif.
*  endloop.

*  refresh lt_lfa1.



  TRY.
    IF s_cursor_lfa1_vend_map IS INITIAL.
      IF gs_input IS NOT INITIAL.
        OPEN CURSOR: s_cursor_lfa1_vend_map FOR
*        select * from lfa1 as a client specified up to gs_input rows where
*      brsch is not null and brsch not in ( select brsch from tp038m2 as b client specified where a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

       SELECT * FROM lfa1 AS a CLIENT SPECIFIED UP TO gs_input ROWS
          WHERE brsch IS NOT NULL AND brsch NOT IN ( SELECT brsch FROM tp038m2 AS b CLIENT SPECIFIED WHERE a~mandt = b~client AND a~brsch = b~brsch ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

      ELSE.
        OPEN CURSOR: s_cursor_lfa1_vend_map FOR
*        select * from lfa1 as a client specified  where
*        brsch is not null and brsch not in ( select brsch from tp038m2 as b client specified where a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

       SELECT * FROM lfa1 AS a CLIENT SPECIFIED
          WHERE brsch IS NOT NULL AND brsch NOT IN ( SELECT brsch FROM tp038m2 AS b CLIENT SPECIFIED WHERE a~mandt = b~client AND a~brsch = b~brsch ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

      ENDIF.
    ENDIF.
    DO.
      FETCH NEXT CURSOR s_cursor_lfa1_vend_map INTO TABLE lt_lfa1 PACKAGE SIZE p_psize_lfa1.
      IF sy-subrc NE 0 .
        CLOSE CURSOR s_cursor_lfa1_vend_map.
        gv_lfa1_vend_mapping = 'X'.
        EXIT .
      ELSE.
        SORT lt_lfa1 BY mandt lifnr .
        ls_key_vend-mandt = ls_lfa1-mandt .
        ls_key_vend-lifnr = ls_lfa1-lifnr .
        APPEND ls_key_vend TO lt_keys_vend.
        LOOP AT lt_lfa1 INTO ls_lfa1.
          READ TABLE lt_lfa1_key INTO ls_lfa1_key WITH KEY lifnr = ls_lfa1-lifnr.
          IF sy-subrc = 0.
            DELETE TABLE lt_lfa1 FROM ls_lfa1.
          ENDIF.
          CLEAR ls_lfa1.
          CLEAR ls_lfa1_key.
        ENDLOOP.

        LOOP AT  lt_lfa1  INTO ls_lfa1 WHERE brsch IS NOT INITIAL  .

          READ TABLE gt_check_final ASSIGNING <ls_final> WITH KEY chkid = 'CHK_5'.
          IF sy-subrc = 0.
            gs_check_msg-chkid = <ls_final>-chkid.
            gs_check_msg-status = '@0A@'.
            gs_check_msg-tabname = 'VC_TP038M'.
            gs_check_msg-client = ls_lfa1-mandt.
*              concatenate ls_lfa1-brsch 'Industry key not assigned' into gs_check_msg-msg_name separated by space.
            CONCATENATE ls_lfa1-brsch 'Industry not maintained in table' 'TP038M2 in client' ls_lfa1-mandt  'kindly refer note 2210486' INTO
            gs_check_msg-msg_name IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT
            APPEND  gs_check_msg TO gt_check_msg.
            <ls_final>-status = '@0A@'.
            <ls_final>-stat_chk = 'E'.
          ENDIF.

        ENDLOOP.

        LOOP AT lt_lfa1 INTO ls_lfa1.
          READ TABLE lt_lfa1_key INTO ls_lfa1_key WITH KEY lifnr = ls_lfa1-lifnr.
          IF sy-subrc = 0.
            DELETE TABLE lt_lfa1 FROM ls_lfa1.
          ENDIF.
          CLEAR ls_lfa1.
          CLEAR ls_lfa1_key.
        ENDLOOP.

      ENDIF.
      PERFORM check_vend_part_of_retail_site USING lt_keys_vend lt_lfa1_temp CHANGING lt_lfa1_key.
      REFRESH lt_lfa1.
      REFRESH lt_lfa1_key.
      REFRESH lt_lfa1_temp.
      REFRESH lt_keys_vend.
      FREE: lt_lfa1, lt_lfa1_key, lt_lfa1_temp, lt_keys_vend.
*  endif.
    ENDDO.


    IF s_cursor_lfa1_vend_map1 IS INITIAL.
      IF gs_input IS NOT INITIAL.
        OPEN CURSOR: s_cursor_lfa1_vend_map1 FOR
*        select * from lfa1 as a client specified up to gs_input rows where
*       brsch is not null and brsch not in ( select brsch from tp038m1 as b client specified where  a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

       SELECT * FROM lfa1 AS a CLIENT SPECIFIED UP TO gs_input ROWS
          WHERE brsch IS NOT NULL AND brsch NOT IN ( SELECT brsch FROM tp038m1 AS b CLIENT SPECIFIED WHERE  a~mandt = b~client AND a~brsch = b~brsch ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

      ELSE.
        OPEN CURSOR: s_cursor_lfa1_vend_map1 FOR
*        select * from lfa1 as a client specified  where
*         brsch is not null and brsch not in ( select brsch from tp038m1 as b client specified where  a~mandt = b~client ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

       SELECT * FROM lfa1 AS a CLIENT SPECIFIED
          WHERE brsch IS NOT NULL AND brsch NOT IN ( SELECT brsch FROM tp038m1 AS b CLIENT SPECIFIED WHERE  a~mandt = b~client AND a~brsch = b~brsch ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

      ENDIF.
    ENDIF.
    DO.
      FETCH NEXT CURSOR s_cursor_lfa1_vend_map1 INTO TABLE lt_lfa1 PACKAGE SIZE p_psize_lfa1.
      IF sy-subrc NE 0 .
        CLOSE CURSOR s_cursor_lfa1_vend_map1.
*          gv_lfa1_vend_mapping1 = 'X'.
        EXIT .
      ELSE.
        SORT lt_lfa1 BY mandt lifnr .
        ls_key_vend-mandt = ls_lfa1-mandt.
        ls_key_vend-lifnr = ls_lfa1-lifnr .
        APPEND ls_key_vend TO lt_keys_vend.
        LOOP AT lt_lfa1 INTO ls_lfa1.
          READ TABLE lt_lfa1_key INTO ls_lfa1_key WITH KEY lifnr = ls_lfa1-lifnr.
          IF sy-subrc = 0.
            DELETE TABLE lt_lfa1 FROM ls_lfa1.
          ENDIF.
          CLEAR ls_lfa1.
          CLEAR ls_lfa1_key.
        ENDLOOP.
        LOOP AT  lt_lfa1  INTO ls_lfa1 WHERE brsch IS NOT INITIAL  .

          READ TABLE gt_check_final ASSIGNING <ls_final> WITH KEY chkid = 'CHK_5'.
          IF sy-subrc = 0.
            gs_check_msg-chkid = <ls_final>-chkid.
            gs_check_msg-status = '@0A@'.
            gs_check_msg-tabname = 'VC_TP038M'.
            gs_check_msg-client = ls_lfa1-mandt.
*          concatenate ls_lfa1-brsch 'Industry key not assigned' into gs_check_msg-msg_name separated by space.
            CONCATENATE ls_lfa1-brsch 'Industry not maintained in table' 'TP038M1 in client'  'kindly refer note 2210486' ls_lfa1-mandt INTO
            gs_check_msg-msg_name IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT
            APPEND  gs_check_msg TO gt_check_msg.
            <ls_final>-status = '@0A@'.
            <ls_final>-stat_chk = 'E'.
          ENDIF.
        ENDLOOP.

      ENDIF.
      PERFORM check_vend_part_of_retail_site USING lt_keys_vend lt_lfa1_temp CHANGING lt_lfa1_key.
      REFRESH lt_lfa1.
      REFRESH lt_lfa1_key.
      REFRESH lt_lfa1_temp.
      REFRESH lt_keys_vend.
      FREE: lt_lfa1, lt_lfa1_key, lt_lfa1_temp, lt_keys_vend.
*  endif.
    ENDDO.
*      Incoming industry


*      LOOP AT lt_lfa1 INTO ls_lfa1.
*        READ TABLE lt_lfa1_key INTO ls_lfa1_key WITH KEY lifnr = ls_lfa1-lifnr.
*        IF sy-subrc = 0.
*          DELETE TABLE lt_lfa1 FROM ls_lfa1.
*        ENDIF.
*        CLEAR ls_lfa1.
*        CLEAR ls_lfa1_key.
*      ENDLOOP.


















*
*      select * from lfa1  into corresponding fields of table lt_lfa1  where  brsch is not null and  brsch not in ( select brsch from tp038m1 ). "#EC CI_NOWHERE  "#EC CI_BUFFSUBQ.
*
*
*      loop at lt_lfa1 into ls_lfa1.
*        read table lt_lfa1_key into ls_lfa1_key with key lifnr = ls_lfa1-lifnr.
*        if sy-subrc = 0.
*          delete table lt_lfa1 from ls_lfa1.
*        endif.
*        clear ls_lfa1.
*        clear ls_lfa1_key.
*      endloop.
*      loop at  lt_lfa1  into ls_lfa1 where brsch is not initial  .
*
*        read table gt_check_final assigning <ls_final> with key chkid = 'CHK_5'.
*        if sy-subrc = 0.
*          gs_check_msg-chkid = <ls_final>-chkid.
*          gs_check_msg-status = '@0A@'.
*          concatenate ls_lfa1-brsch 'Industry key not assigned' into gs_check_msg-msg_name separated by space.
*          append  gs_check_msg to gt_check_msg.
*          <ls_final>-status = '@0A@'.
*          <ls_final>-stat_chk = 'E'.
*        endif.
*      endloop.


    SORT gt_check_msg BY chkid(6) status msg_name tabname client."   type mandt,
    DELETE ADJACENT DUPLICATES FROM gt_check_msg COMPARING chkid(6) status msg_name tabname client.

    IF gt_check_msg IS NOT INITIAL.
      READ TABLE gt_check_msg INTO gs_msg_check INDEX 1.
      IF sy-subrc = 0.
        APPEND gs_msg_check TO gt_msg_check.
      ENDIF.
      CLEAR gs_msg_check.
    ENDIF.


    LOOP AT gt_check_final ASSIGNING <ls_final> WHERE chkid = 'CHK_5' .
      IF <ls_final>-stat_chk <> 'E'.
        <ls_final>-status = '@08@'.
      ENDIF.

    ENDLOOP.

  ENDTRY.
ENDFORM.                    "chk_op5
*&---------------------------------------------------------------------*
*&      Form  CHK_OP6
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM chk_op6.
  DATA : lt_knvk TYPE STANDARD TABLE OF knvk.
  DATA : ls_knvk LIKE LINE OF lt_knvk.
  DATA : lt_lfa1 TYPE STANDARD TABLE OF lfa1.
  DATA : ls_lfa1 LIKE LINE OF lt_lfa1.
  DATA : lt_cust_link TYPE STANDARD TABLE OF cvi_cust_link .
  DATA : ls_cust_link LIKE LINE OF lt_cust_link.
  DATA : lt_vend_link TYPE STANDARD TABLE OF cvi_vend_link .
  DATA : ls_vend_link LIKE LINE OF lt_vend_link.
  FIELD-SYMBOLS : <ls_final> LIKE LINE OF gt_check_final.
  DATA : table_name TYPE tabname.
  DATA : lv_subrc TYPE sy-subrc .
  DATA : lt_keys TYPE cmds_kna1_t. "cmds_customer_numbers_t .
  DATA : ls_key LIKE LINE OF lt_keys.
  DATA : lt_kna1_temp TYPE cmds_kna1_t.
  DATA : ls_kna1_temp LIKE LINE OF lt_kna1_temp.
  DATA : lt_kna1_key  TYPE cmds_customer_numbers_s_t.
*  DATA : lt_kna1_key  TYPE cmds_kna1_t.
*  DATA : lt_kna1_key  TYPE cmds_kna1_t.
  DATA : ls_kna1_key LIKE LINE OF lt_kna1_key.


  DATA : lt_keys_vend TYPE vmds_lfa1_t. "vmds_vendor_numbers_t .
  DATA : ls_key_vend LIKE LINE OF lt_keys_vend.
  DATA : lt_lfa1_temp TYPE vmds_lfa1_t.
  DATA : ls_lfa1_temp LIKE LINE OF lt_lfa1_temp.
  DATA : lt_lfa1_key  TYPE vmds_vendor_numbers_s_t.
  DATA : ls_lfa1_key LIKE LINE OF lt_lfa1_key.



  DATA :lt_knvk_temp TYPE cmds_knvk_t.   "cmds_customer_numbers_s_t
  DATA :ls_knvk_temp LIKE LINE OF lt_knvk_temp.
  DATA : lt_knvk_key TYPE cmds_customer_numbers_s_t.
  DATA : ls_knvk_key  LIKE LINE OF lt_knvk_key.
  DATA : lt_kna1 TYPE STANDARD TABLE OF kna1.
  DATA : ls_kna1 LIKE LINE OF lt_kna1.
  DATA : ls_kna1_consm LIKE LINE OF lt_kna1.
  table_name = 'CVI_CUST_CT_LINK' .



  TRY.

    table_name = 'CVI_CUST_CT_LINK' .

    CALL FUNCTION 'DD_EXIST_TABLE'
      EXPORTING
        tabname      = table_name
        status       = 'M'
      IMPORTING
        subrc        = lv_subrc
      EXCEPTIONS
        wrong_status = 1
        OTHERS       = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.
    IF lv_subrc = 0.

      DATA : s_cursor_knvk4 TYPE cursor.
      DATA : p_psize_knvk4 TYPE integer VALUE '1000'.
      DATA : lv_count_cust TYPE integer VALUE 1.

      IF s_cursor_knvk4 IS INITIAL.
        IF gs_input IS NOT INITIAL.
          OPEN CURSOR : s_cursor_knvk4  FOR
*          select * from knvk as a client specified  up to gs_input rows
*        where kunnr is not null and parnr not in ( select customer_cont from (table_name) as b client specified where a~mandt = b~client  ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

*         select * from knvk as a client specified  up to gs_input rows
*            where kunnr is not null and parnr not in ( select customer_cont from (table_name) as b client specified where a~mandt = b~client and a~parnr = b~customer_cont ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

          SELECT * FROM knvk AS a CLIENT SPECIFIED UP TO gs_input ROWS
            WHERE kunnr NE ''
            AND lifnr EQ '' AND
            parnr NOT IN ( SELECT customer_cont FROM (table_name) AS b CLIENT SPECIFIED WHERE a~mandt = b~client AND a~parnr = b~customer_cont ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

        ELSE.
          OPEN CURSOR : s_cursor_knvk4  FOR
*          select * from knvk as a client specified
*          where kunnr is not null and parnr not in ( select customer_cont from (table_name) as b client specified where a~mandt = b~client  ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

         SELECT * FROM knvk AS a CLIENT SPECIFIED
            WHERE kunnr NE ''
            AND lifnr EQ '' AND
            parnr NOT IN ( SELECT customer_cont FROM (table_name) AS b CLIENT SPECIFIED WHERE a~mandt = b~client AND a~parnr = b~customer_cont ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.


*         select * from knvk as a client specified
*            where kunnr is not null and parnr not in ( select customer_cont from (table_name) as b client specified where a~mandt = b~client and a~parnr = b~customer_cont ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

        ENDIF.
      ENDIF.


      DO.

        FETCH NEXT CURSOR  s_cursor_knvk4  INTO TABLE lt_knvk PACKAGE SIZE p_psize_knvk4.
        IF sy-subrc NE 0.
          CLOSE CURSOR s_cursor_knvk4.
          EXIT .
        ELSE.

          SORT lt_knvk BY mandt kunnr .

          SELECT DISTINCT * FROM kna1 CLIENT SPECIFIED INTO CORRESPONDING FIELDS OF TABLE
               lt_kna1_temp  FOR ALL ENTRIES IN lt_knvk WHERE kunnr = lt_knvk-kunnr AND mandt = lt_knvk-mandt. "AND NOT werks = space

* SORT lt_kna1_temp by mandt kunnr.

          LOOP AT lt_kna1_temp INTO ls_kna1_temp.
            MOVE-CORRESPONDING ls_kna1_temp TO ls_key.
            APPEND ls_key TO lt_keys.
          ENDLOOP.

        ENDIF.

        PERFORM check_cust_part_of_retail_site USING lt_keys lt_kna1_temp CHANGING lt_kna1_key.

        LOOP AT lt_knvk INTO ls_knvk.
          READ TABLE lt_kna1_key INTO ls_kna1_key WITH KEY kunnr = ls_knvk-kunnr." mandt = ls_knvk-mandt  .
          IF sy-subrc = 0.
            DELETE TABLE lt_knvk FROM ls_knvk.
          ENDIF.
          CLEAR ls_knvk.
          CLEAR ls_knvk_key.
        ENDLOOP.

        LOOP AT lt_knvk INTO ls_knvk WHERE kunnr <> space.

*          if lv_count_cust le 1000.
          READ TABLE gt_check_final ASSIGNING <ls_final> WITH KEY chkid = 'CHK_6'.
          IF sy-subrc = 0.
            read table lt_kna1_temp into ls_kna1_consm with key kunnr = ls_knvk-kunnr.
            if ls_kna1_consm-dear6 is initial.
            gs_check_msg-chkid = <ls_final>-chkid.
            gs_check_msg-status = '@0A@'.
            gs_check_msg-tabname = 'CVI_CUST_CT_LINK'.
            gs_check_msg-client = ls_knvk-mandt.
            CONCATENATE ls_knvk-parnr  'Contact person is not maintanined in table CVI_CUST_CT_LINK in client ' ls_knvk-mandt 'kindly refer note 2210486'
            INTO gs_check_msg-msg_name SEPARATED BY space.
            APPEND  gs_check_msg TO gt_check_msg.
            <ls_final>-status = '@0A@'.
            <ls_final>-stat_chk = 'E'.
*            endif.
*              gs_check_msg-chkid = <ls_final>-chkid.
*              gs_check_msg-status = '@0A@'.
*              gs_check_msg-tabname = 'CVI_CUST_CT_LINK'.
*              gs_check_msg-client = ls_knvk-mandt.
*              concatenate ls_knvk-parnr  'Contact person is not maintanined in table CVI_CUST_CT_LINK in client ' ls_knvk-mandt 'kindly refer note 2210486'
*              into gs_check_msg-msg_name separated by space.
*              append  gs_check_msg to gt_check_msg.
*              <ls_final>-status = '@0A@'.
*              <ls_final>-stat_chk = 'W'.
            endif.
          ENDIF.
*            lv_count_cust = lv_count_cust + 1.
*          endif.
        ENDLOOP.
*      endif.
        REFRESH lt_knvk.
        REFRESH lt_knvk_key.
        REFRESH lt_knvk_temp.
        REFRESH lt_keys.

        FREE : lt_knvk,lt_knvk_key,lt_knvk_temp,lt_keys.
        REFRESH  lt_kna1.
        REFRESH  lt_kna1_key.
        REFRESH  lt_kna1_temp.
        REFRESH lt_keys.
*          clear lv_cust_count.

        FREE: lt_kna1, lt_kna1_key, lt_kna1_temp, lt_keys.


        REFRESH lt_knvk.
        FREE lt_knvk.
        CLEAR lv_subrc .

*      clear lv_count_cust.
      ENDDO.
    ENDIF.


    CLEAR table_name.

    table_name = 'CVI_VEND_CT_LINK' .
    CALL FUNCTION 'DD_EXIST_TABLE'
      EXPORTING
        tabname      = table_name
        status       = 'M'
      IMPORTING
        subrc        = lv_subrc
      EXCEPTIONS
        wrong_status = 1
        OTHERS       = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.
    IF lv_subrc = 0.
      DATA : s_cursor_knvk5 TYPE cursor.
      DATA : p_psize_knvk5 TYPE integer VALUE '1000'.
      DATA : lv_count_vend TYPE integer VALUE 1.

      IF s_cursor_knvk5 IS INITIAL.
        IF gs_input IS NOT INITIAL.
          OPEN CURSOR : s_cursor_knvk5  FOR
*          select * from knvk as a client specified up to gs_input rows
*                                            where lifnr is not null and parnr not in ( select vendor_cont from (table_name) as b client specified where a~mandt = b~client  ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

*          select * from knvk as a client specified up to gs_input rows
*             where lifnr is not null and parnr not in ( select vendor_cont from (table_name) as b client specified where a~mandt = b~client and a~parnr = b~vendor_cont ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
               SELECT * FROM knvk AS a CLIENT SPECIFIED UP TO gs_input ROWS
            WHERE kunnr EQ ''
            AND lifnr NE '' AND
            parnr NOT IN ( SELECT vendor_cont FROM (table_name) AS b CLIENT SPECIFIED WHERE a~mandt = b~client AND a~parnr = b~vendor_cont ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.



        ELSE.
          OPEN CURSOR : s_cursor_knvk5  FOR
*           select * from knvk as a client specified
*                                              where lifnr is not null and parnr not in ( select vendor_cont from (table_name) as b client specified where a~mandt = b~client  ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

*          select * from knvk as a client specified
*             where lifnr is not null and parnr not in ( select vendor_cont from (table_name) as b client specified where a~mandt = b~client and a~parnr = b~vendor_cont ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
           SELECT * FROM knvk AS a CLIENT SPECIFIED
            WHERE kunnr EQ ''
            AND lifnr NE '' AND
            parnr NOT IN ( SELECT vendor_cont FROM (table_name) AS b CLIENT SPECIFIED WHERE a~mandt = b~client AND a~parnr = b~vendor_cont ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.


        ENDIF.

      ENDIF.


      DO.
        FETCH NEXT CURSOR  s_cursor_knvk5  INTO TABLE lt_knvk PACKAGE SIZE p_psize_knvk5.
        IF sy-subrc NE 0.
          CLOSE CURSOR s_cursor_knvk5.
          EXIT .
        ELSE.
          SORT lt_knvk BY mandt lifnr.

          SELECT DISTINCT * FROM lfa1 CLIENT SPECIFIED INTO CORRESPONDING FIELDS OF TABLE
lt_lfa1_temp  FOR ALL ENTRIES IN lt_knvk WHERE lifnr = lt_knvk-lifnr AND NOT werks = space AND mandt = lt_knvk-mandt.


          LOOP AT lt_lfa1_temp INTO ls_lfa1_temp.
            MOVE-CORRESPONDING ls_lfa1_temp TO ls_key_vend.
            APPEND ls_key_vend TO lt_keys_vend.
          ENDLOOP.
        ENDIF.

        PERFORM check_vend_part_of_retail_site USING lt_keys_vend lt_lfa1_temp CHANGING lt_lfa1_key.

        LOOP AT lt_knvk INTO ls_knvk.
          READ TABLE lt_lfa1_key INTO ls_lfa1_key WITH KEY lifnr = ls_knvk-lifnr.
          IF sy-subrc = 0.
            DELETE TABLE lt_knvk FROM ls_knvk.
          ENDIF.
          CLEAR ls_knvk.
          CLEAR ls_knvk_key.
        ENDLOOP.


        LOOP AT lt_knvk INTO ls_knvk WHERE lifnr <> space.
*          if lv_count_vend le 1000.
          READ TABLE gt_check_final ASSIGNING <ls_final> WITH KEY chkid = 'CHK_6'.
          IF sy-subrc = 0.
            gs_check_msg-chkid = <ls_final>-chkid.
            gs_check_msg-status = '@0A@'.
            gs_check_msg-tabname = 'CVI_VEND_CT_LINK'.
            gs_check_msg-client = ls_knvk-mandt.
            CONCATENATE ls_knvk-parnr 'Contact person is not maintained in table CVI_VEND_CT_LINK in client ' ls_knvk-mandt 'kindly refer note 2210486'
            INTO gs_check_msg-msg_name SEPARATED BY space.
            APPEND  gs_check_msg TO gt_check_msg.
            <ls_final>-status = '@0A@'.
            <ls_final>-stat_chk = 'E'.
*            endif.
*            lv_count_vend = lv_count_vend + 1.
          ENDIF.

        ENDLOOP.
*      endif.

        REFRESH lt_knvk.
        REFRESH lt_knvk_key.
        REFRESH lt_knvk_temp.
        REFRESH  lt_lfa1.
        REFRESH  lt_lfa1_key.
        REFRESH  lt_lfa1_temp.

        CLEAR lv_subrc.
        FREE : lt_knvk,lt_knvk_key,lt_knvk_temp,lt_keys_vend.
        FREE: lt_lfa1, lt_lfa1_key, lt_lfa1_temp.
      ENDDO.


    ENDIF.
  ENDTRY.







*    call function 'DD_EXIST_TABLE'
*      EXPORTING
*        tabname      = table_name
*        status       = 'M'
*      IMPORTING
*        subrc        = lv_subrc
*      EXCEPTIONS
*        wrong_status = 1
*        others       = 2.
*    if sy-subrc <> 0.
** Implement suitable error handling here
*    endif.
*    if lv_subrc = 0.
*
*      select * from knvk into corresponding fields of table lt_knvk where kunnr is not null and parnr not in ( select customer_cont from (table_name) ). "#EC CI_NOWHERE  "#EC CI_BUFFSUBQ.
*
*
*      loop at lt_knvk into ls_knvk where kunnr <> space.
*
*        read table gt_check_final assigning <ls_final> with key chkid = 'CHK_6'.
*        if sy-subrc = 0.
*          gs_check_msg-chkid = <ls_final>-chkid.
*          gs_check_msg-status = '@0A@'.
*          gs_check_msg-tabname = 'CVI_CUST_CT_LINK'.
*          gs_check_msg-client = ls_knvk-mandt.
*          concatenate ls_knvk-parnr  'Contact person is not maintanined in table CVI_CUST_CT_LINK in client ' ls_knvk-mandt 'kindly refer note 2210486'
*          into gs_check_msg-msg_name separated by space.
*          append  gs_check_msg to gt_check_msg.
*          <ls_final>-status = '@0A@'.
*          <ls_final>-stat_chk = 'E'.
*        endif.
*      endloop.
*    endif.
*    refresh lt_knvk.
*    clear lv_subrc .
*    clear table_name.

*
*    table_name = 'CVI_VEND_CT_LINK' .
*
*    call function 'DD_EXIST_TABLE'
*      EXPORTING
*        tabname      = table_name
*        status       = 'M'
*      IMPORTING
*        subrc        = lv_subrc
*      EXCEPTIONS
*        wrong_status = 1
*        others       = 2.
*    if sy-subrc <> 0.
** Implement suitable error handling here
*    endif.
*    if lv_subrc = 0.
*      select * from knvk into corresponding fields of table lt_knvk where lifnr is not null and parnr not in ( select vendor_cont from (table_name) ). "#EC CI_NOWHERE  "#EC CI_BUFFSUBQ.
*      loop at lt_knvk into ls_knvk where lifnr <> space.
*        read table gt_check_final assigning <ls_final> with key chkid = 'CHK_6'.
*        if sy-subrc = 0.
*          gs_check_msg-chkid = <ls_final>-chkid.
*          gs_check_msg-status = '@0A@'.
*          gs_check_msg-tabname = 'CVI_VEND_CT_LINK'.
*          gs_check_msg-client = ls_knvk-mandt.
*          concatenate ls_knvk-parnr 'Contact person is not maintained in table CVI_VEND_CT_LINK in client ' ls_knvk-mandt 'kindly refer note 2210486'
*          into gs_check_msg-msg_name separated by space.
*          append  gs_check_msg to gt_check_msg.
*          <ls_final>-status = '@0A@'.
*          <ls_final>-stat_chk = 'E'.
*        endif.
*
*      endloop.
*    endif.
*  sort gt_check_msg by msg_name client.
*  delete adjacent duplicates from gt_check_msg comparing msg_name.

  SORT gt_check_msg BY chkid(6) status msg_name tabname client."   type mandt,
  DELETE ADJACENT DUPLICATES FROM gt_check_msg COMPARING chkid(6) status msg_name tabname client.

  IF gt_check_msg IS NOT INITIAL.
    READ TABLE gt_check_msg INTO gs_msg_check INDEX 1.
    IF sy-subrc = 0.
      APPEND gs_msg_check TO gt_msg_check.
    ENDIF.
    CLEAR gs_msg_check.
  ENDIF.

  LOOP AT gt_check_final ASSIGNING <ls_final> WHERE chkid = 'CHK_6' .
    IF <ls_final>-stat_chk <> 'E'.
      <ls_final>-status = '@08@'.
    ENDIF.

  ENDLOOP.


ENDFORM.                    "chk_op6
*&---------------------------------------------------------------------*
*&      Form  CHK_OP7
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM chk_op7 .

  DATA : lt_but100 TYPE STANDARD TABLE OF but100.
  DATA : ls_but100 LIKE LINE OF  lt_but100.
  DATA : lt_cviv_cust_to_bp2 TYPE STANDARD TABLE OF cvic_cust_to_bp2.
  DATA : ls_cviv_cust LIKE LINE OF  lt_cviv_cust_to_bp2 .
  DATA : lt_cviv_vend_to_bp2 TYPE STANDARD TABLE OF cvic_vend_to_bp2.
  DATA : ls_cviv_vend_to_bp2 LIKE LINE OF lt_cviv_vend_to_bp2 .
  DATA : lt_but100_vend TYPE STANDARD TABLE OF but100.
  DATA : ls_but100_vend LIKE LINE OF lt_but100_vend .
  FIELD-SYMBOLS : <ls_final> LIKE LINE OF gt_check_final.

  SELECT DISTINCT partner rltyp FROM but100 INTO CORRESPONDING FIELDS OF TABLE lt_but100 WHERE rltyp IS NOT NULL AND rltyp NOT IN ( SELECT rltyp FROM tbd002 ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

  LOOP AT lt_but100 INTO ls_but100 WHERE rltyp IS NOT INITIAL.
    READ TABLE gt_check_final ASSIGNING <ls_final> WITH KEY chkid = 'CHK_7'.
    IF sy-subrc = 0.
      gs_check_msg-chkid = <ls_final>-chkid.
      gs_check_msg-status = '@0A@'.
      CONCATENATE ls_but100-partner 'BP roles are not assigned to account groups'
      INTO gs_check_msg-msg_name SEPARATED BY space.
      APPEND  gs_check_msg TO gt_check_msg.
      <ls_final>-status = '@0A@'.
    ENDIF.

  ENDLOOP.

  SELECT DISTINCT partner rltyp FROM but100 INTO CORRESPONDING FIELDS OF TABLE lt_but100 WHERE rltyp IS NOT NULL AND rltyp NOT IN ( SELECT rltyp FROM tbc002 ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

  LOOP AT lt_but100 INTO ls_but100 WHERE rltyp IS NOT INITIAL.
    READ TABLE gt_check_final ASSIGNING <ls_final> WITH KEY chkid = 'CHK_7'.
    IF sy-subrc = 0.
      gs_check_msg-chkid = <ls_final>-chkid.
      gs_check_msg-status = '@0A@'.
      CONCATENATE ls_but100-partner 'BP roles are not assigned to account groups' INTO gs_check_msg-msg_name SEPARATED BY space.
      APPEND  gs_check_msg TO gt_check_msg.
      <ls_final>-status = '@0A@'.
    ENDIF.

  ENDLOOP.

*  sort gt_check_msg by client msg_name.
*  delete adjacent duplicates from gt_check_msg comparing msg_name.

  SORT gt_check_msg BY chkid(6) status msg_name tabname client."   type mandt,
  DELETE ADJACENT DUPLICATES FROM gt_check_msg COMPARING chkid(6) status msg_name tabname client.

  IF gt_check_msg IS NOT INITIAL.
    READ TABLE gt_check_msg INTO gs_msg_check INDEX 1.
    IF sy-subrc = 0.
      APPEND gs_msg_check TO gt_msg_check.
    ENDIF.
    CLEAR gs_msg_check.
  ENDIF.

  LOOP AT gt_check_final ASSIGNING <ls_final> WHERE chkid = 'CHK_7' .
    IF <ls_final>-stat_chk <> 'E'.
      <ls_final>-status = '@08@'.
    ENDIF.

  ENDLOOP.
ENDFORM.                    "chk_op7
*&---------------------------------------------------------------------*
*&      Form  CHK_OP8
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM chk_op8 .


  DATA :  lt_but000 TYPE STANDARD TABLE OF but000.
  DATA : ls_but000 LIKE LINE OF lt_but000.
  DATA : lt_cviv_cust_to_bp1 TYPE STANDARD TABLE OF cvic_cust_to_bp1.
  DATA : ls_cviv_cust LIKE LINE OF  lt_cviv_cust_to_bp1 .
  DATA : lt_cviv_vend_to_bp1 TYPE STANDARD TABLE OF cvic_vend_to_bp1.
  DATA : ls_cviv_vend_to_bp1 LIKE LINE OF lt_cviv_vend_to_bp1 .
  FIELD-SYMBOLS : <ls_final> LIKE LINE OF gt_check_final.


  SELECT DISTINCT partner bu_group FROM but000 INTO CORRESPONDING FIELDS OF TABLE lt_but000 WHERE bu_group IS NOT NULL AND bu_group NOT IN ( SELECT bu_group FROM  tbd001 ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

  LOOP AT  lt_but000 INTO ls_but000 WHERE bu_group IS NOT INITIAL.
    READ TABLE gt_check_final ASSIGNING <ls_final> WITH KEY chkid = 'CHK_8'.
    IF sy-subrc = 0.
      gs_check_msg-chkid = <ls_final>-chkid.
      gs_check_msg-status = '@0A@'.
      CONCATENATE ls_but000-partner 'BP Grouping is not available for account groups' INTO gs_check_msg-msg_name SEPARATED BY space.
      APPEND  gs_check_msg TO gt_check_msg.
      <ls_final>-status = '@0A@'.
    ENDIF.
  ENDLOOP.

  REFRESH lt_but000.

  SELECT DISTINCT partner bu_group FROM but000 INTO CORRESPONDING FIELDS OF TABLE lt_but000 WHERE bu_group IS NOT NULL AND bu_group NOT IN ( SELECT bu_group FROM  tbc001 ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

  LOOP AT  lt_but000 INTO ls_but000 WHERE bu_group IS NOT INITIAL.
    READ TABLE gt_check_final ASSIGNING <ls_final> WITH KEY chkid = 'CHK_8'.
    IF sy-subrc = 0.
      gs_check_msg-chkid = <ls_final>-chkid.
      gs_check_msg-status = '@0A@'.
      CONCATENATE ls_but000-partner 'BP Grouping is not available for account groups' INTO gs_check_msg-msg_name SEPARATED BY space.
      APPEND  gs_check_msg TO gt_check_msg.
      <ls_final>-status = '@0A@'.
    ENDIF.
  ENDLOOP.
*  sort gt_check_msg by client msg_name.
*  delete adjacent duplicates from gt_check_msg comparing msg_name.

  SORT gt_check_msg BY chkid(6) status msg_name tabname client."   type mandt,
  DELETE ADJACENT DUPLICATES FROM gt_check_msg COMPARING chkid(6) status msg_name tabname client.

  IF gt_check_msg IS NOT INITIAL.
    READ TABLE gt_check_msg INTO gs_msg_check INDEX 1.
    IF sy-subrc = 0.
      APPEND gs_msg_check TO gt_msg_check.
    ENDIF.
    CLEAR gs_msg_check.
  ENDIF.
  LOOP AT gt_check_final ASSIGNING <ls_final> WHERE chkid = 'CHK_8' .
    IF <ls_final>-stat_chk <> 'E'.
      <ls_final>-status = '@08@'.
    ENDIF.

  ENDLOOP.

ENDFORM.                    "chk_op8
*&---------------------------------------------------------------------*
*&      Form  CHK_OP9
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM chk_op9 .

  DATA : lt_but000 TYPE STANDARD TABLE OF but000.
  DATA : ls_but000 LIKE LINE OF lt_but000.
  DATA : lt_but000_vend TYPE STANDARD TABLE OF but000.
  DATA : ls_but000_vend LIKE LINE OF lt_but000.
  DATA :lt_but100 TYPE STANDARD TABLE OF but100.
  DATA : ls_but100 LIKE LINE OF lt_but100.
  DATA : lt_cust_link TYPE STANDARD TABLE OF cvi_cust_link.
  DATA : ls_cust_link LIKE LINE OF lt_cust_link.
  DATA : lt_vend_link TYPE STANDARD TABLE OF cvi_vend_link.
  DATA : ls_vend_link LIKE LINE OF   lt_vend_link.
  DATA : lt_but100_vend_role TYPE STANDARD TABLE OF but000.
  DATA :lt_but000_cust TYPE STANDARD TABLE OF but000.
  DATA :ls_but000_cust LIKE LINE OF lt_but000_cust.
  FIELD-SYMBOLS : <ls_final> LIKE LINE OF gt_check_final.

  SELECT DISTINCT * FROM but100 INTO CORRESPONDING FIELDS OF TABLE lt_but100 WHERE rltyp IN ( SELECT rltyp FROM tbd002 ). "#EC CI_BUFFSUBQ.
  IF lt_but100 IS NOT INITIAL.
    SELECT * FROM but000 INTO CORRESPONDING FIELDS OF TABLE lt_but000 FOR ALL ENTRIES IN lt_but100   WHERE partner_guid NOT IN ( SELECT partner_guid FROM cvi_cust_link )
                                                                                                      AND partner = lt_but100-partner. "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.


    LOOP AT lt_but000 INTO ls_but000 WHERE partner IS NOT INITIAL.
      READ TABLE gt_check_final ASSIGNING <ls_final> WITH KEY chkid = 'CHK_9'.
      IF sy-subrc = 0.
        gs_check_msg-chkid = <ls_final>-chkid.
        gs_check_msg-status = '@0A@'.
        CONCATENATE ls_but000-partner 'BP Grouping is not available for account groups' INTO gs_check_msg-msg_name SEPARATED BY space.
        APPEND  gs_check_msg TO gt_check_msg.
        <ls_final>-status = '@0A@'.
      ENDIF.


    ENDLOOP.
  ENDIF.

  REFRESH lt_but100.
  REFRESH lt_but000.

  SELECT DISTINCT * FROM but100 INTO CORRESPONDING FIELDS OF TABLE lt_but100 WHERE rltyp IN ( SELECT rltyp FROM tbc002 ). "#EC CI_BUFFSUBQ.
  IF lt_but100 IS NOT INITIAL.
    SELECT * FROM but000 INTO CORRESPONDING FIELDS OF TABLE lt_but000 FOR ALL ENTRIES IN lt_but100   WHERE partner_guid NOT IN ( SELECT partner_guid FROM cvi_vend_link )
                                                                                                      AND partner = lt_but100-partner. "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

    LOOP AT lt_but000 INTO ls_but000 WHERE partner IS NOT INITIAL.
      READ TABLE gt_check_final ASSIGNING <ls_final> WITH KEY chkid = 'CHK_9'.
      IF sy-subrc = 0.
        gs_check_msg-chkid = <ls_final>-chkid.
        gs_check_msg-status = '@0A@'.
        CONCATENATE ls_but000-partner 'BP Grouping is not available for account groups' INTO gs_check_msg-msg_name SEPARATED BY space.
        APPEND  gs_check_msg TO gt_check_msg.
        <ls_final>-status = '@0A@'.
      ENDIF.

    ENDLOOP.
  ENDIF.

  SORT gt_check_msg BY chkid(6) status msg_name tabname client."   type mandt,
  DELETE ADJACENT DUPLICATES FROM gt_check_msg COMPARING chkid(6) status msg_name tabname client.

  IF gt_check_msg IS NOT INITIAL.
    READ TABLE gt_check_msg INTO gs_msg_check INDEX 1.
    IF sy-subrc = 0.
      APPEND gs_msg_check TO gt_msg_check.
    ENDIF.
    CLEAR gs_msg_check.
  ENDIF.
  LOOP AT gt_check_final ASSIGNING <ls_final> WHERE chkid = 'CHK_9' .
    IF <ls_final>-stat_chk <> 'E'.
      <ls_final>-status = '@08@'.
    ENDIF.

  ENDLOOP.
ENDFORM.                    "chk_op9
*&---------------------------------------------------------------------*
*&      Form  CHK_OP10
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM chk_op10 .
  DATA : lt_but051 TYPE TABLE OF but051.
  DATA : ls_but051 LIKE LINE OF lt_but051.
  DATA : lt_but000 TYPE TABLE OF but000.
  DATA : ls_but000 LIKE LINE OF lt_but000.
  DATA : lt_but0is TYPE TABLE OF but0is.
  DATA : ls_but0is LIKE LINE OF lt_but0is.
  DATA : lt_cvic_cp1_link TYPE TABLE OF cvic_cp1_link.
  DATA : ls_cviv_cp1_link LIKE LINE OF  lt_cvic_cp1_link.
  DATA : ls_map_contact TYPE cvic_map_contact.
  DATA :ls_cvic_cp1_link LIKE LINE OF lt_cvic_cp1_link.
  DATA : lt_cvic_cp2_link TYPE TABLE OF cvic_cp2_link.
  DATA : ls_cvic_cp2_link LIKE LINE OF lt_cvic_cp2_link.
  DATA : lt_cvic_cp3_link TYPE TABLE OF cvic_cp3_link.
  DATA : ls_cvic_cp3_link LIKE LINE OF lt_cvic_cp3_link.
  DATA : lt_cvic_cp4_link TYPE TABLE OF cvic_cp4_link.
  DATA : ls_cvic_cp4_link LIKE LINE OF lt_cvic_cp4_link.
  DATA: lt_cvic_marst_link  TYPE STANDARD TABLE OF cvic_marst_link .
  DATA: ls_cvic_marst_link  LIKE LINE OF lt_cvic_marst_link .
  DATA : lt_cvic_legform_lnk TYPE STANDARD TABLE OF cvic_legform_lnk.
  DATA: ls_cvic_legform_lnk LIKE LINE OF lt_cvic_legform_lnk.
  DATA : lt_payment TYPE STANDARD TABLE OF but0cc.
  DATA : ls_payment LIKE LINE OF lt_payment.
  DATA : lt_payment_master TYPE STANDARD TABLE OF pca_master.
  DATA : ls_payment_master LIKE LINE OF lt_payment_master.
  DATA: lt_cvic_ccid_link TYPE STANDARD TABLE OF cvic_ccid_link.
  DATA : ls_cvic_ccid_link LIKE LINE OF lt_cvic_ccid_link.

  DATA : lt_tp038m2  TYPE STANDARD TABLE OF tp038m2 .
  DATA : ls_tp038m2  LIKE LINE OF lt_tp038m2 .
  DATA :lt_but100_vend TYPE STANDARD TABLE OF but100.
  DATA :lt_but100  TYPE STANDARD TABLE OF but100.
  DATA : lt_but000_bp TYPE STANDARD TABLE OF but000.
  FIELD-SYMBOLS : <ls_final> LIKE LINE OF gt_check_final.

  DATA : lt_tb910 TYPE STANDARD TABLE OF tb910.
  DATA : ls_tb910 LIKE LINE OF lt_tb910.
  DATA : lt_tb912 TYPE STANDARD TABLE OF tb912.
  DATA : ls_tb912 LIKE LINE OF lt_tb912 .
  DATA : lt_tb914 TYPE STANDARD TABLE OF tb914.
  DATA : ls_tb914 LIKE LINE OF lt_tb914 .
  DATA : lt_tb916 TYPE STANDARD TABLE OF tb916 .
  DATA : ls_tb916 LIKE LINE OF lt_tb916.
  DATA : lt_tb027  TYPE STANDARD TABLE OF tb027.
  DATA : ls_tb027 LIKE LINE OF lt_tb027.
  DATA : lt_tb019 TYPE STANDARD TABLE OF tb019.
  DATA : ls_tb019 LIKE LINE OF lt_tb019.
  DATA : lt_tb038a TYPE STANDARD TABLE OF tb038a.
  DATA : ls_tb038a LIKE LINE OF lt_tb038a.
  DATA : lt_tb033 TYPE STANDARD TABLE OF tb033.
  DATA : ls_tb033 LIKE LINE OF lt_tb033.



  IF gs_input IS NOT INITIAL.
    SELECT DISTINCT * FROM tb910 AS a CLIENT SPECIFIED UP TO gs_input ROWS INTO CORRESPONDING FIELDS OF TABLE lt_tb910
      WHERE abtnr NOT IN ( SELECT abtnr FROM cvic_cp1_link  AS b CLIENT SPECIFIED  WHERE  a~client = b~client AND a~abtnr = b~abtnr ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
  ELSE.
    SELECT DISTINCT * FROM tb910 AS a CLIENT SPECIFIED   INTO CORRESPONDING FIELDS OF TABLE lt_tb910
      WHERE abtnr NOT IN ( SELECT abtnr FROM cvic_cp1_link  AS b CLIENT SPECIFIED  WHERE  a~client = b~client AND a~abtnr = b~abtnr ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
  ENDIF.
  IF sy-subrc = 0.
    LOOP AT  lt_tb910 INTO ls_tb910 WHERE abtnr IS NOT INITIAL  .
      READ TABLE gt_check_final ASSIGNING <ls_final> WITH KEY chkid = 'CHK_10'.
      IF sy-subrc = 0.
        gs_check_msg-chkid = <ls_final>-chkid.
        gs_check_msg-status = '@0A@'.
        gs_check_msg-tabname = 'CVIV_CP1_LINK'.
        gs_check_msg-client = ls_tb910-client.
        CONCATENATE ls_tb910-abtnr 'Department not maintained in table' 'CVIC_CP1_LINK in client' ls_tb910-client 'kindly refer note 2210486'
                  INTO gs_check_msg-msg_name IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT
        APPEND  gs_check_msg TO gt_check_msg.
        <ls_final>-status = '@0A@'.
        <ls_final>-stat_chk = 'E'.
      ENDIF.
      CLEAR ls_tb910.
    ENDLOOP.

  ENDIF.

* Assign for department functions
  IF gs_input IS NOT INITIAL.
    SELECT DISTINCT * FROM tb912 AS a CLIENT SPECIFIED  UP TO gs_input ROWS INTO CORRESPONDING FIELDS OF TABLE lt_tb912
      WHERE pafkt NOT IN ( SELECT gp_pafkt FROM cvic_cp2_link  AS b CLIENT SPECIFIED  WHERE  a~client = b~client AND a~pafkt = b~gp_pafkt    ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
  ELSE.
    SELECT DISTINCT * FROM tb912 AS a CLIENT SPECIFIED   INTO CORRESPONDING FIELDS OF TABLE lt_tb912
      WHERE pafkt NOT IN ( SELECT gp_pafkt FROM cvic_cp2_link  AS b CLIENT SPECIFIED   WHERE  a~client = b~client AND a~pafkt = b~gp_pafkt    ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
  ENDIF.
  IF sy-subrc = 0.
    LOOP AT  lt_tb912 INTO ls_tb912 WHERE pafkt IS NOT INITIAL  .
      READ TABLE gt_check_final ASSIGNING <ls_final> WITH KEY chkid = 'CHK_10'.
      IF sy-subrc = 0.
        gs_check_msg-chkid = <ls_final>-chkid.
        gs_check_msg-status = '@0A@'.
        gs_check_msg-tabname = 'CVIV_CP2_LINK'.
        gs_check_msg-client = ls_tb912-client.
*          concatenate ls_knvk-pafkt  'Function not assigned' into gs_check_msg-msg_name separated by space.
        CONCATENATE ls_tb912-pafkt 'Function not maintained in table' 'CVIC_CP2_LINK in client' ls_tb912-client 'kindly refer note 2210486'
        INTO gs_check_msg-msg_name IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT
        APPEND  gs_check_msg TO gt_check_msg.
        <ls_final>-status = '@0A@'.
        <ls_final>-stat_chk = 'E'.
      ENDIF.
      CLEAR ls_tb912.
    ENDLOOP.

  ENDIF.


*  Authority
  IF gs_input IS NOT INITIAL.
    SELECT DISTINCT * FROM tb914 AS a CLIENT SPECIFIED  UP TO gs_input ROWS INTO CORRESPONDING FIELDS OF TABLE lt_tb914
      WHERE paauth NOT IN ( SELECT paauth FROM cvic_cp3_link  AS b CLIENT SPECIFIED  WHERE  a~client = b~client AND a~paauth = b~paauth  ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
  ELSE.
    SELECT DISTINCT * FROM tb914 AS a CLIENT SPECIFIED  INTO CORRESPONDING FIELDS OF TABLE lt_tb914
      WHERE paauth NOT IN ( SELECT paauth FROM cvic_cp3_link  AS b CLIENT SPECIFIED  WHERE  a~client = b~client AND a~paauth = b~paauth  ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
  ENDIF.
  IF sy-subrc =  0.
    LOOP AT  lt_tb914 INTO ls_tb914 WHERE paauth IS NOT INITIAL  .
      READ TABLE gt_check_final ASSIGNING <ls_final> WITH KEY chkid = 'CHK_10'.
      IF sy-subrc = 0.
        gs_check_msg-chkid = <ls_final>-chkid.
        gs_check_msg-status = '@0A@'.
        gs_check_msg-tabname = 'CVIV_CP3_LINK'.
        gs_check_msg-client = ls_tb914-client.
*          concatenate ls_knvk-parvo 'Authority of Contact Person Not maintained' into gs_check_msg-msg_name separated by space.
        CONCATENATE ls_tb914-paauth 'Authority not mainatined in table' 'CVIC_CP3_LINK in client' ls_tb914-client  'kindly refer note 2210486'
        INTO gs_check_msg-msg_name IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT
        APPEND  gs_check_msg TO gt_check_msg.
        <ls_final>-status = '@0A@'.
        <ls_final>-stat_chk = 'E'.
      ENDIF.
    ENDLOOP.

  ENDIF.


*  VIP Indicator
  IF gs_input IS NOT INITIAL.
    SELECT DISTINCT * FROM tb916 AS a CLIENT SPECIFIED  UP TO gs_input ROWS INTO CORRESPONDING FIELDS OF TABLE lt_tb916
      WHERE pavip NOT IN ( SELECT pavip FROM cvic_cp4_link  AS b CLIENT SPECIFIED  WHERE  a~client = b~client AND a~pavip = b~pavip  ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
  ELSE.
    SELECT DISTINCT * FROM tb916 AS a CLIENT SPECIFIED  INTO CORRESPONDING FIELDS OF TABLE lt_tb916
      WHERE pavip NOT IN ( SELECT pavip FROM cvic_cp4_link  AS b CLIENT SPECIFIED  WHERE  a~client = b~client AND a~pavip = b~pavip  ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
  ENDIF.
  IF sy-subrc =  0.
    LOOP AT  lt_tb916 INTO ls_tb916 WHERE pavip IS NOT INITIAL  .

      READ TABLE gt_check_final ASSIGNING <ls_final> WITH KEY chkid = 'CHK_10'.
      IF sy-subrc = 0.
        gs_check_msg-chkid = <ls_final>-chkid.
        gs_check_msg-status = '@0A@'.
        gs_check_msg-tabname = 'CVIV_CP4_LINK'.
        gs_check_msg-client = ls_tb916-client.
*          concatenate ls_tvip-pavip  'VIP Indicator not assigned' into gs_check_msg-msg_name separated by space.
        CONCATENATE ls_tb916-pavip 'VIP Indicator not mainatined in table' 'CVIC_CP4_LINK in client' ls_tb916-client 'Kindly refer note 2210486'
        INTO gs_check_msg-msg_name IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT
        APPEND  gs_check_msg TO gt_check_msg.
        <ls_final>-status = '@0A@'.
        <ls_final>-stat_chk = 'E'.
      ENDIF.
      CLEAR ls_tb914.
    ENDLOOP.

  ENDIF.


*  Martial status
  IF gs_input IS NOT INITIAL.
    SELECT DISTINCT * FROM tb027 AS a CLIENT SPECIFIED  UP TO gs_input ROWS INTO CORRESPONDING FIELDS OF TABLE lt_tb027
      WHERE marst NOT IN ( SELECT marst FROM cvic_marst_link  AS b CLIENT SPECIFIED  WHERE  a~client = b~client AND a~marst = b~marst   ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
  ELSE.
    SELECT DISTINCT * FROM tb027 AS a CLIENT SPECIFIED  INTO CORRESPONDING FIELDS OF TABLE lt_tb027
      WHERE marst NOT IN ( SELECT marst FROM cvic_marst_link  AS b CLIENT SPECIFIED  WHERE  a~client = b~client AND a~marst = b~marst   ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
  ENDIF.
  IF sy-subrc =  0.
    LOOP AT  lt_tb027 INTO ls_tb027 WHERE marst IS NOT INITIAL  .
      READ TABLE gt_check_final ASSIGNING <ls_final> WITH KEY chkid = 'CHK_10'.
      IF sy-subrc = 0.
        gs_check_msg-chkid = <ls_final>-chkid.
        gs_check_msg-status = '@0A@'.
        gs_check_msg-tabname = 'CVIV_MARST_LINK'.
        gs_check_msg-client = ls_tb027-client.
*      concatenate ls_martial-famst 'Martial status not maintained' into gs_check_msg-msg_name separated by space.
        CONCATENATE ls_tb027-marst 'Marital Status not mainatined in table' 'CVIC_MARST_LINK in client' ls_tb027-client 'kindly refer note 2210486'
        INTO gs_check_msg-msg_name IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT
        APPEND  gs_check_msg TO gt_check_msg.
        <ls_final>-status = '@0A@'.
        <ls_final>-stat_chk = 'E'.
      ENDIF.
    ENDLOOP.
*

  ENDIF.


*  Legal form

  IF gs_input IS NOT INITIAL.
    SELECT DISTINCT * FROM tb019 AS a CLIENT SPECIFIED  UP TO gs_input ROWS INTO CORRESPONDING FIELDS OF TABLE lt_tb019
      WHERE legal_enty NOT IN ( SELECT legal_enty FROM cvic_legform_lnk  AS b CLIENT SPECIFIED  WHERE  a~client = b~client AND a~legal_enty = b~legal_enty    ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
  ELSE.
    SELECT DISTINCT * FROM tb019 AS a CLIENT SPECIFIED  INTO CORRESPONDING FIELDS OF TABLE lt_tb019
      WHERE legal_enty NOT IN ( SELECT legal_enty FROM cvic_legform_lnk  AS b CLIENT SPECIFIED  WHERE  a~client = b~client AND a~legal_enty = b~legal_enty    ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
  ENDIF.
  IF sy-subrc = 0.
    LOOP AT  lt_tb019 INTO ls_tb019 WHERE legal_enty IS NOT INITIAL  .
      READ TABLE gt_check_final ASSIGNING <ls_final> WITH KEY chkid = 'CHK_10'.
      IF sy-subrc = 0.
        gs_check_msg-chkid = <ls_final>-chkid.
        gs_check_msg-status = '@0A@'.
        gs_check_msg-tabname = 'CVIV_LEGFORM_LNK'.
        gs_check_msg-client = ls_tb019-client.
*          concatenate ls_kna1-gform  'Legal form to legal status is not assigned' into gs_check_msg-msg_name separated by space.
        CONCATENATE ls_tb019-legal_enty 'Legal form not maintained in table' 'CVIC_LEGFORM_LNK in client' ls_tb019-client 'kindly refer note 2210486'
        INTO gs_check_msg-msg_name IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT
        APPEND  gs_check_msg TO gt_check_msg.
        <ls_final>-status = '@0A@'.
        <ls_final>-stat_chk = 'E'.
      ENDIF.
    ENDLOOP.

  ENDIF.


*    Industries

*  incoming industry
  IF gs_input IS NOT INITIAL.
    SELECT DISTINCT * FROM  tb038a AS a CLIENT SPECIFIED  UP TO gs_input ROWS  INTO CORRESPONDING FIELDS OF TABLE lt_tb038a
      WHERE istype NOT IN ( SELECT istype FROM  tp038m2  AS b CLIENT SPECIFIED   WHERE  a~client = b~client AND a~istype = b~istype  )
      AND   ind_sector NOT IN ( SELECT ind_sector FROM tp038m2  AS c CLIENT SPECIFIED  WHERE  a~client = c~client AND a~ind_sector = c~ind_sector    ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
  ELSE.
    SELECT DISTINCT * FROM  tb038a AS a CLIENT SPECIFIED  INTO CORRESPONDING FIELDS OF TABLE lt_tb038a
     WHERE istype NOT IN ( SELECT istype FROM  tp038m2  AS b CLIENT SPECIFIED   WHERE  a~client = b~client AND a~istype = b~istype  )
     AND   ind_sector NOT IN ( SELECT ind_sector FROM tp038m2  AS c CLIENT SPECIFIED   WHERE  a~client = c~client AND a~ind_sector = c~ind_sector   ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
  ENDIF.

  IF sy-subrc = 0.
    LOOP AT  lt_tb038a INTO ls_tb038a WHERE istype IS NOT INITIAL AND ind_sector IS NOT INITIAL .
      READ TABLE gt_check_final ASSIGNING <ls_final> WITH KEY chkid = 'CHK_10'.
      IF sy-subrc = 0.
        gs_check_msg-chkid = <ls_final>-chkid.
        gs_check_msg-status = '@0A@'.
        gs_check_msg-tabname = 'VC_TP038M'.
        gs_check_msg-client = ls_tb038a-client.
*          concatenate ls_kna1-brsch 'Industry key not assigned' into gs_check_msg-msg_name separated by space.
        CONCATENATE ls_tb038a-istype ls_tb038a-ind_sector 'Industry Not maintained in table ' 'TP038M2 in client'  ls_tb038a-client 'kindly refer note 2210486'
        INTO gs_check_msg-msg_name IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT
        APPEND  gs_check_msg TO gt_check_msg.
        <ls_final>-status = '@0A@'.
        <ls_final>-stat_chk = 'E'.
      ENDIF.
      CLEAR ls_tb038a.
    ENDLOOP.
  ENDIF.

* outgoing industry
  IF gs_input IS NOT INITIAL.
    SELECT DISTINCT * FROM  tb038a AS a CLIENT SPECIFIED  UP TO gs_input ROWS INTO CORRESPONDING FIELDS OF TABLE lt_tb038a
      WHERE istype NOT IN ( SELECT istype FROM  tp038m1  AS b CLIENT SPECIFIED  WHERE  a~client = b~client AND a~istype = b~istype    )
      AND  ind_sector NOT IN ( SELECT ind_sector FROM tp038m1  AS c CLIENT SPECIFIED  WHERE  a~client = c~client AND a~ind_sector = c~ind_sector    ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
  ELSE.
    SELECT DISTINCT * FROM  tb038a AS a CLIENT SPECIFIED  INTO CORRESPONDING FIELDS OF TABLE lt_tb038a
      WHERE istype NOT IN ( SELECT istype FROM  tp038m1  AS b CLIENT SPECIFIED  WHERE  a~client = b~client AND a~istype = b~istype    )
      AND  ind_sector NOT IN ( SELECT ind_sector FROM tp038m1  AS c CLIENT SPECIFIED  WHERE  a~client = c~client AND a~ind_sector = c~ind_sector    ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
  ENDIF.

  IF sy-subrc = 0.
    LOOP AT  lt_tb038a INTO ls_tb038a WHERE istype IS NOT INITIAL AND ind_sector IS NOT INITIAL .
      READ TABLE gt_check_final ASSIGNING <ls_final> WITH KEY chkid = 'CHK_10'.
      IF sy-subrc = 0.
        gs_check_msg-chkid = <ls_final>-chkid.
        gs_check_msg-status = '@0A@'.
        gs_check_msg-tabname = 'VC_TP038M'.
        gs_check_msg-client = ls_tb038a-client.
*          concatenate ls_kna1-brsch 'Industry key not assigned' into gs_check_msg-msg_name separated by space.
        CONCATENATE ls_tb038a-istype ls_tb038a-ind_sector 'Industry Not maintained in table ' 'TP038M1 in client'  ls_tb038a-client 'kindly refer note 2210486'
        INTO gs_check_msg-msg_name IN CHARACTER MODE SEPARATED BY space. "#EC NOTEXT
        APPEND  gs_check_msg TO gt_check_msg.
        <ls_final>-status = '@0A@'.
        <ls_final>-stat_chk = 'E'.
      ENDIF.
      CLEAR ls_tb038a.
    ENDLOOP.
  ENDIF.

*payment card

  IF gs_input IS NOT INITIAL .
    SELECT DISTINCT * FROM  tb033 AS a CLIENT SPECIFIED  UP TO gs_input ROWS  INTO CORRESPONDING FIELDS OF TABLE lt_tb033
      WHERE ccins NOT IN ( SELECT pcid_bp FROM cvic_ccid_link   AS b CLIENT SPECIFIED  WHERE  a~mandt = b~client AND a~ccins = b~pcid_bp   ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
  ELSE.
    SELECT DISTINCT * FROM  tb033 AS a CLIENT SPECIFIED  INTO CORRESPONDING FIELDS OF TABLE lt_tb033
      WHERE ccins NOT IN ( SELECT pcid_bp FROM cvic_ccid_link   AS b CLIENT SPECIFIED  WHERE  a~mandt = b~client AND a~ccins = b~pcid_bp  ). "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
  ENDIF.
  IF sy-subrc = 0.
    LOOP AT lt_tb033 INTO ls_tb033 WHERE ccins IS NOT INITIAL .

      READ TABLE gt_check_final ASSIGNING <ls_final> WITH KEY chkid = 'CHK_10'.
      IF sy-subrc = 0.
        gs_check_msg-chkid = <ls_final>-chkid.
        gs_check_msg-status = '@0A@'.
        gs_check_msg-tabname = 'CVIC_CCID_LINK'.
        gs_check_msg-client = ls_tb033-mandt.
        CONCATENATE ls_tb033-ccins 'Payment Card not maintained in table' 'CVIC_CCID_LINK in client' ls_tb033-mandt 'kindly refer note 2210486'
        INTO gs_check_msg-msg_name SEPARATED BY space.
        APPEND  gs_check_msg TO gt_check_msg.
        <ls_final>-status = '@0A@'.
        <ls_final>-stat_chk = 'E'.
      ENDIF.
      CLEAR ls_tb033.
    ENDLOOP.
  ENDIF.












*  select distinct * from but100 into corresponding fields of table lt_but100 where  rltyp in ( select rltyp from tbd002 ). "#EC CI_BUFFSUBQ.
*  select distinct * from but100 into corresponding fields of table lt_but100_vend where  rltyp in ( select rltyp from tbc002 ). "#EC CI_BUFFSUBQ.
*  append lines of lt_but100_vend to lt_but100.
*
*  sort lt_but100 by partner rltyp.
*  delete adjacent duplicates from lt_but100 comparing partner rltyp.
*
*  if lt_but100 is not initial.
*    select * from but000 into corresponding fields of table lt_but000 for all entries in lt_but100 where  partner = lt_but100-partner. "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
*  endif.
**b.  Assign Department Numbers for Contact Person
*
*  if lt_but000 is not initial.
*    select distinct * from but051 into corresponding fields of table lt_but051 for all entries in lt_but000 where abtnr is not null and abtnr not in ( select abtnr from cvic_cp1_link )
*                                                                                                             and  partner1 = lt_but000-partner. "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
*    loop at  lt_but051 into ls_but051 where abtnr is not initial  .
*      read table gt_check_final assigning <ls_final> with key chkid = 'CHK_10'.
*      if sy-subrc = 0.
*        gs_check_msg-chkid = <ls_final>-chkid.
*        gs_check_msg-status = '@0A@'.
*        concatenate ls_but000-partner text-005 into gs_check_msg-msg_name separated by space.
*        append  gs_check_msg to gt_check_msg.
*        <ls_final>-status = '@0A@'.
*      endif.
*    endloop.
*
*
*
*    refresh lt_but051.
*
**c.  Assign Functions of Contact Person
*    select distinct * from but051 into corresponding fields of table lt_but051 for all entries in lt_but000 where  pafkt is not null and pafkt not in ( select pafkt from cvic_cp2_link )
*                                                                                                             and   partner1 = lt_but000-partner. "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
*    loop at lt_but051 into ls_but051 where pafkt is not initial.
*      read table gt_check_final assigning <ls_final> with key chkid = 'CHK_10'.
*      if sy-subrc = 0.
*        gs_check_msg-chkid = <ls_final>-chkid.
*        gs_check_msg-status = '@0A@'.
*        concatenate ls_but000-partner text-006 into gs_check_msg-msg_name separated by space.
*        append  gs_check_msg to gt_check_msg.
*        <ls_final>-status = '@0A@'.
*      endif.
*    endloop.
*
*    refresh lt_but051.
*
*
**    *b  Assign Authority of Contact Person
*    select distinct * from but051 into corresponding fields of table lt_but051 for all entries in lt_but000 where paauth is not null and paauth  not in ( select parvo from cvic_cp3_link )
*                                                                                                             and   partner1 = lt_but000-partner. "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
*    loop at lt_but051 into ls_but051 where paauth is not initial.
*      read table gt_check_final assigning <ls_final> with key chkid = 'CHK_10'.
*      if sy-subrc = 0.
*        gs_check_msg-chkid = <ls_final>-chkid.
*        gs_check_msg-status = '@0A@'.
*        concatenate ls_but000-partner text-007 into gs_check_msg-msg_name separated by space.
*        append  gs_check_msg to gt_check_msg.
*        <ls_final>-status = '@0A@'.
*      endif.
*    endloop.
*    refresh lt_but051.
**e.  Assign VIP Indicator for Contact Person
*    select distinct * from but051 into corresponding fields of table lt_but051 for all entries in lt_but000 where pavip is not null and pavip  not in ( select pavip from cvic_cp4_link )
*                                                                                                            and  partner1 = lt_but000-partner. "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
*    loop at lt_but051 into ls_but051 where pavip is not initial.
*      read table gt_check_final assigning <ls_final> with key chkid = 'CHK_10'.
*      if sy-subrc = 0.
*        gs_check_msg-chkid = <ls_final>-chkid.
*        gs_check_msg-status = '@0A@'.
*        concatenate ls_but000-partner text-008 into gs_check_msg-msg_name separated by space.
*        append  gs_check_msg to gt_check_msg.
*        <ls_final>-status = '@0A@'.
*      endif.
*    endloop.
*    refresh lt_but051.
**f.  Assign Marital Status
*
*    select distinct * from but000 into corresponding fields of table lt_but000_bp  for all entries in lt_but000  where marst is not null and marst not in ( select famst from  cvic_marst_link )
*                                                                                                                  and  partner = lt_but000-partner . "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
*    loop at lt_but000_bp into ls_but000 where marst is not initial.
*      read table gt_check_final assigning <ls_final> with key chkid = 'CHK_10'.
*      if sy-subrc = 0.
*        gs_check_msg-chkid = <ls_final>-chkid.
*        gs_check_msg-status = '@0A@'.
*        concatenate ls_but000-partner text-009 into gs_check_msg-msg_name separated by space.
*        append  gs_check_msg to gt_check_msg.
*        <ls_final>-status = '@0A@'.
*      endif.
*    endloop.
*    refresh  lt_but000_bp.
**b.  Assign Legal Form to Legal Status
*    select   distinct * from but000 into corresponding fields of table lt_but000_bp for all entries in lt_but000  where legal_enty is not null and legal_enty not in ( select gform  from  cvic_legform_lnk  )
*                                                                                                                   and  partner = lt_but000-partner . "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
*    loop at lt_but000 into ls_but000 where legal_enty is not initial.
*      read table gt_check_final assigning <ls_final> with key chkid = 'CHK_10'.
*      if sy-subrc = 0.
*        gs_check_msg-chkid = <ls_final>-chkid.
*        gs_check_msg-status = '@0A@'.
*        concatenate ls_but000-partner text-010 into gs_check_msg-msg_name separated by space.
*        append  gs_check_msg to gt_check_msg.
*        <ls_final>-status = '@0A@'.
*      endif.
*
*      clear ls_but000.
*    endloop.
*    refresh lt_but000_bp.
*
** c  Assign Industries
** Incoming industry
*    select distinct * from but0is into corresponding fields of table lt_but0is for all entries in lt_but000  where istype is not null and istype  not in ( select istype  from tp038m2 )
*                                                                                                              and  ind_sector is not null and ind_sector not in ( select ind_sector from tp038m2 )
*                                                                                                              and  partner = lt_but000-partner . "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
*    loop at lt_but0is into ls_but0is where ind_sector  is not initial .
*      read table gt_check_final assigning <ls_final> with key chkid = 'CHK_10'.
*      if sy-subrc = 0.
*        gs_check_msg-chkid = <ls_final>-chkid.
*        gs_check_msg-status = '@0A@'.
*        concatenate ls_but000-partner text-011 into gs_check_msg-msg_name separated by space.
*        append  gs_check_msg to gt_check_msg.
*        <ls_final>-status = '@0A@'.
*      endif.
*    endloop.
*
*    refresh lt_but0is.
** Outgoing Industry
*    select distinct * from but0is into corresponding fields of table lt_but0is for all entries in lt_but000 where   istype is not null and istype  not in ( select istype from tp038m1 )
*                                                                                                            and     ind_sector is not null and ind_sector not in ( select ind_sector from tp038m1 )
*                                                                                                            and     partner = lt_but000-partner . "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
*    loop at lt_but0is into ls_but0is where ind_sector  is not initial .
*      read table gt_check_final assigning <ls_final> with key chkid = 'CHK_10'.
*      if sy-subrc = 0.
*        gs_check_msg-chkid = <ls_final>-chkid.
*        gs_check_msg-status = '@0A@'.
*        concatenate ls_but0is-partner text-011 into gs_check_msg-msg_name separated by space.
*        append  gs_check_msg to gt_check_msg.
*        <ls_final>-status = '@0A@'.
*      endif.
*    endloop.
*
*    refresh lt_but0is.
**  d Assign Payment Cards
*
*    select distinct  * from but0cc into corresponding fields of table lt_payment  for all entries in lt_but000 where ccins is not null and ccins not in ( select ccins from cvic_ccid_link )
*                                                                                                                and     partner = lt_but000-partner . "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
*    if lt_payment is not initial.
*
*      loop at lt_payment into ls_payment where ccins is not initial.
*
*        read table gt_check_final assigning <ls_final> with key chkid = 'CHK_10'.
*        if sy-subrc = 0.
*          gs_check_msg-chkid = <ls_final>-chkid.
*          gs_check_msg-status = '@0A@'.
*          concatenate ls_payment_master-card_type text-012 into gs_check_msg-msg_name separated by space.
*          append  gs_check_msg to gt_check_msg.
*          <ls_final>-status = '@0A@'.
*        endif.
*
*      endloop.
*    else.
*      select distinct  * from pca_master into corresponding fields of table lt_payment_master  where card_type is not null and card_type not in ( select ccins from cvic_ccid_link ) . "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
*
*
*      loop at lt_payment_master into ls_payment_master where card_type is not initial.
*
*        read table gt_check_final assigning <ls_final> with key chkid = 'CHK_10'.
*        if sy-subrc = 0.
*          gs_check_msg-chkid = <ls_final>-chkid.
*          gs_check_msg-status = '@0A@'.
*          concatenate ls_payment_master-card_type text-012 into gs_check_msg-msg_name separated by space.
*          append  gs_check_msg to gt_check_msg.
*          <ls_final>-status = '@0A@'.
*        endif.
*
*
*        clear ls_payment.
*
*      endloop.
*    endif.
*  endif.


*  sort gt_check_msg by client msg_name.
*  delete adjacent duplicates from gt_check_msg comparing msg_name.

  SORT gt_check_msg BY chkid(6) status msg_name tabname client."   type mandt,
  DELETE ADJACENT DUPLICATES FROM gt_check_msg COMPARING chkid(6) status msg_name tabname client.

  IF gt_check_msg IS NOT INITIAL.
    READ TABLE gt_check_msg INTO gs_msg_check INDEX 1.
    IF sy-subrc = 0.
      APPEND gs_msg_check TO gt_msg_check.
    ENDIF.
    CLEAR gs_msg_check.
  ENDIF.

  LOOP AT gt_check_final ASSIGNING <ls_final> WHERE chkid = 'CHK_10' .
    IF <ls_final>-stat_chk <> 'E'.
      <ls_final>-status = '@08@'.
    ENDIF.

  ENDLOOP.
*  if gt_check_msg is not initial.
*    read table gt_check_msg into gs_msg_check index 1.
*    if sy-subrc = 0.
*      append gs_msg_check to gt_msg_check.
*    endif.
*    clear gs_msg_check.
*  endif.
*  loop at gt_check_final assigning <ls_final> where chkid = 'CHK_10' .
*    if <ls_final>-stat_chk <> 'E'.
*      <ls_final>-status = '@08@'.
*    endif.

*  endloop.
ENDFORM.                    "chk_op10
*&---------------------------------------------------------------------*
*&      Form  CHK_OP11
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM chk_op11 .

  DATA : lt_but051 TYPE STANDARD TABLE OF but051 .
  DATA : ls_but051 LIKE LINE OF lt_but051.
  DATA : lt_lfa1 TYPE STANDARD TABLE OF lfa1.
  DATA : ls_lfa1 LIKE LINE OF lt_lfa1.
  DATA : lt_cust_link TYPE STANDARD TABLE OF cvi_cust_link.
  DATA : ls_cust_link LIKE LINE OF lt_cust_link.
  DATA : lt_vend_link TYPE STANDARD TABLE OF cvi_vend_link.
  DATA : ls_vend_link LIKE LINE OF lt_vend_link.
  DATA : lt_but100 TYPE STANDARD TABLE OF but100.
  DATA : ls_but100 LIKE LINE OF lt_but100.
  DATA :lt_but000 TYPE STANDARD TABLE OF but000.
  DATA : table_name TYPE tabname.
  DATA : lv_status TYPE as4local.
  DATA : lv_subrc TYPE sy-subrc .
  FIELD-SYMBOLS : <ls_final> LIKE LINE OF gt_check_final.




  SELECT DISTINCT * FROM but100 INTO CORRESPONDING FIELDS OF TABLE lt_but100 WHERE  rltyp IN ( SELECT rltyp FROM tbd002 ). "#EC CI_BUFFSUBQ.

  IF lt_but100 IS NOT INITIAL.
    SELECT * FROM but000 INTO CORRESPONDING FIELDS OF TABLE lt_but000 FOR ALL ENTRIES IN lt_but100 WHERE  partner = lt_but100-partner. "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
  ENDIF.


  table_name = 'CVI_CUST_CT_LINK' .

  CALL FUNCTION 'DD_EXIST_TABLE'
    EXPORTING
      tabname      = table_name
      status       = lv_status
    IMPORTING
      subrc        = lv_subrc
    EXCEPTIONS
      wrong_status = 1
      OTHERS       = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
  IF lv_subrc = 0 AND lt_but000 IS NOT INITIAL.
    SELECT * FROM but051 INTO CORRESPONDING FIELDS OF TABLE lt_but051  FOR ALL ENTRIES IN lt_but000 WHERE partner1 IS NOT NULL AND partner1 NOT IN ( SELECT customer_cont FROM (table_name) )
                                                                                                 AND partner1 = lt_but000-partner. "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

    LOOP AT lt_but051 INTO ls_but051 WHERE partner1 IS NOT INITIAL .
      READ TABLE gt_check_final ASSIGNING <ls_final> WITH KEY chkid = 'CHK_11'.
      IF sy-subrc = 0.
        gs_check_msg-chkid = <ls_final>-chkid.
        gs_check_msg-status = '@0A@'.
        CONCATENATE ls_but051-partner1 'Contact Person Mapping' INTO gs_check_msg-msg_name SEPARATED BY space.
        APPEND  gs_check_msg TO gt_check_msg.
        <ls_final>-status = '@0A@'.
      ENDIF.
    ENDLOOP.
  ENDIF.
  CLEAR table_name.

  REFRESH lt_but000.
  REFRESH lt_but100.

  SELECT DISTINCT * FROM but100 INTO CORRESPONDING FIELDS OF TABLE lt_but100 WHERE  rltyp IN ( SELECT rltyp FROM tbc002 ). "#EC CI_BUFFSUBQ.

  IF lt_but100 IS NOT INITIAL.
    SELECT * FROM but000 INTO CORRESPONDING FIELDS OF TABLE lt_but000 FOR ALL ENTRIES IN lt_but100 WHERE  partner = lt_but100-partner. "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.
  ENDIF.




  table_name = 'CVI_VEND_CT_LINK' .
  CALL FUNCTION 'DD_EXIST_TABLE'
    EXPORTING
      tabname      = table_name
      status       = 'M'
    IMPORTING
      subrc        = lv_subrc
    EXCEPTIONS
      wrong_status = 1
      OTHERS       = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
  IF lv_subrc = 0 AND lt_but000 IS NOT INITIAL .
    SELECT * FROM but051 INTO CORRESPONDING FIELDS OF TABLE lt_but051 FOR ALL ENTRIES IN lt_but000 WHERE partner1 IS NOT NULL AND partner1 NOT IN ( SELECT vendor_cont   FROM (table_name) )
                                                                      AND     partner1 = lt_but000-partner. "#EC CI_NOWHERE "#EC CI_BUFFSUBQ.

    LOOP AT lt_but051 INTO ls_but051 WHERE  partner1 IS NOT INITIAL.
      READ TABLE gt_check_final ASSIGNING <ls_final> WITH KEY chkid = 'CHK_11'.
      IF sy-subrc = 0.
        gs_check_msg-chkid = <ls_final>-chkid.
        gs_check_msg-status = '@0A@'.
        CONCATENATE ls_but051-partner1 'Contact Person Mapping' INTO gs_check_msg-msg_name SEPARATED BY space.
        APPEND  gs_check_msg TO gt_check_msg.
        <ls_final>-status = '@0A@'.
      ENDIF.
    ENDLOOP.

  ENDIF.

  SORT gt_check_msg BY chkid(6) status msg_name tabname client."   type mandt,
  DELETE ADJACENT DUPLICATES FROM gt_check_msg COMPARING chkid(6) status msg_name tabname client.

  IF gt_check_msg IS NOT INITIAL.
    READ TABLE gt_check_msg INTO gs_msg_check INDEX 1.
    IF sy-subrc = 0.
      APPEND gs_msg_check TO gt_msg_check.
    ENDIF.
    CLEAR gs_msg_check.
  ENDIF.
  LOOP AT gt_check_final ASSIGNING <ls_final> WHERE chkid = 'CHK_11' .
    IF <ls_final>-stat_chk <> 'E'.
      <ls_final>-status = '@08@'.
    ENDIF.

  ENDLOOP.
ENDFORM.                    "chk_op11
*&---------------------------------------------------------------------*
*& Form CHECK_STATUS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM check_status .
  DATA : gv_kna1               TYPE c,
         gv_lfa1               TYPE c,
         gv_kna1_cvi_mapping   TYPE c,
         gv_lfa1_cvi_mapping   TYPE c,
         gv_kna1_ac_bprole     TYPE c,
         gv_lfa1_ac_bprole     TYPE c,
         gv_lfa1_vend_mapping  TYPE c,
         gv_kna1_value_mapping TYPE c,
         gv_retail             TYPE c,
         gv_retail_vend        TYPE c.

  DATA: et_check_results TYPE tt_preprocessing_check_results.
  DATA : gs_check_final   LIKE LINE OF gt_check_final.

  TYPES:
    BEGIN OF ty_sw_component,
      sw_component TYPE dlvunit,
    END   OF ty_sw_component .
  TYPES:
    tt_sw_components TYPE STANDARD TABLE OF ty_sw_component .
  DATA : it_sw_components TYPE STANDARD TABLE OF ty_sw_component.


  REFRESH: et_check_results.

  gv_kna1 = ''.
  gv_lfa1 = ''.
  gv_kna1_cvi_mapping = ''.
  gv_lfa1_cvi_mapping = ''.
  gv_kna1_ac_bprole = ''.
  gv_lfa1_ac_bprole = ''.
  gv_lfa1_vend_mapping = ''.
  gv_kna1_value_mapping = ''.
  gv_retail = ''.
  gv_retail_vend = ''.

*data: gs_check type gt_check.
*  clear gs_check.
  LOOP AT gt_check INTO gs_check.
    IF gs_check-chkid = 'CHK_1' AND gs_check-check = 'X'.
      IF gv_current_client = 'X'.
        PERFORM chk_op1_clnt.
      ELSE.
        PERFORM chk_op1.
      ENDIF.
      LOOP AT gt_msg_check INTO gs_check_msg.
        IF gs_check_msg-chkid = 'CHK_1'.
          gs_check_results-check_id = 'CHK_BP_ROLE'.
          CONCATENATE 'Some of the customer or vendor account groups are not maintained' ' kindly refer note 2210486' INTO gs_check_results-description SEPARATED BY space.
          APPEND gs_check_results TO gt_check_results.
        ENDIF.
      ENDLOOP.
      REFRESH gt_check_msg.
    ENDIF.

    IF gs_check-chkid = 'CHK_2' AND gs_check-check = 'X'.
      IF gv_current_client = 'X'.
        PERFORM chk_op2_clnt.
      ELSE.
        PERFORM chk_op2.
      ENDIF.
      LOOP AT gt_msg_check INTO gs_check_msg.
        IF gs_check_msg-chkid = 'CHK_2'.
          gs_check_results-check_id = 'CHK_BP_AC'.
          CONCATENATE 'Some of the customer or vendor account groups are not assigned to any roles' ' kindly refer note 2210486' INTO gs_check_results-description SEPARATED BY space.
          APPEND gs_check_results TO gt_check_results.
        ENDIF.
      ENDLOOP.
      REFRESH gt_check_msg.
    ENDIF.

    IF gs_check-chkid = 'CHK_3' AND gs_check-check = 'X'.
      IF gv_current_client = 'X'.
        PERFORM chk_op3_clnt.
      ELSE.
        PERFORM chk_op3.
      ENDIF.
      LOOP AT gt_msg_check INTO gs_check_msg.
        IF gs_check_msg-chkid = 'CHK_3'.
          gs_check_results-check_id = 'CVI_MAPPING'.
          CONCATENATE 'Some of the customer or vendor numbers are not mapped ' 'kindly refer note 2210486' INTO gs_check_results-description SEPARATED BY space.
          APPEND gs_check_results TO gt_check_results.
        ENDIF.
      ENDLOOP.
      REFRESH gt_check_msg.
    ENDIF.

    IF gs_check-chkid = 'CHK_4' AND gs_check-check = 'X'.
      IF gv_current_client = 'X'.
        PERFORM chk_op4_clnt.
      ELSE.
        PERFORM chk_op4.
      ENDIF.
      LOOP AT gt_msg_check INTO gs_check_msg.
        IF gs_check_msg-chkid = 'CHK_4'.
          gs_check_results-check_id = 'CHK_CON_ASSIGNMENT'.
          CONCATENATE 'Some of the customer value mapping is not maintained' 'kindly refer note 2210486' INTO gs_check_results-description SEPARATED BY space.
          APPEND gs_check_results TO gt_check_results.
        ENDIF.
      ENDLOOP.
      REFRESH gt_check_msg.
    ENDIF.

    IF gs_check-chkid = 'CHK_5' AND gs_check-check = 'X'.
      if gv_current_client = 'X'.
        PERFORM chk_op5_clnt.
        else.
      PERFORM chk_op5.
      endif.
      LOOP AT gt_msg_check INTO gs_check_msg.
        IF gs_check_msg-chkid = 'CHK_5'.
          gs_check_results-check_id = 'CHK_VEND_MAP'.
          CONCATENATE 'Some of the vendor value mapping is not maintained' 'kindly refer note 2210486' INTO gs_check_results-description SEPARATED BY space.
          APPEND gs_check_results TO gt_check_results.
        ENDIF.
      ENDLOOP.
      REFRESH gt_check_msg.
    ENDIF.

    IF gs_check-chkid = 'CHK_6' AND gs_check-check = 'X'.
      if gv_current_client = 'X'.
        PERFORM chk_op6_clnt.
        else.
      PERFORM chk_op6.
      endif.
      LOOP AT gt_msg_check INTO gs_check_msg.
        IF gs_check_msg-chkid = 'CHK_6'.
          gs_check_results-check_id = 'CHK_CONT_MAP'.
          CONCATENATE 'Some of the customers are not having contact person mapping' 'kindly refer note 2210486' INTO gs_check_results-description SEPARATED BY space.
          APPEND gs_check_results TO gt_check_results.
*    endif.
        ENDIF.
      ENDLOOP.
      REFRESH gt_check_msg.
    ENDIF.
*  refresh gt_check_final.

    IF gs_check-chkid = 'CHK_12' AND gs_check-check = 'X'.
      if gv_current_client = 'X'.
         PERFORM chk_OP12.
        else.
      PERFORM chk_op12.
      endif.
      LOOP AT gt_msg_check INTO gs_check_msg.
        IF gs_check_msg-chkid = 'CHK_12'.
          gs_check_results-check_id = 'CHK_CVI_LINK'.
          CONCATENATE 'CVI_Link ' 'not establisihed' INTO gs_check_results-description SEPARATED BY space.
          APPEND gs_check_results TO gt_check_results.
        ENDIF.
      ENDLOOP.
      REFRESH gt_check_msg.
    ENDIF.
*perform chk_op13.
*  loop at gt_msg_check into gs_check_msg.
*    if gs_check_msg-chkid = 'CHK_13'.
*      gs_check_results-check_id = 'CHK_CVI_CUST_LINK'.
*      concatenate 'CVI_CUST_LINK ' 'not establisihed' into gs_check_results-description separated by space.
*      append gs_check_results to gt_check_results.
*    endif.
*  endloop.
*  refresh gt_check_msg.
*
*  perform chk_op14.
*  loop at gt_msg_check into gs_check_msg.
*    if gs_check_msg-chkid = 'CHK_14'.
*      gs_check_results-check_id = 'CHK_CVI_VEND_LINK'.
*      concatenate 'CVI_VEND_LINK ' 'not establisihed' into gs_check_results-description separated by space.
*      append gs_check_results to gt_check_results.
*    endif.
*  endloop.
*  refresh gt_check_msg.

    IF gs_check-chkid = 'CHK_10' AND gs_check-check = 'X'.
      if gv_current_client = 'X'.
        PERFORM chk_op10_clnt.
        else.
       PERFORM chk_op10.
       endif.
      LOOP AT gt_msg_check INTO gs_check_msg.
        IF gs_check_msg-chkid = 'CHK_10'.
          gs_check_results-check_id = 'CHK_POST_CON_ASSIGNMENT'.
          CONCATENATE 'Some of the post value mapping for customer and vendor are not maintained ' 'kindly refer note 2210486' INTO gs_check_results-description SEPARATED BY space.
          APPEND gs_check_results TO gt_check_results.
        ENDIF.
      ENDLOOP.
      REFRESH gt_check_msg.
    ENDIF.

  ENDLOOP.

ENDFORM.                    "check_status
*&---------------------------------------------------------------------*
*&      Form  CHK_OP12
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM chk_op12 .

  DATA: lt_mdsc_ctrl_opt_a_cust TYPE STANDARD TABLE OF mdsc_ctrl_opt_a,
        lt_mdsc_ctrl_opt_a_vend TYPE STANDARD TABLE OF mdsc_ctrl_opt_a.
  SELECT * FROM mdsc_ctrl_opt_a INTO CORRESPONDING FIELDS OF TABLE lt_mdsc_ctrl_opt_a_cust WHERE sync_obj_source = 'CUSTOMER' AND sync_obj_target = 'BP' AND active_indicator = 'X'.
  SELECT * FROM mdsc_ctrl_opt_a INTO CORRESPONDING FIELDS OF TABLE lt_mdsc_ctrl_opt_a_vend WHERE sync_obj_source = 'VENDOR' AND sync_obj_target = 'BP' AND active_indicator = 'X'.

  IF lt_mdsc_ctrl_opt_a_cust IS INITIAL OR lt_mdsc_ctrl_opt_a_vend IS INITIAL.
    READ TABLE gt_check_final ASSIGNING <ls_final> WITH KEY chkid = 'CHK_12'.
    IF sy-subrc = 0.
      gs_check_msg-chkid = <ls_final>-chkid.
      gs_check_msg-status = '@0A@'.
      gs_check_msg-tabname = 'MDSV_CTRL_OPT_A'.
      gs_check_msg-client = sy-mandt.
      CONCATENATE  'CVI_Link' ' not established' INTO gs_check_msg-msg_name SEPARATED BY space.
      <ls_final>-status = '@0A@'.
      <ls_final>-stat_chk = 'E'.
    ENDIF.
    APPEND  gs_check_msg TO gt_check_msg.
  ELSE .
    READ TABLE gt_check_final ASSIGNING <ls_final> WITH KEY chkid = 'CHK_12'.
    IF sy-subrc = 0.
      gs_check_msg-chkid = <ls_final>-chkid.
      gs_check_msg-status = '@08@'.
      CONCATENATE  'CVI_Link' 'established' INTO gs_check_msg-msg_name SEPARATED BY space.
      <ls_final>-status = '@08@'.
    ENDIF.
    APPEND  gs_check_msg TO gt_check_msg.
  ENDIF.




  IF gt_check_msg IS NOT INITIAL.
    READ TABLE gt_check_msg INTO gs_msg_check INDEX 1.
    IF sy-subrc = 0.
      APPEND gs_msg_check TO gt_msg_check.
    ENDIF.
    CLEAR gs_msg_check.
  ENDIF.


  LOOP AT gt_check_final ASSIGNING <ls_final> WHERE chkid = 'CHK_12' .
    IF <ls_final>-stat_chk <> 'E'.
      <ls_final>-status = '@08@'.
    ENDIF.
  ENDLOOP.
ENDFORM.                    " CHK_OP12



*&---------------------------------------------------------------------*
*&      Form  check_cust_part_of_retail_site
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->IT_KEYS          text
*      -->IT_KNA1          text
*      <--ET_PART_OF_SITE  text
*----------------------------------------------------------------------*
FORM check_cust_part_of_retail_site USING
      it_keys TYPE cmds_kna1_t
      it_kna1 TYPE cmds_kna1_t
  CHANGING et_part_of_site TYPE cmds_customer_numbers_s_t.

  DATA:
    lt_werks_in         TYPE cvis_werks_t,
    lt_kna1_temp        TYPE STANDARD TABLE OF kna1,
    lt_retail_sites     TYPE cvis_werks_t,
    lt_candidates       TYPE cmds_customer_plant_t,
    lt_potential_sites  TYPE cmds_customer_plant_t,
    ls_potential_sites  TYPE cmds_customer_plant,
    ls_customer_number  TYPE cmds_customer_number.
*    lt_retail_sites     type cmds_kna1_t.
*    lt_candidates       type cmds_kna1_t,
*    lt_potential_sites  type cmds_kna1_t,
*    ls_potential_sites  type kna1,
*    ls_customer_number  type kna1.


  DATA : p_psize1 TYPE integer VALUE '1000'.  " Package size
  DATA : ls_kna1 LIKE LINE OF lt_kna1_temp.
  DATA : ls_kna1_new LIKE LINE OF lt_kna1_temp.
  DATA : ls_cust_plant TYPE cmds_customer_plant.
*  data : ls_cust_plant type kna1.
  DATA : lt_keys TYPE cmds_kna1_t.
  DATA : ls_key LIKE LINE OF lt_keys.
  DATA : lv_count TYPE i.

  FIELD-SYMBOLS:
    <ls_kna1>          TYPE kna1,
    <ls_cust_plant>    TYPE cmds_customer_plant.
*    <ls_cust_plant>    type kna1.

* first, process the table with the structure
  LOOP AT it_kna1 ASSIGNING <ls_kna1>
        WHERE NOT werks IS INITIAL.
* kna1 sentences with field werks filled are possible retail sites
    INSERT <ls_kna1>-werks INTO TABLE lt_werks_in.
    ls_potential_sites-kunnr = <ls_kna1>-kunnr.
    ls_potential_sites-werks = <ls_kna1>-werks.
*    ls_potential_sites-mandt = <ls_kna1>-mandt.
    APPEND ls_potential_sites TO lt_potential_sites.
  ENDLOOP.

* now process the keys which are passed over
  IF NOT it_keys[] IS INITIAL.
*    CALL METHOD cmd_ei_api_check=>get_customer_with_plant
*      EXPORTING
*        it_keys       = it_keys
*      IMPORTING
*        et_candidates = lt_candidates.

* SELECT kunnr werks FROM kna1 CLIENT SPECIFIED INTO CORRESPONDING FIELDS OF TABLE lt_candidates FOR ALL ENTRIES IN it_keys WHERE kunnr = it_keys-kunnr AND NOT werks = space.
*lt_keys = it_keys.

    CLEAR lv_count.
    LOOP AT it_keys INTO ls_key.
      APPEND ls_key TO lt_keys.
      DESCRIBE TABLE lt_keys LINES lv_count.
      IF lv_count  >= p_psize1.
        IF lt_keys IS NOT INITIAL.
*          SELECT kunnr werks FROM kna1 CLIENT SPECIFIED INTO CORRESPONDING FIELDS OF TABLE lt_kna1_temp  FOR ALL ENTRIES IN lt_keys WHERE kunnr = lt_keys-kunnr AND NOT werks = space.
          LOOP AT it_kna1 INTO ls_kna1_new WHERE NOT werks EQ space. "werks is not initial.
            READ TABLE lt_keys WITH KEY kunnr = ls_kna1_new-kunnr TRANSPORTING NO FIELDS  .
            IF sy-subrc = 0.
*            if ls_kna1_new-werks ne space and ls_kna1_new-kunnr is not initial.
*              ls_kna1_new-kunnr = it_kna1-kunnr.
*              ls_kna1_new-kunnr = it_kna1-kunnr.
              APPEND ls_kna1_new TO lt_kna1_temp.
              CLEAR ls_kna1_new.
*              endif.
            ENDIF.
          ENDLOOP.
        ENDIF.
        "proces your task
        LOOP AT lt_kna1_temp INTO ls_kna1 .
          ls_cust_plant-kunnr = ls_kna1-kunnr.
          ls_cust_plant-werks = ls_kna1-werks.
*          ls_cust_plant-mandt = ls_kna1-mandt.
          APPEND ls_cust_plant TO lt_candidates.
          CLEAR ls_cust_plant.
        ENDLOOP.
*        sort lt_candidates by mandt kunnr werks .

        LOOP AT lt_candidates ASSIGNING <ls_cust_plant>.
          APPEND <ls_cust_plant> TO lt_potential_sites.
          INSERT <ls_cust_plant>-werks INTO TABLE lt_werks_in.
        ENDLOOP.
        REFRESH lt_candidates.
        REFRESH lt_kna1_temp.
        REFRESH lt_keys.
        FREE : lt_candidates , lt_kna1_temp , lt_keys.
      ENDIF.

    ENDLOOP.

  ENDIF.

  IF lt_keys IS NOT INITIAL.
    SELECT mandt kunnr werks FROM kna1 AS a  CLIENT SPECIFIED INTO CORRESPONDING FIELDS OF TABLE lt_kna1_temp
      FOR ALL ENTRIES IN lt_keys WHERE kunnr = lt_keys-kunnr AND NOT werks = space  AND a~mandt = lt_keys-mandt.
    "proces your task
    LOOP AT lt_kna1_temp INTO ls_kna1 .
      ls_cust_plant-kunnr = ls_kna1-kunnr.
      ls_cust_plant-werks = ls_kna1-werks.
*      ls_cust_plant-mandt = ls_kna1-mandt.
      APPEND ls_cust_plant TO lt_candidates.
      CLEAR ls_cust_plant.
    ENDLOOP.

    SORT lt_candidates BY kunnr werks.

    LOOP AT lt_candidates ASSIGNING <ls_cust_plant>.
      APPEND <ls_cust_plant> TO lt_potential_sites.
      INSERT <ls_cust_plant>-werks INTO TABLE lt_werks_in.
    ENDLOOP.
    REFRESH lt_candidates.
    REFRESH lt_kna1_temp.
    REFRESH lt_keys.
    FREE : lt_candidates , lt_kna1_temp , lt_keys.
  ENDIF.
*commented to resolve time consuming during fetch of records.
*    IF s_cursor_retail IS INITIAL.
*      OPEN CURSOR: s_cursor_retail FOR
*      SELECT kunnr werks FROM kna1 CLIENT SPECIFIED
*      FOR ALL ENTRIES IN it_keys WHERE kunnr = it_keys-kunnr AND NOT werks = space. "#EC CI_NOWHERE "#EC CI_BUFFSUB endif. "mandt kunnr ktokd
*    ENDIF.
*    DO.
*      FETCH NEXT CURSOR s_cursor_retail INTO TABLE lt_kna1_temp PACKAGE SIZE p_psize1.
*      IF sy-subrc NE 0 .
*        CLOSE CURSOR s_cursor_retail.
*        gv_retail = 'X'.
*        EXIT .
*      ELSE.
*
*        loop at lt_kna1_temp into ls_kna1 .
*          ls_cust_plant-kunnr = ls_kna1-kunnr.
*          ls_cust_plant-werks = ls_kna1-werks.
*          append ls_cust_plant to lt_candidates.
*          clear ls_cust_plant.
*        endloop.
*        SORT lt_candidates BY kunnr werks.
*      ENDIF.
*      LOOP AT lt_candidates ASSIGNING <ls_cust_plant>.
*        APPEND <ls_cust_plant> TO lt_potential_sites.
*        INSERT <ls_cust_plant>-werks INTO TABLE lt_werks_in.
*      ENDLOOP.
*      refresh lt_candidates.
*      refresh lt_kna1_temp.
*    ENDDO.
*  ENDIF.
* end of comment


  IF NOT lt_werks_in[] IS INITIAL.
* get the retail sites
*    CALL METHOD cvi_ei_api=>filter_out_retail_plants
*      EXPORTING
*        it_werks       = lt_werks_in
*      IMPORTING
*        et_retail_part = lt_retail_sites.

*  CHECK NOT it_werks[] IS INITIAL.

    SELECT werks FROM t001w
       CLIENT SPECIFIED
       INTO TABLE lt_retail_sites
       FOR ALL ENTRIES IN lt_werks_in
       WHERE werks = lt_werks_in-table_line
                 AND NOT vlfkz = space.

  ENDIF.

* Table lt_retail_sites picks up every customer which is part of
* a retail site.
* If lt_retail_sites is empty ==> no customer is part of a retail site.
  CHECK NOT lt_retail_sites[] IS INITIAL.

  IF     NOT it_keys[] IS INITIAL
     AND NOT it_kna1[] IS INITIAL.
* if both input tables are used for determine the potential sites, it
* should be checked if there are duplicates found.
*    sort lt_potential_sites by kunnr werks.
    DELETE ADJACENT DUPLICATES FROM lt_potential_sites.
  ENDIF.

  LOOP AT lt_potential_sites ASSIGNING <ls_cust_plant>.
    READ TABLE lt_retail_sites
           WITH TABLE KEY table_line = <ls_cust_plant>-werks
           TRANSPORTING NO FIELDS.

    IF sy-subrc = 0.
* customer is part of a retail site
      ls_customer_number-kunnr = <ls_cust_plant>-kunnr.
*      ls_customer_number-mandt = <ls_cust_plant>-mandt.
      INSERT ls_customer_number INTO TABLE et_part_of_site.
    ENDIF.
  ENDLOOP.



ENDFORM.                    "CHECK_CUST_PART_OF_RETAIL_SITE




*&---------------------------------------------------------------------*
*&      Form  check_vend_part_of_retail_site
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->IT_KEYS          text
*      -->IT_LFA1          text
*      <--ET_PART_OF_SITE  text
*----------------------------------------------------------------------*
FORM check_vend_part_of_retail_site USING
      it_keys TYPE vmds_lfa1_t
      it_lfa1 TYPE vmds_lfa1_t
  CHANGING et_part_of_site TYPE vmds_vendor_numbers_s_t.




  DATA:
    lt_werks_in         TYPE cvis_werks_t,
    lt_lfa1_temp        TYPE STANDARD TABLE OF lfa1,
    lt_retail_sites     TYPE cvis_werks_t,
    lt_candidates       TYPE vmds_vendor_plant_t,
    lt_potential_sites  TYPE vmds_vendor_plant_t,
    ls_potential_sites  TYPE vmds_vendor_plant,
    ls_vendor_number    TYPE vmds_vendor_number.

  DATA : p_psize1 TYPE integer VALUE '1000'.  " Package size
  DATA : ls_lfa1 LIKE LINE OF lt_lfa1_temp.
  DATA : ls_lfa1_new LIKE LINE OF lt_lfa1_temp.

  DATA : ls_vend_plant TYPE vmds_vendor_plant.
  DATA : lv_count TYPE i.
  DATA : lt_keys TYPE  vmds_lfa1_t ."vmds_vendor_numbers_t .
  DATA : ls_key LIKE  LINE OF lt_keys.


  FIELD-SYMBOLS:
    <ls_lfa1>          TYPE lfa1,
    <ls_vend_plant>    TYPE vmds_vendor_plant.

* first, process the table with the structure
  LOOP AT it_lfa1 ASSIGNING <ls_lfa1>
        WHERE NOT werks IS INITIAL.
* lfa1 sentences with field werks filled are possible retail sites
    INSERT <ls_lfa1>-werks INTO TABLE lt_werks_in.
    ls_potential_sites-lifnr = <ls_lfa1>-lifnr.
    ls_potential_sites-werks = <ls_lfa1>-werks.
    APPEND ls_potential_sites TO lt_potential_sites.
  ENDLOOP.

* now process the keys which are passed over
  IF NOT it_keys[] IS INITIAL.
*    CALL METHOD vmd_ei_api_check=>get_vendor_with_plant
*      EXPORTING
*        it_keys       = it_keys
*      IMPORTING
*        et_candidates = lt_candidates.

*SELECT lifnr werks FROM lfa1
*     INTO CORRESPONDING FIELDS OF TABLE et_candidates
*     FOR ALL ENTRIES IN it_keys
*                     WHERE lifnr = it_keys-lifnr
*                       AND NOT werks = space.


    CLEAR lv_count.
    LOOP AT it_keys INTO ls_key.
      APPEND ls_key TO lt_keys.
      DESCRIBE TABLE lt_keys LINES lv_count.
*      if lv_count  >= p_psize1.
      IF lt_keys IS NOT INITIAL.
*          SELECT lifnr werks FROM lfa1 CLIENT SPECIFIED INTO CORRESPONDING FIELDS OF TABLE lt_lfa1_temp  FOR ALL ENTRIES IN lt_keys WHERE lifnr = lt_keys-lifnr AND NOT werks = space.

        LOOP AT it_lfa1 INTO ls_lfa1_new WHERE NOT werks EQ space.
          READ TABLE lt_keys WITH KEY lifnr = ls_lfa1_new-lifnr TRANSPORTING NO FIELDS  .
          IF sy-subrc = 0.
            APPEND ls_lfa1_new TO lt_lfa1_temp.
            CLEAR ls_lfa1_new.
          ENDIF.
        ENDLOOP.



      ENDIF.
      "proces your task
      LOOP AT lt_lfa1_temp INTO ls_lfa1 .
        ls_vend_plant-lifnr = ls_lfa1-lifnr.
        ls_vend_plant-werks = ls_lfa1-werks.
        APPEND ls_vend_plant TO lt_candidates.
        CLEAR ls_vend_plant.
      ENDLOOP.
      SORT lt_candidates BY lifnr werks.

      LOOP AT lt_candidates ASSIGNING <ls_vend_plant>.
        APPEND <ls_vend_plant> TO lt_potential_sites.
        INSERT <ls_vend_plant>-werks INTO TABLE lt_werks_in.
      ENDLOOP.
      REFRESH lt_candidates.
      REFRESH lt_lfa1_temp.
      REFRESH lt_keys.
      FREE : lt_candidates , lt_lfa1_temp , lt_keys.
*      endif.

    ENDLOOP.

  ENDIF.




  IF lt_keys IS NOT INITIAL.
    SELECT mandt lifnr werks FROM lfa1 AS a CLIENT SPECIFIED INTO CORRESPONDING FIELDS OF TABLE lt_lfa1_temp  FOR ALL ENTRIES IN lt_keys WHERE lifnr = lt_keys-lifnr AND NOT werks = space  AND a~mandt = lt_keys-mandt.
    "proces your task
    LOOP AT lt_lfa1_temp INTO ls_lfa1 .
      ls_vend_plant-lifnr = ls_lfa1-lifnr.
      ls_vend_plant-werks = ls_lfa1-werks.
      APPEND ls_vend_plant TO lt_candidates.
      CLEAR ls_vend_plant.
    ENDLOOP.
    SORT lt_candidates BY lifnr werks.

    LOOP AT lt_candidates ASSIGNING <ls_vend_plant>.
      APPEND <ls_vend_plant> TO lt_potential_sites.
      INSERT <ls_vend_plant>-werks INTO TABLE lt_werks_in.
    ENDLOOP.
    REFRESH lt_candidates.
    REFRESH lt_lfa1_temp.
    REFRESH lt_keys.
    FREE : lt_candidates , lt_lfa1_temp , lt_keys.
  ENDIF.
*commented to resolve time consuming during fetch of records.

*IF s_cursor_retail_vend IS INITIAL.
*      OPEN CURSOR: s_cursor_retail_vend FOR
*      SELECT lifnr werks FROM lfa1 CLIENT SPECIFIED
*      FOR ALL ENTRIES IN it_keys WHERE lifnr = it_keys-lifnr AND NOT werks = space. "#EC CI_NOWHERE "#EC CI_BUFFSUB endif. "mandt kunnr ktokd
*    ENDIF.
*    DO.
*      FETCH NEXT CURSOR s_cursor_retail_vend INTO TABLE lt_lfa1_temp PACKAGE SIZE p_psize1.
*      IF sy-subrc NE 0 .
*        CLOSE CURSOR s_cursor_retail_vend.
*        gv_retail_vend = 'X'.
*        EXIT .
*      ELSE.
*
*        loop at lt_lfa1_temp into ls_lfa1 .
*          ls_vend_plant-lifnr = ls_lfa1-lifnr.
*          ls_vend_plant-werks = ls_lfa1-werks.
*          append ls_vend_plant to lt_candidates.
*          clear ls_vend_plant.
*        endloop.
*        SORT lt_candidates BY lifnr werks.
*      ENDIF.
*     LOOP AT lt_candidates ASSIGNING <ls_vend_plant>.
*       APPEND <ls_vend_plant> TO lt_potential_sites.
*       INSERT <ls_vend_plant>-werks INTO TABLE lt_werks_in.
*     ENDLOOP.
*      refresh lt_candidates.
*      refresh lt_lfa1_temp.
*    ENDDO.
* ENDIF.
*   End of comment

  IF NOT lt_werks_in[] IS INITIAL.
* get the retail sites
*    CALL METHOD cvi_ei_api=>filter_out_retail_plants
*      EXPORTING
*        it_werks       = lt_werks_in
*      IMPORTING
*        et_retail_part = lt_retail_sites.

    SELECT werks FROM t001w
       CLIENT SPECIFIED
       INTO TABLE lt_retail_sites
       FOR ALL ENTRIES IN lt_werks_in
       WHERE werks = lt_werks_in-table_line
                 AND NOT vlfkz = space.

  ENDIF.

* Table lt_retail_sites picks up every vendor which is part of
* a retail site.
* If lt_retail_sites is empty ==> no vendor is part of a retail site.
  CHECK NOT lt_retail_sites[] IS INITIAL.

  IF     NOT it_keys[] IS INITIAL
     AND NOT it_lfa1[] IS INITIAL.
* if both input tables are used for determine the potential sites, it
* should be checked if there are duplicates found.
    SORT lt_potential_sites BY lifnr werks.
    DELETE ADJACENT DUPLICATES FROM lt_potential_sites.
  ENDIF.

  LOOP AT lt_potential_sites ASSIGNING <ls_vend_plant>.
    READ TABLE lt_retail_sites
           WITH TABLE KEY table_line = <ls_vend_plant>-werks
           TRANSPORTING NO FIELDS.

    IF sy-subrc = 0.
* vendor is part of a retail site
      ls_vendor_number-lifnr = <ls_vend_plant>-lifnr.
      INSERT ls_vendor_number INTO TABLE et_part_of_site.
    ENDIF.
  ENDLOOP.

ENDFORM.                    "CHECK_VEND_PART_OF_RETAIL_SITE                  " CHECK_VEND_PART_OF_RETAIL_SITE
