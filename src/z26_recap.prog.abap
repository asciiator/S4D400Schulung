*&---------------------------------------------------------------------*
*& Report z26_recap
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z26_recap.


PARAMETERS p_input TYPE string.
DATA(i_len) = strlen( p_input ).
DATA(g_first) = substring( val = p_input off = 0 len = 1 ).

CASE g_first.
  WHEN 'A'.
    WRITE to_lower( p_input ).
  WHEN 'Z'.
    p_input = reverse( p_input ).
    WRITE p_input.
  WHEN OTHERS.
    WHILE sy-index - 1 < i_len.
      WRITE / substring( val = p_input off = sy-index - 1 len = 1 ) && sy-index.
    ENDWHILE.


ENDCASE.
