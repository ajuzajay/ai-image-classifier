#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${1:-http://localhost:8000}"
SAMPLE_IMAGE="${2:-test_data/sample_cat.png}"

echo "Smoke test target: ${BASE_URL}"
echo "Sample image: ${SAMPLE_IMAGE}"

if [ ! -f "${SAMPLE_IMAGE}" ]; then
  echo "Missing sample image: ${SAMPLE_IMAGE}"
  exit 1
fi

echo "Checking home page..."
curl -fsS "${BASE_URL}/" >/tmp/ai-image-classifier-home.html

echo "Checking prediction endpoint..."
RESPONSE="$(curl -fsS -X POST "${BASE_URL}/predict" -F "file=@${SAMPLE_IMAGE}")"
echo "${RESPONSE}" >/tmp/ai-image-classifier-predict-response.json

echo "Checking prediction response contains class..."
echo "${RESPONSE}" | grep '"class"'

echo "Smoke test passed."
