from anthropic import Anthropic
from src.config.settings import get_settings
import logging

logger = logging.getLogger(__name__)


class AnthropicClient:
    def __init__(self):
        settings = get_settings()
        self.client = Anthropic(api_key=settings.ANTHROPIC_API_KEY)
        self.model = "claude-3-opus-20240229"  # or your preferred model

    async def get_client(self):
        return self.client

    async def analyze_text(self, text: str, prompt: str = None) -> str:
        """Analyze text using Claude"""
        try:
            default_prompt = (
                f"Please analyze the following text and provide insights: {text}"
            )
            message = await self.client.messages.create(
                model=self.model,
                max_tokens=1000,
                messages=[{"role": "user", "content": prompt or default_prompt}],
            )
            return message.content
        except Exception as e:
            logger.error(f"Error in Claude analysis: {str(e)}")
            raise Exception(f"Failed to analyze with Claude: {str(e)}")
