import structlog
from typing import Any, Dict


def setup_logging() -> None:
    """Configure structured logging for the application."""
    structlog.configure(
        processors=[
            structlog.contextvars.merge_contextvars,
            structlog.processors.add_log_level,
            structlog.processors.TimeStamper(fmt="iso"),
            structlog.processors.JSONRenderer(),
        ],
        wrapper_class=structlog.make_filtering_bound_logger(
            structlog.get_logger().level
        ),
        context_class=dict,
        logger_factory=structlog.PrintLoggerFactory(),
        cache_logger_on_first_use=True,
    )


def get_logger(context: Dict[str, Any] = None) -> structlog.BoundLogger:
    """Get a logger instance with optional context."""
    logger = structlog.get_logger()
    if context:
        return logger.bind(**context)
    return logger
