
OBJCOPY=arm-none-eabi-objcopy
OBJDUMP=arm-none-eabi-objdump
GCC=arm-none-eabi-gcc
LD=arm-none-eabi-ld

#OBJCOPY= objcopy
#OBJDUMP= objdump
#GCC= D:\Program Files\mingw-w64\x86_64-4.9.2-posix-seh-rt_v4-rev2\mingw64\bin\gcc
#LD = ld

all: test.bin 
test.bin: start.o main.o
	$(LD) -T fortest.lds -o test.elf start.o main.o
	$(OBJCOPY) -O binary test.elf test.bin
	$(OBJDUMP) -D test.elf > test.dis
start.o: start.S
	$(GCC) -o start.o start.S -c
main.o: main.c
	$(GCC) -o main.o main.c -c
clean:
	rm *.o test.*

