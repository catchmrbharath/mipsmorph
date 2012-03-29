module branchPredictor (
    output prediction,
    input [9:0] pc_D,
    input [9:0] pc_E,
	input update_enable,
	input update_value,
    input clk );
	
	reg [9:0] local_history_table [0:1023];
	reg [2:0] local_pattern_table [0:1023];
	reg [1:0] global_pattern_table [0:4095];
	reg [1:0] choice_pattern_table [0:4095];
	
	wire [2:0] local_prediction;
	wire [1:0] global_prediction;
	wire [1:0] choice_prediction;
	reg [11:0] path_history;
	reg [9:0] last_pc_D;
	wire [9:0] local_history;
	wire prediction;
	
	reg [12:0] k;
	
    initial begin
		for (k = 0; k < 1024; k = k + 1) begin
    		local_history_table[k] = 0;
			local_pattern_table[k] = 0;
		end
		
		for (k = 0; k < 4096; k = k + 1) begin
    		global_pattern_table[k] = 0;
			choice_pattern_table[k] = 0;
		end
		
		path_history = 0;
		last_local_history = 0;
		last_path_history = 0;
		last_pc_D = 0;
		
	end
	
	assign local_history = local_history_table[pc_D];
	assign local_prediction = local_pattern_table[local_history];
	
	assign global_prediction = global_pattern_table[path_history];
	assign choice_prediction = choice_pattern_table[path_history];
	
	assign prediction = choice_prediction[1] ? global_prediction[1] : local_prediction[2];

    //UPDATING CODE

	reg [9:0] last_local_history;
	reg [11:0] last_path_history;

	always @(posedge clk) begin
	
        if( update_enable ) begin
			
			path_history = path_history << 1;
			path_history[0] = update_value;
			last_local_history <= local_history_table[pc_E];
			last_path_history <= path_history;
			
			local_history_table[pc_E] = { local_history_table[pc_E], update_value };
			
			if( update_value == 1'b0 ) begin
				if( local_pattern_table[last_local_history] != 3'd0 )
            		local_pattern_table[last_local_history] <= local_pattern_table[last_local_history] - 3'd1;
				if( global_pattern_table[last_path_history] != 2'd0 ) begin
            		global_pattern_table[last_path_history] <= global_pattern_table[last_path_history] - 2'd1;
            		choice_pattern_table[last_path_history] <= choice_pattern_table[last_path_history] - 2'd1;
				end
			end
			else begin
				if( local_pattern_table[last_local_history] != 3'b111 )
            		local_pattern_table[last_local_history] <= local_pattern_table[last_local_history] + 3'd1;
				if( global_pattern_table[last_path_history] != 2'b11 ) begin
            		global_pattern_table[last_path_history] <= global_pattern_table[last_path_history] + 2'd1;
            		choice_pattern_table[last_path_history] <= choice_pattern_table[last_path_history] + 2'd1;
				end
			end
		end
        else begin
        end
	end
endmodule
