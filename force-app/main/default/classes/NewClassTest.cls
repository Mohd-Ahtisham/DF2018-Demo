@isTest
private class NewClassTest {
    @isTest
    private static void newMethodTest() {
        Test.startTest();
        Account accObject = NewClass.newMethod();
        Test.stopTest();
        System.assertNotEquals(accObject,Null);
    }
}