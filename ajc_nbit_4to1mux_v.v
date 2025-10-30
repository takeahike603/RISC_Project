module ajc_nbit_4to1mux_v (d3, d2, d1, d0, s, f);

parameter n = 8;
input [n-1:0] d3,d2, d1, d0;
input [1:0] s;
output [n-1:0] f;
genvar k;

generate for (k = 0; k < n; k = k + 1) begin : mux
	assign f[k] = (~s[1] & ~s[0] & d0[k]) | (~s[1] & s[0] & d1[k]) | (s[1] & ~s[0] & d2[k]) | (s[1] & s[0] & d3[k]);
	end
endgenerate

endmodule
