import pytest


def test_simple():
    assert True


@pytest.mark.asyncio
async def test_async_simple():
    assert True
