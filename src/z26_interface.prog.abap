*&---------------------------------------------------------------------*
*& Report s4d400_intf_t1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z26_interface.

INTERFACE lif_partner.
  TYPES: BEGIN OF ts_info,
           attribute TYPE string,
           value     TYPE string,
         END OF ts_info,
         tt_info TYPE STANDARD TABLE OF ts_info WITH NON-UNIQUE KEY attribute.
  METHODS get_partner_info RETURNING VALUE(rt_info) TYPE tt_info.
ENDINTERFACE.
CLASS lcl_vehicle DEFINITION.

  PUBLIC SECTION.
    TYPES: BEGIN OF ts_attribute,
             attribute TYPE string,
             value     TYPE string,
           END OF ts_attribute,
           tt_attributes TYPE STANDARD TABLE OF ts_attribute
            WITH NON-UNIQUE KEY attribute.
    METHODS:
      set_attributes
        IMPORTING
          iv_make  TYPE s_make
          iv_model TYPE s_model,

      get_attributes EXPORTING et_attributes TYPE tt_attributes,

      constructor IMPORTING iv_make  TYPE s_make
                            iv_model TYPE s_model
                  RAISING
                            cx_s4d400_wrong_vehicle.

    CLASS-METHODS:
      get_n_o_vehicles EXPORTING ev_number TYPE i,
      class_constructor.
  PROTECTED SECTION.
    DATA: mv_color TYPE string,
          mv_make  TYPE s_make,
          mv_model TYPE s_model.

  PRIVATE SECTION.




    CLASS-DATA:
      gv_n_o_vehicles TYPE i,
      gt_vehicles     TYPE STANDARD TABLE OF svehicle WITH NON-UNIQUE KEY make model.

ENDCLASS.                    "lcl_vehicle DEFINITION

*------------------------------------------------------------------*
*       CLASS lcl_vehicle IMPLEMENTATION                          *
*------------------------------------------------------------------*
CLASS lcl_vehicle IMPLEMENTATION.

  METHOD set_attributes.

    mv_make  = iv_make.
    mv_model = iv_model.

    gv_n_o_vehicles = gv_n_o_vehicles + 1.

  ENDMETHOD.                    "set_attributes

  METHOD get_attributes.

    et_attributes = VALUE #(  ( attribute = 'MAKE' value = mv_make )
                             ( attribute = 'MODEL' value = mv_model ) ).

  ENDMETHOD.                    "get_attributes

  METHOD get_n_o_vehicles.
    ev_number = gv_n_o_vehicles.
  ENDMETHOD.                    "display_n_o_vehicles

  METHOD constructor.
    IF NOT line_exists(  gt_vehicles[ make = iv_make model = iv_model ] ).
      RAISE EXCEPTION TYPE cx_s4d400_wrong_vehicle.
    ENDIF.
    set_attributes(
      EXPORTING
        iv_make  = iv_make
        iv_model = iv_model
    ).

  ENDMETHOD.

  METHOD class_constructor.
    SELECT * FROM svehicle INTO TABLE gt_vehicles.
  ENDMETHOD.

ENDCLASS.                    "lcl_vehicle IMPLEMENTATION

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
    DATA: mv_name      TYPE string,
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

CLASS lcl_rental DEFINITION.
  PUBLIC SECTION.
  INTERFACES lif_partner.
    TYPES: tt_vehicletab TYPE STANDARD TABLE OF REF TO lcl_vehicle WITH EMPTY KEY.
    METHODS:
      add_vehicle IMPORTING io_vehicle TYPE REF TO lcl_vehicle,
      get_vehicles RETURNING VALUE(rt_vehicles) TYPE tt_vehicletab.


  PRIVATE SECTION.
    DATA mt_vehicles TYPE tt_vehicletab.
ENDCLASS.

CLASS lcl_rental IMPLEMENTATION.
  METHOD lif_partner~get_partner_info.
  rt_info = VALUE #( ( attribute = 'TYPE' value = 'RENTAL' )
                ( attribute = 'VEHICELS' value = lines( mt_vehicles ) ) ).
  ENDMETHOD.
  METHOD add_vehicle.
    mt_vehicles = VALUE #(  BASE mt_vehicles ( io_vehicle ) ).
  ENDMETHOD.

  METHOD get_vehicles.
    rt_vehicles = mt_vehicles.
  ENDMETHOD.



ENDCLASS.
CLASS lcl_carrier DEFINITION.
  PUBLIC SECTION.
  INTERFACES lif_partner.
    TYPES: tt_planetab TYPE STANDARD TABLE OF REF TO lcl_airplane WITH EMPTY KEY.
    METHODS:
      add_plane IMPORTING io_plane TYPE REF TO lcl_airplane,
      get_planes RETURNING VALUE(rt_planes) TYPE tt_planetab.

  PRIVATE SECTION.
    DATA mt_planes TYPE tt_planetab.
ENDCLASS.

CLASS lcl_carrier IMPLEMENTATION.
  METHOD add_plane.
    mt_planes = VALUE #(  BASE mt_planes ( io_plane ) ).
  ENDMETHOD.

  METHOD get_planes.
    rt_planes = mt_planes.
  ENDMETHOD.

  METHOD lif_partner~get_partner_info.
    rt_info = VALUE #( ( attribute = 'TYPE' value = 'CARRIER' )
                ( attribute = 'PLANES' value = lines( mt_planes ) ) ).
  ENDMETHOD.

ENDCLASS.

DATA: go_airplane     TYPE REF TO lcl_airplane,
      go_carrier      TYPE REF TO lcl_carrier,
      go_rental       TYPE REF TO lcl_rental,
      go_vehicle      TYPE REF TO lcl_vehicle,
      gt_partners TYPE TABLE OF REF TO lif_partner,
      gt_all_partners TYPE lif_partner=>tt_info,
      gt_single_partner TYPE lif_partner=>tt_info.


START-OF-SELECTION.

* Create airline and car rental
  go_carrier = NEW #(  ).
  go_rental = NEW #( ) .
   gt_partners = VALUE #( ( go_carrier ) ( go_rental ) ).

* Create some airplanes
Try.
  go_airplane = NEW #( iv_name = 'Plane 1'
                       iv_planetype = 'A380-800' ).
 go_carrier->add_plane(  go_airplane ).
 CATCH cx_s4d400_wrong_plane.
 ENDTRY.

Try.
  go_airplane = NEW #(  iv_name = 'Plane 2'
                        iv_planetype = '737-800' ).
  go_carrier->add_plane(  go_airplane ).
 CATCH cx_s4d400_wrong_plane.
 ENDTRY.

Try.
  go_airplane = NEW #(  iv_name = 'Plane 3'
 iv_planetype = '747-400' ).

  go_carrier->add_plane(  go_airplane ).
 CATCH cx_s4d400_wrong_plane.
 ENDTRY.


* Create some vehicles.
  Try.
  go_vehicle = NEW #(  iv_make = 'AUDI'
                       iv_model = 'A3' ).
  go_rental->add_vehicle(  go_vehicle ).
  CATCH cx_s4d400_wrong_vehicle.
  ENDTRY.

  Try.
  go_vehicle = NEW #(  iv_make = 'MAN'
                         iv_model = 'TGX' ).
  go_rental->add_vehicle(  go_vehicle ).
  CATCH cx_s4d400_wrong_vehicle.
  ENDTRY.
  LOOP AT gt_partners INTO DATA(go_parnter).
  Try.
  gt_single_partner = go_parnter->get_partner_info( ).
  gt_all_partners = CORRESPONDING #( Base ( gt_all_partners ) gt_single_partner ).
  CATCH cx_s4d400_wrong_vehicle.
  ENDTRY.
  ENDLOOP.

 cl_s4d_output=>display_table( it_table = gt_all_partners ).
* CATCH cx_s4d_no_structure.
* CATCH cx_s4d_no_structure.
