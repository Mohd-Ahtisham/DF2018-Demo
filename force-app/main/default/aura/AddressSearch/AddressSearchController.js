({
    //Show the modal window on click in the input field
    OpenModal : function(component, event, helper) {
        component.set('v.AddressList', null);
        component.set("v.showModalBox", true);
    }, 
    //close the modal window on click of cancel button
    closeModal: function(component, event, helper) {
        component.set("v.showModalBox", false);
    }, 
    //Clear the address list on the user interface
    clear: function(component, event, helper) {
        helper.clearAddressList(component, event);
    }, 
    //get address details in the initital load of the component
    doInit: function(component, event, helper) {
        console.log("Init method execution");
        helper.getAddressDetails(component);
    }, 
    //Save address when user click on save button in the component
    saveAdress: function(component, event, helper){
        console.log("On click of save button!");
        helper.saveAddressDetails(component);
    },
    //Get city, state, country and other details from selected address
    selectOption:function(component, event, helper) {
        console.log("--Inside selectOption controller--");
        helper.getAddressDetailsByPlaceId(component, event);
    }, 
    //On search of address get address list from the API
    keyPressController: function(component, event, helper) {
        helper.getAddressRecommendations(component,event);
    }, 
})