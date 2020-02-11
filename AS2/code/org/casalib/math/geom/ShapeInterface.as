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

import org.casalib.math.geom.PointInterface;
import org.casalib.math.geom.Point;

/**
	@author Aaron Clinger
	@version 08/02/07
*/

interface org.casalib.math.geom.ShapeInterface extends PointInterface {
	
	/**
		@return The width of the shape at its widest point.
	*/
	public function getWidth():Number;
	
	/**
		Sets the width of the shape at its widest point.
		
		@param width: Width of the shape.
	*/
	public function setWidth(width:Number):Void;
	
	/**
		@return The height of the shape at its tallest point.
	*/
	public function getHeight():Number;
	
	/**
		Sets the height of the shape at its tallest point.
		
		@param height: Height of the shape.
	*/
	public function setHeight(height:Number):Void;
	
	/**
		@return A defined {@link Point} object with the value of the top left X and Y position of the shape.
	*/
	public function getPosition():Point;
	
	/**
		Sets the value of the top left X and Y position of the shape.
		
		@param pointObject: A defined {@link Point} object.
	*/
	public function setPosition(pointObject:Point):Void;
	
	/**
		@return A defined {@link Point} object with the value of the center position point of the shape.
	*/
	public function getCenterPoint():Point;
	
	/**
		@return The distance around the shape.
	*/
	public function getPerimeter():Number;

	/**
		@return The size of the shape.
	*/
	public function getArea():Number;
	
	/**
		Finds if point is contained inside the shape's perimeter.
		
		@param pointObject: A defined {@link Point} object.
		@return Returns <code>true</code> if shape's area contains point; otherwise <code>false</code>.
	*/
	public function containsPoint(pointObject:Point):Boolean;
	
	/**
		Determines whether the shape specified in the <code>shapeObject</code> parameter is equal to this shape object.
		
		@param shapeObject: A shape object.
		@return Returns <code>true</code> if shape's location and size is identical; otherwise <code>false</code>.
	*/
	public function equals(shapeObject:ShapeInterface):Boolean;
	
	/**
		@return A new shape object with the same values as this shape.
	*/
	public function clone():ShapeInterface;
}