*&---------------------------------------------------------------------*
*& Report z26_sql1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z26_sql1.

DATA: gs_flight  TYPE d400_s_flight, g_airline TYPE d400_s_flight-carrid, g_flightnr TYPE d400_s_flight-connid,
      g_fldate   TYPE d400_s_flight-fldate.
cl_s4d_input=>get_flight(
  IMPORTING
    ev_airline   = g_airline
    ev_flight_no = g_flightnr
    ev_date      = g_fldate
).

SELECT SINGLE FROM sflight
FIELDS carrid, connid, fldate, planetype, seatsmax, seatsocc
WHERE carrid = @g_airline AND connid = @g_flightnr AND fldate = @g_fldate
INTO @gs_flight.

cl_s4d_output=>display_structure( iv_structure =  gs_flight ).
