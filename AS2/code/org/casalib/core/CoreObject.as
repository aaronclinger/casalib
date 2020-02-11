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

import org.casalib.core.CoreInterface;

/**
	A core level object to inherent from which extends Flash's built-in object class. All object classes not extending from core flash classes/types should extend from here
	
	@author Toby Boudreaux
	@author David Nelson
	@author Aaron Clinger
	@version 02/06/07
	@usageNote All user defined objects should inherent from CoreObject to return a detailed class description rather than the default <code>[object Object]</code>. In subclasses call method <code>$setClassDescription(description:String)</code> to set class description.
	@example
		<code>
			class com.example.Example extends CoreObject {
				public function Example() {
					super();
					
					this.$setClassDescription("com.example.Example");
				}
			}
		</code>
*/

class org.casalib.core.CoreObject implements CoreInterface {
	private var $instanceDescription:String;
	
	public function CoreObject() {
		this.$setClassDescription('org.casalib.core.CoreObject');
	}
	
	public function toString():String {
		return '[' + this.$instanceDescription + ']';
	}
	
	/**
		{@inheritDoc}
		
		@example
			<code>
				this.myObject.destroy();
				delete this.myObject;
			</code>
	*/
	public function destroy():Void {
		delete this.$instanceDescription;
	}
	
	private function $setClassDescription(description:String):Void {
		this.$instanceDescription = description;
	}
}