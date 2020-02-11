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

import org.casalib.textfield.CoreTextField;

/**
	Utilities for determining an object's type.
	
	@author Aaron Clinger
	@author David Nelson
	@version 05/12/07
*/

class org.casalib.util.TypeUtil {
	
	/**
		Evaluates an object and returns a string describing its type. This method is more versed than the <code>typeof</code> equivalent.
		
		@param obj: Object to evaluate.
		@return Returns a string describing the objects type.
		@usageNote {@link CoreTextField} and {@link CoreMovieClip} will return types of <code>"textfield"</code> and <code>"movieclip"</code> respectively.
	*/
	public static function getTypeOf(obj:Object):String {
		if (obj instanceof CoreTextField)
			return 'textfield';
		var t:String = typeof obj;
		if (t != 'object')
			return t;
		if (obj instanceof Array)
			return 'array';
		if (obj instanceof Button)
			return 'button';
		if (obj instanceof Color)
			return 'color';
		if (obj instanceof ContextMenu)
			return 'contextmenu';
		if (obj instanceof ContextMenuItem)
			return 'contextmenuitem';
		if (obj instanceof Date)
			return 'date';
		if (obj instanceof Error)
			return 'error';
		if (obj instanceof LoadVars)
			return 'loadvars';
		if (obj instanceof LocalConnection)
			return 'localconnection';
		if (obj instanceof MovieClipLoader)
			return 'moviecliploader';
		if (obj instanceof NetConnection)
			return 'netconnection';
		if (obj instanceof NetStream)
			return 'netstream';
		if (obj instanceof PrintJob)
			return 'printjob';
		if (obj instanceof Sound)
			return 'sound';
		if (obj instanceof TextField)
			return 'textfield';
		if (obj instanceof TextFormat)
			return 'textformat';
		if (obj instanceof TextSnapshot)
			return 'textsnapshot';
		if (obj instanceof Video)
			return 'video';
		if (obj instanceof XML)
			return 'xml';
		if (obj instanceof XMLNode)
			return 'xmlnode';
		if (obj instanceof XMLSocket)
			return 'xmlsocket';
		if (obj instanceof XML)
			return 'xml';
		
		return 'object';
	}
	
	/**
		Evaluates if an object is of a certain type. Can detect any types that {@link #getTypeOf} can describe.
		
		@param obj: Object to evaluate.
		@param type: String describe the objects type.
		@return Returns <code>true</code> if object matches type; otherwise <code>false</code>.
	*/
	public static function isTypeOf(obj:Object, type:String):Boolean {
		return TypeUtil.getTypeOf(obj) == type.toLowerCase();
	}
	
	private function TypeUtil() {} // Prevents instance creation
}