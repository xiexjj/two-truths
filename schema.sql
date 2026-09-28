-- Jalankan di Supabase: SQL Editor > New query > Run
create table game (id int primary key default 1, phase text not null default 'submit', started_at timestamptz);
insert into game (id) values (1);

create table players (id uuid primary key default gen_random_uuid(), name text unique not null);

create table sets (
  player_id uuid primary key references players on delete cascade,
  s1 text not null, s2 text not null, s3 text not null,
  lie int not null check (lie between 0 and 2)
);

create table guesses (
  id bigint generated always as identity primary key,
  guesser uuid not null references players on delete cascade,
  target uuid not null references sets(player_id) on delete cascade,
  pick int,
  answered_at timestamptz
);
create index on guesses (guesser);

-- Akses terbuka untuk game sekali pakai (tanpa login)
alter table game enable row level security;
alter table players enable row level security;
alter table sets enable row level security;
alter table guesses enable row level security;
create policy "open" on game for all using (true) with check (true);
create policy "open" on players for all using (true) with check (true);
create policy "open" on sets for all using (true) with check (true);
create policy "open" on guesses for all using (true) with check (true);
