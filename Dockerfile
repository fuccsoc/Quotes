FROM python:3.11-slim-bookworm

# Install system dependencies required by wkhtmltopdf and imgkit
RUN apt-get update && apt-get install -y --no-install-recommends \
    wkhtmltopdf \
    && rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN pip install --no-cache-dir poetry

WORKDIR /app

# Copy dependency files first for layer caching
COPY pyproject.toml poetry.lock ./

# Install dependencies without dev dependencies
RUN poetry config virtualenvs.create false \
    && poetry install --no-root --without dev

# Copy application source
COPY . .

EXPOSE 1337

CMD ["python3", "-m", "app"]
