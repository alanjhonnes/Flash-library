package br.com.ajwebdesign.amf
{
	import br.com.ajwebdesign.utils.DomainUtils;
	import flash.events.AsyncErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.LocalConnection;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.utils.getQualifiedClassName;
	import temple.core.CoreNetConnection;
	import temple.core.CoreObject;
	
	/**
	 * AbstractAMFNetConnection class contains the base functionality for communicating
	 * with an AMF server.
	 * 
	 * @author Alan Jhonnes
	 */	
	public class AbstractAMFNetConnection extends CoreObject
	{
		/**
		 * The AMF gateway URL.
		 */		
		static public var connection:String;
		
		protected var method:String;
		protected var success:Function;
		protected var failure:Function;
		//protected var methodArguments:Array;
		protected var netConnection:CoreNetConnection;
		
		/**
		 * @Constructor
		 * 
		 * @param command The class and method to execute on the server, "MyClass.myMethod".
		 * @param successCallback The method to call on success.  Method signature should be "function successCallback( result:Object )"
		 * @param failureCallback The method to call on failure.  Method signature should be "function failureCallback( fault:Object )"
		 * @param methodArgs An Array of objects to send to the remote method, depending on what the remote method expects.
		 * @param executeNow (Optional) This parameter defaults to true, so that the remote method is invoked immediately.  Must call the invoke() method if set to false.
		 */		
		public function AbstractAMFNetConnection( command:String, successCallback:Function, failureCallback:Function, invokeNow:Boolean = true ) {
			method				= command;
			success				= successCallback;
			failure				= failureCallback;
			initNetConnection();
			
			if (invokeNow) {
				invoke();
			}
		}
		
		protected function initNetConnection():void {
			netConnection					= new CoreNetConnection();
			netConnection.objectEncoding		= ObjectEncoding.AMF3;
			connection  = AMFService.correctGatewayPath;
			netConnection.addEventListener(NetStatusEvent.NET_STATUS, netStatus, false, 0, true);
			netConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, netSecurityError, false, 0, true);
			netConnection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorEventHandler, false, 0, true);
			netConnection.addEventListener(IOErrorEvent.IO_ERROR, ioErrorEventHandler, false, 0, true);
			netConnection.connect( connection );
		}
		
		protected function ioErrorEventHandler(e:IOErrorEvent):void {
			logError("AMF IOError - " + e.type); 
		}
		
		protected function asyncErrorEventHandler(e:AsyncErrorEvent):void {
			logError("AMF async error - " + e.error);
		}
		
		protected function netSecurityError(e:SecurityErrorEvent):void {
			logError("AMF Net Security error - " + e.type);
		}
		
		protected function netStatus(e:NetStatusEvent):void {
			logStatus(e.type + " - " + e.info + " - " + e.info.code);
		}
		
		public function invoke():void {
			// Implemented in concrete service class
		}
		
		override public function destruct():void {
			success = null;
			failure = null;
			netConnection.removeEventListener(NetStatusEvent.NET_STATUS, netStatus);
			netConnection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, netSecurityError);
			netConnection.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorEventHandler);
			netConnection.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorEventHandler);
			netConnection.destruct();
			super.destruct();
		}
	}
}