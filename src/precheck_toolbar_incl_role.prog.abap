*&---------------------------------------------------------------------*
*& Include          PRECHECK_TOOLBAR_INCL_ROLE
*&---------------------------------------------------------------------*
 delete table e_object->mt_toolbar with table key function = '&DETAIL'.
  delete table e_object->mt_toolbar with table key function = '&LOCAL&COPY'.
  delete table e_object->mt_toolbar with table key function = '&LOCAL&UNDO'.
  delete table e_object->mt_toolbar with table key function = '&LOCAL&PASTE'.
  delete table e_object->mt_toolbar with table key function = '&LOCAL&CUT'.
  delete table e_object->mt_toolbar with table key function = '&CHECK'.
  delete table e_object->mt_toolbar with table key function = '&REFRESH'.
  delete table e_object->mt_toolbar with table key function = '&LOCAL&APPEND'.
*  delete table e_object->mt_toolbar with table key function = '&LOCAL&INSERT_ROW'.
*  delete table e_object->mt_toolbar with table key function = '&LOCAL&DELETE_ROW'.
  delete table e_object->mt_toolbar with table key function = '&LOCAL&COPY_ROW'.
  delete table e_object->mt_toolbar with table key function = '&SORT_ASC'.
  delete table e_object->mt_toolbar with table key function = '&SORT_DSC'.
  delete table e_object->mt_toolbar with table key function = '&FIND'.
  delete table e_object->mt_toolbar with table key function = '&FIND_MORE'.
  delete table e_object->mt_toolbar with table key function = '&MB_FILTER'.
  delete table e_object->mt_toolbar with table key function = '&MB_SUM'.
  delete table e_object->mt_toolbar with table key function = '&MB_SUBTOT'.
  delete table e_object->mt_toolbar with table key function = '&PRINT_BACK'.
  delete table e_object->mt_toolbar with table key function = '&MB_VIEW'.
  delete table e_object->mt_toolbar with table key function = '&MB_EXPORT'.
  delete table e_object->mt_toolbar with table key function = '&COL0'.
  delete table e_object->mt_toolbar with table key function = '&GRAPH'.
  delete table e_object->mt_toolbar with table key function = '&INFO'.
