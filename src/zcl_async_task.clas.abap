CLASS zcl_async_task DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS assign_task_results
      IMPORTING
        !id_task_results TYPE REF TO data .
    METHODS check_task_failure
      RAISING
        zcx_async_task .
    METHODS complete_task .
    METHODS constructor
      IMPORTING
        !it_bapiret TYPE bapirettab OPTIONAL .
    METHODS is_task_complete
      RETURNING
        VALUE(result) TYPE abap_bool .
    METHODS register_task_return
      IMPORTING
        !is_syst      TYPE syst
      RETURNING
        VALUE(result) TYPE bapirettab .
    METHODS save_task_results
      IMPORTING
        VALUE(id_task_results) TYPE REF TO data .
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA mv_task_complete TYPE abap_bool VALUE abap_false ##NO_TEXT.
    DATA md_task_results TYPE REF TO data .
    DATA mt_bapiret TYPE bapirettab .
ENDCLASS.



CLASS ZCL_ASYNC_TASK IMPLEMENTATION.


  METHOD assign_task_results.

    FIELD-SYMBOLS: <fs_input>  TYPE any,
                   <fs_member> TYPE any.

    CHECK md_task_results IS NOT INITIAL.

    ASSIGN md_task_results->* TO <fs_member>.
    ASSIGN id_task_results->* TO <fs_input>.

    <fs_input> = <fs_member>.

  ENDMETHOD.


  METHOD check_task_failure.

    CHECK mt_bapiret IS NOT INITIAL AND is_task_complete( ) = abap_true.

    RAISE EXCEPTION TYPE zcx_async_task
      EXPORTING
        mt_bapiret = mt_bapiret.

  ENDMETHOD.


  METHOD complete_task.

    mv_task_complete = abap_true.

  ENDMETHOD.


  METHOD constructor.

    mt_bapiret = it_bapiret.

  ENDMETHOD.


  METHOD is_task_complete.

    result = mv_task_complete.

  ENDMETHOD.


  METHOD register_task_return.

    DATA: lv_original_message TYPE string,
          lv_task_message     TYPE string,
          ls_bapiret          TYPE bapiret2.

    IF is_syst-msgid IS NOT INITIAL AND
       is_syst-msgty IS NOT INITIAL AND
       is_syst-msgno IS NOT INITIAL.
      MESSAGE ID     is_syst-msgid
              TYPE   is_syst-msgty
              NUMBER is_syst-msgno
              WITH   is_syst-msgv1 is_syst-msgv2 is_syst-msgv3 is_syst-msgv4
              INTO   lv_original_message.

      ls_bapiret = zcl_core_bapiret_utils=>build_bapiret( lv_original_message ).
      APPEND ls_bapiret TO mt_bapiret.
    ENDIF.

    CASE is_syst-subrc.
      WHEN 1.
        MESSAGE e000(zabap_async)
          INTO lv_task_message.
      WHEN 2.
        MESSAGE e001(zabap_async)
          INTO lv_task_message.
      WHEN OTHERS.
        MESSAGE e002(zabap_async)
          INTO lv_task_message.
    ENDCASE.

    ls_bapiret = zcl_core_bapiret_utils=>build_bapiret( lv_task_message ).
    APPEND ls_bapiret TO mt_bapiret.

    result = mt_bapiret.

  ENDMETHOD.


  METHOD save_task_results.

    FIELD-SYMBOLS: <fs_input>  TYPE any,
                   <fs_member> TYPE any.

    ASSIGN id_task_results->* TO <fs_input>.
    CREATE DATA md_task_results LIKE <fs_input>.

    ASSIGN md_task_results->* TO <fs_member>.
    <fs_member> = <fs_input>.

  ENDMETHOD.
ENDCLASS.
