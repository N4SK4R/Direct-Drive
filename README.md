# Direct-Drive
Bare-Metal Example on STM32F103
- [x] UART Driver to print to Serial Port
- [x] `.data` and `.bss` initialization
- [x] One Way Context Switch from User to Privilege mode
- [ ] MultiTasking
- [ ] Preemptive Scheduling
- [ ] User Threads (Basic `RTOS` kernel)


```bash
bin/arm-none-eabi-gcc -fno-common -O0 \
-mcpu=cortex-m3 -mthumb -g \
-T link.ld -nostartfiles hello.c startup.c -o hello.elf
```
* `-nostartfiles` Do **not use the default startup files** provided by GCC like `crt0.o`
* `-f no-common`  Tells the compiler **not to place uninitialized global variables in a common block**

To convert `.elf` to machine code 
```
bin/arm-none-eabi-objcopy -O binary hello.elf hello.bin
```

To Disassemble `.elf` to ARM instructions
```
bin/arm-none-eabi-objdump -S hello.elf > hello.list
```
To Execute on `Qemu` 
```
docker run --rm -v $(pwd):/work -w /work qemu_stm32 /usr/local/bin/qemu-system-arm -M stm32-p103 -nographic -kernel hello.bin
```

To Build 
```
make
```
