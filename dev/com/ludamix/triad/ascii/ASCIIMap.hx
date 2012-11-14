package com.ludamix.triad.ascii;

import com.ludamix.triad.grid.IntGrid;
import com.ludamix.triad.tools.Color;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.geom.ColorTransform;
import nme.geom.Matrix;
import nme.geom.Point;

class ASCIIMap extends Bitmap
{
	
	// Custom renderer for "ASCII-like" character graphics
	// Important note: Sheet index 0(char 0, bg 0, fg 0) is _transparent_. 
	
	public var sheet : ASCIISheet;
	public var char : IntGrid;
	private var swap : IntGrid;
	
	public function new(sheet : ASCIISheet, mapwidth : Int, mapheight : Int)
	{
		var vwidth = sheet.twidth * mapwidth;
		var vheight = sheet.theight * mapheight;
		
		super(new BitmapData(vwidth, vheight, false, Color.ARGB(0xFF00FF,0xFF)));
		
		this.sheet = sheet;
		
		var ar = new Array<Int>(); for (n in 0...mapwidth * mapheight) { ar.push(0); }
		var ar2 = new Array<Int>(); for (n in 0...mapwidth * mapheight) { ar.push(-1); }
		
		char = new IntGrid(mapwidth, mapheight, sheet.twidth, sheet.theight, ar);
		swap = new IntGrid(mapwidth, mapheight, sheet.twidth, sheet.theight, ar2);
		
	}
	
	public function update()
	{
		bitmapData.lock();
		var pt2 = new Point(0., 0.);
		var pt = new Point(0., 0.);		
		for (n in 0...char.world.length)
		{
			if (char.world[n] != swap.world[n])
			{
				var dec = decode(char.world[n]);
				var tinfos = sheet.chars[dec.fg][dec.bg][dec.char];
				bitmapData.copyPixels(tinfos.bd, tinfos.rect, pt, tinfos.bd, pt2, false);
			}
			pt.x += sheet.twidth; if (pt.x >= this.bitmapData.width) { pt.x = 0; pt.y += sheet.theight; }
		}
		bitmapData.unlock();		
		swap.world = char.world.copy();
	}
	
	public static inline function encode(bg_color : Int, fg_color : Int, char : Int)
	{
		return Color.buildRGB(bg_color, fg_color, char);
	}	
	
	public static inline function decode(packed : Int)
	{
		return { bg:Color.RGBred(packed), fg:Color.RGBgreen(packed), char:Color.RGBblue(packed) };		
	}
	
	public function text(string : String, x : Int, y : Int, ?fg_color = -1, ?bg_color = -1)
	{
		spriteMono(string, string.length, x, y, fg_color, bg_color);
	}
	
	public function squareMono(char : String, width : Int, height : Int, x : Int, y : Int, ?fg_color = -1, ?bg_color = -1)
	{
		var string = "";
		for (n in 0...width * height)
			string += char;
		var fg_colors = new Array<Int>();
		var bg_colors = new Array<Int>();
		for (n in 0...string.length) { fg_colors.push(fg_color); bg_colors.push(bg_color); }
		spriteMulti(string, width, x, y, fg_colors, bg_colors);
	}
	
	public function spriteMono(string : String, width : Int, x : Int, y : Int, ?fg_color = -1, ?bg_color = -1)
	{
		var fg_colors = new Array<Int>();
		var bg_colors = new Array<Int>();
		for (n in 0...string.length) { fg_colors.push(fg_color); bg_colors.push(bg_color); }
		spriteMulti(string, width, x, y, fg_colors, bg_colors);
	}
	
	public function recolorMono(width : Int, height, x : Int, y : Int, ?fg_color = -1, ?bg_color = -1)
	{
		var fg_colors = new Array<Int>();
		var bg_colors = new Array<Int>();
		var len = width * height;
		for (n in 0...len) { fg_colors.push(fg_color); bg_colors.push(bg_color); }
		recolor(width, height, x, y, fg_colors, bg_colors);
	}
	
	public function spriteMulti(string : String, width : Int, x : Int, y : Int, 
		fg_colors : Array<Int>, bg_colors : Array<Int>)
	{
		var xpos = 0;
		var ypos = 0;
		for (n in 0...string.length)
		{
			var pos = char.c21(x + xpos, y + ypos);
			var bg = bg_colors[n];
			var fg = fg_colors[n];
			var cur = decode(char.world[pos]);
			if (bg < 0) bg = cur.bg;
			if (fg < 0) fg = cur.fg;
			char.world[pos] = encode(bg,fg,string.charCodeAt(n));
			xpos += 1;
			if (xpos >= width) { xpos = 0; ypos++; }
		}
	}
	
	public function recolor(width : Int, height : Int, x : Int, y : Int, 
		fg_colors : Array<Int>, bg_colors : Array<Int>)
	{
		var xpos = 0;
		var ypos = 0;
		var len = width * height;
		for (n in 0...len)
		{
			var pos = char.c21(x + xpos, y + ypos);
			var bg = bg_colors[n];
			var fg = fg_colors[n];
			var cur = decode(char.world[pos]);
			if (bg < 0) bg = cur.bg;
			if (fg < 0) fg = cur.fg;
			char.world[pos] = encode(bg,fg,cur.char);
			xpos += 1;
			if (xpos >= width) { xpos = 0; ypos++; }
		}
	}
	
	public function blit(chars : Array<Int>)
	{
		for (n in 0...chars.length)
		{
			char.world[n] = chars[n];
		}
	}

}