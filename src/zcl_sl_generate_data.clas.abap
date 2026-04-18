CLASS zcl_sl_generate_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zcl_sl_generate_data IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA: it_books   TYPE TABLE OF zsl_books,
          it_members TYPE TABLE OF zsl_members.

    DELETE FROM zsl_books.
    DELETE FROM zsl_members.
    DELETE FROM zsl_checkouts.

    it_books = VALUE #(
      ( book_id = 'B001' title = 'The ABAP Handbook' author = 'SAP Expert' status = 'A' )
      ( book_id = 'B002' title = 'Mastering RAP'     author = 'Cloud Guru' status = 'A' )
    ).

    it_members = VALUE #(
      ( member_id = 'M001' name = 'Awesome Developer' )
    ).

    INSERT zsl_books FROM TABLE @it_books.
    INSERT zsl_members FROM TABLE @it_members.
    COMMIT WORK.

    out->write( 'Smart Library tables successfully populated!' ).
  ENDMETHOD.
ENDCLASS.
