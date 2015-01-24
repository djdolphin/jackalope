/*
 * Scratch Project Editor and Player
 * Copyright (C) 2014 Massachusetts Institute of Technology
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

// Primitives.as
// John Maloney, April 2010
//
// Miscellaneous primitives. Registers other primitive modules.
// Note: A few control structure primitives are implemented directly in Interpreter.as.

package primitives {
	import flash.utils.Dictionary;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import blocks.*;
	import interpreter.*;
	import scratch.JackalopeColor;
	import util.Color;

public class ColorPrims {

	private var app:Scratch;
	private var interp:Interpreter;

	public function ColorPrims(app:Scratch, interpreter:Interpreter) {
		this.app = app;
		this.interp = interpreter;
	}

	public function addPrimsTo(primTable:Dictionary):void {
		primTable["colorFromRGB"]		= primColorFromRGB;
		primTable["redFromColor"]		= primRedFromColor;
		primTable["blueFromColor"]		= primBlueFromColor;
		primTable["greenFromColor"]		= primGreenFromColor;
		primTable["colorFromHSV"]		= primColorFromHSV;
		primTable["hueFromColor"]		= primHueFromColor;
		primTable["saturationFromColor"] = primSaturationFromColor;
		primTable["valueFromColor"]		= primValueFromColor;
		primTable["mixColors"]			= primMixColors;
		primTable["mixColorsWithRatio"]	= primMixColorsWithRatio;
		primTable["scaleColorBrightness"] = primScaleColorBrightness;
		primTable["colorAtPoint"]		= primColorAtPoint;
		primTable["randomColor"]		= primRandomColor;
	}

	private function primColorFromRGB(b:Block):JackalopeColor {
		return new JackalopeColor(Color.combineRGB(interp.numarg(b, 0), interp.numarg(b, 1), interp.numarg(b, 2)));
	}

	private function primRedFromColor(b:Block):Number {
		return Color.separateRGB(interp.numarg(b, 0))[0];
	}

	private function primGreenFromColor(b:Block):Number {
		return Color.separateRGB(interp.numarg(b, 0))[1];
	}

	private function primBlueFromColor(b:Block):Number {
		return Color.separateRGB(interp.numarg(b, 0))[2];
	}

	private function primColorFromHSV(b:Block):JackalopeColor {
		return new JackalopeColor(Color.fromHSV(interp.numarg(b, 0), interp.numarg(b, 1) / 100, interp.numarg(b, 2) / 100));
	}

	private function primHueFromColor(b:Block):Number {
		return Math.round(Color.rgb2hsv(interp.numarg(b, 0))[0]);
	}

	private function primSaturationFromColor(b:Block):Number {
		return Math.round(Color.rgb2hsv(interp.numarg(b, 0))[1] * 100);
	}

	private function primValueFromColor(b:Block):Number {
		return Math.round(Color.rgb2hsv(interp.numarg(b, 0))[2] * 100);
	}
	
	private function primMixColors(b:Block):JackalopeColor {
		return new JackalopeColor(Color.mixRGB(interp.numarg(b, 0), interp.numarg(b, 1), 0.5));
	}

	private function primMixColorsWithRatio(b:Block):JackalopeColor {
		var A:Number = interp.numarg(b, 1);
		var B:Number = interp.numarg(b, 2);
		var fraction:Number = B / (A + B);
		return new JackalopeColor(Color.mixRGB(interp.numarg(b, 0), interp.numarg(b, 3), fraction));
	}

	private function primScaleColorBrightness(b:Block):JackalopeColor {
		var scale:Number = 1 + interp.numarg(b, 1) / 100;
		return new JackalopeColor(Color.scaleBrightness(interp.numarg(b, 0), scale));
	}

	private function primColorAtPoint(b:Block):JackalopeColor {
		var x:int = 240 + interp.numarg(b, 0);
		var y:int = 180 - interp.numarg(b, 1);
		var onePixel:BitmapData = new BitmapData(1, 1);
		var m:Matrix = new Matrix();
		m.translate(-x, -y);
		onePixel.fillRect(onePixel.rect, 0xFFFFFF);
		onePixel.draw(app.stagePane, m);
		var color:uint = onePixel.getPixel32(0, 0);
		color = color % 0x1000000; // get rid of alpha channel
		return new JackalopeColor(color);
	}

	private function primRandomColor(b:Block):JackalopeColor {
		return new JackalopeColor(Color.random());
	}

}}