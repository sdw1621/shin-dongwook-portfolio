-- ============================================================
--  멀티유저 전환 마이그레이션 (사용자별 데이터 분리)
--  Supabase SQL Editor 에 전체 붙여넣고 RUN 하세요.
--  ★ 회원가입을 켜기 전에 반드시 먼저 실행해야 합니다 ★
--    (실행 전에는 로그인한 누구나 모든 이력을 수정 가능)
-- ============================================================

-- 1) careers 에 소유자(user_id) 컬럼 추가 (신규 입력 시 자동으로 로그인 사용자 지정)
alter table public.careers
  add column if not exists user_id uuid references auth.users(id) default auth.uid();

-- 2) 기존 이력 15건을 소유자(신동욱) 계정에 귀속
--    ※ 아래 이메일이 본인 관리자 계정과 다르면 이메일만 바꿔서 실행하세요.
update public.careers
  set user_id = (select id from auth.users where email = 'sdw1904@naver.com')
  where user_id is null;

-- 3) 보안정책(RLS) 재설정: 공개 읽기는 유지, 쓰기는 '본인 것'만 허용
alter table public.careers enable row level security;
drop policy if exists "public read" on public.careers;
drop policy if exists "auth write"  on public.careers;
drop policy if exists "owner insert" on public.careers;
drop policy if exists "owner update" on public.careers;
drop policy if exists "owner delete" on public.careers;

create policy "public read"  on public.careers for select using (true);
create policy "owner insert" on public.careers for insert with check (auth.uid() = user_id);
create policy "owner update" on public.careers for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "owner delete" on public.careers for delete using (auth.uid() = user_id);

-- 완료 후: 가입한 사용자는 '자기 이력'만 관리할 수 있고,
--          다른 사람 데이터는 절대 수정/삭제할 수 없습니다.
