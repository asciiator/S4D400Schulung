*&---------------------------------------------------------------------*
*& Report z26_calculator
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z26_function_module.

TYPES ty_packed TYPE p LENGTH 3 DECIMALS 2. "Typ - keine Variable!

DATA:
  g_res    TYPE Z00_PACKED, g_fehler TYPE string, i_proc TYPE s4d400_percentage.
PARAMETERS:
  p_num1 TYPE decfloat34, p_num2 TYPE decfloat34, p_op TYPE c LENGTH 1.

CASE p_op.
  WHEN '+'.
    CALL FUNCTION 'Z_26_ADD'
      EXPORTING
        i_val1   = CONV Z00_PACKED( p_num1 )
        i_val2   = CONV Z00_PACKED( p_num1 )
      IMPORTING
        e_result = g_res.
  WHEN '-'.
    g_res = p_num1 - p_num2.
  WHEN '*'.
    g_res = p_num1 * p_num2.
  WHEN '/'.
    IF p_num2 = 0.
      g_fehler = 'Durch Null teilen ist böse'.
    ELSE.
      g_res = p_num1 / p_num2.
    ENDIF.
  WHEN '^'.
    g_res = ipow( base = p_num1 exp = p_num2 ).
  WHEN '%'.
    CALL FUNCTION 'S4D400_CALCULATE_PERCENTAGE'
      EXPORTING
        iv_int1          = CONV i( p_num1 )
        iv_int2          = CONV i( p_num2 )
      IMPORTING
        ev_result        = i_proc
      EXCEPTIONS
        division_by_zero = 1
        OTHERS           = 2.
    IF sy-subrc <> 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      cl_s4d_output=>display_string( iv_text = |{ TEXT-te1 }| ).
      MESSAGE `devision by zero` TYPE 'S' DISPLAY LIKE 'E'. "I-> Info / S->Success /W -> Warning / E -> Error
    ENDIF.

    g_res = i_proc.

  WHEN OTHERS.
    g_fehler = 'Nicht die Operatoren, die sie suchen. (+,-,*,/, ^)'.
ENDCASE.
IF g_fehler = ''.
  WRITE g_res.
ELSE.
  WRITE g_fehler.
ENDIF.
