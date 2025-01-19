from fastapi import APIRouter, Depends
from app.core.apps import AppFeature
from app.core.deps import get_current_app, require_feature

router = APIRouter(prefix="/app2")


@router.get("/courses")
async def list_courses(
    app=Depends(get_current_app), _=Depends(require_feature(AppFeature.SCHEDULING))
):
    """List courses for app2"""
    return {"courses": [], "app": "app2"}


@router.post("/schedule")
async def schedule_session(
    app=Depends(get_current_app), _=Depends(require_feature(AppFeature.VIDEOCONFERENCE))
):
    """Schedule a video session for app2"""
    return {"status": "scheduled", "app": "app2"}
