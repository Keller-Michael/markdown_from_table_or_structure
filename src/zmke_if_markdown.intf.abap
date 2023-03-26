INTERFACE zmke_if_markdown PUBLIC.

  METHODS generate_from_structure
    IMPORTING
      structure     TYPE any
    RETURNING
      VALUE(result) TYPE string_table.

  METHODS generate_from_table
    IMPORTING
      table         TYPE any
    RETURNING
      VALUE(result) TYPE string_table.

  METHODS generate_from_bapi_return
    IMPORTING
      table         TYPE bapirettab
    RETURNING
      VALUE(result) TYPE string_table.

ENDINTERFACE.
