public class LeadAWSCallout {

    @future(callout=true)
    public static void sendLeadToAWS(String leadId) {

        Lead lead = [
            SELECT Id, Name, Phone, Title, Website,
                   LeadSource, NumberOfEmployees, Industry, Company
            FROM Lead
            WHERE Id = :leadId
            LIMIT 1
        ];

        Map<String, Object> leadMap = new Map<String, Object>{
            'id'         => lead.Id,
            'name'       => lead.Name,
            'company'    => lead.Company,
            'phone'      => lead.Phone,
            'title'      => lead.Title,
            'website'    => lead.Website,
            'leadSource' => lead.LeadSource,
            'employees'  => lead.NumberOfEmployees,
            'industry'   => lead.Industry
        };

        Map<String, Object> payload = new Map<String, Object>{
            'lead' => leadMap
        };

        String body = JSON.serialize(payload);

        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:AWS_Smart_CRM/score');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(body);
        req.setTimeout(30000);

        Http http = new Http();
        HttpResponse res = http.send(req);

       if (res.getStatusCode() == 200) {
            // O API Gateway retorna body aninhado — precisa parsear duas vezes
            Map<String, Object> outerResult = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            String innerBodyStr = (String) outerResult.get('body');
            Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(innerBodyStr);

            Integer awsScore          = Integer.valueOf(result.get('score'));
            String suggestion         = (String) result.get('suggestion');
            String emailDraft         = (String) result.get('emailDraft');

            Lead toUpdate = new Lead(
                Id                = leadId,
                Score__c          = awsScore,
                AI_Suggestion__c  = suggestion,
                AI_Email_Draft__c = emailDraft
            );

            TriggerContext.skipCallout = true;
            update toUpdate;
        }
    }
}