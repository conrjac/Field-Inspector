@isTest
private class ObjectAndFieldServiceTest {
 
@isTest
    private static void testgetFieldsForObject()
    {
        /*
        String accountObject = 'Account';
        ObjectAndFieldService.getFieldsForObject(accountObject);
        List<Object__c> objectRecords = [SELECT Name FROM Object__c WHERE Id = :accountObject];
        System.assert(objectRecords.size() == 1, 'Account object not found');
        */
    }

    @isTest
    private static void testgetObjectDetails()
    {
        Test.startTest();
        Object__c objectRecord = new Object__c(Name = 'Account');
        insert objectRecord;

        objectRecord = ObjectAndFieldService.getObjectDetails(objectRecord);
        Test.stopTest();
        System.assert(objectRecord.Custom__c != True, 'Account Objecy Should Be Standard');
    }
}