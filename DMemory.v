/* DMemory.v
part of project Turboencabulator
Julian Ceipek, Yuxin Guan, Philip Z Loh, Sasha Sproch
Computer Architecture, Olin College Fall 2012 */

module memory(clk, regWE, Addr,
                DataIn, DataOut);
  input clk, regWE;
  input[9:0] Addr;
  input[31:0] DataIn;
  output[31:0]  DataOut;
  integer index;
  reg [31:0] mem[1023:0]; // 1024 rows of 32-bit lines

  always @(posedge clk) begin
    if (regWE)
      mem[Addr] <= DataIn;
  end

  initial begin
    // Read the code into memory
    $readmemb("add.dat", mem);

    // Loop through every row of memory and display it
    for(index = 0; index < 1024; index = index + 1) begin
        $display("mem[%d] = %b", index[9:0], mem[index]);
    end
  end

  assign DataOut = mem[Addr];

endmodule
