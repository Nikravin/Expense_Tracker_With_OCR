# Quick Scan OCR Feature - Usage Guide

## Overview
The Quick Scan feature allows users to scan bills and receipts using their phone camera and automatically extract expense information using OCR (Optical Character Recognition).

## Features
✅ **Camera Integration**: Take photos directly from the app or select from gallery
✅ **OCR Text Recognition**: Automatically extract text from receipt images
✅ **Smart Parsing**: Intelligently parse expense information including:
   - Amount extraction
   - Merchant/vendor name detection
   - Category auto-classification
   - Date extraction
✅ **Editable Results**: Review and edit extracted information before saving
✅ **Automatic Balance Updates**: Balance card updates immediately after saving

## How to Use

### 1. Navigate to Quick Scan
- From the main screen, tap the "Quick Scan" button in the Quick Actions section
- The button has a camera icon and blue accent color

### 2. Capture Receipt
- Tap "Scan Receipt" button
- Choose between "Camera" or "Gallery"
- If using camera: Point at the receipt and capture
- If using gallery: Select an existing image

### 3. OCR Processing
- The app will automatically process the image
- Text recognition will extract all readable text
- Smart parsing will identify key information

### 4. Review & Edit
- Review the extracted information:
  - **Amount**: Automatically detected monetary values
  - **Merchant**: Vendor/store name from receipt header
  - **Category**: Auto-classified based on keywords
  - **Note**: Optional additional information
- Edit any field as needed

### 5. Save Expense
- Tap "Save Expense" to add to your expense tracker
- Balance card will update automatically
- Return to home screen

## Supported Receipt Types
The OCR system works best with:
- **Restaurant receipts**
- **Shopping receipts**
- **Gas station receipts**
- **Pharmacy receipts**
- **Online order confirmations** (printed)

## Tips for Better OCR Results
1. **Good Lighting**: Ensure receipt is well-lit
2. **Flat Surface**: Lay receipt flat without wrinkles
3. **Full Frame**: Capture the entire receipt in frame
4. **Clear Focus**: Ensure text is sharp and readable
5. **Contrast**: Dark text on light background works best

## Auto-Classification Categories
The system automatically classifies expenses into:
- **Food**: Restaurants, cafes, food delivery
- **Transportation**: Gas, parking, Uber, public transport
- **Shopping**: Stores, malls, online purchases
- **Entertainment**: Movies, games, concerts
- **Healthcare**: Pharmacy, medical, hospitals
- **Utilities**: Bills, internet, phone
- **Education**: Books, courses, school fees
- **Other**: Miscellaneous expenses

## OCR Parsing Intelligence
The system looks for:
- **Total amounts**: Keywords like "total", "amount", currency symbols
- **Merchant names**: Usually in the first few lines of receipt
- **Dates**: Various date formats (MM/DD/YYYY, DD/MM/YYYY, etc.)
- **Category keywords**: Matches text against predefined category lists

## Permissions Required
- **Camera**: For taking photos of receipts
- **Storage**: For accessing gallery images
- **Internet**: For Google ML Kit OCR processing

## Technical Implementation
- **Google ML Kit**: For text recognition
- **Custom Parser**: For extracting expense data
- **Category Classification**: Keyword-based smart categorization
- **Flutter BLoC**: For state management and automatic UI updates

## Troubleshooting
- **No text detected**: Try better lighting or clearer image
- **Wrong amount**: Manually edit the detected amount
- **Wrong category**: Select correct category from dropdown
- **Permission issues**: Check app permissions in device settings

## Future Enhancements
- Receipt image storage
- Multi-language OCR support
- Receipt template recognition
- Expense splitting from itemized receipts
- Integration with cloud storage
