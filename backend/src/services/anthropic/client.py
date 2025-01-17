from anthropic import Anthropic
from src.config.settings import get_settings


class AnthropicClient:
    def __init__(self):
        settings = get_settings()
        self.client = Anthropic(api_key=settings.ANTHROPIC_API_KEY)

    async def get_client(self):
        return self.client
