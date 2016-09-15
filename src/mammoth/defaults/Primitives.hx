package mammoth.defaults;

import mammoth.render.Mesh;

class Primitives {
	public static function screenQuad():Mesh {
		var m:Mesh = new Mesh("screen", Mammoth.graphics, ["position"]);

		m.setVertexData([
			-1.0, -1.0,
			 1.0, -1.0,
			 1.0,  1.0,
			-1.0,  1.0,
			]);
		m.setIndexData([
			0, 1, 2,
			0, 2, 3]);

		return m;
	}
}