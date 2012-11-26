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
  parameter RTYPE = 6'b000000;
  
  // RTYPE parameters
  parameter ADD = 6'b100000;
  parameter ADDU = 6'b100001;
  parameter SUB = 6'b100010;
  parameter SUBU = 6'b100011;
  
  reg [3:0] stage;
  reg [5:0] opcode;
  reg clk;
  reg [4:0] destReg;
  reg [4:0] rA;
  reg [4:0] rB;
  reg [15:0] imm;
  reg [4:0] rD;
  reg [4:0] shamt;
  reg [5:0] funct;
  reg [31:0] IRegister;
  reg [9:0] ProgCounter;
  
  integer resExecute;

  always begin
    #HALFCLK clk = ~clk;
  end
  
  always @(posedge clk) begin
    case(stage)
      IFetch: begin
        // load memory module, give clock and pc, store stuff in IRegister
        //IMemory myMem (IRegister, clk, ProgCounter);
        ProgCounter <= ProgCounter + 4;
        stage <= Decode;
      end
      
      Decode: begin
        // split IRegister into rA, rB, imm, rD, shamt, and funct
        opcode <= IRegister[31:26]; 
        rA <= IRegister[25:21];
        rB <= IRegister[20:16];
        imm <= IRegister[15:0];
        rD <= IRegister[15:11];
        shamt <= IRegister[10:6];
        funct <= IRegister[5:0];
        stage <= Execute;
      end
      
      Execute: begin
        case(opcode)
          RTYPE: begin
            case(funct)
              ADD: resExecute <= IRegister[rA] + IRegister[rB];                

              // funct undefined
              default: $display("DIE IN RTYPE EXECUTE");
            endcase
            stage <= Writeback;
          end
          
          // opcode undefined
          default: $display("DIE IN EXECUTE");
        endcase
      end
        
      Memory: begin
        case(opcode)
          // opcode undefined
          default: $display("DIE IN MEMORY");
        endcase
        stage <= Writeback;
      end 
        
      Writeback: begin
        case(opcode)
          RTYPE: begin
            case(funct)
              ADD: IRegister[rD] <= resExecute;
              
              // funct undefined
              default: $display("DIE IN RTYPE WRITEBACK");
            endcase
          end

          // opcode undefined
          default: $display("DIE IN WRITEBACK");
        endcase
        stage <= IFetch;
      end
      
      // stage undefined  
      default: $display("DIE");
    endcase
  end
endmodule