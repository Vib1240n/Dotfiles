"use strict";var O=Object.create;var S=Object.defineProperty;var U=Object.getOwnPropertyDescriptor;var j=Object.getOwnPropertyNames;var Q=Object.getPrototypeOf,G=Object.prototype.hasOwnProperty;var V=(i,e)=>{for(var a in e)S(i,a,{get:e[a],enumerable:!0})},N=(i,e,a,s)=>{if(e&&typeof e=="object"||typeof e=="function")for(let c of j(e))!G.call(i,c)&&c!==a&&S(i,c,{get:()=>e[c],enumerable:!(s=U(e,c))||s.enumerable});return i};var q=(i,e,a)=>(a=i!=null?O(Q(i)):{},N(e||!i||!i.__esModule?S(a,"default",{value:i,enumerable:!0}):a,i)),B=i=>N(S({},"__esModule",{value:!0}),i);var J={};V(J,{default:()=>L});module.exports=B(J);var t=require("@raycast/api"),f=require("react");var b=require("react");var y=require("os"),p=require("fs"),g=q(require("path")),Y=["com.lukilabs.lukiapp","com.lukilabs.lukiapp-setapp"],[k]=Y.map(i=>g.default.join((0,y.homedir)(),`/Library/Containers/${i}/Data/Library/Application Support/${i}`)).filter(p.existsSync),_=g.default.join(k,"Search"),D=g.default.join(k,"raycast-spaces-config.json"),d=class{constructor(){this.spaceSettings={};this.primarySpace=()=>this.spaces.find(e=>e.primary);this.buildFilterRegexForExistingRealms=()=>{let e=k.replace("~",(0,y.homedir)()),a=(0,p.readdirSync)(e).filter(this.selectRealmFiles).map(this.extractSpaceIDs).filter(s=>s).join("|");return new RegExp(`(?:${a})[^.]*.sqlite$`)};this.selectRealmFiles=e=>e.match(/\.realm$/)!==null;this.extractSpaceIDs=e=>{let a=e.split("_");if(a.length===3)return a[1].split("||").pop()};this.makeSpaceFromStr=(e,a)=>{let s=a.match(/\w{8}-\w{4}-\w{4}-\w{4}-\w{12}/g)?.pop()||"",c=this.spaceSettings[s];return{primary:!a.includes("||"),path:g.default.join(e,a),spaceID:s,customName:c?.customName||null,isEnabled:c?.isEnabled??!0}};this.getSpaceDisplayName=e=>{let a=this.spaces.find(s=>s.spaceID===e);return a?a.customName?a.primary?`${a.customName} (Primary)`:a.customName:a.primary?`${e} (Primary)`:e:e};this.setSpaceCustomName=(e,a)=>{let s=this.spaces.find(c=>c.spaceID===e);s&&(s.customName=a),this.spaceSettings[e]||(this.spaceSettings[e]={customName:null,isEnabled:!0}),this.spaceSettings[e].customName=a,this.saveSpaceSettings()};this.toggleSpaceEnabled=e=>{let a=this.spaces.find(s=>s.spaceID===e);a&&(a.isEnabled=!a.isEnabled),this.spaceSettings[e]||(this.spaceSettings[e]={customName:null,isEnabled:!0}),this.spaceSettings[e].isEnabled=a?.isEnabled??!0,this.saveSpaceSettings()};this.getEnabledSpaces=()=>this.spaces.filter(e=>e.isEnabled);this.getAllSpacesForDropdown=()=>this.getEnabledSpaces().map(e=>({id:e.spaceID,title:this.getSpaceDisplayName(e.spaceID)}));this.loadSpaceSettings=()=>{try{if((0,p.existsSync)(D)){let e=(0,p.readFileSync)(D,"utf-8");this.spaceSettings=JSON.parse(e)}else this.spaceSettings={}}catch(e){console.debug(`Failed to load space settings: ${e}`),this.spaceSettings={}}};this.saveSpaceSettings=()=>{try{(0,p.writeFileSync)(D,JSON.stringify(this.spaceSettings,null,2))}catch(e){console.debug(`Failed to save space settings: ${e}`)}};try{let e=_.replace("~",(0,y.homedir)()),a=this.buildFilterRegexForExistingRealms();this.loadSpaceSettings(),this.spaces=(0,p.readdirSync)(e).filter(s=>s.match(a)).map(s=>this.makeSpaceFromStr(e,s))}catch(e){console.debug(`failed getting files: ${e}`),this.spaces=[]}}};function I({appExistsLoading:i,appExists:e}){let[a,s]=(0,b.useState)({configLoading:!0,config:null}),c=()=>{if(!i){if(!e)return s(u=>({...u,configLoading:!1}));s({configLoading:!1,config:new d})}},m=()=>{e&&s({configLoading:!1,config:new d})};return(0,b.useEffect)(()=>{c()},[i]),{...a,refreshConfig:m}}var E=require("react"),F=require("@raycast/api");var C=require("@raycast/api"),T=["com.lukilabs.lukiapp","com.lukilabs.lukiapp-setapp"],A=()=>(0,C.getPreferenceValues)();function x(){let[i,e]=(0,E.useState)({appExistsLoading:!0,appExists:!1});return(0,E.useEffect)(()=>{(async()=>{let s=await(0,F.getApplications)(),c=A().application,m=s.find(r=>r.bundleId&&T.includes(r.bundleId));if(!(c||m))return e({appExistsLoading:!1,appExists:!1});e({appExistsLoading:!1,appExists:!0})})()},[]),i}var P=require("@raycast/api"),v=require("react/jsx-runtime");function w(){return(0,v.jsx)(P.Detail,{markdown:`
# How to Find Your Space IDs

*This tutorial can be accessed anytime through the command's action menu (\u2318+K) or directly (\u2318+T)*

---

Space IDs are unique identifiers that Craft uses internally to distinguish between different spaces in your account.

## Why Do You Need This?

- **Better Organization**: Instead of seeing cryptic IDs like "1ab23c45-67de-89f0-1g23-hijk456789l0", you can rename them to names like "Personal Space" or "Team Space"
- **Space Management**: Enable or disable specific spaces across all extension commands
- **Consistent Naming**: Use the same space names throughout all Craft extension commands

## Step-by-Step Guide

### 1. Open Craft App
Navigate to any Space you want to identify.

### 2. Open Any Document
Navigate to any document within that space.

### 3. Right-Click (Secondary Click)
Right-click on any block within the document.

### 4. Copy the Deeplink
From the context menu that appears:
1. Select **"Copy As"**
2. Then select **"Deeplink"**

### 5. Extract the Space ID
The deeplink will be copied to your clipboard and looks something like this:

\`\`\`
craftdocs://open?blockId=ABC123&spaceId=1ab23c45-67de-89f0-1g23-hijk456789l0
\`\`\`

The **Space ID** is the long string after \`spaceId=\` in the URL.

In this example: \`1ab23c45-67de-89f0-1g23-hijk456789l0\`

### 6. Use in Manage Spaces
Now you can use the Manage Spaces command to:
- Rename this cryptic ID as you wish
- Enable or disable this space across all extension commands

## Tips

- **Multiple Spaces**: Repeat this process for each space you want to manage
- **Any Block Works**: You can right-click on any block in a space to get its Space ID
- **Consistent IDs**: The Space ID remains the same for all blocks within the same space
- **One-Time Setup**: Once you've renamed your spaces, you won't need to do this again

## Troubleshooting

**Can't find "Copy As" option?**
- Make sure you're right-clicking directly on text or a block, not empty space
- Try right-clicking on a document title in the sidebar

**Space ID looks different?**
- Space IDs are always long strings of letters, numbers, and dashes
- Each space has a unique ID - they should all look different

`})}var n=require("react/jsx-runtime");function z({spaceID:i,currentName:e,onRename:a}){let{pop:s}=(0,t.useNavigation)(),[c,m]=(0,f.useState)(e||""),u=()=>{let r=c.trim()||null;a(i,r),(0,t.showToast)({title:r?"Space renamed":"Custom name removed",style:t.Toast.Style.Success}),s()};return(0,n.jsxs)(t.Form,{actions:(0,n.jsxs)(t.ActionPanel,{children:[(0,n.jsx)(t.Action.SubmitForm,{title:"Save Name",onSubmit:u}),(0,n.jsx)(t.Action,{title:"Cancel",onAction:s})]}),children:[(0,n.jsx)(t.Form.TextField,{id:"name",title:"Space Name",value:c,onChange:m,placeholder:"Enter custom name (leave empty to use Space ID)"}),(0,n.jsx)(t.Form.Description,{text:`Space ID: ${i}`})]})}function L(){let i=x(),{config:e,configLoading:a,refreshConfig:s}=I(i),{push:c}=(0,t.useNavigation)(),[m,u]=(0,f.useState)(!1);(0,f.useEffect)(()=>{(async()=>{await t.LocalStorage.getItem("hasSeenSpaceIdTutorial")||(u(!0),await t.LocalStorage.setItem("hasSeenSpaceIdTutorial","true"))})()},[]);let r=()=>{c((0,n.jsx)(w,{}))};(0,f.useEffect)(()=>{m&&e&&e.spaces.length>0&&(r(),u(!1))},[m,e]);let R=(o,l)=>{e&&(e.setSpaceCustomName(o,l),s())},$=async(o,l)=>{if(!e)return;let h=e.spaces.find(M=>M.spaceID===o);if(!h)return;if(h.primary&&l){await(0,t.showToast)({title:"Cannot disable primary space",message:"The primary space cannot be disabled",style:t.Toast.Style.Failure});return}await(0,t.confirmAlert)({title:l?"Disable Space":"Enable Space",message:l?"This space will be hidden from search results and other commands.":"This space will be shown in search results and other commands.",primaryAction:{title:l?"Disable":"Enable",style:t.Alert.ActionStyle.Default}})&&(e.toggleSpaceEnabled(o),s(),(0,t.showToast)({title:l?"Space disabled":"Space enabled",style:t.Toast.Style.Success}))};return!i.appExists||!e?(0,n.jsx)(t.List,{actions:(0,n.jsx)(t.ActionPanel,{children:(0,n.jsx)(t.Action,{title:"Show Space ID Tutorial",icon:t.Icon.QuestionMark,onAction:r,shortcut:{modifiers:["cmd"],key:"t"}})}),children:(0,n.jsx)(t.List.EmptyView,{title:"Craft not found",description:"Make sure Craft is installed and configured properly",icon:"command-icon-small.png"})}):e.spaces.length===0?(0,n.jsx)(t.List,{actions:(0,n.jsx)(t.ActionPanel,{children:(0,n.jsx)(t.Action,{title:"Show Space ID Tutorial",icon:t.Icon.QuestionMark,onAction:r,shortcut:{modifiers:["cmd"],key:"t"}})}),children:(0,n.jsx)(t.List.EmptyView,{title:"No spaces found",description:"Try using Craft app first to initialize your spaces",icon:"command-icon-small.png"})}):(0,n.jsx)(t.List,{isLoading:a,children:(0,n.jsx)(t.List.Section,{title:`${e.spaces.length} Space${e.spaces.length===1?"":"s"} Found`,children:e.spaces.map(o=>{let l=e.getSpaceDisplayName(o.spaceID),h=o.customName!==null;return(0,n.jsx)(t.List.Item,{title:l,subtitle:h?`ID: ${o.spaceID}`:void 0,accessories:[...o.primary?[{tag:"Primary"}]:[],{tag:{value:o.isEnabled?"Enabled":"Disabled",color:o.isEnabled?"#00FF00":"#FF0000"}}],actions:(0,n.jsxs)(t.ActionPanel,{children:[(0,n.jsx)(t.Action.Push,{title:"Rename Space",icon:t.Icon.Pencil,target:(0,n.jsx)(z,{spaceID:o.spaceID,currentName:o.customName,onRename:R})}),(0,n.jsx)(t.Action,{title:o.isEnabled?"Disable Space":"Enable Space",icon:o.isEnabled?t.Icon.EyeDisabled:t.Icon.Eye,onAction:()=>$(o.spaceID,o.isEnabled)}),(0,n.jsx)(t.Action.CopyToClipboard,{title:"Copy Space ID",content:o.spaceID,shortcut:{modifiers:["cmd"],key:"c"}}),(0,n.jsx)(t.Action,{title:"Show Space ID Tutorial",icon:t.Icon.QuestionMark,onAction:r,shortcut:{modifiers:["cmd"],key:"t"}})]})},o.spaceID)})})})}
