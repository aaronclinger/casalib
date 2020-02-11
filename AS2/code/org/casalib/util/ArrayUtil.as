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

import org.casalib.util.NumberUtil;

/**
	Utilities for sorting, searching and manipulating Arrays.
	
	@author Aaron Clinger
	@author David Nelson
	@version 06/08/07
*/

class org.casalib.util.ArrayUtil {
	
	/**
		Determines if two Arrays contain the same objects at the same index.
		
		@param first: First Array to compare to <code>second</code>.
		@param second: Second Array to compare to <code>first</code>.
		@return Returns <code>true</code> if Arrays are the same; otherwise <code>false</code>.
	*/
	public static function equals(first:Array, second:Array):Boolean {
		var i:Number = first.length;
		
		if (i != second.length)
			return false;
		
		while (i--)
			if (first[i] != second[i])
				return false;
		
		return true;
	}
	
	/**
		Creates new Array comprised of only the non-identical elements of passed Array.
		
		@param inArray: Array to remove equivalent items.
		@return A new Array comprised of only unique elements.
		@usage
			<code>
				var numberArray:Array = new Array(1, 2, 3, 4, 4, 4, 4, 5);
				trace(ArrayUtil.removeDuplicates(numberArray));
			</code>
	*/
	public static function removeDuplicates(inArray:Array):Array {
		var o:Object;
		var i:Number = -1;
		var m:Object = new Object();
		var u:Array  = new Array();
		
		while (++i < inArray.length) {
			o = inArray[i];
			
			if (!m[o]) {
				u.push(o);
				m[o] = true;
			}
		}
		
		return u;
	}
	
	/**
		Modifies original Array by removing all items that are identical to passed <code>item</code>.
		
		@param tarArray: Array to remove passed <code>item</code>.
		@param item: Value to remove.
		@return The amount of removed elements that matched <code>item</code>, if none found returns <code>0</code>.
		@usage
			<code>
				var numberArray:Array = new Array(1, 2, 3, 7, 7, 7, 4, 5);
				trace("Removed " + ArrayUtil.removeArrayItem(numberArray, 7) + " items.");
				trace(numberArray);
			</code>
		@usageNote <code>item</code> can be any object; <code>Number</code>, <code>String</code>, <code>Object</code>, etc...
	*/
	public static function removeArrayItem(tarArray:Array, item:Object):Number {
		var l:Number = tarArray.length;
		var f:Number = 0;
		
		while (l--) {
			if (tarArray[l] == item) {
				tarArray.splice(l, 1);
				f++;
			}
		}
		
		return f;
	}
	
	/**
		Removes only the specified items in an Array.
		
		@param tarArray: Array to remove specified items from.
		@param items: Array of elements to remove.
		@return Returns <code>true</code> if the Array was changed as a result of the call; otherwise <code>false</code>.
		@usage
			<code>
				var numberArray:Array = new Array(1, 2, 3, 7, 7, 7, 4, 5);
				ArrayUtil.removeArrayItems(numberArray, new Array(1, 3, 7, 5));
				trace(numberArray);
			</code>
	*/
	public static function removeArrayItems(tarArray:Array, items:Array):Boolean {
		var removed:Boolean = false;
		var l:Number        = tarArray.length;
		var i:Number;
		
		while (l--) {
			i = ArrayUtil.indexOf(items, tarArray[l]);
			
			if (i != -1) {
				tarArray.splice(l, 1);
				removed = true;
			}
		}
		
		return removed;
	}
	
	/**
		Retains only the specified items in an Array.
		
		@param tarArray: Array to remove non specified items from.
		@param items: Array of elements to keep.
		@return Returns <code>true</code> if the Array was changed as a result of the call; otherwise <code>false</code>.
		@usage
			<code>
				var numberArray:Array = new Array(1, 2, 3, 7, 7, 7, 4, 5);
				ArrayUtil.retainArrayItems(numberArray, new Array(2, 4));
				trace(numberArray);
			</code>
	*/
	public static function retainArrayItems(tarArray:Array, items:Array):Boolean {
		var removed:Boolean = false;
		var l:Number        = tarArray.length;
		var i:Number;
		
		while (l--) {
			i = ArrayUtil.indexOf(items, tarArray[l]);
			
			if (i == -1) {
				tarArray.splice(l, 1);
				removed = true;
			}
		}
		
		return removed;
	}
	
	/**
		Finds the position of the first instance of passed <code>item</code> in <code>inArray</code>.
		
		@param inArray: Array to find <code>item</code>'s position in.
		@param item: Object to find position of.
		@param startIndex: <strong>[optional]</strong> The starting position of the search.
		@return The first index of the instance <code>item</code>; if none found returns <code>-1</code>.
		@usage
			<code>
				var colorArray = new Array("red", "blue", "pink", "black");
				trace("First postion of 'pink' is: " + ArrayUtil.indexOf(colorArray, "pink"));
			</code>
		@usageNote <code>item</code> can be any object; <code>Number</code>, <code>String</code>, <code>Object</code>, etc...
	*/
	public static function indexOf(inArray:Array, item:Object, startIndex:Number):Number {
		var i:Number = (startIndex == undefined) ? -1 : startIndex - 1;
		
		while (++i < inArray.length)
			if (inArray[i] == item)
				return i;
		
		return -1;
	}
	
	/**
		Finds the position of the last instance of passed <code>item</code> in <code>inArray</code>.
		
		@param inArray: Array to find <code>item</code>'s position in.
		@param item: Object to find position of.
		@param startIndex: <strong>[optional]</strong> The starting position of the search.
		@return The last index of the instance <code>item</code>; if none found returns <code>-1</code>.
		@usage
			<code>
				var colorArray = new Array("red", "blue", "pink", "black");
				trace("First postion of 'pink' is: " + ArrayUtil.indexOf(colorArray, "pink"));
			</code>
		@usageNote <code>item</code> can be any object; <code>Number</code>, <code>String</code>, <code>Object</code>, etc...
	*/
	public static function lastIndexOf(inArray:Array, item:Object, startIndex:Number):Number {
		var i:Number = (startIndex == undefined) ? inArray.length : startIndex;
		
		while (i--)
			if (inArray[i] == item)
				return i;
		
		return -1;
	}
	
	/**
		Finds out how many instances of <code>item</code> Array contains.
		
		@param inArray: Array to search for <code>item</code> in.
		@param item: Object to find.
		@return The amount of <code>item</code>'s found; if none were found returns <code>0</code>.
		@usage
			<code>
				var numberArray:Array = new Array(1, 2, 3, 7, 7, 7, 4, 5);
				trace("numberArray contains " + ArrayUtil.contains(numberArray, 7) + " 7's.");
			</code>
		@usageNote If you are trying to find if an array contains an item and don't need to know the total, use {@link #indexOf} instead. <code>item</code> can be any object; <code>Number</code>, <code>String</code>, <code>Object</code>, etc...
	*/
	public static function contains(inArray:Array, item:Object):Number {
		var l:Number = inArray.length;
		var t:Number = 0;
		
		while (l--)
			if (inArray[l] == item)
				t++;
		
		return t;
	}
	
	/**
		Determines if Array contains all items.
		
		@param inArray: Array to search for <code>items</code> in.
		@param items: Array of elements to search for.
		@return Returns <code>true</code> if <code>inArray</code> contains all elements of <code>items</code>; otherwise <code>false</code>.
		@usage
			<code>
				var numberArray:Array = new Array(1, 2, 3, 4, 5);
				trace(ArrayUtil.containsAll(numberArray, new Array(1, 3, 5)));
			</code>
	*/
	public static function containsAll(inArray:Array, items:Array):Boolean {
		var l:Number = items.length;
		
		while (l--)
			if (ArrayUtil.indexOf(inArray, items[l]) == -1)
				return false;
		
		return true;
	}
	
	/**
		Determines if Array <code>inArray</code> contains any element of Array <code>items</code>.
		
		@param inArray: Array to search for <code>items</code> in.
		@param items: Array of elements to search for.
		@return Returns <code>true</code> if <code>inArray</code> contains any element of <code>items</code>; otherwise <code>false</code>.
		@usage
			<code>
				var numberArray:Array = new Array(1, 2, 3, 4, 5);
				trace(ArrayUtil.containsAny(numberArray, new Array(1, 3, 5)));
			</code>
	*/
	public static function containsAny(inArray:Array, items:Array):Boolean {
		var l:Number = items.length;
		
		while (l--)
			if (ArrayUtil.indexOf(inArray, items[l]) != -1)
				return true;
		
		return false;
	}
	
	/**
		Creates new Array composed of passed Array's items in a random order.
		
		@param inArray: Array to create copy of, and randomize.
		@return A new Array comprised of passed Array's items in a random order.
		@usage
			<code>
				var numberArray:Array = new Array(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
				trace(ArrayUtil.randomize(numberArray));
			</code>
		@since Flash Player 7
	*/
	public static function randomize(inArray:Array):Array {
		var t:Array  = new Array();
		var r:Array  = inArray.sort(ArrayUtil.$sortRandom, Array.RETURNINDEXEDARRAY);
		var i:Number = -1;
		
		while (++i < inArray.length)
			t.push(inArray[r[i]]);
		
		return t;
	}
	
	private static function $sortRandom(a:Object, b:Object):Number {
		return NumberUtil.randomInteger(0, 1) ? 1 : -1;
	}
	
	
	/**
		Adds all items in <code>inArray</code> and returns the value.
		
		@param inArray: Array comprised only of numbers.
		@return The total of all numbers in <code>inArray</code> added.
		@usage
			<code>
				var numberArray:Array = new Array(2, 3);
				trace("Total is: " + ArrayUtil.sum(numberArray));
			</code>
	*/
	public static function sum(inArray: /*Number*/ Array):Number {
		var t:Number = 0;
		var l:Number = inArray.length;
		
		while (l--)
			t += inArray[l];
		
		return t;
	}
	
	/**
		Averages the values in <code>inArray</code>.
		
		@param inArray: Array comprised only of numbers.
		@return The average of all numbers in the <code>inArray</code>.
		@usage
			<code>
				var numberArray:Array = new Array(2, 3, 8, 3);
				trace("Average is: " + ArrayUtil.average(numberArray));
			</code>
	*/
	public static function average(inArray: /*Number*/ Array):Number {
		if (inArray.length == 0)
			return 0;
		
		return ArrayUtil.sum(inArray) / inArray.length;
	}
	
	/**
		Finds the lowest value in <code>inArray</code>.
		
		@param inArray: Array comprised only of numbers.
		@return The lowest value in <code>inArray</code>.
		@usage
			<code>
				var numberArray:Array = new Array(2, 1, 5, 4, 3);
				trace("The lowest value is: " + ArrayUtil.getLowestValue(numberArray));
			</code>
		@since Flash Player 7
	*/
	public static function getLowestValue(inArray: /*Number*/ Array):Number {
		return inArray[inArray.sort(16|8)[0]];
	}
	
	/**
		Finds the highest value in <code>inArray</code>.
		
		@param inArray: Array comprised only of numbers.
		@return The highest value in <code>inArray</code>.
		@usage
			<code>
				var numberArray:Array = new Array(2, 1, 5, 4, 3);
				trace("The highest value is: " + ArrayUtil.getHighestValue(numberArray));
			</code>
		@since Flash Player 7
	*/
	public static function getHighestValue(inArray: /*Number*/ Array):Number {
		return inArray[inArray.sort(16|8)[inArray.length - 1]];
	}
	
	private function ArrayUtil() {} // Prevents instance creation
}
