module UART(
   // Outputs
   uart_busy,   // High means UART is transmitting
   uart_tx,     // UART transmit wire
   // Inputs
   uart_wr_i,   // Raise to transmit byte
   uart_dat_i,  // 8-bit data
   sys_clk_i,   // System clock, 68 MHz
   rst    // System reset
);

  input uart_wr_i;
  input reg [7:0] uart_dat_i;
  input sys_clk_i;
  input rst;

  output uart_busy;
  output uart_tx;

  reg [3:0] bitcount;
  reg [8:0] shifter;
  reg uart_tx;

  wire uart_busy;
  wire sending;
  // sys_clk_i is 68MHz.  We want a 115200Hz clock

//  reg [28:0] d;
//  wire [28:0] dInc = d[28] ? (115200) : (115200 - 50000000);
//  wire [28:0] dNxt = d + dInc;
//  always @(posedge sys_clk_i)
//  begin
//    d = dNxt;
//  end
//  wire ser_clk = ~d[28]; // this is the 115200 Hz clock
   
	assign  uart_busy = |bitcount[3:1];
	assign  sending = |bitcount;
	
  always @(posedge sys_clk_i, negedge rst)
  begin
    if (!rst) begin
      uart_tx <= 1;
      bitcount <= 0;
      shifter <= 0;
    end else begin
      // just got a new byte
      if (uart_wr_i & ~uart_busy) begin
        shifter <= {uart_dat_i[7:0],1'h0};
        bitcount <= (1 + 8 + 2);
      end

      if (sending) begin
        { shifter, uart_tx } <= { 1'h1, shifter };
        bitcount <= bitcount - 1;
      end
    end
  end

endmodule
