package br.com.ajwebdesign.bitmap.perlinnoise.presets {
	import br.com.ajwebdesign.bitmap.BitmapDataChannels;
	import br.com.ajwebdesign.bitmap.perlinnoise.presets.AbstractPreset;
	import flash.display.BlendMode;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Alan Jhonnes
	 */
	public class BloodPreset extends AbstractPreset {
		
		public function BloodPreset() {
			backgroundColor = 0xff3a2b;
			octaves = 3;
			speeds = new <Point>[new Point(0.2, 0.5), new Point(-0.3, 0.2), new Point(0.2, -0.4)];
			offsets = [new Point(), new Point(), new Point()];
			baseX = 64;
			baseY = 141;
			seed = 999;
			stitch = false;
			fractal = false;
			channels = BitmapDataChannels.ALPHA_RED;
			grayScale = false;
			animated = true;
			blendMode = BlendMode.SUBTRACT;
			alpha = 0.9;
			filters.push(new ColorMatrixFilter( [4,0,0,0,-400,
												4,0,0,0,-400,
												4,0,0,0,-400,
												0,0,0,1,0] ));
			
		}
		
	}

}