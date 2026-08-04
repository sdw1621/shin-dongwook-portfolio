# 신동욱 | AI 교육 전문가 포트폴리오

생성형 AI · 빅데이터 · 프로그래밍 교육 전문가 **신동욱** 강사의 포트폴리오 사이트입니다.

## 구성
- `index.html` — 메인 (히어로 + 핵심 지표)
- `about.html` — 소개
- `skills.html` — 전문 분야
- `experience.html` — 주요 이력
- `clients.html` — 협업 기관
- `publications.html` — 저서 & 연구
- `contact.html` — 문의하기

## 기술
- 정적 HTML (멀티 페이지)
- Tailwind CSS (CDN) · Pretendard 폰트
- 이미지는 base64로 내장되어 외부 의존성 없음

## 멀티유저 (신규 인원 로그인 + 개인 공개 포트폴리오)
- `admin.html` — 로그인/회원가입. 신규 인원은 직접 가입 후 **본인 이력만** 관리
- `/@<handle>` — 사용자별 공개 포트폴리오 (소개·전문분야·이력)
  · GitHub Pages 의 `404.html` 폴백을 이용한 깔끔한 주소 (`portfolio.js` 공용 렌더러)
  · `portfolio.html?u=<handle>` 형태도 그대로 동작 (자동으로 `/@handle` 로 정리)
- 각 사용자는 관리자 화면의 **내 프로필**에서 이름·주소(handle)·소개·전문분야를 편집

### Supabase 설정 순서
1. `supabase_setup.sql` 실행 (careers 테이블)
2. `multiuser_setup.sql` 실행 (사용자별 데이터 분리 — 회원가입 켜기 전 필수)
3. `profiles_setup.sql` 실행 (프로필/공개 페이지)
4. Authentication → Providers 에서 회원가입(Allow new users to sign up) 활성화
5. (선택) `config.js` 의 `ownerUserId` 에 소유자 UUID 를 넣으면
   `experience.html` 공개 페이지는 소유자 이력만 표시

---
© 2026 신동욱 (Shin Dong Wook). All rights reserved.
