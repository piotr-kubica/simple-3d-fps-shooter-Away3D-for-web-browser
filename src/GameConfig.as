package
{
	public class GameConfig
	{
		public function GameConfig() {
			throw new Error("GameConfig cannot be instatiated");
		}
		
		public static const GAME_TIME:int = 90; // sec
		
		public static const FOG_DISTANCE:int = 200;
		public static const BG_COLOR:int = 0x86a1ae;
		
		// explosion buffer
		public static const EXPLOSION_BUFFER:int = 10;
		// enemies
		public static const OGRE_ENEMY_CNT:int = 5;
		public static const TRIS_ENEMY_CNT:int = 3;
		
		// enemy and player common terrain settings
		public static const FIGURE_OFF_BOUND:int = 100;
		public static const FIGURE_SIZE:int = 20;
		
		// Player settings
		public static const PLAYER_MAX_SPEED:int = 4;
		public static const PLAYER_OFF_GROUD:int = 40;
		
		public static const ROCKET_CNT:int = 10;
		public static const ROCKET_SPEED:int = 20;
		public static const ROCKET_OFFSET:int = 10;
		
		// AI settings
		public static const SCARE_DISTANCE:int = 300;
		public static const RUNAWAY_MAX_ITER:int = 40;
		public static const RUNAWAY_MIN_ITER:int = 10;
		public static const ROT_MAX_RAND:int = 30;
		
		// Enemy settings
		public static const ENEMY_OFF_GROUD:int = 24;
		public static const ENEMY_ROT_SPEED:int = 6;
		public static const OGRE_MAX_SPEED:int = 3;
		public static const TRIS_MAX_SPEED:int = 5;
	}
}