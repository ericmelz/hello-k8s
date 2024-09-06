from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    greeting: str = "Hello, K8s, from local!"
    database_url: str

    class Config:
        env_file = ".env"


settings = Settings()
        
