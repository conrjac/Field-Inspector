@isTest
private class ObjectAndFieldServiceTest {
 
   @testSetup static void setup() {
        // Create common test accounts
        List<Object__c> objects = new List<Object__c>();

        for(string objectName : new List<String>{'Account','Contact','Case'})
        {
            objects.add(new Object__c(Name = objectName));
        }

        insert objects;    
    }



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
        System.assert(objectRecord.Custom__c != True, 'Account Object Should Be Standard');
    }


    @isTest
    private static void testOBJECTS()
    {
        Test.startTest();
        List<Object__c> objectsFromDatabase = [SELECT Id FROM Object__c];
        Map<String, Object__c> objectsFromClass = ObjectAndFieldService.OBJECTS;
        Test.stopTest();
     //   System.assertEquals(objectsFromDatabase, objectsFromClass.values(), 'Object results different');

    }

    @isTest
    private static void testDESCRIBEOBJECTS()
    {
        Test.startTest();
        Map<String, Schema.SObjectType>  describeObjectsFromClass = ObjectAndFieldService.DESCRIBEOBJECTS;
        Map<String, Schema.SObjectType> describeObjectsFromSchema = Schema.getGlobalDescribe(); 
        Test.stopTest();
        System.assertEquals(describeObjectsFromClass, describeObjectsFromSchema, 'Schema results different');
    }

}