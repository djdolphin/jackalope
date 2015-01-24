package uiwidgets {
	import flash.display.*;
	import flash.events.MouseEvent;

public class ProcedureEditorIcon extends Sprite {

	public var iconName:String;
	private var icon:Bitmap;

	public function ProcedureEditorIcon(iconName:String, mouseDown:Function) {
		this.iconName = iconName;
		icon = Specs.IconNamed(iconName);
		addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
		draw();
	}

	private function draw():void {
		while (numChildren > 0) removeChildAt(0);
		addChild(icon);
		icon.x = 0;
		icon.y = 0;
		// Make the entire button rectangle be mouse-sensitive:
		graphics.clear();
		graphics.beginFill(0xA0, 0); // invisible but mouse-sensitive; min size 10x10
		graphics.drawRect(0, 0, Math.max(10, icon.width), Math.max(10, icon.height));
		graphics.endFill();
	}

}}
