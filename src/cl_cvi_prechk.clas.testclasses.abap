*"* use this source file for your ABAP unit test classes

CLASS lcl_cvi_prechk DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
.
*?﻿<asx:abap xmlns:asx="http://www.sap.com/abapxml" version="1.0">
*?<asx:values>
*?<TESTCLASS_OPTIONS>
*?<TEST_CLASS>lcl_Cvi_Prechk
*?</TEST_CLASS>
*?<TEST_MEMBER>f_Cut
*?</TEST_MEMBER>
*?<OBJECT_UNDER_TEST>CL_CVI_PRECHK
*?</OBJECT_UNDER_TEST>
*?<OBJECT_IS_LOCAL/>
*?<GENERATE_FIXTURE/>
*?<GENERATE_CLASS_FIXTURE/>
*?<GENERATE_INVOCATION/>
*?<GENERATE_ASSERT_EQUAL>X
*?</GENERATE_ASSERT_EQUAL>
*?</TESTCLASS_OPTIONS>
*?</asx:values>
*?</asx:abap>
  PRIVATE SECTION.
    DATA:
      f_cut TYPE REF TO cl_cvi_prechk.  "class under test

    METHODS: process_selection_data FOR TESTING.
    METHODS: validate_selection_input FOR TESTING.
ENDCLASS.       "lcl_Cvi_Prechk


CLASS lcl_cvi_prechk IMPLEMENTATION.

  METHOD process_selection_data.



  ENDMETHOD.


  METHOD validate_selection_input.

*    CALL METHOD cl_cvi_prechk=>validate_selection_input
*      EXPORTING
*        im_gen_selection =
*        im_scenario      =
**      IMPORTING
**        ex_return        =
*        .


  ENDMETHOD.




ENDCLASS.
