-- Spoony: esquema de la copia en la nube (cuenta opcional).
--
-- Se ejecuta una vez en el editor SQL del proyecto de Supabase.
-- Crea el proyecto en la región de Frankfurt (eu-central-1): el módulo de Ciclo
-- guarda datos de salud, que el RGPD trata como categoría especial.
--
-- Una fila por persona con el estado entero de la app en jsonb. La app ya
-- trabaja con un único objeto `state`, así que subirlo y bajarlo entero es lo
-- más simple y lo más difícil de romper. `version` sube sola en cada cambio y
-- la app la usa para no pisar lo que otro móvil haya subido entretanto.

create table if not exists public.spoony_state (
  user_id    uuid primary key references auth.users(id) on delete cascade,
  data       jsonb       not null,
  version    bigint      not null default 1,
  updated_at timestamptz not null default now()
);

-- Cada persona solo ve y toca su propia fila. Sin esto, la clave pública que
-- lleva la app dejaría leer los datos de todo el mundo.
alter table public.spoony_state enable row level security;

drop policy if exists "leer lo propio" on public.spoony_state;
create policy "leer lo propio" on public.spoony_state
  for select using (auth.uid() = user_id);

drop policy if exists "crear lo propio" on public.spoony_state;
create policy "crear lo propio" on public.spoony_state
  for insert with check (auth.uid() = user_id);

drop policy if exists "cambiar lo propio" on public.spoony_state;
create policy "cambiar lo propio" on public.spoony_state
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "borrar lo propio" on public.spoony_state;
create policy "borrar lo propio" on public.spoony_state
  for delete using (auth.uid() = user_id);

-- La versión y la fecha las pone la base de datos, nunca la app: así un reloj
-- mal puesto en un móvil no decide qué copia gana.
create or replace function public.spoony_bump() returns trigger
language plpgsql as $$
begin
  new.version    := old.version + 1;
  new.updated_at := now();
  return new;
end $$;

drop trigger if exists spoony_bump on public.spoony_state;
create trigger spoony_bump before update on public.spoony_state
  for each row execute function public.spoony_bump();

-- Borrar la cuenta desde la propia app. Apple lo exige a cualquier app que deje
-- crear cuenta (App Store Review Guideline 5.1.1(v)). Borra el usuario y, por
-- el "on delete cascade", su fila de datos.
create or replace function public.delete_my_account() returns void
language sql security definer set search_path = '' as $$
  delete from auth.users where id = auth.uid();
$$;

revoke all on function public.delete_my_account() from public, anon;
grant execute on function public.delete_my_account() to authenticated;

-- Derecho de acceso a lo de pago (freemium, ver DESIGN_LOG.md). Tabla aparte
-- de spoony_state a propósito: esa tabla deja al cliente reescribir su fila
-- entera (política "cambiar lo propio"), así que un campo premium ahí sería
-- tan seguro como un `if(premium)` en el JS. Aquí solo hay política de
-- lectura para el propio usuario; nada de insert/update/delete para
-- anon/authenticated, así que solo puede tocarla el rol de servicio (el panel
-- de Supabase a mano, o más adelante un webhook de RevenueCat).
create table if not exists public.spoony_entitlements (
  user_id    uuid primary key references auth.users(id) on delete cascade,
  is_premium boolean     not null default false,
  source     text        not null default 'manual', -- 'manual' | 'revenuecat'
  updated_at timestamptz not null default now()
);

alter table public.spoony_entitlements enable row level security;

drop policy if exists "leer mi derecho de acceso" on public.spoony_entitlements;
create policy "leer mi derecho de acceso" on public.spoony_entitlements
  for select using (auth.uid() = user_id);

-- Dar acceso total a las cuentas del desarrollador y su pareja, autista
-- (decisión 2026-09-23 en DESIGN_LOG.md, ampliada 2026-09-23). Ejecutar a
-- mano en el editor SQL de Supabase; es seguro volver a ejecutar el archivo
-- entero, no duplica nada.
insert into public.spoony_entitlements (user_id, is_premium, source)
select id, true, 'manual' from auth.users where email = 'jaimelillobenito@gmail.com'
on conflict (user_id) do update set is_premium = true, source = 'manual', updated_at = now();

insert into public.spoony_entitlements (user_id, is_premium, source)
select id, true, 'manual' from auth.users where email = 'claudiaballesteroscalzon@gmail.com'
on conflict (user_id) do update set is_premium = true, source = 'manual', updated_at = now();
