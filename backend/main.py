from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from backend.api.routes import events, alerts
from backend.database.db import init_db

app = FastAPI(
    title="AI Surveillance API",
    description="Intelligent Audio-Visual Fusion Surveillance System",
    version="1.0.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.on_event("startup")
async def startup():
    init_db()

@app.get("/")
def root():
    return {"status": "running", "project": "AI Surveillance System"}

app.include_router(events.router, prefix="/events", tags=["events"])
app.include_router(alerts.router, prefix="/alerts", tags=["alerts"])