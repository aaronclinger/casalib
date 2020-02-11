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

import org.casalib.math.Percent;

/**
	Provides utility functions for dealing with color.
	
	@author Aaron Clinger
	@version 04/02/07
*/

class org.casalib.util.ColorUtil {
	
	/**
		Converts a color in hexadecimal format into an RGB object.
		
		@param colorHex: The hexadecimal color.
		@return Returns an object with the properties r, g and b defined.
		@example
			<code>
				var myRGB:Object = ColorUtil.getRGBFromHex(0xFF00FF);
				trace("Red = " + myRGB.r);
				trace("Green = " + myRGB.g);
				trace("Blue = " + myRGB.b);
			</code>
	*/
	public static function getRGBFromHex(colorHex:Number):Object {
		var rgb:Object = new Object();
		
		rgb.r = (colorHex >> 16);
		rgb.g = (colorHex >> 8 ^ rgb.r << 8);
		rgb.b = (colorHex ^ (rgb.r << 16 | rgb.g << 8));
		
		return rgb;
	}
	
	/**
		Converts a RGB color into a hexadecimal color string.
		
		@param r: The number value of red.
		@param g: The number value of green.
		@param b: The number value of blue.
		@return Returns a hexadecimal color as a string.
		@example <code>trace(ColorUtil.getHexStringFromRGB(255, 0, 255));</code>
	*/
	public static function getHexStringFromRGB(r:Number, g:Number, b:Number):String {
		var red:String   = r.toString(16);
		var green:String = g.toString(16);
		var blue:String  = b.toString(16);
		
		red   = (red.length < 2) ? '0' + red : red;
		green = (green.length < 2) ? '0' + green : green;
		blue  = (blue.length < 2) ? '0' + blue : blue;
		
		return (red + green + blue).toUpperCase();
	}
	
	/**
		Converts a RGB color into a hexadecimal color number.
		
		@param r: The number value of red.
		@param g: The number value of green.
		@param b: The number value of blue.
		@return Returns a hexadecimal color as a number.
		@example <code>trace(ColorUtil.getHexFromRGB(255, 0, 255));</code>
	*/
	public static function getHexFromRGB(r:Number, g:Number, b:Number):Number {
		return Number('0x' + ColorUtil.getHexStringFromRGB(r, g, b));
	}
	
	/**
		Specifies the tint color and tint percentage of a MovieClip.
		
		@param target_mc: The MovieClip to tint.
		@param tintColor: The hexadecimal color to be set.
		@param percent: The tint percentage, from transparent to completely saturated.
		@example <code>ColorUtil.setTint(myMovie_mc, 0xFF00FF, new Percent(.8));</code>
	*/
	public static function setTint(target_mc:MovieClip, tintColor:Number, percent:Percent):Void {
		var targetColor:Color    = new Color(target_mc);
		var currentColor:Number  = targetColor.getRGB();
		var invertPercent:Number = 100 - percent.getPercentage();
		
		if (currentColor != 0) {
			var r:Number = ((currentColor & 0xff) * invertPercent + (tintColor & 0xff) * percent.getPercentage()) / 100;
			var g:Number = ((currentColor & 0xff00) / 0x100 * invertPercent + (tintColor & 0xff00) / 0x100 * percent.getPercentage()) / 100;
			var b:Number = ((currentColor & 0xff0000) / 0x10000 * invertPercent + (tintColor & 0xff0000) / 0x10000 * percent.getPercentage()) / 100;
			
			targetColor.setRGB(r | g << 8 | b << 16);
			return;
		}
		
		var rgb:Object   = ColorUtil.getRGBFromHex(tintColor);
		var trans:Object = new Object();
		
		trans.ra = trans.ga = trans.ba = invertPercent;
		trans.rb = rgb.r * percent.getDecimalPercentage();
		trans.gb = rgb.g * percent.getDecimalPercentage();
		trans.bb = rgb.b * percent.getDecimalPercentage();
		
		targetColor.setTransform(trans);
	}
	
	private function ColorUtil() {} // Prevents instance creation
}