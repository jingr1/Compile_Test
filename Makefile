test.bin: start.o main.o
	arm-linux-ld -T fortest.lds -o test.elf start.o main.o
	arm-linux-objcopy -O binary test.elf test.bin
	arm-linux-objdump -D test.elf > test.dis
start.o: start.S
	arm-linux-gcc -o start.o start.S -c
main.o: main.c
	arm-linux-gcc -o main.o main.c -c
clean:
	rm *.o test.*

