*&---------------------------------------------------------------------*
*& Report  CVI_MAPPING_BP_CUST_VEND
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  CVI_MAPPING_BP_CUST_VEND NO STANDARD PAGE HEADING.

SELECTION-SCREEN BEGIN OF BLOCK a01 WITH FRAME TITLE text-a01
                                                 NO INTERVALS.
PARAMETERS:p_findob   TYPE MDST_SYNC_OBJECTS AS LISTBOX VISIBLE LENGTH 15
                                                               OBLIGATORY,
           p_mapdob   TYPE MDST_SYNC_OBJECTS AS LISTBOX VISIBLE LENGTH 15
                                                               OBLIGATORY,
           p_number   TYPE char10 OBLIGATORY.

SELECTION-SCREEN END OF BLOCK a01.

* Local type
  types:  begin of lty_contact,
           kunnr         type kunnr,
           customer_cont type parnr,
          end of lty_contact.

* Local data declarations
  DATA :
       lv_msg          TYPE char100,
       lv_partner      LIKE but000-partner,
       lv_vendor       TYPE lifnr,
       lv_customer     TYPE kunnr,
       lv_partner_guid TYPE BU_PARTNER_GUID.

  DATA:
      ls_contacts      type lty_contact,
      lt_contacts      type table of lty_contact.

* Local constants.
  CONSTANTS:
      lc_bp(2)              type c value 'BP',
      lc_cust(8)            type c value 'CUSTOMER',
      lc_vend(6)            type c value 'VENDOR',
      lc_contact_person(14) type c value 'CONTACT PERSON'.

* Conversion of the Find Object to readable format.
  CASE p_findob.
     WHEN 1.
       p_findob = lc_bp.
     WHEN 2.
       p_findob = lc_cust.
     WHEN 3.
       p_findob = lc_vend.
     WHEN 4.
       p_findob = lc_contact_person.
     WHEN others.
       clear p_findob.
  ENDCASE.

* Conversion of the Mapped To Object to readable format.
  CASE p_mapdob.
     WHEN 1.
       p_mapdob = lc_bp.
     WHEN 2.
       p_mapdob = lc_cust.
     WHEN 3.
       p_mapdob = lc_vend.
     WHEN 4.
       p_mapdob = lc_contact_person.
     WHEN others.
       clear p_mapdob.
  ENDCASE.


* Basic Input Validations.
  IF p_findob = p_mapdob.
     write: / text-a14.
     EXIT.
  ELSEIF p_findob is initial or p_mapdob is initial or p_number is initial.
     write: / text-a15.
     EXIT.
  ELSEIF ( p_findob = lc_cust and p_mapdob = lc_vend ) OR
             ( p_findob = lc_vend and p_mapdob = lc_cust ).
     write: / text-a16,
            / text-a17.
     EXIT.
  ENDIF.


* Converting the number into the appropriate order.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = p_number
      IMPORTING
        output = p_number
      EXCEPTIONS
        OTHERS = 0.

* Initialization
  CLEAR: lv_partner,
         lv_partner_guid,
         lv_customer,
         lv_vendor.

* Depending on the Find By object the data is extracted.
  CASE p_findob.

     WHEN lc_bp.
*        Mapped To object
         CASE p_mapdob.
*           Find the BP mapped to the Customer.
            WHEN lc_cust.
               select single PARTNER_GUID from cvi_cust_link into lv_partner_guid
                  where customer = p_number.                          "#EC *
               if sy-subrc <> 0.
                  select single PARTNER from bd001 into lv_partner
                         where kunnr = p_number.                      "#EC *
                  if sy-subrc <> 0.
                      CONCATENATE text-a13
                                  p_number
                                  INTO lv_msg
                                  SEPARATED BY space.
                  else.
                    CONCATENATE text-a03
                                lv_partner
                                text-a08
                                p_number
                                INTO lv_msg
                                SEPARATED BY space.
                  endif.
                else.
                    CALL FUNCTION 'BUPA_NUMBERS_GET'
                      EXPORTING
                        iv_partner_guid   = lv_partner_guid
                      IMPORTING
                        ev_partner        = lv_partner.

                    IF lv_partner is not initial.
                       CONCATENATE  text-a03
                                    lv_partner
                                    text-a08
                                    p_number
                                    INTO lv_msg
                                    SEPARATED BY space.
                     ELSE.
                       CONCATENATE  text-a12
                                    p_number
                                    text-a05
                                    INTO lv_msg
                                    SEPARATED BY space.
                     ENDIF.
                endif.

*           Find the BP mapped to the Vendor.
            WHEN lc_vend.
              select single PARTNER_GUID from cvi_vend_link into lv_partner_guid
                  where vendor = p_number.                          "#EC *
                if sy-subrc <> 0.
                  select single PARTNER from bc001 into lv_partner
                         where lifnr = p_number.                    "#EC *
                  if sy-subrc <> 0.
                      CONCATENATE text-a11
                                  p_number
                                  INTO lv_msg
                                  SEPARATED BY space.
                  else.
                      CONCATENATE text-a03
                                  lv_partner
                                  text-a06
                                  p_number
                                  INTO lv_msg
                                  SEPARATED BY space.
                  endif.
                else.
                    CALL FUNCTION 'BUPA_NUMBERS_GET'
                      EXPORTING
                        iv_partner_guid   = lv_partner_guid
                      IMPORTING
                        ev_partner        = lv_partner.

                    IF lv_partner is not initial.
                       CONCATENATE text-a03
                                   lv_partner
                                   text-a06
                                   p_number
                                   INTO lv_msg
                                   SEPARATED BY space.
                  ELSE.
                       CONCATENATE  text-a10
                                    p_number
                                    text-a05
                                    INTO lv_msg
                                    SEPARATED BY space.
                  ENDIF.
                endif.

*           Find the BP mapped to the Contact Person of the Customer.
            WHEN lc_contact_person.
              select single PERSON_GUID from cvi_cust_ct_link into lv_partner_guid
                  where customer_cont = p_number.                          "#EC *
                if sy-subrc <> 0.
                   CONCATENATE text-a24
                               p_number
                               INTO lv_msg
                               SEPARATED BY space.
                else.
                    CALL FUNCTION 'BUPA_NUMBERS_GET'
                      EXPORTING
                        iv_partner_guid   = lv_partner_guid
                      IMPORTING
                        ev_partner        = lv_partner.

                    IF lv_partner is not initial.
                       CONCATENATE text-a03
                                   lv_partner
                                   text-a18
                                   p_number
                                   INTO lv_msg
                                   SEPARATED BY space.
                     ELSE.
                       CONCATENATE  text-a19
                                    p_number
                                    text-a05
                                    INTO lv_msg
                                    SEPARATED BY space.
                     ENDIF.
                endif.

              WHEN OTHERS.
                 lv_msg = text-a02.
         ENDCASE.

      WHEN lc_cust.

         CASE p_mapdob.

*           Find the Customer mapped to the BP.
            WHEN lc_bp.
               lv_partner = p_number.
               CALL FUNCTION 'BUPA_NUMBERS_GET'
                    EXPORTING
                      iv_partner      = lv_partner
                    IMPORTING
                      ev_partner_guid = lv_partner_guid.

               IF lv_partner_guid is not initial.

                    select single customer from cvi_cust_link into lv_customer
                        where partner_guid = lv_partner_guid.
                      if sy-subrc <> 0.
                        select single kunnr from bd001 into lv_customer
                               where partner = lv_partner.
                        if sy-subrc <> 0.
                            CONCATENATE text-a09
                                        p_number
                                        INTO lv_msg
                                        SEPARATED BY space.
                        else.
                            CONCATENATE text-a03
                                        lv_partner
                                        text-a08
                                        lv_customer
                                        INTO lv_msg
                                        SEPARATED BY space.
                        endif.
                      else.
                          CONCATENATE text-a03
                                      lv_partner
                                      text-a08
                                      lv_customer
                                      INTO lv_msg
                                      SEPARATED BY space.
                      endif.
               ELSE.
                   CONCATENATE text-a04
                               p_number
                               text-a05
                               INTO lv_msg
                               SEPARATED BY space.
               ENDIF.
            WHEN OTHERS.
              lv_msg = text-a02.
         ENDCASE.

       WHEN lc_vend.

         CASE p_mapdob.

*           Find the Vendor mapped to the BP.
            WHEN lc_bp.
               lv_partner = p_number.
               CALL FUNCTION 'BUPA_NUMBERS_GET'
                    EXPORTING
                      iv_partner      = lv_partner
                    IMPORTING
                       ev_partner_guid = lv_partner_guid.

               IF lv_partner_guid is not initial.

                  select single vendor from cvi_vend_link into lv_vendor
                      where partner_guid = lv_partner_guid.
                    if sy-subrc <> 0.
                      select single lifnr from bc001 into lv_vendor
                             where partner = lv_partner.
                      if sy-subrc <> 0.
                          CONCATENATE text-a07
                                      p_number
                                      INTO lv_msg
                                      SEPARATED BY space.
                      else.
                          CONCATENATE text-a03
                                      lv_partner
                                      text-a06
                                      lv_vendor
                                      INTO lv_msg
                                      SEPARATED BY space.
                      endif.
                    else.
                       CONCATENATE text-a03
                                   lv_partner
                                   text-a06
                                   lv_vendor
                                   INTO lv_msg
                                   SEPARATED BY space.

                    endif.
               ELSE.
                   CONCATENATE text-a04
                               p_number
                               text-a05
                               INTO lv_msg
                               SEPARATED BY space.
               ENDIF.
            WHEN OTHERS.
               lv_msg = text-a02.
          ENDCASE.

       WHEN lc_contact_person.

         CASE p_mapdob.
*           Find the Contact Person(s) of the Customer mapped to the BP.
            WHEN lc_bp.
               lv_partner = p_number.
               CALL FUNCTION 'BUPA_NUMBERS_GET'
                    EXPORTING
                      iv_partner      = lv_partner
                    IMPORTING
                       ev_partner_guid = lv_partner_guid.

               IF lv_partner_guid is not initial.

                  select * from cvi_cust_ct_link into corresponding fields of table lt_contacts
                           where person_guid = lv_partner_guid.
                    if sy-subrc <> 0.
                        CONCATENATE text-a20
                                    p_number
                                    INTO lv_msg
                                    SEPARATED BY space.
                    else.
*                      Get all the customers for the respective Contact persons.
                       loop at lt_contacts into ls_contacts.
                         select single kunnr from knvk into corresponding fields of ls_contacts
                                      where parnr = ls_contacts-customer_cont.
                          if sy-subrc = 0.
                             MODIFY lt_contacts FROM ls_contacts.
                          endif.

                       endloop.

                       WRITE :/ text-a03,
                                p_number,
                                text-a21,
                                sy-uline.

                       loop at lt_contacts into ls_contacts.
                          CONCATENATE text-a22
                                      ls_contacts-customer_cont
                                      text-a23
                                      ls_contacts-kunnr
                                      INTO lv_msg
                                      SEPARATED BY space.

                          WRITE : / lv_msg.
                          clear lv_msg.
                       endloop.
                    endif.

               ELSE.
                   CONCATENATE text-a04
                               p_number
                               text-a05
                               INTO lv_msg
                               SEPARATED BY space.
               ENDIF.
            WHEN OTHERS.
               lv_msg = text-a02.
          ENDCASE.

       WHEN OTHERS.
         lv_msg = text-a02.
  ENDCASE.

  WRITE:/ lv_msg.
