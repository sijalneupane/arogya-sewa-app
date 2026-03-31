# ArogyaSewa Dialogs

Reusable, theme-compatible dialog modals for the ArogyaSewa application.

## Features

- ✅ **5 Dialog Types**: Confirm, Info, Success, Warning, Error
- ✅ **Theme Compatible**: Automatically adapts to light and dark themes
- ✅ **Customizable**: Custom titles, messages, button text, and icons
- ✅ **Easy to Use**: Static methods for quick access
- ✅ **Tap Outside to Dismiss**: User-friendly dismissal behavior
- ✅ **Consistent Design**: Clean, minimal UI

## Usage

### Import

```dart
import 'package:shared_ui/shared_ui.dart';
```

### Quick Start

```dart
// Confirmation dialog
ArogyaSewaDialogs.showConfirmDialog(
  context: context,
  title: 'Confirm Action',
  message: 'Are you sure?',
  onConfirm: () {
    // Handle confirm
  },
);

// Info dialog
ArogyaSewaDialogs.showInfoDialog(
  context: context,
  title: 'Info',
  message: 'Something happened',
);

// Success dialog
ArogyaSewaDialogs.showSuccessDialog(
  context: context,
  title: 'Done!',
  message: 'Completed successfully',
);

// Warning dialog
ArogyaSewaDialogs.showWarningDialog(
  context: context,
  title: 'Warning',
  message: 'Be careful',
);

// Error dialog
ArogyaSewaDialogs.showErrorDialog(
  context: context,
  title: 'Error',
  message: 'Something went wrong',
);
```

## Dialog Methods

| Method | Buttons | Use Case |
|--------|---------|----------|
| `showConfirmDialog` | Cancel + Confirm | User needs to confirm an action |
| `showInfoDialog` | OK | General information |
| `showSuccessDialog` | OK | Operation completed successfully |
| `showWarningDialog` | OK | Caution or attention needed |
| `showErrorDialog` | Close | Something went wrong |

## Parameters

### showConfirmDialog

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `context` | `BuildContext` | required | Build context |
| `title` | `String` | required | Dialog title |
| `message` | `String` | required | Message body |
| `onConfirm` | `VoidCallback` | required | Callback on confirm |
| `icon` | `IconData?` | null | Custom icon |
| `cancelText` | `String` | 'Cancel' | Cancel button text |
| `confirmText` | `String` | 'Confirm' | Confirm button text |

### showInfoDialog, showSuccessDialog, showWarningDialog, showErrorDialog

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `context` | `BuildContext` | required | Build context |
| `title` | `String` | required | Dialog title |
| `message` | `String` | required | Message body |
| `icon` | `IconData?` | Auto | Custom icon |
| `buttonText` | `String` | 'OK'/'Close' | Button text |

## Theme Support

The dialogs automatically adapt to the current theme:

- **Light Mode**: Light surface background, dark text
- **Dark Mode**: Dark surface background, light text

Colors are derived from the app's `ColorScheme` for consistent theming.

## Examples

See `dialog_example.dart` for complete usage examples.

## Best Practices

1. **Keep messages short**: 1-2 sentences maximum
2. **Use appropriate type**: Match dialog type to the situation
3. **Clear actions**: Use descriptive button text
4. **Don't overuse**: Reserve dialogs for important interactions
5. **Handle actions**: Always provide meaningful callbacks
