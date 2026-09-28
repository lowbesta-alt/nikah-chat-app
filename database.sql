-- ============================================================================
-- BASE DE DONNÉES : Plateforme de mariage islamique éthique
-- Projet : nikah-chat-app
-- Auteur : nkongji70-dev
-- ============================================================================

-- ----------------------------------------------------------------------------
-- TABLE 1 : PROFILES (profils des utilisateurs)
-- ----------------------------------------------------------------------------
create table public.profiles (
  id                uuid primary key references auth.users(id) on delete cascade,
  username          text unique not null,
  gender            text check (gender in ('male','female')),
  birth_date        date,
  country           text,
  city              text,
  bio               text,
  religiosity_level text check (religiosity_level in ('modere','pratiquant','tres_pratiquant')),
  marital_status    text check (marital_status in ('celibataire','divorce','veuf','marie')),
  avatar_url        text,
  created_at        timestamptz not null default now()
);

-- ----------------------------------------------------------------------------
-- TABLE 2 : CONVERSATIONS (échanges entre 2 personnes)
-- ----------------------------------------------------------------------------
create table public.conversations (
  id              uuid primary key default gen_random_uuid(),
  participant_one uuid not null references public.profiles(id) on delete cascade,
  participant_two uuid not null references public.profiles(id) on delete cascade,
  message_count   integer not null default 0,
  is_unlocked     boolean not null default false,
  created_at      timestamptz not null default now(),
  constraint uq_conversation_pair unique (participant_one, participant_two),
  constraint chk_participants_diff check (participant_one <> participant_two)
);

-- ----------------------------------------------------------------------------
-- TABLE 3 : MESSAGES (textes, photos, vocaux)
-- ----------------------------------------------------------------------------
create table public.messages (
  id              uuid primary key default gen_random_uuid(),
  conversation_id uuid not null references public.conversations(id) on delete cascade,
  sender_id       uuid not null references public.profiles(id) on delete cascade,
  content_type    text not null check (content_type in ('text','image','audio')),
  content_url     text,
  text_body       text,
  created_at      timestamptz not null default now()
);

-- ----------------------------------------------------------------------------
-- TABLE 4 : PAYMENTS (traçabilité des paiements Mobile Money / Carte)
-- ----------------------------------------------------------------------------
create table public.payments (
  id              uuid primary key default gen_random_uuid(),
  conversation_id uuid references public.conversations(id) on delete set null,
  user_id         uuid references public.profiles(id) on delete set null,
  provider        text not null,
  provider_ref    text unique,
  amount          numeric(10,2) not null,
  currency        text not null default 'XAF',
  status          text not null default 'pending'
                  check (status in ('pending','success','failed','refunded')),
  created_at      timestamptz not null default now()
);

-- ============================================================================
-- SÉCURITÉ : ROW LEVEL SECURITY (RLS)
-- ============================================================================
alter table public.profiles      enable row level security;
alter table public.conversations enable row level security;
alter table public.messages      enable row level security;
alter table public.payments      enable row level security;

-- Fonction utilitaire : l'utilisateur connecté fait-il partie de la conversation ?
create or replace function public.is_conversation_member(p_conversation_id uuid)
returns boolean
language sql
security definer
stable
set search_path = public
as $$
  select exists (
    select 1 from public.conversations c
    where c.id = p_conversation_id
      and (c.participant_one = auth.uid() or c.participant_two = auth.uid())
  );
$$;

-- Règles pour PROFILES
create policy "profiles_select_all" on public.profiles
  for select to authenticated using (true);

create policy "profiles_insert_self" on public.profiles
  for insert to authenticated with check (id = auth.uid());

create policy "profiles_update_self" on public.profiles
  for update to authenticated
  using (id = auth.uid()) with check (id = auth.uid());

-- Règles pour CONVERSATIONS
create policy "conv_select_member" on public.conversations
  for select to authenticated
  using (participant_one = auth.uid() or participant_two = auth.uid());

-- Règles pour MESSAGES
create policy "msg_select_member" on public.messages
  for select to authenticated
  using (public.is_conversation_member(conversation_id));

create policy "msg_insert_member" on public.messages
  for insert to authenticated
  with check (
    sender_id = auth.uid()
    and public.is_conversation_member(conversation_id)
  );

-- Règles pour PAYMENTS
create policy "pay_select_own" on public.payments
  for select to authenticated using (user_id = auth.uid());
