package edu.rosehulman.wukusil;
import java.io.IOException;

import org.apache.pig.PrimitiveEvalFunc;

public class ToLetterGrade extends PrimitiveEvalFunc<Integer, String> {

	@Override
	public String exec(Integer in) throws IOException {
		 if (in <= 60){
			 return "F";
		 }
		 if (in <= 70){
			 return "D";
		 } 
		 if (in <= 80){
			 return "C";
		 } 
		 if (in < 90){
			 return "B";
		 } 
		 if (in >= 90){
			 return "A";
		 }
		
		return "E";
	}

}
