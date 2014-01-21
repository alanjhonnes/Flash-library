package br.com.ajwebdesign.authentication 
{
	/**
	 * User for the user
	 * @author Alan
	 */
	public class User
	{
		public var login:String;
		public var name:String;
		public var email:String;
		public var zipcode:String;
		public var address:String;
		public var number:String;
		public var complement:String;
		public var district:String;
		public var city:String;
		public var state:String;
		public var membership:String;
		
		public function User(membership:String = "GUEST", login:String = "", name:String = "", email:String = "", zipcode:String = "", address:String = "", number:String = "", complement:String = "", district:String = "", city:String = "", state:String = "" ) 
		{
			this.membership = membership;
			this.login = login;
			this.name = name;
			this.email = email;
			this.zipcode = zipcode;
			this.address = address;
			this.number = number;
			this.complement = complement;
			this.district = district;
			this.city = city;
			this.state = state;
			
		}
		
	}

}