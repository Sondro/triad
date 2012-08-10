package com.ludamix.triad.tools;

typedef IInt = #if neko Int #elseif cpp Int #else UInt #end;

class StringTools
{
	
	public static function parseHex(hexstr : String) : IInt
	{
		var remain = hexstr.substr(2).toUpperCase();
		var set : IInt = 0;
		for (idx in 0...remain.length)
		{
			var chr = remain.charAt((remain.length - 1) - idx);
			switch(chr)
			{
				case '0': {}
				case '1': { set += (1 << (idx * 4)); }
				case '2': { set += (2 << (idx * 4)); }
				case '3': { set += (3 << (idx * 4)); }
				case '4': { set += (4 << (idx * 4)); }
				case '5': { set += (5 << (idx * 4)); }
				case '6': { set += (6 << (idx * 4)); }
				case '7': { set += (7 << (idx * 4)); }
				case '8': { set += (8 << (idx * 4)); }
				case '9': { set += (9 << (idx * 4)); }
				case 'A': { set += (10 << (idx * 4)); }
				case 'B': { set += (11 << (idx * 4)); }
				case 'C': { set += (12 << (idx * 4)); }
				case 'D': { set += (13 << (idx * 4)); }
				case 'E': { set += (14 << (idx * 4)); }
				case 'F': { set += (15 << (idx * 4)); }
			}
		}
		return set;
	}
	
	public static function parseIntFloatString(value : String) : Dynamic
	{
		if (value.length == 0) return value;
		
		// number?
		var before_deci : String = ""; 
		var after_deci : String = "";
		var decimal : Bool = false;
		var ok : Bool = true;
		for (idx in 0...value.length)
		{
			switch(value.charAt(idx))
			{
				case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9": 
					if (decimal) after_deci += value.charAt(idx);
					else before_deci += value.charAt(idx);
				case ".": if (decimal) { ok = false;  break; } else { decimal = true; }
				default:
					ok = false;  break;
			}
		}
		if (ok) { if (decimal) return Std.parseFloat(value); else return Std.parseInt(value); }
		
		// string...
		return value;		
	}
	
	public static function parseBits(inp : String)
	{
		// parses a string of digits 000100100... with LSB at right-hand side.
		var msb = inp.length;
		var result = 0;
		for (n in 0...inp.length)
		{
			var shl = msb - n;
			if (inp.charAt(n) == "1") result += (1 << shl);
		}
		return result;
	}
	
	public static function cleanASCII(i : String)
	{
		// returns the string, with non-textual data cut (good for e.g. binary files with fixlen strings)
		var out = "";
		for (n in 0...i.length)
		{
			var cc = i.charCodeAt(n);
			if (cc >= 32 && cc < 127)
				out += String.fromCharCode(cc);
		}
		return out;
	}
	
}