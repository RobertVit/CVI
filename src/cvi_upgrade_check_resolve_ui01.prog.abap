*----------------------------------------------------------------------*
***INCLUDE CVI_UPGRADE_CHECK_RESOLVE_UI01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_1143  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_1143 INPUT.

data: display_profile type bal_s_prof,
      fcat            type bal_s_fcat,
      it_balhdr       type balhdr occurs 0 with header line,
      s_sort  TYPE  bal_s_sort.
DATA: l_sx_profile  TYPE bal_s_prof.

*data: wa_arcdel_obj type arcdel_obj.
data: wa_arcdel_obj type balsub.

* for investigating old/new protocol
DATA: obj_tab TYPE AS_T_ARCHOBJ,
       cross_ao type OBJCT_TR01 value 'X_ARCH_OBJ',
       ao_log type BALOBJ_D.
  CASE sy-ucomm.
  WHEN 'CANCEL'.
  LEAVE TO SCREEN 0.
  WHEN 'ENTER'.
  if object is not initial.
*  select single * from arcdel_obj into wa_arcdel_obj
*            where arc_objtype eq object.
   select single * from balsub into wa_arcdel_obj
            where object eq object.

  if sy-subrc <> 0.
* AO not in cross table
    MESSAGE id 'BA' type 'E' number '349'
           with object.
  endif.
endif.
** first check if AO is using the new protocol
*if wa_arcdel_obj-APPLOG_OBJECT = 'ADK_PROTOCOL'
*or object is initial.
** use new protocol
*  append cross_ao to obj_tab.
*  CALL FUNCTION 'ARCHIVE_PROTOCOLS_DISPLAY'
*    EXPORTING
*      i_arch_object = obj_tab. " cross ao
*
*else.
** use the old protocol
*  CALL FUNCTION 'BAL_DSP_PROFILE_STANDARD_GET'
*    IMPORTING
*      E_S_DISPLAY_PROFILE = display_profile.
*
*  display_profile-head_text = text-001.
*  display_profile-title     = text-002.
*
*  clear display_profile-lev1_fcat[].
*  clear fcat.
*
**-first column
*  fcat-ref_table = 'BAL_S_SHOW'.
*  fcat-ref_field = 'SUBOBJECT'.
*  fcat-col_pos = '1'.
*
*  clear fcat-outputlen.
*  clear fcat-colddictxt.
*  clear fcat-is_treecol.
*
*  fcat-colddictxt = 'R'.
*  fcat-is_treecol = ' '.
*
*  append fcat to display_profile-lev1_fcat.
*
**-second column
*  fcat-ref_table = 'BAL_S_SHOW'.
*  fcat-ref_field = 'ALDATE'.
*  fcat-col_pos = '2'.
*
*  clear fcat-outputlen.
*  clear fcat-colddictxt.
*  clear fcat-is_treecol.
*
*  fcat-outputlen = '20'.
*  fcat-is_treecol = 'X'.
*
*  append fcat to display_profile-lev1_fcat.
*
**-third column
*  fcat-ref_table = 'BAL_S_SHOW'.
*  fcat-ref_field = 'ALTIME'.
*  fcat-col_pos = '3'.
*  clear fcat-outputlen.
*  clear fcat-colddictxt.
*  clear fcat-is_treecol.
*
*  fcat-outputlen = '20'.
*  fcat-is_treecol = 'X'.
*
*  append fcat to display_profile-lev1_fcat.
*
*
* delete display_profile-lev1_sort where ( ( ref_table eq 'BAL_S_SHOW' )
*                                    and ( ref_field eq 'ALUSER' ) ).
*
**-fourth column
*  fcat-ref_table = 'BAL_S_SHOW'.
*  fcat-ref_field = 'T_SUBOBJ'.
*  fcat-outputlen = '20'.
*  fcat-col_pos = '4'.
*  fcat-colddictxt = 'R'.
*  fcat-is_treecol = 'X'.
*
*  append fcat to display_profile-lev1_fcat.
*
**-define sort-criteria
*  CLEAR s_sort.
*  s_sort-ref_table = 'BAL_S_SHOW'.
*  s_sort-ref_field = 'SUBOBJECT'.
*  s_sort-up        = 'X'.
*  APPEND s_sort TO display_profile-lev1_sort.
 if CD-LOW eq '00000000'.
   CD-LOW = ''.
 endif.

  if CD-HIGH eq '00000000'.
   CD-HIGH = ''.
  endif.

   CALL FUNCTION 'BAL_DSP_PROFILE_STANDARD_GET'
    IMPORTING
      e_s_display_profile = l_sx_profile.

  CLEAR: l_sx_profile-lev2_fcat, l_sx_profile-lev2_sort.
  CLEAR: l_sx_profile-lev3_fcat, l_sx_profile-lev3_sort.
  CLEAR: l_sx_profile-lev4_fcat, l_sx_profile-lev4_sort.
  CLEAR: l_sx_profile-lev5_fcat, l_sx_profile-lev5_sort.
  CLEAR: l_sx_profile-lev6_fcat, l_sx_profile-lev6_sort.
  CLEAR: l_sx_profile-lev7_fcat, l_sx_profile-lev7_sort.
  CLEAR: l_sx_profile-lev8_fcat, l_sx_profile-lev8_sort.
  CLEAR: l_sx_profile-lev9_fcat, l_sx_profile-lev9_sort.

  CALL FUNCTION 'APPL_LOG_DISPLAY'
          EXPORTING
              OBJECT                = wa_arcdel_obj-object
              SUBOBJECT             = wa_arcdel_obj-subobject
*                EXTERNAL_NUMBER                  = ' '
*                OBJECT_ATTRIBUTE                 = 0
*                SUBOBJECT_ATTRIBUTE              = 0
                EXTERNAL_NUMBER_ATTRIBUTE        = 2
              DATE_FROM                        = CD-LOW
*              TIME_FROM                        = time_min
              DATE_TO                          = CD-HIGH
*              TIME_TO                          = time_max
*              TITLE_SELECTION_SCREEN           = text-002
*                TITLE_LIST_SCREEN                = ' '
*                COLUMN_SELECTION                 = '11112221122   '
              SUPPRESS_SELECTION_DIALOG        = 'X'
*                COLUMN_SELECTION_MSG_JUMP        = '1'
*                EXTERNAL_NUMBER_DISPLAY_LENGTH = 20
              I_S_DISPLAY_PROFILE               = l_sx_profile
*                I_VARIANT_REPORT                 = ' '
*            IMPORTING
*                NUMBER_OF_PROTOCOLS              =
          EXCEPTIONS
              NO_AUTHORITY                     = 1
              OTHERS                           = 2
       .
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.

*endif.
  endcase.

ENDMODULE.
