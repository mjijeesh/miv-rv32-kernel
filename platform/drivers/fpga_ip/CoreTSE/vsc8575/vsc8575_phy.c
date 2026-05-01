/*******************************************************************************
 * (c) Copyright 2014-2016 Microsemi SoC Products Group.  All rights reserved.
 *
 * Marvell's M88E1340 PHY interface driver implementation.
 *
 * SVN $Revision: 8432 $
 * SVN $Date: 2016-06-20 15:56:50 +0530 (Mon, 20 Jun 2016) $
 */
#include "phy.h"
#include "core_tse.h"
#include "coretse_regs.h"
#include "hal.h"
#include "hal_assert.h"

#include "fpga_design_config/fpga_design_config.h"



#ifdef __cplusplus
extern "C" {
#endif

/***************************************************************************//**
 * VSC8575 PHY specific register offsets and bit definitions
 */

#define PAGE_0                                  0x00

#define VSC8575_PHY_STATUS_1000                0x0010
#define VSC8575_PHY_STATUS_100                 0x0008
#define VSC8575_PHY_STATUS_10                  0x0000
#define VSC8575_PHY_STATUS_SPD_MASK            0x0018
#define VSC8575_PHY_STATUS_FULLDUPLEX          0x0020

/***************************************************************************//**
 * Preprocessor Macros
 */
#define BMSR_AUTO_NEGOTIATION_COMPLETE          0x0020u

/***************************************************************************//**
 *
 */
void
TSE_phy_init
(
    tse_instance_t * this_tse,
    uint8_t phy_addr
)
{
#if 0
	volatile uint16_t phy_reg;

    /* Reset the PHY. */
    phy_reg = TSE_read_phy_reg(this_tse, phy_addr, MII_BMCR);
    phy_reg |= BMCR_RESET;
    TSE_write_phy_reg(this_tse, phy_addr, MII_BMCR, phy_reg);

    /* Power up the PHY. */
    phy_reg = TSE_read_phy_reg(this_tse, phy_addr, MII_BMCR);
    phy_reg &= ~BMCR_PDOWN;
    TSE_write_phy_reg(this_tse, phy_addr, MII_BMCR, phy_reg);
#endif
    volatile uint16_t phy_reg_0;
      volatile uint16_t temp;
      volatile uint16_t  id1=0,id2=0,phy_mac_reg = 0;


      //writing coreSTE MDIO Mgmt: Address  with phy address 0x1C and phy internal address 02(PHY identifier 1) :0x1c02
      *(volatile unsigned int *) (TSEMAC_BASE + 0x028) = 0x1C02; //
      *(volatile unsigned int *) (TSEMAC_BASE + 0x024) = 0x1;//coreSTE MDIO Mgmt: Command  : passing 1 for single read cycle
      while ((*(volatile unsigned int *) (TSEMAC_BASE + 0x034)) != 0); // waiting for MDIO Mgmt block  busy

      id1 = *(volatile unsigned int *) (TSEMAC_BASE + 0x030); //PHY identifier 1 read from VSC PHY
      *(volatile unsigned int *) (TSEMAC_BASE + 0x024) = 0x0;

      //writing coreSTE MDIO Mgmt: Address  with phy address 0x1C and phy internal address 03(PHY identifier 2) :0x1c03
      *(volatile unsigned int *) (TSEMAC_BASE + 0x028) = 0x1C03;
      *(volatile unsigned int *) (TSEMAC_BASE + 0x024) = 0x1; //coreSTE MDIO Mgmt: Command  : passing 1 for single read cycle
      while ((*(volatile unsigned int *) (TSEMAC_BASE + 0x034)) != 0); // waiting for MDIO Mgmt block  busy

      id2 = *(volatile unsigned int *) (TSEMAC_BASE + 0x030); //PHY identifier 2 read from VSC PHY
      *(volatile unsigned int *) (TSEMAC_BASE + 0x024) = 0x0;

//for extended register page access  configure address 31 0x1F to 0x3 to access extended page 3 registers
      *(volatile unsigned int *) (TSEMAC_BASE + 0x028) = 0x1C1F;
      *(volatile unsigned int *) (TSEMAC_BASE + 0x02C) = 0x0003; // writing 3 to MDIO Mgmt: control
      while ((*(volatile unsigned int *) (TSEMAC_BASE + 0x034)) != 0); // waiting for MDIO Mgmt block  busy


      /* 16E3 bit 7 setting to 1 for SERDES MAC AN EN */ // 16E3 means address 16 extended page 3 so 0x1F should be written with 3 . we did that previously
      //writing coreSTE MDIO Mgmt: Address  with phy address 0x1C and phy internal address 10 :  0x1c10
      *(volatile unsigned int *) (TSEMAC_BASE + 0x028) = 0x1C10;  //
      *(volatile unsigned int *) (TSEMAC_BASE + 0x024) = 0x1;  // coreSTE MDIO Mgmt: Command  : passing 1 for single read cycle
      while ((*(volatile unsigned int *) (TSEMAC_BASE + 0x034)) != 0); // waiting for MDIO Mgmt block  busy

      phy_mac_reg = *(volatile unsigned int *) (TSEMAC_BASE + 0x030); // read from the VSCPHY from CoreTSE MDIO Mgmt: Status
      *(volatile unsigned int *) (TSEMAC_BASE + 0x024) = 0x0;   //coreSTE MDIO Mgmt: Command  : passing 0 default , no reading from VSC PHY

      phy_mac_reg |= 0x80;  // making 7th bit to 1 to make  MAC autonegotiation enable 133 page of VSC 8575 DS

        *(volatile unsigned int *) (TSEMAC_BASE + 0x028) = 0x1C10;
      *(volatile unsigned int *) (TSEMAC_BASE + 0x02C) = phy_mac_reg;
      while ((*(volatile unsigned int *) (TSEMAC_BASE + 0x034)) != 0);


      /* Set Register 31 to 0 */
      *(volatile unsigned int *) (TSEMAC_BASE + 0x028) = 0x1C1F;
      *(volatile unsigned int *) (TSEMAC_BASE + 0x02C) = 0x0010;
      while ((*(volatile unsigned int *) (TSEMAC_BASE + 0x034)) != 0);

     // configure 18G for MAC on all PHY writes( SGMII:0x80F0)  // 99page in vsc DS
      phy_mac_reg = 0x80F0;
      *(volatile unsigned int *) (TSEMAC_BASE + 0x028) = 0x1C12;
      *(volatile unsigned int *) (TSEMAC_BASE + 0x02C) = phy_mac_reg;
      while ((*(volatile unsigned int *) (TSEMAC_BASE + 0x034)) != 0);

      // read register 18G until bit 15 equals 0
      while(1)
      {
        *(volatile unsigned int *) (TSEMAC_BASE + 0x028) = 0x1C12;
        *(volatile unsigned int *) (TSEMAC_BASE + 0x024) = 0x1;
        while ((*(volatile unsigned int *) (TSEMAC_BASE + 0x034)) != 0);

        temp = *(volatile unsigned int *) (TSEMAC_BASE + 0x030);
        *(volatile unsigned int *) (TSEMAC_BASE + 0x024) = 0x0;

        if((temp & 0x8000) == 0)
        {
          break;
        }
      }

//apply sw reset
      //extended register access must be 0
      *(volatile unsigned int *) (TSEMAC_BASE + 0x028) = 0x1C1F;
      *(volatile unsigned int *) (TSEMAC_BASE + 0x02C) = 0x0;
      while ((*(volatile unsigned int *) (TSEMAC_BASE + 0x034)) != 0);
//read register 0
      *(volatile unsigned int *) (TSEMAC_BASE + 0x028) = 0x1C00;
      *(volatile unsigned int *) (TSEMAC_BASE + 0x024) = 0x1;
      while ((*(volatile unsigned int *) (TSEMAC_BASE + 0x034)) != 0);

      phy_reg_0 = *(volatile unsigned int *) (TSEMAC_BASE + 0x030);
      *(volatile unsigned int *) (TSEMAC_BASE + 0x024) = 0x0;
//set bit 15 to 1
      phy_reg_0 = phy_reg_0 | 0x8000;
      *(volatile unsigned int *) (TSEMAC_BASE + 0x028) = 0x1C00;
      *(volatile unsigned int *) (TSEMAC_BASE + 0x02C) = phy_reg_0;
      while ((*(volatile unsigned int *) (TSEMAC_BASE + 0x034)) != 0);
//read register 0 until bit 15 equals 0
      while(1)
      {
        *(volatile unsigned int *) (TSEMAC_BASE + 0x028) = 0x1C00;
        *(volatile unsigned int *) (TSEMAC_BASE + 0x024) = 0x1;
        while ((*(volatile unsigned int *) (TSEMAC_BASE + 0x034)) != 0);

        temp = *(volatile unsigned int *) (TSEMAC_BASE + 0x030);
        *(volatile unsigned int *) (TSEMAC_BASE + 0x024) = 0x0;
        if((temp & 0x8000) == 0)
        {
          break;
        }
      }

    #if 0 // phy loopback far end checking code

      *(volatile unsigned int *) (TSEMAC_BASE + 0x028) = 0x1C17;
      *(volatile unsigned int *) (TSEMAC_BASE + 0x024) = 0x1;
      while ((*(volatile unsigned int *) (TSEMAC_BASE + 0x034)) != 0);

      phy_reg_0 = *(volatile unsigned int *) (TSEMAC_BASE + 0x030);
      *(volatile unsigned int *) (TSEMAC_BASE + 0x024) = 0x0;

      phy_reg_0 = phy_reg_0 | 0x8;

      *(volatile unsigned int *) (TSEMAC_BASE + 0x028) = 0x1C17;
      *(volatile unsigned int *) (TSEMAC_BASE + 0x02C) = phy_reg_0;
      while ((*(volatile unsigned int *) (TSEMAC_BASE + 0x034)) != 0);

    #endif
}

/**************************************************************************//**
 *
 */
void
TSE_phy_set_link_speed
(
    tse_instance_t * this_tse,
    uint8_t phy_addr,
    uint32_t speed_duplex_select
)
{
    uint16_t phy_reg;
    uint32_t inc;
    uint32_t speed_select;
    uint16_t const mii_advertise_bits[4] = {ADVERTISE_10FULL, ADVERTISE_10HALF,
                                            ADVERTISE_100FULL, ADVERTISE_100HALF};

    /* Set 10Mbps and 100Mbps advertisement. */
    phy_reg = TSE_read_phy_reg(this_tse, phy_addr, MII_ADVERTISE);
    phy_reg &= ~(ADVERTISE_10HALF | ADVERTISE_10FULL |
                 ADVERTISE_100HALF | ADVERTISE_100FULL);

    speed_select = speed_duplex_select;
    for(inc = 0u; inc < 4u; ++inc)
    {
        uint32_t advertise;
        advertise = speed_select & 0x00000001u;
        if(advertise != 0u)
        {
            phy_reg |= mii_advertise_bits[inc];
        }
        speed_select = speed_select >> 1u;
    }

    TSE_write_phy_reg(this_tse, phy_addr, MII_ADVERTISE, phy_reg);

    /* Set 1000Mbps advertisement. */
    phy_reg = TSE_read_phy_reg(this_tse, phy_addr, MII_CTRL1000);
    phy_reg &= ~(CTRL1000_FULL | CTRL1000_HALF);

    if((speed_duplex_select & TSE_ANEG_1000M_FD) != 0u)
    {
        phy_reg |= CTRL1000_FULL;
    }

    if((speed_duplex_select & TSE_ANEG_1000M_HD) != 0u)
    {
        phy_reg |= CTRL1000_HALF;
    }

    TSE_write_phy_reg(this_tse, phy_addr, MII_CTRL1000, phy_reg);
}

/**************************************************************************//**
 *
 */
void
TSE_phy_autonegotiate
(
    tse_instance_t * this_tse,
    uint8_t phy_addr
)
{
#if 0
    volatile uint16_t phy_reg;
    uint16_t autoneg_complete;
    uint32_t volatile copper_aneg_timeout = 1000000u;

    /* Enable auto-negotiation. */
    TSE_write_phy_reg(this_tse, phy_addr, M88E1340_EXT_ADDR_PAGE_CR, PAGE_0);

    phy_reg = TSE_read_phy_reg(this_tse, phy_addr, MII_BMCR);
    phy_reg |= (BMCR_ANENABLE | BMCR_ANRESTART);
    TSE_write_phy_reg(this_tse, phy_addr, MII_BMCR, phy_reg);

    /* Wait for copper auto-negotiation to complete. */
    do
    {
        phy_reg = TSE_read_phy_reg(this_tse, phy_addr, MII_BMSR);
        autoneg_complete = phy_reg & BMSR_AUTO_NEGOTIATION_COMPLETE;
        --copper_aneg_timeout;
    } while((!autoneg_complete  && copper_aneg_timeout != 0u) || (0xFFFF == phy_reg));

    {
        volatile uint32_t delay = 40000000 / 256u;
        while(delay != 0)
        {
            --delay;
        }
    }
#endif
    uint32_t phy_reg = 0xFFFF;
      uint16_t autoneg_complete;
      volatile uint32_t copper_aneg_timeout = 1000000u;
      volatile uint32_t sgmii_aneg_timeout = 100000u;
      uint8_t copper_link_up;

      *(volatile unsigned int *) (TSEMAC_BASE + 0x028) = 0x1C1F;
      *(volatile unsigned int *) (TSEMAC_BASE + 0x02C) = 0x0;
      while ((*(volatile unsigned int *) (TSEMAC_BASE + 0x034)) != 0);

      *(volatile unsigned int *) (TSEMAC_BASE + 0x028) = 0x1C00;
      *(volatile unsigned int *) (TSEMAC_BASE + 0x024) = 0x1;
      while ((*(volatile unsigned int *) (TSEMAC_BASE + 0x034)) != 0);

      phy_reg = *(volatile unsigned int *) (TSEMAC_BASE + 0x030);
      *(volatile unsigned int *) (TSEMAC_BASE + 0x024) = 0x0;

      phy_reg |= 0x1200;

      *(volatile unsigned int *) (TSEMAC_BASE + 0x028) = 0x1C00;
      *(volatile unsigned int *) (TSEMAC_BASE + 0x02C) = phy_reg;
      while ((*(volatile unsigned int *) (TSEMAC_BASE + 0x034)) != 0);

      do {
        *(volatile unsigned int *) (TSEMAC_BASE + 0x028) = 0x1C01;
        *(volatile unsigned int *) (TSEMAC_BASE + 0x024) = 0x1;
        while ((*(volatile unsigned int *) (TSEMAC_BASE + 0x034)) != 0);

        phy_reg = *(volatile unsigned int *) (TSEMAC_BASE + 0x030);
        *(volatile unsigned int *) (TSEMAC_BASE + 0x024) = 0x0;

        autoneg_complete = phy_reg & 0x0020u;
        --copper_aneg_timeout;
      } while(!autoneg_complete && (copper_aneg_timeout != 0u));

      for (volatile uint32_t i = 0; i < 100000; i++);

      *(volatile unsigned int *) (TSEMAC_BASE + 0x028) = 0x1C01;
      *(volatile unsigned int *) (TSEMAC_BASE + 0x024) = 0x1;
      while ((*(volatile unsigned int *) (TSEMAC_BASE + 0x034)) != 0);

      phy_reg = *(volatile unsigned int *) (TSEMAC_BASE + 0x030);
      *(volatile unsigned int *) (TSEMAC_BASE + 0x024) = 0x0;

      copper_link_up = phy_reg & 0x0004;

      if(copper_link_up != 0u)
      {
        *(volatile unsigned int *) (TSEMAC_BASE + 0x028) = 0x1200;
        *(volatile unsigned int *) (TSEMAC_BASE + 0x024) = 0x1;
        while ((*(volatile unsigned int *) (TSEMAC_BASE + 0x034)) != 0);

        phy_reg = *(volatile unsigned int *) (TSEMAC_BASE + 0x030);
        *(volatile unsigned int *) (TSEMAC_BASE + 0x024) = 0x0;

        phy_reg |= 0x1000;

        *(volatile unsigned int *) (TSEMAC_BASE + 0x028) = 0x1200;
        *(volatile unsigned int *) (TSEMAC_BASE + 0x02C) = phy_reg;
        while ((*(volatile unsigned int *) (TSEMAC_BASE + 0x034)) != 0);

        *(volatile unsigned int *) (TSEMAC_BASE + 0x028) = 0x1200;
        *(volatile unsigned int *) (TSEMAC_BASE + 0x024) = 0x1;
        while ((*(volatile unsigned int *) (TSEMAC_BASE + 0x034)) != 0);

        phy_reg = *(volatile unsigned int *) (TSEMAC_BASE + 0x030);
        *(volatile unsigned int *) (TSEMAC_BASE + 0x024) = 0x0;

        phy_reg |= 0x0200;

        *(volatile unsigned int *) (TSEMAC_BASE + 0x028) = 0x1200;
        *(volatile unsigned int *) (TSEMAC_BASE + 0x02C) = phy_reg;
        while ((*(volatile unsigned int *) (TSEMAC_BASE + 0x034)) != 0);

        do {
          *(volatile unsigned int *) (TSEMAC_BASE + 0x028) = 0x1201;
          *(volatile unsigned int *) (TSEMAC_BASE + 0x024) = 0x1;
          while ((*(volatile unsigned int *) (TSEMAC_BASE + 0x034)) != 0);

          phy_reg = *(volatile unsigned int *) (TSEMAC_BASE + 0x030);
          *(volatile unsigned int *) (TSEMAC_BASE + 0x024) = 0x0;


          autoneg_complete = phy_reg & 0x0020;
          --sgmii_aneg_timeout;
        } while((!autoneg_complete) && (sgmii_aneg_timeout != 0u));


      }
}

/***************************************************************************//**
 *
 */
uint8_t
TSE_phy_get_link_status
(
    tse_instance_t * this_tse,
    uint8_t phy_addr,
    tse_speed_t * speed,
    uint8_t * fullduplex
)
{
    volatile uint16_t phy_reg;
    uint16_t copper_link_up;
    uint8_t link_status;

    /* Find out if link is up between Vitesse PHY and remote device.*/
    phy_reg = TSE_read_phy_reg(this_tse, phy_addr, MII_BMSR);
    copper_link_up = phy_reg & BMSR_LSTATUS;

    if(copper_link_up != TSE_LINK_DOWN)
    {
        uint16_t duplex;
        uint16_t phy_speed;

        /* Link is up. */
        link_status = TSE_LINK_UP;

        phy_reg = TSE_read_phy_reg(this_tse, phy_addr, MII_AUX_CNTL_STAT);
        duplex = phy_reg & VSC8575_PHY_STATUS_FULLDUPLEX;
        phy_speed = phy_reg & VSC8575_PHY_STATUS_SPD_MASK;

        if(TSE_HALF_DUPLEX == duplex)
        {
            *fullduplex = TSE_HALF_DUPLEX;
        }
        else
        {
            *fullduplex = TSE_FULL_DUPLEX;
        }

        switch(phy_speed)
        {
            case VSC8575_PHY_STATUS_1000:
                *speed = TSE_MAC1000MBPS;
                break;

            case VSC8575_PHY_STATUS_100:
                *speed = TSE_MAC100MBPS;
                break;

            case VSC8575_PHY_STATUS_10:
                *speed = TSE_MAC10MBPS;
                break;
            default:
                *speed = TSE_INVALID_SPEED;
                break;
        }
    }
    else
    {
        /* Link is down. */
        link_status = TSE_LINK_DOWN;
    }

    return link_status;
}

#ifdef __cplusplus
}
#endif

/******************************** END OF FILE ******************************/
