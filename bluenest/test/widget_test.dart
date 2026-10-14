import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bluenest/core/dev_config.dart';
import 'package:bluenest/main.dart';

void main() {
  setUp(() {
    DevConfig.bypassLogin = true;
  });

  testWidgets('Resident Dashboard smoke test - Full Flow', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const BlueNestApp());
    await tester.pumpAndSettle();

    // Verify WelcomeScreen loaded
    expect(find.text("I'm looking for a home"), findsOneWidget);

    // Tap on tenant role
    await tester.tap(find.text("I'm looking for a home"));
    await tester.pumpAndSettle();

    // Verify AuthScreen is loaded with Sign up prompt
    expect(find.text('Continuing as a tenant'), findsOneWidget);
    expect(find.text("Don't have an account? "), findsOneWidget);
    expect(find.text('Sign up'), findsOneWidget);

    // Enter any id and password
    final textFields = find.byType(TextFormField);
    expect(textFields, findsNWidgets(2));
    await tester.enterText(textFields.first, 'anyuser');
    await tester.enterText(textFields.last, 'anypass');
    await tester.pumpAndSettle();

    // Tap Log in
    final loginBtn = find.widgetWithText(ElevatedButton, 'Log in');
    await tester.ensureVisible(loginBtn);
    await tester.tap(loginBtn);
    await tester.pumpAndSettle();

    // 1. Verify AppBar has 'Resident' (replaced Tenant Dashboard)
    expect(find.text('Resident'), findsOneWidget);

    // 2. Verify Cards on Home Dashboard
    expect(find.text('My Rental & Rent Dues'), findsOneWidget);
    expect(find.text('Search Properties'), findsOneWidget);

    // 3. Verify Fixed Bottom Bar exists with Home, Search, Settings (replaces Manage Account)
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);

    // 4. Verify Pay Now button is workable in My Rental & Rent Dues box
    final payBtn = find.widgetWithText(ElevatedButton, 'Pay Now');
    expect(payBtn, findsOneWidget);
    await tester.tap(payBtn);
    await tester.pumpAndSettle();
    expect(find.text('Paid'), findsOneWidget);
    // Verify the small text was removed completely
    expect(
        find.text(
            'Rent for the current period is paid. Tap diagonal arrow ↗ above to view receipt.'),
        findsNothing);

    // 5. Verify Explore button takes to Search Properties screen
    final exploreBtn = find.widgetWithText(ElevatedButton, 'Explore');
    expect(exploreBtn, findsOneWidget);
    await tester.tap(exploreBtn);
    await tester.pumpAndSettle();
    expect(find.text('Search by title, city or locality'), findsOneWidget);
    expect(find.text('Luxury 3 BHK Apartment in Indiranagar'), findsOneWidget);

    // 6. Verify tapping Home in bottom bar goes back to Home
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('Resident'), findsOneWidget);

    // 7. Verify tapping Settings on bottom bar switches to SettingsScreen
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Manage Account'), findsOneWidget);
    expect(find.text('Dark Mode'), findsOneWidget);
    expect(find.text('Contact Support'), findsOneWidget);
    expect(find.text('Log Out of BlueNest'), findsOneWidget);

    // 8. Test Dark Mode toggle
    final darkModeSwitch = find.byType(Switch);
    expect(darkModeSwitch, findsOneWidget);
    await tester.tap(darkModeSwitch);
    await tester.pumpAndSettle();
    expect(find.text('Aesthetic Dark UI active'), findsOneWidget);

    // 9. Open Manage Account from Settings
    await tester.tap(find.text('Manage Account'));
    await tester.pumpAndSettle();
    expect(find.text('Personal Information'), findsOneWidget);
    expect(find.text('Save Changes'), findsOneWidget);
  });

  testWidgets('Landlord Dashboard smoke test - Full Flow', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const BlueNestApp());
    await tester.pumpAndSettle();

    // Tap on landlord role
    await tester.tap(find.text('I manage properties'));
    await tester.pumpAndSettle();

    // Verify AuthScreen is loaded for landlord
    expect(find.text('Continuing as a landlord'), findsOneWidget);

    // Enter any id and password
    final textFields = find.byType(TextFormField);
    await tester.enterText(textFields.first, 'landlord_demo');
    await tester.enterText(textFields.last, 'secret');
    await tester.pumpAndSettle();

    // Tap Log in
    final loginBtn = find.widgetWithText(ElevatedButton, 'Log in');
    await tester.ensureVisible(loginBtn);
    await tester.tap(loginBtn);
    await tester.pumpAndSettle();

    // 1. Verify AppBar has ONLY 'Landlord' (removed Dashboard)
    expect(find.text('Landlord'), findsOneWidget);
    expect(find.text('Landlord Dashboard'), findsNothing);

    // 2. Verify circle profile bubble in top right
    expect(find.byKey(const Key('landlord_profile_bubble')), findsOneWidget);

    // 3. Verify Payment and Rent Record box at top
    expect(find.text('Payment & Rent Records'), findsOneWidget);
    expect(find.text('Rent Collected'), findsOneWidget);
    expect(find.text('Rent Pending'), findsOneWidget);

    // 4. Verify Action buttons below payment box
    expect(find.text('My Properties'), findsOneWidget);
    expect(find.text('Tenants & Leases'), findsOneWidget);

    // 5. Verify Fixed Bottom Bar: Properties on left, Home in center, Settings on right
    expect(find.text('Properties'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);

    // 6. Test diagonal arrow opens PaymentsRecordsScreen
    final diagonalArrow = find.byKey(const Key('open_payment_details_arrow'));
    expect(diagonalArrow, findsOneWidget);
    await tester.tap(diagonalArrow);
    await tester.pumpAndSettle();
    expect(find.text('Total Collected'), findsOneWidget);
    expect(find.text('Pending Dues'), findsOneWidget);

    // Pop back to Landlord Home
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Landlord'), findsOneWidget);

    // 7. Test bottom bar Left tab (Properties)
    await tester.tap(find.text('Properties'));
    await tester.pumpAndSettle();
    expect(find.text('Add Property'), findsOneWidget);

    // 8. Test bottom bar Right tab (Settings)
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Manage Account'), findsOneWidget);
    expect(find.text('Contact Support'), findsOneWidget);
    expect(find.text('Dark Mode'), findsOneWidget);
  });
}
