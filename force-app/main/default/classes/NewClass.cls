public with sharing class NewClass {
    public static Account newMethod(){
        Account accObj = new Account();
        accObj.Name = 'Hello SFDX';
        insert accObj;
        return accObj;
    }
}