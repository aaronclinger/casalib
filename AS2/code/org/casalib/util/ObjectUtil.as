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

/**
	@author Aaron Clinger
	@author David Nelson
	@version 04/04/07
*/

class org.casalib.util.ObjectUtil {
	
	/**
		Searches the first level properties of an object for a another object.
		
		@param obj: Object to search in.
		@param member: Object to search for.
		@return Returns <code>true</code> if object was found; otherwise <code>false</code>.
	*/
	public static function contains(obj:Object, member:Object):Boolean {
		for (var prop:String in obj)
			if (obj[prop] == member)
				return true;
		
		return false;
	}
	
	/**
		Makes a clone of the original Object.
		
		@param obj: Object to make the clone of.
		@return Returns a duplicate Object.
	*/
	public static function clone(obj:Object):Object {
		var cloneObj:Object = new (Function(obj.__proto__.constructor))();
		
		for (var prop:String in obj) {
			switch (TypeUtil.getTypeOf(obj[prop])) {
				case 'array' :
					cloneObj[prop] = obj[prop].slice();
					break;
				case 'object' :
					cloneObj[prop] = ObjectUtil.clone(obj[prop]);
					break;
				default :
					cloneObj[prop] = obj[prop];
					break;
			}
		}
		
		return cloneObj;
	}
	
	/**
		Uses the strict equality operator to determine if object is <code>undefined</code>.
		
		@param obj: Object to determine if <code>undefined</code>.
		@return Returns <code>true</code> if object is <code>undefined</code>; otherwise <code>false</code>.
	*/
	public static function isUndefined(obj:Object):Boolean {
		return obj === undefined;
	}
	
	/**
		Uses the strict equality operator to determine if object is <code>null</code>.
		
		@param obj: Object to determine if <code>null</code>.
		@return Returns <code>true</code> if object is <code>null</code>; otherwise <code>false</code>.
	*/
	public static function isNull(obj:Object):Boolean {
		return obj === null;
	}
	
	/**
		Determines if object contains no value(s).
		
		@param obj: Object to derimine if empty.
		@return Returns <code>true</code> if object is empty; otherwise <code>false</code>.
		@usage
			<code>
				var testArray:Array   = new Array();
				var testString:String = '';
				var testObject:Object = new Object();
				
				trace(ObjectUtil.isEmpty(testArray));  // traces "true"
				trace(ObjectUtil.isEmpty(testObject)); // traces "true"
				trace(ObjectUtil.isEmpty(testString)); // traces "true"
			</code>
	*/
	public static function isEmpty(obj:Object):Boolean {
		if (obj == undefined)
			return true;
		//@TODO Update method to correctly test more object types.
		switch (TypeUtil.getTypeOf(obj)) {
			case 'string' :
			case 'array' :
				return (obj.length == 0) ? true : false;
				break;
			case 'object' :
				for (var prop:String in obj)
					return false;
				break;
		}
		
		return true;
	}
	
	private function ObjectUtil() {} // Prevents instance creation
}