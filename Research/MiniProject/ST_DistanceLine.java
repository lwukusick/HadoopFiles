import com.esri.hadoop.hive.GeometryUtils;
import com.esri.hadoop.hive.ST_GeometryAccessor;
import com.esri.core.geometry.Operator.Type;
import com.esri.core.geometry.OperatorFactoryLocal;
import com.esri.core.geometry.OperatorProximity2D;
import com.esri.core.geometry.Point;
import com.esri.core.geometry.Polyline;
import com.esri.core.geometry.Proximity2DResult;
import com.esri.core.geometry.ogc.OGCGeometry;

import org.apache.hadoop.io.BytesWritable; 
// DoubleWritable - must use hive-serde2; the other one produces struct {value:d.d}

public class ST_DistanceLine extends ST_GeometryAccessor {
	final BytesWritable resultDouble = new BytesWritable();
	OperatorProximity2D prox = (OperatorProximity2D)OperatorFactoryLocal.getInstance().getOperator(Type.Proximity2D);

    public BytesWritable evaluate(BytesWritable geometryref1, BytesWritable geometryref2) {
		if (geometryref1 == null || geometryref2 == null) {
			return null;
		}

		OGCGeometry ogcGeom1 = GeometryUtils.geometryFromEsriShape(geometryref1);
		OGCGeometry ogcGeom2 = GeometryUtils.geometryFromEsriShape(geometryref2);
		
		Point startPoint = (Point)ogcGeom2.getEsriGeometry();
		Proximity2DResult result = prox.getNearestCoordinate(ogcGeom1.getEsriGeometry(), startPoint, true);
		
		Polyline linestring = new Polyline();
		linestring.startPath(result.getCoordinate());
		linestring.lineTo(startPoint);

		return GeometryUtils.geometryToEsriShapeBytesWritable(OGCGeometry.createFromEsriGeometry(linestring, null));
	}
}
