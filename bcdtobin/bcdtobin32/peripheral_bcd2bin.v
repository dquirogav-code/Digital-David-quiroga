module peripheral_bcd2bin(

    input clk,
    input reset,

    input [31:0] d_in,

    input cs,
    input [4:0] addr,
    input rd,
    input wr,

    output reg [31:0] d_out

);

//==================================================
// Registros internos
//==================================================

reg [31:0] bcdin;
reg init;

wire [31:0] B;
wire done;

//==================================================
// Escritura
//==================================================

always @(posedge clk or posedge reset) begin

    if(reset) begin

        bcdin <= 32'd0;
        init  <= 1'b0;

    end
    else begin

        // init es un pulso de un ciclo
        init <= 1'b0;

        if(cs && wr) begin

            case(addr)

                5'h04:
                    bcdin <= d_in;

                5'h0C:
                    init <= 1'b1;

                default: begin
                end

            endcase

        end

    end

end

//==================================================
// Lectura
//==================================================

always @(*) begin

    d_out = 32'd0;

    if(cs && rd) begin

        case(addr)

            5'h10:
                d_out = B;

            5'h14:
                d_out = {31'd0,done};

            default:
                d_out = 32'd0;

        endcase

    end

end

//==================================================
// Conversor
//==================================================

BCDBIN_TOP bcd2bin0(

    .clk(clk),
    .rst(reset),
    .init(init),

    .bcdin(bcdin),

    .B(B),
    .done(done)

);

endmodule