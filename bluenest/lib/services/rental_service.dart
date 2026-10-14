import 'package:flutter/material.dart';

enum RentalStatus {
  pending,
  paid,
  noPropertyLeased,
}

class RentalInfo {
  final RentalStatus status;
  final String propertyTitle;
  final String propertyAddress;
  final num monthlyRent;
  final num dueAmount;
  final String dueDate;
  final String lastPaidDate;
  final String landlordName;
  final String leasePeriod;

  const RentalInfo({
    required this.status,
    required this.propertyTitle,
    required this.propertyAddress,
    required this.monthlyRent,
    required this.dueAmount,
    required this.dueDate,
    required this.lastPaidDate,
    required this.landlordName,
    required this.leasePeriod,
  });

  RentalInfo copyWith({
    RentalStatus? status,
    String? propertyTitle,
    String? propertyAddress,
    num? monthlyRent,
    num? dueAmount,
    String? dueDate,
    String? lastPaidDate,
    String? landlordName,
    String? leasePeriod,
  }) {
    return RentalInfo(
      status: status ?? this.status,
      propertyTitle: propertyTitle ?? this.propertyTitle,
      propertyAddress: propertyAddress ?? this.propertyAddress,
      monthlyRent: monthlyRent ?? this.monthlyRent,
      dueAmount: dueAmount ?? this.dueAmount,
      dueDate: dueDate ?? this.dueDate,
      lastPaidDate: lastPaidDate ?? this.lastPaidDate,
      landlordName: landlordName ?? this.landlordName,
      leasePeriod: leasePeriod ?? this.leasePeriod,
    );
  }
}

class RentalService {
  static final ValueNotifier<RentalInfo> current = ValueNotifier<RentalInfo>(
    const RentalInfo(
      status: RentalStatus.pending,
      propertyTitle: 'Greenwood Heights, Flat 402',
      propertyAddress: '100 Feet Road, Indiranagar, Bangalore',
      monthlyRent: 18000,
      dueAmount: 18000,
      dueDate: '01 Nov 2026',
      lastPaidDate: '12 Oct 2026',
      landlordName: 'Rajesh Sharma',
      leasePeriod: 'May 2026 - Apr 2027 (11 Months)',
    ),
  );

  static void setStatus(RentalStatus newStatus) {
    current.value = current.value.copyWith(status: newStatus);
  }

  static void markAsPaid() {
    current.value = current.value.copyWith(
      status: RentalStatus.paid,
      dueAmount: 0,
      lastPaidDate: 'Today',
    );
  }

  static void markAsPending() {
    current.value = current.value.copyWith(
      status: RentalStatus.pending,
      dueAmount: current.value.monthlyRent,
    );
  }
}
