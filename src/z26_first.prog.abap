*&---------------------------------------------------------------------*
*& Report z26_first
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z26_first.
PARAMETERS p_carr TYPE s_carr_id. "mit input"
PARAMETERS p_carrc TYPE c LENGTH 3.
WRITE:p_carr, 'Hello World'.

DATA: var1 TYPE c LENGTH 1, var2 TYPE i.

DATA g_num TYPE n.
DATA g_char TYPE c.
