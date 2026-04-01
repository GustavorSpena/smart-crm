public class LeadScoreHandler {

    public static void handle(List<Lead> leads) {
        for (Lead ld : leads) {

            // ── VALIDAÇÕES ────────────────────────────────
            if (String.isBlank(ld.Email)) {
                ld.addError('Email required');
            }

            if (String.isBlank(ld.Company)) {
                ld.addError('Company required');
            }

            if (!String.isBlank(ld.Email) && !ld.Email.contains('@')) {
                ld.addError('Email format invalid');
            }

            // ── SCORE ─────────────────────────────────────
            Integer score = 0;

            if (!String.isBlank(ld.Phone))   score += 20;
            if (!String.isBlank(ld.Title))   score += 15;
            if (!String.isBlank(ld.Website)) score += 10;

            if (ld.LeadSource == 'Web')   score += 20;
            if (ld.LeadSource == 'Word of mouth' || ld.LeadSource == 'Other' || ld.LeadSource == 'Referral') score += 30;

            if (ld.NumberOfEmployees != null && ld.NumberOfEmployees > 100) score += 25;
            if (ld.NumberOfEmployees != null && ld.NumberOfEmployees > 500) score += 10;

            if (ld.Industry == 'Technology') score += 15;

            ld.Score__c = Math.min(score, 100);
        }
    }
}