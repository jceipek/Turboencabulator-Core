// FluffyTheGatekeeper
module CPU_FSM();
  // CPU parameters
  parameter HALFCLK = 5;
  
  // Stage parameters
  parameter IFetch = 4'h0;
  parameter Decode = 4'h1;
  parameter Execute = 4'h2;
  parameter Memory = 4'h3;
  parameter Writeback = 4'h4;

  // Op parameters
  parameter ADD = 6'h0;
  
  reg [3:0] state;
  reg [3:0] op;
  reg clk;

  always begin
    #HALFCLK clk = ~clk;
  end
  
  always @(posedge clk) begin
    case(state)
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
        case(op)
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
        case(op)
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
        case(op)
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