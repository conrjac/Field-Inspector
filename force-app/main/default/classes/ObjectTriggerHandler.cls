public class ObjectTriggerHandler implements TriggerHandler {
    
    public void beforeInsert(List<Object__c> newObjects) {
        
        for(Object__c o : newObjects)
        {
            o.Number_of_Records__c = ObjectAndFieldService.getNumberOfRecordsForObjectWhereFieldNotNull(o.Name, 'Id');
            o = ObjectAndFieldService.getObjectDetails(o);
        }
    }
    public void beforeUpdate(List<Object__c> oldObjects, List<Object__c> newObjects, Map<ID, SObject> oldAccountMap, Map<ID, SObject> newAccountMap) {
        for(Object__c o : newObjects)
        {
            o = ObjectAndFieldService.getObjectDetails(o);
            
            o.Number_of_Records__c = ObjectAndFieldService.getNumberOfRecordsForObjectWhereFieldNotNull(o.Name, 'Id');
            
            o.Number_of_Fields__c = ObjectAndFieldService.getFieldCountForObject(o.Name);
        }
    }
    public void beforeDelete(List<Object__c> oldAccounts, Map<ID, SObject> oldAccountMap) {
        
    }
    public void afterInsert(List<Object__c> newAccounts, Map<ID, SObject> newAccountMap) {
        
    }
    public void afterUpdate(List<Object__c> oldAccounts, List<Object__c> newAccounts, Map<ID, SObject> oldAccountMap, Map<ID, SObject> newAccountMap) {
        
    }
    public void afterDelete(List<Object__c> oldAccounts, Map<ID, SObject> oldAccountMap) {
    }
    public void afterUndelete(List<Object__c> newAccounts, Map<ID, SObject> newAccountMap) {
        
        
    }
    
    
}