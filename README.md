# Móveis Finos — orçamentos e financeiro

App de arquivo único (`index.html`) + Supabase (banco e login) — mesmo padrão do Finanzza.

## Testar agora (sem conta nenhuma)
Dê dois cliques em `index.html`. Sem Supabase configurado, o app roda em **modo teste**: os dados ficam só naquele navegador.
Na aba **Catálogo**, clique em "Carregar itens iniciais da planilha".

## Regra de cálculo (igual à planilha)
`Valor final = materiais + (materiais × lucro%) + Júlio (nº de chapas × valor por chapa) − desconto`

## Ligar ao Supabase (conta do pai)
1. Criar projeto no Supabase com o e-mail do pai.
2. SQL Editor → colar o conteúdo de `schema.sql` → RUN.
3. Authentication → Users → Add user (e-mail e senha do pai). Depois, em Authentication → Sign In / Providers, desligar "Allow new users to sign up".
4. Project Settings → API: copiar **Project URL** e **anon public key** para `SUPABASE_URL` e `SUPABASE_KEY` no topo do script do `index.html`.

## Publicar
Repositório no GitHub (conta do pai) → conectar à Vercel/Netlify/Cloudflare Pages. Cada envio ao repositório publica sozinho.
