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

/**
	Creates a standardized way of describing and storing percentages. You can store and receive percentages in two different formats; regular percentage or as an decimal percentage.
	
	If percent is 37.5% a regular percentage would be expressed as <code>37.5</code> while the decimal percentage will be expressed <code>.375</code>.
	
	@author Aaron Clinger
	@version 12/01/06
	@example
		<code>
			var boxWidthPer:Percent = new Percent();
			this.boxWidthPer.setPercentage(25);
			
			this.box_mc._width *= boxWidthPer.getDecimalPercentage();
		</code>
*/

class org.casalib.math.Percent extends CoreObject {
	private var $percent:Number;
	
	/**
		Creates a new percentage class with the option of defining the percent on creation.
		
		@param percentage: <strong>[optional]</strong> Percent formated at a percentage or an decimal percentage.
		@param isDecimalPercentage: <strong>[optional]</strong> Indicates if the parameter <code>percentage</code> is a decimal percentage <code>true</code>, or regular percentage <code>false</code>; defaults to <code>true</code>.
	*/
	public function Percent(percentage:Number, isDecimalPercentage:Boolean) {
		super();
		
		if (isDecimalPercentage == true || isDecimalPercentage == undefined)
			this.setDecimalPercentage(percentage);
		else
			this.setPercentage(percentage);
		
		this.$setClassDescription('org.casalib.math.Percent');
	}
	
	/**
		Sets the percentage.
		
		@param percent: Percent expressed as a regular percentage. 37.5% would be expressed as <code>37.5</code>.
	*/
	public function setPercentage(percent:Number):Void {
		this.$percent = percent * .01;
	}
	
	/**
		Gets the percentage.
		
		@return Returns percent expressed as a regular percentage. 37.5% would be returned as <code>37.5</code>.
	*/
	public function getPercentage():Number {
		return 100 * this.$percent;
	}
	
	/**
		Sets the percentage.
		
		@param percent: Percent expressed as a decimal percentage. 37.5% would be expressed as <code>.375</code>.
	*/
	public function setDecimalPercentage(percent:Number):Void {
		this.$percent = percent;
	}
	
	/**
		Gets the percentage.
		
		@return Returns percent expressed as a decimal percentage. 37.5% would be returned as <code>.375</code>.
	*/
	public function getDecimalPercentage():Number {
		return this.$percent;
	}
	
	/**
		Determines whether the percent specified in the <code>percent</code> parameter is equal to this percent object.

		@param percent: A defined {@link Percent} object.
		@return Returns <code>true</code> if percents are identical; otherwise <code>false</code>.
	*/
	public function equals(percent:Percent):Boolean {
		return this.getDecimalPercentage() == percent.getDecimalPercentage();
	}
	
	/**
		@return A new percent object with the same value as this percent.
	*/
	public function clone():Percent {
		return new Percent(this.getDecimalPercentage());
	}
	
	public function destroy():Void {
		delete this.$percent;
		super.destroy();
	}
}