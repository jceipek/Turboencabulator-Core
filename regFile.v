/* regFile.v
part of project Turboencabulator
Julian Ceipek, Yuxin Guan, Philip Z Loh, Sasha Sproch
Computer Architecture, Olin College Fall 2012 */

module regFile (ReadData1, ReadData2, WriteData, ReadRegister1, ReadRegister2, WriteRegister, RegWrite, clk);
  input clk, RegWrite;
  input [4:0] ReadRegister1, ReadRegister2, WriteRegister;
  input [31:0] WriteData;
  output reg [31:0] ReadData1, ReadData2;
  
  reg [31:0] registers [31:0]; //32 registers each 32-long
  
// Synchronous write logic
  always @(posedge clk) begin
    if (RegWrite) registers[WriteRegister] <= WriteData;
    
    // Asynchronous read logic
    assign ReadData1 = registers[ReadRegister1];
    assign ReadData2 = registers[ReadRegister2];
  end
endmodule

