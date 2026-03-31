public class LeadScoreHandler {

    public static void handle(List<Lead> leads) {
        for (Lead ld : leads) {

            // ── VALIDAÇÕES ────────────────────────────────
            if (String.isBlank(ld.Email)) {
                ld.addError('Email é obrigatório para cadastrar um Lead.');
            }

            if (String.isBlank(ld.Company)) {
                ld.addError('Empresa é obrigatória para cadastrar um Lead.');
            }

            if (!String.isBlank(ld.Email) && !ld.Email.contains('@')) {
                ld.addError('Email inválido — verifique o formato.');
            }

            // ── SCORE ─────────────────────────────────────
            Integer score = 0;

            if (!String.isBlank(ld.Phone))   score += 20;
            if (!String.isBlank(ld.Title))   score += 15;
            if (!String.isBlank(ld.Website)) score += 10;

            if (ld.LeadSource == 'Web')   score += 20;
            if (ld.LeadSource == 'Word of mouth' || ld.LeadSource == 'Other') score += 30;

            if (ld.NumberOfEmployees != null && ld.NumberOfEmployees > 100) score += 25;
            if (ld.NumberOfEmployees != null && ld.NumberOfEmployees > 500) score += 10;

            if (ld.Industry == 'Technology') score += 15;

            ld.Score__c = Math.min(score, 100);
        }
    }
}