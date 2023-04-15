CLASS zmke_cl_markdown_playground DEFINITION PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.

  PRIVATE SECTION.
    METHODS output_simple_structure IMPORTING console TYPE REF TO if_oo_adt_classrun_out.

    METHODS output_complex_structure IMPORTING console TYPE REF TO if_oo_adt_classrun_out.

    METHODS output_simple_table IMPORTING console TYPE REF TO if_oo_adt_classrun_out.

    METHODS output_complex_table IMPORTING console TYPE REF TO if_oo_adt_classrun_out.

    METHODS output_bapi_messages IMPORTING console TYPE REF TO if_oo_adt_classrun_out.

ENDCLASS.



CLASS zmke_cl_markdown_playground IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    output_simple_structure( out ).
    output_complex_structure( out ).
    output_simple_table( out ).
    output_complex_table( out ).
    output_bapi_messages( out ).
  ENDMETHOD.

  METHOD output_complex_structure.
    TYPES: BEGIN OF name_details,
             first_name TYPE string,
             last_name  TYPE string,
           END OF name_details.

    TYPES: BEGIN OF contact_details,
             phone  TYPE string,
             e_mail TYPE string,
           END OF contact_details.

    TYPES: BEGIN OF person_details,
             personnel_number TYPE string.
             INCLUDE TYPE name_details.
             INCLUDE TYPE contact_details.
    TYPES: END OF person_details.

    DATA(markdown) = zmke_cl_markdown=>get_instance( ).

    DATA(person) = VALUE person_details( personnel_number = '001'
                                         first_name = 'John'
                                         last_name = 'Doe'
                                         phone = '4711'
                                         e_mail = 'j.doe@example.com' ).

    DATA(markdown_table) = markdown->generate_from_structure( person ).

    console->write( markdown_table ).
    console->write( space ).
  ENDMETHOD.

  METHOD output_simple_structure.
    DATA(markdown) = zmke_cl_markdown=>get_instance( ).

    SELECT SINGLE * FROM I_currency INTO @DATA(currency).
    DATA(markdown_table) = markdown->generate_from_structure( currency ).

    console->write( markdown_table ).
    console->write( space ).
  ENDMETHOD.

  METHOD output_simple_table.
    DATA(markdown) = zmke_cl_markdown=>get_instance( ).

    SELECT * FROM I_Currency INTO TABLE @DATA(currencies).
    DATA(markdown_table) = markdown->generate_from_table( currencies ).

    console->write( markdown_table ).
    console->write( space ).
  ENDMETHOD.

  METHOD output_bapi_messages.
    DATA(markdown) = zmke_cl_markdown=>get_instance( ).

    DATA(bapi_messages) = VALUE bapirettab( ( type = 'E' id = 'SY' number = '499' message_v1 = 'Hi' message_v2 = 'there!' )
                                            ( type = 'A' id = 'SY' number = '499' message_v1 = 'Hi' message_v2 = 'there!' )
                                            ( type = 'I' id = 'SY' number = '499' message_v1 = 'Hi' message_v2 = 'there!' )
                                            ( type = 'W' id = 'SY' number = '499' message_v1 = 'Hi' message_v2 = 'there!' )
                                            ( type = 'S' id = 'SY' number = '499' message_v1 = 'Hi' message_v2 = 'there!' ) ).

    DATA(markdown_table) = markdown->generate_from_bapi_return( bapi_messages ).

    console->write( markdown_table ).
    console->write( space ).
  ENDMETHOD.

  METHOD output_complex_table.
    TYPES: BEGIN OF name_details,
             first_name TYPE string,
             last_name  TYPE string,
           END OF name_details.

    TYPES: BEGIN OF phone_details,
             phone_number TYPE string,
             country      TYPE string,
           END OF phone_details.

    TYPES: BEGIN OF contact_details.
             INCLUDE TYPE phone_details.
    TYPES: END OF contact_details.

    TYPES: BEGIN OF person_details,
             personnel_number TYPE string.
             INCLUDE TYPE name_details.
             INCLUDE TYPE contact_details.
    TYPES: END OF person_details.

    TYPES persons TYPE TABLE OF person_details WITH KEY personnel_number.

    DATA(markdown) = zmke_cl_markdown=>get_instance( ).

    DATA(persons) = VALUE persons( ( personnel_number = '001' first_name = 'John' last_name = 'Doe' phone_number = '4711' country = 'Italy' )
                                   ( personnel_number = '002' first_name = 'Jane' last_name = 'Doe' phone_number = '8812' country = 'Germany' ) ).

    DATA(markdown_table) = markdown->generate_from_table( persons ).

    console->write( markdown_table ).
    console->write( space ).
  ENDMETHOD.

ENDCLASS.
