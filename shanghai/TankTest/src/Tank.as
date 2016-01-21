package
{
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	import flare.basic.Scene3D;
	import flare.core.Mesh3D;
	import flare.core.Pivot3D;
	import flare.materials.Shader3D;
	import flare.materials.filters.TextureFilter;
	import flare.system.Device3D;
	
	public class Tank extends Pivot3D
	{
		protected var model:Pivot3D;
		
		protected var paotai:Pivot3D;
		protected var lvdaiMaterial:Shader3D;
		
		protected var isWDown:Boolean = false;
		protected var isADown:Boolean = false;
		protected var isSDown:Boolean = false;
		protected var isDDown:Boolean = false;
		
		public function Tank()
		{
			super("");
		}
		
		public function startMoving():void
		{
			this.isWDown = false;
			this.isSDown = false;
			this.isADown = false;
			this.isDDown = false;
			Device3D.scene.addEventListener(Scene3D.UPDATE_EVENT, updateEvent);
		}
		
		public function stopMoving():void
		{
			Device3D.scene.removeEventListener(Scene3D.UPDATE_EVENT, updateEvent);
			
			this.isWDown = false;
			this.isSDown = false;
			this.isADown = false;
			this.isDDown = false;
		}
		
		public function setState(x:Number, z:Number, oriX:Number, oriZ:Number, paoOriX:Number, paoOriZ:Number):void
		{
			this.x = x;
			this.z = z;
			this.setOrientation(new Vector3D(oriX, 0, oriZ));
			paotai.setOrientation(new Vector3D(paoOriX, 0, paoOriZ));
		}
		
		public function updateState(isWDown:Boolean, isSDown:Boolean, isADown:Boolean, isDDown:Boolean, paotaiDirX:Number, paotaiDirZ:Number):void
		{
			this.isWDown = isWDown;
			this.isSDown = isSDown;
			this.isADown = isADown;
			this.isDDown = isDDown;
			
			// 炮台朝向
			if (paotai)
				paotai.setOrientation(new Vector3D(paotaiDirX, 0, paotaiDirZ));
		}
		
		protected function updateEvent(event:Event):void
		{
			if (isWDown || isSDown || isADown || isDDown)
			{
				(lvdaiMaterial.filters[0] as TextureFilter).offsetX -= 0.1;
				lvdaiMaterial.build();
			}
			
			if (isWDown)
				this.translateZ(8);
			if (isSDown)
				this.translateZ(-8);
			
			if (isADown)
				this.rotateY(-1.5);
			if (isDDown)
				this.rotateY(1.5);
		}
		
		public function cloneModel(name:String):Tank
		{
			var tank:Tank = new Tank();
			tank.model = model.clone();
			tank.paotai = tank.model.getChildByName("paotai");
			tank.lvdaiMaterial = (tank.model.getChildByName("lvdai") as Mesh3D).getMaterialByName("lvdai") as Shader3D;
			tank.name = name;
			tank.addChild(tank.model);
			return tank;
		}
	}
}