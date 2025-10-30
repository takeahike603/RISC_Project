// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on

module ajcRISC_HSMIOP_v_tb;
	reg Reset_tb, Clock_tb, PB1_tb;
	reg [3:0] SW_tb;
	wire [7:0] LEDs_tb;
	wire [95:0] ICis_tb;
	wire [2:0] crtMCis_tb;
	integer i;

ajcRISC_v muv	(Reset_tb, Clock_tb, PB1_tb, 
				SW_tb, LEDs_tb, ICis_tb, crtMCis_tb);
	
initial	begin	
//----------------------------------------------------------------------------
//	Reset_tb, Clock_tb, PB1_tb, SW_tb, LEDs_tb, 
// ICis_tb, crtMCis_tb
//----------------------------------------------------------------------------
//-- Test Vector 1 (40ns): Reset
//----------------------------------------------------------------------------
	for (i=0; i<5; i=i+1)
		apply_test_vector(1, 0, 1, 4'b0000);
//----------------------------------------------------------------------------
//-- All other test vectors
//----------------------------------------------------------------------------
	for (i=0; i<30; i=i+1)
		apply_test_vector(0, 0, 1, 4'b0000);
	for (i=30; i<650; i=i+1)
		apply_test_vector(0, 0, 1, 4'b1111);
end

task apply_test_vector;
	input	Reset_int, Clock_int, PB1_int;
	input	[3:0] SW_int;
	
	begin
		Reset_tb = Reset_int; Clock_tb = Clock_int; 
		PB1_tb = PB1_int; SW_tb = SW_int;
		#25000;
		Clock_tb = 1;
		#25000;
	end
endtask
endmodule
