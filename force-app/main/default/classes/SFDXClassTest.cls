@isTest
private class SFDXClassTest {
    @isTest
    private static void SFDXClassMethoodTest() {
       Test.startTest();
        Account acc =  SFDXClass.SFDXClassMethood();
       Test.stopTest();
       System.assertNotEquals(acc,null);
    }
}