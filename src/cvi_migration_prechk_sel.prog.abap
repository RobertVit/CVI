*&---------------------------------------------------------------------*
*&  Include           CVI_MIGRATION_PRECHK_SEL
*&---------------------------------------------------------------------*
*& General Selection screen for Customer
SELECTION-SCREEN BEGIN OF SCREEN 1002 AS SUBSCREEN .
SELECT-OPTIONS   s_cust FOR   gs_so_dummy-kunnr.
SELECT-OPTIONS   s_cac_gp FOR gs_so_dummy-ktokd.
SELECTION-SCREEN END OF SCREEN 1002.

*&---------------------------------------------------------------------*
*& General Selection screen for Vendor
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF SCREEN 1003 AS SUBSCREEN .
SELECT-OPTIONS   s_vend FOR gs_so_dummy-lifnr.
SELECT-OPTIONS   s_vac_gp FOR gs_so_dummy-ktokk.
SELECTION-SCREEN END OF SCREEN 1003.

*&---------------------------------------------------------------------*
* Run History section for Created on range
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF SCREEN 1004 AS SUBSCREEN .
SELECT-OPTIONS   s_run_on FOR gs_so_dummy-run_on NO-EXTENSION.
SELECTION-SCREEN END OF SCREEN 1004.
