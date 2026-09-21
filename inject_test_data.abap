*&---------------------------------------------------------------------*
*& Report: zfc_inject_test_data
*& Purpose: Inject test data into existing records (Anonymized)
*&---------------------------------------------------------------------*
REPORT zfc_inject_test_data.

" =====================================================================
" FIELD MAPPING KEY (For your reference when adapting to real system):
" Header Table (example_db_01):
"   field01 = ID, field02 = Status, field05 = Created Date, field06 = Run Date
" Notes Table (example_db_04):
"   field01 = ID, field18 = Note#, field05 = Date, field19 = Time
"   field20 = User, field21 = Text
" =====================================================================

DATA: lv_today       TYPE datum,
      lv_count_upd   TYPE i,
      lv_count_notes TYPE i,
      ls_db_01       TYPE example_db_01,
      ls_db_04       TYPE example_db_04,
      lv_max_note    TYPE numc10.

lv_today = sy-datum.

START-OF-SELECTION.
  PERFORM inject_data.
  PERFORM show_results.

*&---------------------------------------------------------------------*
*& Form INJECT_DATA
*&---------------------------------------------------------------------*
FORM inject_data.

  " 1. NEW CASES TODAY: Update Record 105 (field05 = today, field02 = 'A')
  SELECT SINGLE * FROM example_db_01 INTO ls_db_01 WHERE field01 = '0000000105'.
  IF sy-subrc = 0.
    ls_db_01-field05 = lv_today.
    MODIFY example_db_01 FROM ls_db_01.
    lv_count_upd = lv_count_upd + 1.
    PERFORM add_note USING '0000000105' |TEST-INJEKTION: field05 auf heute ({ lv_today }) gesetzt|.
  ENDIF.

  " 2. PAYMENT PROMISES DUE TODAY: Update Record 101 (field06 = today, field02 = 'R')
  SELECT SINGLE * FROM example_db_01 INTO ls_db_01 WHERE field01 = '0000000101'.
  IF sy-subrc = 0.
    ls_db_01-field06 = lv_today.
    MODIFY example_db_01 FROM ls_db_01.
    lv_count_upd = lv_count_upd + 1.
    PERFORM add_note USING '0000000101' |TEST-INJEKTION: field06 auf heute ({ lv_today }) gesetzt - Fällige Zusage|.
  ENDIF.

  " 3. PAYMENTS TODAY: Update Record 106 (field02 = 'C', field05 = today)
  SELECT SINGLE * FROM example_db_01 INTO ls_db_01 WHERE field01 = '0000000106'.
  IF sy-subrc = 0.
    ls_db_01-field02 = 'C'. " Value from example_dom_01 (Closed/Paid)
    ls_db_01-field05 = lv_today.
    MODIFY example_db_01 FROM ls_db_01.
    lv_count_upd = lv_count_upd + 1.
    PERFORM add_note USING '0000000106' |TEST-INJEKTION: field02 auf 'C' und field05 auf heute gesetzt|.
  ENDIF.

  " 4. FOLLOW-UP TODAY: Update Record 107 (field06 = today)
  SELECT SINGLE * FROM example_db_01 INTO ls_db_01 WHERE field01 = '0000000107'.
  IF sy-subrc = 0.
    ls_db_01-field06 = lv_today.
    MODIFY example_db_01 FROM ls_db_01.
    lv_count_upd = lv_count_upd + 1.
    PERFORM add_note USING '0000000107' |TEST-INJEKTION: Wiedervorlage heute ({ lv_today })|.
  ENDIF.

  " 5. DOCUMENT EXISTING DATA (No update needed, just add notes for dashboard context)
  PERFORM add_note USING '0000000101' 'TEST-INJEKTION: Dient auch als abgebrochene Ratenzahlung (ursprüngl. field06 < heute)'.
  PERFORM add_note USING '0000000102' 'TEST-INJEKTION: Dient als Sperrung vorgemerkt (Mahnstufe 3+, field02=A)'.

  COMMIT WORK.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form ADD_NOTE
*&---------------------------------------------------------------------*
FORM add_note USING pv_id TYPE char20
                    pv_text TYPE txt255.

  " Get next note number
  SELECT MAX( field18 ) FROM example_db_04 
    WHERE field01 = @pv_id 
    INTO @lv_max_note.
  
  lv_max_note = lv_max_note + 1.
  IF lv_max_note <= 0. 
    lv_max_note = 1. 
  ENDIF.

  CLEAR ls_db_04.
  ls_db_04-mandt      = sy-mandt.
  ls_db_04-field01    = pv_id.
  ls_db_04-field18    = lv_max_note.
  ls_db_04-field05    = sy-datum.
  ls_db_04-field19    = sy-uzeit.
  ls_db_04-field20    = sy-uname.
  ls_db_04-field21    = pv_text.

  INSERT example_db_04 FROM ls_db_04.
  IF sy-subrc = 0.
    lv_count_notes = lv_count_notes + 1.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form SHOW_RESULTS
*&---------------------------------------------------------------------*
FORM show_results.
  WRITE: / '================================================================================'.
  WRITE: / 'TEST DATA INJECTION COMPLETED'.
  WRITE: / 'Records Updated:', lv_count_upd.
  WRITE: / 'Notes Added:    ', lv_count_notes.
  WRITE: / '================================================================================'.
  WRITE: / 'Dashboard tiles should now display data for:'.
  WRITE: / '- Neue Forderungen (Record 105)'.
  WRITE: / '- Fällige Zahlungszusagen (Record 101)'.
  WRITE: / '- Zahlungseingänge Heute (Record 106)'.
  WRITE: / '- Offene Wiedervorlagen (Record 107)'.
  WRITE: / '- Abgebrochene Ratenzahlungen (Record 101)'.
  WRITE: / '- Zur Sperrung vorgemerkt (Record 102)'.
  WRITE: / '================================================================================'.
  WRITE: / 'NOTE: All changes are documented in the example_db_04 notes table.'.
ENDFORM.
