*&---------------------------------------------------------------------*
*& Report z26_string
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z26_string.

" '' -> Charakter

DATA(g_char) = 'Hallo'.
g_char = 'Tschuess'.

WRITE g_char.

*`` -> STRING

DATA(g_string) = `Hallo`.
g_string = 'TSCHUESS'.
WRITE g_string.
*
*|| -> String
DATA(g_pipe) = |Hallo|.
g_pipe = 'TSCHUESS'.
WRITE g_pipe.

* Pipes for formatting

DATA(g_pipe2) = |Hallo { g_string }|.
WRITE g_pipe2.

DATA g_int TYPE i.
g_int = 1000.

DATA(g_write) = |{ g_int NUMBER = USER }|.
WRITE g_write.

g_write = |{ sy-datlo DATE = USER } { sy-timlo TIME = USER }|.
WRITE / g_write.

g_write = |{ sy-datlo DATE = RAW } { sy-timlo TIME = RAW }|.
WRITE / g_write.

*Abschliessende Leerzeichen werden bei '' ignoriert.

WRITE / `ich bin cool ` && 'und ich weniger ' && |gell|.

DATA(g_splitting) = |Oh mein Gott!|.
SPLIT g_splitting AT space INTO DATA(g_spl1) DATA(g_spl2) DATA(g_spl3).
WRITE / g_spl1 && g_spl2 && to_lower( g_spl3 ).


DATA g_packed_show TYPE p LENGTH 4 DECIMALS 2.
g_packed_show = 100.
g_packed_show = `100`.
g_packed_show = `100.25`.
WRITE / g_packed_show.

*leads to short dump
*g_packed_show = '100,25'.
*WRITE g_packed_show.

* Constants
CONSTANTS gc_hundred TYPE I VALUE 100.
WRITE gc_hundred.
