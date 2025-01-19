from fastapi import Request
from starlette.middleware.base import BaseHTTPMiddleware
from app.core.apps import AppRegistry


class AppContextMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        # Extract app_id from path or subdomain
        app_id = self._get_app_id(request)

        if app_id:
            AppRegistry.set_current_app(app_id)

        response = await call_next(request)
        return response

    def _get_app_id(self, request: Request) -> str:
        # From path: /app1/api/users -> app1
        path_parts = request.url.path.split("/")
        if len(path_parts) > 1:
            return path_parts[1]

        # From subdomain: app1.yourdomain.com
        host = request.headers.get("host", "")
        subdomain = host.split(".")[0]
        return subdomain if subdomain in ["app1", "app2"] else "default"
