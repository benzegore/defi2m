-- Défi 2 minutes : table de sauvegarde (une ligne par compte)
create table if not exists public.sauvegardes (
  user_id uuid primary key references auth.users (id) on delete cascade,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.sauvegardes enable row level security;

drop policy if exists "lecture"      on public.sauvegardes;
drop policy if exists "creation"     on public.sauvegardes;
drop policy if exists "modification" on public.sauvegardes;
drop policy if exists "suppression"  on public.sauvegardes;

create policy "lecture" on public.sauvegardes
  for select to authenticated using ((select auth.uid()) = user_id);
create policy "creation" on public.sauvegardes
  for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "modification" on public.sauvegardes
  for update to authenticated
  using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy "suppression" on public.sauvegardes
  for delete to authenticated using ((select auth.uid()) = user_id);
