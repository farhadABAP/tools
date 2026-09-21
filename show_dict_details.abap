*&---------------------------------------------------------------------*
*& Report: zfc_show_dict_details
*& Purpose: Display DDIC table fields and domain fixed values
*&---------------------------------------------------------------------*
REPORT zfc_show_dict_details.

" =====================================================================
" MAPPING KEY (Replace these before using in your SAP system):
" example_db_01 -> Header Table
" example_db_02 -> Position Table
" example_db_03 -> Master Data Table
" example_db_04 -> Notes Table
" example_dom_01 -> Status Domain
" example_dom_02 -> Rule Type Domain
" =====================================================================

DATA: lt_dfies TYPE TABLE OF dfies,
      ls_dfies TYPE dfies,
      lt_dd07v TYPE TABLE OF dd07v,
      ls_dd07v TYPE dd07v.

START-OF-SELECTION.
  " Display Table Structures
  PERFORM show_table_details USING 'EXAMPLE_DB_01'.
  PERFORM show_table_details USING 'EXAMPLE_DB_02'.
  PERFORM show_table_details USING 'EXAMPLE_DB_03'.
  PERFORM show_table_details USING 'EXAMPLE_DB_04'.

  " Display Domain Fixed Values
  PERFORM show_domain_details USING 'EXAMPLE_DOM_01'.
  PERFORM show_domain_details USING 'EXAMPLE_DOM_02'.

*&---------------------------------------------------------------------*
*& Form SHOW_TABLE_DETAILS
*&---------------------------------------------------------------------*
FORM show_table_details USING pv_tabname TYPE tabname.
  REFRESH lt_dfies.

  CALL FUNCTION 'DDIF_TABL_GET'
    EXPORTING
      name      = pv_tabname
    TABLES
      dfies_tab = lt_dfies
    EXCEPTIONS
      OTHERS    = 1.

  IF sy-subrc <> 0.
    WRITE: / 'Table', pv_tabname, 'not found in DDIC.'.
    RETURN.
  ENDIF.

  WRITE: / '================================================================================'.
  WRITE: / 'TABLE DETAILS:', pv_tabname.
  WRITE: / '--------------------------------------------------------------------------------'.
  WRITE: / 'Pos', 5 'Field Name', 30 'Data Element', 20 'Domain', 10 'Type', 5 'Lg'.
  WRITE: / '--------------------------------------------------------------------------------'.

  LOOP AT lt_dfies INTO ls_dfies.
    WRITE: / ls_dfies-position, 
           5 ls_dfies-fieldname, 
           30 ls_dfies-rollname, 
           20 ls_dfies-domname, 
           10 ls_dfies-datatype, 
           5 ls_dfies-leng.
  ENDLOOP.
  ULINE.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form SHOW_DOMAIN_DETAILS
*&---------------------------------------------------------------------*
FORM show_domain_details USING pv_domname TYPE domname.
  REFRESH lt_dd07v.

  CALL FUNCTION 'DDIF_DOMA_GET'
    EXPORTING
      name      = pv_domname
    TABLES
      dd07v_tab = lt_dd07v
    EXCEPTIONS
      OTHERS    = 1.

  IF sy-subrc <> 0.
    WRITE: / 'Domain', pv_domname, 'not found in DDIC.'.
    RETURN.
  ENDIF.

  WRITE: / '================================================================================'.
  WRITE: / 'DOMAIN FIXED VALUES:', pv_domname.
  WRITE: / '--------------------------------------------------------------------------------'.
  WRITE: / 'Pos', 5 'Value', 10 'Short Text'.
  WRITE: / '--------------------------------------------------------------------------------'.

  LOOP AT lt_dd07v INTO ls_dd07v.
    WRITE: / ls_dd07v-ddposition, 
           5 ls_dd07v-domvalue_l, 
           10 ls_dd07v-ddtext.
  ENDLOOP.
  ULINE.
ENDFORM.
