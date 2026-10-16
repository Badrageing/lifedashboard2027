# Life Dashboard 2027

Personal operating system for goals, routines and career execution.

## LinkedIn Networking OS

The dedicated LinkedIn CRM lives in [`linkedin-networking.html`](./linkedin-networking.html).

It supports:
- Contact scouting and a structured contact CRM
- Relationship status tracking, next actions and dated follow-ups
- Interaction history per contact
- Message templates, weekly reviews and progress metrics
- JSON backup and import

### Data and privacy

- The app uses Supabase Auth and stores the signed-in user's state in `public.networking_state`.
- Row Level Security restricts each user to their own row.
- The app also keeps a local browser cache to make the interface responsive.
- Export a JSON backup periodically, especially before importing a full backup.
- Keep notes professional and avoid sensitive or confidential information.

### Maintenance notes

- Contact records are stored as JSON in the user's `state` field. New optional fields (such as interaction history) are backward-compatible.
- Status labels used by existing records should remain available in both the edit form and the filter.
- Follow-up dates should be compared using the user's local calendar date, not UTC.
