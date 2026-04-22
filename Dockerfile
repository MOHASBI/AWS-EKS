FROM python:3.12-slim
WORKDIR /app
COPY . . 
EXPOSE 80
CMD ["python", "-m", "http.server", "80"]
