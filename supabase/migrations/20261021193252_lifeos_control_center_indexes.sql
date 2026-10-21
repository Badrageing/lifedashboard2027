create index if not exists lifeos_sources_import_user_idx on public.lifeos_sources(import_id, user_id);
create index if not exists lifeos_loop_sources_loop_user_idx on public.lifeos_loop_sources(loop_id, user_id);
create index if not exists lifeos_loop_sources_source_user_idx on public.lifeos_loop_sources(source_id, user_id);
create index if not exists lifeos_loop_sources_user_idx on public.lifeos_loop_sources(user_id);
create index if not exists lifeos_review_items_review_user_idx on public.lifeos_review_items(review_id, user_id);
create index if not exists lifeos_review_items_loop_user_idx on public.lifeos_review_items(loop_id, user_id);
create index if not exists lifeos_review_items_user_idx on public.lifeos_review_items(user_id);
