*&---------------------------------------------------------------------*
*& Report z26_itab
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z26_itab.

DATA gt_connections TYPE z26_t_connections.
DATA gt_flights TYPE d400_t_flights.
DATA gt_percentage TYPE d400_t_percentage.

gt_connections = VALUE #( ( carrid = 'LH' connid = '0400' )
                            ( carrid = 'LH' connid = '0402' ) ).

CALL FUNCTION 'Z26_GET_FLIGHTS_FOR_CONNECTION'
  EXPORTING
    it_connections = gt_connections
  IMPORTING
    et_flights     = gt_flights.

gt_percentage = CORRESPONDING #( gt_flights ).

LOOP AT gt_percentage REFERENCE INTO DATA(g_percentage_ref).
  IF g_percentage_ref->seatsmax <> 0.
    g_percentage_ref->percentage = g_percentage_ref->seatsocc / g_percentage_ref->seatsmax * 100.
  ENDIF.
ENDLOOP.
WRITE: / 'Carrid', AT 10 'Connid', AT 20 'fldate', AT 35 'Seatsmax',
        AT 45 'seatsocc', AT 55 'percentage' .

LOOP AT gt_percentage REFERENCE INTO DATA(g_percentage).
  WRITE: /  g_percentage->carrid, AT 10 g_percentage->connid,
          AT 20 g_percentage->fldate, AT 35 CONV string( g_percentage->seatsmax ),
          AT 45 CONV string( g_percentage->seatsocc ), AT 55 CONV string( g_percentage->percentage ).
ENDLOOP.
