#include <stdint.h>
#include "reg.h"

#define USART_FLAG_TXE	((uint16_t) 0x0080)
void activate(unsigned int *stack);

int puts(const char *str)
{
	while (*str) {
		while (!(*(USART2_SR) & USART_FLAG_TXE));
		*(USART2_DR) = *str++ & 0xFF;
	}
	return 0;
}

void usertask(void)
{
	puts("User Task \n");
	while (1); /* Never terminate the task */
}

void main(void)
{
	*(RCC_APB2ENR) |= (uint32_t) (0x00000001 | 0x00000004);
	*(RCC_APB1ENR) |= (uint32_t) (0x00020000);

	/* USART2 Configuration */
	*(GPIOA_CRL) = 0x00004B00;
	*(GPIOA_CRH) = 0x44444444;

	*(USART2_CR1) = 0x0000000C;
	*(USART2_CR1) |= 0x2000;


	unsigned int usertask_stack[20];
	/* 9 words from bottom to store Initial User State ( 9 registers ) */  
	unsigned int *usertask_stack_start = usertask_stack + 20 - 9; 
	/* Last(9th) word would load lr Register */
	usertask_stack_start[8] = (unsigned int) &usertask;

	activate(usertask_stack_start);

	while (1);
}