
# MIV RV32 Demo Design for Polarfire Eval Kit

### CFG2

This design makes use of the MIV_ESS Block for the peripherals.
Following peripherals are enabled

-`GPIO`
-`UART`
-`SPI`
-`Timer`




Ths uses the same memory map as the `CFG1` design. So the same software will work.  


```
$python3 build_gateware ./configs/PF_EVAL_CFG2.yaml


```



Generate the Libero Project


setup the libero environemnt variables usign the provided script file. modify if needed.

```
$source setup-microchip-tools.sh
```
generate the CFG1  design file for basic application usign the belwo command
configurtiosn are store in the .yaml file. 

`CFG1` has the below peripherals selected.

- `CoreUART`
- `CoreTimer`
- `CoreGPIO`
- `CoreSPI`


```
$python3 build_gateware ./configs/config_CREATIVE_CFG1.yaml
```

```


## YMODEM


Use `CFG3`  when using  ymodem in the design. This design enables use of esram of MSS along with the DDR memory

`CONFIG3` has the  same peripheral set as `CFG2` .

- `CoreUART`
- `CoreTimer`
- `CoreGPIO`
- `CoreSPI`
- Two Interrupt on the MIV_RV32 side as well enabled compared to 1 interrupt in the `CONFIG1` design.

`CFG3` uses only the AHB interface for `RV32`, This is mapped to use from `0x20000000 - 0x8fffffff` . 
An AHBLITe interface is used to connect the MSS susbsystem of DDR and ESRAM to this. `Slot2` is connected to `FIC-0` of MSS, `Slot8` is connected to `MSS_DDR` interface.
`Slot7` is connected to the AHBTOAPB and further to the `MIV_ESS` block. THis way the design has the same memory map as other CONFIGs.



```
$python3 build_gateware ./configs/config_CREATIVE_CFG3.yaml


10th May 2026
