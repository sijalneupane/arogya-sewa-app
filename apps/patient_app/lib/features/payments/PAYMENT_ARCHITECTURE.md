# Khalti Payment Integration Refactoring - Architecture Documentation

## Overview

This document describes the refactored Khalti payment integration architecture that has been made app-wide global in the patient app. The refactoring ensures the payment system is:

- **Global**: Initialized once at app startup and available throughout the app
- **Clean**: Follows clean architecture patterns consistent with other features
- **Reusable**: Can be used for both appointment payments and future due payments
- **Testable**: Separated concerns make unit testing easier

## Architecture Layers

### 1. **Core Services Layer** (`lib/core/services/`)

**KhaltiService** - Global payment gateway service
- **Purpose**: Manages Khalti SDK lifecycle globally
- **Location**: `lib/core/services/khalti_service.dart`
- **Key Methods**:
  - `initialize()` - Initializes the service (called once at startup)
  - `openCheckout()` - Opens Khalti payment UI with all callbacks
  - `getConfig()` - Returns current configuration
- **Lifecycle**: Singleton, initialized early in `initDI()`
- **Usage**: Injected via `GetIt.instance<KhaltiService>()`

### 2. **Core Config Layer** (`lib/core/config/`)

**KhaltiCheckoutConfig** - Centralized configuration
- **Purpose**: Holds environment-specific Khalti settings
- **Location**: `lib/core/config/khalti_checkout_config.dart`
- **Properties**:
  - `publicKey` - From environment variable or fallback
  - `environment` - Khalti.Environment (test/prod)
  - `enableDebugLogs` - Debug logging flag
- **Immutable**: All properties are const/static

### 3. **Payment Feature - Data Layer** (`lib/features/payments/data/`)

#### Datasources

**khalti_payment_remote_datasource** - Abstract interface
- `initiatePayment(payload)` → Returns pidx
- `verifyPayment(appointmentId, pidx)` → Returns void

**khalti_payment_remote_datasource_impl** - Dio-based HTTP client
- Follows standard pattern: inject `Dio`, implement interface
- Error handling via `handleDataSourceDioException`
- Endpoints:
  - `POST /payments/khalti/initiate` - Get pidx for SDK
  - `POST /payments/khalti/verify?appointment_id=X&pidx=Y` - Confirm payment backend

#### Models

**khalti_payment_initiation_model** - Data transfer object
- Maps appointment details to backend payload
- Contains: `appointmentId`, `amount`, `customerPhone`

### 4. **Payment Feature - Domain Layer** (`lib/features/payments/domain/`)

#### Repository Pattern

**khalti_payment_repository** - Abstract interface
- `initiatePayment(appointmentId, amount, phone)` → Either<Failure, String>
- `verifyPayment(appointmentId, pidx)` → Either<Failure, void>

**khalti_payment_repository_impl** - Repository implementation
- Wraps datasource calls with:
  - Network connectivity checks (NetworkInfo)
  - Error handling (returns Either<Failure, T>)
- Follows pattern from other features (doctors, availability, etc.)

#### Usecases

**InitiateKhaltiPaymentUsecase**
- Params: `InitiateKhaltiPaymentParams(appointmentId, amount,customerPhone)`
- Output: `Either<Failure, String>` (pidx)
- Implements `UseCase<String, InitiateKhaltiPaymentParams>`

**VerifyKhaltiPaymentUsecase**
- Params: `VerifyKhaltiPaymentParams(appointmentId, pidx)`
- Output: `Either<Failure, void>`
- Implements `UseCase<void, VerifyKhaltiPaymentParams>`

#### Param Classes

Located in `domain/usecases/params/` for clean organization:
- `InitiateKhaltiPaymentParams` - Usecase input for initiation
- `VerifyKhaltiPaymentParams` - Usecase input for verification

### 5. **Payment Feature - Presentation Layer** (`lib/features/payments/presentation/`)

**KhaltiPaymentBloc** - State management
- **Events**:
  - `InitiateKhaltiPaymentEvent` - Trigger payment initiation
  - `VerifyKhaltiPaymentEvent` - Trigger backend verification
  - `ResetKhaltiPaymentEvent` - Reset to initial state
- **States**:
  - `KhaltiPaymentInitial` - Initial state
  - `KhaltiPaymentLoading` - Initiation in progress
  - `KhaltiPaymentInitiated(pidx)` - Ready to open SDK
  - `KhaltiPaymentVerifying` - Backend verification in progress
  - `KhaltiPaymentVerified` - Success
  - `KhaltiPaymentFailure(message)` - Error occurred
  - `KhaltiPaymentCanceled` - User canceled

## Dependency Injection (DI)

### Registration Order in `initDI()`

```
1. Shared core dependencies (Firebase, Dio, etc.)
2. GLOBAL SERVICES INITIALIZATION
   ↳ KhaltiService → singleton, initialize()
3. Feature dependencies (datasources → repos → usecases → blocs)
   ↳ All other features...
   ↳ Payment feature dependencies
4. Notification service setup
```

### Registration Details

```dart
// KhaltiService - Global singleton
sl.registerSingleton<KhaltiService>(KhaltiService());
await sl<KhaltiService>().initialize();

// Payment feature chain
sl.registerLazySingleton<KhaltiPaymentRemoteDataSource>(
  () => KhaltiPaymentRemoteDataSourceImpl(sl<Dio>()),
);
sl.registerLazySingleton<KhaltiPaymentRepository>(
  () => KhaltiPaymentRepositoryImpl(
    remoteDataSource: sl<KhaltiPaymentRemoteDataSource>(),
    networkInfo: sl<NetworkInfo>(),
  ),
);
sl.registerLazySingleton<InitiateKhaltiPaymentUsecase>(
  () => InitiateKhaltiPaymentUsecase(sl<KhaltiPaymentRepository>()),
);
sl.registerLazySingleton<VerifyKhaltiPaymentUsecase>(
  () => VerifyKhaltiPaymentUsecase(sl<KhaltiPaymentRepository>()),
);
sl.registerFactory<KhaltiPaymentBloc>(
  () => KhaltiPaymentBloc(
    initiateKhaltiPaymentUsecase: sl<InitiateKhaltiPaymentUsecase>(),
    verifyKhaltiPaymentUsecase: sl<VerifyKhaltiPaymentUsecase>(),
  ),
);
```

## Payment Flow

### Appointment Payment Example

```
User fills form
    ↓
Submits appointment
    ↓
[BLoC] CreateAppointmentBloc handles creation
    ↓
[BLoC Success] CreateAppointmentLoaded
    ↓
[Page] Calls _initiateKhaltiPayment()
    ↓
[BLoC] Dispatches InitiateKhaltiPaymentEvent
    ↓
[BLoC Handler] _onInitiateKhaltiPayment
    ↓
[Usecase] InitiateKhaltiPaymentUsecase.call()
    ↓
[Repo] Repository.initiatePayment()
    ↓
[Datasource] POST /payments/khalti/initiate
    ↓
[BLoC State] KhaltiPaymentInitiated(pidx)
    ↓
[Page] _onKhaltiPaymentStateChange detects KhaltiPaymentInitiated
    ↓
[Page] Calls _openKhaltiSDK(pidx)
    ↓
[Service] KhaltiService.openCheckout()
    ↓
[SDK] Khalti SDK UI displayed to user
    ↓
User completes payment
    ↓
[Callback] onPaymentResult called
    ↓
[Page] _verifyKhaltiPayment(pidx)
    ↓
[BLoC] Dispatches VerifyKhaltiPaymentEvent
    ↓
[BLoC Handler] _onVerifyKhaltiPayment
    ↓
[Usecase] VerifyKhaltiPaymentUsecase.call()
    ↓
[Repo] Repository.verifyPayment()
    ↓
[Datasource] POST /payments/khalti/verify?appointment_id=X&pidx=Y
    ↓
[BLoC State] KhaltiPaymentVerified
    ↓
[Page] Shows success dialog and closes
```

## File Structure

```
lib/
├── core/
│   ├── config/
│   │   └── khalti_checkout_config.dart          # Config singleton
│   └── services/
│       └── khalti_service.dart                  # Global Khalti service
└── features/
    └── payments/
        ├── data/
        │   ├── datasources/
        │   │   ├── khalti_payment_remote_datasource.dart
        │   │   └── khalti_payment_remote_datasource_impl.dart
        │   └── models/
        │       └── khalti_payment_initiation_model.dart
        ├── domain/
        │   ├── repositories/
        │   │   ├── khalti_payment_repository.dart
        │   │   └── khalti_payment_repository_impl.dart
        │   └── usecases/
        │       ├── initiate_khalti_payment_usecase.dart
        │       ├── verify_khalti_payment_usecase.dart
        │       └── params/
        │           ├── initiate_khalti_payment_params.dart
        │           └── verify_khalti_payment_params.dart
        └── presentation/
            └── bloc/
                ├── khalti_payment_bloc.dart
                ├── khalti_payment_event.dart
                └── khalti_payment_state.dart
```

## Future Use: Due Payments

The refactored structure supports future payment operations without modification:

```dart
// For due payments, create a new feature or usecase:
// lib/features/payments/domain/usecases/pay_due_usecase.dart

// 1. Service already initialized globally - no setup needed
final khaltiService = GetIt.instance<KhaltiService>();

// 2. Create repository call to initiate dues payment
final initiateResult = await repository.initiatePaymentForDue(
  dueId: dueId,
  amount: amount,
  customerPhone: phone,
);

// 3. On success (pidx received), open same checkout UI:
await khaltiService.openCheckout(
  context: context,
  pidx: pidx,
  // ... rest of callbacks
);

// 4. After payment, verify via same verification endpoint
// with different backend path if needed
```

## Key Design Patterns

### 1. **Repository Pattern**
- Abstract `KhaltiPaymentRepository` interface
- Implementation handles network/error logic
- Usecases depend on abstraction, not implementation

### 2. **Either/Failure Pattern**
- All operations return `Either<Failure, T>`
- Left = error, Right = success
- Enables type-safe error handling

### 3. **Service Locator (GetIt)**
- Single global instance of `KhaltiService`
- Lazy initialization of repositories/usecases
- Factory for BLoCs (new instance per page)

### 4. **State Management (BLoC)**
- Clean separation of concerns
- Events dispatch based on user actions
- States drive UI updates
- No business logic in UI layer

## Testing Considerations

### Unit Testing
- Mock `KhaltiPaymentRepository` for usecase tests
- Mock `KhaltiService` for page tests
- Test all three verification states: Verifying → Verified/Failure

### Integration Testing
- Test full flow: Initiate → Open SDK → Verify
- Mock backend API responses
- Test error recovery and retry logic

### E2E Testing
- Test with actual Khalti test merchant account
- Verify pidx extraction from SDK
- Monitor backend logs for verify requests

## Configuration

### Environment Variables
```bash
# In pubspec.yaml or build command:
--dart-define=KHALTI_PUBLIC_KEY=your_test_key
```

### Local Override
Edit `KhaltiCheckoutConfig`:
```dart
static const String publicKey = 'your_local_test_key';
```

## Migration Notes for Developers

### Old Way (Pre-refactoring)
```dart
// Config was in features/payments/config/
// Had to import from payment feature
// No global service - initialized inline in page
```

### New Way (Post-refactoring)
```dart
// Config is in core/config/ - shared resource
import 'package:patient_app/core/config/khalti_checkout_config.dart';
import 'package:patient_app/core/services/khalti_service.dart';

// Service is global - use anywhere
final khaltiService = GetIt.instance<KhaltiService>();
await khaltiService.openCheckout(...);
```

## Next Steps

1. **Test** - Run full appointment flow with test Khalti account
2. **Due Payments** - Implement `PayDueUsecase` using existing infrastructure
3. **Monitoring** - Add analytics to track payment success/failure rates
4. **Error Handling** - Add retry logic for network failures during verification
5. **Logging** - Consider structured logging for payment events

---

**Last Updated**: April 2, 2026
**Status**: ✅ Refactoring Complete - All files compile cleanly
