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

import org.casalib.core.CoreObject;
import org.casalib.math.geom.PointInterface;
import org.casalib.util.ConversionUtil;

/**
	Stores location of a point in a two-dimensional coordinate system, where x represents the horizontal axis and y represents the vertical axis.
	
	@author Aaron Clinger
	@author David Bliss
	@version 03/21/08
*/

class org.casalib.math.geom.Point extends CoreObject implements PointInterface {
	private var $x:Number;
	private var $y:Number;
	
	/**
		Creates point object.
		
		@param x: The horizontal coordinate of the point.
		@param y: The vertical coordinate of the point.
	*/
	public function Point(x:Number, y:Number) {
		super();
		
		this.setX((x == undefined) ? 0 : x);
		this.setY((y == undefined) ? 0 : y);
		
		this.$setClassDescription('org.casalib.math.geom.Point');
	}
	
	public function getX():Number {
		return this.$x;
	}
	
	public function setX(x:Number):Void {
		this.$x = x;
	}
	
	public function getY():Number {
		return this.$y;
	}
	
	public function setY(y:Number):Void {
		this.$y = y;
	}
	
	/**
		Offsets the Point object by the specified amount.
		
		@param x: The amount by which to offset the horizontal coordinate.
		@param y: The amount by which to offset the vertical coordinate.
	*/
	public function offset(x:Number, y:Number):Void {
		this.$x += x;
		this.$y += y;
	}
	
	/**
		Rotate the Point object around another point by the specified angle.
		
		@param pointObject: The Point to rotate this point around.
		@param angle: The angle (in degrees) to rotate this point.
	*/
	public function rotate ( pointObject:Point, angle:Number ):Void {
		var radians:Number = ConversionUtil.degreesToRadians(angle);	
		
		var baseX:Number = this.$x - pointObject.getX();
		var baseY:Number = this.$y - pointObject.getY();
			
		this.$x = (Math.cos(radians)*baseX)-(Math.sin(radians)*baseY)+pointObject.getX();
		this.$y = (Math.sin(radians)*baseX)+(Math.cos(radians)*baseY)+pointObject.getY();	
	}
	
	/**
		Determines whether the point specified in the <code>pointObject</code> parameter is equal to this point object.

		@param pointObject: A defined {@link Point} object.
		@return Returns <code>true</code> if shape's location is identical; otherwise <code>false</code>.
	*/
	public function equals(pointObject:Point):Boolean {
		return this.getX() == pointObject.getX() && this.getY() == pointObject.getY();
	}
	
	/**
		@return A new point object with the same values as this point.
	*/
	public function clone():Point {
		return new Point(this.getX(), this.getY());
	}
	
	/**
		Determines the distance between the first and second points.
		
		@param firstPoint: The first point.
		@param secondPoint: The second point.
	*/
	public static function distance(firstPoint:Point, secondPoint:Point):Number {
		var x:Number = secondPoint.getX() - firstPoint.getX();
		var y:Number = secondPoint.getY() - firstPoint.getY();
		
		return Math.sqrt(x * x + y * y);
	}
	
	/**
		Determines the angle/degree between the first and second point.
		
		@param firstPoint: The first point.
		@param secondPoint: The second point.
	*/
	public static function angle(firstPoint:Point, secondPoint:Point):Number {
		return Math.atan((firstPoint.getY() - secondPoint.getY()) / (firstPoint.getX() - secondPoint.getX())) / (Math.PI / 180);
	}
	
	public function destroy():Void {
		delete this.$x;
		delete this.$y;
		
		super.destroy();
	}
}