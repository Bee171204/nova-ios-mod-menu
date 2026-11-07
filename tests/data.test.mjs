import test from 'node:test';
import assert from 'node:assert/strict';
import {categories,controls,defaultValues,clampControl,sanitizeState,activeCount,totalToggles,enabledToggles,presets} from '../src/data.js';

test('unique category and control IDs',()=>{
 assert.equal(new Set(categories.map(x=>x.id)).size,categories.length);
 assert.equal(new Set(controls.map(x=>x.id)).size,controls.length);
});
test('all controls have matching nav category',()=>{
 for(const c of controls)assert(categories.some(n=>n.id===c.category));
});
test('range controls clamp and quantize',()=>{
 const c=controls.find(x=>x.id==='speed');
 assert.equal(clampControl(c,-9),1);assert.equal(clampControl(c,999),3);
 assert.equal(clampControl(c,1.37),1.4);
});
test('invalid imported state cannot inject arbitrary keys',()=>{
 const state=sanitizeState({__proto__:{hacked:true},aimStrength:900,assist:'true',accent:'evil',profile:'<img src=x onerror=alert(1)>'});
 assert.equal(state.aimStrength,100);
 assert.equal(state.assist,false);
 assert.equal(state.accent,'mint');
 assert.equal(Object.hasOwn(state,'hacked'),false);
});
test('counts only toggle controls',()=>{
 assert.equal(totalToggles(),controls.filter(c=>c.type==='toggle').length);
 assert.equal(enabledToggles(defaultValues),controls.filter(c=>c.type==='toggle'&&defaultValues[c.id]).length);
 assert.equal(activeCount(defaultValues,'combat'),controls.filter(c=>c.type==='toggle'&&c.category==='combat'&&defaultValues[c.id]).length);
});
test('all profile overrides map to known keys',()=>{
 for(const p of presets)for(const key of Object.keys(p.overrides))assert(Object.hasOwn(defaultValues,key));
});
test('at least 25 configurable functions',()=>assert(controls.length>=25));
