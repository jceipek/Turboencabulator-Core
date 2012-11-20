
module regFile (clk, regWE, Addr, 
                DataIn, DataOut);
  input clk, regWE;
  input[4:0] Addr;
  input[31:0] DataIn;
  output[31:0]  DataOut;
  
reg [31:0] registers [15:0];  
// Synchronous write logic
always @(posedge clk)
  if (regWE)
    registers[Addr] <= DataIn;
    
// Asynchronous read logic
assign DataOut = registers[Addr];

endmodule
