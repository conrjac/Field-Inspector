@isTest
private class ObjectTriggerHandlerTest {

    @isTest
    private static void insertRecord()
    {
        Object__c objectRecord = new Object__c(Name = 'Account');
        insert objectRecord;
        System.assertNotEquals(objectRecord.Id, NULL,'Object Record Insert Failed');
    }

}