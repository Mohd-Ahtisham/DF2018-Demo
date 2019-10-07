/*****************************************************************************************
Class Name:  AddressSearchController
Description: This class is used to call google location API for auto complete functionality
******************************************************************************************/
public class AddressSearchController {
    
    //Method to get address details in the initial load
    @AuraEnabled
    public static List<Address_Details__c> getAddressDetailsbyId(String id){
        List<Address_Details__c> ad = new List<Address_Details__c>();
        ad = [select Id, City__c, State__c, Country__c, Postal_Code__c, Street__C  from Address_Details__c where Id=: id];
        system.debug('ad-------->'+ad);
        if(ad.size() > 0){
            return ad;
        }
        return ad;
    }
    
    //Method to save address details on click on Save button
    @AuraEnabled
    public static String saveAddressDetailsbyId(String id, Address_Details__c addDetails){
        system.debug('saveAddressDetailsbyId method');
        Address_Details__c obj = [select Id from Address_Details__c where Id=: id];
        obj.City__c = addDetails.City__c;
        obj.State__c = addDetails.State__c;
        obj.Country__c = addDetails.Country__c;
        obj.Postal_Code__c = addDetails.Postal_Code__c;
        obj.Street__c = addDetails.Street__c;
        update obj;
        return 'Success';
    }
    
    //Method to call google API and fetch the address recommendations 
    @AuraEnabled
    public static String getAddressSet(String SearchText){
        String APIKey = 'AIzaSyBtuD9VexV2ah1REIM1dNqiqqtjWJlIL0A';
        String result = null;
        system.debug('SearchText is ' + SearchText);
        try{
            if(SearchText != null){
                String APIUrl = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=' + SearchText.replace(' ', '%20') + '&key=' + APIKey; 
                system.debug('APIUrl is ' + APIUrl);
                HttpRequest req = new HttpRequest();
                req.setMethod('GET');
                req.setEndpoint(APIURL);
                Http http = new Http();
                HttpResponse res = http.send(req);
                Integer statusCode = res.getStatusCode();
                system.debug('statusCode is ' + statusCode);
                if(statusCode == 200){
                    system.debug('API invoked successfully');
                    system.debug('res.getBody------>'+res.getBody());
                    result = res.getBody();
                }
            }
        }
        catch(exception e){
            //Handling exception
            system.debug(e.getMessage());
            system.debug(e.getLineNumber());
        }
        return result;
    }
    
    //Method to call google API and fetch the address details by addressID 
    @AuraEnabled
    public static String getAddressDetailsByPlaceId(String PlaceID){
        String APIKey = 'AIzaSyBtuD9VexV2ah1REIM1dNqiqqtjWJlIL0A';
        String result = null;
        system.debug('SearchText is ' + PlaceID);
        try{
            if(PlaceID != null){
                String APIUrl = 'https://maps.googleapis.com/maps/api/place/details/json?placeid=' + PlaceId.replace(' ', '%20') + '&key=' + APIKey; 
                system.debug('APIUrl is ' + APIUrl);
                HttpRequest req = new HttpRequest();
                req.setMethod('GET');
                req.setEndpoint(APIURL);
                Http http = new Http();
                HttpResponse res = http.send(req);
                Integer statusCode = res.getStatusCode();
                system.debug('statusCode is ' + statusCode);
                if(statusCode == 200){
                    system.debug('API invoked successfully');
                    result = res.getBody();
                }
            }
        }
        catch(exception e){
            //Handling exception
            system.debug(e.getMessage());
            system.debug(e.getLineNumber());
        }
        return result;
    }
}