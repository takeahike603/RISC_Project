module ajc_8bit_sr_unit_v (Func_Sel, Operand_X, Operand_Y, Const_K, Cin,
				SR_Result, SR_CNVZ);
//----------------------------------------------------------------------------------
// Input and output ports declarations
//----------------------------------------------------------------------------------
	input [1:0] Func_Sel;
	input [7:0] Operand_X, Operand_Y;
	input [1:0] Const_K;
	input Cin;
	output [7:0] SR_Result;
	output [3:0] SR_CNVZ;
//----------------------------------------------------------------------------------
// Internal signals declarations
//----------------------------------------------------------------------------------
	wire [7:0] shra, shra0, shra1, shra2, shra3, shll, shll0, shll1, shll2, shll3,
	rrc, rrc0, rrc1, rrc2, rrc3;
	wire cout_rrc, cout;
//----------------------------------------------------------------------------------
// The sr_mux instance
//----------------------------------------------------------------------------------
	ajc_nbit_4to1mux_v #8	sr_mux
		(.d3(Operand_Y), .d2(rrc), .d1(shll), .d0(shra), .s(Func_Sel[1:0]), .f(SR_Result));
		
	ajc_nbit_4to1mux_v #8 cout_mux (.d3(0), .d2(cout_rrc), .d1(0), .d0(0), .s(Func_Sel[1:0]), .f(cout));
//----------------------------------------------------------------------------------
// Using two nested conditional operators to calculate shra.
// You will need to do the same for shll or shrl and rlc or rrc!
//----------------------------------------------------------------------------------
	assign shra = Const_K[1] ? (Const_K[0] ? shra3 : shra2) : (Const_K[0] ? shra1 : shra0);
	assign shra3 = {Operand_X[7], Operand_X[7], Operand_X[7], Operand_X[7], Operand_X[6], Operand_X[5], Operand_X[4], Operand_X[3]};
	assign shra2 = {Operand_X[7], Operand_X[7], Operand_X[7], Operand_X[6], Operand_X[5], Operand_X[4], Operand_X[3], Operand_X[2]};
	assign shra1 = {Operand_X[7], Operand_X[7], Operand_X[6], Operand_X[5], Operand_X[4], Operand_X[3], Operand_X[2], Operand_X[1]};
	assign shra0 = {Operand_X[7], Operand_X[6], Operand_X[5], Operand_X[4], Operand_X[3], Operand_X[2], Operand_X[1], Operand_X[0]};
	
	
	assign shll = Const_K[1] ? (Const_K[0] ? shll3 : shll2) : (Const_K[0] ? shll1 : shll0);
	assign shll3 = {Operand_X[4], Operand_X[3], Operand_X[2], Operand_X[1], Operand_X[0], 1'b0, 1'b0, 1'b0};
	assign shll2 = {Operand_X[5], Operand_X[4], Operand_X[3], Operand_X[2], Operand_X[1], Operand_X[0], 1'b0, 1'b0};
	assign shll1 = {Operand_X[6], Operand_X[5], Operand_X[4], Operand_X[3], Operand_X[2], Operand_X[1], Operand_X[0], 1'b0};
	assign shll0 = {Operand_X[7], Operand_X[6], Operand_X[5], Operand_X[4], Operand_X[3], Operand_X[2], Operand_X[1], Operand_X[0]};
	
	assign rrc = Const_K[1] ? (Const_K[0] ? rrc3 : rrc2) : (Const_K[0] ? rrc1 : rrc0);
	assign rrc3 = {Operand_X[1], Operand_X[0], Cin, Operand_X[7], Operand_X[6], Operand_X[5], Operand_X[4], Operand_X[3]};
	assign rrc2 = {Operand_X[0], Cin, Operand_X[7], Operand_X[6], Operand_X[5], Operand_X[4], Operand_X[3], Operand_X[2]};
	assign rrc1 = {Cin, Operand_X[7], Operand_X[6], Operand_X[5], Operand_X[4], Operand_X[3], Operand_X[2], Operand_X[1]};
	assign rrc0 = {Operand_X[7], Operand_X[6], Operand_X[5], Operand_X[4], Operand_X[3], Operand_X[2], Operand_X[1], Operand_X[0]};
	assign cout_rrc = Const_K[1] ? (Const_K[0] ? Operand_X[2] : Operand_X[1]) : (Const_K[0] ? Operand_X[0] : Cin);
	

//----------------------------------------------------------------------------------
	assign SR_CNVZ = {cout, SR_Result[7], 1'b0, ~| SR_Result};
//----------------------------------------------------------------------------------
endmodule
