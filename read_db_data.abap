*&---------------------------------------------------------------------*
*& Report: zfc_read_db_data
*& Purpose: Read and display current data from generic tables (Anonymized)
*&---------------------------------------------------------------------*
REPORT zfc_read_db_data.

" =====================================================================
" FIELD MAPPING KEY (For your reference when adapting to real system):
" Header Table (example_db_01):
"   field01 = ID, field02 = Status, field03 = Customer, field04 = CoCode
"   field05 = Created Date, field06 = Run Date, field07 = Ref ID
" Position Table (example_db_02):
"   field01 = ID, field08 = Doc Number, field09 = Year, field10 = Item
"   field11 = Level, field12 = Amount, field13 = Currency, field14 = Date
" Master Data Table (example_db_03):
"   field07 = Ref ID, field15 = Name, field16 = User, field17 = Email
" Notes Table (example_db_04):
"   field01 = ID, field18 = Note#, field05 = Date, field19 = Time
"   field20 = User, field21 = Text
" =====================================================================

DATA: lt_db_01 TYPE STANDARD TABLE OF example_db_01,
      lt_db_02 TYPE STANDARD TABLE OF example_db_02,
      lt_db_03 TYPE STANDARD TABLE OF example_db_03,
      lt_db_04 TYPE STANDARD TABLE OF example_db_04.

DATA: ls_db_01 TYPE example_db_01,
      ls_db_02 TYPE example_db_02,
      ls_db_03 TYPE example_db_03,
      ls_db_04 TYPE example_db_04.

START-OF-SELECTION.
  " 1. Read Header Table
  SELECT * FROM example_db_01 INTO TABLE lt_db_01.
  WRITE: / '=== HEADER TABLE (example_db_01) ==='.
  WRITE: / 'field01 | field02 | field03 | field04 | field05  | field06  | field07'.
  WRITE: / '------------------------------------------------------------------------'.
  LOOP AT lt_db_01 INTO ls_db_01.
    WRITE: / ls_db_01-field01, '|', ls_db_01-field02, '|', ls_db_01-field03, '|', 
           ls_db_01-field04, '|', ls_db_01-field05, '|', ls_db_01-field06, '|', ls_db_01-field07.
  ENDLOOP.
  ULINE.

  " 2. Read Position Table
  SELECT * FROM example_db_02 INTO TABLE lt_db_02.
  WRITE: / '=== POSITION TABLE (example_db_02) ==='.
  WRITE: / 'field01 | field08 | field09 | field10 | field11 | field12 | field13 | field14'.
  WRITE: / '------------------------------------------------------------------------'.
  LOOP AT lt_db_02 INTO ls_db_02.
    WRITE: / ls_db_02-field01, '|', ls_db_02-field08, '|', ls_db_02-field09, '|', 
           ls_db_02-field10, '|', ls_db_02-field11, '|', ls_db_02-field12, '|', 
           ls_db_02-field13, '|', ls_db_02-field14.
  ENDLOOP.
  ULINE.

  " 3. Read Master Data Table
  SELECT * FROM example_db_03 INTO TABLE lt_db_03.
  WRITE: / '=== MASTER DATA TABLE (example_db_03) ==='.
  WRITE: / 'field07 | field15 | field16 | field17'.
  WRITE: / '------------------------------------------------------------------------'.
  LOOP AT lt_db_03 INTO ls_db_03.
    WRITE: / ls_db_03-field07, '|', ls_db_03-field15, '|', ls_db_03-field16, '|', ls_db_03-field17.
  ENDLOOP.
  ULINE.

  " 4. Read Notes Table
  SELECT * FROM example_db_04 INTO TABLE lt_db_04.
  WRITE: / '=== NOTES TABLE (example_db_04) ==='.
  WRITE: / 'field01 | field18 | field05 | field19 | field20 | field21'.
  WRITE: / '------------------------------------------------------------------------'.
  LOOP AT lt_db_04 INTO ls_db_04.
    WRITE: / ls_db_04-field01, '|', ls_db_04-field18, '|', ls_db_04-field05, '|', 
           ls_db_04-field19, '|', ls_db_04-field20, '|', ls_db_04-field21.
  ENDLOOP.
