FUNCTION z_26_add.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(I_VAL1) TYPE  Z00_PACKED
*"     VALUE(I_VAL2) TYPE  Z00_PACKED DEFAULT 1
*"  EXPORTING
*"     REFERENCE(E_RESULT) TYPE  Z00_PACKED
*"----------------------------------------------------------------------
  e_result = i_val1 + i_val2.

ENDFUNCTION.
