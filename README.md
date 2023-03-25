# :factory: Generate Markdown table from internal table or structure

## Description

Executable classes and the ABAP Development Tools console as an output area for information are particularly useful when using the SAP Business Technology platform (SAP BTP). With this sample class you are able to generate a [Markdown](https://en.wikipedia.org/wiki/Markdown) table from an internal table or structure in your ABAP code. The advantage is that a Markdown table can be easily prepared and processed: You can use online editors such as [Dillinger](https://dillinger.io/) or offline editors such as [Visual Studio Code](https://code.visualstudio.com/) with suitable plugins such as Markdown. Not to forget: Markdown plays a huge role on GitHub.

## Example

Here's an simple example call to generate a Markdown table from a structure (example 1) and from internal table (example 2).

```
METHOD if_oo_adt_classrun~main.
  DATA markdown_table TYPE string_table.

  DATA(markdown) = zmke_cl_markdown=>get_instance( ).

  SELECT SINGLE * FROM I_currency INTO @DATA(currency).
  markdown_table = markdown->generate_from_structure( currency ).
  out->write( markdown_table ).

  SELECT * FROM I_Currency INTO TABLE @DATA(currencies).
  markdown_table = markdown->generate_from_table( currencies ).
  out->write( markdown_table ).
ENDMETHOD.
```

Here's the result for example 1:

| Field | Value |                   
| :--- | :--- |                     
| CURRENCY | AED |                  
| DECIMALS | 2 |                    
| CURRENCYISOCODE | AED |           
| ALTERNATIVECURRENCYKEY | 784 |    
| ISPRIMARYCURRENCYFORISOCRCY |  |  
  
Here's the result for example 2 (showing only two entries, there are more):
  
| CURRENCY | DECIMALS  | CURRENCYISOCODE  | ALTERNATIVECURRENCYKEY  | ISPRIMARYCURRENCYFORISOCRCY |  
| :--- | :---  | :---  | :---  | :--- |                                                              
| AED | 2 | AED | 784 |  |                                                                           
| AFN | 2 | AFN | 971 |  |                                                                           
| ALL | 2 | ALL | 008 |  |       

## Notice

I stumbled across some problems during development involving non-released development objects for SAP BTP, specifically methods of typical classes like CL_ABAP_STRUCTDESCR (really missing GET_DDIC_FIELD_LIST). In an on-premises system, some things such as the column headings of the Markdown table could certainly be designed better ([CamelCase](https://en.wikipedia.org/wiki/Camel_case)).
