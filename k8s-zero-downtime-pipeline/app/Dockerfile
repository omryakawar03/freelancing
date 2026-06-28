FROM python:3.12-slim AS builder
WORKDIR /app
COPY app/requirements.txt .
RUN pip install --no-cache-dir --target=/install -r requirements.txt

FROM python:3.12-slim
WORKDIR /app
COPY --from=builder /install /usr/local/lib/python3.12/site-packages
COPY app/ .
RUN useradd -m appuser
USER appuser
EXPOSE 5000
CMD ["python", "app.py"]