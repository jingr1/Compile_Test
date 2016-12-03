DIR_OBJ = ..\products
DIR_SRC = ..\source
OBJCOPY=arm-none-eabi-objcopy
OBJDUMP=arm-none-eabi-objdump
GCC=arm-none-eabi-gcc
LD=arm-none-eabi-ld
ELF_FILE = $(DIR_OBJ)\test.elf
BIN_FILE = $(DIR_OBJ)\test.bin

#SRC = $(wildcard ${DIR_SRC}/*.cpp ${DIR_SRC}/head/*.cpp)  
#OBJ = $(patsubst %.cpp, ${DIR_OBJ}/%.o, $(notdir $(SRC)))   
#INC = $(patsubst %, -I%, $(shell find src -name '[a-zA-Z0-9]*'.h))  

#OBJCOPY= objcopy
#OBJDUMP= objdump
#GCC= D:\Program Files\mingw-w64\x86_64-4.9.2-posix-seh-rt_v4-rev2\mingw64\bin\gcc
#LD = ld

all: $(DIR_OBJ)\test.bin 
$(BIN_FILE): start.o main.o
	$(LD) -T fortest.lds -o $(ELF_FILE) start.o main.o
	$(OBJCOPY) -O binary $(ELF_FILE) $(BIN_FILE)
	$(OBJDUMP) -D $(ELF_FILE) > test.dis
start.o: $(DIR_SRC)\start.S
	$(GCC) -o start.o start.S -c
main.o: $(DIR_SRC)\main.c
	$(GCC) -o main.o $(DIR_SRC)\main.c -c
clean:
	rm *.o test.*

