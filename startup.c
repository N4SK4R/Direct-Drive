#include <stdint.h>

extern void main(void);

/* End address for the stack. defined in linker script */
extern uint32_t _estack;
/* start address for the initialization values of the .data section in the flash */
extern uint32_t _sidata;
/* start address for the .data section*/
extern uint32_t _sdata;
/* end address for the .data section */
extern uint32_t _edata;

/* '&' used for linker symbols (Addresses) */

void reset_handler(void)
{
	/* Copy the data segment initializers from flash to SRAM */
	uint32_t *idata_begin = &_sidata;
	uint32_t *data_begin = &_sdata;
	uint32_t *data_end = &_edata;

	/* increments the pointer data_begin but returns the value of data_begin before it was incremented */
	while (data_begin < data_end) *data_begin++ = *idata_begin++;

	main();
}

__attribute((section(".isr_vector")))
uint32_t *isr_vectors[] = {
	(uint32_t *) &_estack,		// stack pointer
	(uint32_t *) reset_handler,	// code entry point 
};