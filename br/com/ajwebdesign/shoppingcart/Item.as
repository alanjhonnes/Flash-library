package br.com.ajwebdesign.shoppingcart 
{
	
	/**
	 * Item class for the ShoppingCart.
	 * @author Alan Jhonnes
	 */
	public class Item
	{
		
		public var name:String;
		public var id:int;
		public var category:String;
		public var price:Number;
		public var weight:Number;
		private var _quantity:int;
		private var _totalPrice:Number;
		private var _totalWeight:Number;

		
		/**
		 * Creates a new Item to be put on the shopping cart.Name,price and quantity are required.
		 * @param	name
		 * @param	price
		 * @param	quantity
		 * @param	category
		 * @param	id
		 */
		public function Item(name:String,price:Number,quantity:int, weight:Number = 0, category:String = "", id:int = 0) 
		{
			this.name = name;
			this.price = price;
			this.id = id;
			this.weight = weight;
			this.category = category;
			this.quantity = quantity;
		}
		
		
		
		public function get quantity():int { return _quantity; }
		
		public function set quantity(value:int):void 
		{
			_quantity = value;
			_totalPrice = price * _quantity;
			_totalWeight = weight * _quantity;
		}
		
		public function get totalPrice():Number { return _totalPrice; }
		
		public function get totalWeight():Number { return _totalWeight; }
		
		
		
	}

}