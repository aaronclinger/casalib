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
	Event interface which all objects that use {@link EventDispatcher} should adhere to.

	@author Aaron Clinger
	@version 02/06/07
*/

interface org.casalib.event.DispatchableInterface extends CoreInterface {
	
	/**
		Reports event to all subscribed objects.
		
		@param eventName: Event name.
		@param param(s): <strong>[optional]</strong> Parameters passed to the function specified by "eventName". Multiple parameters are allowed and should be separated by commas: param1,param2, ...,paramN
		@return Returns <code>true</code> if observer(s) listening to specifed event were found; otherwise <code>false</code>.
	*/
	public function dispatchEvent(eventName:String):Boolean;
	
	/**
		Registers a function to receive notification when a event handler is invoked.
		
		@param scope: The target or object in which to subscribe.
		@param eventName: Event name to subscribe to.
		@param eventHandler: <strong>[optional]</strong> Name of function to recieve the event. If undefined class assumes <code>eventHandler</code> matches <code>eventName</code>.
		@return Returns <code>true</code> if the observer was established successfully; otherwise <code>false</code>.
	*/
	public function addEventObserver(scope:Object, eventName:String, eventHandler:String):Boolean;
	
	/**
		Removes specific observer for event.
		
		@param scope: The target or object in which subscribed.
		@param eventName: Event name to unsubscribe to.
		@param eventHandler: <strong>[optional]</strong> Name of function that recieved the event. If undefined class assumes <code>eventHandler</code> matched <code>eventName</code>.
		@return Returns <code>true</code> if the observer was successfully found and removed; otherwise <code>false</code>.
	*/
	public function removeEventObserver(scope:Object, eventName:String, eventHandler:String):Boolean;
	
	/**
		Removes all observers for a specified event.
		
		@param eventName: Event name to unsubscribe to.
		@return Returns <code>true</code> if observers were successfully found for specified <code>eventName</code> and removed; otherwise <code>false</code>.
	*/
	public function removeEventObserversForEvent(eventName:String):Boolean;
	
	/**
		Removes all observers in a specified scope.
		
		@param scope: The target or object in which to unsubscribe.
		@return Returns <code>true</code> if observers were successfully found in <code>scope</code> and removed; otherwise <code>false</code>.
	*/
	public function removeEventObserversForScope(scope:Object):Boolean;
	
	/**
		Removes all observers regardless of scope or event.
		
		@return Returns <code>true</code> if observers were successfully removed; otherwise <code>false</code>.
	*/
	public function removeAllEventObservers():Boolean;
}