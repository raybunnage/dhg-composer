from fastapi import APIRouter, HTTPException
from app.services.test.service import TestService

router = APIRouter()


@router.get("/test-supabase")
async def test_supabase():
    """Test Supabase connection"""
    try:
        test_service = TestService()
        return await test_service.test_db_connection()
    except Exception as e:
        return {
            "status": "error",
            "message": str(e),
            "details": "Connection test failed",
        }


@router.post("/test-supabase/add")
async def add_test_data():
    """Add test data to Supabase"""
    try:
        test_service = TestService()
        return await test_service.add_sample_data()
    except Exception as e:
        return {
            "status": "error",
            "message": str(e),
            "details": "Failed to add test data",
        }
