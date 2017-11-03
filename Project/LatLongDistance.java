package edu.rosehulman.bcw;

import org.apache.hadoop.hive.ql.exec.UDF;
import org.apache.hadoop.io.DoubleWritable;

public class LatLongDistance extends UDF{

	public DoubleWritable evaluate(DoubleWritable lat1, DoubleWritable lat2,
									DoubleWritable long1, DoubleWritable long2){
		
		// method taken from https://andrew.hedges.name/experiments/haversine/
		// derived from information from Bob Chamberlain (rgc@jpl.nasa.gov) of Caltech and NASA's Jet Propulsion Laboratory as described on the U.S. Census Bureau Web site.
		
		Double lat1double = lat1.get();
		Double lat2double = lat2.get();
		Double long1double = long1.get();
		Double long2double = long2.get();
		Double dlong = long2double-long1double;
		Double dlat = lat2double-lat1double;
		Double a = Math.pow(Math.sin(dlat/2),2) 
				+ Math.cos(lat1double) * Math.cos(lat2double) 
				* Math.pow(Math.sin(dlong/2),2);
		Double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
		Double dis = 3961 * c; // radius of the Earth in miles		
		return new DoubleWritable(dis);
	}
	
}
