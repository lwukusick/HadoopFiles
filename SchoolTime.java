package edu.rosehulman.bcw;

import org.apache.hadoop.hive.ql.exec.UDF;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.BooleanWritable;

import java.time.*;

public class SchoolTime extends UDF{
	
	public BooleanWritable evaluate(Text s){
		if(s == null) return null;
		LocalDateTime LDT = LocalDateTime.parse(s.toString());
		DayOfWeek dayEnum = LDT.getDayOfWeek();
		int month = LDT.getMonthValue();
		int hour = LDT.getHour();
		if(dayEnum == DayOfWeek.SUNDAY || dayEnum == DayOfWeek.SATURDAY){
			return new BooleanWritable(false);
		}else if(month == 7 || month == 8){
			return new BooleanWritable(false);
		}else if(hour >= 6 && hour <= 18){
			return new BooleanWritable(true); // only 6am to 6pm
		}
		else return new BooleanWritable(false);
	}
}
