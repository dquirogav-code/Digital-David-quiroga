module peripheral_sqrt(
    clk,
    reset,
    d_in,
    cs,
    addr,
    rd,
    wr,
    d_out
);

input clk;
input reset;

input [31:0] d_in;

input cs;
input [4:0] addr;
input rd;
input wr;

output reg [31:0] d_out;


//--------------------------------------------------
// Registros
//--------------------------------------------------

reg [4:0] s;

reg [31:0] A;
reg init;

wire [31:0] result;
wire done;


//--------------------------------------------------
// Decoder
//--------------------------------------------------

always @(*) begin

    if(cs) begin

        case(addr)

            5'h04:
                s = 5'b00001; // A

            5'h0C:
                s = 5'b00100; // init

            5'h10:
                s = 5'b01000; // result

            5'h14:
                s = 5'b10000; // done

            default:
                s = 5'b00000;

        endcase

    end
    else begin

        s = 5'b00000;

    end

end



//--------------------------------------------------
// Escritura
//--------------------------------------------------

always @(negedge clk) begin

    if(reset) begin

        A <= 32'd0;
        init <= 1'b0;

    end

    else begin

        // init es un pulso
        init <= 1'b0;


        if(cs && wr) begin


            if(s[0])
                A <= d_in;


            if(s[2])
                init <= d_in[0];


        end

    end

end



//--------------------------------------------------
// Lectura
//--------------------------------------------------

always @(negedge clk) begin

    if(reset) begin

        d_out <= 32'd0;

    end

    else if(cs && rd) begin


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
// Raíz cuadrada
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