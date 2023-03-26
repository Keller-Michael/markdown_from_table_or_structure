CLASS zmke_cl_markdown DEFINITION PUBLIC FINAL CREATE PRIVATE.

  PUBLIC SECTION.
    INTERFACES zmke_if_markdown.

    CLASS-METHODS get_instance RETURNING VALUE(result) TYPE REF TO zmke_if_markdown.

    ALIASES generate_from_table FOR zmke_if_markdown~generate_from_table.

    METHODS constructor.

  PROTECTED SECTION.

  PRIVATE SECTION.
    METHODS get_table_components
      IMPORTING
        table         TYPE any
      RETURNING
        VALUE(result) TYPE abap_component_tab.

    METHODS generate_table_headline
      IMPORTING
        components    TYPE abap_component_tab
      RETURNING
        VALUE(result) TYPE string_table.

    METHODS generate_table_entries
      IMPORTING
        table         TYPE any
        components    TYPE abap_component_tab
      RETURNING
        VALUE(result) TYPE string_table.

ENDCLASS.



CLASS zmke_cl_markdown IMPLEMENTATION.

  METHOD zmke_if_markdown~generate_from_structure.
    DATA line TYPE string.
    DATA element TYPE REF TO cl_abap_elemdescr.

    TRY.
        DATA(description) = CAST cl_abap_structdescr( cl_abap_structdescr=>describe_by_data( structure ) ).
      CATCH cx_sy_move_cast_error.
        RETURN.
    ENDTRY.

    DATA(components) = description->get_components( ).

    DATA(headlines) = VALUE string_table( ( `| Field | Value |` )
                                          ( `| :--- | :--- |` ) ).

    APPEND LINES OF headlines TO result.

    LOOP AT components INTO DATA(component).
      TRY.
          element = CAST cl_abap_elemdescr( component-type ).
        CATCH cx_sy_move_cast_error.
          CONTINUE.
      ENDTRY.

      ASSIGN COMPONENT component-name OF STRUCTURE structure TO FIELD-SYMBOL(<value>).
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      line = |\| { component-name } \| { <value> } \||.
      APPEND line TO result.
    ENDLOOP.
  ENDMETHOD.

  METHOD zmke_if_markdown~generate_from_table.
    DATA(components) = get_table_components( table ).
    IF components IS INITIAL.
      RETURN.
    ENDIF.

    DATA(headline_and_alignment) = generate_table_headline( components ).
    IF headline_and_alignment IS INITIAL.
      RETURN.
    ENDIF.
    APPEND LINES OF headline_and_alignment TO result.

    DATA(entries) = generate_table_entries( table      = table
                                            components = components ).

    IF entries IS INITIAL.
      RETURN.
    ENDIF.
    APPEND LINES OF  entries TO result.
  ENDMETHOD.

  METHOD generate_table_headline.
    DATA headline TYPE string.
    DATA alignment TYPE string.

    LOOP AT components INTO DATA(component).
      IF sy-tabix = 1.
        headline = |\| { component-name }|.
        alignment = |\| :---|.
      ELSEIF sy-tabix = lines( components ).
        headline = |{ headline } \| { component-name } \||.
        alignment = |{ alignment } \| :--- \||.
      ELSE.
        headline = |{ headline } \| { component-name } |.
        alignment = |{ alignment } \| :--- |.
      ENDIF.
    ENDLOOP.

    APPEND headline TO result.
    APPEND alignment TO result.
  ENDMETHOD.

  METHOD get_instance.
    result = NEW zmke_cl_markdown( ).
  ENDMETHOD.

  METHOD constructor.
  ENDMETHOD.

  METHOD get_table_components.
    TRY.
        DATA(table_description) = CAST cl_abap_tabledescr( cl_abap_tabledescr=>describe_by_data( table ) ).
      CATCH cx_sy_move_cast_error.
        RETURN.
    ENDTRY.

    TRY.
        DATA(structure_description) = CAST cl_abap_structdescr( table_description->get_table_line_type( ) ).
      CATCH cx_sy_move_cast_error.
        RETURN.
    ENDTRY.

    result = structure_description->get_components( ).
  ENDMETHOD.


  METHOD generate_table_entries.
    DATA entry TYPE string.
    DATA element TYPE REF TO cl_abap_elemdescr.

    FIELD-SYMBOLS <table> TYPE ANY TABLE.
    FIELD-SYMBOLS <entry> TYPE any.

    ASSIGN ('TABLE') TO <table>.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    LOOP AT <table> ASSIGNING <entry>.
      CLEAR entry.
      LOOP AT components INTO DATA(component).
        TRY.
            element = CAST cl_abap_elemdescr( component-type ).
          CATCH cx_sy_move_cast_error.
            CONTINUE.
        ENDTRY.

        ASSIGN COMPONENT component-name OF STRUCTURE <entry> TO FIELD-SYMBOL(<value>).
        IF sy-subrc <> 0.
          CONTINUE.
        ENDIF.

        IF sy-tabix = 1.
          entry = |\| { <value> }|.
        ELSEIF sy-tabix = lines( components ).
          entry = |{ entry } \| { <value> } \||.
        ELSE.
          entry = |{ entry } \| { <value> }|.
        ENDIF.
      ENDLOOP.
      APPEND entry TO result.
    ENDLOOP.
  ENDMETHOD.

  METHOD zmke_if_markdown~generate_from_bapi_return.
    CONSTANTS msg_type_is_error TYPE bapi_mtype VALUE 'E'.
    CONSTANTS msg_type_is_abort TYPE bapi_mtype VALUE 'A'.
    CONSTANTS msg_type_is_success TYPE bapi_mtype VALUE 'S'.
    CONSTANTS msg_type_is_info TYPE bapi_mtype VALUE 'I'.
    CONSTANTS msg_type_is_warning TYPE bapi_mtype VALUE 'W'.

    result = generate_from_table( table ).

    LOOP AT result ASSIGNING FIELD-SYMBOL(<line>).
      IF sy-tabix = 1.
        <line> = |\| ICON { <line> }|.
      ELSEIF sy-tabix = 2.
        <line> = |\| :--- { <line> }|.
      ELSE.
        TRY.
            DATA(message) = table[ sy-tabix - 2 ].
          CATCH cx_sy_itab_line_not_found.
            CONTINUE.
        ENDTRY.

        CASE message-type.
          WHEN msg_type_is_error OR msg_type_is_abort.
            <line> = |\| :red_circle: { <line> }|.
          WHEN msg_type_is_info OR msg_type_is_warning.
            <line> = |\| :yellow_circle: { <line> }|.
          WHEN msg_type_is_success.
            <line> = |\| :green_circle: { <line> }|.
        ENDCASE.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
