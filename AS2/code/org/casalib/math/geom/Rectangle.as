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

import org.casalib.math.geom.BaseShape;
import org.casalib.math.geom.Point;

/**
	Stores position and size of a rectangle (or square).

	@author Aaron Clinger
	@version 08/02/07
*/

class org.casalib.math.geom.Rectangle extends BaseShape {
	
	
	/**
		Creates new rectangle object.
		
		@param x: The horizontal position of the rectangle.
		@param y: The vertical position of the rectangle.
		@param width: Width of the rectangle.
		@param height: <strong>[optional]</strong> Height of the rectangle. If <code>undefined</code> assumes <code>height</code> matches <code>width</code> (Creates square).
	*/
	public function Rectangle(x:Number, y:Number, width:Number, height:Number) {
		super(x, y, width, height);
		
		this.$setClassDescription('org.casalib.math.geom.Rectangle');
	}
	
	/**
		@return The right X position of the rectangle.
	*/
	public function getX2():Number {
		return this.getX() + this.getWidth();
	}
	
	/**
		Sets the right position of the rectangle.
		
		@param x: The right X position of the rectangle.
	*/
	public function setX2(x:Number):Void {
		this.setWidth(x - this.getX());
	}
	
	/**
		@return The bottom Y position of the rectangle.
	*/
	public function getY2():Number {
		return this.getY() + this.getHeight();
	}
	
	/**
		Sets the bottom position of the rectangle.
		
		@param y: The bottom Y position of the rectangle.
	*/
	public function setY2(y:Number):Void {
		this.setHeight(y - this.getY());
	}
	
	public function getPerimeter():Number {
		return this.getWidth() * 2 + this.getHeight() * 2;
	}
	
	public function getArea():Number {
		return this.getWidth() * this.getHeight();
	}
	
	public function containsPoint(pointObject:Point):Boolean {
		return pointObject.getX() >= this.getX() && pointObject.getX() <= this.getX2() && pointObject.getY() >= this.getY() && pointObject.getY() <= this.getY2();
	}
	
	/**
		Determines whether the rectangle specified in the <code>rectangleObject</code> parameter is equal to this rectangle object.
		
		@param rectangleObject: A defined {@link Rectangle} object.
		@return {@inheritDoc}
	*/
	public function equals(rectangleObject:Rectangle):Boolean {
		return this.getX() == rectangleObject.getX() && this.getY() == rectangleObject.getY() && this.getWidth() == rectangleObject.getWidth() && this.getHeight() == rectangleObject.getHeight();
	}
	
	/**
		@return A new rectangle object with the same values as this rectangle.
	*/
	public function clone():Rectangle {
		return new Rectangle(this.getX(), this.getY(), this.getWidth(), this.getHeight());
	}
	
	public function destroy():Void {
		super.destroy();
	}
}