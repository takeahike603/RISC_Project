module ajc_8bit_ALU (Func_Sel, Operand_X, Operand_Y, Const_K, Cin,
				ALU_Result, ALU_CNVZ);

	input [3:0] Func_Sel;
	input [7:0] Operand_X, Operand_Y;
	input [1:0] Const_K;
	input Cin;
	output [7:0] ALU_Result;
	output [3:0] ALU_CNVZ;
	wire [7:0] Arith_Result, Logic_Result, SR_Result, Const_Result;
	wire [3:0] Arith_CNVZ, Logic_CNVZ, SR_CNVZ, Const_CNVZ;
//----------------------------------------------------------------------------------
// The top-level 4to1muxes which select the ALU_Result and ALU_CNVZ
//----------------------------------------------------------------------------------
	ajc_nbit_4to1mux_v #8	result_mux	(.d3(Const_Result), .d2(SR_Result), .d1(Logic_Result), 
		.d0(Arith_Result[7:0]), .s(Func_Sel[3:2]), .f(ALU_Result));
	ajc_nbit_4to1mux_v #4	cnvz_mux	(.d3(Const_CNVZ), .d2(SR_CNVZ), .d1(Logic_CNVZ), 
		.d0(Arith_CNVZ), .s(Func_Sel[3:2]), .f(ALU_CNVZ));
//----------------------------------------------------------------------------------
// The arithmetic unit instance
//----------------------------------------------------------------------------------	
	ajc_8bit_arith_unit_v	arith_unit (.Func_Sel(Func_Sel[1:0]), .Operand_X(Operand_X), .Operand_Y(Operand_Y), .Const_K(Const_K), 
				.Arith_Result(Arith_Result), .Arith_CNVZ(Arith_CNVZ));
//----------------------------------------------------------------------------------
// The logic unit instance	
//----------------------------------------------------------------------------------
	ajc_8bit_logic_unit_v	logic_unit (.Func_Sel(Func_Sel[1:0]), .Operand_X(Operand_X), .Operand_Y(Operand_Y), .Const_K(Const_K), 
				.Logic_Result(Logic_Result), .Logic_CNVZ(Logic_CNVZ));
//----------------------------------------------------------------------------------
// The shift-rotate unit instance	
//----------------------------------------------------------------------------------
		
	ajc_8bit_sr_unit_v sr_unit (.Func_Sel(Func_Sel[1:0]), .Operand_X(Operand_X), .Operand_Y(Operand_Y), .Const_K(Const_K), .Cin(Cin), 
				.SR_Result(SR_Result), .SR_CNVZ(SR_CNVZ));
//----------------------------------------------------------------------------------
// The constant output unit instance
//----------------------------------------------------------------------------------
	ajc_8bit_const_unit_v const_unit (.Func_Sel(Func_Sel[1:0]), .Const_Result(Const_Result), .Const_CNVZ(Const_CNVZ));


endmodule
