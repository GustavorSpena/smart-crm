@isTest
public class SmartCRMTest {
    private static Lead createTestLead(Boolean doInsert){

        Lead ld = new Lead(
            FirstName       = 'João',
            LastName        = 'Silva',
            Company         = 'Tech Solutions',
            Email           = 'joao@techsolutions.com',
            Phone           = '11999999999',
            Title           = 'CTO',
            Website         = 'www.techsolutions.com',
            LeadSource      = 'Referral',
            NumberOfEmployees = 200,
            Industry        = 'Technology'
            );

        if (doInsert) insert ld;
        return ld;
    }
    @isTest
    static void testName(){
        Lead ld = createTestLead(false);
        
        Test.startTest();
        insert ld;
        Test.stopTest();
    
        Lead result = [SELECT Score__c FROM Lead WHERE Id = :ld.Id];

        System.assertEquals(100, result.Score__c, 'error');
    }
    @isTest
    static void testMinimum(){
        Lead ld = new Lead(
            LastName        = 'Silva',
            Company         = 'Tech Solutions',
            Email           = 'joao@techsolutions.com',
            LeadSource      = 'Web'
            );       
        
        Test.startTest();
        insert ld;
        Test.stopTest();

        Lead result = [SELECT Score__c FROM Lead WHERE Id = :ld.Id];

        System.assertEquals(20, result.Score__c, 'error');
    }

    @isTest
    static void testEmail(){
        Lead ld = new Lead(
            LastName        = 'Silva',
            Company         = 'Tech Solutions',
            LeadSource      = 'Web'
        ); 

         Test.startTest();

        try {
            insert ld;
            System.assert(false, 'Should throw exception');
        } catch (DmlException e) {
            System.assert(
                e.getMessage().contains('Email required'),
                'Incorrect error message'
            );
        }
        Test.stopTest();
    }

        @isTest
    static void testCompany(){
        Lead ld = new Lead(
            LastName        = 'Silva',
            LeadSource      = 'Web',
            Email           = 'joao@techsolutions.com'
        ); 

         Test.startTest();

        try {
            insert ld;
            System.assert(false, 'Should throw exception');
        } catch (DmlException e) {
            System.assert(
                e.getMessage().contains('Company required'),
                'Incorrect error message'
            );
        }
        Test.stopTest();
    }

    @isTest
    static void testEmailFormat(){
        Lead ld = new Lead(
            LastName        = 'Silva',
            Company         = 'Tech Solutions',
            LeadSource      = 'Web',
            Email           = 'joaotechsolutions.com'
        ); 

        Test.startTest();

        try {
            insert ld;
            System.assert(false, 'Should throw exception');
        } catch (DmlException e) {
            System.assert(true, 'Exception thrown as expected');
        }
        Test.stopTest();
    }
    @isTest 
    static void testAWSCallout() {

        Lead ld = createTestLead(true);

        Test.setMock(HttpCalloutMock.class, new AWSCalloutMock());

        Test.startTest();
        LeadAWSCallout.sendLeadToAWS(ld.Id);
        Test.stopTest();

        Lead result = [
            SELECT Score__c, AI_Suggestion__c, AI_Email_Draft__c
            FROM Lead
            WHERE Id = :ld.Id
        ];

        System.assertEquals(100, result.Score__c, 'Score should be updated from mock response');
        System.assertNotEquals(null, result.AI_Suggestion__c, 'AI Suggestion should be populated');
        System.assertNotEquals(null, result.AI_Email_Draft__c, 'AI Email Draft should be populated');
    }

    
}