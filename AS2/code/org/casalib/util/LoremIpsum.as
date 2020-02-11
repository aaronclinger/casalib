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

import org.casalib.util.NumberUtil;
import org.casalib.util.StringUtil;

/**
	@author David Nelson
	@author Aaron Clinger
	@version 02/12/07
*/

class org.casalib.util.LoremIpsum {
	private static var $words:Array = new Array('lorem', 'ipsum', 'dolor', 'sit', 'amet', 'consectetuer', 'adipiscing', 'elit', 'nam', 'imperdiet', 'dignissim', 'erat', 'mauris', 'ut', 'pellentesque', 'habitant', 'morbi', 'tristique', 'senectus', 'et', 'netus', 'malesuada', 'fames', 'ac', 'turpis', 'egestas', 'phasellus', 'sem', 'metus', 'lacinia', 'facilisis', 'at', 'sagittis', 'vel', 'felis', 'aenean', 'bibendum', 'in', 'enim', 'nulla', 'sed', 'ante', 'scelerisque', 'aliquet', 'facilisi', 'aliquam', 'velit', 'vitae', 'tellus', 'massa', 'etiam', 'hendrerit', 'rutrum', 'orci', 'nibh', 'fringilla', 'posuere', 'mi', 'praesent', 'interdum', 'risus', 'arcu', 'donec', 'auctor', 'dui', 'tempus', 'nec', 'id', 'laoreet', 'blandit', 'ligula', 'eu', 'dapibus', 'tincidunt', 'nunc', 'lectus', 'integer', 'curabitur', 'a', 'ultricies', 'quis', 'suscipit', 'eleifend', 'augue', 'congue', 'eros', 'non', 'sapien', 'neque', 'vestibulum', 'nonummy', 'leo', 'ornare', 'vehicula', 'eget', 'tempor', 'magna', 'suspendisse', 'placerat', 'mattis', 'luctus', 'lacus', 'duis', 'venenatis', 'porta', 'urna', 'vivamus', 'nisl', 'proin', 'sollicitudin', 'pulvinar', 'quam', 'maecenas', 'lobortis', 'pharetra', 'purus', 'pretium', 'mollis', 'cum', 'sociis', 'natoque', 'penatibus', 'magnis', 'dis', 'parturient', 'montes', 'nascetur', 'ridiculus', 'mus', 'fusce', 'est', 'ultrices', 'feugiat', 'iaculis', 'nisi', 'sodales', 'vulputate', 'tortor', 'accumsan', 'commodo', 'faucibus', 'justo', 'volutpat', 'porttitor', 'gravida', 'nullam', 'molestie', 'condimentum', 'euismod', 'elementum', 'odio');
	
	
	/**
		Creates a defined amount of placeholder words.
		
		@amount The amount of words.
		@return Returns a string comprised of randomized dummy text.
	*/
	public static function generateWords(amount:Number):String {
		var l:Number = LoremIpsum.$words.length;
		var r:String = StringUtil.toTitleCase(LoremIpsum.$words[NumberUtil.randomInteger(0, l)]);
		
		amount--;
		
		while (amount--)
			r += ' ' + LoremIpsum.$words[NumberUtil.randomInteger(0, l)];
		
		return r;
	}
	
	/**
		Creates a defined amount of placeholder sentences. Sentence length varies between four and ten words.
		
		@amount The amount of sentences.
		@return Returns a string comprised of randomized dummy text.
	*/
	public static function generateSentences(amount:Number):String {
		var r:String = '';
		
		while (amount--)
			r += LoremIpsum.generateWords(NumberUtil.randomInteger(4, 10)) + '. ';
		
		return r.slice(0, -1);
	}
	
	/**
		Creates a defined amount of placeholder paragraphs. Paragraph length varies between four and fifteen sentences.
		
		@amount The amount of paragraphs.
		@return Returns a string comprised of randomized dummy text.
	*/
	public static function generateParagraphs(amount:Number):String {
		var t:String = '';
		
		while (amount--)
			t += LoremIpsum.generateSentences(NumberUtil.randomInteger(4, 15)) + '\r\r';
		
		return t;
	}
	
	private function LoremIpsum() {} // Prevents instance creation
}