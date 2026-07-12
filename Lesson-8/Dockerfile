FROM python:3.10-slim AS builder

WORKDIR /app
RUN apt-get update && apt-get install -y gcc libpq-dev && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt


FROM python:3.10-slim

WORKDIR /app
RUN apt-get update && apt-get install -y libpq5 && rm -rf /var/lib/apt/lists/*


COPY --from=builder /root/.local /root/.local
COPY . .


ENV PATH=/root/.local/bin:$PATH
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1


RUN useradd -m djangoapp
USER djangoapp

EXPOSE 8000


CMD ["gunicorn", "--bind", "0.0.0.0:8000", "myproject.wsgi:application"]