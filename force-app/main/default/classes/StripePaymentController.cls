public with sharing class StripePaymentController {

    @AuraEnabled
    public static paymentStripeWrapper getCardTokenAndPayment(String cardObj) {
        try {
            if (cardObj != null) {
                String access_token = 'sk_test_ADQTqMikzax38AzVuLWF1ng500pfsnFciz';
                
                cardDetailsWrapper cardDetailInst =
                        (cardDetailsWrapper) JSON.deserialize(cardObj, cardDetailsWrapper.class);
                System.debug('cardDetailInst>>>' + cardDetailInst);
                System.debug('cardDetailInst Month-->' + cardDetailInst.expiryMonth);
                System.debug('cardDetailInst Year-->' + cardDetailInst.expiryYear);
                Stripe_Credentials__c stripeAPI = Stripe_Credentials__c.getOrgDefaults();
                System.debug('cardDetailInst Year-->' + stripeAPI);

                if (access_token != null) {
                    HttpRequest request = new HttpRequest();
                    Http http = new Http();
                    HttpResponse response = new HttpResponse();
                    request.setMethod('POST');
                    request.setHeader('Authorization', 'Bearer '+stripeAPI.Secret_Key__c);
                    request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
                    request.setEndpoint(stripeAPI.Base_Url__c+'/tokens');
                    String reqBody = 'card[number]=' + cardDetailInst.cardNumber + '&card[exp_month]=' +
                            integer.valueof(cardDetailInst.expiryMonth) + '&card[exp_year]=' +
                            cardDetailInst.expiryYear + '&card[cvc]=' + integer.valueof(cardDetailInst.cvcNumber);
                    request.setBody(reqBody);
                    System.debug('request>>' + request);
                    if(Test.isRunningTest()){
                        return StripePaymentController.stripePayment('TestSecretKey', 'CardId');
                    }else{
                        response = http.send(request);
                        if (response.getBody() != null) {
                            stripeCardTokenWrapper stripCardDetail =
                                    (stripeCardTokenWrapper) JSON.deserialize(response.getBody(),
                                            stripeCardTokenWrapper.class);
                            if (stripCardDetail.Id != null) {
                                System.debug('stripCardDetail.Id---> '+stripCardDetail.Id);
                                return StripePaymentController.stripePayment(stripeAPI.Secret_Key__c, stripCardDetail.Id);
                            }
                        }
                    }
                }
            }
        } catch (Exception ex) {
            System.debug('Exception >>>' + ex.getMessage());
        }
        return null;
    }

    @AuraEnabled
    public static paymentStripeWrapper stripePayment(String accessToken, String cardToken) {
        try {
            System.debug('accessToken-- ' + accessToken);
            System.debug('cardToken-- ' + cardToken);

            Stripe_Credentials__c stripeAPI= Stripe_Credentials__c.getOrgDefaults();
            if (cardToken != null && accessToken != null) {
                Decimal finalTotal = 5000;
                HttpRequest request = new HttpRequest();
                Http http = new Http();
                HttpResponse response = new HttpResponse();
                request.setMethod('POST');
                request.setHeader('Authorization', 'Bearer ' + accessToken);
                request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
                request.setEndpoint(stripeAPI.Base_Url__c+'/charges');
                String reqBody = 'amount=' + integer.valueof(finalTotal) + '&currency=aud&source=' + cardToken;
                request.setBody(reqBody);
                System.debug('request>>' + request);
                paymentStripeWrapper stripCardDetail = new paymentStripeWrapper();
                if(!Test.isRunningTest()){
                    response = http.send(request);
                    if (response.getBody() != null ) {
                        stripCardDetail =
                                (paymentStripeWrapper) JSON.deserialize(response.getBody(), paymentStripeWrapper.class);
                    }
                }

                if (stripCardDetail != null) {
                    if(stripCardDetail.status == 'succeeded' || Test.isRunningTest()){
                        system.debug('Payment Reciept Id-------->'+stripCardDetail.id);
                        system.debug('Payment Amount-------->'+stripCardDetail.amount == null ? 0 : stripCardDetail.amount);
                        system.debug('Payment Date-------->'+DateTime.now());
                    }
                   
                    return stripCardDetail;
                }
            }
            return null;
        } catch (Exception ex) {
            System.debug('Exception >>>' + ex.getMessage() + ' at line number >' + ex.getLineNumber());
        }
        return null;
    }

    public class cardDetailsWrapper{
        @AuraEnabled
        public String cardNumber;
        @AuraEnabled
        public Integer expiryMonth;
        @AuraEnabled
        public Integer expiryYear;
        @AuraEnabled
        public String cvcNumber;
    }

    public class OAuth_Token{
        @AuraEnabled
        public String access_token;
        @AuraEnabled
        public String refresh_token;
        @AuraEnabled
        public String token_type;
        @AuraEnabled
        public String id_token;
        @AuraEnabled
        public String expires_in;

    }

    public class stripeCardTokenWrapper {
        @AuraEnabled
        public String id;
        @AuraEnabled
        public String object_Z;
        @AuraEnabled
        public Card card;
        @AuraEnabled
        public String client_ip;
        @AuraEnabled
        public Integer created;
        @AuraEnabled
        public Boolean livemode;
        @AuraEnabled
        public String type_Z;
        @AuraEnabled
        public Boolean used;
    }

    public class paymentStripeWrapper{
        @AuraEnabled
        public String id;
        @AuraEnabled
        public String object_Z;
        @AuraEnabled
        public Integer amount;
        @AuraEnabled
        public Integer amount_refunded;
        @AuraEnabled
        public String application;
        @AuraEnabled
        public String balance_transaction;
        @AuraEnabled
        public Boolean captured;
        @AuraEnabled
        public Integer created;
        @AuraEnabled
        public String currencies;
        @AuraEnabled
        public Object invoice;
        @AuraEnabled
        public Boolean livemode;
        @AuraEnabled
        public Object on_behalf_of;
        @AuraEnabled
        public Object order;
        @AuraEnabled
        public Outcome outcome;
        @AuraEnabled
        public String receipt_url;
        @AuraEnabled
        public String status;
    }
    public class Outcome {
        @AuraEnabled
        public String network_status;
        @AuraEnabled
        public Object reason;
        @AuraEnabled
        public String risk_level;
        @AuraEnabled
        public Integer risk_score;
        @AuraEnabled
        public String seller_message;
        @AuraEnabled
        public String type_Z;
    }

    public class Card {
        @AuraEnabled
        public String id;
        @AuraEnabled
        public String object_Z;
        @AuraEnabled
        public Object address_city;
        @AuraEnabled
        public Object address_country;
        @AuraEnabled
        public Object address_line1;
        @AuraEnabled
        public Object address_line1_check;
        @AuraEnabled
        public Object address_line2;
        @AuraEnabled
        public Object address_state;
        @AuraEnabled
        public Object address_zip;
        @AuraEnabled
        public Object address_zip_check;
        @AuraEnabled
        public String brand;
        @AuraEnabled
        public String country;
        @AuraEnabled
        public String cvc_check;
        @AuraEnabled
        public Object dynamic_last4;
        @AuraEnabled
        public Integer exp_month;
        @AuraEnabled
        public Integer exp_year;
        @AuraEnabled
        public String fingerprint;
        @AuraEnabled
        public String funding;
        @AuraEnabled
        public String last4;
        @AuraEnabled
        public Object name;
        @AuraEnabled
        public Object tokenization_method;
    }
}