from fastapi import FastAPI, Depends
from sqlalchemy.orm import Session
from conf import settings
from models import Message, get_db

print(f'{settings.greeting=}')
print(f'{settings.database_url=}')

app = FastAPI()

@app.get("/greet")
def greet():
    return {"message": settings.greeting, "database_url": settings.database_url}

@app.get("/data")
def get_data(db: Session = Depends(get_db)):
    messages = db.query(Message).all()
    return {"messages": [msg.message for msg in messages]}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
