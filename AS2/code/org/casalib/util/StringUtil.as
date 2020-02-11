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

/**
	@author Aaron Clinger
	@author Mike Creighton
	@version 05/09/07
*/

class org.casalib.util.StringUtil {
	
	/**
		Transforms source string to per word capitalization.
		
		@param source: String to return as title cased.
		@return String with capitalized words.
	*/
	public static function toTitleCase(source:String):String {
		var w:Array  = source.split(' ');
		var i:Number = -1;
		
		while (++i < w.length)
			w[i] = StringUtil.replaceAt(w[i], 0, w[i].charAt(0).toUpperCase());
		
		return w.join(' ');
	}
	
	/**
		Removes all numeric characters from string.
		
		@param source: String to remove numbers from.
		@return String with numbers removed.
	*/
	public static function removeNumbersFromString(source:String):String {
		var i:Number = -1;
		
		while (++i < source.length) {
			if (!isNaN(source.charAt(i))) {
				source = StringUtil.removeAt(source, i);
				i--;
			}
		}
		
		return source;
	}
	
	/**
		Removes all non numeric characters from string.
		
		@param source: String to return numbers from.
		@return String containing only numbers.
	*/
	public static function getNumbersFromString(source:String):String {
		var i:Number = -1;
		
		while (++i < source.length) {
			if (isNaN(source.charAt(i))) {
				source = StringUtil.removeAt(source, i);
				i--;
			}
		}
		
		return source;
	}
	
	/**
		Determines if string contains search string.
		
		@param source: String to search in.
		@param search: String to search for.
		@return Returns the frequency of the search term found in source string.
	*/
	public static function contains(source:String, search:String):Number {
		var i:Number     = source.indexOf(search);
		var total:Number = 0;
		
		while (i > -1) {
			i = source.indexOf(search, i + 1);
			total++;
		}
		
		return total;
	}
	
	/**
		Strips whitespace (or other characters) from the beginning of a string.
		
		@param source: String to remove characters from.
		@param removeChars: <strong>[optional]</strong> Characters to strip (case sensitive); defaults to all whitespace characters.
		@return String with characters removed.
	*/
	public static function trimLeft(source:String, removeChars:String):String {
		removeChars = (removeChars == undefined) ? ' \n\r\t' : removeChars;
		
		var i:Number = -1;
		while (++i < source.length)
			if (removeChars.indexOf(source.charAt(i)) == -1)
				break;
		
		return source.slice(i);
	}
	
	/**
		Strips whitespace (or other characters) from the end of a string.
		
		@param source: String to remove characters from.
		@param removeChars: <strong>[optional]</strong> Characters to strip (case sensitive); defaults to all whitespace characters.
		@return String with characters removed.
	*/
	public static function trimRight(source:String, removeChars:String):String {
		removeChars = (removeChars == undefined) ? ' \n\r\t' : removeChars;
		
		var i:Number = source.length;
		while (i--)
			if (removeChars.indexOf(source.charAt(i)) == -1)
				break;
		
		return source.slice(0, i + 1);
	}
	
	/**
		Strips whitespace (or other characters) from the beginning and end of a string.
		
		@param source: String to remove characters from.
		@param removeChars: <strong>[optional]</strong> Characters to strip (case sensitive); defaults to all whitespace characters.
		@return String with characters removed.
	*/
	public static function trim(source:String, removeChars:String):String {
		return StringUtil.trimLeft(StringUtil.trimRight(source, removeChars), removeChars);
	}
	
	/**
		Removes additional spaces from string.
		
		@param source: String to remove extra spaces from.
		@return String with additional spaces removed.
	*/
	public static function removeExtraSpaces(source:String):String {
		while (source.indexOf('  ') > -1)
			source = StringUtil.replace(source, '  ', ' ');
		
		return source;
	}
	
	/**
		Removes tabs, linefeeds, carriage returns and spaces from string.
		
		@param source: String to remove whitespace from.
		@return String with whitespace removed.
	*/
	public static function removeWhitespace(source:String):String {
		return StringUtil.remove(StringUtil.remove(StringUtil.remove(StringUtil.remove(source, ' '), '\n'), '\t'), '\r');
	}
	
	/**
		Removes characters from a source string.
		
		@param source: String to remove characters from.
		@param remove: String describing characters to remove.
		@return String with characters removed.
	*/
	public static function remove(source:String, remove:String):String {
		return StringUtil.replace(source, remove, '');
	}
	
	/**
		Replaces target characters with new characters.
		
		@param source: String to replace characters from.
		@param remove: String describing characters to remove.
		@param replace: String to replace removed characters.
		@return String with characters replaced.
	*/
	public static function replace(source:String, remove:String, replace:String):String {
		return source.split(remove).join(replace);
	}
	
	/**
		Removes a character at a specific index.
		
		@param source: String to remove character from.
		@param position: Position of character to remove.
		@return String with character removed.
	*/
	public static function removeAt(source:String, position:Number):String {
		return StringUtil.replaceAt(source, position, '');
	}
	
	/**
		Replaces a character at a specific index with new characters.
		
		@param source: String to replace characters from.
		@param position: Position of character to replace.
		@param replace: String to replace removed character.
		@return String with character replaced.
	*/
	public static function replaceAt(source:String, position:Number, replace:String):String {
		var parts:Array = source.split('');
		parts.splice(position, 1, replace);
		return parts.join('');
	}
	
	/**
		Adds characters at a specific index.
		
		@param source: String to add characters to.
		@param position: Position in which to add characters.
		@param addition: String to add.
		@return String with characters added.
	*/
	public static function addAt(source:String, position:Number, addition:String):String {
		var parts:Array = source.split('');
		parts.splice(position, 0, addition);
		return parts.join('');
	}
	
	/**
		Extracts all the unique characters from a source String.
		
		@param source: String to find unique characters within.
		@return String containing unique characters from source String.
	*/
	public static function getUniqueCharacters(source:String) : String {
		var unique:String = '';
		var i:Number      = -1;
		var char:String;
		
		while (++i < source.length){
			char = source.charAt(i);
			
			if (unique.indexOf(char) == -1)
				unique += char;
		}
		
		return unique;
	}
	
	private function StringUtil() {} // Prevents instance creation
}
