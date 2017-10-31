package edu.rosehulman.wukusil;

import java.io.IOException;

import org.apache.pig.EvalFunc;
import org.apache.pig.data.Tuple;

public class CatName extends EvalFunc<String> {

	@Override
	public String exec(Tuple arg0) throws IOException {
		String outstring = (String) arg0.get(0) + " " + (String) arg0.get(1);
		return outstring;
	}

}
