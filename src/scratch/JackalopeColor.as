package scratch {
	import blocks.BlockShape;
	import blocks.BlockArg;

	public class JackalopeColor extends BlockShape {
		public function JackalopeColor(color:int) {
			this.color = color;
			this.shape = RectShape;
			setShape(shape);
			filters = BlockArg.blockArgFilters();
			setWidthAndTopHeight(13, 13, true);
		}
		
		override public function toString():String {
			return String(color);
		}
		
		public function toJSON():Object {
			return {type: 'JackalopeColor', color: color};
		}
	}
}