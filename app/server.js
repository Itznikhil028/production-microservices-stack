const express = require('express');
const { Pool } = require('pg');
const redis = require('redis');

const app = express();
const PORT = process.env.PORT || 3000;

// PostgreSQL Connection Pool
const pool = new Pool({
  host: process.env.POSTGRES_HOST || 'postgres-db',
  user: process.env.POSTGRES_USER || 'admin',
  password: process.env.POSTGRES_PASSWORD || 'secret123',
  database: process.env.POSTGRES_DB || 'appdb',
  port: 5432,
});

// Redis Client Connection
const redisClient = redis.createClient({
  url: `redis://${process.env.REDIS_HOST || 'redis-cache'}:6379`
});

redisClient.on('error', (err) => console.error('Redis Error:', err));

async function init() {
  await redisClient.connect();
  console.log('Connected to Redis');
}
init();

// Routes
app.get('/', (req, res) => {
  res.json({ message: 'Production API Gateway Active', status: 'OK' });
});

app.get('/health', async (req, res) => {
  try {
    await pool.query('SELECT 1');
    const ping = await redisClient.ping();
    if (ping === 'PONG') {
      return res.status(200).json({ status: 'healthy', db: 'up', redis: 'up' });
    }
  } catch (err) {
    return res.status(500).json({ status: 'unhealthy', error: err.message });
  }
});

app.get('/users', async (req, res) => {
  try {
    const cachedUsers = await redisClient.get('users_data');
    if (cachedUsers) {
      return res.json({ source: 'redis-cache', data: JSON.parse(cachedUsers) });
    }

    const { rows } = await pool.query('SELECT * FROM users');
    await redisClient.set('users_data', JSON.stringify(rows), { EX: 30 });
    res.json({ source: 'postgres-db', data: rows });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.listen(PORT, () => console.log(`API running on port ${PORT}`));
