*&---------------------------------------------------------------------*
*&  Include           CVI_MIGRATION_PRECHK_PPF
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  before_rfc
*&---------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
FORM before_rfc
   USING
      it_before_rfc_imp     TYPE spta_t_before_rfc_imp
   CHANGING
      cs_before_rfc_exp     TYPE spta_t_before_rfc_exp
      ct_rfcdata            TYPE spta_t_indxtab
      ct_failed_objects     TYPE spta_t_failed_objects
      ct_objects_in_process TYPE spta_t_objects_in_process
      ct_user_param .

  CALL METHOD cl_cvi_prechk=>ppf_before_call
    IMPORTING
      ex_start_rfc = cs_before_rfc_exp-start_rfc
    CHANGING
      ch_ppf_data  = ct_user_param
      ct_rfcdata   = ct_rfcdata.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  in_rfc
*&---------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
FORM in_rfc
USING
      is_in_rfc_imp  TYPE spta_t_in_rfc_imp
   CHANGING
      cs_in_rfc_exp  TYPE spta_t_in_rfc_exp
      ct_rfcdata     TYPE spta_t_indxtab.

  CALL METHOD cl_cvi_prechk=>ppf_in_call
    CHANGING
      ct_rfc_data = ct_rfcdata.



ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  after_rfc
*&---------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
*      -->IT_RFCDATA             text
*      -->IV_RFCSUBRC            text
*      -->IV_RFCMSG              text
*      -->IT_OBJECTS_IN_PROCESS  text
*      -->IS_AFTER_RFC_IMP       text
*      -->CS_AFTER_RFC_EXP       text
*----------------------------------------------------------------------*
FORM after_rfc
  USING
      it_rfcdata            TYPE spta_t_indxtab
      iv_rfcsubrc           TYPE sy-subrc
      iv_rfcmsg             TYPE spta_t_rfcmsg
      it_objects_in_process TYPE spta_t_objects_in_process
      is_after_rfc_imp      TYPE spta_t_after_rfc_imp
   CHANGING
      cs_after_rfc_exp      TYPE spta_t_after_rfc_exp
      ct_user_param.

  CALL METHOD cl_cvi_prechk=>ppf_after_call
    EXPORTING
      it_rfc_data = it_rfcdata.

ENDFORM.
