public class ObjectsAndFields {
    
    public static void getObjects()
    {
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
        Set<String> standardObjects = new Set<String>();
        Set<String> customObjects = new Set<String>();
        for(Schema.SObjectType d : gd.values())
        {
            Schema.DescribeSObjectResult ds = d.getDescribe();
            if(!ds.isCreateable())
                continue;
            if(ds.isCustom() == false && ds.getRecordTypeInfos().size() > 0)
                standardObjects.add(ds.getName());
            else if(ds.isCustom())
                customObjects.add(ds.getName());
        }
        List<String> sortedNames = new List<String>(customObjects);
        sortedNames.sort();
        for(String name : sortedNames)
            System.debug('Custom object: ' + name);
        sortedNames = new List<String>(standardObjects);
        sortedNames.sort();
        for(String name : sortedNames)
            System.debug('Standard object: ' + name);
        
    }
    
    public static void getFieldsForObject(string objName)
    {            
        
        Map<String, Schema.SObjectType> m = Schema.getGlobalDescribe() ;
        Schema.SObjectType objectType = m.get(objName);
        
        Schema.DescribeSObjectResult r1 = objectType.getDescribe();   
        
        Object__c objectRecord = [SELECT Id, Name FROM Object__c WHERE Name = :r1.getName() LIMIT 1];
        
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
    
    
    public static field__c getFieldDetails(field__c f, string objectName)
    {
        if((f != null) && (objectName != null))
        {
            
            
            Schema.DescribeSObjectResult objectDetails = Schema.getGlobalDescribe().get(objectName).getDescribe();   
            Schema.SObjectField fieldDetails = objectDetails.fields.getMap().get(f.name);
            
            Schema.DescribeFieldResult fieldResult = fieldDetails.getDescribe();    
            if ( fieldResult.isAccessible() ) {    
                System.debug(fieldResult.getName());
                f.Name = fieldResult.getName();
                f.Label__c = fieldResult.getLabel();
                f.Type__c = String.valueOf(fieldResult.getType());
            }
        }
        return f;
    }
    
    
    public static integer getFieldCountForObject(string objName)
    {            
        integer numberOfFields;
        try{
            numberOfFields = Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap().values().size();   
        }
        catch(Exception e)
        {
            numberOfFields = Null;
        }
        return numberOfFields;
    }
    
    
    
    
    public static integer getNumberOfRecordsForObject(string objectName)
    {   
        try{     
        AggregateResult[] groupedResults = Database.query('SELECT COUNT(Id)recordCount FROM ' + objectName );
        return Integer.valueOf(groupedResults[0].get('recordCount'));
        }
        catch(Exception e)
        {
            return null;
        }
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