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

import org.casalib.time.Chain;

/**
	Creates a sequence of methods calls at defined times.
	
	@author Aaron Clinger
	@version 09/12/07
	@example
		<code>
			function hideBox():Void {
				this.box_mc._visible = false;
			}
			
			function showBox():Void {
				this.box_mc._visible = true;
			}
			
			var seq:Sequence = new Sequence(true);
			seq.addTask(this, "hideBox", 3000);
			seq.addTask(this, "showBox", 1000);
			seq.start();
		</code>
*/

class org.casalib.time.Sequence extends Chain {
	
	
	/**
		Creates a new sequence.
		
		@param isLooping: <strong>[optional]</strong> Indicates the sequence replays once completed <code>true</code>, or stops <code>false</code>; defaults to <code>false</code>.
	*/
	public function Sequence(isLooping:Boolean) {
		super(isLooping);
		
		this.$setClassDescription('org.casalib.time.Sequence');
	}
	
	/**
		Adds a method call to the sequence.
		
		@param scope: An object that contains the method specified by "methodName".
		@param methodName: A method that exists in the scope of the object specified by "scope".
		@param delay: The time in milliseconds after the previous call or from the start.
		@param position: <strong>[optional]</strong> Specifies the index of the insertion in the sequence order; defaults to the next position.
	*/
	public function addTask(scope:Object, methodName:String, delay:Number, position:Number):Void {
		this.$createNewTask(scope, methodName, null, delay, position);
	}
	
	private function $triggerEvent():Void {
		super.$triggerEvent();
		this.$startDelay();
	}
	
	private function $addObserverForSequenceItem(position:Number):Void {}
	
	private function $removeObserversForSequenceItem(position:Number):Void {}
}