CLASS zcl_sl_time_machine DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zcl_sl_time_machine IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    DATA(lv_target_trans_id) = '003'.

    DATA(lv_today) = cl_abap_context_info=>get_system_date( ).
    DATA(lv_past_checkout) = lv_today - 20.
    DATA(lv_past_due)      = lv_today - 6.


    UPDATE zsl_checkouts
      SET checkout_date = @lv_past_checkout,
          due_date      = @lv_past_due
      WHERE trans_id = @lv_target_trans_id.

    IF sy-subrc = 0.
      COMMIT WORK.
      out->write( |SUCCESS: Time travel complete! Transaction { lv_target_trans_id } is now 6 days OVERDUE!| ).
    ELSE.
      out->write( |ERROR: Could not find Transaction { lv_target_trans_id } in the database. Check the ID!| ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
