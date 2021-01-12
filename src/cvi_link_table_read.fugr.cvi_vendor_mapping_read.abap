FUNCTION CVI_VENDOR_MAPPING_READ.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     REFERENCE(IV_CURRENT_TIME) TYPE  TIMESTAMP OPTIONAL
*"     REFERENCE(IV_PROCESS_MODE) OPTIONAL
*"  CHANGING
*"     REFERENCE(IT_PARTNER_GUID) TYPE  ANY TABLE OPTIONAL
*"     REFERENCE(IT_VENDOR_NO) TYPE  ANY TABLE OPTIONAL
*"     REFERENCE(ET_VENDORMAP) TYPE  ANY TABLE OPTIONAL
*"----------------------------------------------------------------------

CONSTANTS: IC_ROLE_VENDOR    TYPE BU_RLTYP VALUE 'BBP000',
             IC_ROLE_INV_PARTY TYPE BU_RLTYP VALUE 'BBP006'.
  TYPES: BEGIN OF lty_partner_guid,
              sign   TYPE bapisign,
              option TYPE bapioption,
              low    TYPE bu_partner_guid,
              high   TYPE bu_partner_guid,
         END OF lty_partner_guid,
         BEGIN OF lty_vendor_no,
            sign   TYPE bapisign,
            option TYPE bapioption,
            low    TYPE lifnr,
            high   TYPE lifnr,
         END OF lty_vendor_no,
         begin of lty_maptab,
            partner_guid TYPE bu_partner_guid,
            vendor_no    TYPE lifnr,
         end of lty_maptab.
  DATA:  lr_partner_guid TYPE STANDARD TABLE OF lty_partner_guid,
         lr_vendor_no TYPE STANDARD TABLE OF lty_vendor_no,
         lt_cvi_vend_link type table of cvi_vend_link,
         ls_maptab type lty_maptab,
         lt_maptab type table of lty_maptab.
  Field-symbols:  <LFS_CVI_VEND_LINK> type cvi_vend_link.
  lr_partner_guid[] = it_partner_guid[].
  lr_vendor_no[]    = it_vendor_no[].
  if iv_process_mode = 'A'.
*---select only for role type VENDOR
    SELECT A~CLIENT A~PARTNER_GUID A~VENDOR
                   INTO  TABLE LT_CVI_VEND_LINK
                   FROM  CVI_VEND_LINK AS A INNER JOIN BUT000 AS B
                   ON    B~PARTNER_GUID = A~PARTNER_GUID
                         INNER JOIN BUT100 AS C
                         ON    C~PARTNER = B~PARTNER
                   WHERE A~PARTNER_GUID IN LR_PARTNER_GUID
                   AND   A~VENDOR       IN LR_VENDOR_NO
                   AND   C~RLTYP        EQ iC_ROLE_VENDOR
                   AND ( C~VALID_FROM   LE IV_CURRENT_TIME AND
                         C~VALID_TO     GE IV_CURRENT_TIME  OR
                         C~VALID_FROM   EQ 0 AND
                         C~VALID_TO     EQ 0 OR
                         C~VALID_FROM   IS NULL AND
                         C~VALID_TO     IS NULL ).
  elseif iv_process_mode = 'B'.
*---select for role type VENDOR and INV_PARTY
    SELECT A~CLIENT A~PARTNER_GUID A~VENDOR
                   INTO  TABLE LT_CVI_VEND_LINK
                   FROM  CVI_VEND_LINK AS A INNER JOIN BUT000 AS B
                   ON    B~PARTNER_GUID = A~PARTNER_GUID
                         INNER JOIN BUT100 AS C
                         ON    C~PARTNER = B~PARTNER
                   WHERE A~PARTNER_GUID IN LR_PARTNER_GUID
                   AND   A~VENDOR    IN LR_VENDOR_NO
                   AND ( C~RLTYP EQ iC_ROLE_VENDOR OR
                         C~RLTYP EQ iC_ROLE_INV_PARTY )
                   AND ( C~VALID_FROM   LE IV_CURRENT_TIME AND
                         C~VALID_TO     GE IV_CURRENT_TIME  OR
                         C~VALID_FROM   EQ 0 AND
                         C~VALID_TO     EQ 0 OR
                         C~VALID_FROM   IS NULL AND
                         C~VALID_TO     IS NULL ).
  elseif iv_process_mode = 'C'.
    SELECT * INTO TABLE LT_CVI_VEND_LINK FROM CVI_VEND_LINK
             WHERE PARTNER_GUID IN LR_PARTNER_GUID.
  endif.
  LOOP AT LT_CVI_VEND_LINK ASSIGNING <LFS_CVI_VEND_LINK>.
      CLEAR LS_maptab.
      MOVE <LFS_CVI_VEND_LINK>-PARTNER_GUID TO LS_maptab-PARTNER_GUID.
      MOVE <LFS_CVI_VEND_LINK>-VENDOR       TO LS_maptab-VENDOR_NO.
      APPEND LS_maptab TO LT_maptab.
  ENDLOOP.
  et_vendormap[] = lt_maptab[].
  REFRESH LT_CVI_VEND_LINK.
ENDFUNCTION.
