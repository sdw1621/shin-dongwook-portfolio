// ============================================================
//  공개 포트폴리오 렌더러 (portfolio.html · 404.html 공용)
//  주소 형태:  /@<handle>   또는   portfolio.html?u=<handle>
// ============================================================
(function(){
    var $ = function(id){ return document.getElementById(id); };
    var esc = function(s){ return (s||'').replace(/[&<>"]/g, function(c){ return {'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'}[c]; }); };
    function show(id){ $('loading').classList.add('hidden'); $(id).classList.remove('hidden'); }
    function fail(msg){ if(msg) $('notfoundMsg').textContent = msg; show('notfound'); }

    // handle 추출: ?u= 우선, 없으면 경로의 /@handle
    var params = new URLSearchParams(location.search);
    var handle = params.get('u') || '';
    if(!handle){ var m = location.pathname.match(/@([^\/?#]+)/); if(m) handle = decodeURIComponent(m[1]); }
    handle = (handle||'').trim().toLowerCase().replace(/[^a-z0-9-]/g, '');
    if(!handle){ fail('주소에 사용자 아이디가 없습니다. (예: /@아이디)'); return; }

    var cfg = window.SUPABASE_CONFIG || {};
    if(!cfg.url || !cfg.anonKey || cfg.url.indexOf('PASTE_') >= 0 || !window.supabase){
        fail('사이트 설정이 완료되지 않았습니다.'); return;
    }
    var sb = window.supabase.createClient(cfg.url, cfg.anonKey);

    var CAT_COLOR = {'대기업·금융':'from-slate-700 to-slate-900','정부·공공기관':'from-blue-600 to-indigo-700','대학·교육':'from-violet-500 to-purple-600','기타':'from-teal-500 to-cyan-600'};
    function grad(r){ return r.featured ? (esc(r.color)||'from-blue-600 to-indigo-700') : (CAT_COLOR[r.category]||'from-teal-500 to-cyan-600'); }
    function initials(name){ var n=(name||'').trim(); if(!n) return '👤'; var parts=n.split(/\s+/); return (parts.length>1 ? parts[0][0]+parts[1][0] : n.slice(0,2)); }
    function badge(r){ var b=(r.badge||'').trim(); if(b) return esc(b.slice(0,4)); return esc((r.org||'').slice(0,2)); }

    function card(r){
        return '<div class="bg-white rounded-2xl border border-gray-100 p-6 shadow-sm hover:shadow-lg hover:-translate-y-0.5 transition-all duration-300">'
          + '<div class="flex items-start justify-between gap-3 mb-4">'
            + '<div class="w-11 h-11 shrink-0 rounded-xl bg-gradient-to-br '+grad(r)+' flex items-center justify-center text-white font-extrabold text-sm shadow">'+badge(r)+'</div>'
            + '<span class="text-xs font-semibold text-gray-400 pt-1">'+(esc(r.period)||'')+'</span>'
          + '</div>'
          + '<h3 class="font-bold leading-tight mb-1">'+esc(r.org)+'</h3>'
          + (r.title ? '<p class="text-sm text-brand font-semibold mb-1.5">'+esc(r.title)+'</p>' : '')
          + (r.description ? '<p class="text-sm text-gray-500 leading-relaxed">'+esc(r.description)+'</p>' : '')
          + '</div>';
    }

    (async function(){
        try{
            var pr = await sb.from('profiles').select('*').eq('handle', handle).maybeSingle();
            if(pr.error){ fail('프로필을 불러오지 못했습니다: '+pr.error.message); return; }
            var p = pr.data;
            if(!p){ fail('"'+handle+'" 사용자를 찾을 수 없습니다.'); return; }

            // 주소 정규화: 항상 /@handle 형태로 (리다이렉트 없이 주소창만 정리)
            try{
                var base = location.pathname.replace(/(portfolio\.html|404\.html|@[^\/?#]+)$/,'').replace(/\/$/,'');
                var clean = base + '/@' + handle;
                if(location.pathname + location.search !== clean){ history.replaceState(null, '', clean); }
            }catch(_){}

            document.title = (p.display_name || handle) + ' | 포트폴리오';
            $('name').textContent = p.display_name || handle;
            $('avatar').textContent = initials(p.display_name);
            $('footName').textContent = p.display_name || handle;
            if(p.headline){ $('headline').textContent = p.headline; } else { $('headline').classList.add('hidden'); }
            if(p.bio){ $('bio').textContent = p.bio; } else { $('bio').classList.add('hidden'); }

            var skills = (p.skills||'').split(',').map(function(s){ return s.trim(); }).filter(Boolean);
            if(skills.length){
                $('skills').innerHTML = skills.map(function(s){
                    return '<span class="px-4 py-2 rounded-full bg-white border border-gray-200 text-sm font-medium text-gray-700 shadow-sm">'+esc(s)+'</span>';
                }).join('');
                $('skillsSec').classList.remove('hidden');
            }

            var cr = await sb.from('careers').select('*').eq('user_id', p.id)
                .order('sort_order', {ascending:false}).order('created_at', {ascending:false});
            var careers = cr.data || [];
            if(careers.length){
                $('expList').innerHTML = careers.map(card).join('');
                $('expSec').classList.remove('hidden');
            }

            show('content');
        }catch(e){ fail('오류가 발생했습니다: '+e.message); }
    })();
})();
