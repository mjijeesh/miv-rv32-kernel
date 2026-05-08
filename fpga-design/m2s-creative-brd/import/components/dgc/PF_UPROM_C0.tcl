# Exporting Component Description of PF_UPROM_C0 to TCL
# Family: PolarFire
# Part Number: MPF300TS-1FCG484I
# Create and Configure the core component PF_UPROM_C0
create_and_configure_core -core_vlnv {Actel:SgCore:PF_UPROM:*} -download_core -component_name {PF_UPROM_C0} -params "\
CFGFILE:$scriptDir/import/components/dgc/PF_UPROM_C0_0/UPROM.cfg "
# Exporting Component Description of PF_UPROM_C0 to TCL done
