from PyPDF2 import PdfReader
import logging

logger = logging.getLogger(__name__)


class PDFProcessorMixin:
    """Mixin for PDF processing operations"""

    async def extract_text(self, pdf_file) -> str:
        """Extract text from PDF file"""
        try:
            reader = PdfReader(pdf_file)
            text = ""
            for page in reader.pages:
                text += page.extract_text()
            return text
        except Exception as e:
            logger.error(f"Error extracting text from PDF: {str(e)}")
            raise Exception(f"Failed to extract text from PDF: {str(e)}")

    async def analyze_content(self, text: str) -> dict:
        """Analyze extracted text content"""
        try:
            # Basic analysis - you can expand this based on your needs
            analysis = {
                "character_count": len(text),
                "word_count": len(text.split()),
                "line_count": len(text.splitlines()),
            }
            return analysis
        except Exception as e:
            logger.error(f"Error analyzing content: {str(e)}")
            raise Exception(f"Failed to analyze content: {str(e)}")
