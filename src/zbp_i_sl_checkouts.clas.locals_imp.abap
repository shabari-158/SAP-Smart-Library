CLASS lhc_Checkout DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Checkout RESULT result.

    METHODS setInitialDates FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Checkout~setInitialDates.

    METHODS validateAvailability FOR VALIDATE ON SAVE
      IMPORTING keys FOR Checkout~validateAvailability.

    METHODS ReturnBook FOR MODIFY
      IMPORTING keys FOR ACTION Checkout~ReturnBook RESULT result.
ENDCLASS.

CLASS lhc_Checkout IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD setInitialDates.
    DATA(lv_today) = cl_abap_context_info=>get_system_date( ).
    DATA(lv_due)   = lv_today + 14.

    MODIFY ENTITIES OF ZI_SL_CHECKOUTS IN LOCAL MODE
      ENTITY Checkout
        UPDATE FIELDS ( CheckoutDate DueDate )
        WITH VALUE #( FOR key IN keys ( %tky         = key-%tky
                                        CheckoutDate = lv_today
                                        DueDate      = lv_due ) ).
  ENDMETHOD.

  METHOD validateAvailability.
    READ ENTITIES OF ZI_SL_CHECKOUTS IN LOCAL MODE
      ENTITY Checkout FIELDS ( BookId ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_checkouts).

    LOOP AT lt_checkouts INTO DATA(ls_checkout).
      SELECT SINGLE status FROM zsl_books WHERE book_id = @ls_checkout-BookId INTO @DATA(lv_status).

      IF lv_status = 'C'.
        APPEND VALUE #( %tky = ls_checkout-%tky ) TO failed-checkout.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD ReturnBook.
    READ ENTITIES OF ZI_SL_CHECKOUTS IN LOCAL MODE
      ENTITY Checkout FIELDS ( BookId DueDate ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_checkouts).

    LOOP AT lt_checkouts INTO DATA(ls_checkout).
      DATA(lv_today) = cl_abap_context_info=>get_system_date( ).
      DATA(lv_fine)  = 0.

      IF lv_today > ls_checkout-DueDate.
        DATA(lv_days_late) = lv_today - ls_checkout-DueDate.
        lv_fine = lv_days_late * 10.
      ENDIF.

      MODIFY ENTITIES OF ZI_SL_CHECKOUTS IN LOCAL MODE
        ENTITY Checkout
          UPDATE FIELDS ( ReturnDate FineAmount )
          WITH VALUE #( ( %tky       = ls_checkout-%tky
                          ReturnDate = lv_today
                          FineAmount = lv_fine ) ).

    ENDLOOP.

    READ ENTITIES OF ZI_SL_CHECKOUTS IN LOCAL MODE
      ENTITY Checkout ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_checkouts_updated).

    result = VALUE #( FOR checkout IN lt_checkouts_updated
                      ( %tky = checkout-%tky %param = checkout ) ).
  ENDMETHOD.
ENDCLASS.


CLASS lsc_ZI_SL_CHECKOUTS DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS save_modified REDEFINITION.
ENDCLASS.

CLASS lsc_ZI_SL_CHECKOUTS IMPLEMENTATION.
  METHOD save_modified.


    IF create-checkout IS NOT INITIAL.
      LOOP AT create-checkout INTO DATA(ls_create).
        UPDATE zsl_books SET status = 'C' WHERE book_id = @ls_create-BookId.
      ENDLOOP.
    ENDIF.


    IF update-checkout IS NOT INITIAL.
      LOOP AT update-checkout INTO DATA(ls_update).

        IF ls_update-ReturnDate IS NOT INITIAL.

           SELECT SINGLE book_id FROM zsl_checkouts WHERE trans_id = @ls_update-TransId INTO @DATA(lv_book).
           IF sy-subrc = 0.
             UPDATE zsl_books SET status = 'A' WHERE book_id = @lv_book.
           ENDIF.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
