FUNCTION cvi_readiness_check.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     REFERENCE(IV_DOWNLOAD) TYPE  ABAP_BOOL OPTIONAL
*"     REFERENCE(IV_PATH) TYPE  STRING OPTIONAL
*"  EXPORTING
*"     REFERENCE(EV_XML) TYPE  STRING
*"     REFERENCE(EV_XSL) TYPE  STRING
*"     REFERENCE(ET_RETURN) TYPE  BAPIRET2_T
*"  EXCEPTIONS
*"      TRANSFORMATION_ERROR
*"----------------------------------------------------------------------

  DATA: lv_xml                       TYPE string,
        lv_xsl                       TYPE string,
        ls_error_customer            TYPE cl_cvi_readiness_check=>ty_rc_business_check_errcount,
        ls_error_vendor              TYPE cl_cvi_readiness_check=>ty_rc_business_check_errcount,
        lt_customfieldcount_customer TYPE cl_cvi_readiness_check=>tt_rc_custom_fields,
        lt_customfieldcount_vender   TYPE cl_cvi_readiness_check=>tt_rc_custom_fields.
  DATA: lr_sy_conversion_codepage     TYPE REF TO cx_sy_conversion_codepage,
        lr_sy_codepage_converter_init TYPE REF TO cx_sy_codepage_converter_init,
        lr_parameter_invalid_type     TYPE REF TO cx_parameter_invalid_type,
        lr_parameter_invalid_range    TYPE REF TO cx_parameter_invalid_range,
        lr_transformation_error       TYPE REF TO cx_transformation_error,
        lr_bcs                        TYPE REF TO cx_bcs,
        lr_gui                        TYPE REF TO cl_gui_frontend_services.

  DATA: lv_flag_xml_xsl TYPE boolean,
        lv_string_size  TYPE i,
        lv_filename     TYPE string,
        lv_file_size    TYPE so_obj_len,
        lt_xml          TYPE solix_tab,
        lt_xsl          TYPE solix_tab,
        lv_info         TYPE string,
        lv_path         TYPE filename.

  DATA: ls_return LIKE LINE OF et_return .

* call readiness check
  cl_cvi_readiness_check=>process_rc_data(
    IMPORTING
      es_errcount_customer         = ls_error_customer
      es_errcount_vendor           = ls_error_vendor
      et_customfieldcount_customer = lt_customfieldcount_customer
      et_customfieldcount_vendor   = lt_customfieldcount_vender
  ).
  TRY.
      cl_cvi_readiness_check=>prepare_xml(
        EXPORTING
          is_errcount_customer         = ls_error_customer
          is_errcount_vendor           = ls_error_vendor
          it_customfieldcount_customer = lt_customfieldcount_customer
          it_customfieldcount_vendor   = lt_customfieldcount_vender
        IMPORTING
          es_xml                       = lv_xml
      ).
    CATCH cx_sy_conversion_codepage INTO lr_sy_conversion_codepage.
      lv_info = lr_sy_conversion_codepage->get_text( ).
      MESSAGE lv_info  TYPE 'I' RAISING transformation_error.
    CATCH cx_sy_codepage_converter_init INTO lr_sy_codepage_converter_init.
      lv_info = lr_sy_codepage_converter_init->get_text( ).
      MESSAGE lv_info TYPE 'I' RAISING transformation_error.
    CATCH cx_parameter_invalid_type INTO lr_parameter_invalid_type.
      lv_info = lr_parameter_invalid_type->get_text( ).
      MESSAGE lv_info TYPE 'I' RAISING transformation_error.
    CATCH cx_parameter_invalid_range INTO lr_parameter_invalid_range.
      lv_info = lr_parameter_invalid_range->get_text( ).
      MESSAGE lv_info  TYPE 'I' RAISING transformation_error.
    CATCH cx_transformation_error INTO lr_transformation_error.
      lv_info = lr_transformation_error->get_text( ).
      MESSAGE lv_info TYPE 'I' RAISING transformation_error.
  ENDTRY.

  cl_cvi_readiness_check=>prepare_xsl(
    IMPORTING
      es_xsl = lv_xsl
  ).

* fill exporting parameters
  ev_xml = lv_xml.
  ev_xsl = lv_xsl.

**********************************************************
* This is mainly used if the consumer wants to check the XML and XSL output independent of the calling program.
* This can be used to download the file to the front end application server.
* The XML and the XSL file should get stored in the same folder.
* Hence in the IV_PATH only provide the folder path with the file name and without the file type.
* Example: Assuming we provided the IV_PATH as C:\RC_XML_XSL\RC_DAT.
* After download, the below files will be created in the folder C:\RC_XML_XSL
* XML File -RC_DT20191128071915.xml and
* XSL file would be bpcc.xsl
* The XSL file provides details in a more user friendly readable format.

  IF iv_download EQ abap_true AND sy-batch = abap_false.
    CREATE OBJECT lr_gui.
    IF lr_gui IS NOT BOUND.
      RETURN.
    ENDIF.

    CONCATENATE iv_path sy-datum sy-uzeit '.XML' INTO lv_filename.

*   This is used for converting the XML data to RAW format.
    TRY .
        CALL METHOD cl_bcs_convert=>string_to_solix
          EXPORTING
            iv_string = lv_xml
          IMPORTING
            et_solix  = lt_xml
            ev_size   = lv_file_size.
      CATCH cx_bcs INTO lr_bcs.
        MESSAGE ID lr_bcs->msgid TYPE lr_bcs->msgty NUMBER lr_bcs->msgno
          WITH lr_bcs->msgv1 lr_bcs->msgv2 lr_bcs->msgv3 lr_bcs->msgv4 INTO ls_return-message.
        APPEND ls_return TO et_return.
        RETURN.
    ENDTRY.

    lv_string_size = lv_file_size.

*   Download the XML file.

    lr_gui->gui_download(
      EXPORTING
        bin_filesize              =  lv_string_size                    " File length for binary files
        filename                  = lv_filename                     " Name of file
        filetype                  = 'BIN'                " File type (ASCII, binary ...)
      CHANGING
        data_tab                  =  lt_xml                    " Transfer table
      EXCEPTIONS
        file_write_error          = 1                    " Cannot write to file
        no_batch                  = 2                    " Cannot execute front-end function in background
        gui_refuse_filetransfer   = 3                    " Incorrect Front End
        invalid_type              = 4                    " Invalid value for parameter FILETYPE
        no_authority              = 5                    " No Download Authorization
        unknown_error             = 6                    " Unknown error
        header_not_allowed        = 7                    " Invalid header
        separator_not_allowed     = 8                    " Invalid separator
        filesize_not_allowed      = 9                    " Invalid file size
        header_too_long           = 10                   " Header information currently restricted to 1023 bytes
        dp_error_create           = 11                   " Cannot create DataProvider
        dp_error_send             = 12                   " Error Sending Data with DataProvider
        dp_error_write            = 13                   " Error Writing Data with DataProvider
        unknown_dp_error          = 14                   " Error when calling data provider
        access_denied             = 15                   " Access to file denied.
        dp_out_of_memory          = 16                   " Not enough memory in data provider
        disk_full                 = 17                   " Storage medium is full.
        dp_timeout                = 18                   " Data provider timeout
        file_not_found            = 19                   " Could not find file
        dataprovider_exception    = 20                   " General Exception Error in DataProvider
        control_flush_error       = 21                   " Error in Control Framework
        not_supported_by_gui      = 22                   " GUI does not support this
        error_no_gui              = 23                   " GUI not available
        OTHERS                    = 24
    ).
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO ls_return-message.
      APPEND ls_return TO et_return.
      RETURN.
    ENDIF.

    CLEAR: lv_filename, lv_file_size, lv_string_size.

*   This is used to determine the file folder where we need to place the XSL file.

    CALL FUNCTION 'TRINT_SPLIT_FILE_AND_PATH'
      EXPORTING
        full_name = iv_path
      IMPORTING
*       STRIPPED_NAME       =
        file_path = lv_path
      EXCEPTIONS
        x_error   = 1
        OTHERS    = 2.
    IF sy-subrc ne 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
       WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO ls_return-message.
      APPEND ls_return TO et_return.
      RETURN.
    ENDIF.

*   The bpcc is the file name used in cl_cvi_readiness_check=>prepare_xml method.
*   When the user opens the XML file, the corresponding bpcc.XSL file is opened.
    CONCATENATE lv_path 'bpcc' '.XSL' INTO lv_filename.

*   Convert the XSL data into RAW format.
    TRY.
        CALL METHOD cl_bcs_convert=>string_to_solix
          EXPORTING
            iv_string = lv_xsl
          IMPORTING
            et_solix  = lt_xsl
            ev_size   = lv_file_size.
      CATCH cx_bcs INTO lr_bcs.
        MESSAGE ID lr_bcs->msgid TYPE lr_bcs->msgty NUMBER lr_bcs->msgno
          WITH lr_bcs->msgv1 lr_bcs->msgv2 lr_bcs->msgv3 lr_bcs->msgv4 INTO ls_return-message.
        APPEND ls_return TO et_return.
    ENDTRY.

    lv_string_size = lv_file_size.

*   Download the XSL file.
    lr_gui->gui_download(
       EXPORTING
         bin_filesize              =  lv_string_size                    " File length for binary files
         filename                  = lv_filename                     " Name of file
         filetype                  = 'BIN'                " File type (ASCII, binary ...)
       CHANGING
         data_tab                  =  lt_xsl                    " Transfer table
       EXCEPTIONS
         file_write_error          = 1                    " Cannot write to file
         no_batch                  = 2                    " Cannot execute front-end function in background
         gui_refuse_filetransfer   = 3                    " Incorrect Front End
         invalid_type              = 4                    " Invalid value for parameter FILETYPE
         no_authority              = 5                    " No Download Authorization
         unknown_error             = 6                    " Unknown error
         header_not_allowed        = 7                    " Invalid header
         separator_not_allowed     = 8                    " Invalid separator
         filesize_not_allowed      = 9                    " Invalid file size
         header_too_long           = 10                   " Header information currently restricted to 1023 bytes
         dp_error_create           = 11                   " Cannot create DataProvider
         dp_error_send             = 12                   " Error Sending Data with DataProvider
         dp_error_write            = 13                   " Error Writing Data with DataProvider
         unknown_dp_error          = 14                   " Error when calling data provider
         access_denied             = 15                   " Access to file denied.
         dp_out_of_memory          = 16                   " Not enough memory in data provider
         disk_full                 = 17                   " Storage medium is full.
         dp_timeout                = 18                   " Data provider timeout
         file_not_found            = 19                   " Could not find file
         dataprovider_exception    = 20                   " General Exception Error in DataProvider
         control_flush_error       = 21                   " Error in Control Framework
         not_supported_by_gui      = 22                   " GUI does not support this
         error_no_gui              = 23                   " GUI not available
         OTHERS                    = 24
     ).
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
     WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO ls_return-message.
      APPEND ls_return TO et_return.
      RETURN.
    ENDIF.

  ENDIF.

ENDFUNCTION.
