# lwip specific

LWIP_HOME ?= middleware/tcpip/lwip

C_SRCS += \
        $(LWIP_HOME)/api/api_lib.c \
        $(LWIP_HOME)/api/api_msg.c \
        $(LWIP_HOME)/api/err.c \
        $(LWIP_HOME)/api/netbuf.c \
        $(LWIP_HOME)/api/netdb.c \
        $(LWIP_HOME)/api/netifapi.c \
        $(LWIP_HOME)/api/sockets.c \
        $(LWIP_HOME)/api/tcpip.c 


C_SRCS += \
        $(LWIP_HOME)/core/def.c \
        $(LWIP_HOME)/core/dhcp.c \
        $(LWIP_HOME)/core/dns.c \
        $(LWIP_HOME)/core/init.c \
        $(LWIP_HOME)/core/lwip_timers.c \
        $(LWIP_HOME)/core/mem.c \
        $(LWIP_HOME)/core/memp.c \
        $(LWIP_HOME)/core/netif.c \
        $(LWIP_HOME)/core/pbuf.c \
        $(LWIP_HOME)/core/raw.c \
        $(LWIP_HOME)/core/stats.c \
        $(LWIP_HOME)/core/sys.c \
        $(LWIP_HOME)/core/tcp.c \
        $(LWIP_HOME)/core/tcp_in.c \
        $(LWIP_HOME)/core/tcp_out.c \
        $(LWIP_HOME)/core/udp.c 


C_SRCS += \
        $(LWIP_HOME)/core/ipv4/autoip.c \
        $(LWIP_HOME)/core/ipv4/icmp.c \
        $(LWIP_HOME)/core/ipv4/igmp.c \
        $(LWIP_HOME)/core/ipv4/inet.c \
        $(LWIP_HOME)/core/ipv4/inet_chksum.c \
        $(LWIP_HOME)/core/ipv4/ip.c \
        $(LWIP_HOME)/core/ipv4/ip_addr.c \
        $(LWIP_HOME)/core/ipv4/ip_frag.c 
        
 
C_SRCS += \
        $(LWIP_HOME)/core/snmp/asn1_dec.c \
        $(LWIP_HOME)/core/snmp/asn1_enc.c \
        $(LWIP_HOME)/core/snmp/mib2.c \
        $(LWIP_HOME)/core/snmp/mib_structs.c \
        $(LWIP_HOME)/core/snmp/msg_in.c \
        $(LWIP_HOME)/core/snmp/msg_out.c  
        
C_SRCS += \
        $(LWIP_HOME)/netif/etharp.c \
        $(LWIP_HOME)/netif/coretse_ethernetif.c \
        $(LWIP_HOME)/netif/ethernetif.c \
        $(LWIP_HOME)/netif/slipif.c     
        
C_SRCS += \
        $(LWIP_HOME)/netif/ppp/auth.c \
        $(LWIP_HOME)/netif/ppp/chap.c \
        $(LWIP_HOME)/netif/ppp/chpms.c \
        $(LWIP_HOME)/netif/ppp/fsm.c \
        $(LWIP_HOME)/netif/ppp/ipcp.c \
        $(LWIP_HOME)/netif/ppp/lcp.c \
        $(LWIP_HOME)/netif/ppp/magic.c \
        $(LWIP_HOME)/netif/ppp/md5.c \
        $(LWIP_HOME)/netif/ppp/pap.c \
        $(LWIP_HOME)/netif/ppp/ppp.c \
        $(LWIP_HOME)/netif/ppp/ppp_oe.c \
        $(LWIP_HOME)/netif/ppp/randm.c \
        $(LWIP_HOME)/netif/ppp/vj.c 

C_SRCS += \
		$(LWIP_HOME)/port/FreeRTOS/M2SXXX/sys_arch.c 

		  
INCS +=    -I $(LWIP_HOME) \
		   -I $(LWIP_HOME)/include \
		   -I $(LWIP_HOME)/include/ipv4  \
		   -I $(LWIP_HOME)/port/FreeRTOS/M2SXXX
		   
INCS +=	   -I $(LWIP_HOME)/port/FreeRTOS/M2SXXX/arch \
		   -I $(LWIP_HOME)/api \
           -I $(LWIP_HOME)/core \
           -I $(LWIP_HOME)/core/ipv4 \
           -I $(LWIP_HOME)/core/snmp \
           -I $(LWIP_HOME)/netif \
           -I $(LWIP_HOME)/netif/ppp 
            