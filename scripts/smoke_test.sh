#!/usr/bin/env bash
set -eo pipefail

echo "==========================================="
echo "  RUNNING PRODUCTION STACK SMOKE TESTS"
echo "==========================================="

BASE_URL="http://localhost"
FAILED=0

# Test 1: Healthcheck Route
echo -n "[TEST 1] Checking Nginx -> App /health endpoint... "
HEALTH_RESPONSE=$(curl -s "${BASE_URL}/health" || echo "")
if [[ "$HEALTH_RESPONSE" =~ "healthy" ]] && [[ "$HEALTH_RESPONSE" =~ "up" ]]; then
    echo "PASSED (200 OK, DB & Redis Up)"
else
    echo "FAILED! Got: $HEALTH_RESPONSE"
    FAILED=1
fi

# Test 2: Database Query (Cache Miss)
echo -n "[TEST 2] Verifying Postgres seed query (Cache Miss)... "
DB_RESPONSE=$(curl -s "${BASE_URL}/users" || echo "")
if [[ "$DB_RESPONSE" =~ "postgres-db" ]]; then
    echo "PASSED (Data fetched from Postgres)"
else
    echo "FAILED! Got: $DB_RESPONSE"
    FAILED=1
fi

# Test 3: Redis Cache Query (Cache Hit)
echo -n "[TEST 3] Verifying Redis caching layer (Cache Hit)... "
CACHE_RESPONSE=$(curl -s "${BASE_URL}/users" || echo "")
if [[ "$CACHE_RESPONSE" =~ "redis-cache" ]]; then
    echo "PASSED (Data served from Redis cache)"
else
    echo "FAILED! Got: $CACHE_RESPONSE"
    FAILED=1
fi

echo "==========================================="
if [ $FAILED -eq 0 ]; then
    echo "  ALL SMOKE TESTS PASSED SUCCESSFULLY! "
    echo "==========================================="
    exit 0
else
    echo "  SMOKE TESTS FAILED! "
    echo "==========================================="
    exit 1
fi
