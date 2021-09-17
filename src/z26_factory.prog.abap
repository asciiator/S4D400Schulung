*&---------------------------------------------------------------------*
*& Report s4d400_factoy_s1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z26_factory.
CLASS lcl_airplane DEFINITION CREATE PRIVATE.

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
      class_constructor,
      get_plane IMPORTING iv_name         TYPE string
                          iv_planetype    TYPE saplane-planetype
                RETURNING VALUE(ro_plane) TYPE REF TO lcl_airplane
                RAISING   cx_s4d400_wrong_plane.

  PRIVATE SECTION.
    TYPES: BEGIN OF ts_instance,
             name      TYPE string,
             planetype TYPE string,
             object    TYPE REF TO lcl_airplane,
           END OF ts_instance,
           tt_instances TYPE STANDARD TABLE OF ts_instance WITH NON-UNIQUE KEY name planetype.
    DATA:
      mv_name      TYPE string,
      mv_planetype TYPE saplane-planetype.

    CLASS-DATA:
      gv_n_o_airplanes TYPE i,
      gt_planetypes    TYPE STANDARD TABLE OF saplane WITH NON-UNIQUE KEY planetype,
      gt_instances     TYPE tt_instances.

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

  METHOD get_plane.
* The purpose of this factory method is to ensure that for each combination of name and planetype only one
* instance of the class is created.
* When the consumer requests an instance, the method first consults an internal table containing all of the instances
* that have already been created.
* If there is an appropriate instance, the method returns it *without* creating a new instance.
* IF the instance does not exist, the method creates one, returns it, and adds it to its internal buffer for the next time.

    TRY. "Try to read the instance corresponding to the supplied name and plane type.
        ro_plane = gt_instances[ name = iv_name planetype = iv_planetype ]-object.

* If it does not exist, cx_sy_itab_line_not_found is thrown. That just means we need to create the instance.
      CATCH cx_sy_itab_line_not_found.

* Create the new instance and send it back to the caller
* The constructor  *could* trigger the exception cx_s4d400_wrong_plane.
* It is not caught here, but is listed in the signature of this method.
* This means that it would be passed directly back to the caller to handle themselves.
        ro_plane = NEW #(  iv_name = iv_name iv_planetype = iv_planetype ).

* But add it to the internal table as well.
        gt_instances = VALUE #(  BASE gt_instances  (  name = iv_name planetype = iv_planetype object = ro_plane ) ).
    ENDTRY.
  ENDMETHOD.

ENDCLASS.                    "lcl_airplane IMPLEMENTATION




DATA: go_airplane   TYPE REF TO lcl_airplane,
      gt_airplanes  TYPE TABLE OF REF TO lcl_airplane,
      gt_attributes TYPE lcl_airplane=>tt_attributes,
      gt_output     TYPE lcl_airplane=>tt_attributes.

START-OF-SELECTION.


  TRY.
      go_airplane = lcl_airplane=>get_plane(
          iv_name      = 'Plane 1'
          iv_planetype = '747-400'
      ).
      gt_airplanes = VALUE #(  BASE gt_airplanes ( go_airplane ) ).
    CATCH cx_s4d400_wrong_plane.
  ENDTRY.

  TRY.
      go_airplane = lcl_airplane=>get_plane(
          iv_name      = 'Plane 1'
          iv_planetype = '747-400'
      ).
      gt_airplanes = VALUE #(  BASE gt_airplanes ( go_airplane ) ).
    CATCH cx_s4d400_wrong_plane.
  ENDTRY.

  TRY.
      go_airplane = lcl_airplane=>get_plane(
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
