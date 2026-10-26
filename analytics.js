/* Dayoffly v0.0.4 | Privacy-first Google Analytics 4 */
(() => {
  'use strict';
  const MEASUREMENT_ID = 'G-V26YX470D6';
  const CONSENT_KEY = 'dayoffly-analytics-consent-v1';
  const LANGUAGE = () => document.documentElement.lang === 'en' ? 'en' : 'el';
  const t = (el,en) => LANGUAGE() === 'el' ? el : en;
  let active = false;
  let lastView = null;

  function loadAnalytics() {
    if (active || document.querySelector('script[data-dayoffly-ga]')) return;
    active = true;
    window.dataLayer = window.dataLayer || [];
    window.gtag = function() { window.dataLayer.push(arguments); };
    window.gtag('js', new Date());
    window.gtag('config', MEASUREMENT_ID, {send_page_view: true});
    const script = document.createElement('script');
    script.async = true;
    script.dataset.dayofflyGa = 'true';
    script.src = `https://www.googletagmanager.com/gtag/js?id=${MEASUREMENT_ID}`;
    document.head.appendChild(script);
  }

  function track(name,params={}) {
    if (active && typeof window.gtag === 'function') window.gtag('event',name,params);
  }

  function choices() {
    return `<div class="analytics-banner" role="dialog" aria-label="${t('Προτιμήσεις στατιστικών','Analytics preferences')}">
      <div class="analytics-copy"><strong>${t('Βοήθησέ μας να βελτιώσουμε το Dayoffly','Help us improve Dayoffly')}</strong>
      <p>${t('Χρησιμοποιούμε προαιρετικά Google Analytics για ανώνυμα συγκεντρωτικά στατιστικά χρήσης. Δεν αποστέλλουμε τις ημερομηνίες ή τα προσωπικά πλάνα σου.','Optional Google Analytics helps us understand how the app is used. We do not send your dates or personal leave plans.')}</p></div>
      <div class="analytics-buttons">
      <button type="button" class="analytics-no" data-consent-choice="denied">${t('Απόρριψη','Reject')}</button>
      <button type="button" class="analytics-yes" data-consent-choice="granted">${t('Αποδοχή','Accept')}</button>
      </div></div>`;
  }

  function removeBanner() {document.getElementById('dayoffly-consent')?.remove();}
  function showBanner() {
    removeBanner();
    const wrap=document.createElement('div'); wrap.id='dayoffly-consent'; wrap.innerHTML=choices();
    document.body.appendChild(wrap);
  }

  function setConsent(choice) {
    localStorage.setItem(CONSENT_KEY,choice);
    removeBanner();
    if(choice==='granted') loadAnalytics();
    else if(active) { // Stop further event emission. Reload clears an already-loaded GA library.
      active=false; location.reload();
    }
  }

  // Keep controls outside #app so the main UI can re-render without dismissing them.
  document.addEventListener('click', e => {
    const consentButton=e.target.closest('[data-consent-choice]');
    if(consentButton) {setConsent(consentButton.dataset.consentChoice);return;}
    if(e.target.closest('[data-analytics-settings]')) {showBanner();return;}
    const view=e.target.closest('[data-view]')?.dataset.view;
    const action=e.target.closest('[data-action]')?.dataset.action;
    if(view && view!==lastView) {
      lastView=view;
      track('screen_navigation',{screen_name:view});
    }
    const events={lang:'language_switch',calculate:'leave_optimizer_run',save:'leave_plan_save',ics:'calendar_export',share:'plan_share',manual:'manual_plan_create'};
    if(action && events[action]) track(events[action],action==='lang'?{language:LANGUAGE()==='el'?'en':'el'}:{});
  },true);

  function addPrivacyControl() {
    if(document.getElementById('dayoffly-analytics-settings')) return;
    const footer=document.querySelector('.footer .shell');
    if(!footer) return;
    const btn=document.createElement('button');
    btn.type='button';btn.id='dayoffly-analytics-settings';btn.className='analytics-settings';
    btn.dataset.analyticsSettings='';
    btn.textContent=t('Ρυθμίσεις Analytics','Analytics settings');
    footer.appendChild(btn);
  }
  const obs=new MutationObserver(() => {
    addPrivacyControl();
    const btn=document.getElementById('dayoffly-analytics-settings');
    if(btn) btn.textContent=t('Ρυθμίσεις Analytics','Analytics settings');
    const banner=document.getElementById('dayoffly-consent');
    if(banner) banner.innerHTML=choices();
  });
  obs.observe(document.getElementById('app')||document.body,{childList:true,subtree:false});
  addPrivacyControl();

  let consent;
  try {consent=localStorage.getItem(CONSENT_KEY);}catch{}
  if(consent==='granted') loadAnalytics();
  else if(consent!=='denied') showBanner();
})();
