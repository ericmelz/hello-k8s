from api.models import Base, engine, SessionLocal, Message

# Create tables if they don't exist
Base.metadata.create_all(bind=engine)

def seed():
    db = SessionLocal()
    messages = [
        Message(message="Hello, Kubernetes!"),
        Message(message="Welcome to FastAPI!"),
    ]
    db.add_all(messages)
    db.commit()
    db.close()

if __name__ == "__main__":
    seed()
