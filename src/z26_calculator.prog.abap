*&---------------------------------------------------------------------*
*& Report z26_calculator
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z26_calculator.

TYPES ty_packed TYPE p LENGTH 3 DECIMALS 2. "Typ - keine Variable!

DATA:
  g_res    TYPE decfloat34, g_fehler TYPE string, i_proc TYPE s4d400_percentage.
PARAMETERS:
  p_num1 TYPE decfloat34, p_num2 TYPE decfloat34, p_op TYPE c LENGTH 1.

CASE p_op.
  WHEN '+'.
    g_res = p_num1 + p_num2.
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

  WHEN OTHERS.
    g_fehler = 'Nicht die Operatoren, die sie suchen. (+,-,*,/, ^)'.
ENDCASE.
IF g_fehler = ''.
  WRITE g_res.
ELSE.
  WRITE g_fehler.
ENDIF.
