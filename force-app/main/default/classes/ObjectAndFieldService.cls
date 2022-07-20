public class ObjectAndFieldService {
    
    public static final Map<String, Schema.SObjectType> DESCRIBEOBJECTS;
    static{
        DESCRIBEOBJECTS = Schema.getGlobalDescribe(); 
    }
    
    public static final Map<String, Object__c> OBJECTS;
    static{
        OBJECTS = New Map<String, Object__c>();
        For(Object__c obj : [SELECT Id, Name FROM Object__c])
        {
            OBJECTS.put(obj.Name, obj);
        }
    }
    
    public static void getAndInsertAllObjectsFromSchema(Boolean createable)
    {
        List<Object__c> objects = new List<Object__c>();
        for(Schema.SObjectType d : DESCRIBEOBJECTS.values())
        {
            Schema.DescribeSObjectResult ds = d.getDescribe();
            if(ds.isCreateable() == createable)
            {
                Object__c obj = new Object__c(Name = ds.name);
                objects.add(obj);
            }
        }
        insert objects;
    }
    
    public static void getFieldsForObject(string objName)
    {            
        
        Schema.DescribeSObjectResult r1 = DESCRIBEOBJECTS.get(objName).getDescribe();   
        
        Object__c objectRecord = OBJECTS.get(objName);
        
        if(objectRecord == NULL)
        {
            Object__c newObjectRecord = new Object__c(Name = r1.getName());
            insert newObjectRecord;
            objectRecord = newObjectRecord;
        }
        
        
        List<Field__c> fields = new List<Field__c>();
        
        Map<String , Schema.SObjectField > mapFieldList = r1.fields.getMap();    
        for ( Schema.SObjectField field : mapFieldList.values() ) {    
            Schema.DescribeFieldResult fieldResult = field.getDescribe();    
            
            System.debug(fieldResult.getName());
            Field__c f = new Field__c();
            f.Name = fieldResult.getName();
            f.Label__c = fieldResult.getLabel();
            f.Type__c = String.valueOf(fieldResult.getType());
            f.Object__c = objectRecord.Id;
            fields.add(f);
            
        }
        
        List<Database.SaveResult> insertResults = Database.insert(fields, false);
    }
    
    
    public static object__c getObjectDetails(object__c obj)
    {
        if(obj.Name != Null)
        {        Schema.SObjectType objectType = Schema.getGlobalDescribe().get(obj.Name);
            Schema.DescribeSObjectResult schemaObject = objectType.getDescribe();       
            obj.Label__c = schemaObject.getLabel();
            obj.Custom__c = schemaObject.isCustom();
            obj.Number_of_Fields__c = schemaObject.fields.getMap().values().size();  
        }   
        return obj;  
    }
    
    public static field__c getFieldDetails(field__c f, string objectName)
    {
        if((f != null) && (objectName != null))
        {
            Schema.DescribeSObjectResult objectDetails = DESCRIBEOBJECTS.get(objectName).getDescribe();   
            Schema.SObjectField fieldDetails = objectDetails.fields.getMap().get(f.name);
            
            Schema.DescribeFieldResult fieldResult = fieldDetails.getDescribe();    
            if ( fieldResult.isAccessible() ) {    
                System.debug(fieldResult.getName());
                f.Name = fieldResult.getName();
                f.Label__c = fieldResult.getLabel();
                f.Type__c = String.valueOf(fieldResult.getType());
                f.Custom__c = fieldResult.isCustom();
            }
        }
        return f;
    }
    
    
    public static integer getFieldCountForObject(string objName)
    {           
        if(OBJECTS.containsKey(objName))
        { 
            integer numberOfFields;
            try{
                numberOfFields = DESCRIBEOBJECTS.get(objName).getDescribe().fields.getMap().values().size();   
            }
            catch(Exception e)
            {
                numberOfFields = Null;
            }
            return numberOfFields;
        }
        return Null;
    }
    
    public static integer getNumberOfRecordsForObjectWhereFieldNotNull(string objectName, string fieldName)
    {    
        try{
            AggregateResult[] groupedResults = Database.query('SELECT COUNT(Id)recordCount FROM ' + objectName + ' WHERE ' + fieldName + ' != NULL');
            return Integer.valueOf(groupedResults[0].get('recordCount'));
        }
        catch(Exception e)
        {
            return null;
        }
    }
    
}