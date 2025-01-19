from pydantic import BaseModel
from typing import Dict


class App2Settings(BaseModel):
    """App2-specific settings"""

    VIDEO_PROVIDER: str = "zoom"
    COURSE_TYPES: list = ["live", "recorded", "hybrid"]
    FEATURE_FLAGS: Dict[str, bool] = {
        "enable_live_sessions": True,
        "enable_chat": True,
        "enable_assignments": True,
    }
