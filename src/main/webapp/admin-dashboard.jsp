<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, com.inventory.model.Product" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page import="com.inventory.model.User" %>
<%@ page import="com.inventory.model.StockMovement" %>
<%
    // Security Check: Ensure user is Admin
    User currentUser = (User)session.getAttribute("activeUser");
    if(currentUser == null || !currentUser.getRole().equals("ADMIN")) {
        response.sendRedirect("Login.jsp");
        return;
    }
    

    // Intel Extraction
    List<Product> expired = (List<Product>) request.getAttribute("expired");
    if (expired == null) expired = new ArrayList<>();

    List<Product> lowStock = (List<Product>) request.getAttribute("lowStock");
    if (lowStock == null) lowStock = new ArrayList<>();

    List<Map<String, String>> managers = (List<Map<String, String>>) request.getAttribute("managers");
    if (managers == null) managers = new ArrayList<>();

    Object managerCount = request.getAttribute("managerCount");
    Object expiredCount = request.getAttribute("expiredCount");
    Object lowStockCount = request.getAttribute("lowStockCount");
    Object alertCount = request.getAttribute("alertCount");
%>

<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>Admin Dashboard | InvenTrack</title>
<link rel="preconnect" href="https://fonts.googleapis.com"/>
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300..700&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet"/>
<link rel="stylesheet" href="css/styles.css">
<style>
:root,[data-theme="light"]{
  --bg:#f7f6f2;--surface:#ffffff;--surface2:#f9f8f5;--surface-off:#f3f0ec;--surface-accent:#eef4f4;
  --divider:#e5e3de;--border:#d8d5ce;--text:#1c1a15;--text-m:#6b6965;--text-f:#a8a5a0;--text-inv:#f9f8f4;
  --primary:#01696f;--primary-h:#0c4e54;--primary-l:#e0f0ef;--blue:#2265b1;--blue-l:#e7f0fb;
  --safe:#437a22;--safe-bg:#eef5e8;--warn-l:#f5f0df;--warn-m:#f0e0b0;--warn-d:#c88a00;
  --crit-l:#fdeee6;--crit-m:#f8c9aa;--crit-d:#b84800;--exp-bg:#f9e5e5;--exp-t:#8b1c1c;--exp-b:#e8b4b4;
  --shadow-sm:0 1px 2px oklch(0.2 0.01 80/0.06);--shadow-md:0 4px 16px oklch(0.2 0.01 80/0.08);
  --r-sm:.375rem;--r-md:.5rem;--r-lg:.75rem;--r-xl:1rem;--r-f:9999px;
  --font:'Inter',sans-serif;--mono:'DM Mono',monospace;
  --sp1:.25rem;--sp2:.5rem;--sp3:.75rem;--sp4:1rem;--sp5:1.25rem;--sp6:1.5rem;--sp8:2rem;
  --tx-xs:clamp(.75rem,.7rem + .25vw,.875rem);--tx-sm:clamp(.875rem,.8rem + .35vw,1rem);
  --tx-b:clamp(1rem,.95rem + .25vw,1.125rem);--tx-lg:clamp(1.125rem,1rem + .75vw,1.5rem);
  --tx-xl:clamp(1.5rem,1.2rem + 1.25vw,2.25rem);--tr:180ms cubic-bezier(.16,1,.3,1);
}
[data-theme="dark"]{
  --bg:#171614;--surface:#1e1d1b;--surface2:#242320;--surface-off:#1a1917;--surface-accent:#1d2828;
  --divider:#2a2926;--border:#363430;--text:#d4d2cf;--text-m:#7a7875;--text-f:#5a5855;--text-inv:#1c1a15;
  --primary:#4f98a3;--primary-h:#5fb0bc;--primary-l:#1e3234;--blue:#6fa5e5;--blue-l:#1c2f4a;
  --safe:#6daa45;--safe-bg:#1e2e16;--warn-l:#2e2a18;--warn-m:#3d3418;--warn-d:#e8b030;
  --crit-l:#2e1f14;--crit-m:#4a2810;--crit-d:#f08040;--exp-bg:#2a1414;--exp-t:#e87070;--exp-b:#5a2020;
  --shadow-sm:0 1px 2px oklch(0 0 0/.25);--shadow-md:0 4px 16px oklch(0 0 0/.35);
}
@media(prefers-color-scheme:dark){:root:not([data-theme]){
  --bg:#171614;--surface:#1e1d1b;--surface2:#242320;--surface-off:#1a1917;--surface-accent:#1d2828;
  --divider:#2a2926;--border:#363430;--text:#d4d2cf;--text-m:#7a7875;--text-f:#5a5855;--text-inv:#1c1a15;
  --primary:#4f98a3;--primary-h:#5fb0bc;--primary-l:#1e3234;--blue:#6fa5e5;--blue-l:#1c2f4a;
  --safe:#6daa45;--safe-bg:#1e2e16;--warn-l:#2e2a18;--warn-m:#3d3418;--warn-d:#e8b030;
  --crit-l:#2e1f14;--crit-m:#4a2810;--crit-d:#f08040;--exp-bg:#2a1414;--exp-t:#e87070;--exp-b:#5a2020;
  --shadow-sm:0 1px 2px oklch(0 0 0/.25);--shadow-md:0 4px 16px oklch(0 0 0/.35);
}}
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
html{-webkit-font-smoothing:antialiased;scroll-behavior:smooth}
body{font-family:var(--font);font-size:var(--tx-b);color:var(--text);background:var(--bg);min-height:100dvh;line-height:1.6}
button,input,select{font:inherit;color:inherit}
button{cursor:pointer;background:none;border:none}
table{border-collapse:collapse;width:100%}
a,button,input,select{transition:color var(--tr),background var(--tr),border-color var(--tr)}
:focus-visible{outline:2px solid var(--primary);outline-offset:3px;border-radius:var(--r-sm)}

/* Layout */
.app{display:grid;grid-template-columns:220px 1fr;grid-template-rows:auto 1fr;min-height:100dvh}
@media(max-width:900px){.app{grid-template-columns:1fr}}

/* Header */
header{grid-column:1/-1;background:var(--surface);border-bottom:1px solid var(--divider);
  padding:var(--sp4) var(--sp6);display:flex;align-items:center;justify-content:space-between;
  box-shadow:var(--shadow-sm);position:sticky;top:0;z-index:100}
.hbrand{display:flex;align-items:center;gap:var(--sp3)}
.hbrand svg{color:var(--primary);flex-shrink:0}
.btext{display:flex;flex-direction:column;line-height:1.2}
.bname{font-size:var(--tx-b);font-weight:700;letter-spacing:-.01em}
.bsub{font-size:var(--tx-xs);color:var(--text-m)}
.hright{display:flex;align-items:center;gap:var(--sp4)}
.dlabel{font-size:var(--tx-xs);color:var(--text-m);font-variant-numeric:tabular-nums}
.ttoggle{width:36px;height:36px;border-radius:var(--r-md);display:flex;align-items:center;
  justify-content:center;color:var(--text-m);border:1px solid var(--border)}
.ttoggle:hover{background:var(--surface2);color:var(--text)}

/* Sidebar */
aside{background:var(--surface);border-right:1px solid var(--divider);padding:var(--sp6) 0;
  display:flex;flex-direction:column;gap:var(--sp2)}
@media(max-width:900px){aside{display:none}}
.nlabel{font-size:var(--tx-xs);font-weight:600;text-transform:uppercase;letter-spacing:.08em;
  color:var(--text-f);padding:var(--sp2) var(--sp5);margin-top:var(--sp4)}
.nlabel:first-child{margin-top:0}
.nitem{display:flex;align-items:center;gap:var(--sp3);padding:var(--sp2) var(--sp5);
  font-size:var(--tx-sm);color:var(--text-m);cursor:pointer;border:none;background:none;
  width:100%;text-align:left}
.nitem svg{flex-shrink:0;opacity:.65}
.nitem:hover{background:var(--surface2);color:var(--text)}
.nitem.active{background:var(--primary-l);color:var(--primary);font-weight:600}
.nitem.active svg{opacity:1}

/* Main */
main{padding:var(--sp8);overflow-y:auto;display:flex;flex-direction:column;gap:var(--sp8)}
@media(max-width:768px){main{padding:var(--sp4)}}
.page{display:none;flex-direction:column;gap:var(--sp8)}
.page.active{display:flex}

/* Page header */
.pheader{display:flex;align-items:flex-start;justify-content:space-between;flex-wrap:wrap;gap:var(--sp4)}
.ptitle{font-size:var(--tx-lg);font-weight:700;letter-spacing:-.02em}
.psub{font-size:var(--tx-sm);color:var(--text-m);margin-top:var(--sp1)}

/* KPI */
.kgrid{display:grid;grid-template-columns:repeat(auto-fill,minmax(min(200px,100%),1fr));gap:var(--sp4)}
.kcard{background:var(--surface);border:1px solid var(--divider);border-radius:var(--r-lg);
  padding:var(--sp5);box-shadow:var(--shadow-sm);display:flex;flex-direction:column;gap:var(--sp2)}
.klabel{font-size:var(--tx-xs);font-weight:600;text-transform:uppercase;letter-spacing:.07em;color:var(--text-m)}
.kval{font-size:var(--tx-xl);font-weight:700;letter-spacing:-.03em;font-variant-numeric:tabular-nums;line-height:1}
.kmeta{font-size:var(--tx-xs);color:var(--text-m)}
.kdanger .kval{color:var(--exp-t)} .kwarn .kval{color:var(--warn-d)}
.kprimary .kval{color:var(--primary)} .kblue .kval{color:var(--blue)}

/* Legend */
.legend{display:flex;align-items:center;gap:var(--sp3);background:var(--surface);
  border:1px solid var(--divider);border-radius:var(--r-lg);padding:var(--sp4) var(--sp5);flex-wrap:wrap}
.ltitle{font-size:var(--tx-xs);font-weight:600;text-transform:uppercase;letter-spacing:.07em;
  color:var(--text-m);margin-right:var(--sp2)}
.litem{display:flex;align-items:center;gap:var(--sp2);font-size:var(--tx-xs);color:var(--text-m)}
.ldot{width:10px;height:10px;border-radius:var(--r-f);flex-shrink:0}
.gstrip{width:80px;height:10px;border-radius:var(--r-f);
  background:linear-gradient(to right,#fdeee6,#f8c9aa,#f0a060,#c84800)}
[data-theme="dark"] .gstrip{background:linear-gradient(to right,#2e1f14,#4a2810,#804020,#f08040)}

/* Section */
.section{background:var(--surface);border:1px solid var(--divider);border-radius:var(--r-xl);
  box-shadow:var(--shadow-sm);overflow:hidden}
.shead{padding:var(--sp5) var(--sp6);border-bottom:1px solid var(--divider);
  display:flex;align-items:center;justify-content:space-between;gap:var(--sp4);flex-wrap:wrap}
.stitle{font-size:var(--tx-b);font-weight:600}
.smeta{font-size:var(--tx-xs);color:var(--text-m)}

/* Tools / buttons */
.tools{display:flex;align-items:center;gap:var(--sp3);flex-wrap:wrap}
.field,.select,.btn{font-size:var(--tx-sm);padding:var(--sp2) var(--sp3);border:1px solid var(--border);
  border-radius:var(--r-md);background:var(--surface2);color:var(--text)}
.field{min-width:220px} .field::placeholder{color:var(--text-f)}
.btn{background:var(--surface);cursor:pointer}
.btn.primary{background:var(--primary);color:var(--text-inv);border-color:var(--primary)}
.btn.primary:hover{background:var(--primary-h)}
.btn.blue{background:var(--blue);color:#fff;border-color:var(--blue)}
.btn.blue:hover{filter:brightness(1.08)}

/* Table */
.table-wrap{overflow:auto}
.table{min-width:700px}
.table thead tr{background:var(--surface2)}
.table th{padding:var(--sp3) var(--sp5);font-size:var(--tx-xs);font-weight:600;text-transform:uppercase;
  letter-spacing:.07em;color:var(--text-m);text-align:left;border-bottom:1px solid var(--divider);white-space:nowrap}
.table th.sort{cursor:pointer} .table th.sort:hover{color:var(--text)}
.table td{padding:var(--sp4) var(--sp5);font-size:var(--tx-sm);border-bottom:1px solid var(--divider);
  vertical-align:middle;font-variant-numeric:tabular-nums}
.table tr:last-child td{border-bottom:none}
.table tbody tr:not(.rexp):hover{background:var(--surface2)}

/* Expiry styles */
.ecell{display:flex;align-items:center;gap:var(--sp2);flex-wrap:wrap}
.ebadge{display:inline-flex;align-items:center;font-size:var(--tx-xs);font-weight:600;
  padding:2px var(--sp2);border-radius:var(--r-f);white-space:nowrap}
.edot{width:8px;height:8px;border-radius:var(--r-f);flex-shrink:0}
.edays{font-size:var(--tx-xs);color:var(--text-m)}
.es{background:var(--safe-bg);color:var(--safe)}
.ew1{background:#f5f0df;color:#7a5800} .ew2{background:#ede0a0;color:#6a4800} .ew3{background:#e8c870;color:#5a3800}
.ec1{background:var(--crit-l);color:var(--crit-d)} .ec2{background:var(--crit-m);color:#a03000} .ec3{background:#f0a070;color:#802000}
.eexp{background:var(--exp-bg);color:var(--exp-t);border:1px solid var(--exp-b)}

/* Row tints */
.rexp{background:color-mix(in oklab,var(--exp-bg) 40%,transparent)!important}
.rc3{background:color-mix(in oklab,#f0a070 15%,transparent)!important}
.rc2{background:color-mix(in oklab,var(--crit-m) 18%,transparent)!important}
.rc1{background:color-mix(in oklab,var(--crit-l) 22%,transparent)!important}
.rw{background:color-mix(in oklab,#f5f0df 25%,transparent)!important}

/* Category badges */
.badge{display:inline-block;padding:2px var(--sp2);font-size:var(--tx-xs);font-weight:500;
  border-radius:var(--r-f);background:var(--surface-off);color:var(--text-m)}
.cm{background:var(--primary-l);color:var(--primary)}
.cf{background:var(--safe-bg);color:var(--safe)}
.cl{background:#e8e0f8;color:#5a35aa}
[data-theme="dark"] .cl{background:#2a2040;color:#9a7ee0}
.movement-in{color:var(--safe);font-weight:600}
.movement-out{color:var(--crit-d);font-weight:600}

/* Two-column grid */
.cards2{display:grid;grid-template-columns:1.3fr .9fr;gap:var(--sp4)}
@media(max-width:980px){.cards2{grid-template-columns:1fr}}
.mini-grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:var(--sp4)}
@media(max-width:540px){.mini-grid{grid-template-columns:1fr}}

/* Bar chart */
.bar-list{display:flex;flex-direction:column;gap:var(--sp4);padding:var(--sp6)}
.bar-row{display:grid;grid-template-columns:180px 1fr 60px;gap:var(--sp4);align-items:center}
@media(max-width:640px){.bar-row{grid-template-columns:1fr;gap:var(--sp2)}}
.bar-track{height:10px;border-radius:var(--r-f);background:var(--surface-off);overflow:hidden}
.bar-fill{height:100%;border-radius:var(--r-f);background:var(--primary)}
.bar-fill.warn{background:var(--warn-d)} .bar-fill.exp{background:var(--exp-t)}
.bar-val{font-family:var(--mono);font-size:var(--tx-xs);color:var(--text-m);text-align:right}

/* Footer line */
.footerline{padding:var(--sp4) var(--sp6);border-top:1px solid var(--divider);
  font-size:var(--tx-xs);color:var(--text-m);display:flex;justify-content:space-between;flex-wrap:wrap;gap:var(--sp3)}

/* Form */
.form-grid{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:var(--sp4);padding:var(--sp6)}
.form-grid .full{grid-column:1/-1}
@media(max-width:900px){.form-grid{grid-template-columns:1fr 1fr}}
@media(max-width:560px){.form-grid{grid-template-columns:1fr}}
.fblock{display:flex;flex-direction:column;gap:var(--sp2)}
.flabel{font-size:var(--tx-xs);font-weight:600;text-transform:uppercase;letter-spacing:.07em;color:var(--text-m)}
.finput,.fselect,.ftextarea{padding:var(--sp3);border:1px solid var(--border);
  border-radius:var(--r-md);background:var(--surface2);color:var(--text)}
.ftextarea{min-height:90px;resize:vertical}
.note{padding:var(--sp4) var(--sp6);background:var(--surface-accent);border-top:1px solid var(--divider);
  font-size:var(--tx-xs);color:var(--text-m)}

/* Print */
@media print{
  header,aside,.tools,.ttoggle,.btn,.note{display:none!important}
  .app{display:block} main{padding:0}
  .page{display:none!important} .page.active{display:flex!important}
  .section{box-shadow:none;border:1px solid #ccc}
}
</style>
</head>
<body>

<div class="app">

<header>
  <div class="hbrand">
    <svg aria-label="InvenTrack" width="32" height="32" viewBox="0 0 32 32" fill="none">
      <rect x="2" y="2" width="28" height="28" rx="7" fill="currentColor" opacity="0.13"/>
      <rect x="14" y="6" width="4" height="20" rx="2" fill="currentColor"/>
      <rect x="6" y="14" width="20" height="4" rx="2" fill="currentColor"/>
      <circle cx="16" cy="16" r="4" fill="currentColor" opacity="0.22"/>
    </svg>
    <div class="btext">
      <span class="bname">InvenTrack</span>
      <span class="bsub">Administrator Console</span>
    </div>
  </div>
  <div class="hright">
    <span class="badge">Role: Admin</span>
    <a href="LogoutServlet" class="btn" style="color: var(--danger); border-color: rgba(245, 98, 93, 0.3); text-decoration: none;">Logout</a>
    <button class="ttoggle" data-theme-toggle aria-label="Toggle dark mode">🌙</button>
  </div>
</header>

<aside>
  <span class="nlabel">System</span>
  <button class="nitem active" data-page="overviewPage">
    Overview
  </button>
  <button class="nitem" data-page="manageManagersPage">
    Manage Managers
  </button>
  <button class="nitem" data-page="reportsPage">
    System Reports
  </button>
  <span class="nlabel">Alerts</span>
  <button class="nitem" data-page="expiredPage">
    Expired Items
  </button>
  <button class="nitem" data-page="lowStockPage">
    Low Stock
  </button>
</aside>

<main>

<section id="overviewPage" class="page active">
  <div class="pheader">
    <div>
      <h1 class="ptitle">System Administration</h1>
      <p class="psub">Top-level metrics and system health</p>
    </div>
  </div>

  <div class="kgrid">
    <div class="kcard kprimary">
      <div class="klabel">Total Managers</div>
      <div class="kval"><%= managerCount != null ? managerCount : "0" %></div>
      <div class="kmeta">Active accounts</div>
    </div>
    <div class="kcard kdanger">
      <div class="klabel">Expired Items</div>
      <div class="kval"><%= expiredCount != null ? expiredCount : "0" %></div>
      <div class="kmeta">Requires immediate action</div>
    </div>
    <div class="kcard kwarn">
      <div class="klabel">Low Stock Items</div>
      <div class="kval"><%= lowStockCount != null ? lowStockCount : "0" %></div>
      <div class="kmeta">Restock recommended</div>
    </div>
    <div class="kcard kblue">
      <div class="klabel">Open Alerts</div>
      <div class="kval"><%= alertCount != null ? alertCount : "0" %></div>
      <div class="kmeta">System notifications</div>
    </div>
  </div>

  <div class="cards2" style="margin-top: var(--sp4);">
    <div class="section">
      <div class="shead">
        <div>
          <div class="stitle">Priority Threat Board</div>
          <div class="smeta">Items requiring immediate intervention</div>
        </div>
      </div>
      <div class="table-wrap">
        <table class="table">
          <tbody>
            <% if (expired.isEmpty() && lowStock.isEmpty()) { %>
              <tr><td style="text-align:center; color:var(--text-m); padding: 2rem;">System is secure. No priority threats.</td></tr>
            <% } else { 
                 // Show up to 3 expired items
                 int shown = 0;
                 for (Product p : expired) {
                   if (shown++ >= 3) break;
            %>
              <tr>
                <td style="font-weight:500"><%= p.getName() %></td>
                <td style="font-family:var(--mono)"><%= p.getQuantity() %> Units</td>
                <td style="text-align:right"><span class="ebadge eexp">EXPIRED</span></td>
              </tr>
            <%   }
                 // Show up to 3 low stock items
                 shown = 0;
                 for (Product p : lowStock) {
                   if (shown++ >= 3) break;
            %>
              <tr>
                <td style="font-weight:500"><%= p.getName() %></td>
                <td style="font-family:var(--mono)"><%= p.getQuantity() %> Units</td>
                <td style="text-align:right"><span class="ebadge ec1">LOW STOCK</span></td>
              </tr>
            <%   }
               } %>
          </tbody>
        </table>
      </div>
    </div>

    <div class="section">
      <div class="shead">
        <div>
          <div class="stitle">Command Links</div>
          <div class="smeta">Direct navigation</div>
        </div>
      </div>
      <div style="padding: var(--sp6); display: flex; flex-direction: column; gap: var(--sp3);">
        <button class="btn primary" onclick="document.querySelector('[data-page=\'manageManagersPage\']').click()" style="width:100%; justify-content:center;">+ Authorize New Manager</button>
        <button class="btn blue" onclick="document.querySelector('[data-page=\'expiredPage\']').click()" style="width:100%; justify-content:center;">Review Expired Assets</button>
        <button class="btn" onclick="document.querySelector('[data-page=\'lowStockPage\']').click()" style="width:100%; justify-content:center;">Review Low Stock Assets</button>
      </div>
    </div>
  </div>
</section>

<section id="manageManagersPage" class="page">
  <div class="pheader">
    <div>
      <h1 class="ptitle">Manage Managers</h1>
      <p class="psub">Create and review manager access</p>
    </div>
  </div>

  <div class="section">
    <div class="shead">
      <div><div class="stitle">Manager Directory</div></div>
    </div>
    <div class="table-wrap">
      <table class="table">
        <thead>
          <tr>
            <th>Full Name</th>
            <th>Username</th>
            <th>Role</th>
            <th>Status</th>
          </tr>
        </thead>
        <tbody>
          <% if (!managers.isEmpty()) { 
               for (Map<String, String> manager : managers) { 
                 boolean isActive = "true".equalsIgnoreCase(manager.get("is_active")); 
                 String badgeClass = isActive ? "es" : "eexp";
                 String statusText = isActive ? "Active" : "Inactive";
          %>
          <tr>
            <td style="font-weight:500"><%= manager.get("name") %></td>
            <td><%= manager.get("username") %></td>
            <td><%= manager.get("role") != null ? manager.get("role") : "MANAGER" %></td>
            <td><span class="ebadge <%= badgeClass %>"><%= statusText %></span></td>
          </tr>
          <%   } 
             } else { %>
          <tr><td colspan="4" style="text-align:center; color:var(--text-m)">No manager accounts found.</td></tr>
          <% } %>
        </tbody>
      </table>
    </div>
  </div>

  <div class="section">
    <div class="shead">
      <div><div class="stitle">Create New Manager</div></div>
    </div>
    <form action="ManageManagerServlet" method="post">
      <div class="form-grid">
        <div class="fblock">
          <label class="flabel">Full Name</label>
          <input class="finput" type="text" name="fullName" placeholder="E.g., Bruce Wayne" required>
        </div>
        <div class="fblock">
          <label class="flabel">Username</label>
          <input class="finput" type="text" name="username" placeholder="bwayne" required>
        </div>
        <div class="fblock">
          <label class="flabel">Temporary Password</label>
          <input class="finput" type="password" name="password" placeholder="Enter secure password" required>
        </div>
        <div class="fblock" style="display:flex; align-items:flex-end;">
          <button type="submit" class="btn primary" style="width:100%;">Create Account</button>
        </div>
      </div>
    </form>
  </div>
</section>

<section id="reportsPage" class="page">
  <div class="pheader">
    <div>
      <h1 class="ptitle">System Health & Reports</h1>
      <p class="psub">Security, compliance, and database diagnostics</p>
    </div>
  </div>

  <div class="cards2">
    <div class="section">
      <div class="shead">
        <div>
          <div class="stitle">Health Diagnostics</div>
          <div class="smeta">Real-time system compliance</div>
        </div>
      </div>
      <div class="table-wrap">
        <table class="table">
          <tbody>
            <tr>
              <td style="font-weight:500; width:60%">Database Uplink</td>
              <td style="text-align:right"><span class="ebadge es">Online</span></td>
            </tr>
            <tr>
              <td style="font-weight:500">Expired Items Threat</td>
              <td style="text-align:right">
                <% if (expiredCount != null && !expiredCount.toString().equals("0")) { %>
                  <span class="ebadge eexp"><%= expiredCount %> Detected</span>
                <% } else { %>
                  <span class="ebadge es">Clear</span>
                <% } %>
              </td>
            </tr>
            <tr>
              <td style="font-weight:500">Low Stock Warnings</td>
              <td style="text-align:right">
                <% if (lowStockCount != null && !lowStockCount.toString().equals("0")) { %>
                  <span class="ebadge ew1"><%= lowStockCount %> Warnings</span>
                <% } else { %>
                  <span class="ebadge es">Optimal</span>
                <% } %>
              </td>
            </tr>
            <tr>
              <td style="font-weight:500">Manager Access Control</td>
              <td style="text-align:right"><span class="ebadge cm"><%= managerCount != null ? managerCount : "0" %> Active</span></td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <div class="section">
      <div class="shead">
        <div>
          <div class="stitle">System Audit Log</div>
          <div class="smeta">Recent background operations</div>
        </div>
      </div>
      <div class="table-wrap">
        <table class="table">
          <thead>
            <tr>
              <th>Timestamp</th>
              <th>Process</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody>
            <% 
              List<StockMovement> auditLogs = (List<StockMovement>) request.getAttribute("auditLogs");
              if (auditLogs != null && !auditLogs.isEmpty()) {
                // Show only the 5 most recent logs for the Admin quick-view
                int count = 0;
                for (StockMovement log : auditLogs) {
                  if (count++ >= 5) break;
            %>
            <tr>
              <td style="font-family:var(--mono); font-size: 0.85rem;"><%= log.getMovementDate() %></td>
              <td>
                <span style="font-weight:600;"><%= log.getManagerUsername() != null ? log.getManagerUsername() : "SYSTEM" %></span> 
                logged a <%= log.getMovementType() %> of <%= log.getQuantity() %> units for <%= log.getProductName() %>.
              </td>
              <td style="color:var(--safe); font-weight:600">SUCCESS</td>
            </tr>
            <%  }
              } else { %>
            <tr><td colspan="3" style="text-align:center; color:var(--text-m)">No system activity detected.</td></tr>
            <% } %>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</section>
<section id="expiredPage" class="page">
  <div class="pheader">
    <div>
      <h1 class="ptitle">Expired Assets</h1>
      <p class="psub">Inventory past usable date requiring disposal or audit</p>
    </div>
  </div>
  <div class="section">
    <div class="table-wrap">
      <table class="table">
        <thead>
          <tr>
            <th>Asset ID</th>
            <th>Item Name</th>
            <th>Category</th>
            <th>Quantity Locked</th>
            <th>Date of Expiry</th>
            <th>System Status</th>
          </tr>
        </thead>
        <tbody>
          <% if (!expired.isEmpty()) { 
               for (Product item : expired) { %>
          <tr class="rexp">
            <td style="font-family:var(--mono)">#<%= item.getId() %></td>
            <td style="font-weight:500"><%= item.getName() %></td>
            <td><span class="badge cm"><%= item.getCategory() %></span></td>
            <td style="font-family:var(--mono); color:var(--exp-t); font-weight:bold;"><%= item.getQuantity() %></td>
            <td style="font-family:var(--mono); color:var(--exp-t)"><%= item.getExpiryDate() %></td>
            <td><span class="ebadge eexp">CONTAMINATED</span></td>
          </tr>
          <%   } 
             } else { %>
          <tr><td colspan="6" style="text-align:center; padding: 3rem; color:var(--text-m)">Database scan complete. No expired assets detected.</td></tr>
          <% } %>
        </tbody>
      </table>
    </div>
  </div>
</section>
<section id="lowStockPage" class="page">
  <div class="pheader">
    <div>
      <h1 class="ptitle">Low Stock Alerts</h1>
      <p class="psub">Assets requiring immediate procurement protocols</p>
    </div>
  </div>
  <div class="section">
    <div class="table-wrap">
      <table class="table">
        <thead>
          <tr>
            <th>Asset ID</th>
            <th>Item Name</th>
            <th>Category</th>
            <th>Remaining Qty</th>
            <th>Threat Level</th>
          </tr>
        </thead>
        <tbody>
          <% if (!lowStock.isEmpty()) { 
               for (Product item : lowStock) { 
                 // Tactical Assessment: Under 5 is critical, under 10 is warning
                 boolean isCritical = item.getQuantity() <= 5;
                 String badgeClass = isCritical ? "ec1" : "ew1";
                 String statText = isCritical ? "CRITICAL DEPLETION" : "WARNING THRESHOLD";
          %>
          <tr>
            <td style="font-family:var(--mono)">#<%= item.getId() %></td>
            <td style="font-weight:500"><%= item.getName() %></td>
            <td><span class="badge cm"><%= item.getCategory() %></span></td>
            <td style="font-family:var(--mono); font-size: 1.1rem; font-weight:bold;"><%= item.getQuantity() %></td>
            <td><span class="ebadge <%= badgeClass %>"><%= statText %></span></td>
          </tr>
          <%   } 
             } else { %>
          <tr><td colspan="5" style="text-align:center; padding: 3rem; color:var(--text-m)">Supply lines are optimal. No low stock detected.</td></tr>
          <% } %>
        </tbody>
      </table>
    </div>
  </div>
</section>

</main>
</div>

<script>
/* Page Navigation Router */
var navItems = document.querySelectorAll('.nitem[data-page]');
var pages = document.querySelectorAll('.page');
navItems.forEach(function(btn){
  btn.addEventListener('click',function(){
    navItems.forEach(function(b){b.classList.remove('active');});
    pages.forEach(function(p){p.classList.remove('active');});
    btn.classList.add('active');
    document.getElementById(btn.dataset.page).classList.add('active');
    window.scrollTo(0,0);
  });
});

/* Dark Mode Toggle */
(function(){
  var toggle = document.querySelector('[data-theme-toggle]');
  var root = document.documentElement;
  var mode = matchMedia('(prefers-color-scheme:dark)').matches ? 'dark' : 'light';
  root.setAttribute('data-theme', mode);
  toggle.addEventListener('click',function(){
    mode = mode === 'dark' ? 'light' : 'dark';
    root.setAttribute('data-theme', mode);
  });
})();
</script>
</body>
</html>