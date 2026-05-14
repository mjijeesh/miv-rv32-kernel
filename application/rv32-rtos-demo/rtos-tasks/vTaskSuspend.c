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



#define mainQUEUE_LENGTH                    ( 1 )

extern void freertos_risc_v_trap_handler( void );


void vSendString( const char * pcString );

static void led_task_handler ( void *params);
static void uart_tx_task_handler ( void *params);
static void uart_rx_task_handler ( void *params);

static void prvSendBuffer( const char * pcBuffer, size_t xBufferLength );
static uint8_t xUART_Rxchar (void);



static QueueHandle_t uartQueue = NULL;

static TaskHandle_t xHandle_ToggleLED = NULL;

/*-----------------------------------------------------------*/


extern UART_instance_t   g_uart;
extern gpio_instance_t  g_gpio_out;

int main_vTaskSuspend_Resume( void )
{

    vSendString(" \r\nFreeRTOS  VTaskSuspen and vTaskResume Demo \r\n ");
    vSendString(" \r\n Prees 's' to start the Task, 't' to stop ");
    vSendString(" \r\n----------------------------------------------- ");


    /* Create the queue. */
        uartQueue = xQueueCreate( mainQUEUE_LENGTH, sizeof( uint8_t ) );


        if( uartQueue != NULL ){
              xTaskCreate(led_task_handler, "LED-Task",configMINIMAL_STACK_SIZE,NULL,2, &xHandle_ToggleLED);
              xTaskCreate(uart_tx_task_handler, "UART-Task-tx",configMINIMAL_STACK_SIZE,NULL,2, NULL);
              xTaskCreate(uart_rx_task_handler, "UART-Task-rx",configMINIMAL_STACK_SIZE,NULL,2, NULL);

              vTaskStartScheduler();


        }

          for (;;)
          {

          }



}

/*-----------------------------------------------------------*/


static void led_task_handler ( void *params)
{
    uint8_t gpio_pattern;

    while(1){

         gpio_pattern = GPIO_get_outputs(&g_gpio_out);
         gpio_pattern ^= 0x00000001;
         GPIO_set_outputs( &g_gpio_out, gpio_pattern );
         vTaskDelay(500);

         }


}

void uart_tx_task_handler ( void *params)
{
    char ulReceivedValue;
    const char * const pcStartMessage = "\r\n LED blinky task started.\r\n";
    const char * const pcStopMessage = "\r\n LED blinky task Stopped.\r\n";
    const char * const pcFailMessage = "\r\n Unsupported command received\r\n";


    for( ;; ){


        /* wait for the  mesage fro mthe Queue */
        xQueueReceive( uartQueue, &ulReceivedValue, portMAX_DELAY );

        /* Echo the character back. */
        prvSendBuffer( &ulReceivedValue, sizeof( ulReceivedValue ) );

        /* resume the led toggle task */
        if (ulReceivedValue == 's' ){

            vTaskResume(xHandle_ToggleLED); // Replace NULL with the LED blinky task handle if necessary
            vSendString( pcStartMessage );
        }
        /* suspend the LED toggle Task */
        else if  (ulReceivedValue == 't' ){

            vTaskSuspend(xHandle_ToggleLED); // Replace NULL with the LED blinky task handle if necessary
            vSendString( pcStopMessage );
        }
        else{

           /* non supported command */
          vSendString( pcFailMessage );
        }
    }
}


static void uart_rx_task_handler ( void *params)

{
    uint8_t receivedChar;

    while(1){

    /* read the char from uart */
    receivedChar = xUART_Rxchar();

       // Send the command string to the UART queue
      xQueueSend(uartQueue, &receivedChar, portMAX_DELAY);

      // Delay for a short time to avoid high CPU usage
      vTaskDelay(pdMS_TO_TICKS(10));
}

}




static void prvSendBuffer( const char * pcBuffer, size_t xBufferLength )
{
    if( xBufferLength > 0 )
    {

        UART_send ( &g_uart, ( uint8_t * ) pcBuffer, xBufferLength);


    }
}


/* get the character from the uART */


static uint8_t xUART_Rxchar (void) {
    uint8_t rx_size=0;
    uint8_t rx_buff;

      do {
    rx_size = UART_get_rx(&g_uart, &rx_buff, sizeof(rx_buff));

      }while ( rx_size < 1);

    return rx_buff;
}








