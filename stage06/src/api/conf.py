import json
import os
from typing import Dict, Any

from pydantic_settings import BaseSettings
from pathlib import Path


class Settings(BaseSettings):
    greeting: str = "Hello, K8s, from local!"
    database_url: str
    db_password: str

    class Config:
        env_file = ".env"

        @classmethod
        def customize_sources(cls, init_settings, env_settings):
            print('****customize_sources')
            return (
                init_settings,
                cls.json_secrets_settings,
                env_settings,
            )

        @classmethod
        def json_secrets_settings(cls) -> Dict[str, Any]:
            print('****json_secrets_settings')
            secrets_dir = Path.home() / ".secrets"
            secrets = {}
            if os.path.exists(secrets_dir):
                for secret_file in os.listdir(secrets_dir):
                    with open(secret_file, 'r') as f:
                        try:
                            secrets.update(json.load(f))
                        except json.JSONDecodeError:
                            raise ValueError(f"Invalid JSON in {secret_file}")
            return secrets


settings = Settings()
        
