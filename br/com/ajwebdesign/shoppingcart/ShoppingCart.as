package  br.com.ajwebdesign.shoppingcart
{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.net.SharedObject;
	import br.com.ajwebdesign.shoppingcart.ShoppingCartEvent;
	
	/**
	 * Singleton Shopping Cart Manager.
	 * @author Alan Jhonnes
	 */
	public class ShoppingCart extends EventDispatcher
	{	
		private static var instance:ShoppingCart;
		//private static var _instance:ShoppingCart = new ShoppingCart();
		private var items:Array = new Array();
		private var sharedObject:SharedObject = SharedObject.getLocal("ShoppingCart");
		protected var _useCookies:Boolean;
		/**
		 * Use ShoppingCart.getInstance() to access the ShoppingCart methods.
		 */
		public function ShoppingCart(useCookies:Boolean) {
			if ( instance ) {
				throw new Error( "ShoppingCart can only be accessed through ShoppingCart.getInstance()" );
			}
			if (useCookies == true) {
				_useCookies = true;
				if ( this.sharedObject.data.items) {
					trace(this.sharedObject.data.items);
					convertCookies();
				}
			}
		}
		
		public static function birth(useCookies:Boolean = false ):ShoppingCart		{
			if (instance == null) {
				instance = new ShoppingCart(useCookies);
				trace("ShoppingCart initialized.");
			}
			return instance;
		}
		
			
		/**
		 * Adds an item to the cart.
		 * @param	name The name of the product
		 * @param	price The price in real number
		 * @param	quantity A integer quantity
		 * @param	weight
		 * @param	category
		 * @param	id
		 */
		public function addItem(name:String, price:Number, quantity:int = 1, weight:Number = 0, category:String = "", id:int = 0):void {
			if (quantity <= 0) {
				quantity = 1;
			}
			var isInCart:Boolean = false;
			for each(var itemInCart:Item in  items) {
				if (name == itemInCart.name) {
					itemInCart.quantity += quantity;
					isInCart = true;
					break;
				}
			}
			if (isInCart == false) {
				var item:Item = new Item(name, price, quantity, weight, category, id);
				items.push(item);
			}
			dispatchEvent(new ShoppingCartEvent(ShoppingCartEvent.CHANGE, totalPrice, itemsCount));
			if (useCookies == true) {
				updateCookies();
			}
		}
		
		/**
		 * Changes the quantity of an item already in the cart.
		 * @param	name
		 * @param	newQuantity
		 */
		public function changeItemQuantity(name:String, newQuantity:int):void {
			if (newQuantity == 0) {
				removeItem(name);
			}
			else {
				for each(var itemInCart:Item in  items) {
					if (name == itemInCart.name) {
						itemInCart.quantity = newQuantity;
						break;
					}
				}
			}
			dispatchEvent(new ShoppingCartEvent(ShoppingCartEvent.CHANGE, totalPrice, itemsCount));
			if (useCookies == true) {
				updateCookies();
			}
		}
		
		/**
		 * Removes an item in the cart.
		 * @param	name
		 */
		public function removeItem(name:String):void {
			var index:int = 0;
			for each(var itemInCart:Item in  items) {
				if (name == itemInCart.name) {
					items.splice(index, 1);
					break;
				}
				index++;
			}
			dispatchEvent(new ShoppingCartEvent(ShoppingCartEvent.CHANGE, totalPrice, itemsCount));
			if (useCookies == true) {
				updateCookies();
			}
		}
		
		/**
		 * Trace all shopping cart properties,including each item
		 */
		public function traceContent():void {
			trace("Shopping Cart Contents:");
			trace("Total items = " + items.length);
			trace("Total price = " + totalPrice);
			trace("Total weight = " + totalWeight);
			if (items.length > 0) {
				trace("-------------------------");
				trace("Tracing items: ");
				for each(var itemInCart:Item in  items) {
					trace("Id = " + itemInCart.id)
					trace("Name = " + itemInCart.name);
					trace("Price = " + itemInCart.price);
					trace("Quantity = " + itemInCart.quantity);
					trace("Weight = " + itemInCart.weight);
					trace("Category = " + itemInCart.category);
					trace("Total item price = " + itemInCart.totalPrice);
					trace("Total item weight = " + itemInCart.totalWeight);
					trace("-----------------------------");
				}
			}
			trace("End trace cart contents");
		}
		
		private function convertCookies():void
		{
			var array:Array = this.sharedObject.data.items;
			var name:String;
			var price:Number;
			var quantity:int;
			var weight:Number;
			var category:String;
			var id:int;
			for each(var item:Object in array) {
				name = item.name;
				price = item.price;
				quantity = item.quantity;
				weight = item.weight;
				category = item.category;
				id = item.id;
				var cartItem:Item = new Item(name, price, quantity, weight, category, id);
				items.push(cartItem);
			}
			traceContent();
		}
		
		private function updateCookies():void {
			var array:Array = [];
			for each (var item:Item in this.items){
				var name:String;
				var price:Number;
				var quantity:int;
				var weight:Number;
				var category:String;
				var id:int;
				name = item.name;
				price = item.price;
				quantity = item.quantity;
				weight = item.weight;
				category = item.category;
				id = item.id;
				var object:Object = { name:name, price:price, quantity:quantity, weight:weight, category:category, id:id };
				array.push(object);
			}
			sharedObject.data.items = array;
		}
		
		/**
		 * Clear the shopping cart.
		 */
		public function clearCart():void {
			items = [];
			dispatchEvent(new ShoppingCartEvent(ShoppingCartEvent.CHANGE, 0, 0));
			if (useCookies == true) {
				updateCookies();
			}
		}
		
		/**
		 * @return The number of items in the cart. 
		 */
		public function get itemsCount():int {
			return items.length;
		}
		
		/**
		 * @return The total price of all the items in cart.
		 */
		public function get totalPrice():Number {
			var total:Number = 0;
			for each(var item:Item in items) {
				total += item.totalPrice;
			}
			return total;
		}
		
		/**
		 * @return The total weight of all the items in the cart.
		 */
		public function get totalWeight():Number {
			var total:Number = 0;
			for each(var item:Item in items) {
				total += item.totalWeight;
			}
			return total;
		}
		
		
		
		/**
		 * @return The array containning all the items in the ShoppingCart.
		 * @example for each(var item:Item in ShoppingCart.instance.items){
		 * 		txtName.text = item.name;
		 * 		txtPrice.text = item.price;
		 * 		txtQuantity.text = item.quantity;
		 * }
		 */
		public function get Items():Array {
			return items;
		}
		
		public function get useCookies():Boolean { return _useCookies; }
		
		public function set useCookies(value:Boolean):void 
		{
			_useCookies = value;
		}
		
		/**
		 * @return The Shopping Cart Instace.Use this to access the methods of the Shopping Cart.
		 */
		public static function getInstance():ShoppingCart {
			return instance;
		}
		
		
	}
}