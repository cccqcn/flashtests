/**
 * Tomislav Podhraški
 * http://www.justpinegames.com
 */

// River.as custom DisplayObject to represent rivers
// Custom DisplayObject: http://wiki.starling-framework.org/manual/custom_display_objects
	
package
{
    import com.adobe.utils.AGALMiniAssembler;
	import starling.textures.Texture;
    
    import flash.display3D.*;
    import flash.geom.*;
    
    import starling.core.RenderSupport;
    import starling.core.Starling;
    import starling.display.DisplayObject;
    import starling.errors.MissingContextError;
    import starling.events.Event;
    import starling.utils.VertexData;
    
    public class River extends DisplayObject
    {
        private static var PROGRAM_NAME:String = "river";

		private var _vertexCount:int;
		private var _faceCount:int;
		
		private var _thickness:Number;
		
		private var _curve:QuadricBezierCurve;

		private var _textureOffset:Number;
		
		private var _texture:Texture;
		
		private const QUALITY:int = 40;
		
	
        // vertex data 
        private var _vertexData:VertexData;
        private var _vertexBuffer:VertexBuffer3D;
        
        // index data
        private var _indexData:Vector.<uint>;
        private var _indexBuffer:IndexBuffer3D;
        
        // helper objects (to avoid temporary objects)
        private static var sHelperMatrix:Matrix = new Matrix();
        private static var sRenderAlpha:Vector.<Number> = new <Number>[1.0, 1.0, 1.0, 1.0];
        
        public function River()
        {
			_textureOffset = 0;
            _thickness = 30;
            Starling.current.addEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
        }
		
		private function updateShape():void
		{
            // setup vertex data and prepare shaders
            setupVertices();
            createBuffers();
            registerPrograms();
		}
        
        public override function dispose():void
        {
            Starling.current.removeEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
            
            if (_vertexBuffer) _vertexBuffer.dispose();
            if (_indexBuffer) _indexBuffer.dispose();
            
            super.dispose();
        }
        
        private function onContextCreated(event:Event):void
        {
            // the old context was lost, so we create new buffers and shaders.
            createBuffers();
            registerPrograms();
        }
        
        public override function getBounds(targetSpace:DisplayObject, resultRect:Rectangle=null):Rectangle
        {
			if (!_curve)
			{
				return new Rectangle();
			}
			
            if (resultRect == null) resultRect = new Rectangle();
            
            var transformationMatrix:Matrix = targetSpace == this ? 
                null : getTransformationMatrix(targetSpace, sHelperMatrix);
            
            return _vertexData.getBounds(transformationMatrix, 0, -1, resultRect);
        }

		// Calculate normal vector on provided line segment defined with points A and B
		private function lineSegmentNormal(A:Point, B:Point):Point
		{
			// Notice that point components are reversed! (y, x)
            var normal:Point = new Point(B.y - A.y, A.x - B.x);
            normal.normalize(1);
            return normal;
		}
		
		// Generate the actual geometry
        private function setupVertices():void
        {
			var negativePoints:Vector.<Point> = _curve.offsetedCurve(-thickness).convertToPoints(QUALITY);
			var positivePoints:Vector.<Point> = _curve.offsetedCurve(thickness).convertToPoints(QUALITY);
			
			_vertexCount = positivePoints.length * 2; // There are twice as many points for geometry shape as there are for line
			_faceCount = (positivePoints.length - 1) * 2;
			
			
            _vertexData = new VertexData(_vertexCount);
			_vertexData.setUniformColor(0xffffff);
			
			var vertexId:int = 0;
            
			var distancePositive:Number = 0;
			var distanceNegative:Number = 0;
			
			// Iterate through all points
			for (var i:int = 0; i < positivePoints.length; i++) {
				
				if (_texture) 
				{
					if (i > 0)
					{
						distancePositive += (Point.distance(negativePoints[i - 1], negativePoints[i]) + Point.distance(positivePoints[i - 1], positivePoints[i])) / _texture.width / 2;
					}
				}

				// For each point in the curve, generate two points of geometry shape, equaly distanced from original point
				_vertexData.setPosition(i * 2 + 0, negativePoints[i].x, negativePoints[i].y);
				_vertexData.setTexCoords(i * 2 + 0, distancePositive, 0);
				_vertexData.setPosition(i * 2 + 1, positivePoints[i].x, positivePoints[i].y);
				_vertexData.setTexCoords(i * 2 + 1, distancePositive, 1);
			}
			
            _indexData = new Vector.<uint>();
            
            for (var j:int = 0; j < _faceCount; j += 2) {
				// Generate 2 triangles using 4 vertices
                _indexData.push(j + 0, j + 1, j + 2);
                _indexData.push(j + 2, j + 3, j + 1);
			}
        }
        
        private function createBuffers():void
        {
            var context:Context3D = Starling.context;
            if (context == null) throw new MissingContextError();
            
            if (_vertexBuffer) _vertexBuffer.dispose();
            if (_indexBuffer) _indexBuffer.dispose();
            
            _vertexBuffer = context.createVertexBuffer(_vertexData.numVertices, VertexData.ELEMENTS_PER_VERTEX);
            _vertexBuffer.uploadFromVector(_vertexData.rawData, 0, _vertexData.numVertices);
            
            _indexBuffer = context.createIndexBuffer(_indexData.length);
            _indexBuffer.uploadFromVector(_indexData, 0, _indexData.length);
        }
        
        public override function render(support:RenderSupport, alpha:Number):void
        {
			if (!_curve)
			{
				return;
			}
			
            // always call this method when you write custom rendering code!
            // it causes all previously batched quads/images to render.
            support.finishQuadBatch();
            
            sRenderAlpha[0] = sRenderAlpha[1] = sRenderAlpha[2] = 1.0;
            sRenderAlpha[3] = alpha * this.alpha;
            
            var context:Context3D = Starling.context;
            if (context == null) throw new MissingContextError();
            
            // apply the current blendmode
            support.applyBlendMode(false);
            
            // activate program (shader) and set the required buffers / constants 
            context.setProgram(Starling.current.getProgram(shaderProgramName()));
            context.setVertexBufferAt(0, _vertexBuffer, VertexData.POSITION_OFFSET, Context3DVertexBufferFormat.FLOAT_2); 
            context.setVertexBufferAt(1, _vertexBuffer, VertexData.COLOR_OFFSET,    Context3DVertexBufferFormat.FLOAT_4);
            if (_texture) context.setVertexBufferAt(2, _vertexBuffer, VertexData.TEXCOORD_OFFSET,    Context3DVertexBufferFormat.FLOAT_2);
            context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, support.mvpMatrix3D, true);            
            context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, sRenderAlpha, 1);
         
			// Texture offset at index 5
            context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 5, new <Number>[-_textureOffset, 0, 0, 0], 1);
			
			if (_texture) context.setTextureAt(0, _texture.base);
			
            // finally: draw the object!
            context.drawTriangles(_indexBuffer, 0, _faceCount);
            
            // reset buffers
            context.setVertexBufferAt(0, null);
            context.setVertexBufferAt(1, null);
            if (_texture) context.setVertexBufferAt(2, null);
        }
		
		private function shaderProgramName():String
		{
			if (_texture)
			{
				return PROGRAM_NAME + "_textured";
			}
			else 
			{
				return PROGRAM_NAME;
			}
		}
        
        private function registerPrograms():void
        {
            var target:Starling = Starling.current;
            if (target.hasProgram(shaderProgramName())) return; // already registered
            
            // va0 -> position
            // va1 -> color
            // vc0 -> mvpMatrix (4 vectors, vc0 - vc3)
            // vc4 -> alpha
            
            var vertexProgramCode:String =
                "m44 op, va0, vc0 \n" + // 4x4 matrix transform to output space
                "mul v0, va1, vc4 \n";  // multiply color with alpha and pass it to fragment shader
            
            var fragmentProgramCode:String =
                "mov oc, v0";           // just forward incoming color
            
			if (_texture) 
			{
				vertexProgramCode =
                "m44 op, va0, vc0 \n" + // 4x4 matrix transform to output space
                "mul v0, va1, vc4 \n" + // multiply color with alpha and pass it to fragment shader
                "add v1, va2, vc5 \n";  // pass texture coordinates to fragment program
				
				fragmentProgramCode =
                "tex ft1, v1, fs0 <2d, linear, mipnone, repeat> \n" + // sample texture 0
                "mul oc, ft1, v0 \n";   // multiply color with texel color
			}
				
            var vertexProgramAssembler:AGALMiniAssembler = new AGALMiniAssembler();
            vertexProgramAssembler.assemble(Context3DProgramType.VERTEX, vertexProgramCode);
            
            var fragmentProgramAssembler:AGALMiniAssembler = new AGALMiniAssembler();
            fragmentProgramAssembler.assemble(Context3DProgramType.FRAGMENT, fragmentProgramCode);
            
            target.registerProgram(shaderProgramName(), vertexProgramAssembler.agalcode, fragmentProgramAssembler.agalcode);
        }
		
		public function get curve():QuadricBezierCurve
		{
			return _curve;
		}
		
		// When points are replaced, shape will be recalculated and sent to GPU
		public function set curve(curve:QuadricBezierCurve):void 
		{

			_curve = curve;
			
			updateShape();
		}
		
		public function get thickness():Number 
		{
			return _thickness;
		}
		
		// Changing the thickness will trigger shape change
		public function set thickness(value:Number):void 
		{
			_thickness = value;
			updateShape();
		}
		
		public function get texture():Texture 
		{
			return _texture;
		}
		
		public function set texture(value:Texture):void 
		{
			_texture = value;
			updateShape();
		}
		
		public function get textureOffset():Number 
		{
			return _textureOffset;
		}
		
		public function set textureOffset(value:Number):void 
		{
			_textureOffset = value;
		}
		
    }
}