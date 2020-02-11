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

import org.casalib.xml.CoreXml;
import org.casalib.load.base.DataLoad;

/**
	Creates an easy way to load or send and load XML.
	
	@author Aaron Clinger
	@version 04/10/08
	@since Flash Player 7
	@example
		To load data:
		<code>
			function onXmlLoad(sender:XmlLoad):Void {
				trace(this.myXmlLoad.getXml().firstChild);
			}
			
			var myXmlLoad:XmlLoad = new XmlLoad("http://example.com/data.xml");
			myXmlLoad.addEventObserver(this, XmlLoad.EVENT_LOAD_COMPLETE, "onXmlLoad");
			myXmlLoad.start();
		</code>
		
		To send and load data:
		<code>
			function onXmlLoad(sender:XmlLoad):Void {
				trace(this.myXmlLoad.getXml().firstChild);
			}
			
			var myXmlSend:CoreXml = new CoreXml("<login><info user=\"CASA\" password=\"fr@m3w0rk\" /></login>");
			
			var myXmlLoad:XmlLoad = new XmlLoad("http://example.com/login.php");
			myXmlLoad.addEventObserver(this, XmlLoad.EVENT_LOAD_COMPLETE, "onXmlLoad");
			myXmlLoad.setXml(this.myXmlSend);
			myXmlLoad.start();
		</code>
		
		To extend the XmlLoad class to parse and send <code>"onParsed"</code> event:
		<code>
			import org.casalib.load.data.xml.XmlLoad;
			import org.casalib.xml.CoreXml;
			
			class com.package.MyClass extends XmlLoad {
				
				public function MyClass(xmlPath:String) {
					super(xmlPath);
				}
				
				public function parse():Void {
					var myXml:CoreXml = this.getXml();
					
					for (var i:String in myXml.firstChild.childNodes) {
						// etc...
					}
					
					this.$parsed(); // Dispataches "onParsed" event
				}
			}
		</code>
	@usageNote Class must be extended to trigger/send <code>"onParsed"</code> event.
	@see {@link CoreXml}
*/

class org.casalib.load.data.xml.XmlLoad extends DataLoad {
	public static var EVENT_PARSING:String     = 'onParsing';
	public static var EVENT_PARSE_ERROR:String = 'onParseError';
	public static var EVENT_PARSED:String      = 'onParsed';
	private var $target:CoreXml;
	private var $receive:CoreXml;
	
	
	/**
		Defines file and location of load triggered by {@link Load#start start}.
		
		@param path: The absolute or relative URL of the XML to be loaded.
	*/
	public function XmlLoad(xmlPath:String) {
		super(xmlPath, null);
		
		this.$target  = new CoreXml();
		this.$receive = new CoreXml();
		
		this.$setClassDescription('org.casalib.load.data.xml.XmlLoad');
	}
	
	/**
		Sets XML to be sent to the server along with the XML request.
		
		@param xml: The XML object to send.
	*/
	public function setXml(xml:CoreXml):Void {
		this.$target        = xml;
		this.$passingValues = true;
	}
	
	/**
		Gets the XML object defined by the loaded XML, if loaded; or the the XML object defined by {@link #setXml}, if not loaded.
		
		@return Returns the XML object.
	*/
	public function getXml():CoreXml {
		return (this.$receive.loaded) ? this.$receive : this.$target;
	}
	
	/**
		<strong>This function needs to be overwritten by a subclass.</strong>
		
		@usageNote After the subclass file is done parsing call <code>private function $parsed()</code> in order to broadcast the 'onParsed' event to listeners.
	*/
	public function parse():Void {}
	
	public function destroy():Void {
		this.$target.destroy();
		this.$receive.destroy();
		
		super.destroy();
	}
	
	private function $onData(src:String):Void {
		if (src != undefined) {
			if (this.$passingValues)
				this.$receive.parseXML(src);
			else
				this.$target.parseXML(src);
		}
		
		super.$onData(src);
	}
	
	/**
		@sends onParsing = function(sender_xml:XmlLoad) {}
		@sends onParseError = function(sender_xml:XmlLoad, errorStatus:Number) {}
	*/
	private function $onComplete():Void {
		super.$onComplete();
		
		if (this.$target.status == 0) {
			this.dispatchEvent(XmlLoad.EVENT_PARSING, this);
			this.parse();
		} else
			this.dispatchEvent(XmlLoad.EVENT_PARSE_ERROR, this, this.$target.status);
	}
	
	/**
		@sends onParsed = function(sender_xml:XmlLoad) {}
	*/
	private function $parsed():Void {
		this.dispatchEvent(XmlLoad.EVENT_PARSED, this);
	}
}