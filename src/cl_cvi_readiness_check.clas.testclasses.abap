
CLASS lcl_cvi_readiness_check DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
.
*?﻿<asx:abap xmlns:asx="http://www.sap.com/abapxml" version="1.0">
*?<asx:values>
*?<TESTCLASS_OPTIONS>
*?<TEST_CLASS>lcl_Cvi_Readiness_Check
*?</TEST_CLASS>
*?<TEST_MEMBER>f_Cut
*?</TEST_MEMBER>
*?<OBJECT_UNDER_TEST>CL_CVI_READINESS_CHECK
*?</OBJECT_UNDER_TEST>
*?<OBJECT_IS_LOCAL/>
*?<GENERATE_FIXTURE/>
*?<GENERATE_CLASS_FIXTURE/>
*?<GENERATE_INVOCATION/>
*?<GENERATE_ASSERT_EQUAL/>
*?</TESTCLASS_OPTIONS>
*?</asx:values>
*?</asx:abap>
  PRIVATE SECTION.
    DATA:
      f_cut TYPE REF TO cl_cvi_readiness_check.  "class under test

    METHODS: prepare_xml FOR TESTING.
    METHODS: prepare_xsl FOR TESTING.
    METHODS: process_rc_data FOR TESTING.
ENDCLASS.       "lcl_Cvi_Readiness_Check


CLASS lcl_cvi_readiness_check IMPLEMENTATION.

  METHOD prepare_xml.



  ENDMETHOD.


  METHOD prepare_xsl.



  ENDMETHOD.


  METHOD process_rc_data.
    TYPES:
      BEGIN OF ty_rc_business_check_errcount,
        totalcount  TYPE int4,  " total number of customer/vendor in system
        contactpers TYPE int4,
        unsynccount TYPE int4,  " Unconverted BP(cvi_cust_link,cvi_vend_link)
        taxcode     TYPE int4,
        email       TYPE int4,
        transzone   TYPE int4,
        postalcode  TYPE int4,
        taxjurd     TYPE int4,
        address     TYPE int4,
        bank        TYPE int4,
        industry    TYPE int4,
        numrange    TYPE int4,
        Accgroup    TYPE int4,
        unsynccontact TYPE int4, " total number of unsynchronized contact persons
        totalerrors   TYPE int4, " total number of inconsistencies in the system (in business checks)
      END OF ty_rc_business_check_errcount .
    DATA: ls_errcount_customer TYPE ty_rc_business_check_errcount,
          ls_errcount_vendor   TYPE ty_rc_business_check_errcount,
          lv_cust_count        TYPE int4,
          lv_vend_count        TYPE int4.
    CALL METHOD cl_cvi_readiness_check=>process_rc_data
      IMPORTING
        es_errcount_customer = ls_errcount_customer
        es_errcount_vendor   = ls_errcount_vendor.

    SELECT COUNT(*) FROM kna1 INTO lv_cust_count "#EC CI_NOWHERE
    .
    SELECT COUNT(*) FROM lfa1 INTO lv_vend_count "#EC CI_NOWHERE
    .

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  = lv_cust_count                             " Data object with current value
        exp                  = ls_errcount_customer-totalcount
    ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  = lv_vend_count                             " Data object with current value
        exp                  = ls_errcount_vendor-totalcount
    ).

  ENDMETHOD.

ENDCLASS.
