# lwip specific


#LWIPDIR    ?= src/middleware/ethernet/lwip/src
#CONTRIBDIR ?= src/middleware/ethernet/lwip/contrib


#--------------------
#------- For Core TSE Driver ----------
#-----------------------------------
ifneq (,$(findstring CORE_TSE,$(USER_FLAGS)))
C_SRCS += $(CONTRIBDIR)/ports/miv-rv32/netif/coretse_ethernetif.c 
endif

# COREFILES, CORE4FILES: The minimum set of files needed for lwIP.
COREFILES = $(LWIPDIR)/core/def.c \
        	$(LWIPDIR)/core/dhcp.c \
        	$(LWIPDIR)/core/dns.c \
        	$(LWIPDIR)/core/init.c \
        	$(LWIPDIR)/core/mem.c \
        	$(LWIPDIR)/core/memp.c \
        	$(LWIPDIR)/core/netif.c \
        	$(LWIPDIR)/core/pbuf.c \
        	$(LWIPDIR)/core/raw.c \
        	$(LWIPDIR)/core/stats.c \
        	$(LWIPDIR)/core/sys.c \
        	$(LWIPDIR)/core/tcp_in.c \
        	$(LWIPDIR)/core/tcp_out.c \
        	$(LWIPDIR)/core/tcp.c \
        	$(LWIPDIR)/core/udp.c\
        	$(LWIPDIR)/core/lwip_timers.c

#$(LWIPDIR)/core/timers.c


CORE4FILES =$(LWIPDIR)/core/ipv4/autoip.c \
        	$(LWIPDIR)/core/ipv4/icmp.c \
        	$(LWIPDIR)/core/ipv4/igmp.c \
        	$(LWIPDIR)/core/ipv4/inet_chksum.c \
        	$(LWIPDIR)/core/ipv4/inet.c \
        	$(LWIPDIR)/core/ipv4/ip_addr.c \
        	$(LWIPDIR)/core/ipv4/ip_frag.c \
        	$(LWIPDIR)/core/ipv4/ip.c 
        	
CORE6FILES =$(LWIPDIR)/core/ipv6/icmp6.c \
        	$(LWIPDIR)/core/ipv6/inet6.c \
        	$(LWIPDIR)/core/ipv6/ip6_addr.c \
        	$(LWIPDIR)/core/ipv6/ip6.c

# SNMPFILES: SNMPv2c agent
SNMPFILES=  $(LWIPDIR)/core/snmp/asn1_dec.c \
        	$(LWIPDIR)/core/snmp/asn1_enc.c \
        	$(LWIPDIR)/core/snmp/mib_structs.c \
        	$(LWIPDIR)/core/snmp/mib2.c \
        	$(LWIPDIR)/core/snmp/msg_in.c \
        	$(LWIPDIR)/core/snmp/msg_out.c
	
# APIFILES: The files which implement the sequential and socket APIs.
APIFILES=   $(LWIPDIR)/api/api_lib.c \
        	$(LWIPDIR)/api/api_msg.c \
        	$(LWIPDIR)/api/err.c \
        	$(LWIPDIR)/api/netbuf.c \
        	$(LWIPDIR)/api/netdb.c \
        	$(LWIPDIR)/api/netifapi.c \
        	$(LWIPDIR)/api/sockets.c \
        	$(LWIPDIR)/api/tcpip.c



# NETIFFILES: Files implementing various generic network interface functions
NETIFFILES= $(LWIPDIR)/netif/ethernetif.c \
        	$(LWIPDIR)/netif/etharp.c \
        	$(LWIPDIR)/netif/slipif.c


PPPFILES=   $(LWIPDIR)/netif/ppp/auth.c \
        	$(LWIPDIR)/netif/ppp/chap.c \
        	$(LWIPDIR)/netif/ppp/chpms.c \
        	$(LWIPDIR)/netif/ppp/fsm.c \
        	$(LWIPDIR)/netif/ppp/ipcp.c \
        	$(LWIPDIR)/netif/ppp/lcp.c \
        	$(LWIPDIR)/netif/ppp/magic.c \
        	$(LWIPDIR)/netif/ppp/md5.c \
        	$(LWIPDIR)/netif/ppp/pap.c \
        	$(LWIPDIR)/netif/ppp/ppp_oe.c \
        	$(LWIPDIR)/netif/ppp/ppp.c \
        	$(LWIPDIR)/netif/ppp/randm.c \
        	$(LWIPDIR)/netif/ppp/vj.c


# LWIPNOAPPSFILES: All LWIP files without apps
LWIPNOAPPSFILES=$(COREFILES) \
            	$(CORE4FILES) \
            	$(APIFILES) \
            	$(NETIFFILES) \
            	$(PPPFILES) \
            	$(SNMPFILES) 
            	
 #$(CORE6FILES)           	

LWIP_PORT_FILES = $(LWIPDIR)/port/miv-rv32/sys_arch.c

		  
LWIP_INCS ?= -I $(LWIPDIR) \
		     -I $(LWIPDIR)/include \
		     -I $(LWIPDIR)/include/ipv4 \
		     -I $(LWIPDIR)/include/ipv6 \
		     -I $(CONTRIBDIR)/ports/miv-rv32
		   
C_SRCS += $(LWIPNOAPPSFILES) $(LWIP_PORT_FILES) 