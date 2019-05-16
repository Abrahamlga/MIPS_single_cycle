// TB Top module, includes GPIO block and MIPS_arch
// Jesus Abraham Lizarraga Banuelos
// Mar-24-2018
// TB_Top_module.sv
//


timeunit 1ns;
timeprecision 100ps;

module TB_Top_module;
   parameter BIT_WIDTH=32;
   parameter BIT_SEL=3;
   parameter BIT_CTRL=5;

`define PERIOD 10

 logic clk, rst;
 logic W_UART;
 logic [BIT_WIDTH-1:0] UART_DATA;
 logic [BIT_WIDTH-1:0] UART_RX;

MIPS_arch_single MIPS_arch_single1(.*);

always
 begin
    #(`PERIOD/2) clk = ~clk;
 end

initial
begin
 W_UART=1'b1;
 UART_DATA=32'h5;
//output UART_RX;
 rst=0;
 clk=0;
 #(`PERIOD * 5);
 W_UART=1'b0;
 rst=1;
 #(`PERIOD * 1500);
 $finish;
end


endmodule
