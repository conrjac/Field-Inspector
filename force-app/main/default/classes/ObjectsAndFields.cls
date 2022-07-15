public class ObjectsAndFields {
    
    /*
https://jungleeforce.wordpress.com/2013/06/07/extracting-list-of-all-the-objects-standard-custom-in-salesforce/
https://salesforce.stackexchange.com/questions/48920/dynamic-picklists-of-objects-its-fields/48936#48936
https://salesforce.stackexchange.com/questions/100668/retrieve-api-names-of-all-object-in-salesforce-org-using-soql
https://developer.secure.force.com/cookbook/recipe/retrieve-a-list-of-objects-using-apex
http://www.infallibletechie.com/2015/08/how-to-get-all-field-names-in-all.html  
*/
    
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
        
        // Schema.DescribeSObjectResult r1 = objectType.getDescribe();   
        // r1.getName()
        
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
            if ( fieldResult.isAccessible() ) {    
                System.debug(fieldResult.getName());
                Field__c f = new Field__c();
                f.Name = fieldResult.getName();
                f.Label__c = fieldResult.getLabel();
                f.Type__c = String.valueOf(fieldResult.getType());
                fields.add(new Field__c());
            }   
        }
        Insert fields;
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
        
        Map<String, Schema.SObjectType> m = Schema.getGlobalDescribe() ;
        Schema.SObjectType objectType = m.get(objName);
        Schema.DescribeSObjectResult r1 = objectType.getDescribe();   
        List<Schema.SObjectField> fields = r1.fields.getMap().values();
        
        return fields.size();
    }
    
    
    
    
    public static integer getNumberOfRecordsForObject(string objectName)
    {
        AggregateResult[] groupedResults = Database.query('SELECT COUNT(Id)recordCount FROM ' + objectName );
        return Integer.valueOf(groupedResults[0].get('recordCount'));
    }
    
    public static integer getNumberOfRecordsForObjectWhereFieldNotNull(string objectName, string fieldName)
    {    
        AggregateResult[] groupedResults = Database.query('SELECT COUNT(Id)recordCount FROM ' + objectName + ' WHERE ' + fieldName + ' != NULL');
        return Integer.valueOf(groupedResults[0].get('recordCount'));
    }
    
    
    /*
public static void getFieldsForObject(Schema.SObjectType objectType)
{
List < Schema.SObjectType > gd = Schema.getGlobalDescribe().Values();      
Map<String , Schema.SObjectType > globalDescription = Schema.getGlobalDescribe();   

for ( Schema.SObjectType f : gd ) {  

Schema.sObjectType objType = globalDescription.get(f.getDescribe().getName() );  
Schema.DescribeSObjectResult r1 = objType.getDescribe();   
Map<String , Schema.SObjectField > mapFieldList = r1.fields.getMap();    

for ( Schema.SObjectField field : mapFieldList.values() ) {    

Schema.DescribeFieldResult fieldResult = field.getDescribe();    

if ( fieldResult.isAccessible() ) {    

System.debug('Field Name is ' + objType + '.' + fieldResult.getName() );  

}   

}  

}
}
*/
}