/* DMemory.v
part of project Turboencabulator
Julian Ceipek, Yuxin Guan, Philip Z Loh, Sasha Sproch
Computer Architecture, Olin College Fall 2012 */

`define DEBUG_MODE 0

module DMemory(DataOut, DataIn, ReadAddr, WriteAddr, regWE, clk);
  input clk, regWE;
  input[9:0] ReadAddr, WriteAddr;
  input[31:0] DataIn;
  output[31:0]  DataOut;
  integer index;
  reg [31:0] mem[1023:0]; // 1024 rows of 32-bit lines

  always @(posedge clk) begin
    if (regWE)
      mem[WriteAddr/4] <= DataIn;
    $writememb("DataOut.dat",mem);
  end

  initial begin
    // Read the code into memory
    $readmemb("dmemory.dat", mem);

        if (`DEBUG_MODE) begin
            // Loop through every row of memory and display it
            for(index = 0; index < 1024; index = index + 1) begin
                $display("DMem[%d] = %b", index[9:0], mem[index]);
            end
        end
  end

  assign DataOut = mem[ReadAddr/4];

endmodule
