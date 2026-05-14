//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Mon Apr 27 12:45:32 2026
// Version: 2025.1 2025.1.0.14
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

// MSS_DDR_C0
module MSS_DDR_C0(
    // Inputs
    CLK0,
    DEVRST_N,
    FAB_RESET_N,
    MDDR_DDR_AHB0_S_HADDR,
    MDDR_DDR_AHB0_S_HBURST,
    MDDR_DDR_AHB0_S_HMASTLOCK,
    MDDR_DDR_AHB0_S_HREADY,
    MDDR_DDR_AHB0_S_HSEL,
    MDDR_DDR_AHB0_S_HSIZE,
    MDDR_DDR_AHB0_S_HTRANS,
    MDDR_DDR_AHB0_S_HWDATA,
    MDDR_DDR_AHB0_S_HWRITE,
    MDDR_DQS_TMATCH_0_IN,
    // Outputs
    DDR_READY,
    INIT_DONE,
    MDDR_ADDR,
    MDDR_BA,
    MDDR_CAS_N,
    MDDR_CKE,
    MDDR_CLK,
    MDDR_CLK_N,
    MDDR_CS_N,
    MDDR_DDR_AHB0_S_HRDATA,
    MDDR_DDR_AHB0_S_HREADYOUT,
    MDDR_DDR_AHB0_S_HRESP,
    MDDR_DQS_TMATCH_0_OUT,
    MDDR_ODT,
    MDDR_RAS_N,
    MDDR_RESET_N,
    MDDR_WE_N,
    MSS_DDR_FIC_SUBSYSTEM_CLK,
    MSS_DDR_FIC_SUBSYSTEM_LOCK,
    MSS_READY,
    POWER_ON_RESET_N,
    // Inouts
    MDDR_DM_RDQS,
    MDDR_DQ,
    MDDR_DQS,
    MDDR_DQS_N
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input         CLK0;
input         DEVRST_N;
input         FAB_RESET_N;
input  [31:0] MDDR_DDR_AHB0_S_HADDR;
input  [2:0]  MDDR_DDR_AHB0_S_HBURST;
input         MDDR_DDR_AHB0_S_HMASTLOCK;
input         MDDR_DDR_AHB0_S_HREADY;
input         MDDR_DDR_AHB0_S_HSEL;
input  [1:0]  MDDR_DDR_AHB0_S_HSIZE;
input  [1:0]  MDDR_DDR_AHB0_S_HTRANS;
input  [31:0] MDDR_DDR_AHB0_S_HWDATA;
input         MDDR_DDR_AHB0_S_HWRITE;
input         MDDR_DQS_TMATCH_0_IN;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output        DDR_READY;
output        INIT_DONE;
output [15:0] MDDR_ADDR;
output [2:0]  MDDR_BA;
output        MDDR_CAS_N;
output        MDDR_CKE;
output        MDDR_CLK;
output        MDDR_CLK_N;
output        MDDR_CS_N;
output [31:0] MDDR_DDR_AHB0_S_HRDATA;
output        MDDR_DDR_AHB0_S_HREADYOUT;
output        MDDR_DDR_AHB0_S_HRESP;
output        MDDR_DQS_TMATCH_0_OUT;
output        MDDR_ODT;
output        MDDR_RAS_N;
output        MDDR_RESET_N;
output        MDDR_WE_N;
output        MSS_DDR_FIC_SUBSYSTEM_CLK;
output        MSS_DDR_FIC_SUBSYSTEM_LOCK;
output        MSS_READY;
output        POWER_ON_RESET_N;
//--------------------------------------------------------------------
// Inout
//--------------------------------------------------------------------
inout  [1:0]  MDDR_DM_RDQS;
inout  [15:0] MDDR_DQ;
inout  [1:0]  MDDR_DQS;
inout  [1:0]  MDDR_DQS_N;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire          CLK0;
wire          CORECONFIGP_0_APB_S_PCLK;
wire          CORECONFIGP_0_APB_S_PRESET_N;
wire          CORECONFIGP_0_CONFIG1_DONE;
wire          CORECONFIGP_0_CONFIG2_DONE;
wire          CORECONFIGP_0_MDDR_APBmslave_PENABLE;
wire          CORECONFIGP_0_MDDR_APBmslave_PREADY;
wire          CORECONFIGP_0_MDDR_APBmslave_PSELx;
wire          CORECONFIGP_0_MDDR_APBmslave_PSLVERR;
wire          CORECONFIGP_0_MDDR_APBmslave_PWRITE;
wire          CORECONFIGP_0_SOFT_EXT_RESET_OUT;
wire          CORECONFIGP_0_SOFT_M3_RESET;
wire          CORECONFIGP_0_SOFT_MDDR_DDR_AXI_S_CORE_RESET;
wire          CORECONFIGP_0_SOFT_RESET_F2M;
wire          CORERESETP_0_M3_RESET_N;
wire          CORERESETP_0_MDDR_DDR_AXI_S_CORE_RESET_N;
wire          CORERESETP_0_RESET_N_F2M;
wire          ddr_mss_sb_MSS_TMP_0_FIC_2_APB_M_PCLK;
wire          ddr_mss_sb_MSS_TMP_0_FIC_2_APB_M_PRESET_N;
wire          ddr_mss_sb_MSS_TMP_0_FIC_2_APB_MASTER_PENABLE;
wire   [31:0] ddr_mss_sb_MSS_TMP_0_FIC_2_APB_MASTER_PRDATA;
wire          ddr_mss_sb_MSS_TMP_0_FIC_2_APB_MASTER_PREADY;
wire          ddr_mss_sb_MSS_TMP_0_FIC_2_APB_MASTER_PSELx;
wire          ddr_mss_sb_MSS_TMP_0_FIC_2_APB_MASTER_PSLVERR;
wire   [31:0] ddr_mss_sb_MSS_TMP_0_FIC_2_APB_MASTER_PWDATA;
wire          ddr_mss_sb_MSS_TMP_0_FIC_2_APB_MASTER_PWRITE;
wire          ddr_mss_sb_MSS_TMP_0_MSS_RESET_N_M2F;
wire          DDR_READY_net_0;
wire          DEVRST_N;
wire          FAB_RESET_N;
wire          FABOSC_0_RCOSC_25_50MHZ_O2F;
wire          INIT_DONE_net_0;
wire   [15:0] MDDR_ADDR_net_0;
wire   [2:0]  MDDR_BA_net_0;
wire          MDDR_CAS_N_net_0;
wire          MDDR_CKE_net_0;
wire          MDDR_CLK_net_0;
wire          MDDR_CLK_N_net_0;
wire          MDDR_CS_N_net_0;
wire   [31:0] MDDR_DDR_AHB0_S_HADDR;
wire   [2:0]  MDDR_DDR_AHB0_S_HBURST;
wire          MDDR_DDR_AHB0_S_HMASTLOCK;
wire   [31:0] MDDR_DDR_AMBA_SLAVE_HRDATA;
wire          MDDR_DDR_AHB0_S_HREADY;
wire          MDDR_DDR_AMBA_SLAVE_HREADYOUT;
wire          MDDR_DDR_AMBA_SLAVE_HRESP;
wire          MDDR_DDR_AHB0_S_HSEL;
wire   [1:0]  MDDR_DDR_AHB0_S_HSIZE;
wire   [1:0]  MDDR_DDR_AHB0_S_HTRANS;
wire   [31:0] MDDR_DDR_AHB0_S_HWDATA;
wire          MDDR_DDR_AHB0_S_HWRITE;
wire   [1:0]  MDDR_DM_RDQS;
wire   [15:0] MDDR_DQ;
wire   [1:0]  MDDR_DQS;
wire   [1:0]  MDDR_DQS_N;
wire          MDDR_DQS_TMATCH_0_IN;
wire          MDDR_DQS_TMATCH_0_OUT_net_0;
wire          MDDR_ODT_net_0;
wire          MDDR_RAS_N_net_0;
wire          MDDR_RESET_N_net_0;
wire          MDDR_WE_N_net_0;
wire          MSS_DDR_FIC_SUBSYSTEM_CLK_net_0;
wire          MSS_DDR_FIC_SUBSYSTEM_LOCK_net_0;
wire          MSS_READY_net_0;
wire          POWER_ON_RESET_N_net_0;
wire          MDDR_DQS_TMATCH_0_OUT_net_1;
wire          MDDR_CAS_N_net_1;
wire          MDDR_CLK_net_1;
wire          MDDR_CLK_N_net_1;
wire          MDDR_CKE_net_1;
wire          MDDR_CS_N_net_1;
wire          MDDR_ODT_net_1;
wire          MDDR_RAS_N_net_1;
wire          MDDR_RESET_N_net_1;
wire          MDDR_WE_N_net_1;
wire          POWER_ON_RESET_N_net_1;
wire          INIT_DONE_net_1;
wire          MSS_DDR_FIC_SUBSYSTEM_CLK_net_1;
wire          MSS_DDR_FIC_SUBSYSTEM_LOCK_net_1;
wire          DDR_READY_net_1;
wire          MSS_READY_net_1;
wire   [15:0] MDDR_ADDR_net_1;
wire   [2:0]  MDDR_BA_net_1;
wire   [31:0] MDDR_DDR_AMBA_SLAVE_HRDATA_net_0;
wire          MDDR_DDR_AMBA_SLAVE_HREADYOUT_net_0;
wire          MDDR_DDR_AMBA_SLAVE_HRESP_net_0;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire          GND_net;
wire   [7:2]  PADDR_const_net_0;
wire   [7:0]  PWDATA_const_net_0;
wire          VCC_net;
wire   [31:0] FDDR_PRDATA_const_net_0;
wire   [31:0] SDIF0_PRDATA_const_net_0;
wire   [31:0] SDIF1_PRDATA_const_net_0;
wire   [31:0] SDIF2_PRDATA_const_net_0;
wire   [31:0] SDIF3_PRDATA_const_net_0;
wire   [31:0] SDIF0_PRDATA_const_net_1;
wire   [31:0] SDIF1_PRDATA_const_net_1;
wire   [31:0] SDIF2_PRDATA_const_net_1;
wire   [31:0] SDIF3_PRDATA_const_net_1;
//--------------------------------------------------------------------
// Bus Interface Nets Declarations - Unequal Pin Widths
//--------------------------------------------------------------------
wire   [15:2] CORECONFIGP_0_MDDR_APBmslave_PADDR;
wire   [10:2] CORECONFIGP_0_MDDR_APBmslave_PADDR_0;
wire   [10:2] CORECONFIGP_0_MDDR_APBmslave_PADDR_0_10to2;
wire   [15:0] CORECONFIGP_0_MDDR_APBmslave_PRDATA;
wire   [31:0] CORECONFIGP_0_MDDR_APBmslave_PRDATA_0;
wire   [15:0] CORECONFIGP_0_MDDR_APBmslave_PRDATA_0_15to0;
wire   [31:16]CORECONFIGP_0_MDDR_APBmslave_PRDATA_0_31to16;
wire   [31:0] CORECONFIGP_0_MDDR_APBmslave_PWDATA;
wire   [15:0] CORECONFIGP_0_MDDR_APBmslave_PWDATA_0;
wire   [15:0] CORECONFIGP_0_MDDR_APBmslave_PWDATA_0_15to0;
wire   [15:2] ddr_mss_sb_MSS_TMP_0_FIC_2_APB_MASTER_PADDR;
wire   [16:2] ddr_mss_sb_MSS_TMP_0_FIC_2_APB_MASTER_PADDR_0;
wire   [15:2] ddr_mss_sb_MSS_TMP_0_FIC_2_APB_MASTER_PADDR_0_15to2;
wire   [16:16]ddr_mss_sb_MSS_TMP_0_FIC_2_APB_MASTER_PADDR_0_16to16;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign GND_net                  = 1'b0;
assign PADDR_const_net_0        = 6'h00;
assign PWDATA_const_net_0       = 8'h00;
assign VCC_net                  = 1'b1;
assign FDDR_PRDATA_const_net_0  = 32'h00000000;
assign SDIF0_PRDATA_const_net_0 = 32'h00000000;
assign SDIF1_PRDATA_const_net_0 = 32'h00000000;
assign SDIF2_PRDATA_const_net_0 = 32'h00000000;
assign SDIF3_PRDATA_const_net_0 = 32'h00000000;
assign SDIF0_PRDATA_const_net_1 = 32'h00000000;
assign SDIF1_PRDATA_const_net_1 = 32'h00000000;
assign SDIF2_PRDATA_const_net_1 = 32'h00000000;
assign SDIF3_PRDATA_const_net_1 = 32'h00000000;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign MDDR_DQS_TMATCH_0_OUT_net_1         = MDDR_DQS_TMATCH_0_OUT_net_0;
assign MDDR_DQS_TMATCH_0_OUT               = MDDR_DQS_TMATCH_0_OUT_net_1;
assign MDDR_CAS_N_net_1                    = MDDR_CAS_N_net_0;
assign MDDR_CAS_N                          = MDDR_CAS_N_net_1;
assign MDDR_CLK_net_1                      = MDDR_CLK_net_0;
assign MDDR_CLK                            = MDDR_CLK_net_1;
assign MDDR_CLK_N_net_1                    = MDDR_CLK_N_net_0;
assign MDDR_CLK_N                          = MDDR_CLK_N_net_1;
assign MDDR_CKE_net_1                      = MDDR_CKE_net_0;
assign MDDR_CKE                            = MDDR_CKE_net_1;
assign MDDR_CS_N_net_1                     = MDDR_CS_N_net_0;
assign MDDR_CS_N                           = MDDR_CS_N_net_1;
assign MDDR_ODT_net_1                      = MDDR_ODT_net_0;
assign MDDR_ODT                            = MDDR_ODT_net_1;
assign MDDR_RAS_N_net_1                    = MDDR_RAS_N_net_0;
assign MDDR_RAS_N                          = MDDR_RAS_N_net_1;
assign MDDR_RESET_N_net_1                  = MDDR_RESET_N_net_0;
assign MDDR_RESET_N                        = MDDR_RESET_N_net_1;
assign MDDR_WE_N_net_1                     = MDDR_WE_N_net_0;
assign MDDR_WE_N                           = MDDR_WE_N_net_1;
assign POWER_ON_RESET_N_net_1              = POWER_ON_RESET_N_net_0;
assign POWER_ON_RESET_N                    = POWER_ON_RESET_N_net_1;
assign INIT_DONE_net_1                     = INIT_DONE_net_0;
assign INIT_DONE                           = INIT_DONE_net_1;
assign MSS_DDR_FIC_SUBSYSTEM_CLK_net_1     = MSS_DDR_FIC_SUBSYSTEM_CLK_net_0;
assign MSS_DDR_FIC_SUBSYSTEM_CLK           = MSS_DDR_FIC_SUBSYSTEM_CLK_net_1;
assign MSS_DDR_FIC_SUBSYSTEM_LOCK_net_1    = MSS_DDR_FIC_SUBSYSTEM_LOCK_net_0;
assign MSS_DDR_FIC_SUBSYSTEM_LOCK          = MSS_DDR_FIC_SUBSYSTEM_LOCK_net_1;
assign DDR_READY_net_1                     = DDR_READY_net_0;
assign DDR_READY                           = DDR_READY_net_1;
assign MSS_READY_net_1                     = MSS_READY_net_0;
assign MSS_READY                           = MSS_READY_net_1;
assign MDDR_ADDR_net_1                     = MDDR_ADDR_net_0;
assign MDDR_ADDR[15:0]                     = MDDR_ADDR_net_1;
assign MDDR_BA_net_1                       = MDDR_BA_net_0;
assign MDDR_BA[2:0]                        = MDDR_BA_net_1;
assign MDDR_DDR_AMBA_SLAVE_HRDATA_net_0    = MDDR_DDR_AMBA_SLAVE_HRDATA;
assign MDDR_DDR_AHB0_S_HRDATA[31:0]        = MDDR_DDR_AMBA_SLAVE_HRDATA_net_0;
assign MDDR_DDR_AMBA_SLAVE_HREADYOUT_net_0 = MDDR_DDR_AMBA_SLAVE_HREADYOUT;
assign MDDR_DDR_AHB0_S_HREADYOUT           = MDDR_DDR_AMBA_SLAVE_HREADYOUT_net_0;
assign MDDR_DDR_AMBA_SLAVE_HRESP_net_0     = MDDR_DDR_AMBA_SLAVE_HRESP;
assign MDDR_DDR_AHB0_S_HRESP               = MDDR_DDR_AMBA_SLAVE_HRESP_net_0;
//--------------------------------------------------------------------
// Bus Interface Nets Assignments - Unequal Pin Widths
//--------------------------------------------------------------------
assign CORECONFIGP_0_MDDR_APBmslave_PADDR_0 = { CORECONFIGP_0_MDDR_APBmslave_PADDR_0_10to2 };
assign CORECONFIGP_0_MDDR_APBmslave_PADDR_0_10to2 = CORECONFIGP_0_MDDR_APBmslave_PADDR[10:2];

assign CORECONFIGP_0_MDDR_APBmslave_PRDATA_0 = { CORECONFIGP_0_MDDR_APBmslave_PRDATA_0_31to16, CORECONFIGP_0_MDDR_APBmslave_PRDATA_0_15to0 };
assign CORECONFIGP_0_MDDR_APBmslave_PRDATA_0_15to0 = CORECONFIGP_0_MDDR_APBmslave_PRDATA[15:0];
assign CORECONFIGP_0_MDDR_APBmslave_PRDATA_0_31to16 = 16'h0;

assign CORECONFIGP_0_MDDR_APBmslave_PWDATA_0 = { CORECONFIGP_0_MDDR_APBmslave_PWDATA_0_15to0 };
assign CORECONFIGP_0_MDDR_APBmslave_PWDATA_0_15to0 = CORECONFIGP_0_MDDR_APBmslave_PWDATA[15:0];

assign ddr_mss_sb_MSS_TMP_0_FIC_2_APB_MASTER_PADDR_0 = { ddr_mss_sb_MSS_TMP_0_FIC_2_APB_MASTER_PADDR_0_16to16, ddr_mss_sb_MSS_TMP_0_FIC_2_APB_MASTER_PADDR_0_15to2 };
assign ddr_mss_sb_MSS_TMP_0_FIC_2_APB_MASTER_PADDR_0_15to2 = ddr_mss_sb_MSS_TMP_0_FIC_2_APB_MASTER_PADDR[15:2];
assign ddr_mss_sb_MSS_TMP_0_FIC_2_APB_MASTER_PADDR_0_16to16 = 1'b0;

//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------MSS_DDR_C0_CCC_0_FCCC   -   Actel:SgCore:FCCC:2.0.201
MSS_DDR_C0_CCC_0_FCCC CCC_0(
        // Inputs
        .CLK0 ( CLK0 ),
        // Outputs
        .GL2  ( MSS_DDR_FIC_SUBSYSTEM_CLK_net_0 ),
        .LOCK ( MSS_DDR_FIC_SUBSYSTEM_LOCK_net_0 ) 
        );

//--------CoreConfigP   -   Actel:DirectCore:CoreConfigP:7.1.100
CoreConfigP #( 
        .DEVICE_090         ( 0 ),
        .ENABLE_SOFT_RESETS ( 1 ),
        .FDDR_IN_USE        ( 0 ),
        .MDDR_IN_USE        ( 1 ),
        .SDIF0_IN_USE       ( 0 ),
        .SDIF0_PCIE         ( 0 ),
        .SDIF1_IN_USE       ( 0 ),
        .SDIF1_PCIE         ( 0 ),
        .SDIF2_IN_USE       ( 0 ),
        .SDIF2_PCIE         ( 0 ),
        .SDIF3_IN_USE       ( 0 ),
        .SDIF3_PCIE         ( 0 ) )
CORECONFIGP_0(
        // Inputs
        .FIC_2_APB_M_PRESET_N           ( ddr_mss_sb_MSS_TMP_0_FIC_2_APB_M_PRESET_N ),
        .FIC_2_APB_M_PCLK               ( ddr_mss_sb_MSS_TMP_0_FIC_2_APB_M_PCLK ),
        .SDIF_RELEASED                  ( GND_net ), // tied to 1'b0 from definition
        .INIT_DONE                      ( INIT_DONE_net_0 ),
        .FIC_2_APB_M_PSEL               ( ddr_mss_sb_MSS_TMP_0_FIC_2_APB_MASTER_PSELx ),
        .FIC_2_APB_M_PENABLE            ( ddr_mss_sb_MSS_TMP_0_FIC_2_APB_MASTER_PENABLE ),
        .FIC_2_APB_M_PWRITE             ( ddr_mss_sb_MSS_TMP_0_FIC_2_APB_MASTER_PWRITE ),
        .MDDR_PREADY                    ( CORECONFIGP_0_MDDR_APBmslave_PREADY ),
        .MDDR_PSLVERR                   ( CORECONFIGP_0_MDDR_APBmslave_PSLVERR ),
        .FDDR_PREADY                    ( VCC_net ), // tied to 1'b1 from definition
        .FDDR_PSLVERR                   ( GND_net ), // tied to 1'b0 from definition
        .SDIF0_PREADY                   ( VCC_net ), // tied to 1'b1 from definition
        .SDIF0_PSLVERR                  ( GND_net ), // tied to 1'b0 from definition
        .SDIF1_PREADY                   ( VCC_net ), // tied to 1'b1 from definition
        .SDIF1_PSLVERR                  ( GND_net ), // tied to 1'b0 from definition
        .SDIF2_PREADY                   ( VCC_net ), // tied to 1'b1 from definition
        .SDIF2_PSLVERR                  ( GND_net ), // tied to 1'b0 from definition
        .SDIF3_PREADY                   ( VCC_net ), // tied to 1'b1 from definition
        .SDIF3_PSLVERR                  ( GND_net ), // tied to 1'b0 from definition
        .FIC_2_APB_M_PADDR              ( ddr_mss_sb_MSS_TMP_0_FIC_2_APB_MASTER_PADDR_0 ),
        .FIC_2_APB_M_PWDATA             ( ddr_mss_sb_MSS_TMP_0_FIC_2_APB_MASTER_PWDATA ),
        .MDDR_PRDATA                    ( CORECONFIGP_0_MDDR_APBmslave_PRDATA_0 ),
        .FDDR_PRDATA                    ( FDDR_PRDATA_const_net_0 ), // tied to 32'h00000000 from definition
        .SDIF0_PRDATA                   ( SDIF0_PRDATA_const_net_0 ), // tied to 32'h00000000 from definition
        .SDIF1_PRDATA                   ( SDIF1_PRDATA_const_net_0 ), // tied to 32'h00000000 from definition
        .SDIF2_PRDATA                   ( SDIF2_PRDATA_const_net_0 ), // tied to 32'h00000000 from definition
        .SDIF3_PRDATA                   ( SDIF3_PRDATA_const_net_0 ), // tied to 32'h00000000 from definition
        // Outputs
        .APB_S_PCLK                     ( CORECONFIGP_0_APB_S_PCLK ),
        .APB_S_PRESET_N                 ( CORECONFIGP_0_APB_S_PRESET_N ),
        .CONFIG1_DONE                   ( CORECONFIGP_0_CONFIG1_DONE ),
        .CONFIG2_DONE                   ( CORECONFIGP_0_CONFIG2_DONE ),
        .FIC_2_APB_M_PREADY             ( ddr_mss_sb_MSS_TMP_0_FIC_2_APB_MASTER_PREADY ),
        .FIC_2_APB_M_PSLVERR            ( ddr_mss_sb_MSS_TMP_0_FIC_2_APB_MASTER_PSLVERR ),
        .MDDR_PSEL                      ( CORECONFIGP_0_MDDR_APBmslave_PSELx ),
        .MDDR_PENABLE                   ( CORECONFIGP_0_MDDR_APBmslave_PENABLE ),
        .MDDR_PWRITE                    ( CORECONFIGP_0_MDDR_APBmslave_PWRITE ),
        .FDDR_PSEL                      (  ),
        .FDDR_PENABLE                   (  ),
        .FDDR_PWRITE                    (  ),
        .SDIF0_PSEL                     (  ),
        .SDIF0_PENABLE                  (  ),
        .SDIF0_PWRITE                   (  ),
        .SDIF1_PSEL                     (  ),
        .SDIF1_PENABLE                  (  ),
        .SDIF1_PWRITE                   (  ),
        .SDIF2_PSEL                     (  ),
        .SDIF2_PENABLE                  (  ),
        .SDIF2_PWRITE                   (  ),
        .SDIF3_PSEL                     (  ),
        .SDIF3_PENABLE                  (  ),
        .SDIF3_PWRITE                   (  ),
        .SOFT_EXT_RESET_OUT             ( CORECONFIGP_0_SOFT_EXT_RESET_OUT ),
        .SOFT_RESET_F2M                 ( CORECONFIGP_0_SOFT_RESET_F2M ),
        .SOFT_M3_RESET                  ( CORECONFIGP_0_SOFT_M3_RESET ),
        .SOFT_MDDR_DDR_AXI_S_CORE_RESET ( CORECONFIGP_0_SOFT_MDDR_DDR_AXI_S_CORE_RESET ),
        .SOFT_FDDR_CORE_RESET           (  ),
        .SOFT_SDIF0_PHY_RESET           (  ),
        .SOFT_SDIF0_CORE_RESET          (  ),
        .SOFT_SDIF0_0_CORE_RESET        (  ),
        .SOFT_SDIF0_1_CORE_RESET        (  ),
        .SOFT_SDIF1_PHY_RESET           (  ),
        .SOFT_SDIF1_CORE_RESET          (  ),
        .SOFT_SDIF2_PHY_RESET           (  ),
        .SOFT_SDIF2_CORE_RESET          (  ),
        .SOFT_SDIF3_PHY_RESET           (  ),
        .SOFT_SDIF3_CORE_RESET          (  ),
        .R_SDIF0_PSEL                   (  ),
        .R_SDIF0_PWRITE                 (  ),
        .R_SDIF1_PSEL                   (  ),
        .R_SDIF1_PWRITE                 (  ),
        .R_SDIF2_PSEL                   (  ),
        .R_SDIF2_PWRITE                 (  ),
        .R_SDIF3_PSEL                   (  ),
        .R_SDIF3_PWRITE                 (  ),
        .FIC_2_APB_M_PRDATA             ( ddr_mss_sb_MSS_TMP_0_FIC_2_APB_MASTER_PRDATA ),
        .MDDR_PADDR                     ( CORECONFIGP_0_MDDR_APBmslave_PADDR ),
        .MDDR_PWDATA                    ( CORECONFIGP_0_MDDR_APBmslave_PWDATA ),
        .FDDR_PADDR                     (  ),
        .FDDR_PWDATA                    (  ),
        .SDIF0_PADDR                    (  ),
        .SDIF0_PWDATA                   (  ),
        .SDIF1_PADDR                    (  ),
        .SDIF1_PWDATA                   (  ),
        .SDIF2_PADDR                    (  ),
        .SDIF2_PWDATA                   (  ),
        .SDIF3_PADDR                    (  ),
        .SDIF3_PWDATA                   (  ),
        .R_SDIF0_PRDATA                 (  ),
        .R_SDIF1_PRDATA                 (  ),
        .R_SDIF2_PRDATA                 (  ),
        .R_SDIF3_PRDATA                 (  ) 
        );

//--------CoreResetP   -   Actel:DirectCore:CoreResetP:7.1.100
CoreResetP #( 
        .DDR_WAIT            ( 200 ),
        .DEVICE_090          ( 0 ),
        .DEVICE_VOLTAGE      ( 2 ),
        .ENABLE_SOFT_RESETS  ( 1 ),
        .EXT_RESET_CFG       ( 0 ),
        .FDDR_IN_USE         ( 0 ),
        .MDDR_IN_USE         ( 1 ),
        .SDIF0_IN_USE        ( 0 ),
        .SDIF0_PCIE          ( 0 ),
        .SDIF0_PCIE_HOTRESET ( 1 ),
        .SDIF0_PCIE_L2P2     ( 1 ),
        .SDIF1_IN_USE        ( 0 ),
        .SDIF1_PCIE          ( 0 ),
        .SDIF1_PCIE_HOTRESET ( 1 ),
        .SDIF1_PCIE_L2P2     ( 1 ),
        .SDIF2_IN_USE        ( 0 ),
        .SDIF2_PCIE          ( 0 ),
        .SDIF2_PCIE_HOTRESET ( 1 ),
        .SDIF2_PCIE_L2P2     ( 1 ),
        .SDIF3_IN_USE        ( 0 ),
        .SDIF3_PCIE          ( 0 ),
        .SDIF3_PCIE_HOTRESET ( 1 ),
        .SDIF3_PCIE_L2P2     ( 1 ) )
CORERESETP_0(
        // Inputs
        .RESET_N_M2F                    ( ddr_mss_sb_MSS_TMP_0_MSS_RESET_N_M2F ),
        .FIC_2_APB_M_PRESET_N           ( ddr_mss_sb_MSS_TMP_0_FIC_2_APB_M_PRESET_N ),
        .POWER_ON_RESET_N               ( POWER_ON_RESET_N_net_0 ),
        .FAB_RESET_N                    ( FAB_RESET_N ),
        .RCOSC_25_50MHZ                 ( FABOSC_0_RCOSC_25_50MHZ_O2F ),
        .CLK_BASE                       ( MSS_DDR_FIC_SUBSYSTEM_CLK_net_0 ),
        .CLK_LTSSM                      ( GND_net ), // tied to 1'b0 from definition
        .FPLL_LOCK                      ( VCC_net ), // tied to 1'b1 from definition
        .SDIF0_SPLL_LOCK                ( VCC_net ), // tied to 1'b1 from definition
        .SDIF1_SPLL_LOCK                ( VCC_net ), // tied to 1'b1 from definition
        .SDIF2_SPLL_LOCK                ( VCC_net ), // tied to 1'b1 from definition
        .SDIF3_SPLL_LOCK                ( VCC_net ), // tied to 1'b1 from definition
        .CONFIG1_DONE                   ( CORECONFIGP_0_CONFIG1_DONE ),
        .CONFIG2_DONE                   ( CORECONFIGP_0_CONFIG2_DONE ),
        .SDIF0_PERST_N                  ( VCC_net ), // tied to 1'b1 from definition
        .SDIF1_PERST_N                  ( VCC_net ), // tied to 1'b1 from definition
        .SDIF2_PERST_N                  ( VCC_net ), // tied to 1'b1 from definition
        .SDIF3_PERST_N                  ( VCC_net ), // tied to 1'b1 from definition
        .SDIF0_PSEL                     ( GND_net ), // tied to 1'b0 from definition
        .SDIF0_PWRITE                   ( VCC_net ), // tied to 1'b1 from definition
        .SDIF1_PSEL                     ( GND_net ), // tied to 1'b0 from definition
        .SDIF1_PWRITE                   ( VCC_net ), // tied to 1'b1 from definition
        .SDIF2_PSEL                     ( GND_net ), // tied to 1'b0 from definition
        .SDIF2_PWRITE                   ( VCC_net ), // tied to 1'b1 from definition
        .SDIF3_PSEL                     ( GND_net ), // tied to 1'b0 from definition
        .SDIF3_PWRITE                   ( VCC_net ), // tied to 1'b1 from definition
        .SOFT_EXT_RESET_OUT             ( CORECONFIGP_0_SOFT_EXT_RESET_OUT ),
        .SOFT_RESET_F2M                 ( CORECONFIGP_0_SOFT_RESET_F2M ),
        .SOFT_M3_RESET                  ( CORECONFIGP_0_SOFT_M3_RESET ),
        .SOFT_MDDR_DDR_AXI_S_CORE_RESET ( CORECONFIGP_0_SOFT_MDDR_DDR_AXI_S_CORE_RESET ),
        .SOFT_FDDR_CORE_RESET           ( GND_net ), // tied to 1'b0 from definition
        .SOFT_SDIF0_PHY_RESET           ( GND_net ), // tied to 1'b0 from definition
        .SOFT_SDIF0_CORE_RESET          ( GND_net ), // tied to 1'b0 from definition
        .SOFT_SDIF0_0_CORE_RESET        ( GND_net ), // tied to 1'b0 from definition
        .SOFT_SDIF0_1_CORE_RESET        ( GND_net ), // tied to 1'b0 from definition
        .SOFT_SDIF1_PHY_RESET           ( GND_net ), // tied to 1'b0 from definition
        .SOFT_SDIF1_CORE_RESET          ( GND_net ), // tied to 1'b0 from definition
        .SOFT_SDIF2_PHY_RESET           ( GND_net ), // tied to 1'b0 from definition
        .SOFT_SDIF2_CORE_RESET          ( GND_net ), // tied to 1'b0 from definition
        .SOFT_SDIF3_PHY_RESET           ( GND_net ), // tied to 1'b0 from definition
        .SOFT_SDIF3_CORE_RESET          ( GND_net ), // tied to 1'b0 from definition
        .SDIF0_PRDATA                   ( SDIF0_PRDATA_const_net_1 ), // tied to 32'h00000000 from definition
        .SDIF1_PRDATA                   ( SDIF1_PRDATA_const_net_1 ), // tied to 32'h00000000 from definition
        .SDIF2_PRDATA                   ( SDIF2_PRDATA_const_net_1 ), // tied to 32'h00000000 from definition
        .SDIF3_PRDATA                   ( SDIF3_PRDATA_const_net_1 ), // tied to 32'h00000000 from definition
        // Outputs
        .MSS_HPMS_READY                 ( MSS_READY_net_0 ),
        .DDR_READY                      ( DDR_READY_net_0 ),
        .SDIF_READY                     (  ),
        .RESET_N_F2M                    ( CORERESETP_0_RESET_N_F2M ),
        .M3_RESET_N                     ( CORERESETP_0_M3_RESET_N ),
        .EXT_RESET_OUT                  (  ),
        .MDDR_DDR_AXI_S_CORE_RESET_N    ( CORERESETP_0_MDDR_DDR_AXI_S_CORE_RESET_N ),
        .FDDR_CORE_RESET_N              (  ),
        .SDIF0_CORE_RESET_N             (  ),
        .SDIF0_0_CORE_RESET_N           (  ),
        .SDIF0_1_CORE_RESET_N           (  ),
        .SDIF0_PHY_RESET_N              (  ),
        .SDIF1_CORE_RESET_N             (  ),
        .SDIF1_PHY_RESET_N              (  ),
        .SDIF2_CORE_RESET_N             (  ),
        .SDIF2_PHY_RESET_N              (  ),
        .SDIF3_CORE_RESET_N             (  ),
        .SDIF3_PHY_RESET_N              (  ),
        .SDIF_RELEASED                  (  ),
        .INIT_DONE                      ( INIT_DONE_net_0 ) 
        );

//--------MSS_DDR_C0_FABOSC_0_OSC   -   Actel:SgCore:OSC:2.0.101
MSS_DDR_C0_FABOSC_0_OSC FABOSC_0(
        // Inputs
        .XTL                ( GND_net ), // tied to 1'b0 from definition
        // Outputs
        .RCOSC_25_50MHZ_CCC (  ),
        .RCOSC_25_50MHZ_O2F ( FABOSC_0_RCOSC_25_50MHZ_O2F ),
        .RCOSC_1MHZ_CCC     (  ),
        .RCOSC_1MHZ_O2F     (  ),
        .XTLOSC_CCC         (  ),
        .XTLOSC_O2F         (  ) 
        );

//--------MSS_C0
MSS_C0 MSS_C0_0(
        // Inputs
        .MCCC_CLK_BASE             ( MSS_DDR_FIC_SUBSYSTEM_CLK_net_0 ),
        .MDDR_DQS_TMATCH_0_IN      ( MDDR_DQS_TMATCH_0_IN ),
        .MCCC_CLK_BASE_PLL_LOCK    ( MSS_DDR_FIC_SUBSYSTEM_LOCK_net_0 ),
        .MSS_RESET_N_F2M           ( CORERESETP_0_RESET_N_F2M ),
        .MDDR_DDR_CORE_RESET_N     ( CORERESETP_0_MDDR_DDR_AXI_S_CORE_RESET_N ),
        .MDDR_DDR_AHB0_S_HSEL      ( MDDR_DDR_AHB0_S_HSEL ),
        .MDDR_DDR_AHB0_S_HMASTLOCK ( MDDR_DDR_AHB0_S_HMASTLOCK ),
        .MDDR_DDR_AHB0_S_HWRITE    ( MDDR_DDR_AHB0_S_HWRITE ),
        .MDDR_DDR_AHB0_S_HREADY    ( MDDR_DDR_AHB0_S_HREADY ),
        .M3_RESET_N                ( CORERESETP_0_M3_RESET_N ),
        .MDDR_APB_S_PRESET_N       ( CORECONFIGP_0_APB_S_PRESET_N ),
        .MDDR_APB_S_PCLK           ( CORECONFIGP_0_APB_S_PCLK ),
        .FIC_2_APB_M_PREADY        ( ddr_mss_sb_MSS_TMP_0_FIC_2_APB_MASTER_PREADY ),
        .FIC_2_APB_M_PSLVERR       ( ddr_mss_sb_MSS_TMP_0_FIC_2_APB_MASTER_PSLVERR ),
        .MDDR_APB_S_PWRITE         ( CORECONFIGP_0_MDDR_APBmslave_PWRITE ),
        .MDDR_APB_S_PENABLE        ( CORECONFIGP_0_MDDR_APBmslave_PENABLE ),
        .MDDR_APB_S_PSEL           ( CORECONFIGP_0_MDDR_APBmslave_PSELx ),
        .MDDR_DDR_AHB0_S_HADDR     ( MDDR_DDR_AHB0_S_HADDR ),
        .MDDR_DDR_AHB0_S_HBURST    ( MDDR_DDR_AHB0_S_HBURST ),
        .MDDR_DDR_AHB0_S_HSIZE     ( MDDR_DDR_AHB0_S_HSIZE ),
        .MDDR_DDR_AHB0_S_HTRANS    ( MDDR_DDR_AHB0_S_HTRANS ),
        .MDDR_DDR_AHB0_S_HWDATA    ( MDDR_DDR_AHB0_S_HWDATA ),
        .FIC_2_APB_M_PRDATA        ( ddr_mss_sb_MSS_TMP_0_FIC_2_APB_MASTER_PRDATA ),
        .MDDR_APB_S_PWDATA         ( CORECONFIGP_0_MDDR_APBmslave_PWDATA_0 ),
        .MDDR_APB_S_PADDR          ( CORECONFIGP_0_MDDR_APBmslave_PADDR_0 ),
        // Outputs
        .MDDR_DQS_TMATCH_0_OUT     ( MDDR_DQS_TMATCH_0_OUT_net_0 ),
        .MDDR_CAS_N                ( MDDR_CAS_N_net_0 ),
        .MDDR_CLK                  ( MDDR_CLK_net_0 ),
        .MDDR_CLK_N                ( MDDR_CLK_N_net_0 ),
        .MDDR_CKE                  ( MDDR_CKE_net_0 ),
        .MDDR_CS_N                 ( MDDR_CS_N_net_0 ),
        .MDDR_ODT                  ( MDDR_ODT_net_0 ),
        .MDDR_RAS_N                ( MDDR_RAS_N_net_0 ),
        .MDDR_RESET_N              ( MDDR_RESET_N_net_0 ),
        .MDDR_WE_N                 ( MDDR_WE_N_net_0 ),
        .MSS_RESET_N_M2F           ( ddr_mss_sb_MSS_TMP_0_MSS_RESET_N_M2F ),
        .MDDR_DDR_AHB0_S_HREADYOUT ( MDDR_DDR_AMBA_SLAVE_HREADYOUT ),
        .MDDR_DDR_AHB0_S_HRESP     ( MDDR_DDR_AMBA_SLAVE_HRESP ),
        .FIC_2_APB_M_PRESET_N      ( ddr_mss_sb_MSS_TMP_0_FIC_2_APB_M_PRESET_N ),
        .FIC_2_APB_M_PCLK          ( ddr_mss_sb_MSS_TMP_0_FIC_2_APB_M_PCLK ),
        .FIC_2_APB_M_PWRITE        ( ddr_mss_sb_MSS_TMP_0_FIC_2_APB_MASTER_PWRITE ),
        .FIC_2_APB_M_PENABLE       ( ddr_mss_sb_MSS_TMP_0_FIC_2_APB_MASTER_PENABLE ),
        .FIC_2_APB_M_PSEL          ( ddr_mss_sb_MSS_TMP_0_FIC_2_APB_MASTER_PSELx ),
        .MDDR_APB_S_PREADY         ( CORECONFIGP_0_MDDR_APBmslave_PREADY ),
        .MDDR_APB_S_PSLVERR        ( CORECONFIGP_0_MDDR_APBmslave_PSLVERR ),
        .MDDR_ADDR                 ( MDDR_ADDR_net_0 ),
        .MDDR_BA                   ( MDDR_BA_net_0 ),
        .MDDR_DDR_AHB0_S_HRDATA    ( MDDR_DDR_AMBA_SLAVE_HRDATA ),
        .FIC_2_APB_M_PADDR         ( ddr_mss_sb_MSS_TMP_0_FIC_2_APB_MASTER_PADDR ),
        .FIC_2_APB_M_PWDATA        ( ddr_mss_sb_MSS_TMP_0_FIC_2_APB_MASTER_PWDATA ),
        .MDDR_APB_S_PRDATA         ( CORECONFIGP_0_MDDR_APBmslave_PRDATA ),
        // Inouts
        .MDDR_DM_RDQS              ( MDDR_DM_RDQS ),
        .MDDR_DQ                   ( MDDR_DQ ),
        .MDDR_DQS                  ( MDDR_DQS ),
        .MDDR_DQS_N                ( MDDR_DQS_N ) 
        );

//--------SYSRESET
SYSRESET SYSRESET_POR(
        // Inputs
        .DEVRST_N         ( DEVRST_N ),
        // Outputs
        .POWER_ON_RESET_N ( POWER_ON_RESET_N_net_0 ) 
        );


endmodule
