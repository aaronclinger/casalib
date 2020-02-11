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
	Utilities for converting field-value query strings to and from Objects.
	
	@author Aaron Clinger
	@version 05/30/07
*/

class org.casalib.util.QueryStringUtil {
	
	/**
		Converts an Object's first level variables into field-value pairs.
		
		@param data: Object that contains variables to convert to field-value pairs.
		@param separator: <strong>[optional]</strong> The string that separates the field-value pairs; defaults to <code>"&"</code>.
		@return Returns a query string.
		@usage
			<code>
				var dataToSend:Object = new Object();
				dataToSend.id = 13;
				dataToSend.name = 'Aaron';
				
				trace(QueryStringUtil.encode(dataToSend));
			</code>
	*/
	public static function encode(data:Object, separator:String):String {
		if (separator == undefined)
			separator = '&';
		
		var query:String = '';
		var val:Object;
		
		for (var i:String in data) {
			val = data[i];
			
			switch (TypeUtil.getTypeOf(val)) {
				case 'boolean' :
					query += i + '=' + (val ? 'true' : 'false') + '&';
					break;
				case 'string' :
					query += i + '=' + val + '&';
					break;
				case 'number' :
					query += i + '=' + val.toString() + '&';
					break;
			}
		}
		
		return query.slice(0, -1);
	}
	
	/**
		Converts a query string of field-value pairs to an Object.
		
		@param query: String composed of a series of field-value pairs.
		@param separator: <strong>[optional]</strong> The string that separates the field-value pairs; defaults to <code>"&"</code>.
		@return Returns Object composed of defined variables Strings.
		@usageNote Method automatically <code>unescape</code>'s values.
		@usage
			<code>
				var fieldValues:Object = QueryStringUtil.decode("name=Aaron&id=13");
				trace(fieldValues.name);
				trace(fieldValues.id);
			</code>
	*/
	public static function decode(query:String, separator:String):Object {
		if (separator == undefined)
			separator = '&';
		
		var index:Number = query.indexOf('?');
		if (index != -1)
			query = query.slice(index + 1);
		
		var fieldValues:Object = new Object();
		var pairs:Array        = query.split(separator);
		var i:Number           = -1;
		var pair:String;
		
		while (++i < pairs.length) {
			pair  = pairs[i];
			index = pair.indexOf('=');
			
			if (index > -1)
				fieldValues[pair.slice(0, index)] = unescape(pair.slice(index + 1));
		}
		
		return fieldValues;
	}
	
	private function QueryStringUtil() {} // Prevents instance creation
}
