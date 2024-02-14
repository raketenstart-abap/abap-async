CLASS zcl_async_test DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_async_test .

    METHODS receive_results_sync
      IMPORTING
        !p_task TYPE clike .
protected section.
PRIVATE SECTION.

  DATA mo_async_task TYPE REF TO zcl_async_task .
  CONSTANTS BEGIN OF sc_task_name .
  CONSTANTS bapi_user_get_detail TYPE string VALUE 'BAPI_USER_GET_DETAIL'.
  CONSTANTS END OF sc_task_name.
ENDCLASS.



CLASS ZCL_ASYNC_TEST IMPLEMENTATION.


  METHOD receive_results_sync.

    DATA result          TYPE zst_async_test_callback.
    DATA ld_task_results TYPE REF TO data.

    RECEIVE RESULTS FROM FUNCTION 'BAPI_USER_GET_DETAIL'
      IMPORTING
        logondata = result-logondata
        company   = result-company
        identity  = result-identity
        admindata = result-admindata
      EXCEPTIONS
        communication_failure = 1
        system_failure        = 2
        OTHERS                = 4.

    IF sy-subrc <> 0.
      mo_async_task->register_task_return( sy ).
    ENDIF.

    GET REFERENCE OF result INTO ld_task_results.
    mo_async_task->save_task_results( ld_task_results ).

    mo_async_task->complete_task( ).

  ENDMETHOD.


  METHOD zif_async_test~execute_async.

    CREATE OBJECT mo_async_task.

    CALL FUNCTION 'BAPI_USER_GET_DETAIL'
      STARTING NEW TASK sc_task_name-bapi_user_get_detail
      EXPORTING
        username              = username
        cache_results         = abap_true
      EXCEPTIONS
        communication_failure = 1
        system_failure        = 2
        OTHERS                = 4.

    IF sy-subrc <> 0.
      mo_async_task->register_task_return( sy ).
    ENDIF.

    WAIT FOR ASYNCHRONOUS TASKS UNTIL mo_async_task->is_task_complete( ) = abap_true.

    mo_async_task->check_task_failure( ).

    FREE mo_async_task.

  ENDMETHOD.


  METHOD zif_async_test~execute_sync.

    DATA ld_task_results TYPE REF TO data.

    CREATE OBJECT mo_async_task.

    CALL FUNCTION 'BAPI_USER_GET_DETAIL'
      STARTING NEW TASK sc_task_name-bapi_user_get_detail
      CALLING receive_results_sync ON END OF TASK
      EXPORTING
        username              = username
        cache_results         = abap_true
      EXCEPTIONS
        communication_failure = 1
        system_failure        = 2
        OTHERS                = 4.

    IF sy-subrc <> 0.
      mo_async_task->register_task_return( sy ).
    ENDIF.

    WAIT FOR ASYNCHRONOUS TASKS UNTIL mo_async_task->is_task_complete( ) = abap_true.

    mo_async_task->check_task_failure( ).

    GET REFERENCE OF result INTO ld_task_results.
    mo_async_task->assign_task_results( ld_task_results ).

    FREE mo_async_task.

  ENDMETHOD.
ENDCLASS.
