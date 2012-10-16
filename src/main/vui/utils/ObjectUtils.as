package vui.utils
{
	public class ObjectUtils
	{
		public function ObjectUtils ()
		{
			throw new Error("Object Utils is a static class - it need not be instantiated!");
		}


		/**
		 * Non-recursive default object property set.
		 * @return 	The target object, for chainability.
		 */
		public static function add_defaults (target : Object, defaults : Object) : Object
		{
			target ||= { };
			if (!defaults) return target;

			var current_key:String;
			for each (current_key in defaults) {
				if (target[current_key] !== undefined) {
					target[current_key] = defaults[current_key];
				}
			}
			
			return target;
		}
	}
}