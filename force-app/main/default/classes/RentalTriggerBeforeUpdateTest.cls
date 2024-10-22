@isTest
private class RentalTriggerBeforeUpdateTest {

    @isTest
    static void checkVehicleAvailabilityBeforeUpdate() {
        SetupData sd = new SetupData();
        sd.prepareDataForTest();

        Test.startTest();
        try {
            sd.rentals[0].Start_date__c = Date.newInstance(2024, 08, 03);
            sd.rentals[0].End_date__c = Date.newInstance(2024, 08, 08);
            update sd.rentals;
            Assert.fail('Expected an exception due to trigger error');
        } catch (DmlException e) {
            Assert.isTrue(e.getMessage().contains(Label.Rental_date_not_available));
        }
        Test.stopTest();

        List<Rental__c> updatedRentals = [
            SELECT Id, Name, Vehicle__c, Start_date__c, End_date__c
            FROM Rental__c
            WHERE Id =:sd.rentals
        ];
        
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
            this.vehicles = new List<Vehicle__c> {
                new Vehicle__c(Name = 'BMW'),
                new Vehicle__c(Name = 'Audi')
            };
        }

        public Id getVehicleForTest() {
            return this.vehicles[0].Id;
        }

        private void setTestRentals() {
            this.rentals = new List<Rental__c> {
                new Rental__c(
                    Name = 'rental1',
                    Start_date__c = Date.newInstance(2024, 08, 01),
                    End_date__c = Date.newInstance(2024, 08, 07),
                    Vehicle__c = vehicles[0].Id
                ),
                new Rental__c(
                    Name = 'rental2',
                    Start_Date__c = Date.newInstance(2024, 08, 07),
                    End_Date__c = Date.newInstance(2024, 08, 13),
                    Vehicle__c = vehicles[0].Id
                ),
                new Rental__c(
                    Name = 'rental3',
                    Start_Date__c = Date.newInstance(2024, 08, 20),
                    End_Date__c = Date.newInstance(2024, 08, 25),
                    Vehicle__c = vehicles[0].Id
                )
            };
        }
    }
}