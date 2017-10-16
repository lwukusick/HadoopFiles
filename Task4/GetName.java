import java.io.IOException;

import org.apache.pig.PrimitiveEvalFunc;

public class GetName extends PrimitiveEvalFunc<String, String> {

	@Override
	public String exec(String in) throws IOException {
		String[] tokens = in.split("/");
		return tokens[0];
	}

}
