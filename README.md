# ai-ops-control-layer

AI Operations Control Layer for the ICOFounder ecosystem.

## Project Structure

- `docs/`: Technical documentation and Architectural Decision Records (ADR).
- `workers/`: Principal Cloudflare Worker (MCP Gateway).
- `supabase/`: Database scripts and initial table definitions.
- `notion/`: Synchronization logic and future templates.
- `config/`: Configuration schemas, variables, and policies.

## Setup

1. **Doppler**: Log in and setup the project.
   ```bash
   doppler setup
   ```
2. **Dependencies**:
   ```bash
   npm install
   ```

## Development

Run with Doppler:
```bash
doppler run -- npm start
```
