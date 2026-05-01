/*******************************************************************************
 * (c) Copyright 2014-2015 Microsemi SoC Products Group.  All rights reserved.
 *
 * Register bit definitions for MII STA (station management entity) standard
 * interface. All basic MII register bits and enhanced capability register bits
 * are defined.
 * Complies with Clauses 22, 28, 37, 40 of IEEE RFC 802.3
 *
 * SVN $Revision: 7354 $
 * SVN $Date: 2015-04-23 17:45:21 +0530 (Thu, 23 Apr 2015) $
 */
#ifndef PHY_H_
#define PHY_H_

#include "coretse_types.h"

#ifdef __cplusplus
extern "C" {
#endif

/**************************************************************************/
/* Public definitions                                                     */
/**************************************************************************/

/* VSC8502 MII registers(802.3, Main). */
#define MII_BMCR                0x00u       /* Basic mode control register */
#define MII_BMSR                0x01u       /* Basic mode status register  */
#define MII_PHYSID1             0x02u       /* PHYS ID 1                   */
#define MII_PHYSID2             0x03u       /* PHYS ID 2                   */
#define MII_ADVERTISE           0x04u       /* Advertisement control reg   */
#define MII_LPA                 0x05u       /* Link partner ability reg    */
#define MII_EXPANSION           0x06u       /* Expansion register          */
#define MII_NPAR                0x07u		/* Auto Next Page Transmit	   */
#define MII_LPNPA               0x08u		/* Auto LP Next Page Receive   */
#define MII_CTRL1000            0x09u       /* 1000BASE-T control          */
#define MII_STAT1000            0x0au       /* 1000BASE-T status           */
#define MII_CLAUSE_1            0x0du       /* Clause 24 Access Registers  */
#define MII_CLAUSE_2            0x0eu       /* Clause 24 Access Registers  */
#define MII_ESTATUS             0x0fu       /* Extended Status 			   */
#define MII_STAT100				0x10u		/* 100BASE-TX Status		   */
#define MII_STAT1000_2   		0x11u		/* 1000BASE-T Status extension */
#define	MII_BYPASS				0x12u		/* Bypass Control			   */
#define	MII_ERRCNTR1			0x13u		/* Error Counter 1			   */
#define	MII_ERRCNTR2			0x14u		/* Error Counter 2			   */
#define	MII_ERRCNTR3			0x15u		/* Error Counter 3			   */
#define	MII_EXTEND       		0x16u		/* Extended control and status */
#define	MII_PHYCTRL1			0x17u		/* Extended PHY control 1 	   */
#define	MII_PHYCTRL2			0x18u		/* Extended PHY control 2 	   */
#define	MII_INTMASK 			0x19u		/* Interrupt mask		 	   */
#define	MII_INTSTAT 			0x1au		/* Interrupt status		 	   */
#define MII_RESV1               0x1bu       /* Reserved...                 */
#define	MII_AUX_CNTL_STAT		0x1cu		/* Extended control and status */
#define MII_LEDMODE				0x1du		/* LED mode select			   */
#define MII_LEDBEHAVE			0x1eu		/* LED behavior				   */
#define MII_EXTEND_REG			0x1fu		/* Extended reg page access	   */

/* *********************************************************************** */
/* Bit location Addresses - */

/* Basic mode control register. */
#define BMCR_RESV               0x003fu     /* Unused...                   */
#define BMCR_SPEED1000          0x0040u     /* MSB of Speed (1000)         */
#define BMCR_CTST               0x0080u     /* Collision test              */
#define BMCR_FULLDPLX           0x0100u     /* Full duplex                 */
#define BMCR_ANRESTART          0x0200u     /* Auto negotiation restart    */
#define BMCR_ISOLATE            0x0400u     /* Disconnect VSC8502 from MII */
#define BMCR_PDOWN              0x0800u     /* Powerdown the VSC8502       */
#define BMCR_ANENABLE           0x1000u     /* Enable auto negotiation     */
#define BMCR_SPEED100           0x2000u     /* Select 100Mbps              */
#define BMCR_LOOPBACK           0x4000u     /* TXD loopback bits           */
#define BMCR_RESET              0x8000u     /* Reset the VSC8502           */

/* Basic mode status register. */
#define BMSR_ERCAP              0x0001u     /* Ext-reg capability          */
#define BMSR_JCD                0x0002u     /* Jabber detected             */
#define BMSR_LSTATUS            0x0004u     /* Link status                 */
#define BMSR_ANEGCAPABLE        0x0008u     /* Able to do auto-negotiation */
#define BMSR_RFAULT             0x0010u     /* Remote fault detected       */
#define BMSR_ANEGCOMPLETE       0x0020u     /* Auto-negotiation complete   */
#define BMSR_PRESUPRES			0x0040u     /* Preamble suppression capable*/
#define BMSR_RESV               0x0080u     /* Unused...                   */
#define BMSR_ESTATEN            0x0100u     /* Extended Status in R15      */
#define BMSR_100HALF2           0x0200u     /* Can do 100BASE-T2 HDX       */
#define BMSR_100FULL2           0x0400u     /* Can do 100BASE-T2 FDX       */
#define BMSR_10HALF             0x0800u     /* Can do 10mbps, half-duplex  */
#define BMSR_10FULL             0x1000u     /* Can do 10mbps, full-duplex  */
#define BMSR_100HALF            0x2000u     /* Can do 100mbps, half-duplex */
#define BMSR_100FULL            0x4000u     /* Can do 100mbps, full-duplex */
#define BMSR_100BASE4           0x8000u     /* Can do 100mbps, 4k packets  */

/* Advertisement control register. */
#define ADVERTISE_SLCT          0x001fu     /* Selector bits               */
#define ADVERTISE_10HALF        0x0020u     /* Try for 10mbps half-duplex  */
#define ADVERTISE_10FULL        0x0040u     /* Try for 10mbps full-duplex  */
#define ADVERTISE_100HALF       0x0080u     /* Try for 100mbps half-duplex */
#define ADVERTISE_100FULL       0x0100u     /* Try for 100mbps full-duplex */
#define ADVERTISE_100BASE4      0x0200u     /* Try for 100mbps 4k packets  */
#define ADVERTISE_PAUSE_CAP     0x0400u     /* Try for pause               */

#define ADVERTISE_ALL (ADVERTISE_10HALF | ADVERTISE_10FULL | \
                       ADVERTISE_100HALF | ADVERTISE_100FULL)

/* Link partner ability register. */
#define LPA_SLCT                0x001fu     /* Same as advertise selector  */
#define LPA_10HALF              0x0020u     /* Can do 10mbps half-duplex   */
#define LPA_10FULL              0x0040u     /* Can do 10mbps full-duplex   */
#define LPA_100HALF             0x0080u     /* Can do 100mbps half-duplex  */
#define LPA_100FULL             0x0100u     /* Can do 100mbps full-duplex  */
#define LPA_100BASE4            0x0200u     /* Can do 100mbps 4k packets   */
#define LPA_PAUSE_CAP           0x0400u     /* Can pause                   */
#define LPA_PAUSE_ASYM          0x0800u     /* Can pause asymetrically     */
#define LPA_RESV                0x1000u     /* Unused...                   */
#define LPA_RFAULT              0x2000u     /* Link partner faulted        */
#define LPA_LPACK               0x4000u     /* Link partner acked us       */
#define LPA_NPAGE               0x8000u     /* Next page bit               */

// #define LPA_DUPLEX              (LPA_10FULL | LPA_100FULL)
// #define LPA_100                 (LPA_100FULL | LPA_100HALF | LPA_100BASE4)

/* Expansion register for auto-negotiation. */
#define EXPANSION_LPAC          0x0001u     /* Can do LP auto-nego         */
#define EXPANSION_LPAGE         0x0002u     /* Got new RX page code word   */
#define EXPANSION_ENABLENPAGE   0x0004u     /* This enables npage words    */
#define EXPANSION_NPCAPABLE     0x0008u     /* Link partner supports npage */
#define EXPANSION_PFAULTS       0x0010u     /* Parallel faults detected    */
#define EXPANSION_RESV          0xffe0u     /* Unused...                   */

/* Auto Next Page Transmit */
#define NPAR_MSG				0x007fu     /* Message / Unformatted Code  */
#define NPAR_TOGGLE				0x0080u		/* Previous transmitted LCW	   */
#define NPAR_ACK2				0x0100u		/* Complies w/ request		   */
#define NPAR_MSGPAGE			0x0200u		/* Previous transmitted LCW	   */
#define NPAR_RESV				0x0400u		/* Previous transmitted LCW	   */
#define NPAR_NXTPAGE			0x0800u		/* More pages to follow		   */

/* Auto Next Page Receive */
#define LPNPA_LPMSG				0x007fu     /* Message / Unformatted Code  */
#define LPNPA_LPTOGGLE			0x0080u		/* Previous transmitted LCW	   */
#define LPNPA_LPACK2			0x0100u		/* Complies w/ request		   */
#define LPNPA_LPMSGPAGE			0x0200u		/* Previous transmitted LCW	   */
#define LPNPA_RESV				0x0400u		/* Previous transmitted LCW	   */
#define LPNPA_LPNXTPAGE			0x0800u		/* More pages to follow		   */

/* 1000BASE-T Control register */
#define CTRL1000_RESV      		0x00ffu     /* Reserved 						*/
#define CTRL1000_HALF      		0x0100u     /* Advertise 1000BASE-T half duplex */
#define CTRL1000_FULL      		0x0200u     /* Advertise 1000BASE-T full duplex */
#define CTRL1000_PORT      		0x0400u     /* Port Type 						*/
#define CTRL1000_MSTRSLVVAL		0x0800u     /* Configure PHY as slave / master  */
#define CTRL1000_MSTRSLVCNFG	0x1000u     /* Enable PHY as slave / master     */
#define CTRL1000_TRNSTEST		0xe000u     /* Transmitter Test Mode			*/

/* 1000BASE-T Status register */
#define STAT1000_CNTR           0x000fu     /* Link partner Idle Counter 		*/
#define STAT1000_RESV           0x0030u     /* Reserved						*/
#define STAT1000_HALF           0x0040u     /* LP 1000BASE-T half duplex capable */
#define STAT1000_FULL           0x0080u     /* LP 1000BASE-T full duplex capable */
#define STAT1000_REMRXOK        0x0100u     /* LP remote receiver status 		*/
#define STAT1000_LOCALRXOK      0x0200u     /* LP local receiver status 		*/
#define STAT1000_MSTRSLVRES		0x0400u     /* Configured PHY as slave / master*/
#define STAT1000_MSTRSLVFAULY	0x0800u     /* PHY as slave / master fault     */

/* CLAUSE_1 Control register */
#define CLAUSE_1_DVAD           0x001fu     /* Device Address - IEEE802.3az	*/
#define CLAUSE_1_RESV           0x3fe0u     /* Reserved						*/
#define CLAUSE_1_FUNC           0x0040u     /* Function						*/

/* CLAUSE_2 Control register */
#define CLAUSE_2_ADDRDATA       0xffffu     /* Device Address - IEEE802.3az	*/

/* Extended Status register  */
#define ESTATUS_RESV1	        0x0fffu     /* Reserved						*/
#define ESTATUS_1000XHALF1      0x1000u     /* 1000BASE-X HDX capable		*/
#define ESTATUS_1000XFULL       0x2000u     /* 1000BASE-X FDX capable		*/
#define ESTATUS_1000XHALF2      0x4000u     /* 1000BASE-X HDX capable		*/
#define ESTATUS_RESV2	        0x8000u     /* Reserved						*/



/* Indicates what features are supported by the interface. */
#define SUPPORTED_10baseT_Half          (1 << 0)
#define SUPPORTED_10baseT_Full          (1 << 1)
#define SUPPORTED_100baseT_Half         (1 << 2)
#define SUPPORTED_100baseT_Full         (1 << 3)
#define SUPPORTED_1000baseT_Half        (1 << 4)
#define SUPPORTED_1000baseT_Full        (1 << 5)
#define SUPPORTED_Autoneg               (1 << 6)
#define SUPPORTED_TP                    (1 << 7)
#define SUPPORTED_AUI                   (1 << 8)
#define SUPPORTED_MII                   (1 << 9)
#define SUPPORTED_FIBRE                 (1 << 10)
#define SUPPORTED_BNC                   (1 << 11)
#define SUPPORTED_10000baseT_Full       (1 << 12)
#define SUPPORTED_Pause                 (1 << 13)
#define SUPPORTED_Asym_Pause            (1 << 14)
#define SUPPORTED_2500baseX_Full        (1 << 15)
#define SUPPORTED_Backplane             (1 << 16)
#define SUPPORTED_1000baseKX_Full       (1 << 17)
#define SUPPORTED_10000baseKX4_Full     (1 << 18)
#define SUPPORTED_10000baseKR_Full      (1 << 19)
#define SUPPORTED_10000baseR_FEC        (1 << 20)

/* Indicates what features are advertised by the interface. */
#define ADVERTISED_10baseT_Half         (1 << 0)
#define ADVERTISED_10baseT_Full         (1 << 1)
#define ADVERTISED_100baseT_Half        (1 << 2)
#define ADVERTISED_100baseT_Full        (1 << 3)
#define ADVERTISED_1000baseT_Half       (1 << 4)
#define ADVERTISED_1000baseT_Full       (1 << 5)
#define ADVERTISED_Autoneg              (1 << 6)
#define ADVERTISED_TP                   (1 << 7)
#define ADVERTISED_AUI                  (1 << 8)
#define ADVERTISED_MII                  (1 << 9)
#define ADVERTISED_FIBRE                (1 << 10)
#define ADVERTISED_BNC                  (1 << 11)
#define ADVERTISED_10000baseT_Full      (1 << 12)
#define ADVERTISED_Pause                (1 << 13)
#define ADVERTISED_Asym_Pause           (1 << 14)
#define ADVERTISED_2500baseX_Full       (1 << 15)
#define ADVERTISED_Backplane            (1 << 16)
#define ADVERTISED_1000baseKX_Full      (1 << 17)
#define ADVERTISED_10000baseKX4_Full    (1 << 18)
#define ADVERTISED_10000baseKR_Full     (1 << 19)
#define ADVERTISED_10000baseR_FEC       (1 << 20)

/**************************************************************************/
/* Public function declarations                                           */
/**************************************************************************/

/***************************************************************************//**

 */
void TSE_phy_init(tse_instance_t * this_tse, uint8_t phy_addr);

/***************************************************************************//**

 */
void TSE_phy_set_link_speed(tse_instance_t * this_tse, uint8_t phy_addr, uint32_t speed_duplex_select);

/***************************************************************************//**

 */
void TSE_phy_autonegotiate(tse_instance_t * this_tse, uint8_t phy_addr);

/***************************************************************************//**

 */
uint8_t TSE_phy_get_link_status
(
    tse_instance_t * this_tse,
    uint8_t phy_addr,
    tse_speed_t * speed,
    uint8_t * fullduplex
);

#ifdef __cplusplus
}
#endif

#endif /* PHY_H_ */
