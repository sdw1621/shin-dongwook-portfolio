-- ============================================================
--  사용자별 공개 포트폴리오 프로필 (profiles)
--  Supabase SQL Editor 에 전체 붙여넣고 RUN 하세요.
--  ★ multiuser_setup.sql 을 먼저 실행한 뒤 이 파일을 실행하세요.
--    (신규 인원마다 handle 로 접근하는 개인 공개 페이지가 생깁니다:
--       portfolio.html?u=<handle> )
-- ============================================================

-- 1) 프로필 테이블 (auth.users 1:1)
create table if not exists public.profiles (
  id           uuid primary key references auth.users(id) on delete cascade,
  handle       text unique not null,          -- 공개 주소용 고유 아이디 (영소문자·숫자·하이픈)
  display_name text not null,                 -- 표시 이름
  headline     text,                          -- 한 줄 소개 (예: AI 교육 전문가)
  bio          text,                          -- 자기소개 (여러 줄)
  skills       text,                          -- 전문 분야 (쉼표로 구분)
  created_at   timestamptz default now(),
  constraint handle_format check (handle ~ '^[a-z0-9-]{3,30}$')
);

-- 2) 보안(RLS): 누구나 읽기(공개 페이지), 본인만 쓰기
alter table public.profiles enable row level security;
drop policy if exists "profiles public read"  on public.profiles;
drop policy if exists "profiles owner insert"  on public.profiles;
drop policy if exists "profiles owner update"  on public.profiles;

create policy "profiles public read"  on public.profiles for select using (true);
create policy "profiles owner insert"  on public.profiles for insert with check (auth.uid() = id);
create policy "profiles owner update"  on public.profiles for update using (auth.uid() = id) with check (auth.uid() = id);

-- 완료 후: 각 사용자는 자기 프로필만 만들고 수정할 수 있으며,
--          누구나 handle 로 공개 포트폴리오( portfolio.html?u=<handle> )를 볼 수 있습니다.
