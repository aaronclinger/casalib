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
import org.casalib.math.geom.ShapeInterface;
import org.casalib.math.geom.Point;

/**
	Base shape class. Class needs to be extended further to function properly.
	
	@author Aaron Clinger
	@version 08/02/07
*/

class org.casalib.math.geom.BaseShape extends CoreObject implements ShapeInterface {
	private var $x:Number;
	private var $y:Number;
	private var $width:Number;
	private var $height:Number;
	
	
	private function BaseShape(x:Number, y:Number, width:Number, height:Number) {
		super();
		
		this.setX((x == undefined) ? 0 : x);
		this.setY((y == undefined) ? 0 : y);
		this.setWidth((width == undefined) ? 0 : width);
		this.setHeight((height == undefined) ? this.getWidth() : height);
		
		this.$setClassDescription('org.casalib.math.geom.BaseShape');
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
	
	public function getPosition():Point {
		return new Point(this.getX(), this.getY());
	}
	
	public function setPosition(pointObject:Point):Void {
		this.setX(pointObject.getX());
		this.setY(pointObject.getY());
	}
	
	public function getCenterPoint():Point {
		return new Point(this.getX() + this.getWidth() * .5, this.getY() + this.getHeight() * .5);
	}
	
	public function getWidth():Number {
		return this.$width;
	}
	
	public function setWidth(width:Number):Void {
		this.$width = width;
	}
	
	public function getHeight():Number {
		return this.$height;
	}
	
	public function setHeight(height:Number):Void {
		this.$height = height;
	}
	
	public function getPerimeter():Number {
		return null;
	}
	
	public function getArea():Number {
		return null;
	}
	
	public function containsPoint(pointObject:Point):Boolean {
		return null;
	}
	
	public function equals(shape:ShapeInterface):Boolean {
		return null;
	}
	
	public function clone():ShapeInterface {
		return null;
	}
	
	public function destroy():Void {
		delete this.$x;
		delete this.$y;
		delete this.$width;
		delete this.$height;
		
		super.destroy();
	}
}