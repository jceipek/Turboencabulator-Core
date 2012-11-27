/* IMemory.v
part of project Turboencabulator
Julian Ceipek, Yuxin Guan, Philip Z Loh, Sasha Sproch
Computer Architecture, Olin College Fall 2012 */

`define DEBUG_MODE 0

module IMemory(DataOut, clk, ProgCounter);
    output[31:0]  DataOut;

    input clk;
    input[9:0] ProgCounter;

    reg [31:0] mem[1023:0]; // 1024 rows of 32-bit lines

    integer index; // Used only for debugging

    initial begin
        // Read the code into memory
        $readmemb("add.dat", mem, 0, 1023);

        if (`DEBUG_MODE) begin
            // Loop through every row of memory and display it
            for(index = 0; index < 1024; index = index + 1) begin
                $display("mem[%d] = %b", index[9:0], mem[index]);
            end
        end
    end

    assign DataOut = mem[ProgCounter];

endmodule