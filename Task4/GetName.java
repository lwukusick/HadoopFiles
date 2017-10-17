import java.io.IOException;

import org.apache.pig.PrimitiveEvalFunc;

public class GetName extends PrimitiveEvalFunc<String, String> {

	@Override
	public String exec(String in) throws IOException {
		String[] tokens = in.split("/");
		if (tokens[1].equals("blogs")){
			return tokens[2];
		}
		
		return null;
	}

}
