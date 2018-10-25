package def;

	function int numofbits (input int temp);
		if (temp <= 1) return(1);
		numofbits = 0;
		while (temp > 0) begin
			temp = temp >> 1;
			numofbits++;
			end
		return(numofbits);
	endfunction

endpackage