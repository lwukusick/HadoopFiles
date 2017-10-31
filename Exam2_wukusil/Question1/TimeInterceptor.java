package edu.rosehulman.wukusil;

import java.net.InetAddress;
import java.nio.charset.Charset;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.flume.Context;
import org.apache.flume.Event;
import org.apache.flume.event.EventBuilder;
import org.apache.flume.interceptor.Interceptor;

public class TimeInterceptor implements Interceptor {

	public void close() {
		// NOP

	}

	public void initialize() {
		// NOP

	}

	public Event intercept(Event event) {
		try{
			String body = new String(event.getBody(), "UTF-8");

			StringBuilder builder = new StringBuilder();
			builder.append("Parse time: " + new SimpleDateFormat("yyyy-MM-dd-HH:mm:ss").format(new Date()) + ",");
			builder.append(body);
			Event e = EventBuilder.withBody(builder.toString(), Charset.forName("UTF-8"));
			return e;
		} catch(Exception exp){ return null;}
	}

	public List<Event> intercept(List<Event> eventList) {
		List<Event> eventListOut = new ArrayList<Event>();
		for(Event event : eventList){
			Event outEvent = intercept(event);
			if(outEvent != null){
				eventListOut.add(outEvent);
			}
		}
		return eventListOut;
	}
	
	public static class Builder implements Interceptor.Builder {

	    
	    
	    public Interceptor build() {
	      return new TimeInterceptor();
	    }

	 
		
		public void configure(Context arg0) {
			// NOP
			
		}
	  }


}
