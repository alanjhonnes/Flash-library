package br.com.ajwebdesign.bitmap.perlinnoise.presets {
	import br.com.ajwebdesign.bitmap.BitmapDataChannels;
	import br.com.ajwebdesign.bitmap.perlinnoise.presets.AbstractPreset;
	import flash.display.BlendMode;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Alan Jhonnes
	 */
	public class WindPreset extends AbstractPreset {
		
		public function WindPreset() {
			backgroundColor = 0xbde9f9;
			octaves = 3;
			speeds = new <Point>[new Point(0.2, 0.5), new Point(-0.3, 0.2), new Point(0.2, -0.4)];
			offsets = [new Point(), new Point(), new Point()];
			baseX = 100;
			baseY = 50;
			seed = 999;
			stitch = false;
			fractal = false;
			channels = BitmapDataChannels.ALPHA_BLUE;
			grayScale = true;
			animated = true;
			blendMode = BlendMode.SUBTRACT;
			alpha = 0.9;
		}
		
	}

}