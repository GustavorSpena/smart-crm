public with sharing class LeadDashboardController {

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getDashboardData() {

        Integer totalLeads = [SELECT COUNT() FROM Lead WHERE IsConverted = false];

        List<Lead> hotLeads = [
            SELECT Id, Name, Company, Email, Score__c,
                   AI_Suggestion__c, LeadSource, Industry
            FROM Lead
            WHERE IsConverted = false
            AND Score__c >= 70
            ORDER BY Score__c DESC
            LIMIT 5
        ];

        List<AggregateResult> byStatus = [
            SELECT Status, COUNT(Id) total
            FROM Lead
            WHERE IsConverted = false
            GROUP BY Status
        ];

        AggregateResult avgScoreResult = [
            SELECT AVG(Score__c) avgScore
            FROM Lead
            WHERE IsConverted = false
            AND Score__c != null
        ];

        Integer leadsToday = [
            SELECT COUNT()
            FROM Lead
            WHERE CreatedDate = TODAY
        ];

        // Formata byStatus para o gráfico
        List<Map<String, Object>> statusData = new List<Map<String, Object>>();
        for (AggregateResult ar : byStatus) {
            statusData.add(new Map<String, Object>{
                'status' => (String) ar.get('Status'),
                'total'  => (Integer) ar.get('total')
            });
        }

        return new Map<String, Object>{
            'totalLeads'  => totalLeads,
            'hotLeads'    => hotLeads,
            'statusData'  => statusData,
            'avgScore'    => avgScoreResult.get('avgScore'),
            'leadsToday'  => leadsToday
        };
    }
}