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

import org.casalib.movieclip.CoreMovieClip;
import org.casalib.state.MovieClipEventHandlerState;
import org.casalib.util.MovieClipUtil;

/**
	Provides state-switching mechanism for MovieClip event handlers and properties.

	@author Toby Boudreaux
	@author David Nelson
	@author Aaron Clinger
	@version 05/13/07
	@example
		<code>
			import org.casalib.util.MovieClipUtil;
			
			MovieClipUtil.attachMovieRegisterClass(org.casalib.movieclip.StatedMovieClip, this, "linkageMovieClip", "stated_mc");
			
			this.stated_mc.onRelease = function():Void {
				trace("onRelease on " + this._name + " was called. Example one.");
			}
			
			this.stated_mc.createState("exampleButtonOne");
			
			this.stated_mc.onRelease = function():Void {
				trace("onRelease on " + this._name + " was called. Example two.");
			}
			
			this.stated_mc.createState("exampleButtonTwo");
		</code>
	
		Now you can switch between the states, example:
		<code>this.stated_mc.switchState("exampleButtonOne");</code> or <code>this.stated_mc.switchState("exampleButtonTwo");</code>
	
		To return to the default creation state call:
		<code>this.stated_mc.switchState("default");</code>
		
		To remove all event handlers call:
		<code>this.stated_mc.switchState("blank");</code>
	@usageNote Class creates <code>"default"</code> and <code>"blank"</code> states during MovieClip instance creation.
*/

class org.casalib.movieclip.StatedMovieClip extends CoreMovieClip {
	private var $states:Object;
	private var $currentState:String;
	
	
	/**
		Creates an empty instance of the StatedMovieClip class. Use this instead of a traditional <code>new</code> constructor statement due to limitations of ActionScript 2.0.
		
		@param target: Location where the MovieClip should be attached.
		@param instanceName: A unique instance name for the MovieClip.
		@param depth: <strong>[optional]</strong> The depth level where the MovieClip is placed; defaults to next highest open depth.
		@param initObject: <strong>[optional]</strong> An object that contains properties with which to populate the newly attached MovieClip.
		@return Returns a reference to the created instance.
		@example <code>var myStated_mc:StatedMovieClip = StatedMovieClip.create(this, "example_mc");</code>
		@usageNote If you want to extend a non empty MovieClip you can either define the ActionScript 2.0 class in the Flash IDE library or use {@link MovieClipUtil#attachMovieRegisterClass}.
		@since Flash Player 7
	*/
	public static function create(target:MovieClip, instanceName:String, depth:Number, initObject:Object):StatedMovieClip {
		return StatedMovieClip(MovieClipUtil.createMovieRegisterClass('org.casalib.movieclip.StatedMovieClip', target, instanceName, depth, initObject));
	}
	
	
	private function StatedMovieClip() {
		super();
		
		this.$states = new Object();
		this.createState('blank', new Array());
		this.createState('default');
		
		this.$setClassDescription('org.casalib.movieclip.StatedMovieClip');
	}
	
	/**
		Returns the current state of MovieClip. If no state has been created {@link #getState} will return <code>"default"</code>.
	
		@return The name of current MovieClip state.
		@usageNote {@link #getState} will always return last created or switched to state.
	*/
	public function getState():String {
		return this.$currentState;
	}
	
	/**
		Switches MovieClip's current state to a precreated state.
	
		@param stateName: Name of precreated MovieClip state.
		@param inclusionList: <strong>[optional]</strong> List of event handlers and properties to include/switch state of. Defaults to all MovieClip event handlers.
		@return Returns <code>true</code> if the precreated state was found and the MovieClip's state was successfully changed; otherwise <code>false</code>.
		@example <code>this.stated_mc.switchState("uniqueStateName", new Array("onEnterFrame", "onRelease"));</code>
		@see {@link #createState}
	*/
	public function switchState(stateName:String, inclusionList:Array):Boolean {
		if (stateName == undefined || this.$states[stateName] == undefined)
			return false;
		
		this.$currentState = stateName;
		
		var keyList:Array = (inclusionList == undefined) ? this.$states[stateName].getValueKeys() : inclusionList;
		var key:String;
		
		for (var i:String in keyList) {
			key = keyList[i];
			this[key] = this.$states[stateName].getValueForKey(key);
		}
		
		return true;
	}
	
	/**
		Creates a new state and records event handlers.
		
		@param stateName: Unique name for MovieClip state.
		@param inclusionList: <strong>[optional]</strong> List of event handlers and properties to include. Defaults to all MovieClip event handlers.
		@usageNote If parameter <code>stateName</code> is identical to previously created state, {@link #createState} will overwrite it.
		@example <code>this.stated_mc.createState("uniqueStateName", new Array("onRollOver", "onRollOut", "onRelease"));</code>
		@see {@link MovieClipEventHandlerState}
	*/
	public function createState(stateName:String, inclusionList:Array):Void {
		if (stateName == undefined)
			return;
		
		this.$currentState = stateName;
		this.$states[stateName] = new MovieClipEventHandlerState();
		
		var keyList:Array = (inclusionList == undefined) ? this.$states[stateName].getValueKeys() : inclusionList;
		var key:String;
		
		for (var i:String in keyList) {
			key = keyList[i];
			this.$states[stateName].setValueForKey(key, this[key]);
		}
	}
	
	/**
		Registers single value to a MovieClip property for a given state.
	
		@param stateName: Name of precreated MovieClip state, or new state.
		@param keyName: Name of any MovieClip property or event handler.
		@param value: Value of MovieClip property or event handler specified by parameter <code>keyName</code>.
		@example 
			<code>
				var anonymousFunction:Function = function():Void {
					trace("onRollOver");
				} 
			
				this.stated_mc.setKeyValueForState("stateName", "onRollOver", anonymousFunction);
			</code>
			
			You can define any MovieClip properties, not just event handlers. Such as <code>_alpha</code>, <code>_x</code>, <code>_yscale</code> etc...:
			<code>this.stated_mc.setKeyValueForState("stateName", "_alpha", 25);</code>
	*/
	public function setKeyValueForState(stateName:String, keyName:String, value:Object):Void {
		if (this.$states[stateName] == undefined)
			this.$states[stateName] = new MovieClipEventHandlerState();
		
		this.$states[stateName].setValueForKey(keyName, value);
	}
	
	/**
		Removes/unregisters value from MovieClip property for a given state.
		
		@param stateName: Name of precreated MovieClip state.
		@param keyName: Name of any MovieClip property or event handler.
		@return Returns <code>true</code> if the key was successfully found and removed from event handler state; otherwise <code>false</code>.
	*/
	public function removeKeyValueForState(stateName:String, keyName:String):Boolean {
		if (this.$states[stateName] == undefined)
			return false;
		
		return this.$states[stateName].removeValueForKey(keyName);
	}
	
	/**
		Deletes precreated MovieClip state.
		
		@param stateName: Name of precreated MovieClip state.
		@return Returns <code>true</code> if the state was successfully found and removed; otherwise <code>false</code>.
	*/
	public function removeState(stateName:String):Boolean {
		if (stateName == undefined || this.$states[stateName] == undefined)
			return false;
		
		delete this.$states[stateName];
		
		return true;
	}
	
	public function destroy():Void {
		delete this.$states;
		delete this.$currentState;
		
		super.destroy();
	}
}
