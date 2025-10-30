module ajc_8bit_logic_unit_v (Func_Sel, Operand_X, Operand_Y, Const_K, 
				Logic_Result, Logic_CNVZ);
//----------------------------------------------------------------------------------
// Input and output ports declarations
//----------------------------------------------------------------------------------
	input [1:0] Func_Sel;
	input [7:0] Operand_X, Operand_Y;
	input [1:0] Const_K;
	output [7:0] Logic_Result;
	output [3:0] Logic_CNVZ;
//----------------------------------------------------------------------------------
// Internal signals declarations
//----------------------------------------------------------------------------------
	wire [7:0] or_result, and_result, xor_result;
//----------------------------------------------------------------------------------
// The logic_mux instance
//----------------------------------------------------------------------------------
	ajc_nbit_4to1mux_v #8	logic_mux
		(.d3(Operand_X), .d2(or_result), .d1(and_result), .d0(xor_result), .s(Func_Sel[1:0]), .f(Logic_Result));
//----------------------------------------------------------------------------------
// The outputs calculations
//----------------------------------------------------------------------------------
	assign xor_result = Operand_X ^ Operand_Y;
	assign and_result = Operand_X & Operand_Y;
	assign or_result = Operand_X | Operand_Y;
//----------------------------------------------------------------------------------	
	assign Logic_CNVZ = {1'b0, Logic_Result[7], 1'b0, ~| Logic_Result};
//----------------------------------------------------------------------------------	
endmodule