/*
 * hardware.c
 *
 *  Created on: 31-Jul-2020
 *      Author: jijeesh
 */


#ifdef USE_TIMER_DELAY

#include "delay.h"



volatile uint32_t ticks;

volatile uint32_t g_10ms_count;

inline uint32_t millis (void);

//extern timer_instance_t g_timer_0;
timer_instance_t  g_timer_0;


// return the system clock as milliseconds
uint32_t millis (void)
{
   //return ticks;
}


/* using the current tick count and the elapsed tick count
 * any delay can be generated ( milli second and greater)
 *
 */

/* delay_ms using the timer_0 */

void delay_ms ( uint32_t val){
    uint32_t timer_load_value , timer_1ms_value;
    uint32_t timer_curr_val;

    timer_1ms_value= SYS_CLK_FREQ /2000 ;  //  timer clock is  SYS_CLK_FREQ/2

    timer_load_value  = timer_1ms_value * val;
    TMR_reload(&g_timer_0,timer_load_value);
    TMR_start(&g_timer_0);

       // keep in the loop till timeout;
         do {
           timer_curr_val =  TMR_current_value(&g_timer_0);
         } while (timer_curr_val > 0);

}



void CONFIG_Delay_Init (void)
{
      TMR_init(&g_timer_0,
      CORETIMER0_BASE_ADDR,
      TMR_ONE_SHOT_MODE,
      PRESCALER_DIV_2,
      2560);

}

#endif




