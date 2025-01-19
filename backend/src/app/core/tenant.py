class Tenant:
    def __init__(self, tenant_id: str):
        self.tenant_id = tenant_id
        self.config = load_tenant_config(tenant_id)


# Usage in routes
@router.get("/api/{tenant_id}/users")
async def get_users(tenant_id: str):
    tenant = Tenant(tenant_id)
    # Use tenant-specific logic/data
