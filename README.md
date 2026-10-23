# Móveis Finos — orçamentos e financeiro

App de arquivo único (`public/index.html`) + Supabase (banco e login) — mesmo padrão do Finanzza.

## Estrutura
- `public/index.html` — o app inteiro (é a única pasta publicada no site)
- `public/dados-planilha.js` — histórico da planilha antiga. **Não vai para o GitHub** (tem nomes de clientes); fica só no computador, para a importação
- `schema.sql` — banco de dados do Supabase
- `wrangler.jsonc` — usado só se o site for publicado como Worker

## Usar no computador
Abra `public/index.html`. Em **Ajustes** há os botões "Completar catálogo" e "Importar histórico" (usar uma única vez, estando logado).

## Regra de cálculo (igual à planilha)
`Valor final = materiais + (materiais × lucro%) + Júlio (nº de chapas × valor por chapa) − desconto`

## Supabase
1. SQL Editor → colar `schema.sql` → RUN.
2. Rodar também: `grant usage on schema public to authenticated; grant select, insert, update, delete on public.clientes, public.materiais, public.orcamentos, public.lancamentos, public.configuracoes to authenticated;`
3. Authentication → Users → Add user, e desligar "Allow new users to sign up".
4. URL e chave pública já estão no topo do script de `public/index.html`.

## Publicar (Cloudflare Pages)
Workers & Pages → Create → Pages → Connect to Git → repositório `moveisfinos`, branch `main`.
Build command: vazio. Build output directory: `public`.
Cada envio ao GitHub publica sozinho.
