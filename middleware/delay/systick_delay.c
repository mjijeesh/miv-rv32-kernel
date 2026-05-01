/*
 * hardware.c
 *
 *  Created on: 31-Jul-2020
 *      Author: jijeesh
 */

#ifdef USE_SYSTICK_DELAY

#include "delay/delay.h"
#include "hal/hal.h"
#include "miv_rv32_hal/miv_rv32_hal.h"


volatile uint32_t ticks;

volatile uint32_t g_10ms_count;

inline uint32_t millis (void);

volatile uint32_t g_state;
uint32_t gpio_pattern,g_gpio_pattern;

uint32_t timer1_load_value;



/* SysTick Interrupt Handler will count the number of milli seconds elapsed from the start ..
 *
 */
void SysTick_Handler (void)
 {
   ticks++;
   g_10ms_count += 10;

        /*
         * For neatness, if we roll over, reset cleanly back to 0 so the count
         * always goes up in proper 10s.
         */
       if(g_10ms_count < 10)
           g_10ms_count = 0;

 }


/* initialise the SystickTimer to generate an interrupt at every milli second.
 * Make sure this function is called in the hw_init() function before using any elay functions
 */

void CONFIG_Delay_Init (void)
{
    uint32_t systick_load;
       systick_load  = SYS_CLK_FREQ/1000 ;  // 1ms ticks

       /* configure the Systick to use the  SYS_CLK_FREQ */

       MRV_systick_config(systick_load);

}


// return the system clock as milliseconds
uint32_t millis (void)
{
   return ticks;
}


/* using the current tick count and the elapsed tick count
 * any delay can be generated ( milli second and greater)
 *
 */

void delay_ms (uint32_t t)
{
  uint32_t start, end;
  start = millis();
  end = start + t;


  if (start < end) {
  	while ((millis() >= start) && (millis() < end)) {
  	  // do nothing
  	}
  } else {
    while ((millis() >= start) || (millis() < end)) {
      // do nothing
    };
  }
}

#endif







