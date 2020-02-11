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
import org.casalib.state.StateableInterface;

/**
	Class designed to store key value pairs.
	
	@author Toby Boudreaux
	@author Aaron Clinger
	@version 12/14/06
*/

class org.casalib.state.ValueState extends CoreObject implements StateableInterface {
	private var $values:Object;
	
	public function ValueState() {
		super();
		this.$values = new Object();
		this.$setClassDescription('org.casalib.state.ValueState');
	}
	
	public function setValueForKey(key:String, value:Object):Void {
		if (key == undefined)
			return;
		
		this.$values[key] = value;
	}
	
	public function getValueForKey(key:String):Object {
		return this.$values[key];
	}
	
	public function removeValueForKey(key:String):Boolean {
		if (this.$values[key] != undefined) {
			delete this.$values[key];
			return true;
		}
		
		return false;
	}
	
	public function getValueKeys(): /*String*/ Array {
		var r: /*String*/ Array = new Array();
		
		for (var i:String in this.$values)
			r.push(i);
		
		return r;
	}
	
	public function destroy():Void {
		delete this.$values;
		super.destroy();
	}
}