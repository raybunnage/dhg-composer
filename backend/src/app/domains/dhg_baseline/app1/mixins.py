from typing import Dict, Any
from app.core.mixins.base import BaseMixin


class PaymentProcessingMixin(BaseMixin):
    """Mixin for payment processing capabilities"""

    async def process_payment(
        self, amount: float, currency: str, payment_method: str, user_id: str
    ) -> Dict[str, Any]:
        # Implement payment processing logic
        pass

    async def refund_payment(
        self, payment_id: str, amount: float, reason: str
    ) -> Dict[str, Any]:
        # Implement refund logic
        pass


class ProductManagementMixin(BaseMixin):
    """Mixin for product management capabilities"""

    async def update_inventory(
        self, product_id: str, quantity: int, action: str
    ) -> None:
        # Implement inventory management logic
        pass
