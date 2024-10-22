public with sharing class RentalTriggerBeforeUpdate {
    private List<Rental__c> newRentals;
    private Map<Id, Rental__c> oldRentalsMap;
    private List<Rental__c> rentalsBeforeUpdate = new List<Rental__c>();
    private Set<Id> rentalsId = Trigger.newMap.keySet();

    public RentalTriggerBeforeUpdate(List<Rental__c> newRentals, Map<Id, Rental__c> oldRentalsMap) {
        this.newRentals = newRentals;
        this.oldRentalsMap = oldRentalsMap;
    }

    public void handleBeforeUpdate() {
        this.setRentalsForUpdate();
        this.checkVehicleAvailability();
    }

    private void setRentalsForUpdate() {
        for(Rental__c rNew : newRentals) {
            Rental__c oldRental = oldRentalsMap.get(rNew.Id);
            if(rNew.Start_date__c != oldRental.Start_date__c
                || rNew.End_date__c != oldRental.End_date__c
                || rNew.Vehicle__c != oldRental.Vehicle__c
            ) {
                rentalsBeforeUpdate.add(rNew);
            }
            }
    }

    private List<Rental__c> setRentalsToCompare() {
        List<Rental__c> rentalsToCompare = [
            SELECT Vehicle__c, Start_date__c, End_date__c
            FROM Rental__c
            WHERE Id NOT IN :rentalsBeforeUpdate
        ];
        rentalsToCompare.addAll(rentalsBeforeUpdate);
        return rentalsToCompare;
    }

    private void checkVehicleAvailability() {
        List<Rental__c> rentalsToCompare = this.setRentalsToCompare();
        for (Rental__c comparedRental : rentalsToCompare) {
            for (Rental__c rental : this.rentalsBeforeUpdate) {
                if (comparedRental.Id == rental.Id) {
                    continue;
                }
                if (comparedRental.Vehicle__c == rental.Vehicle__c) {
                    if (rental.Start_date__c > comparedRental.Start_date__c && rental.Start_date__c < comparedRental.End_date__c) {
                        rental.Start_date__c.addError(Label.Rental_date_not_available);
                    } else if (rental.End_date__c > comparedRental.Start_date__c && rental.End_date__c < comparedRental.End_date__c) {
                        rental.End_date__c.addError(Label.Rental_date_not_available);
                    } else if (rental.Start_date__c < comparedRental.Start_date__c && rental.End_date__c > comparedRental.End_date__c) {
                        rental.Start_date__c.addError(Label.Rental_date_not_available);
                    } else if (comparedRental.Start_date__c == rental.Start_date__c) {
                        rental.Start_date__c.addError(Label.Rental_date_not_available);    
                    } else if (comparedRental.End_date__c == rental.End_date__c) {
                        rental.End_date__c.addError(Label.Rental_date_not_available);
                    }
                }
            }
        }
    }   
}