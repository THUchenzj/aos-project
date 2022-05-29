    .align 4
    .section .data
    .global _app_num
_app_num:
    .quad 9
    .quad app_0_start
    .quad app_1_start
    .quad app_2_start
    .quad app_3_start
    .quad app_4_start
    .quad app_5_start
    .quad app_6_start
    .quad app_7_start
    .quad app_8_start
    .quad app_8_end

    .global _app_names
_app_names:
   .string "ch5t_setprio"
   .string "ch5t_stride0"
   .string "ch5t_stride1"
   .string "ch5t_stride2"
   .string "ch5t_stride3"
   .string "ch5t_stride4"
   .string "ch5t_stride5"
   .string "ch5t_test_stride"
   .string "usershell"

    .global INIT_PROC
INIT_PROC:
    .string "usershell"

    .section .data.app0
    .global app_0_start
app_0_start:
    .incbin "./user/target/bin/ch5t_setprio"

    .section .data.app1
    .global app_1_start
app_1_start:
    .incbin "./user/target/bin/ch5t_stride0"

    .section .data.app2
    .global app_2_start
app_2_start:
    .incbin "./user/target/bin/ch5t_stride1"

    .section .data.app3
    .global app_3_start
app_3_start:
    .incbin "./user/target/bin/ch5t_stride2"

    .section .data.app4
    .global app_4_start
app_4_start:
    .incbin "./user/target/bin/ch5t_stride3"

    .section .data.app5
    .global app_5_start
app_5_start:
    .incbin "./user/target/bin/ch5t_stride4"

    .section .data.app6
    .global app_6_start
app_6_start:
    .incbin "./user/target/bin/ch5t_stride5"

    .section .data.app7
    .global app_7_start
app_7_start:
    .incbin "./user/target/bin/ch5t_test_stride"

    .section .data.app8
    .global app_8_start
app_8_start:
    .incbin "./user/target/bin/usershell"
app_8_end:

