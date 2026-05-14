/*
 * FreeRTOS Kernel V10.3.0
 * Copyright (C) 2020 Amazon.com, Inc. or its affiliates.  All Rights Reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * http://www.FreeRTOS.org
 * http://aws.amazon.com/freertos
 *
 * 1 tab == 4 spaces!
 */

/******************************************************************************
 * This project provides two demo applications.  A simple blinky style project,
 * and a more comprehensive test and demo application.  The
 * mainCREATE_SIMPLE_BLINKY_DEMO_ONLY setting (defined in this file) is used to
 * select between the two.  The simply blinky demo is implemented and described
 * in main_blinky.c.  The more comprehensive test and demo application is
 * implemented and described in main_full.c.
 *
 * This file implements the code that is not demo specific, including the
 * hardware setup and standard FreeRTOS hook functions.
 *
 * ENSURE TO READ THE DOCUMENTATION PAGE FOR THIS PORT AND DEMO APPLICATION ON
 * THE http://www.FreeRTOS.org WEB SITE FOR FULL INFORMATION ON USING THIS DEMO
 * APPLICATION, AND ITS ASSOCIATE FreeRTOS ARCHITECTURE PORT!
 *
 */

/*
 * Modified for the NEORV32 processor by Stephan Nolting.
 */

/* UART hardware constants. */
#define BAUD_RATE 115200



#include <stdint.h>

/* FreeRTOS kernel includes. */
#include <FreeRTOS.h>
#include <semphr.h>
#include <queue.h>
#include <task.h>


/* Microchip includes. */
#include "fpga_design_config/fpga_design_config.h"
#include "drivers/fpga_ip/CoreUARTapb/core_uart_apb.h"
#include "drivers/fpga_ip/CoreGPIO/core_gpio.h"



extern void freertos_risc_v_trap_handler( void );


void vApplicationTickHook( void );
void vApplicationStackOverflowHook( TaskHandle_t pxTask, char *pcTaskName );
void vApplicationIdleHook( void );
void vApplicationMallocFailedHook( void );



/* Prepare hardware to run the demo. */
static void prvSetupHardware( void );


void vSendString( const char * pcString );

void led_task_handler ( void *params);
void uart_task_handler ( void *params);



/*-----------------------------------------------------------*/


extern UART_instance_t   g_uart;
extern gpio_instance_t  g_gpio_out;

int main_vtaskCreate( void )
{

    vSendString(" \r\nFree RTOS  VtaskCreate() Example ");
    //vSendString(" \r\n Prees 's' to start the Task, 't' to stop ");
    //vSendString(" \r\n----------------------------------------------- ");

       xTaskCreate(led_task_handler, "LED-Task",configMINIMAL_STACK_SIZE,NULL,2, NULL);
       xTaskCreate(uart_task_handler, "UART-Task",configMINIMAL_STACK_SIZE,NULL,2, NULL);


       vTaskStartScheduler();



          for (;;)
          {

          }



}

/*-----------------------------------------------------------*/


void led_task_handler ( void *params)
{
    uint8_t gpio_pattern;

    while(1){

         gpio_pattern = GPIO_get_outputs(&g_gpio_out);
         gpio_pattern ^= 0x00000001;
         GPIO_set_outputs( &g_gpio_out, gpio_pattern );
         vTaskDelay(500);

         }


}

void uart_task_handler ( void *params)
{

      while(1) {
          vSendString(" \r\n Blink...");
               }
}








