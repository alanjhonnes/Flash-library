package br.com.ajwebdesign.bitmap.perlinnoise.presets {
	import br.com.ajwebdesign.bitmap.BitmapDataChannels;
	import br.com.ajwebdesign.bitmap.perlinnoise.presets.AbstractPreset;
	import flash.display.BlendMode;
	import flash.display.GradientType;
	import flash.display.InterpolationMethod;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Alan Jhonnes
	 */
	public class SkyPreset extends AbstractPreset {
		
		public function SkyPreset() {
			backgroundColor = 0xbde9f9;
			octaves = 2;
			speeds = new <Point>[new Point(0.2, 0.5), new Point(-0.3, 0.2)];
			offsets = [new Point(), new Point()];
			baseX = 60;
			baseY = 50;
			seed = 999;
			stitch = false;
			fractal = false;
			channels = BitmapDataChannels.ALPHA_BLUE;
			grayScale = false;
			animated = true;
			blendMode = BlendMode.MULTIPLY;
			alpha = 0.5;
			
			colors = [0xfafbff, 0x96ccfa, 0x4895db];
			ratios = [0, 76, 255];
			alphas = [1, 1, 1];
			isGradient = true;
			gradientType = GradientType.LINEAR;
			matrix = new Matrix();
			angle = -Math.PI * 0.5;
			
		}
		
	}

}