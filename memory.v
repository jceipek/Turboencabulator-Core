
/* memory.v
part of project Turboencabulator
Julian Ceipek, Yuxin Guan, Philip Z Loh, Sasha Sproch
Computer Architecture, Olin College Fall 2012 */

module memory(clk, regWE, Addr, 
                DataIn, DataOut);
  input clk, regWE;
  input[9:0] Addr;
  input[31:0] DataIn;
  output[31:0]  DataOut;
  
reg [31:0] mem[1023:0];  

always @(posedge clk)
  if (regWE)
    mem[Addr] <= DataIn;

initial $readmemb(?file.dat?, mem);
    
assign DataOut = registers[Addr];

endmodule
