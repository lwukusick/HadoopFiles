package edu.rosehulman.wukusil;
import com.esri.hadoop.hive.GeometryUtils;
import com.esri.hadoop.hive.ST_GeometryAccessor;
import com.esri.core.geometry.Point;
import com.esri.core.geometry.ogc.OGCGeometry;

import org.apache.hadoop.io.BytesWritable;
import org.apache.hadoop.io.DoubleWritable; 
// DoubleWritable - must use hive-serde2; the other one produces struct {value:d.d}

public class ST_ManhattanDistance extends ST_GeometryAccessor {
	final BytesWritable resultDouble = new BytesWritable();

    public DoubleWritable evaluate(BytesWritable geometryref1, BytesWritable geometryref2) {
		if (geometryref1 == null || geometryref2 == null) {
			return null;
		}

		OGCGeometry ogcGeom1 = GeometryUtils.geometryFromEsriShape(geometryref1);
		OGCGeometry ogcGeom2 = GeometryUtils.geometryFromEsriShape(geometryref2);
		
		Point startPoint = (Point)ogcGeom1.getEsriGeometry();
		Point endPoint = (Point)ogcGeom2.getEsriGeometry();
		
		return new DoubleWritable(Math.abs(startPoint.getX() - endPoint.getX()) + Math.abs(startPoint.getY() - endPoint.getY()));
	}
}
