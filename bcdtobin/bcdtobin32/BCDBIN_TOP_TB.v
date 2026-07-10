`timescale 1ns / 1ps

module BCDBIN_TOP_TB;

reg clk;
reg rst;
reg init;

reg [31:0] bcdin;

wire [31:0] B;
wire done;


//==================================
// INSTANCIA DEL DUT
//==================================

BCDBIN_TOP uut (

    .clk(clk),
    .rst(rst),
    .init(init),

    .bcdin(bcdin),

    .B(B),
    .done(done)

);


//==================================
// PARAMETROS DE RELOJ
//==================================

parameter PERIOD = 20;
parameter real DUTY_CYCLE = 0.5;


//==================================
// GENERACION DEL CLOCK
//==================================

initial begin

    clk = 0;

    forever begin

        #(PERIOD*(1.0-DUTY_CYCLE))
        clk = ~clk;

        #(PERIOD*DUTY_CYCLE)
        clk = ~clk;

    end

end;


//==================================
// ESTIMULOS
//==================================

initial begin

    //==============================
    // VALORES INICIALES
    //==============================

    rst   = 1;
    init  = 0;

    // BCD = 12345678
    bcdin = 32'h00000025;   // Debe producir 25


    //==============================
    // RESET
    //==============================

    #40;
    rst = 0;


    //==============================
    // INICIO
    //==============================

    @(posedge clk);
    init = 1;

    @(posedge clk);
    init = 0;


    //==============================
    // ESPERAR FINALIZACION
    //==============================

    wait(done);


    //==============================
    // MOSTRAR RESULTADO
    //==============================

    $display("=================================");
    $display("BCD     = %h", bcdin);
    $display("Binario = %d", B);
    $display("=================================");


    //==============================
    // FINALIZAR SIMULACION
    //==============================

    #50;
    $finish;

end;


//==================================
// GENERACION DE VCD
//==================================

initial begin

    $dumpfile("BCDBIN_TOP_TB.vcd");
    $dumpvars(0, BCDBIN_TOP_TB);

end

endmodule