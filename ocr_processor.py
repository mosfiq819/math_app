from PIL import Image
import pytesseract
import io
import re

class OCRProcessor:
    def __init__(self):
        # Configure tesseract path if needed
        # pytesseract.pytesseract.tesseract_cmd = r'C:\Program Files\Tesseract-OCR\tesseract.exe'
        pass
    
    def process_image(self, image_data: bytes) -> str:
        """Process image and extract text"""
        try:
            # Open image from bytes
            image = Image.open(io.BytesIO(image_data))
            
            # Convert to grayscale for better OCR
            if image.mode != 'L':
                image = image.convert('L')
            
            # Use Tesseract OCR
            text = pytesseract.image_to_string(image)
            
            # Clean and preprocess for math
            text = self.preprocess_math_text(text)
            
            return text
        except Exception as e:
            return f"OCR Error: {str(e)}"
    
    def preprocess_math_text(self, text: str) -> str:
        """Preprocess OCR text for math parsing"""
        # Replace common OCR errors
        replacements = {
            'ﬁ': 'fi',
            'ﬂ': 'fl',
            '∫': 'integral',
            '∂': 'partial',
            '∑': 'sum',
            '∞': 'infinity',
            '√': 'sqrt',
            '×': '*',
            '÷': '/',
            '≤': '<=',
            '≥': '>=',
            '≠': '!=',
            '≈': '≈'
        }
        
        for old, new in replacements.items():
            text = text.replace(old, new)
        
        return text.strip()