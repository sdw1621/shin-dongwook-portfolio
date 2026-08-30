-- ============================================================
--  신동욱 포트폴리오 · 이력서 기본정보(profile) DB 셋업
--  Supabase 좌측 [SQL Editor] 에 전체 붙여넣고 RUN 하세요.
--  experience.html 의 Excel/PDF 다운로드 상단에 사진·인적사항으로 출력됩니다.
--  ※ 개인정보 주의: 이 테이블은 anon(공개) 키로 읽힙니다.
--    - 주민등록번호는 저장하지 않습니다(생년월일만 저장 → 만 나이 자동 계산).
--    - 집 주소/휴대전화가 공개 노출되는 것이 우려되면 해당 값을 비우거나
--      제출용으로만 잠깐 넣었다가 지우는 운영을 권장합니다.
-- ============================================================

-- 1) 테이블(단일 행: id = 1 고정)
create table if not exists public.profile (
  id            int primary key default 1,
  name_ko       text,            -- 한글 이름 (예: 신동욱)
  name_en       text,            -- 영문 이름 (예: Shin Dong Wook)
  name_hanja    text,            -- 한자 이름 (예: 申東彧)
  birth         date,            -- 생년월일 (예: 1983-01-08) → 만 나이 자동 계산
  phone         text,            -- 휴대전화 (예: 010-2731-2579)
  email         text,            -- 이메일
  address       text,            -- 주소
  photo_url     text,            -- 증명사진 URL(선택) — 없으면 PDF에 '사진' 자리표시
  job_target    text,            -- 희망 직무(선택)
  salary_target text,            -- 희망 연봉(선택)
  updated_at    timestamptz default now(),
  constraint profile_singleton check (id = 1)
);

-- 2) 보안(RLS): 누구나 읽기, 로그인 사용자만 쓰기 (careers 와 동일 정책)
alter table public.profile enable row level security;
drop policy if exists "public read"  on public.profile;
drop policy if exists "auth write"   on public.profile;
create policy "public read" on public.profile for select using (true);
create policy "auth write"  on public.profile for all
  using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');

-- 3) 기본정보 입력(있으면 갱신). 값은 이력서 첨부 기준.
insert into public.profile
  (id, name_ko, name_en, name_hanja, birth, phone, email, address, photo_url, job_target, salary_target)
values
  (1, '신동욱', 'Shin Dong Wook', '申東彧', '1983-01-08',
   '010-2731-2579', 'sdw1904@naver.com',
   '경기도 부천시 원미구 상동 사랑마을 1621-1801',
   '',                                   -- 증명사진 URL을 넣으면 PDF 상단에 표시됩니다
   'BigData Analysis / Prompt Engineer', '')
on conflict (id) do update set
  name_ko=excluded.name_ko, name_en=excluded.name_en, name_hanja=excluded.name_hanja,
  birth=excluded.birth, phone=excluded.phone, email=excluded.email, address=excluded.address,
  job_target=excluded.job_target, salary_target=excluded.salary_target,
  updated_at=now();
-- (photo_url 은 의도적으로 덮어쓰지 않습니다 — /admin 에서 넣은 값 보존)
