package mammoth.components;

import edge.IComponent;
import mammoth.render.Material;
import mammoth.render.Mesh;

class MeshRenderer implements IComponent {
	public var material:Material;
	public var mesh:Mesh;

	public function new() {}

	public function setMesh(mesh:Mesh):MeshRenderer {
		this.mesh = mesh;
		return this;
	}

	public function setMaterial(material:Material):MeshRenderer {
		this.material = material;
		return this;
	}
}