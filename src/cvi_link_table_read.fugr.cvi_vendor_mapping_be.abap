FUNCTION CVI_VENDOR_MAPPING_BE.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_CURRENT_TIME) TYPE  TIMESTAMP OPTIONAL
*"     REFERENCE(IV_PROCESS_MODE) TYPE  C OPTIONAL
*"  CHANGING
*"     REFERENCE(IT_PARTNER_GUID) OPTIONAL
*"     REFERENCE(IT_VENDOR_NO) TYPE  ANY TABLE OPTIONAL
*"     REFERENCE(ET_VENDORMAP) TYPE  ANY TABLE OPTIONAL
*"----------------------------------------------------------------------
CONSTANTS: ic_role_vendor    type bu_rltyp value 'BBP000',
           ic_role_inv_party type bu_rltyp value 'BBP006'.

TYPES:   begin of lty_maptab,
              partner_guid type bu_partner_guid,
              vendor_no    type lifnr,
           end of lty_maptab.

DATA:   lr_partner_guid type bu_partner_guid,
        lt_cvi_vend_link type table of cvi_vend_link,
        ls_maptab type lty_maptab,
        lt_maptab type table of lty_maptab.

field-symbols:  <lfs_cvi_vend_link> type cvi_vend_link.

  IF iv_process_mode = 'A'.
*   select only for role type VENDOR
    SELECT a~client a~partner_guid a~vendor
                   INTO  TABLE lt_cvi_vend_link
                   FROM  cvi_vend_link AS A INNER JOIN but000 AS b
                   ON    b~partner_guid = a~partner_guid
                         INNER JOIN but100 AS c
                         ON    c~partner = b~partner
                   WHERE a~partner_guid eq it_partner_guid
                   AND   c~rltyp        eq ic_role_vendor
                   AND ( c~valid_from   le iv_current_time and
                         c~valid_to     ge iv_current_time  or
                         c~valid_from   eq 0 and
                         c~valid_to     eq 0 or
                         c~valid_from   is null and
                         c~valid_to     is null ).

 ELSEIF iv_process_mode = 'B'.
*   select for role type VENDOR and INV_PARTY
   SELECT a~client a~partner_guid a~vendor
                  INTO  table lt_cvi_vend_link
                  FROM  cvi_vend_link AS A INNER JOIN but000 AS b
                  ON    b~partner_guid = a~partner_guid
                        INNER JOIN but100 AS c
                        ON    c~partner = b~partner
                  WHERE a~partner_guid eq it_partner_guid
                  AND ( c~rltyp eq ic_role_vendor or
                        c~rltyp eq ic_role_inv_party )
                  AND ( c~valid_from   le iv_current_time and
                        c~valid_to     ge iv_current_time  or
                        c~valid_from   eq 0 and
                        c~valid_to     eq 0 or
                        c~valid_from   is null and
                        c~valid_to     is null ).


 ENDIF.

 LOOP at lt_cvi_vend_link assigning <lfs_cvi_vend_link>.
   clear ls_maptab.
   move <lfs_cvi_vend_link>-partner_guid to ls_maptab-partner_guid.
   move <lfs_cvi_vend_link>-vendor       to ls_maptab-vendor_no.
   append ls_maptab to lt_maptab.
 ENDLOOP.

 et_vendormap[] = lt_maptab[].
 refresh lt_cvi_vend_link.

ENDFUNCTION.
