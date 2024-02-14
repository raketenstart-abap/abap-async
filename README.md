# abap-async
ABAP Async Handler

- **Dependencies**

| Package           | Version  | Repository                                      |
| :---------------- | :------: | :---------------------------------------------: |
| abap-core         |   1.0.0  | https://github.com/raketenstart-abap/abap-core  |

- **Demonstration and test programs**

| Report            | Version  | Description                                     |
| :---------------- | :------: | :---------------------------------------------: |
| ZTEST_ASYNC_SYNC  |   1.0.1  | Runs a function module on `synchronous mode`    |
| ZTEST_ASYNC_ASYNC |   1.0.1  | Runs a function module on `asynchronous mode`   |

When starting on any new development, it is essential to utilize the `ZCL_ASYNC_TEST` object class as support. Below are crucial considerations as you proceed with coding your own class:

- **Integration of MO_ASYNC_TASK:** Ensure that the member object `MO_ASYNC_TASK` is seamlessly integrated into your class structure by deriving from `ZCL_ASYNC_TASK`.
- **Enable Remote Call for Function Modules:** It is necessary to enable remote call functionality for all function modules involved in your implementation.
- **Receive Results Methodology:** In synchronous mode, implementing a receive results method is indispensable to handle and process outcomes. <br />
  Conversely, in asynchronous mode, the need for a receive results method is avoided. However, it is prudent to handle asynchronous responses efficiently within the asynchronous task framework.
- **Embrace Interfaces for Flexibility:** Adhere to SOLID principles, particularly emphasizing the use of interfaces. <br />
  Interfaces promote flexibility, scalability, and maintainability in your codebase. They enable clear separation of concerns and facilitate seamless integration of various components within the system.

By adhering to these guidelines, you can ensure the robustness, flexibility, and efficiency of your class implementation, thereby fostering a more streamlined and maintainable development process.
