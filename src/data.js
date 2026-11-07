export const categories = [
  { id: 'overview', title: 'Overview', icon: 'grid', group: 'primary', subtitle: 'YOUR COMMAND CENTER' },
  { id: 'combat', title: 'Combat', icon: 'crosshair', group: 'primary', subtitle: 'PRECISION & CONTROL' },
  { id: 'visuals', title: 'Visuals', icon: 'eye', group: 'primary', subtitle: 'SPATIAL AWARENESS' },
  { id: 'movement', title: 'Movement', icon: 'activity', group: 'primary', subtitle: 'MOTION CONFIGURATION' },
  { id: 'automation', title: 'Automation', icon: 'cpu', group: 'primary', subtitle: 'SMART ASSISTANCE' },
  { id: 'interface', title: 'Appearance', icon: 'sliders', group: 'secondary', subtitle: 'MAKE IT YOURS' },
  { id: 'profiles', title: 'Profiles', icon: 'layers', group: 'secondary', subtitle: 'READY WHEN YOU ARE' },
  { id: 'settings', title: 'Settings', icon: 'settings', group: 'secondary', subtitle: 'SYSTEM CONFIGURATION' },
];

export const controls = [
  { id: 'assist', category:'combat', title:'Aim assistance', description:'Smooth target alignment concept', icon:'crosshair', featured:true, type:'toggle' },
  { id: 'recoil', category:'combat', title:'Recoil compensation', description:'Visual stabilization preset', icon:'target', type:'toggle' },
  { id: 'trigger', category:'combat', title:'Trigger response', description:'Adaptive timing demonstration', icon:'zap', type:'toggle' },
  { id: 'targetPriority', category:'combat', title:'Target priority', description:'Focus selection preference', icon:'users', type:'toggle' },
  { id: 'aimStrength', category:'combat', title:'Assist intensity', description:'Demo interpolation amount', icon:'sliders', type:'range', min:0,max:100,step:1,unit:'%' },
  { id: 'aimFov', category:'combat', title:'Target FOV', description:'Selection cone visualization', icon:'scan', type:'range', min:10,max:180,step:5,unit:'°' },
  { id: 'smoothing', category:'combat', title:'Input smoothing', description:'Higher means more gradual movement', icon:'activity', type:'range', min:1,max:20,step:1,unit:'x' },
  { id: 'boxes', category:'visuals', title:'Player bounding boxes', description:'Demo outlines for tracked units', icon:'box', type:'toggle' },
  { id: 'skeleton', category:'visuals', title:'Skeleton rendering', description:'Joint connections in preview', icon:'activity', type:'toggle' },
  { id: 'tracers', category:'visuals', title:'Direction tracers', description:'Line-based position indicators', icon:'git', type:'toggle' },
  { id: 'nametags', category:'visuals', title:'Name & distance tags', description:'Identity and proximity labels', icon:'tag', type:'toggle' },
  { id: 'radar', category:'visuals', title:'Mini radar', description:'Interactive tactical overview mockup', icon:'radar', type:'toggle' },
  { id: 'chams', category:'visuals', title:'Highlight layers', description:'Multi-tone silhouette demonstration', icon:'layers', type:'toggle' },
  { id: 'visualRange', category:'visuals', title:'Render range', description:'Preview detection radius', icon:'scan', type:'range',min:50,max:500,step:25,unit:'m' },
  { id: 'sprint', category:'movement', title:'Sprint assist', description:'Motion preference toggle', icon:'activity', type:'toggle' },
  { id: 'strafe', category:'movement', title:'Adaptive strafe', description:'Side-step pattern demonstration', icon:'move', type:'toggle' },
  { id: 'jump', category:'movement', title:'Jump timing', description:'Rhythm assistance concept', icon:'zap', type:'toggle' },
  { id: 'camera', category:'movement', title:'Free camera', description:'Camera movement preview mode', icon:'eye', type:'toggle' },
  { id: 'speed', category:'movement', title:'Speed multiplier', description:'Simulated movement feedback', icon:'gauge', type:'range',min:1,max:3,step:.1,unit:'×' },
  { id: 'cameraFov', category:'movement', title:'Camera FOV', description:'Field-of-view preview setting', icon:'scan', type:'range',min:60,max:120,step:5,unit:'°' },
  { id: 'loot', category:'automation', title:'Auto-loot queue', description:'Pickup workflow preview', icon:'box', type:'toggle' },
  { id: 'heal', category:'automation', title:'Smart healing', description:'Health-threshold automation concept', icon:'heart', type:'toggle' },
  { id: 'swap', category:'automation', title:'Quick equipment swap', description:'Context-aware shortcut mockup', icon:'repeat', type:'toggle' },
  { id: 'ping', category:'automation', title:'Auto ping', description:'Demo callout markers for team play', icon:'radar', type:'toggle' },
  { id: 'autoDelay', category:'automation', title:'Action delay', description:'Preview timer interval', icon:'clock', type:'range',min:0,max:500,step:25,unit:'ms' },
];

export const defaultValues = Object.freeze({
  assist:true,recoil:true,trigger:false,targetPriority:true,aimStrength:72,aimFov:85,smoothing:8,
  boxes:true,skeleton:false,tracers:true,nametags:true,radar:true,chams:false,visualRange:250,
  sprint:true,strafe:false,jump:false,camera:false,speed:1.4,cameraFov:90,
  loot:false,heal:true,swap:false,ping:true,autoDelay:175,
  animations:true,compact:false,glow:true,opacity:92,scale:100,accent:'mint',global:true,profile:'Balanced',
});

export const palettes = [
  {id:'mint',name:'Mint',color:'#a7f3d0'},
  {id:'violet',name:'Iris',color:'#c7b9ff'},
  {id:'amber',name:'Amber',color:'#ffd5a4'},
  {id:'ice',name:'Ice',color:'#a8e9ff'},
  {id:'rose',name:'Rose',color:'#ffa7be'},
];

export const presets = [
  {name:'Balanced',tag:'RECOMMENDED',detail:'Confident control with balanced visual feedback.',icon:'layers',overrides:{assist:true,recoil:true,boxes:true,tracers:true,radar:true,smoothing:8,aimStrength:72}},
  {name:'Cinematic',tag:'VISUAL FIRST',detail:'Immersive screen overlays and rich information.',icon:'eye',overrides:{assist:false,recoil:false,boxes:true,skeleton:true,tracers:true,nametags:true,chams:true,radar:true}},
  {name:'Performance',tag:'LIGHTWEIGHT',detail:'Minimal indicators and responsive input settings.',icon:'gauge',overrides:{assist:false,boxes:false,skeleton:false,tracers:false,chams:false,radar:false,animations:false,glow:false}},
  {name:'Creator',tag:'SHOWCASE',detail:'Maximum visual detail for presentation and demos.',icon:'spark',overrides:{boxes:true,skeleton:true,tracers:true,nametags:true,radar:true,chams:true,assist:true,aimFov:120}},
];

export function clampControl(control, value) {
  if (!control || control.type !== 'range') return value;
  const numeric = Number(value);
  if (!Number.isFinite(numeric)) return control.min;
  const steps = Math.round((Math.min(control.max, Math.max(control.min,numeric))-control.min)/control.step);
  return Math.min(control.max, Math.max(control.min, Number((control.min + steps*control.step).toFixed(3))));
}

export function sanitizeState(input) {
  const output = {...defaultValues};
  if (!input || typeof input !== 'object' || Array.isArray(input)) return output;
  for (const c of controls) {
    if (Object.hasOwn(input,c.id)) output[c.id]=c.type==='toggle'?input[c.id] === true:clampControl(c,input[c.id]);
  }
  for (const k of ['animations','compact','glow','global']) if(Object.hasOwn(input,k)) output[k]=input[k]===true;
  for (const [k,min,max] of [['opacity',65,100],['scale',85,110]]) if(Object.hasOwn(input,k)) output[k]=Math.max(min,Math.min(max,Number(input[k])||defaultValues[k]));
  if(palettes.some(p=>p.id===input.accent)) output.accent=input.accent;
  if(typeof input.profile === 'string' && input.profile.length < 40) output.profile=input.profile;
  return output;
}

export function activeCount(state,category) { return controls.filter(c=>c.category===category && c.type==='toggle' && state[c.id]).length; }
export function totalToggles() { return controls.filter(c=>c.type==='toggle').length; }
export function enabledToggles(state) { return controls.filter(c=>c.type==='toggle' && state[c.id]).length; }
