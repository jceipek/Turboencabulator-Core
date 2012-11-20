
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
<<<<<<< HEAD
  
reg [31:0] mem[31:0];  
=======

  integer index;

reg [31:0] mem[1023:0];
>>>>>>> 626e0c88375452f8f0446c3eb7746bc11cb86e09

always @(posedge clk)
  if (regWE)
    mem[Addr] <= DataIn;

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
