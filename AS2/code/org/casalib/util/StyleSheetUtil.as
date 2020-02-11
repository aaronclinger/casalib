/*
	CASA Lib for ActionScript 2.0
	Copyright (c) 2008, Aaron Clinger & Contributors of CASA Lib
	All rights reserved.
	
	Redistribution and use in source and binary forms, with or without
	modification, are permitted provided that the following conditions are met:
	
	- Redistributions of source code must retain the above copyright notice,
	  this list of conditions and the following disclaimer.
	
	- Redistributions in binary form must reproduce the above copyright notice,
	  this list of conditions and the following disclaimer in the documentation
	  and/or other materials provided with the distribution.
	
	- Neither the name of the CASA Lib nor the names of its contributors
	  may be used to endorse or promote products derived from this software
	  without specific prior written permission.
	
	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
	AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
	IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
	ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
	LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
	CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
	SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
	INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
	CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
	ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
	POSSIBILITY OF SUCH DAMAGE.
*/

import org.casalib.util.TypeUtil;
import org.casalib.util.StringUtil;
import org.casalib.util.NumberUtil;

/**
	@author Aaron Clinger
	@version 12/22/06
	@since Flash Player 7
*/

class org.casalib.util.StyleSheetUtil {

	/**
		Positions a TextField, MovieClip or Button relative to the stage using an object of defined properties that mimic the CSS equivalents. This object can be created manually or passed from a <code>StyleSheet</code> object.
		<table border="1">
			<tr style="background-color:#e1e1e1;">
				<th width="150px">CSS property</th>
				<th width="150px">ActionScript property</th>
				<th>Usage and supported values</th>
			</tr>
			<tr>
				<td>top</td>
				<td>top</td>
				<td>Defines object's distance from the top of the stage. Position can be defined in pixels <code>"15px"</code> or as a percentage of the stage height <code>"5%"</code>.</td>
			</tr>
			<tr style="background-color:#f0f5f9;">
				<td>right</td>
				<td>right</td>
				<td>Defines object's distance from the right of the stage. Position can be defined in pixels <code>"15px"</code> or as a percentage of the stage width <code>"5%"</code>.</td>
			</tr>
			<tr>
				<td>bottom</td>
				<td>bottom</td>
				<td>Defines object's distance from the bottom of the stage. Position can be defined in pixels <code>"15px"</code> or as a percentage of the stage height <code>"5%"</code>.</td>
			</tr>
			<tr style="background-color:#f0f5f9;">
				<td>left</td>
				<td>left</td>
				<td>Defines object's distance from the left of the stage. Position can be defined in pixels <code>"15px"</code> or as a percentage of the stage width <code>"5%"</code>.</td>
			</tr>
			<tr>
				<td>margin-top</td>
				<td>marginTop</td>
				<td>Defines the vertical spacing from top position. Position can be defined in pixels <code>"15px"</code> or as a percentage of the stage height <code>"5%"</code>.</td>
			</tr>
			<tr style="background-color:#f0f5f9;">
				<td>margin-right</td>
				<td>marginRight</td>
				<td>Defines the horizontal spacing from right position. Position can be defined in pixels <code>"15px"</code> or as a percentage of the stage width <code>"5%"</code>.</td>
			</tr>
			<tr>
				<td>margin-bottom</td>
				<td>marginBottom</td>
				<td>Defines the vertical spacing from bottom position. Position can be defined in pixels <code>"15px"</code> or as a percentage of the stage height <code>"5%"</code>.</td>
			</tr>
			<tr style="background-color:#f0f5f9;">
				<td>margin-left</td>
				<td>marginLeft</td>
				<td>Defines the horizontal spacing from left position. Position can be defined in pixels <code>"15px"</code> or as a percentage of the stage width <code>"5%"</code>.</td>
			</tr>
			<tr>
				<td>margin</td>
				<td>margin</td>
				<td>A shorthand property for setting the four margin properties in one declaration; see documentation above. Values should be seperated by spaces and are defined in the following order: top, right, bottom and left.</td>
			</tr>
			<tr style="background-color:#f0f5f9;">
				<td>width</td>
				<td>width</td>
				<td>Defines the width of the object. Value can be defined in pixels <code>"250px"</code> or as a percentage of the stage width <code>"25%"</code>.</td>
			</tr>
			<tr>
				<td>height</td>
				<td>height</td>
				<td>Defines the height of the object. Value can be defined in pixels <code>"250px"</code> or as a percentage of the stage height <code>"25%"</code>.</td>
			</tr>
			<tr style="background-color:#f0f5f9;">
				<td>max-width</td>
				<td>maxWidth</td>
				<td>Defines the maximum width of an object. This is most helpful when the width of an object is set to a percentage and the max width is set to a pixel value. Value can be defined in pixels <code>"250px"</code> or as a percentage of the stage width <code>"25%"</code>.</td>
			</tr>
			<tr>
				<td>max-height</td>
				<td>maxHeight</td>
				<td>Defines the maximum height of an object. This is most helpful when the height of an object is set to a percentage and the max height is set to a pixel value. Value can be defined in pixels <code>"250px"</code> or as a percentage of the stage height <code>"25%"</code>.</td>
			</tr>
			<tr style="background-color:#f0f5f9;">
				<td>min-width</td>
				<td>minWidth</td>
				<td>Defines the minimum width of an object. This is most helpful when the width of an object is set to a percentage and the min width is set to a pixel value. Value can be defined in pixels <code>"250px"</code> or as a percentage of the stage width <code>"25%"</code>.</td>
			</tr>
			<tr>
				<td>min-height</td>
				<td>minHeight</td>
				<td>Defines the minimum height of an object. This is most helpful when the height of an object is set to a percentage and the min height is set to a pixel value. Value can be defined in pixels <code>"250px"</code> or as a percentage of the stage height <code>"25%"</code>.</td>
			</tr>
			<tr style="background-color:#f0f5f9;">
				<td>background-color</td>
				<td>backgroundColor</td>
				<td>Defines the background color of TextFields and the object color of MovieClips and Buttons. Only hexadecimal color values are supported. Named colors (such as <code>"blue"</code>) are not supported. Colors are written in the following format: <code>"#FF00FF"</code>.</td>
			</tr>
			<tr>
				<td>border-color</td>
				<td>borderColor</td>
				<td>Defines the border color of a Textfield. Only hexadecimal color values are supported. Named colors (such as <code>"blue"</code>) are not supported. Colors are written in the following format: <code>"#FF00FF"</code>.</td>
			</tr>
			<tr style="background-color:#f0f5f9;">
				<td>opacity</td>
				<td>opacity</td>
				<td>Defines the alpha transparency of the object. Valid value range is <code>"0.0"</code> to <code>"1.0"</code></td>
			</tr>
		</table>
		
		@param item: A <code>MovieClip</code>, <code>TextField</code> or <code>Button</code>.
		@param style: An object that describes the style with the supported properties above.
		@return Returns <code>true</code> if item was of type <code>MovieClip</code>, <code>TextField</code> or <code>Button</code> and was successfully styled; otherwise <code>false</code>.
		@example
			<code>
				Stage.align = "TL";
				Stage.scaleMode = "noScale";
				
				var myStylePosition:Object = new Object();
				this.myStylePosition.top      = "25px";
				this.myStylePosition.left     = "0";
				this.myStylePosition.margin   = "0 5px 0 5px";
				this.myStylePosition.width    = "100%";
				this.myStylePosition.height   = "200px";
				
				StyleSheetUtil.positionItemWithStyleObject(this.myMovieClip_mc, this.myStylePosition);
			</code>
			Or you can use a stylesheet object:
			<code>
				StyleSheetUtil.positionItemWithStyleObject(this.myMovieClip_mc, myStyleSheet.getStyle());
			</code>
	*/
	public static function positionItemWithStyleObject(item:Object, style:Object):Boolean {
		var isText:Boolean = false;
		
		switch (TypeUtil.getTypeOf(item)) {
			case 'textfield' :
				isText = true;
			case 'movieclip' :
			case 'button' :
				break;
			default :
				return false;
		}
		
		var margin:Object = {top:0, right:0, bottom:0, left:0};
		
		var i:String;
		var val:String;
		var width:Number;
		var height:Number;
		var topMin:Number;
		var topMax:Number;
		var leftMin:Number;
		var leftMax:Number;
		var maxWidth:Number;
		var maxHeight:Number;
		var minWidth:Number;
		var minHeight:Number;
		
		for (i in style) {
			val = style[i];
			switch (i) {
				case 'margin' :
					var sides:Array = StringUtil.removeExtraSpaces(val).split(' ');
					if (sides.length == 1) {
						margin.top = margin.bottom = StyleSheetUtil.$getVerticalValue(sides[0]);
						margin.right = margin.left = StyleSheetUtil.$getHorizontalValue(sides[0]);
						break;
					}
					
					if (sides[0] != undefined) margin.top    = StyleSheetUtil.$getVerticalValue(sides[0]);
					if (sides[1] != undefined) margin.right  = StyleSheetUtil.$getHorizontalValue(sides[1]);
					if (sides[2] != undefined) margin.bottom = StyleSheetUtil.$getVerticalValue(sides[2]);
					if (sides[3] != undefined) margin.left   = StyleSheetUtil.$getHorizontalValue(sides[3]);
					break;
				case 'marginTop' :
					margin.top = StyleSheetUtil.$getVerticalValue(val);
					break;
				case 'marginRight' :
					margin.right = StyleSheetUtil.$getHorizontalValue(val);
					break;
				case 'marginBottom' :
					margin.bottom = StyleSheetUtil.$getVerticalValue(val);
					break;
				case 'marginLeft' :
					margin.left = StyleSheetUtil.$getHorizontalValue(val);
					break;
				case 'width' :
					width = StyleSheetUtil.$getHorizontalValue(val);
					break;
				case 'maxWidth' :
					maxWidth = StyleSheetUtil.$getHorizontalValue(val);
					break;
				case 'minWidth' :
					minWidth = StyleSheetUtil.$getHorizontalValue(val);
					break;
				case 'height' :
					height = StyleSheetUtil.$getVerticalValue(val);
					break;
				case 'maxHeight' :
					maxHeight = StyleSheetUtil.$getVerticalValue(val);
					break;
				case 'minHeight' :
					minHeight = StyleSheetUtil.$getVerticalValue(val);
					break;
				case 'backgroundColor' :
					if (val.substr(0, 1) == '#') {
						var colorString:String = '0x' + val.substr(1);
						if (!isNaN(colorString)) {
							if (isText) {
								item.border = item.background = true;
								item.backgroundColor = Number(colorString);
							} else {
								var backColor:Color = new Color(item);
								backColor.setRGB(Number(colorString));
							}
						}
					}
					break;
				case 'borderColor' :
					if (isText) {
						if (val.substr(0, 1) == '#') {
							var colorString:String = '0x' + val.substr(1);
							if (!isNaN(colorString)) {
								if (!item.border) item.border = true;
								item.borderColor = colorString;
							}
						}
					}
					break;
				case 'opacity' :
					if (!isNaN(val)) if (NumberUtil.isBetween(Number(val), 0, 1)) item._alpha = Math.round(100 * Number(val));
					break;
			}
		}
		
		width  = NumberUtil.max(NumberUtil.min(width, maxWidth), minWidth);
		height = NumberUtil.max(NumberUtil.min(height, maxHeight), minHeight);
		
		if (height != undefined) item._height = height - margin.top - margin.bottom;
		if (width  != undefined) item._width  = width - margin.right - margin.left;
		
		for (i in style) {
			val = style[i];
			switch (i) {
				case 'top' :
					item._y = margin.top + StyleSheetUtil.$getVerticalValue(val);
					break;
				case 'right' :
					item._x = (StyleSheetUtil.$getStylePropertyUnitByValue(val) == 'px') ? Stage.width - item._width - margin.right - StyleSheetUtil.$getHorizontalValue(val) : Stage.width - item._width - margin.right - StyleSheetUtil.$getHorizontalValue(val);
					break;
				case 'bottom' :
					item._y = (StyleSheetUtil.$getStylePropertyUnitByValue(val) == 'px') ? Stage.height - item._height - margin.bottom - StyleSheetUtil.$getVerticalValue(val) : Stage.height - item._height - margin.bottom - StyleSheetUtil.$getVerticalValue(val);
					break;
				case 'left' :
					item._x = margin.left + StyleSheetUtil.$getHorizontalValue(val);
					break;
				case 'minTop' :
				case 'maxBottom' :
					topMin = StyleSheetUtil.$getVerticalValue(val);
					break;
				case 'maxTop' :
				case 'minBottom' :
					topMax = StyleSheetUtil.$getVerticalValue(val);
					break;
				case 'minLeft' :
				case 'maxRight' :
					leftMin = StyleSheetUtil.$getHorizontalValue(val);
					break;
				case 'maxLeft' :
				case 'minRight' :
					leftMax = StyleSheetUtil.$getHorizontalValue(val);
					break;
			}
		}
		
		item._x = NumberUtil.max(NumberUtil.min(item._x, leftMax), leftMin);
		item._y = NumberUtil.max(NumberUtil.min(item._y, topMax), topMin);
		
		return true;
	}
	
	private static function $getStylePropertyUnitByValue(value:String):String {
		if (!isNaN(value)) return 'px';
		else if (value.substr(-2).toLowerCase() == 'px') if (!isNaN(value.substr(0, -2))) return 'px';
		else if (value.substr(-1) == '%') if (!isNaN(value.substr(0, -1))) return '%';
	}
	
	private static function $getValue(value:String):Number {
		if (value.substr(-2).toLowerCase() == "px") {
			var num:Number = Number(value.substr(0, -2));
			if (!isNaN(num)) return num;
		} else if (value.substr(-1) == "%") {
			var num:Number = Number(value.substr(0, -1));
			if (!isNaN(num)) return num * .01;
		} else if (!isNaN(value)) return Number(value);
	}
	
	private static function $getHorizontalValue(value:String):Number {
		return (StyleSheetUtil.$getStylePropertyUnitByValue(value) == 'px') ? StyleSheetUtil.$getValue(value) : StyleSheetUtil.$getValue(value) * Stage.width;
	}
	
	private static function $getVerticalValue(value:String):Number {
		return (StyleSheetUtil.$getStylePropertyUnitByValue(value) == 'px') ? StyleSheetUtil.$getValue(value) : StyleSheetUtil.$getValue(value) * Stage.height;
	}
	
	
	private function StyleSheetUtil() {} // Prevents instance creation
}
