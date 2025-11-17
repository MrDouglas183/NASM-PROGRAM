;采用NASM + gcc编译: nasm  -f win64 pro.asm -o pro.o // gcc pro.o -o pro.exe
default rel                                     ;windows标准相对内存

section .data                                   ;变量标签段
    msg db 'The number is %d', 0Ah, 0           ;字符串常量定义
    num dq 0                                    ;要输出的数字
    looper dq 0                                 ;计数器初始化值(0)

section .text                                   ;代码段
    global main                                 ;公开导出main()
    extern printf                               ;外部导入printf(C标准库)

main:                                           ;main()具体定义
    sub rsp, 32                                 ;压栈

    mov rbx, [looper]                           ;将循环计数器赋值给通用寄存器rbx

    call looplab                                ;调用循环函数

    add rsp, 32                                 ;释放栈
    xor rax, rax                                ;清空rax保证正常返回(return 0)
    ret                                         ;返回

looplab:                                        ;循环函数定义
    mov rcx, msg                                ;读取msg至rcx寄存器(第一参)
    mov rdx, [num]                              ;读取num变量至rdx(第二参)

    call printf                                 ;调用printf函数打印

    add [num], 1                                ;num自增

    add rbx, 1                                  ;计数器自增
    cmp rbx, 10                                 ;比较rbx的值与10
    jb looplab                                  ;若rbx<10,则跳回函数开头重新执行,若rbx>=10,则执行后面的代码

    ret                                         ;返回