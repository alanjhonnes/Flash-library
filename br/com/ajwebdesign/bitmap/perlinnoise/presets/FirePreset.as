package br.com.ajwebdesign.bitmap.perlinnoise.presets {
	import br.com.ajwebdesign.bitmap.BitmapDataChannels;
	import br.com.ajwebdesign.bitmap.perlinnoise.presets.AbstractPreset;
	import flash.display.BlendMode;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Alan Jhonnes
	 */
	public class FirePreset extends AbstractPreset {
		
		public function FirePreset() {
			backgroundColor = 0xff3a2b;
			octaves = 3;
			speeds = new <Point>[new Point(4, 3), new Point(-2, 4), new Point(1, -5)];
			offsets = [new Point(), new Point(), new Point()];
			baseX = 64;
			baseY = 141;
			seed = 999;
			stitch = false;
			fractal = false;
			channels = BitmapDataChannels.ALPHA_RED;
			grayScale = true;
			animated = true;
			blendMode = BlendMode.SUBTRACT;
			alpha = 0.9;
			/*
			filters.push(new ColorMatrixFilter( [4,0,0,0,-400,
												4,0,0,0,-400,
												4,0,0,0,-400,
												0,0,0,1,0] ));
			*/
			isGradient = true;
			colors = [0xffffcc, 0xd25300, 0x8e0e00, 0x000000];
			alphas = [1, 1, 1, 1];
			ratios = [0, 90, 180, 255];
			matrix = new Matrix();
			angle = -Math.PI * 0.5;
		}
		
	}

}