/*
 * misc.c
 *
 *  Created on: 30-Jul-2020
 *      Author: jijeesh
 */



#include "fpga_design_config/fpga_design_config.h"
#include <string.h>
#include <stdarg.h>

#include "uart_stdio.h"

#ifdef CONFIG_USE_SPI_FLASH
#include "middleware/spi_flash/spi_flash.h"
#endif


#ifdef MSS_UART_PRINT
#include "drivers/mss_ip/mss_uart/mss_uart.h"


static mss_uart_instance_t * g_uart_ptr = BOARD_UART ;


//#define  polled_tx_string(text)  MSS_UART_polled_tx_string(g_uart,text)
//#define  polled_tx_chars(text,text_size)  MSS_UART_polled_tx(g_uart,text,text_size)

#define  UART_polled_tx_string(g_uart_inst,text)  MSS_UART_polled_tx_string(g_uart_ptr,text)
#define  UART_get_rx(g_uart_inst,rx_buff, rx_size)  MSS_UART_get_rx(g_uart_ptr, rx_buff, rx_size);
#define  UART_send(g_uart_inst,txbyte, size); MSS_UART_polled_tx(g_uart_ptr, txbyte, size);

#else
#ifdef  CORE_UART_PRINT

#include "drivers/fpga_ip/CoreUARTapb/core_uart_apb.h"
extern UART_instance_t g_uart;

#endif

#endif





/* this has to be declared in the main.c
 *
 * mss_uart_instance_t * const g_uart  =  &g_mss_uart0 ;
 * */
extern UART_instance_t g_uart;

/// \cond
// Private functions
static void uart_itoa(uint32_t x, char *res) __attribute__((unused)); // GCC: do not output a warning when this variable is unused
static void uart_tohex(uint32_t x, char *res) __attribute__((unused)); // GCC: do not output a warning when this variable is unused
static void uart_touppercase(uint32_t len, char *ptr) __attribute__((unused)); // GCC: do not output a warning when this variable is unused
/// \endcond


extern UART_instance_t g_uart;

// #################################################################################################
// Override default STDIO functions
// #################################################################################################

/**********************************************************************//**
 * Send char via UART0
 *
 * @param[in] Char to be send.
 * @return Char that has been sent.
 **************************************************************************/
int putchar(int ch) {

  uart0_putc((char)ch);

  return ch;
}


/**********************************************************************//**
 * Read char from UART0.
 *
 * @return Read char.
 **************************************************************************/
int getchar(void) {

  return (int)uart0_getc();
}


// #################################################################################################
// Primary UART (UART0)
// #################################################################################################

/**********************************************************************//**
 * Check if UART0 unit was synthesized.
 *
 * @return 0 if UART0 was not synthesized, 1 if UART0 is available.
 **************************************************************************/

/*
int neorv32_uart0_available(void) {

  if (NEORV32_SYSINFO.SOC & (1 << SYSINFO_SOC_IO_UART0)) {
    return 1;
  }
  else {
    return 0;
  }
}
*/




/**********************************************************************//**
 * Send single char via UART0.
 *
 * @note This function is blocking.
 *
 * @param[in] c Char to be send.
 **************************************************************************/
void uart0_putc(char c) {

  UART_send(&g_uart, &c, sizeof(c));
}



/**********************************************************************//**
 * Get char from UART0.
 *
 * @note This function is blocking and does not check for UART frame/parity errors.
 *
 * @return Received char.
 **************************************************************************/
char uart0_getc(void) {


  uint8_t rx_size=0;
      uint8_t rx_buff;

        do {
      rx_size = UART_get_rx(&g_uart, &rx_buff, sizeof(rx_buff));

        }while ( rx_size < 1);


      return (char)rx_buff;



}




/**********************************************************************//**
 * Print string (zero-terminated) via UART0. Print full line break "\r\n" for every '\n'.
 *
 * @note This function is blocking.
 *
 * @param[in] s Pointer to string.
 **************************************************************************/
void uart0_print(const char *s) {

  char c = 0;
  while ((c = *s++)) {
    if (c == '\n') {
      uart0_putc('\r');
    }
    uart0_putc(c);
  }
}


/**********************************************************************//**
 * Custom version of 'printf' function using UART0.
 *
 * @note This function is blocking.
 *
 * @param[in] format Pointer to format string.
 *
 * <TABLE>
 * <TR><TD>%s</TD><TD>String (array of chars, zero-terminated)</TD></TR>
 * <TR><TD>%c</TD><TD>Single char</TD></TR>
 * <TR><TD>%d/%i</TD><TD>32-bit signed number, printed as decimal</TD></TR>
 * <TR><TD>%u</TD><TD>32-bit unsigned number, printed as decimal</TD></TR>
 * <TR><TD>%x</TD><TD>32-bit number, printed as 8-char hexadecimal - lower-case</TD></TR>
 * <TR><TD>%X</TD><TD>32-bit number, printed as 8-char hexadecimal - upper-case</TD></TR>
 * <TR><TD>%p</TD><TD>32-bit pointer, printed as 8-char hexadecimal - lower-case</TD></TR>
 * </TABLE>
 **************************************************************************/
void uart0_printf(const char *format, ...) {

  char c, string_buf[11];
  int32_t n;

  va_list a;
  va_start(a, format);

  while ((c = *format++)) {
    if (c == '%') {
      c = *format++;
      switch (c) {
        case 's': // string
          uart0_print(va_arg(a, char*));
          break;
        case 'c': // char
          uart0_putc((char)va_arg(a, int));
          break;
        case 'i': // 32-bit signed
        case 'd':
          n = (int32_t)va_arg(a, int32_t);
          if (n < 0) {
            n = -n;
            uart0_putc('-');
          }
          uart_itoa((uint32_t)n, string_buf);
          uart0_print(string_buf);
          break;
        case 'u': // 32-bit unsigned
          uart_itoa(va_arg(a, uint32_t), string_buf);
          uart0_print(string_buf);
          break;
        case 'x': // 32-bit hexadecimal
        case 'p':
        case 'X':
          uart_tohex(va_arg(a, uint32_t), string_buf);
          if (c == 'X') {
            uart_touppercase(11, string_buf);
          }
          uart0_print(string_buf);
          break;
        default: // unsupported format
          uart0_putc('%');
          uart0_putc(c);
          break;
      }
    }
    else {
      if (c == '\n') {
        uart0_putc('\r');
      }
      uart0_putc(c);
    }
  }
  va_end(a);
}


/**********************************************************************//**
 * Simplified custom version of 'scanf' function for UART0.
 *
 * @note This function is blocking.
 *
 * @param[in,out] buffer Pointer to array of chars to store string.
 * @param[in] max_size Maximum number of chars to sample.
 * @param[in] echo Echo UART input when 1.
 * @return Number of chars read.
 **************************************************************************/
int uart0_scan(char *buffer, int max_size, int echo) {

  char c = 0;
  int length = 0;

  while (1) {
    c = uart0_getc();
    if (c == '\b') { // BACKSPACE
      if (length != 0) {
        if (echo) {
          uart0_print("\b \b"); // delete last char in console
        }
        buffer--;
        length--;
      }
    }
    else if (c == '\r') // carriage return
      break;
    else if ((c >= ' ') && (c <= '~') && (length < (max_size-1))) {
      if (echo) {
        uart0_putc(c); // echo
      }
      *buffer++ = c;
      length++;
    }
  }
  *buffer = '\0'; // terminate string

  return length;
}






// #################################################################################################
// Shared functions
// #################################################################################################

/**********************************************************************//**
 * Private function for 'neorv32_printf' to convert into decimal.
 *
 * @param[in] x Unsigned input number.
 * @param[in,out] res Pointer for storing the reuslting number string (11 chars).
 **************************************************************************/
static void uart_itoa(uint32_t x, char *res) {

  static const char numbers[] = "0123456789";
  char buffer1[11];
  uint16_t i, j;

  buffer1[10] = '\0';
  res[10] = '\0';

  // convert
  for (i=0; i<10; i++) {
    buffer1[i] = numbers[x%10];
    x /= 10;
  }

  // delete 'leading' zeros
  for (i=9; i!=0; i--) {
    if (buffer1[i] == '0')
      buffer1[i] = '\0';
    else
      break;
  }

  // reverse
  j = 0;
  do {
    if (buffer1[i] != '\0')
      res[j++] = buffer1[i];
  } while (i--);

  res[j] = '\0'; // terminate result string
}


/**********************************************************************//**
 * Private function for 'neorv32_printf' to convert into hexadecimal.
 *
 * @param[in] x Unsigned input number.
 * @param[in,out] res Pointer for storing the resulting number string (9 chars).
 **************************************************************************/
static void uart_tohex(uint32_t x, char *res) {

  static const char symbols[] = "0123456789abcdef";

  int i;
  for (i=0; i<8; i++) { // nibble by nibble
    uint32_t num_tmp = x >> (4*i);
    res[7-i] = (char)symbols[num_tmp & 0x0f];
  }

  res[8] = '\0'; // terminate result string
}


/**********************************************************************//**
 * Private function to cast a string to UPPERCASE.
 *
 * @param[in] len Total length of input string.
 * @param[in,out] ptr Pointer for input/output string.
 **************************************************************************/
static void uart_touppercase(uint32_t len, char *ptr) {

  char tmp;

  while (len > 0) {
    tmp = *ptr;
    if ((tmp >= 'a') && (tmp <= 'z')) {
      *ptr = tmp - 32;
    }
    ptr++;
    len--;
  }
}






uint8_t uart_getchar () {
	uint8_t rx_size=0;
	uint8_t rx_buff;

	  do {
	rx_size = UART_get_rx(&g_uart, &rx_buff, sizeof(rx_buff));

	  }while ( rx_size < 1);

	return rx_buff;
}


void  uart_print_char (uint8_t txbyte) {

	UART_send(&g_uart, &txbyte, sizeof(txbyte));


}


/**********************************************************************//**
 * Send single char via UART0.
 *
 * @note This function is blocking.
 *
 * @param[in] c Char to be send.
 **************************************************************************/
void  uart_putc (char  txbyte) {

    UART_send(&g_uart, &txbyte, sizeof(txbyte));


}

/**********************************************************************//**
 * Get char from UART0.
 *
 * @note This function is blocking and does not check for UART frame/parity errors.
 *
 * @return Received char.
 **************************************************************************/
char uart_getc(void) {

  uint32_t d = 0;
  uint8_t rx_size=0;
  uint8_t rx_buff;

      do {
         rx_size = UART_get_rx(&g_uart, &rx_buff, sizeof(rx_buff));

           }while ( rx_size < 1);

      return (char)rx_buff;
    }

/**********************************************************************//**
 * Print string (zero-terminated) via UART0. Print full line break "\r\n" for every '\n'.
 *
 * @note This function is blocking.
 *
 * @param[in] s Pointer to string.
 **************************************************************************/
void uart_print(const char *s) {

  char c = 0;
  while ((c = *s++)) {
    if (c == '\n') {
      uart_putc('\r');
    }
      uart_putc(c);
  }
}


/**********************************************************************//**
 * Print 32-bit number as 8-digit hexadecimal value (with "0x" suffix).
 *
 * @param[in] num Number to print as hexadecimal.
 **************************************************************************/
void print_hex_word(uint32_t num) {

  static const char hex_symbols[16] = "0123456789ABCDEF";

  PRINT_TEXT("0x");

  int i;
  for (i=0; i<8; i++) {
    uint32_t index = (num >> (28 - 4*i)) & 0xF;

    PRINT_PUTC(hex_symbols[index]);
  }

}




void print_dec_num(uint32_t value )
{

    uint8_t conv_array[NB_NIBBLES_IN_INT];
    unsigned int uvalue;
    unsigned int remainder;
    unsigned int digit_idx,nb_digits;
    uint8_t * p_result;
    uint8_t result_size;

    uvalue = (uint32_t)value;
    digit_idx=0;
    if (uvalue)
    {
        while (uvalue)
        {
            remainder = uvalue % 10;
            conv_array[digit_idx] = remainder + '0';
            uvalue /= 10;
            digit_idx++;
        }
    }
    else
    {
        conv_array[digit_idx] = '0';
        digit_idx++;
    }


    nb_digits = digit_idx;
    for ( digit_idx = 0; (digit_idx < nb_digits); digit_idx++ )
    {
        p_result[digit_idx] = conv_array[nb_digits - digit_idx - 1];
        PRINT_PUTC(p_result[digit_idx]);

    }

    //return digit_idx;

}

/**********************************************************************//**
 * Print 8-bit number as 2-digit hexadecimal value (with "0x" suffix).
 *
 * @param[in] num Number to print as hexadecimal.
 **************************************************************************/
void print_hex_byte(uint8_t num) {

  static const char hex_symbols[16] ="0123456789ABCDEF";

  PRINT_TEXT("0x");

  int i;
  for (i=6; i<8; i++) {
    uint32_t index = (num >> (28 - 4*i)) & 0xF;
    PRINT_PUTC(hex_symbols[index]);
  }

}


/**********************************************************************//**
 * Print 8-bit number as 2-digit hexadecimal value (without "0x" suffix).
 *
 * @param[in] num Number to print as hexadecimal.
 **************************************************************************/
void print_hex_digit(uint32_t num) {



  static const char hex_symbols[16] = "0123456789ABCDEF";

  //PRINT_TEXT("0x");

  int i;
  for (i=6; i<8; i++) {
    uint32_t index = (num >> (28 - 4*i)) & 0xF;
    PRINT_PUTC(hex_symbols[index]);
  }

}

/**********************************************************************//**
 * Printthe memory array in hex format like a hex editor (without "0x" suffix).
 *
 * @param[in] num Number to print as hexadecimal.
 **************************************************************************/


void print_hex_file(uint8_t *value,uint32_t bytes){
    uint32_t index = 0;

    for ( index =0 ; index < bytes; index=index+ 16){
        uart_print("\r\n ");

        print_array(&value[index],16);
        uart_print("\r\n ");

}
}
/**********************************************************************//**
 * Print memory array in hex format (without "0x" suffix).
 *
 * @param[in] num Number to print as hexadecimal.
 **************************************************************************/

void print_array(uint8_t *value, uint32_t bytes)
{
    int idx;
        for (idx=0;idx<bytes;idx++)
        {
            print_hex_digit(value[bytes-1-idx]);
            uart_print_text(" ");
        }
        return;

}


void uart_print_string( const uint8_t * text , size_t size)
{

    UART_send(&g_uart,text,size);

}


void uart_print_text(const uint8_t * text)
{

    uint8_t length;
    length = 0;
    while (text[length++]!='\0');
    UART_polled_tx_string(&g_uart,text);

}


void uart_print_array(uint8_t *value, uint16_t bytes, uint8_t descriptive)
{
	int idx;
	    for (idx=0;idx<bytes;idx++)
	    {
	        uart_print_number(value[bytes-1-idx], descriptive);
	        uart_print_text(" ");
	    }
	    return;

}

void uart_print_memory(uint8_t *value,uint16_t bytes, uint8_t descriptive){
	uint16_t index = 0;

	for ( index =0 ; index < bytes; index=index+ 16){
		uart_print_text("\r\n ");

		uart_print_array(&value[index],16,descriptive);
	    uart_print_text("\r\n ");

}
}




uint32_t to_hex_digit(uint32_t value, uint8_t * p_result, uint8_t result_size)
{
    int nibble_idx, nb_nibbles;
    uint8_t conv_array[NB_NIBBLES_IN_INT];
    unsigned int uvalue;
    nibble_idx = 0;
    uvalue = (uint32_t)value;

    do {
        int nibble = uvalue & 0x0F;

        if ( nibble < 10 )
            conv_array[nibble_idx] = nibble + '0';
        else
        conv_array[nibble_idx] = nibble  - 10 + 'A';
        uvalue = (uvalue >> 4);
        nibble_idx++;
    } while ( ( nibble_idx < NB_NIBBLES_IN_INT ) && ( uvalue > 0 ) );

    nb_nibbles = nibble_idx;
    for ( nibble_idx = 0; (nibble_idx < nb_nibbles) && (nibble_idx < result_size) ;nibble_idx++ )
    {
        p_result[nibble_idx] = conv_array[nb_nibbles - nibble_idx - 1];
    }
    return nibble_idx;
}

uint32_t to_dec_digit(uint32_t value, uint8_t * p_result, uint8_t result_size)
{

    uint8_t conv_array[NB_NIBBLES_IN_INT];
    unsigned int uvalue;
    unsigned int remainder;
    unsigned int digit_idx,nb_digits;

    uvalue = (uint32_t)value;
    digit_idx=0;
    if (uvalue)
    {
        while (uvalue)
        {
            remainder = uvalue % 10;
            conv_array[digit_idx] = remainder + '0';
            uvalue /= 10;
            digit_idx++;
        }
    }
    else
    {
        conv_array[digit_idx] = '0';
        digit_idx++;
    }


    nb_digits = digit_idx;
    for ( digit_idx = 0; (digit_idx < nb_digits && (digit_idx < result_size)); digit_idx++ )
    {
        p_result[digit_idx] = conv_array[nb_digits - digit_idx - 1];
    }
    return digit_idx;
}




void uart_print_number(uint32_t value,uint8_t descr)
{
	/* User Specific Code */
	uint8_t value_text[256];
	uint8_t text_size;
	    if (descr == HEX)
	    {
	        text_size = to_hex_digit( value, value_text, 8);
	    }
	    else
	    {
	        text_size = to_dec_digit( value, value_text, 8);
	    }
	   // UART_send (&g_stdio_uart, value_text, text_size);
	    UART_send(&g_uart, value_text, text_size);
	    return;
}


void UART_puthex8(uint8_t val) {
	uart_print_number(val,HEX);

}







/*

void press_any_key(void)
{
    uint8_t rx_size = 0;
    uint8_t rx_data = 0;

    MSS_UART_polled_tx_string(g_my_uart,(uint8_t *)"\r\nPress any key to continue...");
    do {
        rx_size = MSS_UART_get_rx(g_my_uart, &rx_data,1);
    } while(rx_size == 0);

}

*/


uint32_t xatoi (                                             /* 0:Failed, 1:Successful */
		       uint8_t  **str,                          /* Pointer to pointer to the string */
		       uint32_t  *res                             /* Pointer to the valiable to store the value */
)
{
		        uint32_t val;
                uint8_t c, r, s = 0;


                *res = 0;

                while ((c = **str) == ' ') (*str)++;               /* Skip leading spaces */

                if (c == '-') {                         /* negative? */
                                s = 1;
                                c = *(++(*str));
                }

                if (c == '0') {
                                c = *(++(*str));
                                switch (c) {
                                case 'x':                                /* hexdecimal */
                                case 'X':

                                                r = 16; c = *(++(*str));
                                                break;
                                case 'b':                                /* binary */
                                case 'B':

                                                r = 2; c = *(++(*str));
                                                break;
                                default:
                                                if (c <= ' ') return 1;          /* single zero */
                                                if (c < '0' || c > '9') return 0;          /* invalid char */
                                                r = 8;                      /* octal */
                                }
                } else {
                                if (c < '0' || c > '9') return 0;          /* EOL or invalid char */
                                r = 10;                                    /* decimal */
                }

                val = 0;
                while (c > ' ') {
                                if (c >= 'a') c -= 0x20;
                                c -= '0';
                                if (c >= 17) {
                                                c -= 7;
                                                if (c <= 9) return 0;           /* invalid char */
                                }
                                if (c >= r) return 0;                           /* invalid char for current radix */
                                val = val * r + c;
                                c = *(++(*str));
                }
                if (s) val = 0 - val;                                               /* apply sign if needed */

                *res = val;
                return 1;
}


uint32_t  getParity(uint32_t n)
{
	uint32_t parity = 0;
    while (n)
    {
        parity = !parity;
        n      = n & (n - 1);
    }
    return parity;
}




/**********************************************************************//**
 * Print the Header for the Hex file/buffer
 *
 * @note This function is blocking.
 *
 * @param[in] c Char to be send.
 **************************************************************************/

void print_hex_header(void)
{

    uint8_t idk;
    PRINT_TEXT("\r\n              ");  // 12 spaces for address

    for ( idk=0 ; idk < 16 ; idk++){

        print_hex_digit(idk);
        PRINT_TEXT(" ");  // one space between bytes

    }
    PRINT_TEXT("  ASCII Value ");  // one space between bytes
    PRINT_TEXT("\r\n  ------------------------------------------------------------------------------- ");  // 12 spaces for address




}

/**********************************************************************//**
 * Print one line of  data containing 16 locations.
 *  hex value followed by ascci value
 * @note This function is blocking.
 *
 * @param  addr  :  address of the buffer wher the data is kpet.
 * @param  value :  pointer to the buffer where the data is kept.
 **************************************************************************/

void print_hex_line( uint32_t addr, uint8_t *value){
    uint32_t index = 0;

    PRINT_TEXT("  ");
    PRINT_XNUM(addr);
    PRINT_TEXT("| "); // two spaces between the address and data bytes

    for ( index =0 ; index < 16; index++){
        print_hex_digit(value[index]);
        PRINT_TEXT(" "); // one space
        }
    PRINT_TEXT("| "); // two spaces


}


/**********************************************************************//**
 * Print one line of  data containing 16 locations. ascci value printing
 * @note This function is blocking.
 *
 * @param  addr  :  address of the buffer wher the data is kpet.
 * @param  value :  pointer to the buffer where the data is kept.
 **************************************************************************/

void print_ascii_line( uint32_t addr, uint8_t *value){
    uint32_t index = 0;
   //PRINT_TEXT("  "); // two spaces
   // PRINT_XNUM(addr);
   // PRINT_TEXT("| "); // two spaces between the address and data bytes

    for ( index =0 ; index < 16; index++){
            PRINT_PUTC(value[index]);
            PRINT_TEXT(" "); // one space between each data byte
            }

}




/**********************************************************************//**
 * Print entire buffer in hex . each line with 16 location followed by its ascii value
 *
 * @note This function is blocking.
 *
 * @param  buffer      :  uint8_t pointer to input buffer where the data is available
 * @param  addr_offset :  use this field if needed to print values with a offset location other than the beginning
 *                        provide 0 if not needed
 *         size        : size of the data to be printed in bytes
 **************************************************************************/
void hex_view_buffer( uint8_t *buffer ,uint32_t addr_offset, uint32_t size){
    uint32_t addr;
    uint32_t idk;
    print_hex_header();
    addr = (uint32_t)buffer + addr_offset; // if there is an address offset  add that as well
    for ( idk=0;  idk < size;  idk = idk + 16){
    PRINT_TEXT("\r\n");
    print_hex_line(addr, &buffer[addr_offset + idk]); // get the value from pointer offset location
    print_ascii_line(addr, &buffer[addr_offset + idk]); // get the value from pointer offset location
    addr = addr + 16;  // next line increment the addr by 16
    }

}



/**********************************************************************//**
 * Print entire buffer in hex . each line with 16 location followed by its ascii value
 *
 * @note This function is blocking.
 *
 * @param  buffer      :  uint8_t pointer to input buffer where the data is available
 * @param  addr_offset :  use this field if needed to print values with a offset location other than the beginning
 *                        provide 0 if not needed
 *         size        : size of the data to be printed in bytes
 **************************************************************************/
void hex_buffer_compare( uint8_t *buffer1 , uint8_t *buffer2, uint32_t size){
    uint32_t addr1, addr2;
    uint32_t idk;
    print_hex_header();
    addr1 = (uint32_t)buffer1 ;  // if there is an address offset  add that as well
    addr2 = (uint32_t)buffer2 ;
    for ( idk=0;  idk < size;  idk = idk + 16){
    PRINT_TEXT("\r\n ");
    print_hex_line(addr1, &buffer1[idk]); // get the value from pointer offset location
    print_hex_line(addr2, &buffer2[idk]); // get the value from pointer offset location
    addr1 = addr1 + 16;  // next line increment the addr by 16
    addr2 = addr2 + 16;  // next line increment the addr by 16
    }

}





/**********************************************************************//**
 * Reads data from the SPI flash memory and prints as hex format
 *
 * @note This function is blocking.
 *
 * @param  flash_addr  :  uint32_t  flash address
 * @param  size        :  size of the data to be read in bytes
 *
 **************************************************************************/
void hex_view_spi_flash(uint32_t flash_addr, uint32_t size){
#ifdef CONFIG_USE_SPI_FLASH
    uint32_t addr_offset =0;
    uint32_t idk,i;
    uint8_t key;
    uint8_t flash_rd_buf[256];


    print_hex_header();

   addr_offset = 0;
   while ( addr_offset < size){
          /* read as many as 128 Bytes at a time ( size of the g_rd_buf buffer */
          spi_flash_read(flash_addr + addr_offset, flash_rd_buf, sizeof(flash_rd_buf));
        //FLASH_read(flash_addr + addr_offset, flash_rd_buf, sizeof(flash_rd_buf));


          /* print the read 128 bytes into 16 bytes per line 8 */
      for ( idk=0;  idk < sizeof(flash_rd_buf);  idk = idk + 16){
       PRINT_TEXT("\r\n");
       print_hex_line(flash_addr + addr_offset +idk , &flash_rd_buf[idk]); // get the value from pointer offset location
       print_ascii_line(flash_addr + addr_offset +idk , &flash_rd_buf[idk]); // get the value from pointer offset location
      }

    addr_offset = addr_offset + sizeof(flash_rd_buf);

    PRINT_TEXT("\r\n press any key to continue or 'x' to exit");
    key = PRINT_GETC();

        if ( key == 'x')
             break;
        else
            continue;

   }
#else

   return ;
#endif

}
