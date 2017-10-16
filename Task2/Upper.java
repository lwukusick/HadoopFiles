import java.io.IOException;

import org.apache.pig.PrimitiveEvalFunc;

public class Upper extends PrimitiveEvalFunc<String, String> {

	@Override
	public String exec(String in) throws IOException {
		String out = in.toUpperCase();
		return out;
	}

}
