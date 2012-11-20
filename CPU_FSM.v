/* CPU_FSM.v
part of project Turboencabulator
Julian Ceipek, Yuxin Guan, Philip Z Loh, Sasha Sproch
Computer Architecture, Olin College Fall 2012 */

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

  always begin
    #HALFCLK clk = ~clk;
  end
  
  always @(posedge clk) begin
    case(stage)
      IFetch:
        begin
        state = Decode;
        end
      Decode:
        begin
        state = Execute;
        end
      Execute:
        begin
        case(opcode)
          ADD:
            ;

          // if we screw up
          default:
            $display("DIE");
        endcase
        state = Memory;
        end
      Memory:
        begin
        case(opcode)
          ADD:
            ;

          // if we screw up
          default:
            $display("DIE");
        endcase
        state = Writeback;
        end
      Writeback:
        begin
        case(opcode)
          ADD:
            ;

          // if we screw up
          default:
            $display("DIE");
        endcase
        state = IFetch;
        end
        
      // if we screw up
      default:
        $display("DIE");
    endcase
  end
endmodule