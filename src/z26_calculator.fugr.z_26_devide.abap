FUNCTION z_26_devide.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(I_VAL1) TYPE  Z00_PACKED OPTIONAL
*"     VALUE(I_VAL2) TYPE  Z00_PACKED DEFAULT 25
*"  EXPORTING
*"     REFERENCE(E_RESULT) TYPE  I
*"  EXCEPTIONS
*"      DEVISION_BY_ZERO
*"----------------------------------------------------------------------
  IF i_val2 = 0.
    RAISE devision_by_zero.
  ENDIF.

  e_result = i_val1 / i_val2.






ENDFUNCTION.
