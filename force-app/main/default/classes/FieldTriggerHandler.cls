public class FieldTriggerHandler implements TriggerHandler {
    
    public void beforeInsert(List<Field__c> newFields) {
        updateFieldUsageCounts(newFields);
    }
    public void beforeUpdate(List<Field__c> oldFields, List<Field__c> newFields, Map<ID, SObject> oldAccountMap, Map<ID, SObject> newAccountMap) {
       updateFieldUsageCounts(newFields);
    }
    public void beforeDelete(List<Field__c> oldFields, Map<ID, SObject> oldAccountMap) {
        
    }
    public void afterInsert(List<Field__c> newFields, Map<ID, SObject> newAccountMap) {
        
    }
    public void afterUpdate(List<Field__c> oldFields, List<Field__c> newFields, Map<ID, SObject> oldAccountMap, Map<ID, SObject> newAccountMap) {
        
    }
    public void afterDelete(List<Field__c> oldFields, Map<ID, SObject> oldAccountMap) {

    }
    public void afterUndelete(List<Field__c> newFields, Map<ID, SObject> newAccountMap) {
    
    }
    
    public static void updateFieldUsageCounts(List<Field__c> newFields)
    {
        Set<Id> relatedObjectRecords = new Set<Id>();
        for(Field__c f : newFields) 
        {
            relatedObjectRecords.add(f.Object__c);
        }

        Map<Id, Object__c> objectDetails = New Map<Id, Object__c>([SELECT Id, Name FROM Object__c WHERE Id IN:relatedObjectRecords WITH SECURITY_ENFORCED]);
        
        for(Field__c f : newFields)
        {
            Object__c relatedObject = objectDetails.get(f.Object__c);
            f = ObjectAndFieldService.getFieldDetails(f, relatedObject.Name);
       		f.Number_of_Records_Populated__c = ObjectAndFieldService.getNumberOfRecordsForObjectWhereFieldNotNull(relatedObject.Name, f.Name);
        }
    }
}