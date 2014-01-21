package br.com.ajwebdesign.shoppingcart 
{
	import flash.events.Event;
	
	/**
	 * Shopping Cart Events
	 * @author Alan Jhonnes
	 */
	public class ShoppingCartEvent extends Event 
	{
		public static const CHANGE:String = "CHANGE";
		
		public var totalPrice:Number;
		public var itemsCount:int;
		public function ShoppingCartEvent(type:String, totalPrice:Number = 0, itemsCount:int = 0, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			this.totalPrice = totalPrice;
			this.itemsCount = itemsCount;
		} 
		
		
		public override function toString():String 
		{ 
			return formatToString("ShoppingCartEvent", "type", "bubbles", "cancelable", "eventPhase", "totalPrice", "itemsCount"); 
		}
		
	}
	
}