.global _start
_start:

/*硬件相关的设置：把外设的基地址告诉CPU*/
#define REG32 0x70000000 /*外设基地址*/
ldr r0, =REG32
orr r0, r0, #0x13 /*256M(0x70000000-0x7fffffff)*/
mcr p15, 0, r0, c15, c2, 4

/*关看门狗*/
#define WATCHDOG 0x7E004000
ldr r0, =WATCHDOG
mov r1, #0
str r1, [r0]
/*重定位*/
adr r0, _start      /*_start当前指令地址：加载地址 SRAM 0*/
ldr r1, = _start    /*_start的链接地址：运行地址 0x50000000*/
ldr r2, = bss_start
cmp r0, r1
beq clean_bss

copy_loop:
ldr r3, [r0], #4
str r3, [r1], #4
cmp r1, r2
bne copy_loop

/*清BSS段*/
clean_bss:
ldr r0, =bss_start
ldr r1, =bss_end
mov r2, #0
cmp r0, r1
beq clean_done

clean_loop:
str r2, [r0], #4
cmp r0, r1
bne clean_loop

clean_done:


/*初始化栈,将8K的SRAM映射到0地址处*/
ldr sp, =8*1024
ldr pc, =main /*重定位之后要使用位置相关码跳转*/
/*bl main*/

halt:
b halt
