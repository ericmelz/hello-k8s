export DATABASE_URL=mysql://hellouser:hellopass@localhost/hello
alembic revision --autogenerate -m "Create messages table"
