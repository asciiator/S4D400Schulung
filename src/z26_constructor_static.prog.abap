*&---------------------------------------------------------------------*
*& Report z26_constructor
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z26_constructor_static.

CLASS lcl_airplane DEFINITION.
  PUBLIC SECTION.
    TYPES: BEGIN OF ts_attribute,
             attribute TYPE string,
             value     TYPE string,
           END OF ts_attribute,
           tt_attributes TYPE STANDARD TABLE OF ts_attribute
                           WITH NON-UNIQUE KEY attribute.
    METHODS:
        CONSTRUCTOR
        IMPORTING iv_name TYPE string
                  iv_planetype TYPE saplane-planetype
        RAISING CX_S4D400_WRONG_PLANE,

          set_attributes
      IMPORTING iv_name  TYPE string
                iv_plane TYPE saplane-planetype,
      get_attributes
        EXPORTING et_attributes TYPE tt_attributes.
      CLASS-METHODS class_construnctor.

    CLASS-METHODS:
      get_n_o_airplanes
        EXPORTING ev_number TYPE i.

  PRIVATE SECTION.
    DATA: mv_name      TYPE string, mv_planetype TYPE saplane-planetype.
    CLASS-DATA: gv_n_o_airplanes TYPE i.
    CLASS-Data gt_planetypes TYPE STANDARD TABLE OF SAPLANE WITH NON-UNIQUE
    Key PLANETYPE.

ENDCLASS.

CLASS lcl_airplane IMPLEMENTATION.

  METHOD get_attributes.
    et_attributes = VALUE #( ( attribute = 'NAME' value = mv_name )
              ( attribute = 'PLANETYPE' value = CONV string( mv_planetype ) ) ).

  ENDMETHOD.

  METHOD get_n_o_airplanes.
    ev_number = gv_n_o_airplanes.
  ENDMETHOD.

  METHOD set_attributes.
    mv_name = iv_name.
    mv_planetype = iv_plane.
  ENDMETHOD.

  METHOD constructor.
  IF NOT line_exists( gt_planetypes[ planetype = iv_planetype ] ).
  RAISE EXCEPTION TYPE CX_S4D400_WRONG_PLANE.
  ENDIF.
        mv_name = iv_name.
        mv_planetype = iv_planetype.
        gv_n_o_airplanes = gv_n_o_airplanes + 1.
  ENDMETHOD.

  METHOD class_construnctor.
    SELECT * FROM saplane into TABLE gt_planetypes.
  ENDMETHOD.

ENDCLASS.

DATA: go_airplane  TYPE REF TO lcl_airplane,
      gt_airplanes TYPE TABLE OF REF TO lcl_airplane,
      gt_attributes TYPE lcl_airplane=>tt_attributes,
      gt_output TYPE lcl_airplane=>tt_attributes.
START-OF-SELECTION.
  DO 3 TIMES.
    TRY.
    go_airplane = NEW #( iv_name  = | Plane-{ sy-index } | iv_planetype = 'LB' ).
    gt_airplanes = VALUE #( BASE gt_airplanes ( go_airplane ) ).
    CATCH cx_s4d400_wrong_plane.
    ENDTRY.
  ENDDO.

LOOP AT gt_airplanes INTO DATA(go_airplane2).
go_airplane2->get_attributes(
  IMPORTING
    et_attributes = gt_attributes
).
gt_output = CORRESPONDING #( BASE ( gt_output ) gt_attributes ).
ENDLOOP.
cl_s4d_output=>display_table( it_table = gt_output  ).
