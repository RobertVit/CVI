FUNCTION CVI_GET_VENDOR_MAP_BE.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(VENDOR_RANGE) TYPE  CVI_VEND_LINK-VENDOR
*"  EXPORTING
*"     REFERENCE(LT_PARTNER_GUID) TYPE  BUT000-PARTNER_GUID
*"----------------------------------------------------------------------

  SELECT SINGLE A~PARTNER_GUID INTO LT_PARTNER_GUID
         FROM  BUT000 AS A INNER JOIN CVI_VEND_LINK AS C
         ON    C~PARTNER_GUID = A~PARTNER_GUID
         WHERE C~VENDOR = VENDOR_RANGE.


ENDFUNCTION.
