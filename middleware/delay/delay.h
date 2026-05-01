/*
 * delay.h
 *
 *  Created on: 26-Aug-2020
 *      Author: jijeesh
 */

#ifndef DELAY_H_
#define DELAY_H_

#include "fpga_design_config/fpga_design_config.h"
#include <drivers/fpga_ip/CoreTimer/core_timer.h>

void CONFIG_Delay_Init (void);
void delay_ms (uint32_t t);



#endif /* DELAY_H_ */
