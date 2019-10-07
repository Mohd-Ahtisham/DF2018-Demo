@RestResource(UrlMapping='/Account/*')
global without sharing class MyRestResource {
    
    @HttpDelete
    global static void doDelete() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Account account = [SELECT Id FROM Account WHERE Id = :accountId];
        delete account;
    }
    
    @HttpGet
    global static Account doGet(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Account acc = [SELECT Id, Name, BillingCity FROM Account WHERE Id =: accountId];
        return acc;
    }  
    
    @HttpPost
    global static Account doPost(){
        Account accountObject = new Account ();
        accountObject.Name = 'New Account'; 
        insert accountObject;
        system.debug('accountObject----->'+JSON.serialize(accountObject));
        return accountObject;
    } 
}