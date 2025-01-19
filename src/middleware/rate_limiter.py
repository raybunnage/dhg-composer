from slowapi import Limiter
from slowapi.util import get_remote_address
from fastapi import FastAPI, Request
from redis import Redis

redis_client = Redis(host="localhost", port=6379, db=0)

limiter = Limiter(
    key_func=get_remote_address,
    storage_uri="redis://localhost:6379",
    default_limits=["10/second"],
)

# Custom limits for fast endpoints
FAST_ENDPOINT_LIMIT = "100/second"

# Apply to your FastAPI app
app = FastAPI()
app.state.limiter = limiter


@app.middleware("http")
async def rate_limit_middleware(request: Request, call_next):
    # Check if endpoint needs custom limits
    if request.url.path in fast_endpoints:
        request.state.rate_limit = FAST_ENDPOINT_LIMIT

    response = await call_next(request)
    return response
