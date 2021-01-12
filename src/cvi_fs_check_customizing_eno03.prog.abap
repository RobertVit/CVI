*----------------------------------------------------------------------*
***INCLUDE CVI_FS_CHECK_CUSTOMIZING_ENO03.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module PBO_0900_VENDOR OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
module pbo_0900_vendor output.
* SET PF-STATUS 'xxxxxxxx'.
* SET TITLEBAR 'xxx'.

  perform set_status_vendor_0900.
*  perform select_transaction_0900.

endmodule.                    "pbo_0900_vendor OUTPUT
*&---------------------------------------------------------------------*
*& Form SET_STATUS_VENDOR_0900
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form set_status_vendor_0900 .
*  set pf-status 'CVI_FS_C_C_NEXT'.
*  set titlebar 'CVI_FS_C_C_VENDOR'.
  set pf-status 'CVI_MAPPING'.
endform.                    "set_status_vendor_0900
*&---------------------------------------------------------------------*
*& Form SELECT_TRANSACTION_0900
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form select_transaction_0900 .
* CALL FUNCTION 'ABAP4_CALL_TRANSACTION'
*          EXPORTING
*            TCODE                         = 'MDS_LOAD_COCKPIT'
**           SKIP_SCREEN                   = ' '
**           MODE_VAL                      = 'A'
**           UPDATE_VAL                    = 'A'
**         IMPORTING
**           SUBRC                         =
**         TABLES
**           USING_TAB                     =
**           SPAGPA_TAB                    =
**           MESS_TAB                      =
**         EXCEPTIONS
**           CALL_TRANSACTION_DENIED       = 1
**           TCODE_INVALID                 = 2
**           OTHERS                        = 3
*                  .
*        IF SY-SUBRC <> 0.
** Implement suitable error handling here
*        ENDIF.
endform.                    "select_transaction_0900
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_VENDOR_0900  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module user_command_vendor_0900 input.
case ok_code.
    when gc_back.
      set screen 100. "start screen
    when gc_next.
      set screen 600. "vendor check screen
    when gc_exit.
      leave program.
       when gc_home.
      set screen 100.
    when 'EXEC'.

********************************************* Move unsynchronized customers and vendors to an excel file ********************************************

      DATA: begin of header occurs 0,
              colname(30) type c,
            end of header.

      header-colname = 'Field Name'.
      append header.
      clear header.
      header-colname = 'Incl/Excl'.
      append header.
      clear header.
      header-colname = 'Option'.
      append header.
      clear header.
      header-colname = 'Lower limit'.
      append header.
      clear header.
      header-colname = 'Upper limit'.
      append header.
      clear header.

      TYPES: begin of excel_type,
              fldname(5) type c,
              incl_excl(1) type c,
              option(2) type c,
              lower(10) type c,
              upper(10) type c,
             end of excel_type.

      DATA: lt_cust type table of excel_type ,
            lt_vend type table of excel_type,
            lt_cust_cont type table of excel_type,
            lt_vend_cont type table of excel_type.

      DATA: ls_cust_ex like line of lt_cust,
            ls_vend_ex like line of lt_vend,
            ls_cust_cont_ex like line of lt_cust_cont,
            ls_vend_cont_ex like line of lt_vend_cont.

      DATA: ls_cust like line of gt_cust,
            ls_vend like line of gt_vend,
            ls_cust_cont like line of gt_cust_cont,
            ls_vend_cont like line of gt_vend_cont.

* Excel file for customers
      loop at gt_cust into ls_cust.
        ls_cust_ex-fldname = 'KUNNR'.
        ls_cust_ex-incl_excl = 'I'.
        ls_cust_ex-option = 'EQ'.
        ls_cust_ex-lower = ls_cust-kunnr.
        append ls_cust_ex to lt_cust.
        clear ls_cust_ex.
        clear ls_cust.
      endloop.

      CALL FUNCTION 'GUI_DOWNLOAD'
        EXPORTING
          FILENAME   = 'C:\temp\CVI\unsync_customers.xls'
          FILETYPE   = 'DBF'
        TABLES
          DATA_TAB   = lt_cust
          FIELDNAMES = header.

* Excel file for suppliers
      loop at gt_vend into ls_vend.
        ls_vend_ex-fldname = 'LIFNR'.
        ls_vend_ex-incl_excl = 'I'.
        ls_vend_ex-option = 'EQ'.
        ls_vend_ex-lower = ls_vend-lifnr.
        append ls_vend_ex to lt_vend.
        clear ls_vend_ex.
        clear ls_vend.
      endloop.

      CALL FUNCTION 'GUI_DOWNLOAD'
        EXPORTING
          FILENAME   = 'C:\temp\CVI\unsync_suppliers.xls'
          FILETYPE   = 'DBF'
        TABLES
          DATA_TAB   = lt_vend
          FIELDNAMES = header.

* Excel file for customer contacts
      loop at gt_cust_cont into ls_cust_cont.
        ls_cust_cont_ex-fldname = 'KUNNR'.
        ls_cust_cont_ex-incl_excl = 'I'.
        ls_cust_cont_ex-option = 'EQ'.
        ls_cust_cont_ex-lower = ls_cust_cont-kunnr.
        append ls_cust_cont_ex to lt_cust_cont.
        clear ls_cust_cont_ex.
        clear ls_cust_cont.
      endloop.

**      sort lt_cust_cont by lower.
**      delete ADJACENT DUPLICATES FROM lt_cust_cont.

      CALL FUNCTION 'GUI_DOWNLOAD'
        EXPORTING
          FILENAME   = 'C:\temp\CVI\unsync_customer_contacts.xls'
          FILETYPE   = 'DBF'
        TABLES
          DATA_TAB   = lt_cust_cont
          FIELDNAMES = header.

* Excel file for supplier contacts
      loop at gt_vend_cont into ls_vend_cont.
        ls_vend_cont_ex-fldname = 'LIFNR'.
        ls_vend_cont_ex-incl_excl = 'I'.
        ls_vend_cont_ex-option = 'EQ'.
        ls_vend_cont_ex-lower = ls_vend_cont-lifnr.
        append ls_vend_cont_ex to lt_vend_cont.
        clear ls_vend_cont_ex.
        clear ls_vend_cont.
      endloop.

      CALL FUNCTION 'GUI_DOWNLOAD'
        EXPORTING
          FILENAME   = 'C:\temp\CVI\unsync_supplier_contacts.xls'
          FILETYPE   = 'DBF'
        TABLES
          DATA_TAB   = lt_vend_cont
          FIELDNAMES = header.

* Message to display folder location
if sy-subrc EQ 0.
  MESSAGE 'Unsynchronized Customer/Supplier data downloaded to C:\temp\CVI. Synchronize by uploading the files.' type 'S'.
endif.



* changes for consumer - start

*CALL FUNCTION 'CVI_SET_MIGRATION_CHECK'
*  EXPORTING
*    lv_migration_check       = 'X'
*          .

* changes for consumer - end
*****************************************************************************************************************************************************

* Call MDS_LOAD_COCKPIT
      CALL FUNCTION 'ABAP4_CALL_TRANSACTION'
        EXPORTING
          tcode                         = 'MDS_LOAD_COCKPIT'
*         SKIP_SCREEN                   = ' '
*         MODE_VAL                      = 'A'
*         UPDATE_VAL                    = 'A'
*       IMPORTING
*         SUBRC                         =
*       TABLES
*         USING_TAB                     =
*         SPAGPA_TAB                    =
*         MESS_TAB                      =
*       EXCEPTIONS
*         CALL_TRANSACTION_DENIED       = 1
*         TCODE_INVALID                 = 2
*         OTHERS                        = 3
                .
      IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.



  endcase.
endmodule.                    "user_command_vendor_0900 INPUT
