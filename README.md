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
