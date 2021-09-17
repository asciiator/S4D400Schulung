*&---------------------------------------------------------------------*
*& Report s4d400_clas_s2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z26_inh_1.
CLASS lcl_airplane DEFINITION.

  PUBLIC SECTION.
    TYPES: BEGIN OF ts_attribute,
             attribute TYPE string,
             value     TYPE string,
           END OF ts_attribute,
           tt_attributes TYPE STANDARD TABLE OF ts_attribute
            WITH NON-UNIQUE KEY attribute.

    METHODS:

      constructor
        IMPORTING iv_name      TYPE string
                  iv_planetype TYPE saplane-planetype
        RAISING   cx_s4d400_wrong_plane,
      set_attributes
        IMPORTING
          iv_name      TYPE string
          iv_planetype TYPE saplane-planetype,

      get_attributes
        EXPORTING
          et_attributes TYPE tt_attributes.

    CLASS-METHODS:
      get_n_o_airplanes EXPORTING ev_number TYPE i,
      class_constructor.

PROTECTED SECTION.
    DATA:
      mv_name      TYPE string,
      mv_planetype TYPE saplane-planetype.

  PRIVATE SECTION.

    CLASS-DATA:
      gv_n_o_airplanes TYPE i,
      gt_planetypes    TYPE STANDARD TABLE OF saplane WITH NON-UNIQUE KEY planetype.

ENDCLASS.                    "lcl_airplane DEFINITION
CLASS lcl_airplane IMPLEMENTATION.

  METHOD set_attributes.

    mv_name      = iv_name.
    mv_planetype = iv_planetype.



  ENDMETHOD.                    "set_attributes

  METHOD get_attributes.

    et_attributes = VALUE #(  (  attribute = 'NAME' value = mv_name )
                              (  attribute = 'PLANETYPE' value = mv_planetype ) ).
  ENDMETHOD.                    "display_attributes

  METHOD get_n_o_airplanes.
    ev_number = gv_n_o_airplanes.
  ENDMETHOD.                    "display_n_o_airplanes

  METHOD constructor.
    IF NOT line_exists( gt_planetypes[ planetype = iv_planetype ] ).
      RAISE EXCEPTION TYPE cx_s4d400_wrong_plane.
    ENDIF.
    mv_name = iv_name.
    mv_planetype = iv_planetype.
    gv_n_o_airplanes = gv_n_o_airplanes + 1.
  ENDMETHOD.

  METHOD class_constructor.
    SELECT * FROM saplane INTO TABLE gt_planetypes.
  ENDMETHOD.

ENDCLASS.                    "lcl_airplane IMPLEMENTATION

CLASS lcl_cargo_plane DEFINITION INHERITING FROM lcl_airplane.
PUBLIC SECTION.
METHODS get_attributes REDEFINITION.
METHODS CONSTRUCTOR
    IMPORTING iv_name TYPE string
              iv_planetype TYPE saplane-planetype
              iv_weight TYPE i
   RAISING cx_s4d400_wrong_plane.


PRIVATE SECTION.
DATA mv_weight TYPE i.

ENDCLASS.

CLASS lcl_cargo_plane IMPLEMENTATION.

METHOD get_attributes.
et_attributes = VALUE #(  (  attribute = 'NAME' value = mv_name )
                              (  attribute = 'PLANETYPE' value = mv_planetype )
                              ( attribute = 'WEIGHT' value = mv_weight ) ).
ENDMETHOD.

METHOD CONSTRUCTOR.
super->constructor(
  EXPORTING
    iv_name      = iv_name
    iv_planetype = iv_planetype
).
mv_weight = iv_weight.

ENDMETHOD.

ENDCLASS.

CLASS lcl_passenger_plane DEFINITION INHERITING FROM lcl_airplane.
PUBLIC SECTION.
METHODS get_attributes REDEFINITION.
METHODS CONSTRUCTOR
        IMPORTING iv_name TYPE string
                  iv_planetype TYPE saplane-planetype
                  iv_seats TYPE i
        RAISING cx_s4d400_wrong_plane.
PRIVATE SECTION.
DATA mv_seats TYPE i.
ENDCLASS.

CLASS lcl_passenger_plane IMPLEMENTATION.
METHOD get_attributes.
super->get_attributes(
  IMPORTING
    et_attributes = et_attributes
).
et_attributes = VALUE #( base et_attributes ( attribute = 'Seats' value = mv_seats ) ).
ENDMETHOD.

METHOD Constructor.
super->constructor(
  EXPORTING
    iv_name      = iv_name
    iv_planetype = iv_planetype
).
    mv_seats = iv_seats.
Endmethod.
ENDCLASS.

DATA: go_airplane   TYPE REF TO lcl_airplane,
      gt_airplanes  TYPE TABLE OF REF TO lcl_airplane,
      gt_attributes TYPE lcl_airplane=>tt_attributes,
      gt_output     TYPE lcl_airplane=>tt_attributes.

START-OF-SELECTION.


  TRY.
      go_airplane = NEW #(
          iv_name      = 'Plane 1'
          iv_planetype = '747-400'
      ).
      gt_airplanes = VALUE #(  BASE gt_airplanes ( go_airplane ) ).
    CATCH cx_s4d400_wrong_plane.
  ENDTRY.

  TRY.
      go_airplane = NEW #(
          iv_name      = 'Plane 2'
          iv_planetype = 'XXX'
      ).
      gt_airplanes = VALUE #(  BASE gt_airplanes ( go_airplane ) ).
    CATCH cx_s4d400_wrong_plane.
  ENDTRY.

  TRY.
      go_airplane = NEW #(
          iv_name      = 'Plane 3'
          iv_planetype = '146-200'
      ).
      gt_airplanes = VALUE #(  BASE gt_airplanes ( go_airplane ) ).
    CATCH cx_s4d400_wrong_plane.
  ENDTRY.


  LOOP AT gt_airplanes INTO go_airplane.
    go_airplane->get_attributes(
      IMPORTING
        et_attributes = gt_attributes
    ).

    gt_output = CORRESPONDING #(  BASE ( gt_output  ) gt_attributes ).
  ENDLOOP.

  cl_s4d_output=>display_table(  gt_output ).
