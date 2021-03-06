package edu.rosehulman.bcw;

import java.io.IOException;
import java.time.DayOfWeek;
import java.time.LocalDateTime;

import org.apache.pig.FilterFunc;
import org.apache.pig.data.Tuple;


public class SchoolTime extends FilterFunc{

	@Override
	public Boolean exec(Tuple input) throws IOException {
		// TODO Auto-generated method stub
		if(input == null) return false;
		LocalDateTime LDT = LocalDateTime.parse(input.get(0).toString());
		DayOfWeek dayEnum = LDT.getDayOfWeek();
		int month = LDT.getMonthValue();
		int hour = LDT.getHour();
		if(dayEnum == DayOfWeek.SUNDAY || dayEnum == DayOfWeek.SATURDAY){
			return false;
		}else if(month == 7 || month == 8){
			return false;
		}else if(hour >= 6 && hour <= 18){
			return true; // only 6am to 6pm
		}
		else return false;
	}

}
