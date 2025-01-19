from pydantic import BaseModel
from typing import Dict


class App1Settings(BaseModel):
    """App1-specific settings"""

    PAYMENT_GATEWAY: str = "stripe"
    PRODUCT_CATEGORIES: list = ["electronics", "books", "clothing"]
    FEATURE_FLAGS: Dict[str, bool] = {
        "enable_marketplace": True,
        "enable_reviews": True,
        "enable_recommendations": False,
    }
