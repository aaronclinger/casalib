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

import org.casalib.xml.DispatchableXml;

/**
	Dispatches XML event handler notification using {@link EventDispatcher}.
	
	@author Aaron Clinger
	@author Mike Creighton
	@version 04/03/07
	@example
		<code>
			import org.casalib.xml.EventXml;
			
			function onXmlLoad(sender:EventXml, success:Boolean, status:Number):Void {
				if (success) {
					trace("Xml loaded: " + sender);
				} else {
					trace("Xml error: " + status);
				}
			}
			
			var myXml:EventXml = new EventXml();
			this.myXml.addEventObserver(this, EventXml.EVENT_LOAD, "onXmlLoad");
			this.myXml.load("example.xml");
		</code>
*/

class org.casalib.xml.EventXml extends DispatchableXml {
	public static var EVENT_LOAD:String        = 'onLoad';
	public static var EVENT_DATA:String        = 'onData';
	public static var EVENT_HTTP_STATUS:String = 'onHttpStatus';
	
	
	/**
		@param text: The XML text parsed to create the new XML object.
	*/
	public function EventXml(text:String) {
		super(text);
		
		this.$setClassDescription('org.casalib.xml.EventXml');
	}
	
	/**
		@exclude
		@sends onData = function(sender:EventXml, src:String) {}
	*/
	public function onData(src:String) {
		super.onData(src);
		this.dispatchEvent(EventXml.EVENT_DATA, this, src);
	}
	
	/**
		@exclude
		@sends onHttpStatus = function(sender:EventXml, httpStatus:Number) {}
	*/
	public function onHTTPStatus(httpStatus:Number) {
		super.onHTTPStatus(httpStatus);
		this.dispatchEvent(EventXml.EVENT_HTTP_STATUS, this, httpStatus);
	}
	
	/**
		@exclude
		@sends onLoad = function(sender:EventXml, success:Boolean, status:Number) {}
	*/
	public function onLoad(success:Boolean) {
		super.onLoad(success);
		this.dispatchEvent(EventXml.EVENT_LOAD, this, success, this.status);
	}
}