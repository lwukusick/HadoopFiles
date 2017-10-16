import java.io.IOException;

import org.apache.pig.PrimitiveEvalFunc;

public class GetHit extends PrimitiveEvalFunc<String, Integer> {

	@Override
	public Integer exec(String in) throws IOException {
		if (in.equals("Hit")){
			return 1;
		}
		return 0;
	}

}
