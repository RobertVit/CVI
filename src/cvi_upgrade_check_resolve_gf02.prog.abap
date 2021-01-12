*----------------------------------------------------------------------*
***INCLUDE CVI_UPGRADE_CHECK_RESOLVE_GF02 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_BPS_WITH_UNSUP_ROLES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_BPS_WITH_UNSUP_ROLES .

data:   cl_chk           type ref to cl_s4_checks_bp_enh,
        lt_check_results type table of ty_preprocessing_check_result,
        ls_check_results like line of lt_check_results.

* create object cl_chk.

 CALL METHOD CL_S4_CHECKS_BP_ENH=>GET_BPS_WITH_UNSUPP_ROLES
   IMPORTING
     ET_PARTNERS      = gt_partners.




ENDFORM.                    " GET_BPS_WITH_UNSUP_ROLES
