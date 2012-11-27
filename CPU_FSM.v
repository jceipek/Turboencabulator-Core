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
  parameter reg_zero = 0;
  parameter reg_ra = 31;

  // stage parameters
  parameter IFetch    = 3'b000;
  parameter Decode    = 3'b001;
  parameter Execute   = 3'b010;
  parameter Memory    = 3'b011;
  parameter Writeback = 3'b100;

  // opcode parameters
  // R-type
  parameter RTYPE = 6'b000000;

  // I-type
  parameter ADDI  = 6'b001000; //code complete: test pending
  parameter ADDIU = 6'b001001; //code complete: test pending
  parameter ANDI  = 6'b001100; //code complete: test pending
  parameter BEQ   = 6'b000100; //code complete: test pending
  parameter BNE   = 6'b000101; //code complete: test pending
  parameter LW    = 6'b100011; //code complete: test pending
  parameter ORI   = 6'b001101; //code complete: test pending
  parameter SW    = 6'b101011; //code complete: test pending

  // J-type
  parameter J     = 6'b000010; //code complete: test pending
  parameter JAL   = 6'b000011; //code complete: test pending

  // RTYPE parameters
  parameter ADD     = 6'b100000; //code complete: test pending
  parameter ADDU    = 6'b100001; //code complete: test pending
  parameter AND     = 6'b100100; //code complete: test pending
//  parameter BREAK   = 6'b001101;
  parameter DIV     = 6'b011010; //code complete: test pending
  parameter DIVU    = 6'b011011; //code complete: test pending
  parameter JR      = 6'b001000; //code complete: test pending
  parameter MFHI    = 6'b010000; //code complete: test pending
  parameter MFLO    = 6'b010010; //code complete: test pending
  parameter MTHI    = 6'b010001; //code complete: test pending
  parameter MTLO    = 6'b010011; //code complete: test pending
  parameter MULT    = 6'b011000; //code complete: test pending
  parameter MULTU   = 6'b011001; //code complete: test pending
  parameter NOR     = 6'b100111; //code complete: test pending
  parameter OR      = 6'b100101; //code complete: test pending
  parameter SLL     = 6'b000000; //code complete: test pending
  parameter SLLV    = 6'b000100; //code complete: test pending
  parameter SLT     = 6'b101010; //code complete: test pending
  parameter SLTU    = 6'b101011; //code complete: test pending
  parameter SRA     = 6'b000011; //code complete: test pending
  parameter SRAV    = 6'b000111; //code complete: test pending
  parameter SRL     = 6'b000010; //code complete: test pending
  parameter SRLV    = 6'b000110; //code complete: test pending
  parameter SUB     = 6'b100010; //code complete: test pending
  parameter SUBU    = 6'b100011; //code complete: test pending
  parameter SYSCALL = 6'b001100;
  parameter XOR     = 6'b100110; //code complete: test pending

  // CPU regs
  reg clk = 0;
  reg [3:0] stage = IFetch;

  reg [9:0] ProgCounter = 0;
  reg [31:0] HiValue;
  reg [31:0] LoValue;
  
  wire [31:0] IRegisterWire;
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

  // instantiate the regFile
  reg WriteEnable;
  reg [4:0] WriteRegister;
  reg [31:0] WriteData;
  wire [4:0] ReadRegister1, ReadRegister2;
  wire [31:0] ReadData1, ReadData2;
  regFile regFile_0(ReadData1, ReadData2, WriteData, ReadRegister1, ReadRegister2, WriteRegister, WriteEnable, clk);

  IMemory IMemory_0(IRegisterWire, clk, ProgCounter);
        
  always begin
    #HALFCLK clk = ~clk;
  end

  always @(posedge clk) begin
    case(stage)
      IFetch: begin
        // load memory module, give clock and pc, store stuff in IRegister
        ProgCounter <= ProgCounter + 4;
        stage <= Decode;
        assign IRegister = IRegisterWire;
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
        // Read rS_value and rT_value
        assign WriteEnable = Read;
        assign rS = ReadRegister1;
        assign rT = ReadRegister2;
        assign rS_value = ReadData1;
        assign rT_value = ReadData2;
            
        case(opcode)
          // R-type Execute
          RTYPE: begin
            case(funct)
              ADD, ADDU: begin //right now everything is unsigned... not a priority
                resExecute <= rS_value + rT_value;
                stage <= Writeback;
              end
              
              AND: begin
                resExecute <= rS_value & rT_value;
                stage <= Writeback;
              end
              
              DIV, DIVU: begin //right now everything is unsigned... not a priority
                HiValue <= rS_value % rT_value;
                LoValue <= rS_value / rT_value;
                stage <= IFetch;
              end
              
              JR: begin
                ProgCounter <= rS_value;
                stage <= IFetch;
              end
              
              MFHI: begin //maybe this should be in Writeback for consistency, but we're cutting down on time
                WriteRegister <= rD;
                WriteData <= HiValue;
                WriteEnable <= Write;
                stage <= IFetch;
              end
              
              MFLO: begin //maybe this should be in Writeback for consistency, but we're cutting down on time
                WriteRegister <= rD;
                WriteData <= LoValue;
                WriteEnable <= Write;
                stage <= IFetch;
              end
              
              MTHI: begin
                HiValue <= rS_value;
                stage <= IFetch;
              end
              
              MTLO: begin
                LoValue <= rS_value;
                stage <= IFetch;
              end
              
              MULT, MULTU: begin //right now everything is unsigned... not a priority
                {HiValue, LoValue} <= rS_value * rT_value;
                stage <= IFetch;
              end
              
              NOR: begin
                resExecute <= ~(rS_value | rT_value);
                stage <= Writeback;
              end
              
              OR: begin
                resExecute <= rS_value | rT_value;
                stage <= Writeback;
              end
              
              SLL: begin
                resExecute <= rT_value << shamt;
                stage <= Writeback;
              end
              
              SLLV: begin
                resExecute <= rT_value << rS_value[4:0];
                stage <= Writeback;
              end
              
              SLT, SLTU: begin //right now everything is unsigned... not a priority
                resExecute <= rS_value < rT_value;
                stage <= Writeback;
              end
              
              SRA: begin
                resExecute <= rT_value >>> shamt;
                stage <= Writeback;
              end
              
              SRAV: begin
                resExecute <= rT_value >>> rS_value[4:0];
                stage <= Writeback;
              end
              
              SRL: begin
                resExecute <= rT_value >> shamt;
                stage <= Writeback;
              end
              
              SRLV: begin
                resExecute <= rT_value >> rS_value[4:0];
                stage <= Writeback;
              end
              
              SUB, SUBU: begin //right now everything is unsigned... not a priority
                resExecute <= rS_value - rT_value;
                stage <= Writeback;
              end
              
              SYSCALL: $stop();
              
              XOR: begin
                resExecute <= rS_value ^ rT_value;
                stage <= Writeback;
              end

              // funct undefined
              default: $display("DIE IN RTYPE EXECUTE");
            endcase
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
            // Write to reg_ra
            WriteRegister <= reg_ra;
            WriteData <= ProgCounter;
            WriteEnable <= Write;
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
              ADD, ADDU, AND, NOR, OR, SLL, SLLV, SLT, SLTU, SRA, SRAV, SRL, SRLV, SUB, SUBU, XOR: begin
                WriteRegister <= rD;
                WriteData <= resExecute;
                WriteEnable <= Write;
              end

              // funct undefined
              default: $display("DIE IN RTYPE WRITEBACK");
            endcase
          end

          // I-type Writeback
          ADDI, ADDIU, ANDI, ORI: begin
            WriteRegister <= rT;
            WriteData <= resExecute;
            WriteEnable <= Write;
          end
          
          BEQ, BNE: if (resExecute) ProgCounter <= ProgCounter + imm;
          
          LW: begin
            WriteRegister <= rT;
            WriteData <= resMemory;
            WriteEnable <= Write;
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