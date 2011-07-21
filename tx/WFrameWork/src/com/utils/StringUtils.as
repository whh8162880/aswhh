package com.utils
{
	
	public class StringUtils
	{

		public static var NEWLINE_TOKENS : Array = new Array (
			'\n',
			'\r'
		);
		
		public static var WHITESPACE_TOKENS : Array = new Array (
			' ',
			'\t'
		);
		

		 /**
		 * Counts the occurrences of needle in haystack. <br />
		 * {@code trace (StringUtils.count ('hello world!', 'o')); // 2
		 * }
		 * @param haystack :String
		 * @param needle :String
		 * @param offset :Number (optional)
		 * @param length :Number (optional)
		 * @return The number of times the needle substring occurs in the
		 * haystack string. Please note that needle is case sensitive.
		 */
		public static function count ( haystack : String, needle : String, offset : Number = 0, length : Number = 0 ) : Number
		{
			if ( length === 0 )
				 length = haystack.length
			var result : Number = 0;
			haystack = haystack.slice( offset, length );
			while ( haystack.length > 0 && haystack.indexOf( needle ) != -1 )
			{
				haystack = haystack.slice( ( haystack.indexOf( needle ) + needle.length ) );
				result++;
			}
			return result;
		}
		
		
		/**
		 * Strip whitespace and newline (or other) from the beginning and end of a string. <br />
		 * {@code trace (StringUtils.trim ('hello world! ')); // hello world!
		 * }
		 * @param str :String
		 * @param charList :Array (optional)
		 * @return A string with whitespace stripped from the beginning and end
		 * of str. Without the second parameter, trim() will strip characters that
		 * defined in WHITESPACE_TOKENS and NEWLINE_TOKENS array.
		 */
		public static function trim ( str : String, charList : Array = null ) : String
		{
			var list : Array;
			if ( charList )
			{
				list = charList;
			}
			else
			{
				list = WHITESPACE_TOKENS.concat( NEWLINE_TOKENS );
			}
			str = trimLeft( str, list );
			str = trimRight( str, list );
			return str;
		}
		
		/**
		 * Does the same how trim method, but only on left-side. <br />
		 * {@code trace (StringUtils.trimLeft ('hello world!')); // hello world!
		 * }
		 * @param str :String
		 * @param charList :Array (optional)
		 * @return A string with whitespace stripped from the start of str.
		 * Without the second parameter, trimLeft() will strip haracters of
		 * WHITESPACE_TOKENS + NEWLINE_TOKENS.
		 */
		public static function trimLeft ( str : String, charList : Array = null ) : String
		{
			var list:Array;
			if ( charList )
				 list = charList;
			else
				 list = WHITESPACE_TOKENS.concat( NEWLINE_TOKENS );
			
			while ( list.toString().indexOf ( str.substr ( 0, 1 ) ) > -1 && str.length > 0 )
			{
				str = str.substr ( 1 );
			}
			return str;
		}
		
		/**
		 * Does the same how trim method, but only on right-side. <br />
		 * {@code trace (StringUtils.trimRight ('hello world!')); // hello world!
		 * }
		 * @param str :String
		 * @param charList :Array (optional)
		 * @return A string with whitespace stripped from the end of str.
		 * Without the second parameter, trimRight() will strip haracters of
		 * WHITESPACE_TOKENS + NEWLINE_TOKENS.
		 */
		public static function trimRight ( str:String, charList : Array = null ) : String
		{
			var list : Array;
			if ( charList )
				 list = charList;
			else
				 list = WHITESPACE_TOKENS.concat( NEWLINE_TOKENS );
			
			while ( list.toString().indexOf ( str.substr ( str.length - 1 ) ) > -1 && str.length > 0)
			{
				str = str.substr ( 0, str.length - 1 );
			}
			return str;
		}
		
		/**
		 *  Substitutes "{n}" tokens within the specified string
		 *  with the respective arguments passed in.
		 *
		 *  @param str The string to make substitutions in.
		 *  This string can contain special tokens of the form
		 *  <code>{n}</code>, where <code>n</code> is a zero based index,
		 *  that will be replaced with the additional parameters
		 *  found at that index if specified.
		 *
		 *  @param rest Additional parameters that can be substituted
		 *  in the <code>str</code> parameter at each <code>{n}</code>
		 *  location, where <code>n</code> is an integer (zero based)
		 *  index value into the array of values specified.
		 *  If the first parameter is an array this array will be used as
		 *  a parameter list.
		 *  This allows reuse of this routine in other methods that want to
		 *  use the ... rest signature.
		 *  For example <pre>
		 *     public function myTracer(str:String, ... rest):void
		 *     { 
		 *         label.text += StringUtil.substitute(str, rest) + "\n";
		 *     } </pre>
		 *
		 *  @return New string with all of the <code>{n}</code> tokens
		 *  replaced with the respective arguments specified.
		 *
		 *  @example
		 *
		 *  var str:String = "here is some info '{0}' and {1}";
		 *  trace(StringUtil.substitute(str, 15.4, true));
		 *
		 *  // this will output the following string:
		 *  // "here is some info '15.4' and true"
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function substitute(str:String, ... rest):String
		{
			if (str == null) return '';
			
			// Replace all of the parameters in the msg string.
			var len:uint = rest.length;
			var args:Array;
			if (len == 1 && rest[0] is Array)
			{
				args = rest[0] as Array;
				len = args.length;
			}
			else
			{
				args = rest;
			}
			
			for (var i:int = 0; i < len; i++)
			{
				str = str.replace(new RegExp("\\{"+i+"\\}", "g"), args[i]);
			}
			
			return str;
		}

	}
}