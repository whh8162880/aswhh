package asgl.files.models {
	public class ASMeshChunk {
		public static const MAIN:uint = 0xB0B0;
		public static const PROPERTY:uint = 0xB0B1;
		public static const MESH:uint = 0xB0B2;
		
		//MESH
		public static const MESH_VERTEX_LIST:uint = 0xB2B0;
		public static const MESH_UV_LIST:uint = 0xB2B1;
		public static const MESH_FACE_VERTEX_INDEX:uint = 0xB2B2;
		public static const MESH_FACE_UV_INDEX:uint = 0xB2B3;
		public static const MESH_MATERIAL_FACE_INDEX:uint = 0xB2B4;
		public static const MESH_BONE:uint = 0xB2B5;
	}
}