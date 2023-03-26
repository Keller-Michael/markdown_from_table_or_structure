CLASS zmke_cl_markdown_playground DEFINITION PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.



CLASS zmke_cl_markdown_playground IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    DATA markdown_table TYPE string_table.

    DATA(markdown) = zmke_cl_markdown=>get_instance( ).

    SELECT SINGLE * FROM I_currency INTO @DATA(currency).
    markdown_table = markdown->generate_from_structure( currency ).
    out->write( markdown_table ).

    out->write( space ).

    SELECT * FROM I_Currency INTO TABLE @DATA(currencies).
    markdown_table = markdown->generate_from_table( currencies ).
    out->write( markdown_table ).

    out->write( space ).

    DATA(bapi_messages) = VALUE bapirettab( ( type = 'E' id = 'SY' number = '499' message_v1 = 'Hi' message_v2 = 'there!' )
                                            ( type = 'A' id = 'SY' number = '499' message_v1 = 'Hi' message_v2 = 'there!' )
                                            ( type = 'I' id = 'SY' number = '499' message_v1 = 'Hi' message_v2 = 'there!' )
                                            ( type = 'W' id = 'SY' number = '499' message_v1 = 'Hi' message_v2 = 'there!' )
                                            ( type = 'S' id = 'SY' number = '499' message_v1 = 'Hi' message_v2 = 'there!' ) ).

    markdown_table = markdown->generate_from_bapi_return( bapi_messages ).
    out->write( markdown_table ).
  ENDMETHOD.

ENDCLASS.
