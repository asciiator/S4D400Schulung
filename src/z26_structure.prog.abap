*&---------------------------------------------------------------------*
*& Report z26_structure
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z26_structure.

TYPES: BEGIN OF ts_complete,
         carrid    TYPE d400_struct_s1-carrid,
         connid    TYPE d400_struct_s1-connid,
         cityfrom  TYPE d400_struct_s1-cityfrom,
         cityto    TYPE  d400_struct_s1-cityto,
         fldate    TYPE d400_s_flight-fldate,
         planetype TYPE d400_s_flight-planetype,
         seatsmax  TYPE d400_s_flight-seatsmax,
         seatsocc  TYPE d400_s_flight-seatsocc,
       END OF ts_complete.


DATA gs_conn TYPE z26_connection.
DATA  g_flight  TYPE d400_s_flight.
DATA gs_complete TYPE ts_complete.

gs_conn = VALUE #( carrid = `LH` connid = `0400` cityfrom = `FRANKFURT` cityto = `NEW YORK`).
TRY.
    cl_s4d400_flight_model=>get_next_flight(
      EXPORTING
        iv_carrid = gs_conn-carrid
        iv_connid = gs_conn-connid
      IMPORTING
        es_flight = g_flight ).
    gs_complete = CORRESPONDING #( BASE ( gs_complete ) gs_conn ).
    gs_complete = CORRESPONDING #( BASE ( gs_complete ) g_flight ).

    cl_s4d_output=>display_structure( iv_structure = gs_complete  ).
  CATCH cx_s4d400_no_data.
    cl_s4d_output=>display_line( iv_text = |{ TEXT-001 }| ).
ENDTRY.
