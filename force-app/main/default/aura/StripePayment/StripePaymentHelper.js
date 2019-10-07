({
    cardNumberValidation_helper : function(c, e, h){
        try{
            var str = e.getSource().get("v.value");
            var name = e.getSource().get("v.name");
            //console.log('str>>'+str);
            if(!$A.util.isUndefinedOrNull(str) && !$A.util.isUndefinedOrNull(name)){
                var newstr = str.replace(/\D/g,'');
                //console.log('newstr>>'+newstr);
                var cardObj = {};
                if(name === 'Card Number'){
                    c.set("v.cardObj.cardNumber",newstr);
                    //cardObj.cardNumber = newstr;
                }
                else if(name === 'Card Month'){
                    if(parseInt(newstr) < 1){
                        newstr = 1;

                    }
                
                    c.set("v.cardObj.expiryMonth",newstr);
                }
                else if(name === 'Card Year'){

                    c.set("v.cardObj.expiryYear",newstr);
                }
                else if(name === 'CVC Number'){
                    c.set("v.cardObj.cvcNumber",newstr);
                    //cardObj.cvcNumber = newstr;
                }

                //c.set("v.cardObj",cardObj);
            }
        }
        catch(ex){
            console.log('exception>>'+ex);
        }
    },

    getCardToken_helper : function(c, e, h){
        try{
            if(true) {
                c.set("v.isStripeOpen",true);
                var cardDetail = c.get("v.cardObj");
                console.log('cardDetail---->'+JSON.stringify(cardDetail));
                if(!$A.util.isUndefinedOrNull(cardDetail) && !$A.util.isEmpty(cardDetail)){
                    let action = c.get("c.getCardTokenAndPayment");
                    action.setParams({
                        "cardObj" : JSON.stringify(cardDetail)
                    });
                    action.setCallback(this, function(r) {
                        let state = r.getState();
                        console.log(state);
                        if (state === "SUCCESS") {
                            let storedResponse = r.getReturnValue();
                            console.log('StoredResponse--->',storedResponse);
                            if(!$A.util.isUndefinedOrNull(storedResponse) && storedResponse.status === 'succeeded'){
                                alert('Payment done successfully!');
                                c.set('v.openStripe',false);
                                h.refreshCardDetails_helper(c, e, h);
                                window.open(storedResponse.receipt_url);
                            }else{
                                alert('Payment was not successful. Please try again !')
                            }
                        }
                        else if (state === "ERROR") {
                            let errors = r.getError();
                            if (errors) {
                                if (errors[0] && errors[0].message) {
                                    console.log("Error message: " +
                                        errors[0].message);
                                }
                            } else {
                                console.log("Unknown error");
                            }
                        }
                    });
                    $A.enqueueAction(action);
                }
            }
        }
        catch(ex){
            console.log('exception>>'+ex);
        }
    },

    validateContactForm : function(c, e, h){
        try{
            var allValid = c.find('creditCardDetails').reduce(function (validSoFar, inputCmp) {
                inputCmp.showHelpMessageIfInvalid();
                return validSoFar && inputCmp.get('v.validity').valid;
            }, true);
            if (allValid) {
                //alert('All form entries look valid. Ready to submit!');
                return allValid;
            } else {
                //alert('Please update the invalid form entries and try again.');
                return false;
            }
        }
        catch(ex){
            console.log('Exception >>'+ex);
        }
    },

    refreshCardDetails_helper : function (c, e, h) {
        var creditCardObjVar = {};
        creditCardObjVar.cardNumber = null;
        creditCardObjVar.expiryMonth = null;
        creditCardObjVar.expiryYear = null;
        creditCardObjVar.cvcNumber = null;
        c.set("v.cardObj",creditCardObjVar);
    }

})