from app.core.mixins.service_mixins import CacheMixin, AuditMixin, ValidationMixin
from app.domains.app1.mixins import ProductManagementMixin
from app.core.base import BaseService


class ProductService(
    BaseService, CacheMixin, AuditMixin, ValidationMixin, ProductManagementMixin
):
    """Product service with mixed-in capabilities"""

    async def create_product(self, data: dict, user_id: str) -> dict:
        # Validate data
        await self.validate_entity(data, ProductSchema)

        # Create product
        product = await self.repository.create(data)

        # Update cache
        cache_key = f"product:{product.id}"
        await self.set_cached(cache_key, product)

        # Log action
        await self.log_action(
            "product_created", user_id, {"product_id": product.id}, "app1"
        )

        return product

    async def update_product_stock(
        self, product_id: str, quantity: int, user_id: str
    ) -> None:
        # Update inventory using mixin
        await self.update_inventory(product_id, quantity, "adjust")

        # Clear cache
        cache_key = f"product:{product_id}"
        await self.clear_cached(cache_key)

        # Log action
        await self.log_action(
            "stock_updated",
            user_id,
            {"product_id": product_id, "quantity": quantity},
            "app1",
        )
