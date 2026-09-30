-- 프로젝트 · 연구 탭(kind='project') 실적 추가
-- 출처: Google Drive '251228_신동욱_AI_교육_전문가_이력서.pdf' (주요 프로젝트 포트폴리오·컨설팅 실적),
--       '신동욱 이력서.PDF' (2026.09 사이트 출력본 · 경력 란)
-- 사용: Supabase SQL Editor 에서 실행 (이미 같은 org+title 이 있으면 건너뜀 → 여러 번 실행해도 안전)
-- ⚠ period 가 비어 있는 행은 이력서에 기간이 없던 항목입니다. 관리자 페이지에서 기간을 채워 주세요.
-- ⚠ 성과 수치(%, 건수)는 본인 이력서 기재 내용 그대로입니다. 게시 전 사실 여부를 확인하세요.

insert into public.careers (period, kind, org, title, description, category, badge, color, featured, sort_order, user_id)
select v.period, 'project', v.org, v.title, v.description, v.category, v.badge, v.color, false, 0,
       (select id from auth.users where email = 'sdw1904@naver.com')
from (values
  ('2024.07', '한국수력원자력', '로컬 LLM 챗봇 개발 컨설팅',
   'EEVE 기반 생성형 AI 챗봇 설계·개발 컨설팅. 챗봇 서비스 론칭.',
   '정부·공공기관', '한수원', 'from-blue-600 to-indigo-700'),
  ('2024.08', '스피드렉', 'AI 현장 적용 컨설팅',
   '생성형 AI를 현장 업무에 적용하는 컨설팅. 업무 효율 40% 향상.',
   '기타', '스피드렉', 'from-teal-500 to-cyan-600'),
  ('2024.05', '한국건설기술연구원', 'R&D 창의적 문제해결 컨설팅',
   '연구개발 현장의 문제 해결 프로세스를 생성형 AI로 재설계. 연구 프로세스 혁신.',
   '정부·공공기관', 'KICT', 'from-blue-600 to-indigo-700'),
  ('2023 ~ 2024', '다수 기업 (10개 이상)', 'ChatGPT 기반 업무 자동화 시스템',
   'ChatGPT API · LangChain · RAG 로 문서 작성, 이메일, 데이터 분석 업무를 자동화. 평균 30% 시간 절감.',
   '기타', 'GPT', 'from-teal-500 to-cyan-600'),
  ('', 'AI인터시스', '멀티모달 콘텐츠 제작 파이프라인',
   'GPT-4o · Stable Diffusion · ElevenLabs TTS 로 텍스트 → 이미지 → 영상을 자동 생성. 가상인간 홍보 영상·교육 콘텐츠에 활용.',
   '기타', 'AI', 'from-teal-500 to-cyan-600'),
  ('', 'AI인터시스', 'RAG 기반 기업 내부 문서 검색 시스템',
   'LangChain · Chroma DB · OpenAI Embeddings 기반 사내 문서 검색 엔진. 정보 검색 시간 80% 단축.',
   '기타', 'RAG', 'from-teal-500 to-cyan-600'),
  ('', '서울시 청소년 복지센터', '설문조사 웹앱 + 빅데이터 분석 시스템',
   'Python Django · 머신러닝 기반 설문 웹앱. 5,000건 이상의 설문 데이터를 분석·시각화.',
   '정부·공공기관', '서울시', 'from-blue-600 to-indigo-700'),
  ('', '세종사이버대학교', '외식·프랜차이즈 SNS 트렌드 분석 대시보드',
   '네이버·인스타그램 크롤링과 NLP 로 실시간 트렌드 분석 대시보드 구현. 교육 과정에 활용.',
   '대학·교육', '세종', 'from-violet-500 to-purple-600'),
  ('2022', '한국정보처리학회', '딥러닝 표정 인식 기반 유튜브 하이라이트 자동화(RPA)',
   'OpenCV·딥러닝 표정 인식으로 운동 영상 하이라이트를 자동 추출·업로드. 2022 춘계학술발표대회 논문 발표. 편집 시간 90% 단축.',
   '대학·교육', 'KIPS', 'from-violet-500 to-purple-600'),
  ('2020.01 ~ 2020.03', 'BN시스템', '애니메이션 공모전 웹 사이트 개발',
   '애니메이션 공모전 웹 사이트 개발 총괄 (개발 팀장).',
   '기타', 'BN', 'from-teal-500 to-cyan-600'),
  ('2019.07 ~ 2020.01', '빅베이스', '암호화폐 전자지갑·블록체인 거래소 개발',
   '블록체인 기반 다중 암호화폐 전자지갑과 거래소 개발·서비스. 다중 서명, 콜드 월렛 등 보안 설계.',
   '대기업·금융', '빅베이스', 'from-slate-700 to-slate-900'),
  ('2018.08 ~ 2018.09', '애니스소프트', '4개 선물회사 위험기반 자금세탁방지 체계 구축',
   '현대·삼성·NH·유진 4개 선물회사 대상 위험기반 자금세탁방지(AML) 체계 구축.',
   '대기업·금융', 'AML', 'from-slate-700 to-slate-900'),
  ('2017.09 ~ 2019.05', '애니스소프트', '라이프코어 이온수기 클라우드 시스템 구축',
   'AWS · 젠킨스 · 플러터 · PHP 기반 이온수기 클라우드 시스템 구축.',
   '기타', '라이프', 'from-teal-500 to-cyan-600'),
  ('2011.08 ~ 2013.01', '코리아로지스', '모바일 물류 솔루션 (Android)',
   '공차정보·화물정보·트럭 위치 추적 기능의 Android 앱 개발 (Java/Kotlin, GPS API).',
   '기타', '물류', 'from-teal-500 to-cyan-600')
) as v(period, org, title, description, category, badge, color)
where not exists (
  select 1 from public.careers c
  where c.kind = 'project'
    and lower(trim(c.org)) = lower(trim(v.org))
    and lower(trim(c.title)) = lower(trim(v.title))
);
