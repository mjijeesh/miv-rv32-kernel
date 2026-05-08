#!/bin/bash

#===============================================================================
# Edit the following section with the location where the following tools are
# installed:
#   - SoftConsole (SC_INSTALL_DIR)
#   - Libero (LIBERO_INSTALL_DIR)
#   - Licensing daemon for Libero (LICENSE_DAEMON_DIR)
#===============================================================================
export SC_INSTALL_DIR=/home/$USER/microchip/softconsole-v2022.2
export LIBERO_INSTALL_DIR=/home/$USER/microchip/Libero_SoC_2025.1/Libero_SoC
export LICENSE_DAEMON_DIR=/home/$USER/flexlm
export LICENSE_FILE_DIR=/home/$USER/flexlm

#===============================================================================
# The following was tested on Ubuntu 20.04 with:
#   - Libero 2023.2
#   - SoftConsole 2022.2
#===============================================================================

#
# SoftConsole
#
export PATH=$PATH:$SC_INSTALL_DIR/riscv-unknown-elf-gcc/bin
export FPGENPROG=$LIBERO_INSTALL_DIR/Designer/bin64/fpgenprog

#
# Libero
#
export PATH=$PATH:$LIBERO_INSTALL_DIR/Designer/bin:$LIBERO_INSTALL_DIR/Designer/bin64
export PATH=$PATH:$LIBERO_INSTALL_DIR/Synplify/bin
export PATH=$PATH:$LIBERO_INSTALL_DIR/Model/modeltech/linuxacoem
export LOCALE=C
export LD_LIBRARY_PATH=/usr/lib/i386-linux-gnu:$LD_LIBRARY_PATH

#
# Libero License daemon
#
export LM_LICENSE_FILE=1702@localhost
export SNPSLMD_LICENSE_FILE=1702@localhost

#$LICENSE_DAEMON_DIR/lmgrd -c $LICENSE_FILE_DIR/License.dat -l $LICENSE_FILE_DIR/license.log
