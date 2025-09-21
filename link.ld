ENTRY(reset_handler)

MEMORY
{
	FLASH (rx) : ORIGIN = 0x00000000, LENGTH = 128K
	RAM (rwx)  : ORIGIN = 0x20000000, LENGTH = 20K
}

_estack = ORIGIN(RAM) + LENGTH(RAM);

SECTIONS
{
	.text :
	{
		KEEP(*(.isr_vector))
		*(.text)
		*(.rodata)
		_sidata = .;
	} >FLASH

	.data : 
   {
	_sdata = .;
    *(.data*)               /* initialized data */
	_edata = .;
   } > RAM AT > FLASH       
}