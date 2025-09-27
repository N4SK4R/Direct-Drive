# Toolchain and paths
BIN_DIR := bin
CC := $(BIN_DIR)/arm-none-eabi-gcc
OBJDUMP := $(BIN_DIR)/arm-none-eabi-objdump
OBJCOPY := $(BIN_DIR)/arm-none-eabi-objcopy

# Files
TARGET := hello
ELF := $(TARGET).elf
BIN := $(TARGET).bin
DISASM := Debug.asm

C_SOURCES := $(wildcard *.c)
ASM_SOURCES := $(wildcard *.S)
SRCS := $(C_SOURCES) $(ASM_SOURCES)

# Flags
CFLAGS := -fno-common -O0 -mcpu=cortex-m3 -mthumb -g
LDFLAGS := -T link.ld -nostartfiles

# Docker & QEMU
DOCKER_IMAGE := qemu_stm32
QEMU := /usr/local/bin/qemu-system-arm
QEMU_ARGS := -M stm32-p103 -nographic -kernel $(BIN)

.PHONY: all  

all: $(ELF) $(BIN) $(DISASM)

$(ELF): $(SRCS) $(LINKER)
	$(CC) $(CFLAGS) $(LDFLAGS) $(SRCS) -o $@

$(BIN): $(ELF)
	$(OBJCOPY) -O binary $< $@

$(DISASM): $(ELF)
	$(OBJDUMP) -d -l $< > $@

run: $(BIN)
	docker run --rm -v $(CURDIR):/work -w /work $(DOCKER_IMAGE) $(QEMU) $(QEMU_ARGS)

debug: $(BIN)
	docker run --rm --network=host -v $(CURDIR):/work -w /work $(DOCKER_IMAGE) $(QEMU) $(QEMU_ARGS) -S -gdb tcp::1234

