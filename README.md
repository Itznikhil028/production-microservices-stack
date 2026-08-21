# Hardened Multi-Tier Microservices Architecture

A production-grade, containerized multi-tier web stack deployed on AWS EC2 featuring dual-bridge network isolation, healthcheck-gated bootstrapping, deterministic caching, strict resource quotas, log rotation, and automated smoke testing.

---

## 🏛️ System Architecture

```text
       Internet (Port 80)
               │
               ▼
   ┌───────────────────────┐
   │      Nginx Proxy      │ ─── Public Facing (frontend-net)
   └───────────────────────┘
               │
               ▼ (Internal HTTP)
   ┌───────────────────────┐
   │    Node.js App API    │ ─── Dual Homing (frontend-net & backend-net)
   └───────────────────────┘
          │          │
 (Cache)  ▼          ▼  (Persistent Storage)
   ┌───────────┐   ┌─────────────┐
   │  Redis 7  │   │ Postgres 16 │ ─── Network Isolated (backend-net)
   └───────────┘   └─────────────┘
