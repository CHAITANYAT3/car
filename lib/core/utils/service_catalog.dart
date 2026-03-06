import '../../domain/entities/app_models.dart';

const serviceCatalog = [
  ServicePackage(
    tier: ServiceTier.basic,
    description: 'Oil change, brake check, and wash',
    price: 79,
    durationHours: 2,
  ),
  ServicePackage(
    tier: ServiceTier.standard,
    description: 'Basic + filter replacement and diagnostics',
    price: 149,
    durationHours: 4,
  ),
  ServicePackage(
    tier: ServiceTier.premium,
    description: 'Comprehensive inspection and tuning',
    price: 249,
    durationHours: 6,
  ),
];
