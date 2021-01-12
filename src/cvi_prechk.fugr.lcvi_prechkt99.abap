
class lcl_Cvi_Prechk definition for testing
  duration short
  risk level harmless
.
*?﻿<asx:abap xmlns:asx="http://www.sap.com/abapxml" version="1.0">
*?<asx:values>
*?<TESTCLASS_OPTIONS>
*?<TEST_CLASS>lcl_Cvi_Prechk
*?</TEST_CLASS>
*?<TEST_MEMBER>-no-
*?</TEST_MEMBER>
*?<OBJECT_UNDER_TEST/>
*?<OBJECT_IS_LOCAL/>
*?<GENERATE_FIXTURE/>
*?<GENERATE_CLASS_FIXTURE/>
*?<GENERATE_INVOCATION/>
*?<GENERATE_ASSERT_EQUAL/>
*?</TESTCLASS_OPTIONS>
*?</asx:values>
*?</asx:abap>
  private section.

    methods: cvi_Prechk_Ppf_Task for testing.
endclass.       "lcl_Cvi_Prechk


class lcl_Cvi_Prechk implementation.

  method cvi_Prechk_Ppf_Task.

*    CALL FUNCTION 'CVI_PRECHK_PPF_TASK'
*      EXPORTING
*        iv_runid               = '99999'
*        iv_objtype             = 'C'
*        ir_objid_range         =
*        ir_cvgroup_range       =
*        iv_server_group        =
*        is_scenario            =
**     IMPORTING
**       EX_RETURN              =
*              .




  endmethod.




endclass.
