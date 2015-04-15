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

// Specs.as
// John Maloney, April 2010
//
// This file defines the command blocks and categories.
// To add a new command:
//		a. add a specification for the new command to the commands array
//		b. add a primitive for the new command to the interpreter

package {
	import flash.display.Bitmap;
	import assets.Resources;

public class Specs {

	public static const GET_VAR:String = "readVariable";
	public static const SET_VAR:String = "setVar:to:";
	public static const CHANGE_VAR:String = "changeVar:by:";
	public static const GET_LIST:String = "contentsOfList:";
	public static const CALL:String = "call";
	public static const PROCEDURE_DEF:String = "procDef";
	public static const GET_PARAM:String = "getParam";

	public static const motionCategory:int = 1;
	public static const looksCategory:int = 2;
	public static const eventsCategory:int = 5;
	public static const controlCategory:int = 6;
	public static const operatorsCategory:int = 8;
	public static const dataCategory:int = 9;
	public static const myBlocksCategory:int = 10;
	public static const listCategory:int = 12;
	public static const extensionsCategory:int = 20;

	public static var variableColor:int = 0xEE7D16; // Scratch 1.4: 0xF3761D
	public static var listColor:int = 0xCC5B22; // Scratch 1.4: 0xD94D11
	public static var procedureColor:int = 0x632D99; // 0x531E99;
	public static var parameterColor:int = 0x5947B1;
	public static var extensionsColor:int = 0x4B4A60; // 0x72228C; // 0x672D79;

	private static const undefinedColor:int = 0xD42828;

	public static const categories:Array = [
	 // id   category name	color
		[0,  "undefined",	0xD42828],
		[1,  "Motion",		0x4a6cd4],
		[2,  "Looks",		0x8a55d7],
		[3,  "Sound",		0xbb42c3],
		[4,  "Pen",			0x0e9a6c], // Scratch 1.4: 0x009870
		[5,  "Events",		0xc88330],
		[6,  "Control",		0xe1a91a],
		[7,  "Sensing",		0x2ca5e2],
		[8,  "Operators",	0x5cb712],
		[9,  "Data",		variableColor],
		[10, "More Blocks",	procedureColor],
		[11, "Parameter",	parameterColor],
		[12, "List",		listColor],
		[13, "Colors",		0x3f3f3f],
		[14, "Strings",		0xdb8ea5],
		[20, "Extension",	extensionsColor],
	];

	public static function blockColor(categoryID:int):int {
		if (categoryID > 100) categoryID -= 100;
		for each (var entry:Array in categories) {
			if (entry[0] == categoryID) return entry[2];
		}
		return undefinedColor;
	}

	public static function entryForCategory(categoryName:String):Array {
		for each (var entry:Array in categories) {
			if (entry[1] == categoryName) return entry;
		}
		return [1, categoryName, 0xFF0000]; // should not happen
	}

	public static function nameForCategory(categoryID:int):String {
		if (categoryID > 100) categoryID -= 100;
		for each (var entry:Array in categories) {
			if (entry[0] == categoryID) return entry[1];
		}
		return "Unknown";
	}

	public static function IconNamed(name:String):* {
		// Block icons are 2x resolution to look better when scaled.
		var icon:Bitmap;
		if (name == "greenFlag") icon = Resources.createBmp('flagIcon');
		if (name == "stop") icon = Resources.createBmp('stopIcon');
		if (name == "turnLeft") icon = Resources.createBmp('turnLeftIcon');
		if (name == "turnRight") icon = Resources.createBmp('turnRightIcon');
		if (icon != null) icon.scaleX = icon.scaleY = 0.5;
		return icon;
	}

	public static var commands:Array = [
		// block specification					type, cat, opcode			default args (optional)
		// motion
		["move %n steps",						" ", 1, "forward:",					10],
		["turn @turnRight %n degrees",			" ", 1, "turnRight:",				15],
		["turn @turnLeft %n degrees",			" ", 1, "turnLeft:",				15],
		["-"],
		["point in direction %d.direction",		" ", 1, "heading:",					90],
		["point towards %m.spriteOrMouse",		" ", 1, "pointTowards:",			""],
		["point towards x:%n y:%n",				" ", 1, "pointTowardsPoint",		0, 0],
		["direction",							"r", 1, "heading"],
		["-"],
		["go to x:%n y:%n",						" ", 1, "gotoX:y:"],
		["go to %m.spriteOrMouse",				" ", 1, "gotoSpriteOrMouse:",		"mouse-pointer"],
		["glide %n secs to x:%n y:%n",			" ", 1, "glideSecs:toX:y:elapsed:from:"],
		["-"],
		["change x by %n",						" ", 1, "changeXposBy:",			10],
		["set x to %n",							" ", 1, "xpos:",					0],
		["x position",							"r", 1, "xpos"],
		["change y by %n",						" ", 1, "changeYposBy:",			10],
		["set y to %n",							" ", 1, "ypos:",					0],
		["y position",							"r", 1, "ypos"],
		["-"],
		["if on edge, bounce",					" ", 1, "bounceOffEdge"],
		["-"],
		["set rotation style %m.rotationStyle",	" ", 1, "setRotationStyle", 		"left-right"],
		["rotation style",						"r", 1, "rotationStyle"],
		["-"],
		["set draggability to %m.draggability",	" ", 1, "setDraggability",			"draggable"],
		["draggable?",							"b", 1, "isDraggable"],

		// looks
		["%m.bubbleStyle %s", " ", 2, "showBubble", "say", "Hello"],
		["%m.bubbleStyle %s for %n secs", " ", 2, "showBubbleAndWait", "say", "Hello", 2],
		['-'],
		["show",								" ", 2, "show"],
		["hide",								" ", 2, "hide"],
		["visible?",							"b", 2, "isVisible"],
		["-"],
		["switch costume to %m.costume",		" ", 2, "lookLike:",				"costume1"],
		["next costume",						" ", 2, "nextCostume"],
		["costume name",						"r", 2, "costumeName"],
		["costume #",							"r", 2, "costumeIndex"],
		["-"],
		["switch backdrop to %m.backdrop",		" ", 2, "startScene", 				"backdrop1"],
		["backdrop name",						"r", 2, "sceneName"],
		["-"],
		["change %m.effect effect by %n",		" ", 2, "changeGraphicEffect:by:",	"color", 25],
		["set %m.effect effect to %n",			" ", 2, "setGraphicEffect:to:",		"color", 0],
		["clear graphic effects",				" ", 2, "filterReset"],
		["%m.effect effect",					"r", 2, "graphicEffect", "color"],
		["-"],
		["change size by %n",					" ", 2, "changeSizeBy:",	 		10],
		["set size to %n%",						" ", 2, "setSizeTo:", 				100],
		["size",								"r", 2, "scale"],
		["-"],
		["change %m.stretchDirection stretch by %n", " ", 2, "changeStretchBy",		"horizontal", 10],
		["set %m.stretchDirection stretch to %n%", " ", 2, "setStretchTo", 			"horizontal", 100],
		["%m.stretchDirection stretch",			"r", 2, "stretch", "horizontal"],
		["-"],
		["go to front",							" ", 2, "comeToFront"],
		["go back %n layers",					" ", 2, "goBackByLayers:", 			1],

		// stage looks
		["switch backdrop to %m.backdrop",			" ", 102, "startScene", 			"backdrop1"],
		["switch backdrop to %m.backdrop and wait", " ", 102, "startSceneAndWait",		"backdrop1"],
		["next backdrop",							" ", 102, "nextScene"],
		["backdrop name",						"r", 102, "sceneName"],
		["backdrop #",							"r", 102, "backgroundIndex"],
		["-"],
		["change %m.effect effect by %n",		" ", 102, "changeGraphicEffect:by:",	"color", 25],
		["set %m.effect effect to %n",			" ", 102, "setGraphicEffect:to:",		"color", 0],
		["clear graphic effects",				" ", 102, "filterReset"],
		["%m.effect effect",					"r", 102, "graphicEffect", "color"],

		// sound
		["play sound %m.sound",					" ", 3, "playSound:",						"pop"],
		["play sound %m.sound until done",		" ", 3, "doPlaySoundAndWait",				"pop"],
		["stop all sounds",						" ", 3, "stopAllSounds"],
		["-"],
		["play drum %d.drum for %n beats",		" ", 3, "playDrum",							1, 0.25],
		["rest for %n beats",					" ", 3, "rest:elapsed:from:",				0.25],
		["-"],
		["play note %d.note for %n beats",		" ", 3, "noteOn:duration:elapsed:from:",	60, 0.5],
		["set instrument to %d.instrument",		" ", 3, "instrument:",						1],

		["-"],
		["change volume by %n",					" ", 3, "changeVolumeBy:",					-10],
		["set volume to %n%",					" ", 3, "setVolumeTo:", 					100],
		["volume",								"r", 3, "volume"],
		["-"],
		["change tempo by %n",					" ", 3, "changeTempoBy:",					20],
		["set tempo to %n bpm",					" ", 3, "setTempoTo:",						60],
		["tempo",								"r", 3,  "tempo"],

		// pen
		["clear",								" ", 4, "clearPenTrails"],
		["-"],
		["stamp",								" ", 4, "stampCostume"],
		["-"],
		["pen down",							" ", 4, "putPenDown"],
		["pen up",								" ", 4, "putPenUp"],
		["pen is down?",						"b", 4, "penIsDown"],
		["-"],
		["set pen color to %c",					" ", 4, "penColor:"],
		["pen color",							"C", 4, "penColor"],
		["-"],
		["change pen hue by %n",				" ", 4, "changePenHueBy:"],
		["set pen hue to %n",					" ", 4, "setPenHueTo:", 		0],
		["pen hue",								"r", 4, "penHue"],
		["-"],
		["change pen shade by %n",				" ", 4, "changePenShadeBy:"],
		["set pen shade to %n",					" ", 4, "setPenShadeTo:",		50],
		["pen shade",							"r", 4, "penShade"],
		["-"],
		["change pen size by %n",				" ", 4, "changePenSizeBy:",		1],
		["set pen size to %n",					" ", 4, "penSize:", 			1],
		["pen size",							"r", 4, "penSize"],
		["-"],
		["change pen transparency by %n",		" ", 4, "changePenTransparency",	10],
		["set pen transparency to %n%",			" ", 4, "setPenTransparency", 		50],
		["pen transparency",					"r", 4, "penTransparency"],
		["--"],
		["draw rectangle at x:%n y:%n width %n height %n", " ", 4, "drawRectangle", 0, 0, 100, 100],
		["draw circle at x:%n y:%n radius %n",	" ", 4, "drawCircle", 0, 0, 50],
		["draw ellipse at x:%n y:%n width %n height %n", " ", 4, "drawEllipse", 0, 0, 100, 50],
		["draw rounded rectangle at x:%n y:%n width %n height %n border radius %n", " ", 4, "drawRoundedRectangle", 0, 0, 100, 100, 10],
		["draw text %s at x: %n y: %n font %m.font", " ", 4, "drawText", "Hello!", 0, 0, "Helvetica"],

		// stage pen
		["clear",								" ", 104, "clearPenTrails"],

		// triggers
		["when @greenFlag clicked",				"h", 5, "whenGreenFlag"],
		["when %m.key key pressed",				"h", 5, "whenKeyPressed", 		"space"],
		["when this sprite clicked",			"h", 5, "whenClicked"],
		["when backdrop switches to %m.backdrop", "h", 5, "whenSceneStarts", 	"backdrop1"],
		["--"],
		["when %m.triggerSensor > %n",			"h", 5, "whenSensorGreaterThan", "loudness", 10],
		["--"],
		["when I receive %m.broadcast",			"h", 5, "whenIReceive",			""],
		["broadcast %m.broadcast",				" ", 5, "broadcast:",			""],
		["broadcast %m.broadcast and wait",		" ", 5, "doBroadcastAndWait",	""],

		// control - sprite
		["wait %n secs",						" ", 6, "wait:elapsed:from:",	1],
		["-"],
		["repeat %n",							"c", 6, "doRepeat", 10],
		["forever",								"cf",6, "doForever"],
		["-"],
		["if %b then",							"c", 6, "doIf"],
		["if %b then",							"e", 6, "doIfElse"],
		["-"],
		["wait until %b",						" ", 6, "doWaitUntil"],
		["repeat until %b",						"c", 6, "doUntil"],
		["while %b",							"c", 6, "doWhile"],
		["for each %m.var in %n",				"c", 6, "doForLoop", "a variable", 10],
		["for each %m.var in %i",				"c", 6, "doForEachLoop"],
		["-"],
		["stop %m.stop",						"f", 6, "stopScripts", "all"],
		["-"],
		["when I start as a clone",				"h", 6, "whenCloned"],
		["create clone of %m.spriteOnly",		" ", 6, "createCloneOf"],
		["delete clones of %m.deleteClone",		" ", 6, "deleteClonesOf"],
		["delete this clone",					"f", 6, "deleteClone"],
		["-"],
		["I am a clone?",						"b", 6, "isClone"],
		["my clone count",						"r", 6, "cloneCount"],
		["total clone count",					"r", 6, "totalCloneCount"],

		// control - stage
		["wait %n secs",						" ", 106, "wait:elapsed:from:",	1],
		["-"],
		["repeat %n",							"c", 106, "doRepeat", 10],
		["forever",								"cf",106, "doForever"],
		["-"],
		["if %b then",							"c", 106, "doIf"],
		["if %b then",							"e", 106, "doIfElse"],
		["-"],
		["wait until %b",						" ", 106, "doWaitUntil"],
		["repeat until %b",						"c", 106, "doUntil"],
		["while %b",							"c", 106, "doWhile"],
		["for each %m.var in %n",				"c", 106, "doForLoop", "a variable", 10],
		["for each %m.var in %i",				"c", 106, "doForEachLoop"],
		["-"],
		["stop %m.stop",						"f", 106, "stopScripts", "all"],
		["-"],
		["create clone of %m.spriteOnly",		" ", 106, "createCloneOf"],
		["delete clones of %m.deleteClone",		" ", 106, "deleteClonesOf"],
		["total clone count",					"r", 106, "totalCloneCount"],

		// sensing
		["my name",								"r", 7, "name"],
		["set my name to %s",					" ", 7, "setName"],
		["-"],
		["touching %m.touching?",				"b", 7, "touching:",			""],
		["touching color %c?",					"b", 7, "touchingColor:"],
		["color %c is touching %c?",			"b", 7, "color:sees:"],
		["distance to %m.spriteOrMouse",		"r", 7, "distanceTo:",			""],
		["distance to x:%n y:%n",				"r", 7, "distanceToPoint",		0, 0],
		["-"],
		["ask %s and wait",						" ", 7, "doAsk", 				"What's your name?"],
		["ask %s in dialog and wait",					" ", 7, "askInDialog",			"What's your name?"],
		["answer",								"r", 7, "answer"],
		["-"],
		["show dialog titled %s with text %s and wait",	" ", 7, "showDialog", "Message", "Hello!"],
		["-"],
		["key %m.key pressed?",					"b", 7, "keyPressed:",			"space"],
		["mouse down?",							"b", 7, "mousePressed"],
		["mouse x",								"r", 7, "mouseX"],
		["mouse y",								"r", 7, "mouseY"],
		["-"],
		["loudness",							"r", 7, "soundLevel"],
		["-"],
		["video %m.videoMotionType on %m.stageOrThis", "r", 7, "senseVideoMotion", "motion"],
		["turn video %m.videoState",			" ", 7, "setVideoState",			"on"],
		["set video transparency to %n%",		" ", 7, "setVideoTransparency",		50],
		["-"],
		["timer",								"r", 7, "timer"],
		["reset timer",							" ", 7, "timerReset"],
		["-"],
		["%m.attribute of %m.spriteOrStage",	"r", 7, "getAttribute:of:"],
		["-"],
		["current %m.timeAndDate", 				"r", 7, "timeAndDate",			"minute"],
		["days since 2000", 					"r", 7, "timestamp"],
		["username",							"r", 7, "getUserName"],

		// stage sensing
		["my name",								"r", 107, "name"],
		["-"],
		["ask %s and wait",						" ", 107, "doAsk", 				"What's your name?"],
		["ask %s in dialog and wait",					" ", 107, "askInDialog",		"What's your name?"],
		["answer",								"r", 107, "answer"],
		["-"],
		["show dialog titled %s with text %s and wait",	" ", 107, "showDialog", "Message", "Hello!"],
		["-"],
		["key %m.key pressed?",					"b", 107, "keyPressed:",		"space"],
		["mouse down?",							"b", 107, "mousePressed"],
		["mouse x",								"r", 107, "mouseX"],
		["mouse y",								"r", 107, "mouseY"],
		["-"],
		["loudness",							"r", 107, "soundLevel"],
		["-"],
		["video %m.videoMotionType on %m.stageOrThis", "r", 107, "senseVideoMotion", "motion", "Stage"],
		["turn video %m.videoState",			" ", 107, "setVideoState",			"on"],
		["set video transparency to %n%",		" ", 107, "setVideoTransparency",	50],
		["-"],
		["timer",								"r", 107, "timer"],
		["reset timer",							" ", 107, "timerReset"],
		["-"],
		["%m.attribute of %m.spriteOrStage",	"r", 107, "getAttribute:of:"],
		["-"],
		["current %m.timeAndDate", 				"r", 107, "timeAndDate",		"minute"],
		["days since 2000", 					"r", 107, "timestamp"],
		["username",							"r", 107, "getUserName"],

		// operators
		["%n + %n",								"r", 8, "+",					"", ""],
		["%n - %n",								"r", 8, "-",					"", ""],
		["%n * %n",								"r", 8, "*",					"", ""],
		["%n / %n",								"r", 8, "/",					"", ""],
		["%n ^ %n",								"r", 8, "^",					"", ""],
		["-"],
		["pick random %n to %n",		"r", 8, "randomFrom:to:",		1, 10],
		["-"],
		["%s < %s",								"b", 8, "<",					"", ""],
		["%s = %s",								"b", 8, "=",					"", ""],
		["%s > %s",								"b", 8, ">",					"", ""],
		["-"],
		["%b and %b",							"b", 8, "&"],
		["%b or %b",							"b", 8, "|"],
		["not %b",								"b", 8, "not"],
		["-"],
		["true",								"b", 8, "true"],
		["false",								"b", 8, "false"],
		["-"],
		["if %b then %s else %s",				"r", 8, "reportIfElse"],
		["-"],
		["%n mod %n",							"r", 8, "%",					"", ""],
		["round %n",							"r", 8, "rounded", 				""],
		["-"],
		["%m.mathOp of %n",						"r", 8, "computeFunction:of:",	"sqrt", 9],

		// variables
		["set %m.var to %s",								" ", 9, SET_VAR],
		["change %m.var by %n",								" ", 9, CHANGE_VAR],
		["show variable %m.var",							" ", 9, "showVariable:"],
		["hide variable %m.var",							" ", 9, "hideVariable:"],
		["-"],
		["move %m.var to x:%n y:%n",						" ", 9, "moveVariable"],
		["set style of %m.var to %m.varStyle",				" ", 9, "setVariableStyle"],
		["set color of %m.var to %c",						" ", 9, "setVariableColor"],
		["-"],
		["make variable %s",								" ", 9, "makeVariable", "a variable"],
		["delete variable %s",								" ", 9, "deleteVariable", "a variable"],

		// lists
		["add %s to %m.list",								" ", 12, "append:toList:"],
		["-"],
		["delete %d.listDeleteItem of %m.list",				" ", 12, "deleteLine:ofList:"],
		["insert %s at %d.listItem of %m.list",				" ", 12, "insert:at:ofList:"],
		["replace item %d.listItem of %m.list with %s",		" ", 12, "setLine:ofList:to:"],
		["-"],
		["item %d.listItem of %m.list",						"r", 12, "getLine:ofList:"],
		["length of %m.list",								"r", 12, "lineCountOfList:"],
		["%m.list contains %s?",							"b", 12, "list:contains:"],
		["index of %s in %m.list starting at %n",			"r", 12, "listIndexOf"],
		["-"],
		["show list %m.list",								" ", 12, "showList:"],
		["hide list %m.list",								" ", 12, "hideList:"],
		["-"],
		["move %m.list to x:%n y:%n",						" ", 12, "moveList"],
		["-"],
		["make list %s",									" ", 12, "makeList", "a list"],
		["delete list %s",									" ", 12, "deleteList", "a list"],
		["iterable list %m.list",									"i", 12, "arrayList:", "a list"],

		// colors
		["color r:%n g:%n b:%n",							"C", 13, "colorFromRGB", 0, 0, 0],
		["%c red",											"r", 13, "redFromColor"],
		["%c green",										"r", 13, "greenFromColor"],
		["%c blue",											"r", 13, "blueFromColor"],
		["-"],
		["color h:%n \u00b0 s:%n% v:%n%",					"C", 13, "colorFromHSV", 0, 0, 0],
		["%c hue",											"r", 13, "hueFromColor"],
		["%c saturation",									"r", 13, "saturationFromColor"],
		["%c value",										"r", 13, "valueFromColor"],
		["-"],
		["mix %c with %c",									"C", 13, "mixColors"],
		["mix %c %n : %n with %c",							"C", 13, "mixColorsWithRatio"],
		["color %c %n% brighter",							"C", 13, "scaleColorBrightness"],
		["-"],
		["color at x:%n y:%n",								"C", 13, "colorAtPoint", 0, 0],
		["-"],
		["random color",									"C", 13, "randomColor"],

		// strings
		["join %s %s",							"r", 14, "concatenate:with:",	"hello ", "world"],
		["letter %n of %s",						"r", 14, "letter:of:",			1, "world"],
		["letters %n to %n of %s",				"r", 14, "lettersOf",			1, 2, "world"],
		["-"],
		["length of %s",						"r", 14, "stringLength:",		"world"],
		["%s contains %s?",						"b", 14, "stringContains",		"hello world", "world"],
		["index of %s in %s starting at %n",	"r", 14, "stringIndexOf",		"world", "hello world", 1],
		["-"],
		["replace %s in %s with %s",			"r", 14, "stringReplace", "world", "hello world", "cow"],
		["regex %s global? %B case sensitive? %B", "r", 14, "reportRegex", "world", true, true],
		["regex %s with flags %s",				"r", 14, "reportRegexWithFlags", "world", "g"],
		["%s matches %s?",						"b", 14, "testRegex", "world", ".*"],
		["-"],
		["unicode of %s",						"r", 14, "reportUnicode", "a"],
		["unicode %n as letter",				"r", 14, "reportUnicodeAsLetter", 65],
		["split string %s on %s",				"i", 14, "splitString:", "hello world"," "],
		["return value %s %i",					" ", 10, "returnvalue:"],

		// obsolete blocks from Scratch 1.4 that may be used in older projects
		["play drum %n for %n beats",			" ", 98, "drum:duration:elapsed:from:", 1, 0.25], // Scratch 1.4 MIDI drum
		["set instrument to %n",				" ", 98, "midiInstrument:", 1],
		["loud?",								"b", 98, "isLoud"],

		// obsolete blocks from Scratch 1.4 that are converted to new forms (so should never appear):
		["abs %n",								"r", 98, "abs"],
		["sqrt %n",								"r", 98, "sqrt"],
		["stop script",							"f", 98, "doReturn"],
		["stop all",							"f", 98, "stopAll"],
		["switch to background %m.costume",		" ", 98, "showBackground:", "backdrop1"],
		["next background",						" ", 98, "nextBackground"],
		["forever if %b",						"cf",98, "doForeverIf"],
		
		// obsolete blocks from Scratch 2.0 that are converted to new forms
		["say %s for %n secs",					" ", 98, "say:duration:elapsed:from:",	"Hello!", 2],
		["say %s",								" ", 98, "say:",							"Hello!"],
		["think %s for %n secs",				" ", 98, "think:duration:elapsed:from:", "Hmm...", 2],
		["think %s",							" ", 98, "think:",						"Hmm..."],

		// testing and experimental control prims
		["noop",								"r", 99, "COUNT"],
		["counter",								"r", 99, "COUNT"],
		["clear counter",						" ", 99, "CLR_COUNT"],
		["incr counter",						" ", 99, "INCR_COUNT"],
		["all at once",							"c", 99, "warpSpeed"],

		// stage motion (scrolling)
		["scroll right %n",						" ", 99, "scrollRight",		10],
		["scroll up %n",						" ", 99, "scrollUp",		10],
		["align scene %m.scrollAlign",			" ", 99, "scrollAlign",		'bottom-left'],
		["x scroll",							"r", 99, "xScroll"],
		["y scroll",							"r", 99, "yScroll"],

		// other obsolete blocks from alpha/beta
		["hide all sprites",					" ", 99, "hideAll"],
		["user id",								"r", 99, "getUserId"],

	];

	public static var extensionSpecs:Array = ["when %m.booleanSensor", "when %m.sensor %m.lessMore %n", "sensor %m.booleanSensor?", "%m.sensor sensor value", "turn %m.motor on for %n secs", "turn %m.motor on", "turn %m.motor off", "set %m.motor power to %n", "set %m.motor2 direction to %m.motorDirection", "when distance %m.lessMore %n", "when tilt %m.eNe %n", "distance", "tilt"];

}}
