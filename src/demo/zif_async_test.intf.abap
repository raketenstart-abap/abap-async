interface ZIF_ASYNC_TEST
  public .


  methods EXECUTE_ASYNC
    importing
      !USERNAME type XUBNAME
    raising
      ZCX_ASYNC_TASK .
  methods EXECUTE_SYNC
    importing
      !USERNAME type XUBNAME
    returning
      value(RESULT) type ZST_ASYNC_TEST_CALLBACK
    raising
      ZCX_ASYNC_TASK .
endinterface.
