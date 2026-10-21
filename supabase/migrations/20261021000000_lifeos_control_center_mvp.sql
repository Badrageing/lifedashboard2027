-- LifeOS Control Center MVP: isolated tables; existing lifeos_state/networking_state remain unchanged.
create table if not exists public.lifeos_imports (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  file_fingerprint text not null check (length(file_fingerprint) = 64),
  filename text,
  status text not null default 'uploaded' check (status in ('uploaded','processing','review','completed','failed')),
  conversation_count integer not null default 0 check (conversation_count >= 0),
  candidate_count integer not null default 0 check (candidate_count >= 0),
  error_summary text,
  created_at timestamptz not null default now(),
  completed_at timestamptz,
  unique (id, user_id),
  unique (user_id, file_fingerprint)
);
create table if not exists public.lifeos_sources (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  import_id uuid not null,
  source_type text not null default 'chatgpt_conversation' check (source_type = 'chatgpt_conversation'),
  external_id text not null,
  title text not null default 'ChatGPT conversation' check (length(title) <= 240),
  conversation_created_at timestamptz,
  conversation_updated_at timestamptz,
  content_fingerprint text not null check (length(content_fingerprint) = 64),
  source_locator text,
  retention_status text not null default 'metadata_only' check (retention_status in ('metadata_only','deleted')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (id, user_id),
  unique (user_id, external_id),
  foreign key (import_id, user_id) references public.lifeos_imports(id, user_id) on delete cascade
);
create table if not exists public.lifeos_open_loops (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null check (length(trim(title)) between 2 and 180),
  description text check (description is null or length(description) <= 1200),
  loop_type text not null default 'follow_up' check (loop_type in ('question','decision','commitment','problem','follow_up')),
  status text not null default 'new' check (status in ('new','active','waiting','parked','completed','dismissed')),
  life_area text not null check (life_area in ('career','health','family','finances','personal_development','side_business')),
  next_action text check (next_action is null or length(next_action) <= 500),
  due_date date,
  priority text not null default 'normal' check (priority in ('low','normal','high')),
  goal_ref text,
  project_ref text,
  reviewed_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  completed_at timestamptz,
  unique (id, user_id)
);
create index if not exists lifeos_open_loops_user_status_idx on public.lifeos_open_loops(user_id, status, due_date);
create index if not exists lifeos_open_loops_user_area_idx on public.lifeos_open_loops(user_id, life_area, status);
create table if not exists public.lifeos_loop_sources (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  loop_id uuid not null,
  source_id uuid not null,
  relationship text not null default 'supports' check (relationship in ('supports','updates','duplicates','contradicts')),
  evidence_excerpt text check (evidence_excerpt is null or length(evidence_excerpt) <= 420),
  created_at timestamptz not null default now(),
  unique (loop_id, source_id),
  foreign key (loop_id, user_id) references public.lifeos_open_loops(id, user_id) on delete cascade,
  foreign key (source_id, user_id) references public.lifeos_sources(id, user_id) on delete cascade
);
create table if not exists public.lifeos_review_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  week_start date not null,
  status text not null default 'in_progress' check (status in ('in_progress','completed')),
  reflection text check (reflection is null or length(reflection) <= 2000),
  top_priorities jsonb not null default '[]'::jsonb check (jsonb_typeof(top_priorities) = 'array' and jsonb_array_length(top_priorities) <= 3),
  created_at timestamptz not null default now(),
  completed_at timestamptz,
  unique (id, user_id),
  unique (user_id, week_start)
);
create table if not exists public.lifeos_review_items (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  review_id uuid not null,
  loop_id uuid not null,
  decision text not null check (decision in ('keep_active','wait','park','complete','dismiss')),
  note text check (note is null or length(note) <= 800),
  created_at timestamptz not null default now(),
  unique (review_id, loop_id),
  foreign key (review_id, user_id) references public.lifeos_review_sessions(id, user_id) on delete cascade,
  foreign key (loop_id, user_id) references public.lifeos_open_loops(id, user_id) on delete cascade
);
alter table public.lifeos_imports enable row level security;
alter table public.lifeos_sources enable row level security;
alter table public.lifeos_open_loops enable row level security;
alter table public.lifeos_loop_sources enable row level security;
alter table public.lifeos_review_sessions enable row level security;
alter table public.lifeos_review_items enable row level security;
drop policy if exists "Users manage own LifeOS imports" on public.lifeos_imports;
create policy "Users manage own LifeOS imports" on public.lifeos_imports for all to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
drop policy if exists "Users manage own LifeOS sources" on public.lifeos_sources;
create policy "Users manage own LifeOS sources" on public.lifeos_sources for all to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
drop policy if exists "Users manage own LifeOS open loops" on public.lifeos_open_loops;
create policy "Users manage own LifeOS open loops" on public.lifeos_open_loops for all to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
drop policy if exists "Users manage own LifeOS loop sources" on public.lifeos_loop_sources;
create policy "Users manage own LifeOS loop sources" on public.lifeos_loop_sources for all to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
drop policy if exists "Users manage own LifeOS reviews" on public.lifeos_review_sessions;
create policy "Users manage own LifeOS reviews" on public.lifeos_review_sessions for all to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
drop policy if exists "Users manage own LifeOS review items" on public.lifeos_review_items;
create policy "Users manage own LifeOS review items" on public.lifeos_review_items for all to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
grant select, insert, update, delete on public.lifeos_imports, public.lifeos_sources, public.lifeos_open_loops, public.lifeos_loop_sources, public.lifeos_review_sessions, public.lifeos_review_items to authenticated;
