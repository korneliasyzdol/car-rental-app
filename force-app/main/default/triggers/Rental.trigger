trigger Rental on Rental__c (before insert, before update) {
    if (Trigger.isInsert) {
        if (Trigger.isBefore) {
            RentalTriggerBeforeInsert beforeInsert = new RentalTriggerBeforeInsert(Trigger.new);
            beforeInsert.handleBeforeInsert();
        }  
    }
    if (Trigger.isUpdate) {
        if (Trigger.isBefore) {
            RentalTriggerBeforeUpdate beforeUpdate = new RentalTriggerBeforeUpdate(Trigger.new, Trigger.oldMap);
            beforeUpdate.handleBeforeUpdate();  
        }
    }
}