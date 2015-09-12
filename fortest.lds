ENTRY(_start)
SECTIONS
{
	. = 0x50000000;  /*链接地址:程序的运行地址*/
	. = ALIGN(4);
	.text : {
		start.o
		* (.text)   /*所有文件的代码段*/
	}
    		
	.data : {
		* (.data)	/*所有文件的数据段*/
	}
	
	bss_start = .;	/*. 表示当前地址*/
	.bss : {
		* (.bss)
	}
	bss_end  = .;	/*程序启动前要将bss段清零*/
}
