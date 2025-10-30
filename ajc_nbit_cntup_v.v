module ajc_nbit_cntup_v 
	(d, ld, reset, cntup, clock, q);
	parameter n = 8;
	input [n-1:0] d;
	input ld, reset, cntup, clock;
	output reg [n-1:0] q;
// n-bit register
	always @(posedge clock)
		if (reset == 1'b1) q = 0;
		else if (ld == 1'b1) q = d;
		else if (cntup == 1'b1)
			q <= q + 1'b1;
		else q = q;
endmodule
