package br.com.ajwebdesign.authentication 
{
	import br.com.ajwebdesign.amf.AMFService;
	import br.com.ajwebdesign.utils.DomainUtils;
	import com.demonsters.debugger.MonsterDebugger;
	import flash.events.EventDispatcher;
	import br.com.ajwebdesign.validation.Validation;
	import flash.net.Responder;
	import flash.net.NetConnection;
	import flash.net.SharedObject;
	
	/**
	 * User Authentication singleton class.
	 * Make sure to initialize the AMFService class first to set the gateway paths.
	 * @author Alan Jhonnes
	 */
	[Event(name="LOGIN", type="br.com.ajwebdesign.authentication.AuthenticationEvent")]
	[Event(name="LOGIN_ERROR", type="br.com.ajwebdesign.authentication.AuthenticationEvent")]
	[Event(name="LOGOUT", type="br.com.ajwebdesign.authentication.AuthenticationEvent")]
	[Event(name="READING_COOKIES", type="br.com.ajwebdesign.authentication.AuthenticationEvent")]
	[Event(name="INSERT_ERROR", type="br.com.ajwebdesign.authentication.AuthenticationEvent")]
	[Event(name="USER_INSERTED", type="br.com.ajwebdesign.authentication.AuthenticationEvent")]
	[Event(name="EDITING_USER", type="br.com.ajwebdesign.authentication.AuthenticationEvent")]
	public class UserAuth extends EventDispatcher {
		protected static var instance:UserAuth;
		public var isLogged:Boolean;	
		public var rememberMe:Boolean = true;
		protected var user:BaseUser = new BaseUser();
		protected var siteClass:String;
		protected var gateway:String;
		protected var connection:NetConnection = new NetConnection();
		protected var loginResponder:Responder = new Responder(onLogin, onLoginError);
		//protected var logoutResponder:Responder = new Responder(onLogout);
		protected var insertUserResponder :Responder = new Responder(onInsert);
		protected var editUserResponder:Responder = new Responder(onEdit);
		protected var sharedObj:SharedObject = SharedObject.getLocal("UserAuth");
		
		
		/** Use UserAuth.getInstance() instead to access the UserAuth methods. */
		public function UserAuth(gatewayURL:String, className:String) {
			if ( instance ) {
				throw new Error( "UserAuth can only be accessed through UserAuth.getInstance()" );
			}
			else {
				gateway = gatewayURL;
				siteClass = className;
			}
		}
		
		
		public static function birth(gatewayURL:String, className:String):UserAuth {
			if (instance == null) instance = new UserAuth(gatewayURL, className);
			return instance;
		}
		
		//{ region Login functions
		
		public function login(login:String, password:String, remember:Boolean = true ):void {
			rememberMe = remember;
			connection.connect(gateway);
			connection.call(siteClass + "." + Functions.LOGIN, loginResponder, login, password);
			connection.close();
		}
		
		protected function onLogin(e:Object):void {
			MonsterDebugger.trace(this, e);
			if (e == false) {
				onLoginError("Login ou senha incorretos.");
			}
			else {
				user = new BaseUser();
				user.email = e['email'];
				user.userId = e['user_id'];
				user.login = e['name'];
				isLogged = true;
				if (rememberMe == true) {
					saveUser();
				}
				dispatchEvent(new AuthenticationEvent(AuthenticationEvent.LOGIN));
			}
		}
		
		protected function onLoginError(error:String):void {
			dispatchEvent(new AuthenticationEvent(AuthenticationEvent.LOGIN_ERROR, false, false, error));
		}
		//} endregion
		
		//{ region Insert User Functions
		
		public function insertUser(userLogin:String, password:String, email:String, membership:String = "USER", name:String = ""):void {
			dispatchEvent(new AuthenticationEvent(AuthenticationEvent.INSERTING_USER));
			connection.connect(gateway);
			connection.call(siteClass + "." + Functions.INSERT_USER, insertUserResponder, userLogin, password, name, email, membership);
			connection.close();
		}
		
		protected function onInsert(e:Boolean):void {
			if (e == false) {
				dispatchEvent(new AuthenticationEvent(AuthenticationEvent.INSERT_ERROR, false , false, "Erro inserindo usuário."));
			}
			else {
				dispatchEvent(new AuthenticationEvent(AuthenticationEvent.USER_INSERTED));
			}
		}
		//} endregion
		
		//{ region Edit User functions
		
		public function editUser(userLogin:String = null, name:String = null, email:String = null, membership:String = null):void {
			dispatchEvent(new AuthenticationEvent(AuthenticationEvent.EDITING_USER));
			connection.connect(gateway);
			connection.call(siteClass + "." + Functions.EDIT_USER, editUserResponder, userLogin, name, email, membership);
			connection.close();
		}
		
		protected function onEdit(e:Object) {
			trace(e);
			if (e == "Error") {
				dispatchEvent(new AuthenticationEvent(AuthenticationEvent.EDIT_ERROR, false, false, e as String));
			}
			else {
				updateUser(e);
				/*
				user.address = e['address'];
				user.city = e['city'];
				user.complement = e['complement'];
				user.district = e['district'];
				user.email = e['email'];
				user.login = e['login'];
				user.membership = e['membership'];
				user.name = e['name'];
				user.number = e['number'];
				user.state = e['state'];
				user.zipcode = e['zipcode'];
				*/
				dispatchEvent(new AuthenticationEvent(AuthenticationEvent.USER_EDITED));
				updateCookies();
			}
		}
		
		protected function updateUser(e:Object):void {
			
		}
		//} endregion
			
		//{ region Logout functions
		
		public function logout():void {
			//connection.connect(gateway);
			//connection.call(siteClass + "." + Functions.LOGOUT, logoutResponder);
			//connection.close();
			user = new BaseUser();
			isLogged = false;
			sharedObj.clear();
			dispatchEvent(new AuthenticationEvent(AuthenticationEvent.LOGOUT));
		}
		
		/*
		protected function onLogout(e:Object):void {
			user = new User();
			isLogged = false;
			sharedObj.clear();
			dispatchEvent(new AuthenticationEvent(AuthenticationEvent.LOGOUT));
		}
		*/
		//} endregion
		
		//{ region Flash Cookies functions
		
		public function checkCookies():void {
			if ( sharedObj.data.user ) {
				convertCookies();
				/*
				if (user.membership != Membership.GUEST) {
					dispatchEvent(new AuthenticationEvent(AuthenticationEvent.LOGIN));
				}
				*/
			}
		}
		
		protected function convertCookies():void {
			dispatchEvent(new AuthenticationEvent(AuthenticationEvent.READING_COOKIES));
			var obj:Object = sharedObj.data.user;
			user = new BaseUser();
			user.login = obj.login;
			user.email = obj.email;
			user.userId = obj.userId;
			isLogged = true;
			rememberMe = true;
			dispatchEvent(new AuthenticationEvent(AuthenticationEvent.LOGIN, false, false));
		}
		
		protected function updateCookies():void {
			/*
			var login:String = user.login;
			var name:String = user.name;
			var email:String = user.email;
			var zipcode:String = user.zipcode;
			var address:String = user.address;
			var number:String = user.number;
			var complement:String = user.complement;
			var district:String = user.district;
			var city:String = user.city;
			var state:String = user.state;
			var membership:String = user.membership;
			var object:Object = { login:login, name:name, email:email, zipcode:zipcode, address:address, number:number, complement:complement, district:district, city:city, state:state, membership:membership };
			
			sharedObj.data.user = object;
			*/
		}
		
		public function saveUser():void {
			if ( isLogged ) {
				sharedObj.data.user = user;
			}
		}
		//} endregion
		
		
		
		public function get currentUser():BaseUser {
			return user;
		}
		
		public function get memberships():Vector.<String> {
			return user.memberships;
		}
		
		public static function getInstance():UserAuth {
			return instance;
		}
	}
} 