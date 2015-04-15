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
	import blocks.*;
	import interpreter.*;
	import scratch.ScratchSprite;
	import translation.Translator;

public class Primitives {

	private const MaxCloneCount:int = 300;

	protected var app:Scratch;
	protected var interp:Interpreter;
	private var counter:int;

	public function Primitives(app:Scratch, interpreter:Interpreter) {
		this.app = app;
		this.interp = interpreter;
	}

	public function addPrimsTo(primTable:Dictionary):void {
		// operators
		primTable["+"]				= function(b:*):* { return interp.numarg(b, 0) + interp.numarg(b, 1) };
		primTable["-"]				= function(b:*):* { return interp.numarg(b, 0) - interp.numarg(b, 1) };
		primTable["*"]				= function(b:*):* { return interp.numarg(b, 0) * interp.numarg(b, 1) };
		primTable["/"]				= function(b:*):* { return interp.numarg(b, 0) / interp.numarg(b, 1) };
		primTable["^"]				= function(b:*):* { return Math.pow(interp.numarg(b, 0), interp.numarg(b, 1)) };
		primTable["randomFrom:to:"]	= primRandom;
		primTable["<"]				= function(b:*):* { return compare(interp.arg(b, 0), interp.arg(b, 1)) < 0 };
		primTable["="]				= function(b:*):* { return compare(interp.arg(b, 0), interp.arg(b, 1)) == 0 };
		primTable[">"]				= function(b:*):* { return compare(interp.arg(b, 0), interp.arg(b, 1)) > 0 };
		primTable["&"]				= function(b:*):* { return interp.arg(b, 0) && interp.arg(b, 1) };
		primTable["|"]				= function(b:*):* { return interp.arg(b, 0) || interp.arg(b, 1) };
		primTable["not"]			= function(b:*):* { return !interp.arg(b, 0) };
		primTable["true"]			= function(b:*):* { return true };
		primTable["false"]			= function(b:*):* { return false };
		primTable["reportIfElse"]	= function(b:*):* { return interp.arg(b, 0) ? interp.arg(b, 1) : interp.arg(b, 2) }
		primTable["abs"]			= function(b:*):* { return Math.abs(interp.numarg(b, 0)) };
		primTable["sqrt"]			= function(b:*):* { return Math.sqrt(interp.numarg(b, 0)) };

		primTable["concatenate:with:"]	= function(b:*):* { return "" + interp.arg(b, 0) + interp.arg(b, 1); };
		primTable["letter:of:"]			= primLetterOf;
		primTable["lettersOf"]			= primLettersOf;
		primTable["stringLength:"]		= function(b:*):* { return String(interp.arg(b, 0)).length };
		primTable["splitString:"]		= function(b:*):* { return String(interp.arg(b, 0)).split(interp.arg(b, 1)) };
		primTable["stringContains"]		= primStringContains
		primTable["stringIndexOf"]		= primStringIndexOf;
		primTable["stringReplace"]		= primStringReplace;
		primTable["reportRegex"]		= primReportRegex;
		primTable["reportRegexWithFlags"] = primReportRegexWithFlags;
		primTable["testRegex"]			= primTestRegex;

		primTable["reportUnicode"]		= function(b:*):* { return String(interp.arg(b, 0)).charCodeAt(0) };
		primTable["reportUnicodeAsLetter"] = function(b:*):* { return String.fromCharCode(interp.numarg(b, 0)) };

		primTable["%"]					= primModulo;
		primTable["rounded"]			= function(b:*):* { return Math.round(interp.numarg(b, 0)) };
		primTable["computeFunction:of:"] = primMathFunction;

		// clone
		primTable["createCloneOf"]		= primCreateCloneOf;
		primTable["deleteClonesOf"]		= primDeleteClonesOf;
		primTable["deleteClone"]		= primDeleteClone;
		primTable["whenCloned"]			= interp.primNoop;
		primTable["isClone"]			= primIsClone;
		primTable["cloneCount"]			= primCloneCount;
		primTable["totalCloneCount"]	= primTotalCloneCount;

		// testing (for development)
		primTable["NOOP"]				= interp.primNoop;
		primTable["COUNT"]				= function(b:*):* { return counter };
		primTable["INCR_COUNT"]			= function(b:*):* { counter++ };
		primTable["CLR_COUNT"]			= function(b:*):* { counter = 0 };

		new LooksPrims(app, interp).addPrimsTo(primTable);
		new MotionAndPenPrims(app, interp).addPrimsTo(primTable);
		new SoundPrims(app, interp).addPrimsTo(primTable);
		new VideoMotionPrims(app, interp).addPrimsTo(primTable);
		addOtherPrims(primTable);
	}

	protected function addOtherPrims(primTable:Dictionary):void {
		new SensingPrims(app, interp).addPrimsTo(primTable);
		new ListPrims(app, interp).addPrimsTo(primTable);
		new ColorPrims(app, interp).addPrimsTo(primTable);
	}

	private function primRandom(b:Block):Number {
		var n1:Number = interp.numarg(b, 0);
		var n2:Number = interp.numarg(b, 1);
		var low:Number = (n1 <= n2) ? n1 : n2;
		var hi:Number = (n1 <= n2) ? n2 : n1;
		if (low == hi) return low;

		// if both low and hi are ints, truncate the result to an int
		if (b.args[0].numberType == BlockArg.NT_INT && b.args[1].numberType == BlockArg.NT_INT)
			return low + int(Math.random() * ((hi + 1) - low));

		return (Math.random() * (hi - low)) + low;
	}

	private function primLetterOf(b:Block):String {
		var s:String = interp.arg(b, 1);
		var i:int = interp.numarg(b, 0) - 1;
		if ((i < 0) || (i >= s.length)) return "";
		return s.charAt(i);
	}

	private function primLettersOf(b:Block):String {
		var s:String = interp.arg(b, 2);
		var start:int = interp.numarg(b, 0) - 1;
		var end:int = interp.numarg(b, 1);
		if ((start < 0) || (start >= s.length) || (end < start) || (end > s.length)) return "";
		return s.substring(start, end);
	}

	private function primStringContains(b:Block):Boolean {
		var string:String = interp.arg(b, 0);
		var search:String = interp.arg(b, 1);
		return string.indexOf(search) > -1;
	}

	private function primStringIndexOf(b:Block):Number {
		var string:String = interp.arg(b, 1);
		var search:String = interp.arg(b, 0);
		var start:int = interp.numarg(b, 2) - 1;
		return string.indexOf(search, start) + 1;
	}

	private function escapeRegexChars(s:String):String {
		return s.replace(/([.?*+^$[\]\\(){}|-])/g, '\\$1');
	}

	private function primStringReplace(b:Block):String {
		var string:String = interp.arg(b, 1);
		var replace:String = interp.arg(b, 2);
		var search:* = interp.arg(b, 0);
		if (!(search is RegExp)) {
			search = new RegExp(escapeRegexChars(search), 'g');
			replace = replace.replace(/\$/g, '$$$$');
		}
		return string.replace(search, replace);
	}

	private function primReportRegex(b:Block):RegExp {
		var s:String = interp.arg(b, 0);
		var flags:String = '';
		if (interp.arg(b, 1)) flags += 'g';
		if (!interp.arg(b, 2)) flags += 'i';
		return new RegExp(s, flags);
	}

	private function primReportRegexWithFlags(b:Block):RegExp {
		var s:String = interp.arg(b, 0);
		var flags:String = interp.arg(b, 1);
		return new RegExp(s, flags);
	}	

	private function primTestRegex(b:Block):Boolean {
		var regex:* = interp.arg(b, 1);
		if (!(regex is RegExp)) regex = new RegExp(regex);
		var s:String = interp.arg(b, 0);
		return RegExp(regex).test(s);
	}

	private function primModulo(b:Block):Number {
		var n:Number = interp.numarg(b, 0);
		var modulus:Number = interp.numarg(b, 1);
		var result:Number = n % modulus;
		if (result / modulus < 0) result += modulus;
		return result;
	}

	private function primMathFunction(b:Block):Number {
		var op:* = interp.arg(b, 0);
		var n:Number = interp.numarg(b, 1);
		switch(op) {
		case "abs": return Math.abs(n);
		case "floor": return Math.floor(n);
		case "ceiling": return Math.ceil(n);
		case "int": return n - (n % 1); // used during alpha, but removed from menu
		case "sqrt": return Math.sqrt(n);
		case "sin": return Math.sin((Math.PI * n) / 180);
		case "cos": return Math.cos((Math.PI * n) / 180);
		case "tan": return Math.tan((Math.PI * n) / 180);
		case "asin": return (Math.asin(n) * 180) / Math.PI;
		case "acos": return (Math.acos(n) * 180) / Math.PI;
		case "atan": return (Math.atan(n) * 180) / Math.PI;
		case "ln": return Math.log(n);
		case "log": return Math.log(n) / Math.LN10;
		case "e ^": return Math.exp(n);
		case "10 ^": return Math.exp(n * Math.LN10);
		}
		return 0;
	}

	private static var lcDict:Dictionary = new Dictionary();
	public static function compare(a1:*, a2:*):int {
		// This is static so it can be used by the list "contains" primitive.
		var n1:Number = Interpreter.asNumber(a1);
		var n2:Number = Interpreter.asNumber(a2);
		if (isNaN(n1) || isNaN(n2)) {
			// at least one argument can't be converted to a number: compare as strings
			var s1:String = lcDict[a1];
			if(!s1) s1 = lcDict[a1] = String(a1).toLowerCase();
			var s2:String = lcDict[a2];
			if(!s2) s2 = lcDict[a2] = String(a2).toLowerCase();
			return s1.localeCompare(s2);
		} else {
			// compare as numbers
			if (n1 < n2) return -1;
			if (n1 == n2) return 0;
			if (n1 > n2) return 1;
		}
		return 1;
	}

	private function primCreateCloneOf(b:Block):void {
		var objName:String = interp.arg(b, 0);
		var proto:ScratchSprite = app.stagePane.spriteNamed(objName);
		if ('_myself_' == objName) proto = interp.activeThread.target;
		if (!proto) return;
		if (app.runtime.cloneCount > MaxCloneCount) return;
		var clone:ScratchSprite = new ScratchSprite();
		if (proto.parent == app.stagePane)
			app.stagePane.addChildAt(clone, app.stagePane.getChildIndex(proto));
		else
			app.stagePane.addChild(clone);

		clone.initFrom(proto, true);
		clone.objName = proto.objName;
		clone.isClone = true;
		for each (var stack:Block in clone.scripts) {
			if (stack.op == "whenCloned") {
				interp.startThreadForClone(stack, clone);
			}
		}
		app.runtime.cloneCount++;
	}

	private function primDeleteClone(b:Block):void {
		var clone:ScratchSprite = interp.targetSprite();
		if ((clone == null) || (!clone.isClone) || (clone.parent == null)) return;
		if (clone.bubble && clone.bubble.parent) clone.bubble.parent.removeChild(clone.bubble);
		clone.parent.removeChild(clone);
		app.interp.stopThreadsFor(clone);
		app.runtime.cloneCount--;
	}

	private function primDeleteClonesOf(b:Block):void {
		var objName:String = interp.arg(b, 0);
		if ('_all sprites_' == objName) {
			app.stagePane.deleteClones();
		} else {
			var sprite:ScratchSprite = app.stagePane.spriteNamed(objName);
			if ('_myself_' == objName) sprite = interp.activeThread.target;
			if (!sprite) return;
			app.stagePane.deleteClonesOf(sprite);
		}
	}

	private function primIsClone(b:Block):Boolean {
		var clone:ScratchSprite = interp.targetSprite();
		if ((clone == null) || (!clone.isClone)) return false;
		return true;
	}

	private function primCloneCount(b:Block):Number {
		var s:ScratchSprite = interp.targetSprite();
		return s != null ? s.cloneCount() : 0;
	}	

	private function primTotalCloneCount(b:Block):Number {
		return (app.runtime.cloneCount as Number);
	}

}}
