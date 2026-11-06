import 'package:flutter_test/flutter_test.dart';
import 'package:parking_management_app/models/parking_settings.dart';
import 'package:parking_management_app/models/parking_slot.dart';
import 'package:parking_management_app/models/vehicle.dart';
import 'package:parking_management_app/services/parking_service.dart';

void main() {
  group('Parking Fee Calculation Tests', () {
    test('Zero or 5 minute duration charges minimum 1 hour rate', () {
      final entry = DateTime(2025, 1, 1, 10, 0);
      final exit = DateTime(2025, 1, 1, 10, 5);

      final result = ParkingService.calculateFeeAndDuration(
        entryTime: entry,
        exitTime: exit,
        hourlyRate: 10.0,
      );

      expect(result['durationMinutes'], 5);
      expect(result['hoursCharged'], 1);
      expect(result['totalFee'], 10.0);
    });

    test('65 minutes duration rounds up to 2 hours charge', () {
      final entry = DateTime(2025, 1, 1, 10, 0);
      final exit = DateTime(2025, 1, 1, 11, 5);

      final result = ParkingService.calculateFeeAndDuration(
        entryTime: entry,
        exitTime: exit,
        hourlyRate: 10.0,
      );

      expect(result['durationMinutes'], 65);
      expect(result['hoursCharged'], 2);
      expect(result['totalFee'], 20.0);
    });

    test('Exactly 120 minutes duration charges 2 hours', () {
      final entry = DateTime(2025, 1, 1, 10, 0);
      final exit = DateTime(2025, 1, 1, 12, 0);

      final result = ParkingService.calculateFeeAndDuration(
        entryTime: entry,
        exitTime: exit,
        hourlyRate: 5.0,
      );

      expect(result['durationMinutes'], 120);
      expect(result['hoursCharged'], 2);
      expect(result['totalFee'], 10.0);
    });

    test('Throws ArgumentError if exit time is before entry time', () {
      final entry = DateTime(2025, 1, 1, 10, 0);
      final exit = DateTime(2025, 1, 1, 9, 30);

      expect(
        () => ParkingService.calculateFeeAndDuration(
          entryTime: entry,
          exitTime: exit,
          hourlyRate: 10.0,
        ),
        throwsArgumentError,
      );
    });
  });

  group('Model Mapping & Helper Tests', () {
    test('Vehicle serialization & deserialization', () {
      final vehicle = Vehicle(
        id: 1,
        ownerName: 'John Doe',
        vehicleNumber: 'ABC-1234',
        vehicleType: 'Car',
        contact: '1234567890',
        createdAt: '2025-01-01T10:00:00',
      );

      final map = vehicle.toMap();
      expect(map['owner_name'], 'John Doe');
      expect(map['vehicle_number'], 'ABC-1234');

      final deserialized = Vehicle.fromMap(map);
      expect(deserialized.id, 1);
      expect(deserialized.ownerName, 'John Doe');
      expect(deserialized.vehicleNumber, 'ABC-1234');
      expect(deserialized.vehicleType, 'Car');
    });

    test('ParkingSlot availability status helper', () {
      final slotAvailable = ParkingSlot(slotNumber: 'P01', status: 'available');
      final slotOccupied = ParkingSlot(slotNumber: 'P02', status: 'occupied');

      expect(slotAvailable.isAvailable, true);
      expect(slotAvailable.isOccupied, false);

      expect(slotOccupied.isAvailable, false);
      expect(slotOccupied.isOccupied, true);
    });

    test('ParkingSettings rates by vehicle type', () {
      const settings = ParkingSettings(
        carRate: 12.0,
        motorcycleRate: 6.0,
        otherRate: 18.0,
      );

      expect(settings.getRateForType('Car'), 12.0);
      expect(settings.getRateForType('Motorcycle'), 6.0);
      expect(settings.getRateForType('Other'), 18.0);
    });
  });
}
