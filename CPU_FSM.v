/* CPU_FSM.v
part of project Turboencabulator
Julian Ceipek, Yuxin Guan, Philip Z Loh, Sasha Sproch
Computer Architecture, Olin College Fall 2012 */

`include "IMemory.v"
`include "regFile.v"

module CPU_FSM();
  // CPU parameters
  parameter HALFCLK = 5;

  // regfile parameters
  parameter Read  = 0;
  parameter Write = 1;
  parameter NULL  = 0;
  parameter reg_ra = 31;

  // stage parameters
  parameter IFetch    = 4'h0;
  parameter Decode    = 4'h1;
  parameter Execute   = 4'h2;
  parameter Memory    = 4'h3;
  parameter Writeback = 4'h4;

  // opcode parameters
  // R-type
  parameter RTYPE = 6'b000000;

  // I-type
  parameter ADDI  = 6'b001000;
  parameter ADDIU = 6'b001001;
  parameter ANDI  = 6'b001100;
  parameter BEQ   = 6'b000100;
  parameter BNE   = 6'b000101;
  parameter LW    = 6'b100011;
  parameter ORI   = 6'b001101;
  parameter SW    = 6'b101011;

  // J-type
  parameter J     = 6'b000010;
  parameter JAL   = 6'b000011;

  // RTYPE parameters
  parameter ADD     = 6'b100000; //code complete: test pending
  parameter ADDU    = 6'b100001; //code complete: test pending
  parameter AND     = 6'b100100; //code complete: test pending
//  parameter BREAK   = 6'b001101;
//  parameter DIV     = 6'b011010;
//  parameter DIVU    = 6'b011011;
//  parameter JR      = 6'b001000;
//  parameter MFHI    = 6'b010000;
//  parameter MFLO    = 6'b010010;
//  parameter MTHI    = 6'b010001;
//  parameter MTLO    = 6'b010011;
//  parameter MULT    = 6'b011000;
//  parameter MULTU   = 6'b011001;
  parameter NOR     = 6'b100111; //code complete: test pending
  parameter OR      = 6'b100101; //code complete: test pending
  parameter SLL     = 6'b000000; //code complete: test pending
  parameter SLLV    = 6'b000100; //code complete: test pending
  parameter SLT     = 6'b101010; //code complete: test pending
//  parameter SLTU    = 6'b101011;
  parameter SRA     = 6'b000011; //code complete: test pending
  parameter SRAV    = 6'b000111; //code complete: test pending
  parameter SRL     = 6'b000010; //code complete: test pending
  parameter SRLV    = 6'b000110; //code complete: test pending
  parameter SUB     = 6'b100010; //code complete: test pending
  parameter SUBU    = 6'b100011; //code complete: test pending
//  parameter SYSCALL   = 6'b001100;
  parameter XOR     = 6'b100110; //code complete: test pending

  // CPU regs
  reg clk;
  reg [3:0] stage;
  reg [9:0] ProgCounter;
  reg [31:0] IRegister;
  reg [5:0] opcode;
  reg [4:0] rS;
  reg [4:0] rT;
  reg [4:0] rD;
  reg [4:0] shamt;
  reg [5:0] funct;
  reg [15:0] imm;
  reg [25:0] jumpaddr;

  // shortcuts
  reg [31:0] rS_value;
  reg [31:0] rT_value;
  reg [31:0] resMemory;
  reg [31:0] resExecute;

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
        // split IRegister into rS, rT, imm, rD, shamt, and funct
        opcode <= IRegister[31:26];
        rS <= IRegister[25:21];
        rT <= IRegister[20:16];
        rD <= IRegister[15:11];
        shamt <= IRegister[10:6];
        funct <= IRegister[5:0];
        imm <= IRegister[15:0];
        jumpaddr <= IRegister[25:0];
        stage <= Execute;
      end

      Execute: begin
        case(opcode)
          // R-type Execute
          RTYPE: begin
            regFile regFile_RTYPEExecute (rS_value, rT_value, NULL, rS, rT, NULL, Read, clk);
            case(funct)
              ADD, ADDU: resExecute <= rS_value + rT_value; //right now everything is unsigned... flags are deprioritized
              AND: resExecute <= rS_value & rT_value;
              NOR: resExecute <= ~(rS_value | rT_value);
              OR: resExecute <= rS_value | rT_value;
              SLL: resExecute <= rT_value << shamt;
              SLLV: resExecute <= rT_value << rS_value[4:0];
              SLT: resExecute <= rS_value < rT_value;
              SRA: resExecute <= rT_value >>> shamt;
              SRAV: resExecute <= rT_value >>> rS_value[4:0];
              SRL: resExecute <= rT_value >> shamt;
              SRLV: resExecute <= rT_value >> rS_value[4:0];
              SUB, SUBU: resExecute <= rS_value - rT_value; //right now everything is unsigned... flags are deprioritized
              XOR: resExecute <= rS_value ^ rT_value;

              // funct undefined
              default: $display("DIE IN RTYPE EXECUTE");
            endcase
            stage <= Writeback;
          end

          // I-type Execute
          ADDI: begin
            resExecute <= rS_value + imm;
            stage <= Writeback;
          end

          ADDIU: begin
            resExecute <= rS_value + imm;
            stage <= Writeback;
          end

          ANDI: begin
            resExecute <= rS_value & imm;
            stage <= Writeback;
          end

          BEQ: begin
            resExecute <= rS_value == rT_value;
            stage <= Writeback;
          end

          BNE: begin
            resExecute <= rS_value != rT_value;
            stage <= Writeback;
          end

          LW, SW: begin
            resExecute <= rS_value + imm;
            stage <= Memory;
          end

          ORI: begin
            resExecute <= rS_value | imm;
            stage <= Writeback;
          end

          // J-type Execute
          J: begin
            ProgCounter <= jumpaddr;
            stage <= IFetch;
          end

          JAL: begin
            regFile regFile_JALExecute(NULL, NULL, ProgCounter, NULL, NULL, reg_ra, Write, clk);
            ProgCounter <= jumpaddr;
            stage <= IFetch;
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
          // R-type Writeback
          RTYPE: begin
            case(funct)
              ADD, ADDU, AND, NOR, OR, SLL, SLLV, SLT, SRA, SRAV, SRL, SRLV, SUB, SUBU, XOR: rD_value <= resExecute;

              // funct undefined
              default: $display("DIE IN RTYPE WRITEBACK");
            endcase
          end

          // I-type Writeback
          ADDI, ADDIU, ANDI, ORI: IRegister[rT_value] <= resExecute;
          BEQ, BNE: if (resExecute) ProgCounter <= ProgCounter + imm;
          LW: IRegister[rT_value] <= resMemory;

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