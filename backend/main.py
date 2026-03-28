from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager
from backend.api.routes import events, alerts, stats, auth
from backend.database.db import init_db
from typing import Dict, List
import json

@asynccontextmanager
async def lifespan(app: FastAPI):
    init_db()
    yield


app = FastAPI(
    title="AI Surveillance API",
    description="Intelligent Audio-Visual Fusion Surveillance System",
    version="1.0.0",
    lifespan=lifespan,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


class ConnectionManager:
    def __init__(self):
        self.active_connections: Dict[str, List[WebSocket]] = {}

    async def connect(self, websocket: WebSocket, user_id: str):
        await websocket.accept()
        if user_id not in self.active_connections:
            self.active_connections[user_id] = []
        self.active_connections[user_id].append(websocket)
        print(f"User {user_id} connected. Total users: {len(self.active_connections)}")

    def disconnect(self, websocket: WebSocket, user_id: str):
        if user_id in self.active_connections:
            if websocket in self.active_connections[user_id]:
                self.active_connections[user_id].remove(websocket)
            if not self.active_connections[user_id]:
                del self.active_connections[user_id]
        print(f"User {user_id} disconnected")

    async def send_to_user(self, user_id: str, message: dict):
        """Send alert only to the specific user"""
        if user_id not in self.active_connections:
            return
        disconnected = []
        for connection in self.active_connections[user_id]:
            try:
                await connection.send_text(json.dumps(message))
            except Exception:
                disconnected.append(connection)
        for conn in disconnected:
            self.active_connections[user_id].remove(conn)

    async def broadcast(self, message: dict):
        """Send to all users — used for system messages"""
        for user_id in list(self.active_connections.keys()):
            await self.send_to_user(user_id, message)


manager = ConnectionManager()





@app.get("/")
def root():
    return {
        "status": "running",
        "project": "AI Surveillance System",
        "connected_users": len(manager.active_connections),
    }


@app.websocket("/ws/{user_id}")
async def websocket_endpoint(
    websocket: WebSocket,
    user_id: str,
):
    await manager.connect(websocket, user_id)
    try:
        while True:
            await websocket.receive_text()
    except WebSocketDisconnect:
        manager.disconnect(websocket, user_id)


app.include_router(events.router, prefix="/events", tags=["events"])
app.include_router(alerts.router, prefix="/alerts", tags=["alerts"])
app.include_router(stats.router, prefix="/stats", tags=["stats"])
app.include_router(auth.router, prefix="/auth", tags=["auth"])

app.state.manager = manager