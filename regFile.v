
/* regFile.v
part of project Turboencabulator
Julian Ceipek, Yuxin Guan, Philip Z Loh, Sasha Sproch
Computer Architecture, Olin College Fall 2012 */

module regFile (DaraOut, clk, regWE, Addr, 
                DataIn);
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

