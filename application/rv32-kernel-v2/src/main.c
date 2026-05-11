/*******************************************************************************
*  Timer with Single shot
 */

#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

#include "hal/hal.h"
#include "miv_rv32_hal/miv_rv32_hal.h"
#include "drivers/fpga_ip/CoreGPIO/core_gpio.h"
#include "drivers/fpga_ip/CoreUARTapb/core_uart_apb.h"
#include "drivers/fpga_ip/CoreSPI/core_spi.h"

#include "fpga_design_config/fpga_design_config.h"



#include "stdio/uart_stdio.h"
#include "spi_flash/spi_flash.h"
#include "ymodem/ymodem.h"




UART_instance_t g_uart;
gpio_instance_t g_gpio;
spi_instance_t  g_spi_0;
//timer_instance_t  g_timer_1;



/* --- Configuration --- */
#define MAX_FILES 15        
#define NAME_LEN 12          
#define CONTENT_LEN 32      
#define PATH_LEN 16         
#define DMESG_LINES 6
#define DMESG_LEN 40

#define HIGH 1
#define LOW 0

#define OUTPUT         GPIO_OUTPUT_MODE
#define INPUT_PULLUP   GPIO_INPUT_MODE

//#define MAX_FILES 15
#define FILE_NAME_LENGTH (64)
#define FILE_SIZE_LENGTH (16)



#define pinMode(pin, MODE)   GPIO_config( &g_gpio,pin,MODE)

#define digitalWrite(pin, VAL)  GPIO_set_output(&g_gpio, pin, VAL )
#define digitalRead(pin) ((GPIO_get_inputs(&g_gpio) >> (pin)) & 0x01)
#define digitalOutRead(pin) ((GPIO_get_outputs(&g_gpio) >> (pin)) & 0x01)

uint32_t file_download(uint8_t * g_bin_base , uint8_t * file_name );
uint32_t ymodem_receive(uint8_t *buf, uint32_t length, uint8_t *file_name, uint32_t memory_size);
static uint32_t rx_app_file(uint8_t *dest_address);

//uint8_t rcv_buff[32*1024*8];


#define LSRAM_BASE_ADDRESS_LOAD         0x80000000
#define LSRAM_BASE_ADDRESS_WRITE        0x89000000
#define LSRAM_SIZE                      131072u


/* --- Structures --- */

typedef struct {
  char name[NAME_LEN];
  char content[CONTENT_LEN];
  char parentDir[PATH_LEN];
  int isDirectory;
  int active;
} RAMFile;

typedef struct {
  unsigned long timestamp;
  char message[DMESG_LEN];
} DmesgEntry;



typedef struct {
    uint8_t     file_name[FILE_NAME_LENGTH];           // File name (max 32 characters)
    uint8_t     size[FILE_SIZE_LENGTH];          // file size in string
    uint32_t    file_size;       // file size in bytes
    uint32_t    file_addr;       // addr offset in spi flash memory
    uint8_t     *file_ptr;       // Pointer to the file in DDR memory
    uint32_t    checksum;        // file checksum
} file_t;



/* --- Global State --- */
RAMFile fs[MAX_FILES];
char currentPath[PATH_LEN] = "/";
char inputBuffer[32] = "";
int inputLen = 0;
DmesgEntry dmesg[DMESG_LINES];
int dmesgIndex = 0;


static volatile uint32_t ms_ticks = 0;
volatile uint32_t g_10ms_count=0;

void executeCommand(char* line) ;

// The replacement for millis()
uint32_t millis(void) {
    return ms_ticks;
}


void delay_ms(uint32_t ms) {
    uint32_t start_time = ms_ticks;
    
    // Use unsigned subtraction to handle timer overflow (rollover) automatically
    while ((uint32_t)(ms_ticks - start_time) < ms) {
        // Optional: Wait For Interrupt (wfi) 
        // This puts the CPU into a low-power state until the next tick occurs
        __asm__ volatile ("wfi"); 
    }
}




void SysTick_Handler(void)
{
    ms_ticks++;

    /* Only increment every 10th tick (when ms_ticks is a multiple of 10) */
   // if ((ms_ticks % 10) == 0)
   // {
   //     g_10ms_count++;
   // }


    g_10ms_count += 10;

      /*
       * For neatness, if we roll over, reset cleanly back to 0 so the count
       * always goes up in proper 10s.
       */
     if(g_10ms_count < 10)
         g_10ms_count = 0;

}

void delay(uint32_t ms) {
    uint32_t start_time = ms_ticks;
    
    // Use unsigned subtraction to handle timer overflow (rollover) automatically
    while ((uint32_t)(ms_ticks - start_time) < ms) {
        // Optional: Wait For Interrupt (wfi) 
        // This puts the CPU into a low-power state until the next tick occurs
        __asm__ volatile ("wfi"); 
    }
}


// Standard Newlib way to estimate free heap
int freeMemory2() {
    extern char _end;      // Symbol defined by linker script
    extern char _stack;    // Symbol defined by linker script
    char top_of_stack;
    return &top_of_stack - &_end;
}


uint32_t freeMemory() {
    extern char _end; // Defined by linker script
    uint32_t stack_ptr;
    // Inline assembly to get the current Stack Pointer (sp)
    __asm__ volatile ("mv %0, sp" : "=r"(stack_ptr));
    
    // The space between the current stack and the end of static data/heap
    return stack_ptr - (uint32_t)&_end;
}



void addDmesgRam(const char* msg) {
  if (dmesgIndex >= DMESG_LINES) dmesgIndex = 0;
  dmesg[dmesgIndex].timestamp = millis() / 1000;
  strncpy(dmesg[dmesgIndex].message, msg, DMESG_LEN - 1);
  dmesg[dmesgIndex].message[DMESG_LEN - 1] = '\0';
  dmesgIndex++;
}




void addDmesg(const char* msg) {
  if (dmesgIndex >= DMESG_LINES) dmesgIndex = 0;
  dmesg[dmesgIndex].timestamp = millis() / 1000;
  strncpy(dmesg[dmesgIndex].message, msg, DMESG_LEN - 1);
  dmesg[dmesgIndex].message[DMESG_LEN - 1] = '\0';
  dmesgIndex++;
}





void printPrompt() {
    printf("\r\n");
    printf("root@rv32:%s# ", currentPath);
}


int atoi_safe(const char* str) {
  int num = 0;
  while (*str >= '0' && *str <= '9') {
    num = num * 10 + (*str - '0');
    str++;
  }
  return num;
}


int indexOf(const char* str, const char* substr) {
  int i, j, slen = strlen(str), sublen = strlen(substr);
  for (i = 0; i <= slen - sublen; i++) {
    int match = 1;
    for (j = 0; j < sublen; j++) {
      if (str[i + j] != substr[j]) { match = 0; break; }
    }
    if (match) return i;
  }
  return -1;
}


void toLowercase(char* str) {
  int i;
  for (i = 0; str[i] != '\0'; i++) {
    if (str[i] >= 'A' && str[i] <= 'Z') str[i] = str[i] - 'A' + 'a';
  }
}

int safeConcatPath(char* dest, const char* add) {
  int destLen = strlen(dest);
  int addLen = strlen(add);
  if (destLen + addLen + 2 >= PATH_LEN) return 0;
  strncat(dest, add, PATH_LEN - destLen - 1);
  strncat(dest, "/", PATH_LEN - strlen(dest) - 1);
  return 1;
}



void initFS() {
  int d, i;

  const char* dirs[] = {"home", "dev"};
  for (d = 0; d < 2; d++) {
    for (i = 0; i < MAX_FILES; i++) {
      if (!fs[i].active) {
        strncpy(fs[i].name, dirs[d], NAME_LEN - 1);
        fs[i].name[NAME_LEN - 1] = '\0';
        strncpy(fs[i].parentDir, "/", PATH_LEN - 1);
        fs[i].parentDir[PATH_LEN - 1] = '\0';
        fs[i].isDirectory = 1;
        fs[i].active = 1;
        break;
      }
    }
  }

  char devPath[PATH_LEN] = "/dev/";
  const char* pins[] = {"pin2", "pin3", "pin4"};
  for (d = 0; d < 3; d++) {
    for (i = 0; i < MAX_FILES; i++) {
      if (!fs[i].active) {
        strncpy(fs[i].name, pins[d], NAME_LEN - 1);
        fs[i].name[NAME_LEN - 1] = '\0';
        strncpy(fs[i].parentDir, devPath, PATH_LEN - 1);
        fs[i].parentDir[PATH_LEN - 1] = '\0';
        fs[i].isDirectory = 0;
        fs[i].content[0] = '\0';
        fs[i].active = 1;
        break;
      }
    }
  }

  // OPT from isse
  addDmesg("Kernel initialized");
  addDmesg("Filesystem mounted");
  addDmesg("Ready for commands");
}

void runScript(const char* content) {
    char line[64]; // Increased slightly for RISC-V safety
    int ci = 0, li = 0, lineNum = 0;
    int len = strlen(content);

    while (ci <= len) {
        // Fetch character or treat end of string as a command terminator (;)
        char c = (ci < len) ? content[ci] : ';';
        ci++;

        if (c == ';' || c == '\n' || c == '\r') {
            if (li > 0) {
                line[li] = '\0';
                lineNum++;
                
                // Professional formatted output
                printf("\r[sh:%d] %s\n", lineNum, line);
                
                executeCommand(line);
                li = 0;
            }
        } else {
            // Prevent buffer overflow: Mi-V stack protection
            if (li < (sizeof(line) - 1)) {
                line[li++] = c;
            }
        }
    }
    addDmesg("sh: script done");
    printf("\r[sh] done.\n");
}


void executeCommand(char* line) {
  char cmd[32] = "";
  char args[32] = "";
  int space1 = -1;
  int i, sp, pin, count;
  char buf[40];

  strncpy(cmd, line, 31);
  //char* cmd = strtok(line, " ");
  cmd[31] = '\0';

  for (i = 0; cmd[i] != '\0'; i++) {
    if (cmd[i] == ' ') {
      space1 = i;
      strncpy(args, cmd + i + 1, 31);
      args[31] = '\0';
      cmd[i] = '\0';
      break;
    }
  }

  toLowercase(cmd);

  if (strcmp(cmd, "write") == 0){
    sp = indexOf(args, " ");
    if (sp == -1) { printf("Usage: write [pin] [high/low]\n"); return; }
    pin = atoi_safe(args);
    char val[8] = "";
    strncpy(val, args + sp + 1, 7);
    val[7] = '\0';
    toLowercase(val);
    digitalWrite(pin, (strcmp(val, "high") == 0 ? HIGH : LOW));
    snprintf(buf, sizeof(buf), "Pin %d wrote %s", pin, (strcmp(val, "high") == 0) ? "HIGH" : "LOW");
    addDmesgRam(buf);
    printf("\rWrite OK.");
  }

  else if (strcmp(cmd, "gpio") == 0) {
    sp = indexOf(args, " ");
    if (sp == -1) {
      printf("\r\nUsage: gpio [pin] [on/off] OR gpio vixa [count]");
      return;
    }
    char pinStr[8] = "";
    strncpy(pinStr, args, sp);
    pinStr[sp] = '\0';
    char action[8] = "";
    strncpy(action, args + sp + 1, 7);
    action[7] = '\0';
    toLowercase(action);

    if (strcmp(pinStr, "vixa") == 0) {
      count = atoi_safe(action);
      if (count <= 0) count = 10;
      addDmesg("LED disco mode activated");
      printf("\rLED DISCO MODE!");
      int cycle, p;
      for (cycle = 0; cycle < count; cycle++) {
        for (p = 0; p <= 3; p++) {
          //pinMode(p, OUTPUT);
          digitalWrite(p, HIGH);
          delay(50);
          digitalWrite(p, LOW);
        }
      }
      printf("\r\nDisco finished!");
      addDmesg("Disco complete");
    }
    else {
      pin = atoi_safe(pinStr);
      if (strcmp(action, "on") == 0) {
        //pinMode(pin, OUTPUT);
        digitalWrite(pin, HIGH);
        snprintf(buf, sizeof(buf), "GPIO %d ON", pin);
        addDmesgRam(buf);
        printf("\rGPIO "); printf("%d",pin); printf(" ON");
      }
      else if (strcmp(action, "off") == 0) {
        //pinMode(pin, OUTPUT);
        digitalWrite(pin, LOW);
        snprintf(buf, sizeof(buf), "GPIO %d OFF", pin);
        addDmesgRam(buf);
        printf("\rGPIO "); printf("%d ",pin); printf(" OFF");
      }
      else if (strcmp(action, "toggle") == 0) {
        //pinMode(pin, OUTPUT);
        digitalWrite(pin, !digitalOutRead(pin));
        snprintf(buf, sizeof(buf), "GPIO %d toggled", pin);
        addDmesgRam(buf);
        printf("\rGPIO "); printf("%d",pin); printf(" toggled");
      }
    }  
}
else if (strcmp(cmd, "ls") == 0) {
    int empty = 1, j;
    printf("\r"); // Move to start once at the beginning (optional)
    for (j = 0; j < MAX_FILES; j++) {
        // Filter: Entry must be active AND located in the current directory
        if (fs[j].active && strcmp(fs[j].parentDir, currentPath) == 0) {
            
            // Print the name, and append a '/' if it's a directory
            printf("%s%s  ", fs[j].name, fs[j].isDirectory ? "/" : "");
            empty = 0;
        }
    }
    
    if (empty) {
        printf("(empty)");
    }
    printf("\n"); // Final newline
}

  else if (strcmp(cmd, "mkdir") == 0 || strcmp(cmd, "touch") == 0) {
    int foundSlot = -1, j;
    // 1. Find the first available (inactive) entry in the array
    for (j = 0; j < MAX_FILES; j++) {
        if (!fs[j].active) { 
            foundSlot = j; 
            break; 
        }
    }

    if (foundSlot == -1) { 
        printf("No space.\n"); 
        return; 
    }

    // 2. Initialize the metadata
    strncpy(fs[foundSlot].name, args, NAME_LEN - 1);
    fs[foundSlot].name[NAME_LEN - 1] = '\0';
    
    strncpy(fs[foundSlot].parentDir, currentPath, PATH_LEN - 1);
    fs[foundSlot].parentDir[PATH_LEN - 1] = '\0';

    // 3. Set the type: mkdir -> Directory, touch -> File
    fs[foundSlot].isDirectory = (strcmp(cmd, "mkdir") == 0);
    
    // 4. Wipe contents and activate
    fs[foundSlot].content[0] = '\0';
    fs[foundSlot].active = 1;
    
    printf("\rOK.\n");
}

  else if (strcmp(cmd, "cd") == 0) {
    // Handle root and parent directory shortcuts
    if (strcmp(args, "..") == 0 || strcmp(args, "/") == 0) {
        strncpy(currentPath, "/", PATH_LEN - 1);
        currentPath[PATH_LEN - 1] = '\0';
    } else {
        int j, found = 0;
        for (j = 0; j < MAX_FILES; j++) {
            // Must be active, a directory, match the name, and be in the current location
            if (fs[j].active && fs[j].isDirectory &&
                strcmp(args, fs[j].name) == 0 &&
                strcmp(fs[j].parentDir, currentPath) == 0) {
                
                // Attempt to update the path string safely
                if (!safeConcatPath(currentPath, fs[j].name)) {
                    // Reset to root if path calculation fails to prevent illegal memory access
                    strncpy(currentPath, "/", PATH_LEN - 1);
                    currentPath[PATH_LEN - 1] = '\0';
                    printf("\rPath too long.\n");
                    return;
                }
                found = 1;
                break;
            }
        }
        if (!found) printf("\rNo dir.\n");
    }
}

  else if (strcmp(cmd, "pwd") == 0) {
    printf("\r%s\n", currentPath);
  }

    

  else if (strcmp(cmd, "echo") == 0) {
    int arrow = indexOf(args, " > ");
    if (arrow != -1) {
        char text[40] = "";
        // Limit copy to size of text buffer to avoid stack corruption
        int textLen = (arrow < 39) ? arrow : 39;
        strncpy(text, args, textLen);
        text[textLen] = '\0';

        char filename[NAME_LEN] = "";
        strncpy(filename, args + arrow + 3, NAME_LEN - 1);
        filename[NAME_LEN - 1] = '\0';

        int j, found = 0;
        for (j = 0; j < MAX_FILES; j++) {
            if (fs[j].active && !fs[j].isDirectory &&
                strcmp(filename, fs[j].name) == 0 &&
                strcmp(fs[j].parentDir, currentPath) == 0) {
                
                strncpy(fs[j].content, text, CONTENT_LEN - 1);
                fs[j].content[CONTENT_LEN - 1] = '\0';
                printf("\rSaved.\n");

                // Virtual Hardware Logic: /dev/pinXX
                if (strcmp(fs[j].parentDir, "/dev/") == 0 && strncmp(fs[j].name, "pin", 3) == 0) {
                    int devPin = atoi_safe(fs[j].name + 3);
                    if (devPin > 0) {
                        //pinMode(devPin, OUTPUT);
                        digitalWrite(devPin, (text[0] == '1') ? HIGH : LOW);
                        
                        char buf[64];
                        snprintf(buf, sizeof(buf), "GPIO %d %s via echo", devPin, (text[0] == '1') ? "HIGH" : "LOW");
                        addDmesgRam(buf);
                    }
                }
                found = 1;
                break;
            }
        }
        if (!found) printf("File not found.\n");
    } else {
        printf("\r%s\n", args);
    }
}

   else if (strcmp(cmd, "cat") == 0) {
    int j, found = 0;
    for (j = 0; j < MAX_FILES; j++) {
        // Validation: Must be active, NOT a directory, and in the current path
        if (fs[j].active && !fs[j].isDirectory &&
            strcmp(args, fs[j].name) == 0 &&
            strcmp(fs[j].parentDir, currentPath) == 0) {
            
            // Native printf handles the string output
            printf("\r%s", fs[j].content);
            found = 1;
            break;
        }
    }
    if (!found) printf("\rFile not found.");
}

   else if (strcmp(cmd, "info") == 0) {
    int j, found = 0;
    for (j = 0; j < MAX_FILES; j++) {
        // Find the active file in the current directory
        if (fs[j].active && strcmp(args, fs[j].name) == 0 && strcmp(fs[j].parentDir, currentPath) == 0) {
            
            printf("\rName: %s\n", fs[j].name);
            printf("\rType: %s\n", fs[j].isDirectory ? "Directory" : "File");
            
            // Calculate size based on string length of content
            printf("\rSize: %u bytes", (unsigned int)strlen(fs[j].content));
            
            found = 1;
            break;
        }
    }
    if (!found) printf("\rNot found.\n");
}


  else if (strcmp(cmd, "rm") == 0) {
    int j, found = 0;
    for (j = 0; j < MAX_FILES; j++) {
        // Check if file is active, names match, and it's in the current directory
        if (fs[j].active && strcmp(args, fs[j].name) == 0 && strcmp(fs[j].parentDir, currentPath) == 0) {
            
            if (fs[j].isDirectory) {
                char dirPath[PATH_LEN];
                // Build the full path of the directory to be removed
                snprintf(dirPath, PATH_LEN, "%s%s/", currentPath, args);
                
                // Recursive-style deletion: Kill all files that have this directory as a parent
                for (int k = 0; k < MAX_FILES; k++) {
                    if (fs[k].active && strncmp(fs[k].parentDir, dirPath, strlen(dirPath)) == 0) {
                        fs[k].active = 0;
                    }
                }
            }
            
            fs[j].active = 0; // Deactivate the file/folder itself
            printf("\rRemoved.");
            found = 1;
            break;
        }
    }
    if (!found) printf("Not found.\n");
}

else if (strcmp(cmd, "dmesg") == 0) {
    printf("=== KERNEL MESSAGES ===\r\n"); // Added \r
    for (int j = 0; j < DMESG_LINES; j++) {
        if (dmesg[j].message[0] != '\0') {
            // Using \r\n at the end of the line
            printf("[%lu] %s\r\n", dmesg[j].timestamp, dmesg[j].message);
        }
    }
}

 else if (strcmp(cmd, "uptime") == 0) {
    unsigned long s = millis() / 1000;
    unsigned long h = s / 3600;
    unsigned long m = (s % 3600) / 60;
    unsigned long sec = s % 60;

    // Use a local buffer to build the string
    char buf[32];
    snprintf(buf, sizeof(buf), "up %luh %lum %lus", h, m, sec);
    
    printf("\r%s\n", buf); // One single UART transmission
    addDmesg("uptime command");
}

else if (strcmp(cmd, "df") == 0 || strcmp(cmd, "free") == 0) {
    // Standardizing on printf for RV32
    printf("\rFree RAM: %u bytes\n", (unsigned int)freeMemory());
}

else if (strcmp(cmd, "whoami") == 0) {
    uint32_t hartid;
    // Read the Machine Hart ID register
    __asm__ volatile ("csrr %0, mhartid" : "=r"(hartid));
    
    printf("\rroot (Hart ID: %u)\n", (unsigned int)hartid);
}

    else if (strcmp(cmd, "uname") == 0) {
        printf("\r%-12s: %s\n", "Kernel", "KernelRISCV v2.0");
        printf("\r%-12s: %s\n", "Architecture", "Mi-V RV32IM");
        printf("\r%-12s: %s\n", "Hardware", "Microchip Creative Board");
        printf("\r%-12s: %u bytes free\n", "RAM", (unsigned int)freeMemory());
        printf("\r%-12s: %s %s\n", "Build Date", __DATE__, __TIME__);
    }  
    
else if (strcmp(cmd, "reboot") == 0) {
    printf("\rRebooting (Software)...\n");
    addDmesg("System reboot");
    delay(500);
    
    // Jump to the reset vector (usually 0x80000000 for Microchip Mi-V)
    void (*resetVector)() = (void (*)())0x80000000;
    resetVector();
}

else if (strcmp(cmd, "panic") == 0) {
    printf("\rKERNEL PANIC: Manual Trigger\n");
    __asm__ volatile ("ebreak"); // This triggers the debugger immediately
}

else if (strcmp(cmd, "clear") == 0) {
    // \033[2J  -> Clears the entire screen
    // \033[H   -> Moves cursor to the Home position (top-left)
    printf("\033[2J\033[H");
}

else if (strcmp(cmd, "sh") == 0) {
    if (args[0] == '\0') {
        printf("Usage: sh [script]\n");
        return;
    }
    
    int j, found = 0;
    for (j = 0; j < MAX_FILES; j++) {
        if (fs[j].active && !fs[j].isDirectory &&
            strcmp(args, fs[j].name) == 0 &&
            strcmp(fs[j].parentDir, currentPath) == 0) {
            
            found = 1;
            addDmesg("sh: running script");
            
            // Critical: Interpretation happens here
            runScript(fs[j].content); 
            break;
        }
    }
    if (!found) printf("Script not found.\n");
}
else if (strcmp(cmd, "ymodem") == 0) {   
    uint32_t file_size;    
    static uint8_t file_name[FILE_NAME_LENGTH + 1]; /* +1 for nul */
    file_size = file_download((uint8_t *)LSRAM_BASE_ADDRESS_LOAD,file_name);
     //file_size = rx_app_file(rcv_buff);
     //file_size= rx_app_file((uint8_t *)LSRAM_BASE_ADDRESS_LOAD);
    addDmesg("ymodem: download");

}

else if (strcmp(cmd, "flash") == 0) {
    // Get the first argument after "flash" (the subcommand)
    char* cmd = strtok(line, " "); // this is needed to get the the  susequent strtok() to work
    char* sub = strtok(NULL, " "); 

    if (sub == NULL) {
        printf("Usage: flash [info|read|write|erase] <args>\r\n");
        return;
    }

    // --- Sub-Command: INFO ---
    if (strcmp(sub, "info") == 0) {
        // Assume you have a function to read and print JEDEC ID
        //print_flash_details();
        spi_flash_device_info();
    }

    // --- Sub-Command: READ <addr> ---
    else if (strcmp(sub, "read") == 0) {
        char* addrStr = strtok(NULL, " ");
        if (!addrStr) {
            printf("Usage: flash read <addr>\r\n");
        } else {
            uint32_t addr = strtoul(addrStr, NULL, 0);
            //hexdump(addr, 256); // Re-using your hexdump from earlier
            hex_view_spi_flash(addr, 4096);
        }
    }

    // --- Sub-Command: ERASE <addr> ---
    else if (strcmp(sub, "erase") == 0) {
        char* addrStr = strtok(NULL, " ");
        if (!addrStr) {
            printf("Usage: flash erase <addr>\r\n");
        } else {
            uint32_t addr = strtoul(addrStr, NULL, 0);
            printf("\rErasing sector at 0x%08X...\r\n", addr);
            spi_flash_erase_sectors (addr, 1);            
            printf("Done.\r\n");
        }
    }

    // --- Sub-Command: WRITE <addr> <data> ---
    else if (strcmp(sub, "write") == 0) {
        char* addrStr = strtok(NULL, " ");
        char* dataStr = strtok(NULL, ""); // Get everything else as the message

        if (!addrStr || !dataStr) {
            printf("Usage: flash write <addr> <text>\r\n");
        } else {
            uint32_t addr = strtoul(addrStr, NULL, 0);
            uint16_t len = strlen(dataStr);

            spi_flash_write_file (addr, (uint8_t*)dataStr, len);            
            
            printf("Wrote %d bytes to 0x%08X\r\n", len, addr);
        }
    }
    else {
        printf("\rUnknown flash command: %s\r\n", sub);
    }
}


  else if (strcmp(cmd,"help") == 0) {
    printf("\r\nCommands: ls, cd, pwd, mkdir, touch, cat, echo, rm, info");
    printf("\r\n          pinmode, write, read, gpio, pwm, sh");
    printf("\r\n          uptime, uname, dmesg, df, free, whoami, clear, reboot");
    printf("\r\nGPIO: gpio [pin] on/off/toggle  |  gpio vixa [count]");
    printf("\r\nSH:   sh [file]  -- run script (use ; as line separator)");
    printf("\r\nYMODEM:   ymodem  ; Download file using ymodem protocol");
  }  
  else {
    printf("\rUnknown command.");
  }
}

int main()
{
    
    /* Configure GPIO */
    GPIO_init( &g_gpio, COREGPIO_BASE_ADDR, GPIO_APB_32_BITS_BUS );  /* added to init LED*/

    /* Configure the UART */        
    UART_init( &g_uart, COREUARTAPB0_BASE_ADDR, BAUD_VALUE_115200, ( DATA_8_BITS | NO_PARITY ) );

    /* Configure SYTICK Timer for delay/tick functions */
    MRV_systick_config(SYS_CLK_FREQ/1000);

   
    printf ( "\r\nInitialising Flash mmeory ");

    spi_flash_init();



     printf ( "\r\nInitialising File System ");

    /* Initialising Filesystem */
    initFS();

    delay(50);

    printPrompt();
    


     while(1){



            char c = uart_getchar();

                        
            if (c == '\r' || c == '\n') {
                if (inputLen > 0) {
                    inputBuffer[inputLen] = '\0';
                    printf("\n");
                    executeCommand(inputBuffer);
                    inputLen = 0;
                    memset(inputBuffer, 0, 32);
                    printPrompt();
                } else {
                    printf("\n");
                    printPrompt();
                }
            }
            else if (c == 8 || c == 127) { // Backspace
                if (inputLen > 0) {
                    inputLen--;
                    inputBuffer[inputLen] = '\0';
                    printf("\b \b");
                }
            }
            else if (inputLen < 31) {
                //putchar(c); // Echo back
                uart_putc(c);// Echo back
                inputBuffer[inputLen++] = c;
            }
            }


    
}



uint32_t file_download(uint8_t * g_bin_base , uint8_t * file_name )
   {
       uint32_t file_size;
       file_t   file_info ;
       uint32_t  offset_addr;
    
       uint32_t MAX_FILE_SIZE = 32 * 1024 * 8; // maximum size of the file to download  is set to  8MB     
        
        PRINT_TEXT( "\r\n------------------------ Starting YModem file transfer to ram/ddr Memory----------\r\n" );
        PRINT_TEXT( "Please select file and initiate transfer on host computer.\r\n" );
        //file_size = ymodem_download_file_ddr( (uint8_t *)offset_addr, MAX_FILE_SIZE, &file_info);      
        file_size = ymodem_receive(g_bin_base, MAX_FILE_SIZE, file_name, LSRAM_SIZE) ;               
        PRINT_TEXT( "\r\nFile Size :  " );
        PRINT_DNUM(file_size );
        PRINT_TEXT( "\r\nFile Name :  " );
        PRINT_TEXT(file_name );

        PRINT_TEXT( "\r\nFile Transfer Completed.\r\n" );       
        return file_size;

   }


   

