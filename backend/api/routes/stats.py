from fastapi import APIRouter

router = APIRouter()


@router.get("/")
def get_stats_overview():
    # Placeholder route so the API boots even if stats aren't implemented yet.
    return {"status": "ok"}
