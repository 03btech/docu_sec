from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from starlette.requests import Request
from starlette.responses import RedirectResponse
from typing import Optional
from ..database import get_db
from .. import crud, models, schemas
from ..dependencies import get_current_user

router = APIRouter()

@router.post("/register", response_model=schemas.User)
async def register(user: schemas.UserCreate, db: AsyncSession = Depends(get_db)):
    db_user = await crud.get_user_by_username(db, username=user.username)
    if db_user:
        raise HTTPException(status_code=400, detail="Username already registered")
    return await crud.create_user(db, user)

@router.post("/login")
async def login(request: Request, user_credentials: schemas.UserLogin, db: AsyncSession = Depends(get_db)):
    user = await crud.authenticate_user(db, user_credentials.username, user_credentials.password)
    if not user:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Incorrect username or password")
    request.session["user_id"] = user.id
    return {"message": "Login successful"}

@router.post("/logout")
async def logout(request: Request):
    request.session.clear()
    return {"message": "Logout successful"}

@router.get("/me", response_model=schemas.User)
async def read_users_me(current_user: models.User = Depends(get_current_user)):
    return current_user

@router.get("/departments")
async def get_departments(db: AsyncSession = Depends(get_db)):
    departments = await crud.get_departments(db)
    return [{"id": dept.id, "name": dept.name} for dept in departments]

@router.get("/users", response_model=list[schemas.UserBasic])
async def list_users(
    search: Optional[str] = None,
    db: AsyncSession = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    """Get list of all users (excluding current user) with optional search."""
    users = await crud.get_all_users(db, exclude_user_id=current_user.id, search=search)
    return users
