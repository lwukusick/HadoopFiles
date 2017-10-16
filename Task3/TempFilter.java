import java.io.IOException;

import org.apache.pig.FilterFunc;
import org.apache.pig.backend.executionengine.ExecException;
import org.apache.pig.data.Tuple;

public class TempFilter extends FilterFunc {

	@Override
	public Boolean exec(Tuple in) throws IOException {
		if (in == null || in.size() == 0) {
			return false;
		}
		
		try{
			Object object = in.get(0);
			if (object == null){
				return false;
			}
			
			int i = (Integer)object;
			return i == 0 || i == 1;
		} catch (ExecException e) {
			throw new IOException(e);
		}
	}

}
