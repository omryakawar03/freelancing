FROM python:3.12.3-slim-bookworm AS builder
WORKDIR /app
COPY requirements.txt .
RUN apt-get update \
    && apt-get upgrade -y --no-install-recommends \
    && pip install --no-cache-dir --target=/install flask -r requirements.txt \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

FROM python:3.12.3-slim-bookworm
WORKDIR /app

# FIX: Set PYTHONPATH so Python can locate the packages in site-packages
ENV PYTHONPATH=/usr/local/lib/python3.12/site-packages

COPY --from=builder /install /usr/local/lib/python3.12/site-packages
COPY . .

RUN groupadd --system appgroup \
    && useradd --system --gid appgroup --create-home --home-dir /home/appuser appuser \
    && chown -R appuser:appgroup /app

USER appuser
EXPOSE 5000
CMD ["python", "app.py"]
