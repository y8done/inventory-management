<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, java.time.*, java.time.format.*, java.time.temporal.*" %>
<%@ page import="com.inventory.model.User" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page import="com.inventory.model.Product" %>
<%@ page import="com.inventory.model.StockMovement" %>
<%
	User currentUser = (User)session.getAttribute("activeUser");
	if(currentUser == null || !currentUser.getRole().equals("MANAGER"))
	{
		response.sendRedirect("Login.jsp");
		return;
	}
%>





<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>Inventory Manager Dashboard</title>
<link rel="preconnect" href="https://fonts.googleapis.com"/>
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300..700&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet"/>
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


<%
    List<Product> products = (List<Product>) request.getAttribute("inventoryList");
    if(products == null) products = new ArrayList<>();

    // 1. DEFINE TOTAL
    int total = products.size(); 
    int expiredCnt=0, critCnt=0, warnCnt=0, safeCnt=0, lowStockCnt=0;
    double totalVal = 0;
    Map<String,Integer> catCount = new LinkedHashMap<>();

    for (Product p : products) {
        // Null-Safety Shield: If there is no stock, there is no expiry date.
        if (p.getExpiryDate() != null) {
            LocalDate exp = p.getExpiryDate().toLocalDate();
            long d = java.time.temporal.ChronoUnit.DAYS.between(LocalDate.now(), exp);
            
            String s = "safe";
            if (d < 0) s = "expired";
            else if (d <= 7) s = "critical";
            else if (d <= 30) s = "warning";

            if (s.equals("expired")) expiredCnt++;
            else if (s.equals("critical")) critCnt++;
            else if (s.equals("warning")) warnCnt++;
            else safeCnt++;
        }

        // Metrics that apply even if out of stock
        if (p.getQuantity() <= 15) lowStockCnt++;
        totalVal += p.getPrice() * p.getQuantity();
        catCount.put(p.getCategory(), catCount.getOrDefault(p.getCategory(), 0) + 1);
    }
    
 // 2. PROCESS MOVEMENT INTEL
    List<StockMovement> movements = (List<StockMovement>) request.getAttribute("movementList");
    if(movements == null) movements = new ArrayList<>();

    int stockInCount = 0, stockOutCount = 0, stockInQty = 0, stockOutQty = 0;

    for (StockMovement sm : movements) {
        if ("IN".equalsIgnoreCase(sm.getMovementType())) {
            stockInCount++;
            stockInQty += sm.getQuantity();
        } else if ("OUT".equalsIgnoreCase(sm.getMovementType())) {
            stockOutCount++;
            stockOutQty += sm.getQuantity();
        }
    }
    
    // Formatting tools
    DateTimeFormatter displayFmt = DateTimeFormatter.ofPattern("dd MMM yyyy");
    LocalDate today = LocalDate.now();
    
    
%>

<div class="app">

<!-- ═══ HEADER ═══ -->
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
      <span class="bsub">Manager Dashboard</span>
    </div>
  </div>
  <div class="hright">
    <span class="dlabel"><%= today.format(DateTimeFormatter.ofPattern("EEE, dd MMM yyyy")) %></span>
    <a href="LogoutServlet" class="btn" style="color: var(--exp-t); border-color: var(--exp-b); text-decoration: none; padding: 4px 12px;">Logout</a>
    <button class="ttoggle" data-theme-toggle aria-label="Toggle dark mode"></button>
  </div>
</header>

<!-- ═══ SIDEBAR ═══ -->
<aside>
  <span class="nlabel">Menu</span>
  <button class="nitem active" data-page="dashboardPage">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
      <rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/>
      <rect x="3" y="14" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/>
    </svg>Dashboard
  </button>
  <button class="nitem" data-page="productsPage">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
      <path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/>
    </svg>Products
  </button>
  <button class="nitem" data-page="movementPage">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
      <path d="M20 7H4a2 2 0 0 0-2 2v6a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2z"/>
      <polyline points="16 21 12 17 8 21"/><polyline points="16 3 12 7 8 3"/>
    </svg>Stock In / Out
  </button>
  <span class="nlabel">Reports</span>
  <button class="nitem" data-page="expiryPage">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
      <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/>
    </svg>Expiry Report
  </button>
  <button class="nitem" data-page="exportPage">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
      <rect x="9" y="9" width="13" height="13" rx="2"/>
      <path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/>
    </svg>Export Data
  </button>
</aside>

<!-- ═══ MAIN ═══ -->
<main>

<!-- ─── PAGE 1: DASHBOARD ─── -->
<section id="dashboardPage" class="page active">
  <div class="pheader">
    <div>
      <h1 class="ptitle">Inventory Overview</h1>
      <p class="psub">Manager snapshot &mdash; static dataset, ready for backend integration</p>
    </div>
  </div>

  <div class="kgrid">
    <div class="kcard">
      <div class="klabel">Total Products</div>
      <div class="kval"><%= total %></div>
      <div class="kmeta">Across all categories</div>
    </div>
    <div class="kcard<%= expiredCnt > 0 ? " kdanger" : "" %>">
      <div class="klabel">Expired</div>
      <div class="kval"><%= expiredCnt %></div>
      <div class="kmeta">Immediate disposal / audit</div>
    </div>
    <div class="kcard<%= critCnt > 0 ? " kwarn" : "" %>">
      <div class="klabel">Critical (&le; 7 days)</div>
      <div class="kval"><%= critCnt %></div>
      <div class="kmeta">Urgent action required</div>
    </div>
    <div class="kcard<%= warnCnt > 0 ? " kwarn" : "" %>">
      <div class="klabel">Warning (8&ndash;30 days)</div>
      <div class="kval"><%= warnCnt %></div>
      <div class="kmeta">Watch closely</div>
    </div>
    <div class="kcard<%= lowStockCnt > 0 ? " kblue" : "" %>">
      <div class="klabel">Low Stock (&le; 15 units)</div>
      <div class="kval"><%= lowStockCnt %></div>
      <div class="kmeta">Replenishment candidates</div>
    </div>
    <div class="kcard kprimary">
      <div class="klabel">Total Stock Value</div>
      <div class="kval">&#8377;<%= String.format("%,.0f", totalVal) %></div>
      <div class="kmeta">Current inventory value</div>
    </div>
  </div>

  <div class="cards2">
    <div class="section">
      <div class="shead">
        <div>
          <div class="stitle">Category Breakdown</div>
          <div class="smeta">Items per category</div>
        </div>
      </div>
      <div class="bar-list">
        <%
          int maxCat = 1;
          for (Integer v : catCount.values()) if (v > maxCat) maxCat = v;
          for (Map.Entry<String,Integer> e : catCount.entrySet()) {
              int pct = (int) Math.round((e.getValue() * 100.0) / maxCat);
              String bc = e.getKey().startsWith("Food") ? "warn" : (e.getKey().startsWith("Lab") ? "exp" : "");
        %>
        <div class="bar-row">
          <div><%= e.getKey() %></div>
          <div class="bar-track"><div class="bar-fill <%= bc %>" style="width:<%= pct %>%"></div></div>
          <div class="bar-val"><%= e.getValue() %> items</div>
        </div>
        <% } %>
      </div>z
      <div class="legend" style="border:none;box-shadow:none;background:transparent;padding-top:0">
        <span class="ltitle">Expiry Scale</span>
        <div class="litem"><span class="ldot" style="background:var(--safe)"></span>Safe (&gt;30d)</div>
        <div class="litem"><span class="gstrip"></span></div>
        <div class="litem"><span class="ldot" style="background:var(--crit-d)"></span>Critical</div>
        <div class="litem"><span class="ldot" style="background:var(--exp-t)"></span>Expired</div>
      </div>
    </div>

    <div class="section">
      <div class="shead"><div><div class="stitle">Movement Snapshot</div><div class="smeta">Static movement data</div></div></div>
      <div class="mini-grid" style="padding:var(--sp6)">
        <div class="kcard">
          <div class="klabel">Stock In</div>
          <div class="kval" style="color:var(--safe)"><%= stockInCount %></div>
          <div class="kmeta">Qty: <%= stockInQty %></div>
        </div>
        <div class="kcard">
          <div class="klabel">Stock Out</div>
          <div class="kval" style="color:var(--crit-d)"><%= stockOutCount %></div>
          <div class="kmeta">Qty: <%= stockOutQty %></div>
        </div>
        <div class="kcard">
          <div class="klabel">Safe Items</div>
          <div class="kval" style="color:var(--safe)"><%= safeCnt %></div>
          <div class="kmeta">&gt;30 days left</div>
        </div>
        <div class="kcard">
          <div class="klabel">At Risk</div>
          <div class="kval" style="color:var(--warn-d)"><%= expiredCnt + critCnt + warnCnt %></div>
          <div class="kmeta">Expired + critical + warning</div>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- ─── PAGE 2: PRODUCTS ─── -->
<section id="productsPage" class="page">
  <div class="pheader">
    <div>
      <h1 class="ptitle">Products</h1>
      <p class="psub">Full inventory with expiry-aware highlighting, search, filter and sort</p>
    </div>
  </div>
  <div class="section" style="margin-bottom: var(--sp8);">
    <div class="shead">
      <div><div class="stitle">Acquire New Asset</div><div class="smeta">Register new inventory into the database</div></div>
    </div>
    <form action="AddProductServlet" method="POST">
      <div class="form-grid">
        <div class="fblock">
          <label class="flabel">Asset Name</label>
          <input class="finput" type="text" name="name" placeholder="E.g., Paracetamol 500mg" required/>
        </div>
        <div class="fblock">
          <label class="flabel">Category</label>
          <input class="finput" type="text" name="category" placeholder="E.g., Medicine" required/>
        </div>
        <div class="fblock">
          <label class="flabel">Initial Qty</label>
          <input class="finput" type="number" name="quantity" min="0" value="0" required/>
        </div>
        <div class="fblock">
          <label class="flabel">Unit Price (₹)</label>
          <input class="finput" type="number" step="0.01" name="price" placeholder="0.00" required/>
        </div>
        <div class="fblock">
  				<label class="flabel">New Batch Expiry (If IN)</label>
  			<input class="finput" type="date" name="expiryDate" />
			</div>
        <div class="fblock" style="display:flex; align-items:flex-end;">
          <button type="submit" class="btn primary" style="width:100%;">Add to Inventory</button>
        </div>
      </div>
    </form>
  </div>

  <div class="section" style="margin-bottom: var(--sp8);">
    <div class="shead">
      <div><div class="stitle">Modify Existing Asset</div><div class="smeta">Update details (Qty is locked; use Movement Log to change stock)</div></div>
    </div>
    <form action="UpdateProductServlet" method="POST">
      <div class="form-grid">
        <div class="fblock">
          <label class="flabel">Target Asset</label>
          <select class="fselect" name="id" required>
            <option value="">Select asset...</option>
            <c:forEach var="item" items="${inventoryList}">
              <option value="${item.id}">[ID: ${item.id}] ${item.name}</option>
            </c:forEach>
          </select>
        </div>
        <div class="fblock">
          <label class="flabel">New Name</label>
          <input class="finput" type="text" name="name" placeholder="Updated name" required/>
        </div>
        <div class="fblock">
          <label class="flabel">New Category</label>
          <input class="finput" type="text" name="category" placeholder="Updated category" required/>
        </div>
        <div class="fblock">
          <label class="flabel">New Price (₹)</label>
          <input class="finput" type="number" step="0.01" name="price" placeholder="0.00" required/>
        </div>
        <div class="fblock">
          <label class="flabel">New Expiry</label>
          <input class="finput" type="date" name="expiryDate" required/>
        </div>
        <div class="fblock" style="display:flex; align-items:flex-end;">
          <button type="submit" class="btn blue" style="width:100%;">Execute Update</button>
        </div>
      </div>
    </form>
  </div>
  <div class="section">
    <div class="shead">
      <div><div class="stitle">Inventory Table</div><div class="smeta">Static dataset &mdash; <%= total %> products</div></div>
      <div class="tools">
        <input type="text" class="field" id="productSearch" placeholder="Search products..." oninput="filterProducts()"/>
        <select class="select" id="productCategory" onchange="filterProducts()">
          <option value="">All Categories</option>
          <% for (String cat : catCount.keySet()) { %>
          <option value="<%= cat %>"><%= cat %></option>
          <% } %>
        </select>
        <select class="select" id="productExpiry" onchange="filterProducts()">
          <option value="">All Status</option>
          <option value="expired">Expired</option>
          <option value="critical">Critical</option>
          <option value="warning">Warning</option>
          <option value="safe">Safe</option>
        </select>
      </div>
    </div>
    <div class="table-wrap">
      <table class="table" id="productsTable">
        <thead>
          <tr>
            <th>#</th>
            <th class="sort" onclick="sortTable('productsTable',1)">Product Name &#x2195;</th>
            <th class="sort" onclick="sortTable('productsTable',2)">Category &#x2195;</th>
            <th class="sort" onclick="sortTable('productsTable',3)">Qty &#x2195;</th>
            <th class="sort" onclick="sortTable('productsTable',4)">Price (&#8377;) &#x2195;</th>
            <th class="sort" onclick="sortTable('productsTable',5)">Expiry Date &#x2195;</th>
            <th>Status</th>
          </tr>
        </thead>
        <tbody>
            <c:forEach var="item" items="${inventoryList}">
                <tr>
                    <td>${item.id}</td>
                    <td>${item.name}</td>
                    <td>${item.category}</td>
                    <td>${item.quantity}</td>
                    <td>&#8377; ${item.price}</td> <td>${item.expiryDate}</td>
                    <td></td>
                </tr>
            </c:forEach>
        </tbody>
      </table>
    </div>
    <div class="footerline">
      <span id="productsCount">Showing all <%= total %> products</span>
      <span>Static dataset &middot; Buffer: 15 days</span>
    </div>
  </div>
</section>

<!-- ─── PAGE 3: STOCK IN / OUT ─── -->
<section id="movementPage" class="page">
  <div class="pheader">
    <div>
      <h1 class="ptitle">Stock In / Out</h1>
      <p class="psub">Movement log &mdash; static records with entry form for backend integration</p>
    </div>
  </div>

  <div class="cards2">
    <div class="section">
      <div class="shead">
        <div><div class="stitle">Record Movement</div><div class="smeta">Wire to StockMovementServlet</div></div>
      </div>
      
      <form action="StockMovementServlet" method="POST">
          <div class="form-grid">
            <div class="fblock">
              <label class="flabel">Item</label>
              <select class="fselect" name="productId" required>
                <option value="">Select product...</option>
                <c:forEach var="item" items="${inventoryList}">
                    <option value="${item.id}">${item.name}</option>
                </c:forEach>
              </select>
            </div>
            
            <div class="fblock">
              <label class="flabel">Movement Type</label>
              <select class="fselect" name="movementType" required>
                  <option value="IN">IN (Add Stock)</option>
                  <option value="OUT">OUT (Reduce Stock)</option>
              </select>
            </div>
            
            <div class="fblock">
              <label class="flabel">Quantity</label>
              <input class="finput" type="number" name="quantity" min="1" placeholder="Enter quantity" required/>
            </div>
            
            <div class="fblock">
              <label class="flabel">Date</label>
              <input class="finput" type="date" name="movementDate" required/>
            </div>
            
            <div class="fblock full">
              <label class="flabel">Remarks</label>
              <textarea class="ftextarea" name="remarks" placeholder="Supplier, usage note, issue reason, etc." required></textarea>
            </div>
          </div>
          
          <div style="margin-top: 15px;">
              <button type="submit" class="btn primary">Save Movement</button>
          </div>
      </form>
    </div>

    <div class="section">
      <div class="shead"><div><div class="stitle">Movement Summary</div><div class="smeta">Computed from static records</div></div></div>
      <div class="mini-grid" style="padding:var(--sp6)">
        <div class="kcard">
          <div class="klabel">Entries In</div>
          <div class="kval" style="color:var(--safe)"><%= stockInCount %></div>
          <div class="kmeta">Qty received: <%= stockInQty %></div>
        </div>
        <div class="kcard">
          <div class="klabel">Entries Out</div>
          <div class="kval" style="color:var(--crit-d)"><%= stockOutCount %></div>
          <div class="kmeta">Qty issued: <%= stockOutQty %></div>
        </div>
        <div class="kcard">
          <div class="klabel">Net Movement</div>
          <div class="kval" style="color:<%= (stockInQty - stockOutQty) >= 0 ? "var(--primary)" : "var(--crit-d)" %>"><%= stockInQty - stockOutQty %></div>
          <div class="kmeta">In minus Out</div>
        </div>
        <div class="kcard">
          <div class="klabel">Total Logs</div>
          <div class="kval"><%= movements.size() %></div>
          <div class="kmeta">Movement records</div>
        </div>
      </div>
    </div>
  </div>

  <div class="section">
    <div class="shead">
      <div><div class="stitle">Movement Log</div><div class="smeta">Sortable &mdash; static dataset</div></div>
    </div>
    <div class="table-wrap">
      <table class="table" id="movementTable">
        <thead>
          <tr>
            <th class="sort" onclick="sortTable('movementTable',0)">Date &#x2195;</th>
            <th class="sort" onclick="sortTable('movementTable',1)">Item &#x2195;</th>
            <th>Type</th>
            <th class="sort" onclick="sortTable('movementTable',3)">Qty &#x2195;</th>
            <th>Remarks</th>
          </tr>
        </thead>
<tbody>
  <c:forEach var="log" items="${movementList}">
    <tr>
      <td style="font-family:var(--mono)">${log.movementDate}</td>
      <td style="font-weight:500">${log.productName}</td>
      <td>
        <c:choose>
          <c:when test="${log.movementType == 'IN'}">
            <span class="movement-in">IN</span>
          </c:when>
          <c:otherwise>
            <span class="movement-out">OUT</span>
          </c:otherwise>
        </c:choose>
      </td>
      <td style="font-family:var(--mono)">
        <c:choose>
          <c:when test="${log.movementType == 'IN'}">+${log.quantity}</c:when>
          <c:otherwise>-${log.quantity}</c:otherwise>
        </c:choose>
      </td>
      <td style="color:var(--text-m)">${log.remarks}</td>
    </tr>
  </c:forEach>
</tbody>
      </table>
    </div>
    <div class="footerline">
      <span><%= movements.size() %> movement records</span>
      <span>Static dataset &mdash; extend via servlet</span>
    </div>
  </div>
</section>

<!-- ─── PAGE 4: EXPIRY REPORT ─── -->
<section id="expiryPage" class="page">
  <div class="pheader">
    <div>
      <h1 class="ptitle">Expiry Report</h1>
      <p class="psub">Products sorted by urgency &mdash; audit, follow-up and print view</p>
    </div>
    <div class="tools">
      <button class="btn" onclick="window.print()">&#128438; Print Report</button>
    </div>
  </div>
  <div class="section">
    <div class="shead">
      <div><div class="stitle">Expiry Priority List</div><div class="smeta">Expired first, then critical, warning, then safe</div></div>
    </div>
    <div class="table-wrap">
      <table class="table" id="expiryTable">
        <thead>
          <tr>
            <th>Priority</th>
            <th>Item</th>
            <th>Category</th>
            <th>Qty</th>
            <th>Expiry Date</th>
            <th>Days Remaining</th>
            <th>Status</th>
            <th>Suggested Action</th>
          </tr>
        </thead>
        <tbody>
<%
    // Filter out products that have no stock/no expiry date before sorting
    List<Product> sortedExpiry = new ArrayList<>();
    for (Product p : products) {
        if (p.getExpiryDate() != null) {
            sortedExpiry.add(p);
        }
    }
    
    // Sort safely
    Collections.sort(sortedExpiry, (a, b) -> a.getExpiryDate().compareTo(b.getExpiryDate()));

    int pr = 1;
    for (Product p : sortedExpiry) {
        LocalDate expDate = p.getExpiryDate().toLocalDate();
        long days = java.time.temporal.ChronoUnit.DAYS.between(LocalDate.now(), expDate);
        
        String status = "Safe";
        String badgeClass = "es";
        String action = "Normal monitoring";

        if (days < 0) { status = "Expired"; badgeClass = "eexp"; action = "Remove stock immediately"; }
        else if (days <= 7) { status = "Critical"; badgeClass = "ec1"; action = "Use first / Issue priority"; }
        else if (days <= 30) { status = "Warning"; badgeClass = "ew1"; action = "Watch weekly"; }
%>
          <tr>
            <td style="font-family:var(--mono)"><%= pr++ %></td>
            <td style="font-weight:500"><%= p.getName() %></td>
            <td><%= p.getCategory() %></td>
            <td style="font-family:var(--mono)"><%= p.getQuantity() %></td>
            <td style="font-family:var(--mono)"><%= expDate.format(displayFmt) %></td>
            <td style="font-family:var(--mono)"><%= days < 0 ? (Math.abs(days) + " ago") : (days + " days") %></td>
            <td><span class="ebadge <%= badgeClass %>"><%= status %></span></td>
            <td style="color:var(--text-m)"><%= action %></td>
          </tr>
<% } %>
</tbody>
      </table>
    </div>
    <div class="footerline">
      <span>Report generated: <%= today.format(displayFmt) %></span>
      <span>Static dataset &middot; Buffer: 15 days</span>
    </div>
  </div>
</section>

<!-- ─── PAGE 5: EXPORT DATA ─── -->
<section id="exportPage" class="page">
  <div class="pheader">
    <div>
      <h1 class="ptitle">Export Data</h1>
      <p class="psub">Download inventory, movement and expiry tables as CSV</p>
    </div>
  </div>
  <div class="cards2">
    <div class="section">
      <div class="shead"><div><div class="stitle">Export Center</div><div class="smeta">Client-side CSV download</div></div></div>
      <div class="form-grid">
        <div class="fblock">
          <label class="flabel">Inventory Master</label>
          <button class="btn primary" onclick="exportTableToCSV('productsTable','inventory-products.csv')">
            &#11015; Export Products CSV
          </button>
        </div>
        <div class="fblock">
          <label class="flabel">Stock Movements</label>
          <button class="btn blue" onclick="exportTableToCSV('movementTable','stock-movements.csv')">
            &#11015; Export Movements CSV
          </button>
        </div>
        <div class="fblock">
          <label class="flabel">Expiry Report</label>
          <button class="btn" onclick="exportTableToCSV('expiryTable','expiry-report.csv')">
            &#11015; Export Expiry CSV
          </button>
        </div>
        <div class="fblock">
          <label class="flabel">Print Summary</label>
          <button class="btn" onclick="window.print()">&#128438; Print Current Page</button>
        </div>
        <div class="fblock full">
          <div class="note" style="border:1px solid var(--divider);border-radius:var(--r-md)">
            CSV export runs entirely in-browser &mdash; no server round-trip needed.
            Exported rows reflect current visible table data (filters respected).
            To export server-side from a DB, wire a servlet endpoint.
          </div>
        </div>
      </div>
    </div>
    <div class="section">
      <div class="shead"><div><div class="stitle">Export File Details</div><div class="smeta">Fields in each CSV</div></div></div>
      <div class="table-wrap">
        <table class="table">
          <thead><tr><th>Filename</th><th>Includes</th></tr></thead>
          <tbody>
            <tr><td style="font-family:var(--mono)">inventory-products.csv</td><td>ID, Name, Category, Qty, Price, Expiry Date, Status</td></tr>
            <tr><td style="font-family:var(--mono)">stock-movements.csv</td><td>Date, Item, IN/OUT, Qty, Remarks</td></tr>
            <tr><td style="font-family:var(--mono)">expiry-report.csv</td><td>Priority, Item, Category, Qty, Expiry, Days, Status, Action</td></tr>
          </tbody>
        </table>
      </div>
      <div class="footerline"><span>No server round-trip for CSV export</span><span>Use Print for PDF output</span></div>
    </div>
  </div>
</section>

</main>
</div>

<!-- ═══ SCRIPTS ═══ -->
<script>
/* ── Dark / light toggle ── */
(function(){
  var toggle=document.querySelector('[data-theme-toggle]');
  var root=document.documentElement;
  var mode=matchMedia('(prefers-color-scheme:dark)').matches?'dark':'light';
  root.setAttribute('data-theme',mode);
  function setIcon(){
    toggle.innerHTML=mode==='dark'
      ?'<svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="5"/><path d="M12 1v2M12 21v2M4.22 4.22l1.42 1.42M18.36 18.36l1.42 1.42M1 12h2M21 12h2M4.22 19.78l1.42-1.42M18.36 5.64l1.42-1.42"/></svg>'
      :'<svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"/></svg>';
  }
  setIcon();
  toggle.addEventListener('click',function(){
    mode=mode==='dark'?'light':'dark';
    root.setAttribute('data-theme',mode);
    setIcon();
  });
})();

/* ── Page navigation ── */
var navItems=document.querySelectorAll('.nitem[data-page]');
var pages=document.querySelectorAll('.page');
navItems.forEach(function(btn){
  btn.addEventListener('click',function(){
    navItems.forEach(function(b){b.classList.remove('active');});
    pages.forEach(function(p){p.classList.remove('active');});
    btn.classList.add('active');
    document.getElementById(btn.dataset.page).classList.add('active');
    window.scrollTo(0,0);
  });
});

/* ── Products filter ── */
function filterProducts(){
  var s=document.getElementById('productSearch').value.toLowerCase();
  var c=document.getElementById('productCategory').value;
  var e=document.getElementById('productExpiry').value;
  var rows=document.querySelectorAll('#productsTable tbody tr');
  var visible=0;
  rows.forEach(function(r){
    var ms=!s||r.dataset.name.includes(s);
    var mc=!c||r.dataset.category===c;
    var me=!e||r.dataset.status===e;
    r.style.display=(ms&&mc&&me)?'':'none';
    if(ms&&mc&&me) visible++;
  });
  document.getElementById('productsCount').textContent='Showing '+visible+' of <%= total %> products';
}

/* ── Generic table sort ── */
var sortState={};
function sortTable(tableId,col){
  var tbody=document.querySelector('#'+tableId+' tbody');
  var rows=Array.from(tbody.querySelectorAll('tr'));
  var key=tableId+'-'+col;
  var asc=!sortState[key];
  Object.keys(sortState).forEach(function(k){delete sortState[k];});
  sortState[key]=asc;
  rows.sort(function(a,b){
    var at=a.cells[col].textContent.trim();
    var bt=b.cells[col].textContent.trim();
    var an=parseFloat(at.replace(/[^0-9.-]/g,''));
    var bn=parseFloat(bt.replace(/[^0-9.-]/g,''));
    if(!isNaN(an)&&!isNaN(bn)) return asc?an-bn:bn-an;
    var ad=Date.parse(at), bd=Date.parse(bt);
    if(!isNaN(ad)&&!isNaN(bd)) return asc?ad-bd:bd-ad;
    return asc?at.localeCompare(bt):bt.localeCompare(at);
  });
  rows.forEach(function(r){tbody.appendChild(r);});
}

/* ── CSV export ── */
function exportTableToCSV(tableId,filename){
  var rows=document.querySelectorAll('#'+tableId+' tr');
  var csv=[];
  rows.forEach(function(row){
    if(row.style&&row.style.display==='none') return;
    var cols=row.querySelectorAll('th,td');
    var line=[];
    cols.forEach(function(col){
      var text=(col.innerText||col.textContent||'').replace(/\n/g,' ').replace(/\s+/g,' ').trim();
      line.push('"'+text.replace(/"/g,'""')+'"');
    });
    csv.push(line.join(','));
  });
  var blob=new Blob([csv.join('\n')],{type:'text/csv;charset=utf-8;'});
  var link=document.createElement('a');
  link.href=URL.createObjectURL(blob);
  link.download=filename;
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
}

/* ── Toast ── */
function showToast(msg){ alert(msg); }
</script>
</body>
</html>