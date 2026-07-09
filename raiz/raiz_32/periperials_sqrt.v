module peripheral_sqrt(
    input clk,
    input reset,
    input [31:0] d_in,
    input cs,
    input [4:0] addr,
    input rd,
    input wr,
    output reg [31:0] d_out
);

//--------------------------------------------------
// Registros y señales
//--------------------------------------------------
reg [4:0] s;

reg [31:0] A;
reg init;

wire [31:0] result;
wire done;

//--------------------------------------------------
// Decoder de direcciones
//--------------------------------------------------
always @(*) begin

    if(cs) begin

        case(addr)

            5'h04: s = 5'b00001;   // A
            5'h0C: s = 5'b00100;   // init
            5'h10: s = 5'b01000;   // resultado
            5'h14: s = 5'b10000;   // done

            default: s = 5'b00000;

        endcase

    end

    else
        s = 5'b00000;

end

//--------------------------------------------------
// Escritura de registros
//--------------------------------------------------
always @(negedge clk) begin

    if(reset) begin

        A    <= 32'd0;
        init <= 1'b0;

    end

    else if(cs && wr) begin

        if(s[0])
            A <= d_in;

        if(s[2])
            init <= d_in[0];

    end

end

//--------------------------------------------------
// Lectura de registros
//--------------------------------------------------
always @(negedge clk) begin

    if(reset)

        d_out <= 32'd0;

    else if(cs) begin

        case(s)

            5'b01000:
                d_out <= result;

            5'b10000:
                d_out <= {31'd0,done};

            default:
                d_out <= 32'd0;

        endcase

    end

end

//--------------------------------------------------
// Instancia del módulo de raíz cuadrada
//--------------------------------------------------
Raiz_TOP raiz0(

    .clk(clk),
    .rst(reset),
    .init(init),

    .Ain(A),

    .Raiz(result),
    .done(done)

);

endmodule