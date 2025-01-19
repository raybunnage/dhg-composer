from fastapi import APIRouter, Depends
from slowapi.util import get_remote_address
from middleware.rate_limiter import limiter

router = APIRouter()


@router.get("/fast-endpoint")
@limiter.limit("100/second")
async def fast_endpoint(request: Request):
    return {"message": "Fast endpoint response"}
