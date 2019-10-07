({
    clearAddressList : function(component) {
        console.log("Clearing the list!");
        component.set('v.searchKey', null)
        component.set('v.AddressList', null);
    }, 
    saveAddressDetails:function(component){
        var id = component.get("v.recordId"); 
        var action = component.get("c.saveAddressDetailsbyId");
        action.setParams({
            id:id,
            addDetails:component.get("v.addressDetails")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('state is ' + state);
            if(state == 'SUCCESS' && response.getReturnValue() == 'Success'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title:'Success Message',
                    message:'Address details are updated successfully!',
                    duration:'2000',
                    key:'info_alt',
                    type:'success',
                    mode:'pester'
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    //get address details from salesforce DB
    getAddressDetails: function(component){
        var id = component.get("v.recordId");  
        var action = component.get("c.getAddressDetailsbyId");
        console.log('action---->'+JSON.stringify(action));
        action.setParams({
            id:id 
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS'){
                console.log(response.getReturnValue());
                component.set("v.addressDetails", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    //get address details by place Id from google API 
    getAddressDetailsByPlaceId: function(component,event){
        var selectedValue = event.currentTarget.dataset.value;
        var action = component.get("c.getAddressDetailsByPlaceId");
        console.log('action------->'+JSON.stringify(action));
        action.setParams({
            PlaceID:selectedValue 
        });
        action.setCallback(this, function(response){
            var res = response.getState();
            if(res == 'SUCCESS'){
                //console.log(response.getReturnValue());
                var response = JSON.parse(response.getReturnValue());
                var postalCode = '', state = '', country= '', city = '', street = '', street_number = '', route = '', subLocal1 = '', subLocal2 = '';
                
                for(var i=0; i < response.result.address_components.length ; i++){
                    var FieldLabel = response.result.address_components[i].types[0];
                    //console.log(FieldLabel);
                    //debugger;
                    if(FieldLabel == 'sublocality_level_2' || FieldLabel == 'sublocality_level_1' || FieldLabel == 'street_number' || FieldLabel == 'route' || FieldLabel == 'locality' || FieldLabel == 'country' || FieldLabel == 'postal_code' || FieldLabel == 'administrative_area_level_1'){
                        switch(FieldLabel){
                            case 'sublocality_level_2':
                                subLocal2 = response.result.address_components[i].long_name;
                                break;
                            case 'sublocality_level_1':
                                subLocal1 = response.result.address_components[i].long_name;
                                break;
                            case 'street_number':
                                street_number = response.result.address_components[i].long_name;
                                break;
                            case 'route':
                                route = response.result.address_components[i].short_name;
                                break;
                            case 'postal_code':
                                postalCode = response.result.address_components[i].long_name;
                                break;
                            case 'administrative_area_level_1':
                                state = response.result.address_components[i].short_name;
                                break;
                            case 'country':
                                country = response.result.address_components[i].long_name;
                                break;
                            case 'locality':
                                city = response.result.address_components[i].long_name;
                                break;
                            default:
                                break;
                        }
                    }
                }
                
                street = street_number + ' ' + route;
                if(street == null){
                    street = subLocal2 + ' ' + subLocal1;
                }
                console.log(street);
                component.set('v.addressDetails.Street__c', street);
                component.set('v.addressDetails.Postal_Code__c', postalCode);
                component.set('v.addressDetails.State__c', state);
                component.set('v.addressDetails.Country__c', country);
                component.set('v.addressDetails.City__c	', city);
                component.set("v.searchKey", null);
                component.set("v.showModalBox", false);
            }
        });
        $A.enqueueAction(action);
    },
    getAddressRecommendations: function(component, event){
        var key = component.get("v.searchKey");
        var action = component.get("c.getAddressSet");
        action.setParams({
            "SearchText": key
        });
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var response = JSON.parse(response.getReturnValue());
                var predictions = response.predictions;
                var addresses = [];
                if (predictions.length > 0) {
                    for (var i = 0; i < predictions.length; i++) {
                        var bc =[];
                        addresses.push(
                            {
                                main_text: predictions[i].structured_formatting.main_text, 
                                secondary_text: predictions[i].structured_formatting.secondary_text,
                                place_id: predictions[i].place_id
                            });
                        
                    }
                }
                for(var i=0; i <addresses.length; i++){
                    console.log(addresses[i].main_text);
                    console.log(addresses[i].secondary_text);
                    console.log(addresses[i].place_id);
                }
                component.set("v.AddressList", addresses);
            }
        });
        $A.enqueueAction(action);
    },
})