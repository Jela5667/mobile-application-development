import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parking_management_app/models/parking_slot.dart';
import 'package:parking_management_app/models/vehicle.dart';
import 'package:parking_management_app/widgets/parking_slot_card.dart';
import 'package:parking_management_app/widgets/stat_card.dart';
import 'package:parking_management_app/widgets/vehicle_list_item.dart';

void main() {
  testWidgets('StatCard renders title and value', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StatCard(
            title: 'Available Slots',
            value: '15',
            icon: Icons.local_parking,
          ),
        ),
      ),
    );

    expect(find.text('Available Slots'), findsOneWidget);
    expect(find.text('15'), findsOneWidget);
  });

  testWidgets('ParkingSlotCard displays available status correctly', (WidgetTester tester) async {
    final slot = ParkingSlot(slotNumber: 'P01', status: 'available');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ParkingSlotCard(slot: slot),
        ),
      ),
    );

    expect(find.text('P01'), findsOneWidget);
    expect(find.text('FREE'), findsOneWidget);
    expect(find.text('Tap to Assign'), findsOneWidget);
  });

  testWidgets('VehicleListItem displays vehicle details', (WidgetTester tester) async {
    final vehicle = Vehicle(
      id: 1,
      ownerName: 'Alice Smith',
      vehicleNumber: 'XYZ-999',
      vehicleType: 'Car',
      contact: '555-0199',
      createdAt: '2025-01-01',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VehicleListItem(
            vehicle: vehicle,
            onEdit: () {},
            onDelete: () {},
          ),
        ),
      ),
    );

    expect(find.text('XYZ-999'), findsOneWidget);
    expect(find.text('Alice Smith'), findsOneWidget);
    expect(find.text('555-0199'), findsOneWidget);
  });
}
