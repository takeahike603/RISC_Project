module ajc_fa_struc_v (cin, x, y, sum, cout);
	input cin, x, y;
	output sum, cout;
	wire z1, z2, z3;
	
		xor (sum, x, y, cin);
		and (z1, x, y);
		and (z2, x, cin);
		and (z3, y, cin);
		or (cout, z1, z2, z3);
		
endmodule
