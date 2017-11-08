package edu.rosehulman.bcw;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.time.LocalDateTime;

import org.apache.pig.EvalFunc;
import org.apache.pig.FuncSpec;
import org.apache.pig.PrimitiveEvalFunc;
import org.apache.pig.data.DataType;
import org.apache.pig.data.Tuple;
import org.apache.pig.impl.logicalLayer.FrontendException;
import org.apache.pig.impl.logicalLayer.schema.Schema;

public class GetHour extends PrimitiveEvalFunc<String,Integer>{

	@Override
	public Integer exec(String input) throws IOException {
		if(input == null) return 0;
		LocalDateTime LDT = LocalDateTime.parse(input);
		return LDT.getHour();
	}

}
