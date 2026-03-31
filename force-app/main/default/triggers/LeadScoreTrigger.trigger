trigger LeadScoreTrigger on Lead (before insert, before update, after update) {

    if (Trigger.isBefore) {
        LeadScoreHandler.handle(Trigger.new);
    }

    if (Trigger.isAfter && Trigger.isUpdate && !TriggerContext.skipCallout) {
        for (Lead lead : Trigger.new) {
            LeadAWSCallout.sendLeadToAWS(lead.Id);
        }
    }
}