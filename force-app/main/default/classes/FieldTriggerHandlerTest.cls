@isTest
private class FieldTriggerHandlerTest {

    @TestSetup
    static void insertTestData(){
        Object__c obj = new Object__c(Name = 'Account');
        insert obj;
    }

    @isTest
    private static void insertRecord()
    {
        Object__c accountObject = [SELECT Id FROM Object__c WHERE Name = 'Account' LIMIT 1];
        Field__c f = new Field__c(Name = 'Name', Object__c = accountObject.Id);
        Insert f;
        System.assertNotEquals(f.Id, Null, 'Field Record Insert Failed');
    }
}