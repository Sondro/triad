import com.ludamix.triad.ui.CascadingText;
import com.ludamix.triad.ui.Rect9;
import com.ludamix.triad.ui.Helpers;
import com.ludamix.triad.ui.HSlider6;
import com.ludamix.triad.ui.SettingsUI;
import com.ludamix.triad.io.ButtonManager;
import nme.Assets;
import nme.text.TextFormatAlign;
import nme.geom.Rectangle;
import nme.Lib;

class CommonStyle
{
	
	public static var rr : Rect9Template;
	public static var rrDown : Rect9Template;
	public static var fielddata : Dynamic;
	public static var formatdata : Dynamic;
	public static var cascade : CascadingTextDef;
	public static var styleUp : LabelRect9Style;
	public static var styleDown : LabelRect9Style;	
	public static var basicButton : LabelButtonStyle;
	public static var settings : SettingsUI;
	public static var slider : ScrollableStyle;
	public static var scrollbar : ScrollableStyle;
	
	public static function init(?buttonmanager : ButtonManager = null, ?sound : String = null)	
	{
		rr = new Rect9Template(Assets.getBitmapData("assets/frame.png"), 8, 8, 32, 32);
		rrDown = new Rect9Template(Assets.getBitmapData("assets/frame2.png"), 8, 8, 32, 32);
		
		fielddata = { text:"Hello World", selectable:false };
		formatdata = { align:TextFormatAlign.CENTER };
		cascade = {field:[fielddata],format:[formatdata]};
		styleUp = {cascade:cascade, rect9 : rr };
		styleDown = {cascade:cascade, rect9 : rrDown };		
		basicButton = { up:styleUp, down:styleDown, over:styleUp, sizing:BSSPad(8, 8) };
		slider = { bitmapdata : Assets.getBitmapData("assets/slider.png"), tile_w : 16, tile_h : 16, 
						drawmode : SliderRepeat };
		scrollbar = { bitmapdata : Assets.getBitmapData("assets/scrollbar.png"), tile_w : 16, tile_h : 16, 
						drawmode : SliderRepeat };
		
		settings = new SettingsUI(new Rectangle(0, 0, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight),
			rr, { up:styleUp, down:styleDown, over:styleUp, sizing:BSSPad(10, 10) }, cascade, 
				{bitmapdata:Assets.getBitmapData("assets/checkbox.png"), tile_w:16, tile_h:16 },
				slider,
				scrollbar,
				sound,buttonmanager);
	}	
	
}