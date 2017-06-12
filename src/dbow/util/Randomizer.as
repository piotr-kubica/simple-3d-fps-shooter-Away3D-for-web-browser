package dbow.util
{
	public class Randomizer
	{
		public function Randomizer(){
			throw new Error("Randomizer cannot be instatiated");
		}
		
		public static function getRand(to:Number = 1, from:Number = 0):Number {
			if(from >= to) {
				throw new Error("parameter [from] must be less than parameter [to]");
			}
			var range:Number = to - from;
			return Math.random() * range + from;
		}
	}
}