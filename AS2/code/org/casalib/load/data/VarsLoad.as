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

import org.casalib.load.base.DataLoad;

/**
	Creates an easy way to load or send and load variables.
	
	@author Aaron Clinger
	@version 07/17/07
	@since Flash Player 7
	@example
		To load data:
		<code>
			function onVarsLoad(sender:VarsLoad):Void {
				trace(this.myVarsLoad.getValue("name"));
			}
			
			var myVarsLoad:VarsLoad = new VarsLoad("http://example.com/getData.php");
			myVarsLoad.addEventObserver(this, VarsLoad.EVENT_LOAD_COMPLETE, "onVarsLoad");
			myVarsLoad.start();
		</code>
		
		To send and load data:
		<code>
			function onVarsLoad(sender:VarsLoad):Void {
				trace(this.myVarsLoad.getValue("city"));
			}
			
			var myVarsLoad:VarsLoad = new VarsLoad("http://example.com/getData.php");
			myVarsLoad.addEventObserver(this, VarsLoad.EVENT_LOAD_COMPLETE, "onVarsLoad");
			myVarsLoad.setValue("zip", "94109");
			myVarsLoad.setValue("state", "CA");
			myVarsLoad.start();
		</code>
*/

class org.casalib.load.data.VarsLoad extends DataLoad {
	private var $target:LoadVars;
	private var $receive:LoadVars;
	
	
	/**
		Defines file and location of load triggered by {@link Load#start start}.
		
		@param path: The absolute or relative URL of the variables to be loaded.
		@param method: <strong>[optional]</strong> Defines the method of the HTTP protocol, either <code>"GET"</code> of <code>"POST"</code>; defaults to <code>"POST"</code>.
	*/
	public function VarsLoad(path:String, method:String) {
		super(path, method);
		
		this.$target  = new LoadVars();
		this.$receive = new LoadVars();
		
		this.$setClassDescription('org.casalib.load.data.VarsLoad');
	}
	
	/**
		Sets a name-value pair to send to the server side script.
		
		@param name: The name of the variable.
		@param value: The value of the variable.
	*/
	public function setValue(name:String, value:String):Void {
		this.$target[name]  = value;
		this.$passingValues = true;
	}
	
	/**
		Gets the value of a name-value pair defined by loaded variables, if any; or defined by {@link #setValue}.
		
		@param name: The name of the variable.
		@return The value of the variable.
	*/
	public function getValue(name:String):String {
		return (this.$receive[name] != undefined) ? this.$receive[name] : this.$target[name];
	}
	
	/**
		Gets the LoadVars object defined by the loaded variables, if loaded; or the the LoadVars object populated by {@link #setValue}, if not loaded.
		
		@return Returns the LoadVars object.
	*/
	public function getLoadVars():LoadVars {
		return (this.$receive.loaded) ? this.$receive : this.$target;
	}
	
	private function $onData(src:String):Void {
		if (src != undefined) {
			if (this.$passingValues)
				this.$receive.decode(src);
			else
				this.$target.decode(src);
		}
		
		super.$onData(src);
	}
}