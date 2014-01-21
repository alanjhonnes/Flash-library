package br.com.ajwebdesign.shoppingcart 
{
	
	/**
	 * ShoppingCart API
	 * @author Alan Jhonnes
	 */
	public interface IShoppingCart 
	{
		function clearCart():void;
		
		function get itemsCount():int;
		
		function get totalPrice():Number;
		
		function get totalWeight():Number;
		
		function get Items():Array;
		
		function traceContent():void;
		
		function removeItem(name:String):void;
		
		function changeItemQuantity(name:String, newQuantity:int):void;
		
		function addItem(name:String, price:Number, quantity:int = 1, weight:Number = 0, category:String = "", id:int = 0):void;
		
	}
	
}