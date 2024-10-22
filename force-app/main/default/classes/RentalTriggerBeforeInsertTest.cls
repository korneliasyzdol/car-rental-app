@isTest
private class RentalTriggerBeforeInsertTest {

    @isTest
    static void checkVehicleAvailabilityBeforeInsert() {
        SetupData sd = new Setupdata();

        sd.prepareDataForTest();
        Test.startTest();
        try {
            insert new Rental__c(
                Name = 'rental0',
                Start_date__c = Date.newInstance(2024, 08, 03),
                End_date__c = Date.newInstance(2024, 08, 07),
                Vehicle__c = sd.getVehicleForTest()
            );
            System.assert(false, 'Expected an exception due to trigger error');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains(Label.Rental_date_not_available));
        }
        
        Test.stopTest();

        List<Rental__c> insertedRentals = [
            SELECT Id, Name, Vehicle__c, Start_date__c, End_date__c 
            FROM Rental__c 
            WHERE Id =:sd.rentals
        ];
        System.debug('faza ' + json.serializePretty(insertedRentals));

    }

    public class SetupData {
        private List<Vehicle__c> vehicles;
        public List<Rental__c> rentals;

        public void prepareDataForTest() {
            this.setTestVehicles();
            insert this.vehicles;
            this.setTestRentals();
            insert this.rentals;
        }

        private void setTestVehicles() {
            this.vehicles = new List<Vehicle__c>{
                new Vehicle__c(Name = 'BMW'),
                new Vehicle__c(Name = 'Audi')
            };
        }

        public Id getVehicleForTest() {
            return this.vehicles[0].Id;
        }

        private void setTestRentals() {
            this.rentals = new List<Rental__c>{
                new Rental__c(
                    Name = 'rental1',
                    Start_date__c = Date.newInstance(2024, 08, 01),
                    End_date__c = Date.newInstance(2024, 08, 04),
                    Vehicle__c = this.vehicles[0].Id
                ),
                new Rental__c(
                    Name = 'rental2',
                    Start_date__c = Date.newInstance(2024, 08, 06),
                    End_date__c = Date.newInstance(2024, 08, 08),
                    Vehicle__c = this.vehicles[0].Id
                ),
                new Rental__c(
                    Name = 'rental3',
                    Start_date__c = Date.newInstance(2024, 08, 10),
                    End_date__c = Date.newInstance(2024, 08, 20),
                    Vehicle__c = this.vehicles[0].Id
                )
            };
        }
    }  
}

