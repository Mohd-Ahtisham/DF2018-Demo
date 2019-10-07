({
    doInit : function (c,e,h) {
        try {
            h.refreshCardDetails_helper(c, e, h);
        } catch (ex) {
            console.log('excpetion>' + ex);
        }
    },

    cardNumberValidation : function(c, e, h){
        h.cardNumberValidation_helper(c, e, h);
    },

    getCardToken : function(c, e, h){
        h.getCardToken_helper(c, e, h);
    },

    closePaymentPopup : function(c, e, h){
        c.set('v.openStripe',false);
    },
})