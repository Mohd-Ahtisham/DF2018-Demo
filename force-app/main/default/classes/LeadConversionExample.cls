/*
* Created by MOHD AHTISHAM on 07/16/2019
*/
public class LeadConversionExample {
    public static void leadExample(){
        
        List<String> dateRecords = new List<String>();
        List<Lead> listOfLead = new List<Lead>();
        Date startDate = Date.parse('01/01/2019');
        Date endDate = System.Today();
        for(dateTime dateObject=startDate ; dateObject<=endDate;  dateObject=dateObject.addDays(1)){
            dateTime addDayDateObject = dateObject.addDays(1);
            string dateFormat = dateObject.formatGmt('MM'+'dd'+'yyyy');
            
            Lead leadObject = new Lead();
            leadObject.LastName ='CA-Lead-'+dateFormat;
            
            Integer sum = addDayDateObject.day() + addDayDateObject.month() + addDayDateObject.year();
            if(math.mod(sum,2) == 0){
                leadObject.Status = 'Working - Contacted';  
                leadObject.Company = 'CA-Company-'+dateFormat;
                dateRecords.add(dateFormat);
            }
            else{
                leadObject.Status = 'Open - Not Contacted';
                leadObject.Company = 'CA-Waste-'+dateFormat;
                leadObject.LeadSource = 'Purchased List';
            }
            listOfLead.add(leadObject);
        }
        
        if(listOfLead.size() > 0){
            insert listOfLead;
        } 
        
        Set<Id> leadId = new Set<Id>();
        for(Lead leadObject :listOfLead){
            if(leadObject.Status == 'Working - Contacted'){
                leadId.add(leadObject.id);
            }
        }
        
        List<Lead> leadObjectList = [Select Id, Name, Status, LeadSource, Company FROM Lead WHERE Id IN: leadId LIMIT 10000];
        if(leadObjectList.size() > 0 ){
            List<Database.LeadConvert> leadConvertsList = new List<database.LeadConvert>();
            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            for(Lead leadObject : leadObjectList){
                Database.LeadConvert leadConvertObject = new database.LeadConvert();
                leadConvertObject.setLeadId(leadObject.Id);
                leadConvertObject.setDoNotCreateOpportunity(TRUE);
                leadConvertObject.setConvertedStatus(convertStatus.MasterLabel);
                leadConvertsList.add(leadConvertObject);
            } 
            
            Set<Id> accountId = new Set<Id>(); 
            Database.LeadConvertResult[] leadConvertResultList = Database.convertLead(leadConvertsList, false);
            for(Database.LeadConvertResult leadConvertResultObject : leadConvertResultList){
                System.assert(leadConvertResultObject.isSuccess());
                Id accId = leadConvertResultObject.getAccountId();
                accountId.add(accId);
            }
            
            if(accountId.size() > 0){
                List<Account> accountUpdateList = new List<Account>();
                List<Account> accountList = new List<Account>();
                accountList = [SELECT Name FROM Account WHERE Id IN : accountId LIMIT 10000];
                if(accountList.size() > 0){
                    if(dateRecords.size() > 0){
                        Integer i = 0;
                        for (Account accountObject : accountList){ 
                            accountObject.Name = 'CA-Account-'+dateRecords[i];
                            accountUpdateList.add(accountObject);
                            i++;
                        }
                        if(accountUpdateList.size() > 0){
                            update accountUpdateList;
                        }
                    }
                }
            }
        } 
    }
}