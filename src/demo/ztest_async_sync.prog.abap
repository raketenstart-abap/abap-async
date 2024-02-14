*&---------------------------------------------------------------------*
*& Report ZTEST_ASYNC_SYNC
*&---------------------------------------------------------------------*
*& Test synchronous call
*&---------------------------------------------------------------------*
REPORT ztest_async_sync.

CLASS lcl DEFINITION
  CREATE PRIVATE.

  PUBLIC SECTION.
    CLASS-METHODS
      get_instance
        RETURNING VALUE(result) TYPE REF TO lcl.

    METHODS
      constructor
        IMPORTING io_async_test TYPE REF TO zif_async_test OPTIONAL.

    METHODS
      execute
        RAISING zcx_root.

  PRIVATE SECTION.
    DATA mo_async_test TYPE REF TO zif_async_test.

ENDCLASS.

CLASS lcl IMPLEMENTATION.

  METHOD get_instance.
    CREATE OBJECT result.
  ENDMETHOD.

  METHOD constructor.
    IF io_async_test IS BOUND.
      mo_async_test = io_async_test.
    ELSE.
      CREATE OBJECT mo_async_test TYPE zcl_async_test.
    ENDIF.
  ENDMETHOD.

  METHOD execute.
    TRY.
        DATA(ls_result) = mo_async_test->execute_sync( sy-uname ).
        WRITE / |Result was sent back to caller in synchronous|.

      CATCH zcx_async_task INTO DATA(lx_async_task).
        lx_async_task->raise_message( ).
    ENDTRY.
  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.
  lcl=>get_instance( )->execute( ).
