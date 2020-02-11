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

import org.casalib.math.geom.Point;

/**
	Stores location of a point in a three-dimensional coordinate system, where x represents the horizontal axis, y represents the vertical axis, z represents the axis that is vertically perpendicular to the xy axis or depth.
	
	@author Aaron Clinger
	@version 03/21/08
*/

class org.casalib.math.geom.Point3d extends Point {
	private var $z:Number;
    
	/**
		Creates 3d point object.
		
		@param x: The horizontal coordinate of the point.
		@param y: The vertical coordinate of the point.
		@param z: The depth coordinate of the point.
	*/
	public function Point3d(x:Number, y:Number, z:Number) {
		super(x, y);
		
		this.setZ((z == undefined) ? 0 : z);
		
		this.$setClassDescription('org.casalib.math.geom.Point3d');
	}
	
	/**
		@return The Z position.
	*/
	public function getZ():Number {
		return this.$z;
	}
	
	/**
		Sets the Z coordinate.
		
		@param z: The depth coordinate of the point.
	*/
	public function setZ(z:Number):Void {
		this.$z = z;
	}
	
	/**
		Offsets the Point object by the specified amount.
		
		@param x: The amount by which to offset the horizontal coordinate.
		@param y: The amount by which to offset the vertical coordinate.
		@param z: The amount by which to offset the depth coordinate.
	*/
	public function offset(x:Number, y:Number, z:Number):Void {
		super.offset(x, y);
		this.$z += z;
	}
	
	/**
		Determines whether the point specified in the <code>pointObject</code> parameter is equal to this point object.

		@param pointObject: A defined {@link Point3d} object.
		@return Returns <code>true</code> if shape's location is identical; otherwise <code>false</code>.
	*/
	public function equals(pointObject:Point3d):Boolean {
		return this.getX() == pointObject.getX() && this.getY() == pointObject.getY() && this.getZ() == pointObject.getZ();
	}
	
	/**
		@return A new point object with the same values as this point.
	*/
	public function clone():Point3d {
		return new Point3d(this.getX(), this.getY(), this.getZ());
	}
	
	/**
		Determines the distance between the first and second points in 3D space.
		
		@param firstPoint: The first point.
		@param secondPoint: The second point.
	*/
	public static function distance(firstPoint:Point3d, secondPoint:Point3d):Number {
		var x:Number = secondPoint.getX() - firstPoint.getX();
		var y:Number = secondPoint.getY() - firstPoint.getY();
		var z:Number = secondPoint.getZ() - firstPoint.getZ();
		
		return Math.sqrt(x * x + y * y + z * z);
	}
	
	public function destroy():Void {
		delete this.$z;
		super.destroy();
	}
}