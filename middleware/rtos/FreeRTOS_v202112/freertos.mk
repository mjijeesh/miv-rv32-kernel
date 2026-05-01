

RTOS_HOME ?= middleware/rtos/FreeRTOS_v202112

# FreeRTOS RISC-V  specific
C_SRCS += $(wildcard $(RTOS_HOME)/FreeRTOS/Source/portable/GCC/RISC-V/*.c)
#C_SRCS += $(RTOS_HOME)/FreeRTOS/Source/portable/GCC/ARM_CM3/portASM.S
#C_SRCS += $(RTOS_HOME)/FreeRTOS/Source/portable/GCC/RISC-V/port.c


ASM_SRCS += $(RTOS_HOME)/FreeRTOS/Source/portable/GCC/RISC-V/portASM.S


INCS  += -I $(RTOS_HOME)/FreeRTOS/Source/portable/GCC/RISC-V/chip_specific_extensions/RV32I_CLINT_no_extensions
INCS  += -I $(RTOS_HOME)/FreeRTOS/Source/portable/GCC/RISC-V
INCS  += -I $(RTOS_HOME)/FreeRTOS/Source/include

# FreeRTOS core
C_SRCS += $(wildcard $(RTOS_HOME)/FreeRTOS/Source/*.c)
C_SRCS += $(wildcard $(RTOS_HOME)/FreeRTOS/Source/portable/MemMang/heap_4.c)

INCS += -I $(RTOS_HOME)/FreeRTOS/Demo/Common/include



#-----------------------------------------------------------
# FreeRTOS sources for the full_demo
#-----------------------------------------------------------

ifneq (,$(findstring FREERTOS_DEMO_FULL,$(USER_FLAGS)))
C_SRCS += $(RTOS_HOME)/FreeRTOS/Demo/Common/Minimal/blocktim.c
C_SRCS += $(RTOS_HOME)/FreeRTOS/Demo/Common/Minimal/dynamic.c
C_SRCS += $(RTOS_HOME)/FreeRTOS/Demo/Common/Minimal/EventGroupsDemo.c
C_SRCS += $(RTOS_HOME)/FreeRTOS/Demo/Common/Minimal/GenQTest.c
C_SRCS += $(RTOS_HOME)/FreeRTOS/Demo/Common/Minimal/recmutex.c
C_SRCS += $(RTOS_HOME)/FreeRTOS/Demo/Common/Minimal/TaskNotify.c
C_SRCS += $(RTOS_HOME)/FreeRTOS/Demo/Common/Minimal/TaskNotifyArray.c
C_SRCS += $(RTOS_HOME)/FreeRTOS/Demo/Common/Minimal/TimerDemo.c
C_SRCS += $(RTOS_HOME)/FreeRTOS/Demo/Common/Minimal/countsem.c
C_SRCS += $(RTOS_HOME)/FreeRTOS/Demo/Common/Minimal/QueueOverwrite.c
C_SRCS += $(RTOS_HOME)/FreeRTOS/Demo/Common/Minimal/QueueSet.c
C_SRCS += $(RTOS_HOME)/FreeRTOS/Demo/Common/Minimal/QPeek.c
C_SRCS += $(RTOS_HOME)/FreeRTOS/Demo/Common/Minimal/integer.c
C_SRCS += $(RTOS_HOME)/FreeRTOS/Demo/Common/Minimal/BlockQ.c
C_SRCS += $(RTOS_HOME)/FreeRTOS/Demo/Common/Minimal/PollQ.c
C_SRCS += $(RTOS_HOME)/FreeRTOS/Demo/Common/Minimal/semtest.c
C_SRCS += $(RTOS_HOME)/FreeRTOS/Demo/Common/Minimal/flash_timer.c
C_SRCS += $(RTOS_HOME)/FreeRTOS/Demo/Common/Minimal/death.c

C_SRCS += $(RTOS_HOME)/FreeRTOS/Demo/Common/Minimal/AbortDelay.c
C_SRCS += $(RTOS_HOME)/FreeRTOS/Demo/Common/Minimal/MessageBufferDemo.c
C_SRCS += $(RTOS_HOME)/FreeRTOS/Demo/Common/Minimal/StreamBufferDemo.c
C_SRCS += $(RTOS_HOME)/FreeRTOS/Demo/Common/Minimal/StreamBufferInterrupt.c

endif




# -----------------
# FreeRTOS-Plus-CLI
# -----------------
ifneq (,$(findstring FREERTOS_PLUS_CLI,$(USER_FLAGS)))
C_SRCS += $(RTOS_HOME)/FreeRTOS-Plus/Source/FreeRTOS-Plus-CLI/FreeRTOS_CLI.c
INCS += -I $(RTOS_HOME)/FreeRTOS-Plus/Source/FreeRTOS-Plus-CLI
endif



# -----------------
# FreeRTOS-Plus-TCP
# -----------------
ifneq (,$(findstring FREERTOS_PLUS_TCP,$(USER_FLAGS)))
C_SRCS += $(RTOS_HOME)/FreeRTOS-Plus/Source/FreeRTOS-Plus-TCP/FreeRTOS_ARP.c
C_SRCS += $(RTOS_HOME)/FreeRTOS-Plus/Source/FreeRTOS-Plus-TCP/FreeRTOS_DHCP.c
C_SRCS += $(RTOS_HOME)/FreeRTOS-Plus/Source/FreeRTOS-Plus-TCP/FreeRTOS_DNS.c
C_SRCS += $(RTOS_HOME)/FreeRTOS-Plus/Source/FreeRTOS-Plus-TCP/FreeRTOS_IP.c
C_SRCS += $(RTOS_HOME)/FreeRTOS-Plus/Source/FreeRTOS-Plus-TCP/FreeRTOS_Sockets.c
C_SRCS += $(RTOS_HOME)/FreeRTOS-Plus/Source/FreeRTOS-Plus-TCP/FreeRTOS_Stream_Buffer.c
C_SRCS += $(RTOS_HOME)/FreeRTOS-Plus/Source/FreeRTOS-Plus-TCP/FreeRTOS_TCP_IP.c
C_SRCS += $(RTOS_HOME)/FreeRTOS-Plus/Source/FreeRTOS-Plus-TCP/FreeRTOS_TCP_WIN.c
C_SRCS += $(RTOS_HOME)/FreeRTOS-Plus/Source/FreeRTOS-Plus-TCP/FreeRTOS_UDP_IP.c

INCS += -I $(RTOS_HOME)/FreeRTOS-Plus/Source/FreeRTOS-Plus-TCP/include
INCS += -I $(RTOS_HOME)/FreeRTOS-Plus/Source/FreeRTOS-Plus-TCP/portable/Compiler/GCC
endif
