# lwip specific


LWIPDIR    ?= middleware/ethernet/lwip/src
CONTRIBDIR ?= middleware/ethernet/lwip/contrib


#basic LWIP Defines for RV32

USER_FLAGS += -D LWIP_COMPAT_MUTEX \
			  -D LWIP_COMPAT_MUTEX_ALLOWED \
			  -D LWIP_PROVIDE_ERRNO


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



CONTRIBAPPFILES= \
            	$(CONTRIBDIR)/apps/chargen/chargen.c \
            	$(CONTRIBDIR)/apps/httpserver/httpserver-netconn.c \
            	$(CONTRIBDIR)/apps/netbios/netbios.c \
            	$(CONTRIBDIR)/apps/netio/netio.c \
            	$(CONTRIBDIR)/apps/ping/ping.c \
            	$(CONTRIBDIR)/apps/rtp/rtp.c \
            	$(CONTRIBDIR)/apps/shell/shell.c \
            	$(CONTRIBDIR)/apps/snmp_private_mib/lwip_prvmib.c \
            	$(CONTRIBDIR)/apps/sntp/sntp.c \
            	$(CONTRIBDIR)/apps/socket_examples/socket_examples.c \
            	$(CONTRIBDIR)/apps/tcpecho/tcpecho.c \
            	$(CONTRIBDIR)/apps/tcpecho_raw/echo.c \
            	$(CONTRIBDIR)/apps/udpecho/udpecho.c
            	
            	
	
	
	
#	$(CONTRIBDIR)/examples/httpd/fs_example/fs_example.c \
	$(CONTRIBDIR)/examples/httpd/https_example/https_example.c \
	$(CONTRIBDIR)/examples/httpd/ssi_example/ssi_example.c \
	$(CONTRIBDIR)/examples/lwiperf/lwiperf_example.c \
	$(CONTRIBDIR)/examples/mdns/mdns_example.c \
	$(CONTRIBDIR)/examples/mqtt/mqtt_example.c \
	$(CONTRIBDIR)/examples/ppp/pppos_example.c \
	$(CONTRIBDIR)/examples/snmp/snmp_private_mib/lwip_prvmib.c \
	$(CONTRIBDIR)/examples/snmp/snmp_v3/snmpv3_dummy.c \
	$(CONTRIBDIR)/examples/snmp/snmp_example.c \
	$(CONTRIBDIR)/examples/sntp/sntp_example.c \
	$(CONTRIBDIR)/examples/tftp/tftp_example.c \
	$(CONTRIBDIR)/addons/tcp_isn/tcp_isn.c \
	$(CONTRIBDIR)/addons/ipv6_static_routing/ip6_route_table.c


# LWIPNOAPPSFILES: All LWIP files without apps
LWIPNOAPPSFILES=$(COREFILES) \
            	$(CORE4FILES) \
            	$(APIFILES) \
            	$(NETIFFILES) \
            	$(PPPFILES) \
            	$(SNMPFILES) 
            	
 #$(CORE6FILES)           	

LWIP_PORT_FILES = $(CONTRIBDIR)/ports/miv-rv32/sys_arch.c

		  
INCS += -I $(LWIPDIR) \
		     -I $(LWIPDIR)/include \
		     -I $(LWIPDIR)/include/ipv4 \
		     -I $(LWIPDIR)/include/ipv6 \
		     -I $(CONTRIBDIR)/ports/miv-rv32
		     
INCS += -I $(CONTRIBDIR)/apps/httpserver
		   
C_SRCS += $(LWIPNOAPPSFILES) $(LWIP_PORT_FILES) $(CONTRIBAPPFILES)