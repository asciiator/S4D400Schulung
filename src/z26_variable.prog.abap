*&---------------------------------------------------------------------*
*& Report z26_variable
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z26_variable.

PARAMETERS text TYPE string.
WRITE text.

DATA gv_text2 TYPE string.
cl_s4d_input=>get_text( IMPORTING ev_text = gv_text2 ).
cl_s4d_output=>display_string( iv_text = gv_text2 ).

DATA(g_int_inline) = 25.

DATA g_int_value TYPE i VALUE 25.

data(min) = nmin( VAL1 = 1 VAL2 = 2 VAL3 = 3 ).

WRITE abap_true.

do 3 times.
*bla
if min = 20.
continue.
endif.
*bla bla
ENDDO.

Do 5 Times.
DATA(g_outer) = sy-index.
DO 5 TIMES.
if g_outer = 3.
ENDIF.
ENDDO.
ENDDO.
