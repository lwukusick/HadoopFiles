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

public class SchoolYear extends PrimitiveEvalFunc<String,Integer>{

	@Override
	public Integer exec(String input) throws IOException {
		if(input == null) return 0;
		LocalDateTime LDT = LocalDateTime.parse(input);
		int month = LDT.getMonthValue();
		int year = LDT.getYear();
		if(month > 8){
			return Integer.parseInt(Integer.toString(year).substring(2)+Integer.toString(year+1).substring(2));
		}else if(month < 7){
			return Integer.parseInt(Integer.toString(year-1).substring(2)+Integer.toString(year).substring(2));
		}else return 0;
	}
}
