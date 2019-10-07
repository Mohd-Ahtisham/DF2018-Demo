public with sharing class SFDXClass {
    public static Account SFDXClassMethood() {
        Account acc = new Account();
        acc.Name = 'Test  SFDX Account';
        insert acc;
        system.debug('acc------->'+acc);
        return acc;
    }
}