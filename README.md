# LifeOS 2027

Personal operating system for goals, routines, weekly reviews and career execution.

## Networking lives inside LifeOS

Open the **„🤝 Netzwerk“ tab** in `index.html` to use the complete networking workspace without leaving LifeOS. The dashboard tab stays focused on goals and everyday execution; the networking tab contains the detailed CRM.

The networking workspace supports:
- Contact scouting and contact management
- Relationship status, next actions and dated follow-ups
- Interaction history per contact
- Message templates and draft preparation
- Career opportunity pipeline
- Weekly reviews and progress metrics
- JSON backup and import

`linkedin-networking.html` remains the underlying networking application loaded inside the LifeOS tab. You normally do not need to open it separately.

## Data and privacy

- LifeOS goals and routines remain in `public.lifeos_state`.
- Networking records remain in the signed-in user's existing `public.networking_state` row.
- LifeOS and the embedded networking workspace use the same Supabase project and signed-in session.
- The networking data is **not copied or migrated** into `lifeos_state`; the existing networking row remains the source of truth. This avoids duplicate records and protects existing contacts and interaction history.
- Row Level Security restricts each user to their own row.
- The networking app keeps a local browser cache for responsiveness. Export a JSON backup periodically, especially before importing a full backup.
- Keep notes professional and avoid sensitive or confidential information.

## Maintenance notes

- Contact records are stored as JSON in the user's networking `state` field. Optional fields are backward-compatible.
- Existing status labels should remain available in both the edit form and filter.
- Follow-up dates should be compared using the user's local calendar date, not UTC.
- Message drafts require user review; nothing is sent automatically.


## LifeOS Control Center

Open **„✦ Control Center“** in the LifeOS navigation or visit `control-center.html`. It adds:
- Open Loops for questions, decisions, commitments, problems and follow-ups
- AI Inbox with explicit user approval, source evidence and duplicate linking
- Weekly review with up to three priorities
- ChatGPT ZIP export import with metadata-only persistence and configurable title exclusions
- References to existing LifeOS goals without copying the source-of-truth state

### Database and AI setup

The Control Center uses isolated tables added by `supabase/migrations/20261021000000_lifeos_control_center_mvp.sql`. Existing `lifeos_state` and `networking_state` remain unchanged. All new public tables use Row Level Security and owner-scoped policies.

The server-side Edge Function source is `supabase/functions/lifeos-analyze-conversations/index.ts`; it is deployed as `lifeos-analyze-conversations` with JWT verification enabled. It does not persist raw conversations and calls the OpenAI Responses API with structured output and `store: false`.

**Required configuration:** set `OPENAI_API_KEY` as a Supabase Edge Function secret. Optionally set `OPENAI_MODEL`; the default is `gpt-4o-mini`. Do not put the key in HTML, browser storage, or GitHub. Until the secret is configured, manual Open Loops and weekly review work, while AI analysis returns a clear configuration error.

### Import privacy

The ZIP is read in the browser. Only conversation metadata, fingerprints and short evidence excerpts are persisted. Selected conversation text is sent to the configured AI API only after the user confirms the analysis consent. The user can cap the number of recent conversations and exclude titles matching comma-separated terms. Title filtering cannot reliably detect sensitive content inside messages, so users should review their selected export before analysis.

### Local verification

The GitHub Actions workflow `.github/workflows/control-center-check.yml` checks inline JavaScript syntax in the HTML pages. Before production use, complete a test import with a redacted export, configure the API secret, verify RLS using a second test account, and review Supabase security advisors.
