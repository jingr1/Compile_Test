DIR_OBJ = ../products
DIR_SRC = ../source
DIR_BUILD = .
OBJCOPY=arm-none-eabi-objcopy
OBJDUMP=arm-none-eabi-objdump
GCC=arm-none-eabi-gcc
LD=arm-none-eabi-ld
ELF_FILE = $(DIR_OBJ)/test.elf
BIN_FILE = $(DIR_OBJ)/test.bin
DIS_FILE = $(DIR_OBJ)/test.dis
LIBS=$(DIR_BUILD)/fortest.lds
LIBSPEC=-L D:\cygwin64\lib

SRC := $(wildcard ${DIR_SRC}/*.c) 
OBJ := $(patsubst %.c, ${DIR_OBJ}/%.o, $(notdir ${SRC}))
SRC+=  $(wildcard ${DIR_SRC}/*.S)
OBJ+= ${DIR_OBJ}/start.o
INC = $(patsubst %, -I%, $(shell find ${SRC} -name '[a-zA-Z0-9]*'.h))  

CFLAGS = -g -Wall $(INC) 
#OBJCOPY= objcopy
#OBJDUMP= objdump
#GCC= D:\Program Files\mingw-w64\x86_64-4.9.2-posix-seh-rt_v4-rev2\mingw64\bin\gcc
#LD = ld

all: $(BIN_FILE)
${BIN_FILE}: ${OBJ}
	@echo $(SRC)
	@echo $(OBJ)
	rm -f ${DIR_OBJ}/*.map
	$(LD) $(LIBSPEC) -T${LIBS} -o $(ELF_FILE) -Map ${DIR_OBJ}/test.map  ${OBJ} -lc
	$(OBJCOPY) -O binary $(ELF_FILE) $(BIN_FILE)
	$(OBJDUMP) -D $(ELF_FILE) > $(DIS_FILE)
	
${DIR_OBJ}/%.o: ${DIR_SRC}/%.c
	$(GCC) $(CFLAGS) -c $< -o $@

${DIR_OBJ}/%.o: ${DIR_SRC}/%.S
	$(GCC) $(CFLAGS) -c $< -o $@
	
clean:
	rm $(DIR_OBJ)/test.*

