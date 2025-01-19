from fastapi import APIRouter, Depends, HTTPException
from typing import List
from .schemas import UserCreate, UserResponse, UserUpdate
from .repository import UserRepository
from app.core.auth import get_current_user

router = APIRouter()


@router.post("/users/", response_model=UserResponse)
async def create_user(user: UserCreate):
    repo = UserRepository()
    existing_user = await repo.get_by_email(user.email)
    if existing_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    return await repo.create(user)


@router.get("/users/", response_model=List[UserResponse])
async def list_users(
    skip: int = 0, limit: int = 100, current_user: dict = Depends(get_current_user)
):
    repo = UserRepository()
    return await repo.list_users(skip, limit)


@router.get("/users/{user_id}", response_model=UserResponse)
async def get_user(user_id: int, current_user: dict = Depends(get_current_user)):
    repo = UserRepository()
    user = await repo.get_by_id(user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user
