FROM python:3.11-slim

WORKDIR /app


COPY requirements.txt .

RUN pip install --no-cache-dir --index-url https://download.pytorch.org/whl/cpu torch torchvision

RUN pip install --no-cache-dir -r requirements.txt

COPY app ./app

EXPOSE 8000

RUN useradd --create-home --shell /usr/sbin/nologin appuser

RUN chown -R appuser:appuser /app

USER appuser

HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/', timeout=3).read()" || exit 1

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]

