*&---------------------------------------------------------------------*
*& Report z26_class
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z26_class.

CLASS lcl_airplane DEFINITION.
  PUBLIC SECTION.
    TYPES: BEGIN OF ts_attribute,
             attribute TYPE string,
             value     TYPE string,
           END OF ts_attribute,
           tt_attributes TYPE STANDARD TABLE OF ts_attribute
                           WITH NON-UNIQUE KEY attribute.
    METHODS: set_attributes
      IMPORTING iv_name  TYPE string
                iv_plane TYPE saplane-planetype,
      get_attributes
        EXPORTING et_attributes TYPE tt_attributes.
    CLASS-METHODS:
      get_n_o_airplanes
        EXPORTING ev_number TYPE i.

  PRIVATE SECTION.
    DATA: mv_name      TYPE string, mv_planetype TYPE saplane-planetype.
    CLASS-DATA: gv_n_o_airplanes TYPE i.

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

ENDCLASS.
