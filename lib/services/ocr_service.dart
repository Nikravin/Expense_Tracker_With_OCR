import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class OCRService {
  static final TextRecognizer _textRecognizer = TextRecognizer();

  static Future<String?> extractTextFromImage(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
      
      return recognizedText.text;
    } catch (e) {
      print('Error extracting text from image: $e');
      return null;
    }
  }

  /// Extract text from XFile (camera/gallery)
  static Future<String?> extractTextFromXFile(XFile imageFile) async {
    try {
      final inputImage = InputImage.fromFilePath(imageFile.path);
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
      
      return recognizedText.text;
    } catch (e) {
      print('Error extracting text from XFile: $e');
      return null;
    }
  }

  /// Dispose resources
  static void dispose() {
    _textRecognizer.close();
  }
}
