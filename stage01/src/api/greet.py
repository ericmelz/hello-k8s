from fastapi import FastAPI
from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    greeting: str = "Hello, K8s, from local!"

    class Config:
        env_file = ".env"


settings = Settings()

app = FastAPI()


@app.get("/greet")
def greet():
    return {"message": settings.greeting}


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
