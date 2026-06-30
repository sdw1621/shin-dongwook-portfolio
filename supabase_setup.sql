-- ============================================================
--  신동욱 포트폴리오 · 이력(careers) DB 셋업
--  Supabase 좌측 [SQL Editor] 에 전체 붙여넣고 RUN 하세요.
-- ============================================================

-- 1) 테이블
create table if not exists public.careers (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz default now(),
  period text,                 -- 기간 (예: '2025.08')
  org text not null,           -- 기관/기업명
  title text,                  -- 과정/주제
  description text,            -- 상세 설명
  category text default '기타', -- 대기업·금융 / 정부·공공기관 / 대학·교육 / 기타
  badge text,                  -- 배지 약칭 (예: SNU)
  color text default 'from-blue-600 to-indigo-700',
  featured boolean default false,  -- 대표 이력 강조
  sort_order int default 0
);

-- 2) 보안(RLS): 누구나 읽기, 로그인 사용자만 쓰기
alter table public.careers enable row level security;
drop policy if exists "public read" on public.careers;
drop policy if exists "auth write" on public.careers;
create policy "public read" on public.careers for select using (true);
create policy "auth write"  on public.careers for all
  using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');

-- 3) 현재 이력 데이터 입력 (대표 6 + 그 외 9)
insert into public.careers (period, org, title, description, category, badge, color, featured, sort_order) values
('2025.03','삼성전자 (구미)','머신러닝 · 파워쿼리 실무과정','사내 외부 강사로 머신러닝(4일)·파워쿼리(2일) 데이터 분석 과정 진행','대기업·금융','삼성','from-slate-700 to-slate-900',true,100),
('2025.08','서울대학교','ChatGPT 활용 파이썬 프로그래밍','커서·LLM 에이전트·바이브코딩 실전 파이썬 개발 특강','대학·교육','SNU','from-slate-700 to-slate-900',true,99),
('2025.09','과학기술정보통신부 × NIPA','디지털 전환 핵심역량 강화 지원사업','정보통신산업진흥원과 함께한 정부 디지털 전환 인력 양성','정부·공공기관','NIPA','from-blue-600 to-indigo-700',true,98),
('2025.09','국가데이터처','파이썬 통계분석 실무 (글로벌)','우즈베키스탄 현지 대상 파이썬 기반 통계분석 실무 교육','정부·공공기관','DATA','from-teal-500 to-cyan-600',true,97),
('2025.08','LIG넥스원 × 메가넥스트','생성형 AI R&D 활용법','연구개발 현장에 생성형 AI를 접목하는 R&D 실무 특강','대기업·금융','LIG','from-sky-600 to-blue-700',true,96),
('2025.03','한국방송통신전파진흥원','딥브레인 AI STUDIOS · 영상 제작','딥브레인 AI STUDIOS 교육 및 AI 영상 제작 컨설팅','정부·공공기관','KCA','from-violet-500 to-purple-600',true,95),
('2025.04','빙그레','독립운동사 AI 영상 제작','생성형 AI를 활용한 독립운동사 영상 콘텐츠 제작','대기업·금융','빙','from-rose-500 to-red-500',false,90),
('2025.02','동아대학교','로컬 LLM 구축 특강','온프레미스 로컬 LLM 구축 실습','대학·교육','DA','from-indigo-600 to-blue-700',false,89),
('2025.01','인천광역시교육청','AI·에듀테크 활용 특강','교사 대상 AI·에듀테크 도구 활용 교육','정부·공공기관','인천','from-sky-500 to-cyan-600',false,88),
('2025.05','새싹 동작캠퍼스','생성형 AI 실무 자동화','생성형 AI로 배우는 실무 자동화 콘텐츠 제작','기타','새싹','from-emerald-500 to-green-600',false,87),
('2025.06','성남 시민 창업대학','AI툴 활용 사업 기획','생성형 AI툴로 내 사업 기획하기','기타','성남','from-amber-500 to-orange-600',false,86),
('2025.06','경기 메타버스 캠퍼스','생성형 AI 콘텐츠 제작','생성형 AI로 배우는 실무 자동화 콘텐츠 제작','기타','경기','from-violet-500 to-purple-600',false,85),
('2025.12','남서울대학교','GraphRAG + 온톨로지 세미나','GraphRAG·온톨로지 실전 기술 세미나','대학·교육','NSU','from-slate-600 to-slate-800',false,84),
('2025.09','통계청 × 한경대학교','파이썬 통계분석 실무','파이썬 기반 통계 분석 실무 교육','정부·공공기관','통계','from-teal-500 to-emerald-600',false,83),
('2025.09','호서대학원','AI로 논문 쓰기','AI 도구를 활용한 학술 논문 작성','대학·교육','호서','from-blue-500 to-indigo-600',false,82);
