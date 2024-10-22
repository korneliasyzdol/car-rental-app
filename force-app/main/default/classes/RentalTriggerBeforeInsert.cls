public with sharing class RentalTriggerBeforeInsert {
    private List<Rental__c> newRentals;
    private Set<String> vehicleIdSet = new Set<String>();

    public RentalTriggerBeforeInsert(List<Rental__c> newRentals) {
        this.newRentals = newRentals;
    }

    public void handleBeforeInsert() {
        this.setRentalIdSet();
        this.checkVehicleAvailabilityAgainstExistingRentals();
        this.checkOverlappingNewRentals();
    }

    public void setRentalIdSet() {
        for (Rental__c r : newRentals) {
                vehicleIdSet.add(r.Vehicle__c);
            }
    }
    
    private List<Rental__c> queryRentals(){
        List<Rental__c> existingRentals = [SELECT Vehicle__c, Start_date__c, End_date__c
             FROM Rental__c WHERE Vehicle__c IN :vehicleIdSet];
        return existingRentals;
    }

    private void checkOverlappingNewRentals() {
        for (Integer i = 0; i < newRentals.size(); i++) {
            for (Integer j = i + 1; j < newRentals.size(); j++) {
                if (newRentals[i].Vehicle__c == newRentals[j].Vehicle__c) {
                    if (newRentals[j].Start_date__c > newRentals[j].Start_date__c && newRentals[j].Start_date__c < newRentals[i].End_date__c) {
                        newRentals[j].Start_date__c.addError(Label.Rental_date_not_available);
                    } else if (newRentals[j].End_date__c > newRentals[i].Start_date__c && newRentals[j].End_date__c < newRentals[i].End_date__c) {
                        newRentals[j].End_date__c.addError(Label.Rental_date_not_available);
                    } else if (newRentals[j].Start_date__c < newRentals[i].Start_date__c && newRentals[j].End_date__c > newRentals[i].End_date__c) {
                        newRentals[j].Start_date__c.addError(Label.Rental_date_not_available);
                        newRentals[j].End_date__c.addError(Label.Rental_date_not_available);
                    } else if (newRentals[i].Start_date__c == newRentals[j].Start_date__c) {
                        newRentals[j].Start_date__c.addError(Label.Rental_date_not_available);
                    } else if (newRentals[i].End_date__c == newRentals[j].End_date__c) {
                        newRentals[j].End_date__c.addError(Label.Rental_date_not_available);
                    }
                }
            }
        }
    }

    private void checkVehicleAvailabilityAgainstExistingRentals() {
        List<Rental__c> existingRentals = this.queryRentals();
        for (Rental__c rOld : existingRentals) {
            for (Rental__c rNew : newRentals) { 
                if (rOld.Vehicle__c == rNew.Vehicle__c) {
                    if (rNew.Start_date__c > rOld.Start_date__c && rNew.Start_date__c < rOld.End_date__c) {
                        rNew.Start_date__c.addError(Label.Rental_date_not_available);
                    } else if (rNew.End_date__c > rOld.Start_date__c && rNew.End_date__c < rOld.End_date__c) {
                        rNew.End_date__c.addError(Label.Rental_date_not_available);
                    } else if (rNew.Start_date__c < rOld.Start_date__c && rNew.End_date__c > rOld.End_date__c) {
                        rNew.Start_date__c.addError(Label.Rental_date_not_available);
                        rNew.End_date__c.addError(Label.Rental_date_not_available);
                    } else if (rOld.Start_date__c == rNew.Start_date__c) {
                        rNew.Start_date__c.addError(Label.Rental_date_not_available);
                    } else if (rOld.End_date__c == rNew.End_date__c) {
                        rNew.End_date__c.addError(Label.Rental_date_not_available);
                    }
                }
            }
        }
    }
}
