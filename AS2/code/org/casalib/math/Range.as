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
import org.casalib.math.Percent;

/**
	Creates a standardized way of describing and storing an amount or extent of variation/a value range.
	
	@author Aaron Clinger
	@version 09/10/07
	@example
		<code>
			var valueRange:Range = new Range(-100, 100);
			trace(valueRange.getValueOfPercent(new Percent(.25)));
		</code>
*/

class org.casalib.math.Range extends CoreObject {
	private var $startValue:Number;
	private var $endValue:Number;
	
	/**
		Creates and defines a Range object.
		
		@param startValue: <strong>[optional]</strong> Beginning value of the range.
		@param endValue: <strong>[optional]</strong> Ending value of the range.
		@usageNote You are not required to define the range in the contructor you can do it at any point by calling {@link #setRange}.
	*/
	public function Range(startValue:Number, endValue:Number) {
		super();
		
		this.setRange(startValue, endValue);
		
		this.$setClassDescription('org.casalib.math.Range');
	}
	
	/**
		Defines or redefines range.
		
		@param startValue: Beginning value of the range.
		@param endValue: Ending value of the range.
	*/
	public function setRange(startValue:Number, endValue:Number):Void {
		this.$startValue = startValue;
		this.$endValue   = endValue;
	}
	
	/**
		@return Returns the value of <code>"startValue"</code> as defined by {@link #Range} or {@link #setRange}.
	*/
	public function getStartValue():Number {
		return this.$startValue;
	}
	
	/**
		@return Returns the value of <code>"endValue"</code> as defined by {@link #Range} or {@link #setRange}.
	*/
	public function getEndValue():Number {
		return this.$endValue;
	}
	
	/**
		@return Returns the minimum value of the range.
	*/
	public function getMinValue():Number {
		return Math.min(this.$startValue, this.$endValue);
	}
	
	/**
		@return Returns the maximum value of the range.
	*/
	public function getMaxValue():Number {
		return Math.max(this.$startValue, this.$endValue);
	}
	
	/**
		Determines if value is included in the range including the range's start and end values.
		
		@return Returns <code>true</code> if value was included in range; otherwise <code>false</code>.
	*/
	public function isWithinRange(value:Number):Boolean {
		return !(value > this.getMaxValue() || value < this.getMinValue());
	}
	
	/**
		Calculates the percent of the range.
		
		@param percent: A defined Percent object.
		@return The value the percent represent of the range.
	*/
	public function getValueOfPercent(percent:Percent):Number {
		var min:Number;
		var max:Number;
		var val:Number;
		var per:Percent = percent.clone();
		
		if (this.$startValue <= this.$endValue) {
			min = this.$startValue;
			max = this.$endValue;
		} else {
			per.setDecimalPercentage(1 - per.getDecimalPercentage());
			
			min = this.$endValue;
			max = this.$startValue;
		}
		
		val = Math.abs(max - min) * per.getDecimalPercentage() + min;
		
		per.destroy();
		
		return val;
	}
	
	/**
		Returns the percentage the value represents out of the range.
		
		@param value: An integer.
		@return A Percent object.
	*/
	public function getPercentOfValue(value:Number):Percent {
		var min:Number;
		var max:Number;
		var per:Percent;
		
		if (this.$startValue <= this.$endValue) {
			min = this.$startValue;
			max = this.$endValue;
			
			per = new Percent((value - min) / (max - min));
		} else {
			min = this.$endValue;
			max = this.$startValue;
			
			per = new Percent(1 - (value - min) / (max - min));
		}
		
		return per;
	}
	
	/**
		Determines whether the range specified by the <code>range</code> parameter is equal to this range object.
		
		@param percent: A defined {@link Range} object.
		@return Returns <code>true</code> if ranges are identical; otherwise <code>false</code>.
	*/
	public function equals(range:Range):Boolean {
		return this.getStartValue() == range.getStartValue() && this.getEndValue() == range.getEndValue();
	}
	
	/**
		Determines whether this range and the range specified by the <code>range</code> parameter overlap.
		
		@param A defined {@link Range} object.
		@return Returns <code>true</code> if this range contains any value of the range specified; otherwise <code>false</code>.
	*/
	public function overlaps(range:Range):Boolean {
		if (this.equals(range) || this.contains(range) || range.contains(this) || this.isWithinRange(range.getStartValue()) || this.isWithinRange(range.getEndValue()))
			return true;
		
		return false;
	}
	
	/**
		Determines whether this range contains the range specified by the <code>range</code> parameter.
		
		@param A defined {@link Range} object.
		@return Returns <code>true</code> if this range contains all values of the range specified; otherwise <code>false</code>.
	*/
	public function contains(range:Range):Boolean {
		return this.getStartValue() <= range.getStartValue() && this.getEndValue() >= range.getEndValue();
	}
	
	/**
		@return A new range object with the same values as this range.
	*/
	public function clone():Range {
		return new Range(this.getStartValue(), this.getEndValue());
	}
	
	public function destroy():Void {
		delete this.$startValue;
		delete this.$endValue;
		
		super.destroy();
	}
}