public with sharing class LeadListController {

    @AuraEnabled(cacheable=true)
    public static List<Lead> getLeads(){
       return [
        SELECT Id,Name,Email,Company,Phone,Score__c
        FROM Lead
        WHERE IsConverted = false
        ORDER BY Score__c DESC NULLS LAST
        LIMIT 50
       ];
    }
}