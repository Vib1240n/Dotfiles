
const API_STATS="/stats";
const SUBMIT_URL="/yearbook/submit";
const morph=document.getElementById("morph");
const formInner=document.getElementById("formInner");
const label=document.getElementById("label");
const textarea=document.getElementById("msg");
const form=document.getElementById("yearbookForm");
const cancelBtn=document.getElementById("cancelBtn");
const toast=document.getElementById("toast");
const note = document.getElementById("note");
let noteTimer = null;

function parseCssTime(str){
  str = (str||'700ms').trim();
  if(str.endsWith('ms')) return parseFloat(str);
  if(str.endsWith('s')) return parseFloat(str)*1000;
  return parseFloat(str);
}
const root = getComputedStyle(document.documentElement);
const morphDur = parseCssTime(root.getPropertyValue('--morph-duration'));
const NOTE_BUFFER = 80;

function showToast(text,time=3500){
  toast.textContent=text;
  toast.classList.add("show");
  setTimeout(()=>toast.classList.remove("show"),time);
}

function openMorph(){
  morph.classList.add("open");
  label.style.display="none";
  formInner.style.display='block';
  setTimeout(()=>{ formInner.style.opacity="1"; formInner.style.transform='none'; }, 60);
  note.classList.remove('note-visible');
  clearTimeout(noteTimer);
  noteTimer = setTimeout(()=> note.classList.add('note-visible'), morphDur + NOTE_BUFFER);
  textarea.focus();
}

function closeMorph(){
  formInner.style.opacity="0";
  formInner.style.transform='translateY(8px)';
  clearTimeout(noteTimer);
  note.classList.remove('note-visible');
  setTimeout(()=>{ formInner.style.display="none"; morph.classList.remove("open"); label.style.display="block"; }, 500);
}

morph.addEventListener("click",e=>{ if(!morph.classList.contains("open")) openMorph(); });
morph.addEventListener("keydown",e=>{ if(e.key==="Enter"&&!morph.classList.contains("open")) openMorph(); });
cancelBtn.addEventListener("click",e=>{ e.preventDefault(); textarea.value=""; closeMorph(); });

form.addEventListener("submit",async e=>{
  e.preventDefault();
  const hp=document.getElementById("hp").value;
  if(hp && hp.trim()!==""){ showToast("Bot detected"); return; }
  const msgVal=(textarea.value||"").trim();
  if(!msgVal){ showToast("Type a message"); return; }
  if(msgVal.length>100){ showToast("Maximum 100 characters"); return; }
  const last=parseInt(localStorage.getItem("rx_last_submit")||"0",10);
  const now=Date.now();
  const twelve=12*60*60*1000;
  if(now-last < twelve){
    const ms=twelve-(now-last);
    const hrs=Math.ceil(ms/36e5);
    showToast("You can submit again in "+hrs+"h");
    return;
  }
  try{
    const res=await fetch(SUBMIT_URL,{ method:"POST", headers:{"Content-Type":"application/json"}, body:JSON.stringify({message:msgVal}) });
    if(res.ok){
      localStorage.setItem("rx_last_submit",String(now));
      textarea.value="";
      closeMorph();
      showToast("Your message is pending approval");
    } else {
      const j=await res.json().catch(()=>({}));
      showToast(j.error||"Submission failed");
    }
  }catch(err){
    showToast("Network error");
  }
});

async function loadStats(){
  try{
    const r=await fetch(API_STATS);
    const data=await r.json();
    const g=data.guilds||[];
    if(g[0] && g[0].icon) document.getElementById("mainIcon").src=g[0].icon;
    if(g[0] && typeof g[0].members!=="undefined") document.getElementById("mainCount").textContent=g[0].members+" Members";
    if(g[1] && g[1].icon) document.getElementById("backupIcon").src=g[1].icon;
    document.body.classList.add("cards-loaded");
  }catch(e){
    document.getElementById("mainCount").textContent="Unavailable";
    document.body.classList.add("cards-loaded");
  }
}

async function loadSplash(){
  let messages=[];
  try{
    const r=await fetch("/yearbook");
    const j=await r.json();
    messages=j.approved||[];
  }catch{}
  if(!messages.length) messages=["Freedom For All"];
  const el=document.getElementById("splash");
  function rotate(){
    const msg=messages[Math.floor(Math.random()*messages.length)];
    el.classList.remove("show");
    setTimeout(()=>{ el.textContent=msg; el.classList.add("show"); },300);
  }
  rotate();
  setInterval(rotate,5000);
}

loadStats();
loadSplash();

/* ReduxSMP hover logic */
const smpCard = document.getElementById("smpCard");
if(smpCard){
  const EXPAND_MS = 250;
  const FADE_MS = 250;
  let hoverTimeout = null;
  let leaveTimeout = null;

  smpCard.addEventListener("mouseenter", () => {
    clearTimeout(hoverTimeout);
    clearTimeout(leaveTimeout);
    smpCard.classList.add("smp-expand");
    hoverTimeout = setTimeout(() => {
      smpCard.classList.add("smp-show-text");
    }, EXPAND_MS);
  });

  smpCard.addEventListener("mouseleave", () => {
    clearTimeout(hoverTimeout);
    smpCard.classList.remove("smp-show-text");
    leaveTimeout = setTimeout(() => {
      smpCard.classList.remove("smp-expand");
    }, FADE_MS);
  });
}
