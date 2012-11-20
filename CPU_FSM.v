/* CPU_FSM.v
part of project Turboencabulator
Julian Ceipek, Yuxin Guan, Philip Z Loh, Sasha Sproch
Computer Architecture, Olin College Fall 2012 */

`include "IMemory.v"

module CPU_FSM();
  // CPU parameters
  parameter HALFCLK = 5;
  
  // stage parameters
  parameter IFetch = 4'h0;
  parameter Decode = 4'h1;
  parameter Execute = 4'h2;
  parameter Memory = 4'h3;
  parameter Writeback = 4'h4;

  // opcode parameters
  parameter ADD = 6'h0;
  
  reg [3:0] stage;
  reg [5:0] opcode;
  reg clk;
  reg [15:0] imm;
  reg [4:0] destReg;
  reg [4:0] rA;
  reg [4:0] rB;
  reg [31:0] register;
  reg [9:0] ProgCounter;

  always begin
    #HALFCLK clk = ~clk;
  end
  
  always @(posedge clk) begin
    case(stage)
      IFetch:
        begin
          // load memory module, give clock and pc, store stuff in dataOut
          // NEED ProgCounter!!!
          IMemory myMem (register, clk, ProgCounter);
        stage = Decode;
        end
      Decode:
        begin
          // split register into rA, rB, rC, and rD
          opcode = register[31:26]; 
          rA = register[25:21];
          rB = register[20:26];
          imm = register[15:0];
        stage = Execute;
        end
      Execute:
        begin
          resExecute = register[rA] + register[rB]
        case(opcode)
          //ADD:
            //;

          // if we screw up
          default:
            $display("DIE");
        endcase
        stage = Memory;
        end
      Memory:
        begin
        case(opcode)
          //ADD:
            //;

          // if we screw up
          default:
            $display("DIE");
        endcase
        stage = Writeback;
        end
      Writeback:
        begin
        case(opcode)
        //  ADD:
           // ;

          // if we screw up
          default:
            $display("DIE");
        endcase
        stage = IFetch;
        end
        
      // if we screw up
      default:
        $display("DIE");
    endcase
  end
endmodule