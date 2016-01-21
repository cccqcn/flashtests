/*
** ADOBE SYSTEMS INCORPORATED
** Copyright 2012 Adobe Systems Incorporated
** All Rights Reserved.
**
** NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the
** terms of the Adobe license agreement accompanying it.  If you have received this file from a
** source other than Adobe, then your use, modification, or distribution of it requires the prior
** written permission of Adobe.
*/
package
{
  import Box2D.Collision.Shapes.b2PolygonShape;
  import Box2D.Common.Math.b2Vec2;
  import Box2D.Dynamics.b2Body;
  import Box2D.Dynamics.b2BodyDef;
  import Box2D.Dynamics.b2FixtureDef;
  import Box2D.Dynamics.b2World;
  
  import flash.display.Sprite;
  import flash.display.Stage;
  import flash.geom.Matrix;

  public class Box2DSprite extends Sprite
  {
    private var bodyDef:b2BodyDef
    private var bodyDefPos:b2Vec2
    private var body:b2Body
    private var dynamicBox:b2PolygonShape
    private var fixtureDef:b2FixtureDef
    private var w:Number, h:Number;

    public function Box2DSprite(_x:Number, _y:Number, _w:Number, _h:Number, world:b2World)
    {
		trace(_x, _y, _w, _h);
      w = _w;
      h = _h;

      graphics.lineStyle(0.25,0x000000);
      graphics.beginFill(0, 0.2);
      graphics.drawRect(0, 0, _w, _h);
      graphics.endFill();

      // Define the dynamic body. We set its position and call the body factory.
      bodyDef = new b2BodyDef();
      bodyDef.type = b2Body.b2_dynamicBody;
      bodyDefPos = new b2Vec2()
      bodyDefPos.Set(_x/30, _y/30 - 50);
      bodyDef.position = bodyDefPos;
//      body = new b2Body(bodyDef, world);
      body = world.CreateBody(bodyDef);

      // Define another box shape for our dynamic body.
      dynamicBox = new b2PolygonShape();
      dynamicBox.SetAsBox(_w/60, _h/60);

      // Define the dynamic body fixture.
      fixtureDef = new b2FixtureDef();
      fixtureDef.shape = dynamicBox;

      // Set the box density to be non-zero, so it will be dynamic.
      fixtureDef.density = 1.0;

      // Override the default friction.
      fixtureDef.friction = 0.3;

      // Add the shape to the body.
      body.CreateFixture(fixtureDef);
	  x = bodyDefPos.x * 30;
	  y = bodyDefPos.y * 30;
    }

    public function update():void
    {
      bodyDefPos = body.GetPosition();
//	  x = bodyDefPos.x * 30 - w / 2;
//	  y = bodyDefPos.y * 30 - h / 2;
//	  rotation = body.GetAngle() * (180/Math.PI);
//	  trace(bodyDefPos.x, bodyDefPos.y, w, h, x, y, stage.stageHeight);
//	  return;
      var matrix:Matrix = new Matrix() 
      matrix.translate(- w/2, - (h/2));
      matrix.rotate(body.GetAngle());
      matrix.translate((bodyDefPos.x*30), (bodyDefPos.y*30));
      transform.matrix = matrix;
    }
  }
}