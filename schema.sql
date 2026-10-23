-- Móveis Finos — banco de dados (Supabase)
-- Cole tudo isto no SQL Editor do Supabase e clique em RUN.

create table if not exists public.clientes (
  id uuid primary key,
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  nome text not null,
  telefone text,
  endereco text,
  observacao text,
  created_at timestamptz default now()
);

create table if not exists public.materiais (
  id uuid primary key,
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  nome text not null,
  categoria text,
  tipo text default 'material',      -- material | ferragem | mao_de_obra
  unidade text default 'un',
  preco numeric(12,2) default 0,
  is_chapa boolean default false,    -- chapa de MDF (gera o valor do Júlio)
  created_at timestamptz default now()
);

create table if not exists public.orcamentos (
  id uuid primary key,
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  numero int,
  cliente_id uuid,
  cliente_nome text,
  data date,
  descricao text,
  endereco text,
  status text default 'orcamento',   -- visitar | orcamento | fechado | producao | entregue | perdido
  itens jsonb default '[]'::jsonb,
  chapas numeric default 0,
  chapas_manual boolean default false,
  valor_chapa numeric(12,2) default 170,
  lucro_pct numeric(6,2) default 60,
  desconto numeric(12,2) default 0,
  entrada_pct numeric(6,2) default 60,
  entrada_auto boolean default true,
  entrada numeric(12,2) default 0,
  entrada_data date,
  entrada_paga boolean default false,
  restante_data date,
  restante_pago boolean default false,
  meios text,
  condicoes text,
  prazo text,
  garantia text,
  validade_dias int default 15,
  especificacoes text,
  observacao text,
  total numeric(12,2) default 0,
  custo numeric(12,2) default 0,
  lucro_real numeric(12,2) default 0,
  valor_fixo numeric(12,2),          -- orçamentos importados da planilha antiga (sem itens)
  importado boolean default false,
  created_at timestamptz default now()
);

-- se a tabela orcamentos já existia, rode também:
alter table public.orcamentos add column if not exists valor_fixo numeric(12,2);
alter table public.orcamentos add column if not exists importado boolean default false;

create table if not exists public.lancamentos (
  id uuid primary key,
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  tipo text not null,                -- entrada | saida
  descricao text,
  valor numeric(12,2) default 0,
  data date,
  categoria text,
  status text default 'pago',        -- pago | pendente
  observacao text,
  created_at timestamptz default now()
);

create table if not exists public.configuracoes (
  user_id uuid primary key default auth.uid() references auth.users(id) on delete cascade,
  dados jsonb default '{}'::jsonb,
  updated_at timestamptz default now()
);

-- Segurança: cada usuário só enxerga e altera os próprios dados
do $$
declare t text;
begin
  foreach t in array array['clientes','materiais','orcamentos','lancamentos','configuracoes']
  loop
    execute format('alter table public.%I enable row level security', t);
    execute format('drop policy if exists "dono_total" on public.%I', t);
    execute format('create policy "dono_total" on public.%I for all using (auth.uid() = user_id) with check (auth.uid() = user_id)', t);
  end loop;
end $$;
