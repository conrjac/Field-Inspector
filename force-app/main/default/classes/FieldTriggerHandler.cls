public class FieldTriggerHandler implements TriggerHandler {
    
    
    
    public void beforeInsert(List<Field__c> newObjects) {
        
        updateFieldUsageCounts(newObjects);
    }
    public void beforeUpdate(List<Field__c> oldObjects, List<Field__c> newObjects, Map<ID, SObject> oldAccountMap, Map<ID, SObject> newAccountMap) {
       updateFieldUsageCounts(newObjects);
    }
    public void beforeDelete(List<Field__c> oldAccounts, Map<ID, SObject> oldAccountMap) {
        
    }
    public void afterInsert(List<Field__c> newAccounts, Map<ID, SObject> newAccountMap) {
        
    }
    public void afterUpdate(List<Field__c> oldAccounts, List<Field__c> newAccounts, Map<ID, SObject> oldAccountMap, Map<ID, SObject> newAccountMap) {
        
    }
    public void afterDelete(List<Field__c> oldAccounts, Map<ID, SObject> oldAccountMap) {
    }
    public void afterUndelete(List<Field__c> newAccounts, Map<ID, SObject> newAccountMap) {
        
        
    }
    
    
    public static void updateFieldUsageCounts(List<Field__c> newObjects)
    {
        
        Map<Id, Object__c> objectDetails = New Map<Id, Object__c>([SELECT Id, Name FROM Object__c]);
        
        for(Field__c f : newObjects)
        {
                        Object__c relatedObject = objectDetails.get(f.Object__c);
            f = ObjectsAndFields.getFieldDetails(f, relatedObject.Name);

       		f.Number_of_Records_Populated__c = ObjectsAndFields.getNumberOfRecordsForObjectWhereFieldNotNull(relatedObject.Name, f.Name);
            
             
            
        }
    }
    
    
    
}