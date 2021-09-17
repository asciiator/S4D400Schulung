*&---------------------------------------------------------------------*
*& Report z26_sql2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z26_sql2.

DATA: gt_flights TYPE d400_t_flights, g_airline TYPE d400_s_flight-carrid,
       g_flightnum TYPE d400_s_flight-connid.
cl_s4d_input=>get_connection(
  IMPORTING
    ev_airline   = g_airline
    ev_flight_no = g_flightnum
).

SELECT FROM SFLIGHT
FIELDS carrid, connid, fldate, planetype, seatsmax, seatsocc
WHERE carrid = @g_airline AND connid = @g_flightnum
INTO TABLE @gt_flights.

cl_s4d_output=>display_table( it_table = gt_flights ).
