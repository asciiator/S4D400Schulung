*&---------------------------------------------------------------------*
*& Report jm_dbg_test
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z26_debug.


DATA: gv_int1   TYPE i VALUE 12,
      gv_int2   TYPE i VALUE 200,
      gv_result TYPE p LENGTH 16 DECIMALS 2.


gv_result = gv_int1 * gv_int2.

IF gv_int2 IS INITIAL.
  gv_int2 = 1.
ENDIF.

CLEAR gv_result.

DO 10 TIMES.
  gv_result = gv_int1 * sy-index.
ENDDO.

IF gv_result < 100.
  cl_s4d_output=>display_line(   TEXT-t01  ). "Finished
ELSE.
  cl_s4d_output=>display_line(  TEXT-t02 ). "Not Quite Finished
ENDIF.
