from fastapi import APIRouter

router = APIRouter()


@router.get("/")
def list_events():
    # Placeholder route so the API boots even if events aren't implemented yet.
    return []
