





<!DOCTYPE HTML>
<html lang="en">
<head>

<!-- Google tag (gtag.js) -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-GG9C02THQ7"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag("js", new Date());

  gtag("config", "G-GG9C02THQ7");
</script>

<script src="https://www.google.com/recaptcha/api.js" async defer></script><meta charset="UTF-8">
<meta name="robots" content="noindex, nofollow">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>mycsg SASnR2 2610_Arrays---Example---replace-a-text-value-in-all-character-variables</title>

    <link rel="stylesheet" href="/styles/mycsg.css">
    <script src="/scripts/mycsg.js"></script>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

    <script src="https://code.jquery.com/jquery-3.5.1.js"></script>
    <script src="https://cdn.datatables.net/1.11.1/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/fixedcolumns/3.3.3/js/dataTables.fixedColumns.min.js"></script>

    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.25/css/jquery.dataTables.min.css">
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/2.0.8/css/dataTables.dataTables.css">

    <link rel="stylesheet" type="text/css" href="/styles/prism.css">
    <script src="/scripts/prism.js" data-manual></script>
    <script src="/vendor/tinymce/tinymce_6.1.2/tinymce.min.js" referrerpolicy="origin"></script>
  <script>
   if (window.tinymce) {
     const presentationTemplates = [{"title":"LD","description":"Adds a four-row lesson description scaffold for presentation mode.","content":"<table style=\"width: 96%; margin: 0 auto; border-collapse: collapse;\"><tr><td style=\"background: #dff3e6; border: 1px solid #000000; text-align: center; font-size: 24px; font-weight: 700; padding: 14px 18px;\">Background</td></tr><tr><td style=\"border: 1px solid #000000; padding: 14px 18px;\"><ul><li>Add the background point here</li></ul></td></tr><tr><td style=\"background: #FBEEB8; border: 1px solid #000000; text-align: center; font-size: 24px; font-weight: 700; padding: 14px 18px;\">What is covered in this lesson</td></tr><tr><td style=\"border: 1px solid #000000; padding: 14px 18px;\"><ul><li>Add the lesson coverage point here</li></ul></td></tr></table><p></p>"}];

     tinymce.init({
       selector: '.myeditablelessondiv',
       plugins: 'table autoresize autosave codesample preview wordcount code emoticons link image lists advlist media insertdatetime template visualblocks help',
       toolbar: 'template | undo redo | styles | hr | forecolor backcolor | bold italic | numlist bullist | alignleft aligncenter alignright alignjustify | outdent indent | link image media| code | visualblocks',
       templates: presentationTemplates
     });
   }
 </script>
    <style>
    .csg-site-navbar {
      padding-top: 0.15rem !important;
      padding-bottom: 0.15rem !important;
    }
    .csg-site-navbar .navbar-brand {
      font-weight: 700;
      margin-right: 1rem;
      white-space: nowrap;
    }
    .csg-site-navbar .nav-link {
      padding: 0.45rem 0.55rem !important;
      font-size: 0.92rem;
      white-space: nowrap;
    }
    .csg-site-navbar .dropdown-toggle,
    .csg-site-navbar .dropdown-item,
    .csg-site-navbar .badge,
    .csg-site-navbar .csg-days,
    .csg-site-navbar .csg-exp {
      white-space: nowrap;
    }
    /* Bell dropdown — shared styles for both bell instances (one outside the
       collapse for mobile/tablet, one inside the right-side ul for desktop). */
    .csg-bell-nav .csg-bell-toggle {
      position: relative;
      display: inline-flex;
      align-items: center;
      color: rgba(255,255,255,0.85);
      padding: 0.45rem 0.6rem;
    }
    .csg-bell-nav .csg-bell-toggle:hover,
    .csg-bell-nav .csg-bell-toggle:focus { color: #fff; }
    .csg-bell-nav .csg-bell-badge {
      display: none; /* JS sets inline-block when unread > 0 */
      position: absolute;
      top: 1px;
      right: -2px;
      font-size: 0.62rem;
      padding: 1px 5px;
      border-radius: 999px;
      line-height: 1;
    }
    .csg-bell-nav .csg-bell-menu {
      min-width: 340px;
      max-width: min(92vw, 400px);
      max-height: 480px;
      overflow: auto;
    }

    /* Outside-collapse bell — visible on mobile/tablet only. Sits between the
       brand and the hamburger toggler. */
    .csg-bell-outside {
      display: flex;
      align-items: center;
      margin-left: auto;
      flex-shrink: 0;
    }
    @media (max-width: 1399.98px) {
      .csg-bell-outside { margin-right: 0.4rem; }
    }
    @media (min-width: 1400px) {
      .csg-bell-outside { display: none !important; }
    }

    /* Inside-collapse bell — visible on desktop only. Sits in the right-side ul
       just before the Hi-user greeting. Hidden on mobile so opening the
       hamburger does not surface a duplicate bell. */
    .csg-bell-inside { display: none; }
    @media (min-width: 1400px) {
      .csg-bell-inside { display: list-item; }
    }
    .csg-site-navbar .navbar-nav {
      align-items: center;
    }
    .csg-site-navbar .navbar-collapse {
      min-width: 0;
    }
    @media (max-width: 1399.98px) {
      .csg-site-navbar.navbar-expand-csg > .container,
      .csg-site-navbar.navbar-expand-csg > .container-fluid {
        padding-left: 0;
        padding-right: 0;
      }
      .csg-site-navbar.navbar-expand-csg .navbar-toggler {
        display: block;
      }
      .csg-site-navbar.navbar-expand-csg .navbar-collapse {
        display: none !important;
        width: 100%;
        margin-top: 0.45rem;
        padding-top: 0.55rem;
        border-top: 1px solid rgba(255,255,255,0.08);
      }
      .csg-site-navbar.navbar-expand-csg .navbar-collapse.show {
        display: block !important;
      }
      .csg-site-navbar.navbar-expand-csg .navbar-nav,
      .csg-site-navbar.navbar-expand-csg .nav.navbar-nav {
        width: 100%;
        align-items: stretch;
      }
      .csg-site-navbar.navbar-expand-csg .navbar-nav .nav-link,
      .csg-site-navbar.navbar-expand-csg .nav.navbar-nav .nav-link {
        width: 100%;
        padding-left: 0 !important;
        padding-right: 0 !important;
      }
      .csg-site-navbar.navbar-expand-csg .navbar-nav.mr-auto {
        margin-right: 0 !important;
      }
      .csg-site-navbar.navbar-expand-csg .navbar-right.ml-auto {
        margin-left: 0 !important;
      }
      .csg-site-navbar.navbar-expand-csg .dropdown-menu {
        position: static !important;
        float: none;
        width: 100%;
        margin-top: 0.25rem;
      }
      .csg-site-navbar.navbar-expand-csg .csg-bell-nav.dropdown {
        position: relative;
      }
      .csg-site-navbar.navbar-expand-csg .csg-bell-nav .dropdown-menu.csg-bell-menu {
        position: fixed !important;
        top: 56px !important;
        right: 8px !important;
        left: 8px !important;
        transform: none !important;
        width: auto;
        min-width: 0;
        max-height: min(70vh, 480px);
        margin-top: 0.35rem;
        z-index: 1040;
      }
    }
    @media (min-width: 1400px) {
      .csg-site-navbar.navbar-expand-csg {
        flex-flow: row nowrap;
        justify-content: flex-start;
      }
      .csg-site-navbar.navbar-expand-csg .navbar-toggler {
        display: none;
      }
      .csg-site-navbar.navbar-expand-csg .navbar-collapse {
        display: flex !important;
        flex-basis: auto;
      }
      .csg-site-navbar.navbar-expand-csg .navbar-nav {
        flex-direction: row;
      }
      .csg-site-navbar.navbar-expand-csg .dropdown-menu {
        position: absolute;
      }
    }
   
    .resizeable-column {
      resize: horizontal; /* Allow the user to resize horizontally */
      overflow: auto; /* Add scrollbars if the content overflows */
    }
        
		.frame {
			height: 500px; /* adjust height as needed */
			   
    hr { 
      margin: 0em;
    } 

    input[type="radio"] {
      -ms-transform: scale(1.5); /* IE 9 */
      -webkit-transform: scale(1.5); /* Chrome, Safari, Opera */
      transform: scale(1.5);
      margin: 10;
    }

    input[type="checkbox"] {
      -ms-transform: scale(1.5); /* IE 9 */
      -webkit-transform: scale(1.5); /* Chrome, Safari, Opera */
      transform: scale(1.5);
    }
        
    .answer_explanation_toggle_wrapper    
    {
            
    }    
    #answer_explanation 
    {
        margin-top: 0px;  
        margin-bottom: 30px; 
        background: gray;
        width: auto; height: 50px;
    }
    .buttontags {
      border-radius: 100px; /* Adjust the value to control the roundness of the corners */
      opacity: 0.1; /* Adjust the value to control the greyed-out appearance */
      pointer-events: none; /* Disable pointer events to make the button non-clickable */
    }

    <style>
  /* Custom striped table colors */
  .table-striped-concepts tbody tr:nth-of-type(odd) {
    background-color: #f8f9fa; /* Light gray color */
  }
  
  .table-striped-concepts tbody tr:nth-of-type(even) {
    background-color: goldenyellow; /* Dark gray color */
  }
</style>

    </style>

    <script>
    $( "button.crf-sdtm-anno-toggle" ).click(function() {
       $( this ).next(".crf-sdtm-anno-toggle").toggle();

    });
        </script>
</head>
<body>

<div class="container-fluid sticky-top m-0 p-0">
  <div class="row h-5 p-0 m-0 d-flex-row">
    <div class="col-12 bg-dark p-0 m-0">

    <nav class="navbar navbar-expand-csg csg-site-navbar bg-dark navbar-dark p-0 px-3 m-0">
    <a class="navbar-brand" href="/index.php">mycsg.in</a>
    <div class="csg-bell-nav csg-bell-outside dropdown">
  <a class="csg-bell-toggle nav-link" href="#" data-toggle="dropdown" role="button"
     aria-haspopup="true" aria-expanded="false" aria-label="Notifications">
    <i class="fas fa-bell"></i>
    <span class="csg-bell-badge badge badge-danger">0</span>
  </a>
  <div class="csg-bell-menu dropdown-menu dropdown-menu-right p-0">
    <div class="px-3 py-2 d-flex justify-content-between align-items-center border-bottom" style="background:#f8fafc;">
      <strong class="small text-dark">Notifications</strong>
      <span class="d-inline-flex align-items-center" style="gap:10px;">
        <button type="button" class="csg-bell-mark-all btn btn-link btn-sm p-0" style="font-size:.75rem;">Mark all read</button>
        <button type="button" class="csg-bell-close btn btn-link btn-sm p-0 text-muted" aria-label="Close notifications" title="Close" style="font-size:1rem;line-height:1;">&times;</button>
      </span>
    </div>
    <div class="csg-bell-list">
      <div class="px-3 py-3 text-muted text-center small">Loading&hellip;</div>
    </div>
    <div class="border-top px-3 py-2 d-flex justify-content-between align-items-center" style="background:#f8fafc;">
      <a href="/notifications_inbox.php" class="small">Open inbox</a>
      <label class="small mb-0 text-dark" style="font-size:.75rem;cursor:pointer;">
        <input type="checkbox" class="csg-bell-email-optin"> Email me
      </label>
    </div>
  </div></div>
    <button class="navbar-toggler center" type="button" data-toggle="collapse" data-target="#collapsibleNavbar">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="collapsibleNavbar">
      <ul class="navbar-nav mr-auto">
        <li class="nav-item">   <a class="nav-link" href="/sas.php">SAS</a>  </li>
    <li class="nav-item">   <a class="nav-link" href="/sasnr2.php">SASnR</a>  </li>
     <li class="nav-item dropdown">
        <a class="nav-link dropdown-toggle" href="#" id="clinicalProgrammingDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
        Clinical Programming
        </a>
        <div class="dropdown-menu" aria-labelledby="clinicalProgrammingDropdown">
        <a class="dropdown-item" href="/crfs/">CRFs</a>
        <a class="dropdown-item" href="/sdtm.php">SDTM</a>
        <a class="dropdown-item" href="/adam.php">ADaM</a>
        <a class="dropdown-item" href="/tfl.php">TFL</a>
        <a class="dropdown-item" href="/tasks.php">Tasks</a>
        <a class="dropdown-item" href="/macros.php">Macros</a>
        </div>
    </li>
    <li class="nav-item">   <a class="nav-link" href="/qna.php">QnA</a>  </li>
    <li class="nav-item">   <a class="nav-link" href="/quiz.php">Quizzes</a>  </li>
    <li class="nav-item">   <a class="nav-link" href="/resources.php">Resources</a>  </li>
    <li class="nav-item">   <a class="nav-link" href="/disclaimer.php">Disclaimer</a>  </li>
    <li class="nav-item">   <a class="nav-link" href="/contact%20us.php">Contact Us</a>  </li>
    <li class="nav-item">
      <a class="nav-link d-flex align-items-center justify-content-start" href="/training.php">
        <span>Training</span>
      </a>
    </li>
    
    
    </ul>
    <ul class="nav navbar-nav navbar-right ml-auto">
      <li class="nav-item dropdown csg-bell-nav csg-bell-inside">
  <a class="csg-bell-toggle nav-link" href="#" data-toggle="dropdown" role="button"
     aria-haspopup="true" aria-expanded="false" aria-label="Notifications">
    <i class="fas fa-bell"></i>
    <span class="csg-bell-badge badge badge-danger">0</span>
  </a>
  <div class="csg-bell-menu dropdown-menu dropdown-menu-right p-0">
    <div class="px-3 py-2 d-flex justify-content-between align-items-center border-bottom" style="background:#f8fafc;">
      <strong class="small text-dark">Notifications</strong>
      <span class="d-inline-flex align-items-center" style="gap:10px;">
        <button type="button" class="csg-bell-mark-all btn btn-link btn-sm p-0" style="font-size:.75rem;">Mark all read</button>
        <button type="button" class="csg-bell-close btn btn-link btn-sm p-0 text-muted" aria-label="Close notifications" title="Close" style="font-size:1rem;line-height:1;">&times;</button>
      </span>
    </div>
    <div class="csg-bell-list">
      <div class="px-3 py-3 text-muted text-center small">Loading&hellip;</div>
    </div>
    <div class="border-top px-3 py-2 d-flex justify-content-between align-items-center" style="background:#f8fafc;">
      <a href="/notifications_inbox.php" class="small">Open inbox</a>
      <label class="small mb-0 text-dark" style="font-size:.75rem;cursor:pointer;">
        <input type="checkbox" class="csg-bell-email-optin"> Email me
      </label>
    </div>
  </div></li>
<li class="nav-item d-flex align-items-center">
  <a class="nav-link d-flex align-items-center" title="Ravi">
    
    <span style="max-width:120px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;display:inline-block;">Hi Ravi!</span>
  </a>
</li><style>
/* tiny pulse dot next to the ACCESS pill */
.csg-pulse {
  position: relative; display:inline-block; width:8px; height:8px; border-radius:50%;
  margin-left:6px; background: #ffcc00;
}
.csg-pulse::after {
  content:""; position:absolute; left:50%; top:50%; width:8px; height:8px; border-radius:50%;
  transform: translate(-50%,-50%); box-shadow: 0 0 0 0 rgba(255,204,0,.6); animation: csg-pulse 1.8s infinite;
}
@keyframes csg-pulse { 0%{box-shadow:0 0 0 0 rgba(255,204,0,.6);} 70%{box-shadow:0 0 0 10px rgba(255,204,0,0);} 100%{box-shadow:0 0 0 0 rgba(255,204,0,0);} }
/* row layout inside dropdown */
.csg-row { display:flex; align-items:center; justify-content:space-between; gap:.75rem; padding:.25rem .25rem; }
.csg-left { display:flex; align-items:center; gap:.5rem; min-width: 0; }
.csg-tag { font-size:.75rem; padding:.25rem .5rem; border-radius:.5rem; }
.csg-days { font-weight:700; white-space:nowrap; }
.csg-exp { font-size:.8rem; color:#6c757d; white-space:nowrap; }
.csg-divider { margin:.25rem 0; }
.csg-preview-nav .dropdown-toggle::after { margin-left:.35rem; }
.csg-preview-menu { min-width: 180px; }
.csg-preview-menu .dropdown-item.active,
.csg-preview-menu .dropdown-item:active {
  background:#ffc107;
  color:#212529;
}
.csg-preview-menu .dropdown-item:hover {
  background:#f8f9fa;
  color:#212529;
}
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
  var previewRoot = document.getElementById('csgPreviewMenu');
  if (!previewRoot) return;

  var toggle = document.getElementById('csgPreviewToggle');
  var menu = previewRoot.querySelector('.csg-preview-menu');
  var closeBtn = previewRoot.querySelector('.csg-preview-close');
  var isOpen = false;

  function openMenu() {
    if (!menu || !toggle) return;
    previewRoot.classList.add('show');
    menu.classList.add('show');
    toggle.classList.add('show');
    toggle.setAttribute('aria-expanded', 'true');
    isOpen = true;
  }

  function closeMenu() {
    if (!menu || !toggle) return;
    previewRoot.classList.remove('show');
    menu.classList.remove('show');
    toggle.classList.remove('show');
    toggle.setAttribute('aria-expanded', 'false');
    isOpen = false;
  }

  previewRoot.addEventListener('mouseenter', openMenu);

  toggle.addEventListener('click', function(e) {
    e.preventDefault();
    if (isOpen) {
      closeMenu();
    } else {
      openMenu();
    }
  });

  if (closeBtn) {
    closeBtn.addEventListener('click', function(e) {
      e.preventDefault();
      closeMenu();
    });
  }

  document.addEventListener('click', function(e) {
    if (!previewRoot.contains(e.target)) {
      closeMenu();
    }
  });

  document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
      closeMenu();
    }
  });
});
</script>


<li class="nav-item dropdown d-flex align-items-center">
  <a class="nav-link dropdown-toggle d-flex align-items-center"
     href="#" id="csgAccessMenu"
     role="button"
     data-bs-toggle="dropdown"       
     data-toggle="dropdown"          
     data-bs-boundary="viewport"      
     data-boundary="viewport"         
     data-bs-offset="0,8"             
     aria-expanded="false">
    <span class="badge bg-warning text-dark">ACCESS</span>
    <span class="csg-pulse"></span>
  </a>

  <div class="dropdown-menu dropdown-menu-end dropdown-menu-right p-2"
       aria-labelledby="csgAccessMenu"
       style="min-width: 320px; max-width: min(92vw, 420px); overflow-wrap:anywhere;">

        <div class="csg-row">
          <div class="csg-left">
            <span class="csg-tag badge bg-success">R Recs</span>
            <span class="csg-exp">expires <strong>11 Jun 2026</strong></span>
          </div>
          <div class="csg-days text-success">26d</div>
        </div>
        <div class="dropdown-divider csg-divider"></div>
        <div class="px-1 text-muted" style="font-size:.75rem;">As of 17 May 2026, 23:51 IST</div>
      </div>
    </li>  
      <li class="nav-item">
        <a class="nav-link" href="/logout.php">Log out</a>
      </li>
      </ul>
    </div>
    </div>
    </nav>
    

</div>

</div>



<script>
(function () {
  var bells = document.querySelectorAll(".csg-bell-nav");
  if (!bells.length) return;

  function $all(sel) { return document.querySelectorAll(sel); }
  function escH(s) { var d = document.createElement("div"); d.textContent = String(s == null ? "" : s); return d.innerHTML; }
  function relTime(iso) {
    if (!iso) return "";
    var d = new Date(iso);
    if (isNaN(d.getTime())) return "";
    var s = Math.max(0, (Date.now() - d.getTime()) / 1000);
    if (s < 60) return "just now";
    if (s < 3600) return Math.floor(s/60) + "m ago";
    if (s < 86400) return Math.floor(s/3600) + "h ago";
    if (s < 86400*7) return Math.floor(s/86400) + "d ago";
    return d.toLocaleDateString();
  }

  function renderItems(items) {
    var html;
    if (!items || !items.length) {
      html = "<div class=\"px-3 py-4 text-muted text-center small\">You're all caught up.</div>";
    } else {
      html = items.slice(0, 10).map(function (n) {
        var bodyTrunc = (n.body_html || "").replace(/<[^>]+>/g, " ").trim();
        if (bodyTrunc.length > 140) bodyTrunc = bodyTrunc.slice(0, 140) + "…";
        var link = n.link || "";
        var clickAction = link ? ("data-link=\"" + escH(link) + "\"") : "";
        var color = n.color || "#6b7280";
        var icon = n.icon || "fa-bell";
        var dim = n.is_dismissed ? "opacity:0.55;" : "";
        return ""
          + "<div class=\"csg-bell-row\" data-id=\"" + escH(n.id) + "\" " + clickAction + " "
          + "style=\"display:flex;gap:10px;padding:10px 14px;border-bottom:1px solid #eef2f6;cursor:pointer;" + dim + "\">"
          + "  <div style=\"width:28px;height:28px;border-radius:50%;background:" + color + ";color:#fff;display:flex;align-items:center;justify-content:center;flex-shrink:0;\">"
          + "    <i class=\"fas " + escH(icon) + "\" style=\"font-size:.75rem;\"></i>"
          + "  </div>"
          + "  <div style=\"flex:1;min-width:0;\">"
          + "    <div style=\"font-weight:600;font-size:.83rem;color:#0f172a;\">" + escH(n.title) + "</div>"
          + "    <div style=\"color:#64748b;font-size:.78rem;line-height:1.3;\">" + escH(bodyTrunc) + "</div>"
          + "    <div style=\"color:#94a3b8;font-size:.7rem;margin-top:2px;\">"
          + "      <span class=\"csg-bell-pill\" style=\"background:" + color + "22;color:" + color + ";padding:1px 6px;border-radius:999px;font-weight:600;margin-right:6px;\">" + escH(n.type_label || n.type || "Update") + "</span>"
          + "      " + escH(relTime(n.created_at))
          + "    </div>"
          + "  </div>"
          + (n.is_dismissed ? "" : "  <button type=\"button\" class=\"btn btn-link p-0 csg-bell-dismiss\" title=\"Mark read\" style=\"color:#94a3b8;font-size:.85rem;align-self:flex-start;\">&times;</button>")
          + "</div>";
      }).join("");
    }
    $all(".csg-bell-list").forEach(function (el) { el.innerHTML = html; });
  }

  function setBadge(n) {
    var show = n && n > 0;
    var text = !show ? "0" : (n > 99 ? "99+" : String(n));
    $all(".csg-bell-badge").forEach(function (el) {
      el.style.display = show ? "inline-block" : "none";
      el.textContent = text;
    });
  }

  function setOptin(checked) {
    $all(".csg-bell-email-optin").forEach(function (el) { el.checked = !!checked; });
  }

  function refresh() {
    fetch("/notifications_api.php?action=list&limit=10", { credentials: "same-origin" })
      .then(function (r) { return r.json(); })
      .then(function (res) {
        if (!res || !res.ok) {
          $all(".csg-bell-list").forEach(function (el) {
            el.innerHTML = "<div class=\"px-3 py-3 text-muted text-center small\">Failed to load.</div>";
          });
          return;
        }
        setBadge(res.unread || 0);
        setOptin(res.email_optin);
        renderItems(res.items || []);
      })
      .catch(function () {
        $all(".csg-bell-list").forEach(function (el) {
          el.innerHTML = "<div class=\"px-3 py-3 text-muted text-center small\">Network error.</div>";
        });
      });
  }
  window.csgRefreshBell = refresh;

  // Click handler on every list (delegation)
  $all(".csg-bell-list").forEach(function (list) {
    list.addEventListener("click", function (e) {
      var dismissBtn = e.target.closest(".csg-bell-dismiss");
      var row = e.target.closest(".csg-bell-row");
      if (!row) return;
      var id = row.getAttribute("data-id") || "";

      if (dismissBtn) {
        e.preventDefault(); e.stopPropagation();
        var fd = new FormData();
        fd.append("action", "dismiss");
        fd.append("id", id);
        fetch("/notifications_api.php", { method: "POST", body: fd, credentials: "same-origin" })
          .then(function (r) { return r.json(); })
          .then(function (res) { if (res && res.ok) { setBadge(res.unread || 0); refresh(); } });
        return;
      }

      var link = row.getAttribute("data-link");
      var fd2 = new FormData();
      fd2.append("action", "dismiss");
      fd2.append("id", id);
      if (navigator.sendBeacon) {
        navigator.sendBeacon("/notifications_api.php", fd2);
      } else {
        fetch("/notifications_api.php", { method: "POST", body: fd2, credentials: "same-origin", keepalive: true }).catch(function () {});
      }
      if (link) window.location.href = link;
    });
  });

  $all(".csg-bell-close").forEach(function (btn) {
    btn.addEventListener("click", function (e) {
      e.preventDefault();
      e.stopPropagation();
      var nav = btn.closest(".csg-bell-nav");
      var toggle = nav ? nav.querySelector(".csg-bell-toggle") : null;
      if (toggle && window.jQuery && window.jQuery.fn && window.jQuery.fn.dropdown) {
        window.jQuery(toggle).dropdown("hide");
      } else {
        var menu = nav ? nav.querySelector(".csg-bell-menu") : null;
        if (menu) menu.classList.remove("show");
        if (toggle) toggle.setAttribute("aria-expanded", "false");
      }
    });
  });

  $all(".csg-bell-mark-all").forEach(function (btn) {
    btn.addEventListener("click", function (e) {
      e.preventDefault();
      var fd = new FormData();
      fd.append("action", "dismiss_all");
      fetch("/notifications_api.php", { method: "POST", body: fd, credentials: "same-origin" })
        .then(function (r) { return r.json(); })
        .then(function () { refresh(); });
    });
  });

  $all(".csg-bell-email-optin").forEach(function (cb) {
    cb.addEventListener("change", function () {
      var fd = new FormData();
      fd.append("action", "set_email_optin");
      fd.append("optin", cb.checked ? "1" : "0");
      setOptin(cb.checked); // sync the other instance immediately
      fetch("/notifications_api.php", { method: "POST", body: fd, credentials: "same-origin" });
    });
  });

  refresh();
})();
</script>
<script src="//cdnjs.cloudflare.com/ajax/libs/highlight.js/11.2.0/highlight.min.js"></script><link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/highlight.js/11.2.0/styles/default.min.css"><link rel="stylesheet" href="assets/sas_mini_highlight.css"><script src="assets/sas_mini_highlight.js"></script><script>hljs.initHighlightingOnLoad();</script><style>
.accordion-header.lang-sas { background-color: #cfe7ff; }
.accordion-header.lang-r-tidyverse { background-color: #d6f2d2; }
.accordion-header.lang-r-base { background-color: #edd6ff; }
.accordion-header.lang-python { background-color: #ffe2a8; }
.accordion-header.lang-default { background-color: #f1f3f5; }
.accordion-header { border-bottom: 1px solid rgba(0,0,0,0.08); padding-top: 15px; padding-bottom: 15px; }
.code-card.lang-sas { border: 1px solid #90caf9; }
.code-card.lang-r-tidyverse { border: 1px solid #a5d6a7; }
.code-card.lang-r-base { border: 1px solid #b07bff; }
.code-card.lang-python { border: 1px solid #ffd166; }
.code-card.lang-default { border: 1px solid #dee2e6; }
.accordion-header h6 { font-size: 1.6rem; line-height: 1.2; }
.accordion-header .badge { font-size: 1.2rem; }
.variant-code { background-color: #f8f9fa; border: 1px solid #e1e5ea; padding: 8px; border-radius: 4px; }
.code-card.lang-sas .variant-code { background-color: transparent; padding: 0; border: 0; }
.variant-description { background-color: #ffffff; border: 1px solid #e1e5ea; padding: 10px 12px; border-radius: 4px; color: #222; }
.variant-description code { background-color: #f4f6f8; padding: 1px 4px; border-radius: 3px; font-size: 0.92em; }
</style><style>
/* --- csg_ads shared layout --- */
/* App-shell: only .csg-center-col (and mobile interstitial) scrolls.
   Containing document (including iframe documents) must not add its own scroll. */
html, body {
  height: 100% !important;
  margin: 0 !important;
  overflow: hidden !important;
}
.csg-adwrap {
  --csg-ad-col-width: clamp(200px, 20vw, 320px);
  --csg-center-max: none;
  --csg-adwrap-bg: #e8ecf1;
  --csg-center-padding: 20px 28px;
  display: flex;
  overflow: hidden;
  background: var(--csg-adwrap-bg);
}
.csg-ad-col {
  flex: 0 0 var(--csg-ad-col-width);
  overflow: hidden;
  padding: 16px 8px;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
}
.csg-ad-label {
  font-size: 9px;
  color: #b0b8c4;
  text-transform: uppercase;
  letter-spacing: 0.12em;
  align-self: stretch;
  text-align: center;
  visibility: hidden;
}
.csg-ad-col.is-filled .csg-ad-label { visibility: visible; }
.csg-center-col {
  flex: 1;
  min-width: 0;
  min-height: 100%;
  max-width: var(--csg-center-max);
  overflow-y: auto;
  padding: var(--csg-center-padding);
  background: #ffffff;
  box-shadow: 0 0 0 1px rgba(0,0,0,0.06), 0 0 40px rgba(0,0,0,0.16);
  position: relative;
  z-index: 2;
}
@media (max-width: 991.98px) {
  .csg-ad-col { display: none; }
  .csg-center-col { padding: 16px 14px; box-shadow: none; }
}
/* --- csg_ads mobile interstitial --- */
.csg-interstitial-overlay {
  position: fixed;
  inset: 0;
  z-index: 9999;
  background: rgba(0,0,0,0.88);
  display: none;
  align-items: center;
  justify-content: center;
  padding: 16px;
}
.csg-interstitial-card {
  width: 100%;
  max-width: 380px;
  background: #111;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 8px 32px rgba(0,0,0,0.6);
}
.csg-interstitial-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 8px 12px;
  border-bottom: 1px solid rgba(255,255,255,0.08);
}
.csg-interstitial-ad-label {
  font-size: 10px;
  color: #666;
  text-transform: uppercase;
  letter-spacing: 0.1em;
}
.csg-interstitial-skip {
  background: rgba(255,255,255,0.08);
  border: 1px solid rgba(255,255,255,0.12);
  color: #aaa;
  border-radius: 4px;
  padding: 4px 10px;
  font-size: 12px;
  cursor: default;
}
.csg-interstitial-skip:not(:disabled) {
  cursor: pointer;
  background: rgba(255,255,255,0.18);
  color: #fff;
  border-color: rgba(255,255,255,0.3);
}
</style><script async src='https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-7309667479757182' crossorigin='anonymous'></script><script>
(function() {
  function setH() {
    var el = document.getElementById("sasnr-lesson-wrap");
    if (!el) return;
    var top = el.getBoundingClientRect().top;
    var vh  = window.innerHeight || document.documentElement.clientHeight;
    // Leave room for the fixed site footer (footer.php, id='pagefooter') when present.
    // Absent on iframe documents — in that case footerH is 0.
    var footer  = document.getElementById('pagefooter');
    var footerH = footer ? footer.offsetHeight : 0;
    el.style.height = Math.max(300, vh - top - footerH) + 'px';
  }
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', setH);
  } else {
    setH();
  }
  window.addEventListener('load', setH);
  window.addEventListener('resize', setH);
  setTimeout(setH, 600);
})();
</script><div class='csg-adwrap' id='sasnr-lesson-wrap'><div class='csg-center-col'><center><h2>Arrays - Example - replace a text value in all character variables</h2></center><hr><div class="card mb-3 code-card lang-default">  <div class="card-header p-2 d-flex justify-content-between align-items-center accordion-header lang-default" data-toggle="collapse" data-target="#lessonDesc" style="cursor:pointer;" role="button" aria-expanded="true" aria-controls="lessonDesc">    <h6 class="mb-0">Lesson Description</h6>    <span class="toggle-indicator" data-target="lessonDesc">-</span>  </div>  <div id="lessonDesc" class="collapse show">    <div class="card-body variant-description"><ul>
<li>A common request in clinical data: replace a sentinel string like <code>"_missing_"</code> with a genuine empty value across every character column.</li>
<li>Writing the rule once and applying it to all character columns keeps the code short and correct as new character columns are added upstream.</li>
<li>SAS uses an ARRAY with the special shortcut <code>_character_</code> to point at every character variable, then a DO loop to apply the replacement.</li>
<li>Tidyverse uses <code>mutate(across(where(is.character), ...))</code> to target all character columns and run the replacement through <code>if_else()</code>.</li>
<li>Base R uses <code>sapply(df, is.character)</code> to build a logical mask of character columns, then <code>lapply()</code> to apply the replacement.</li>
<li>This lesson replaces every <code>"_missing_"</code> value in a small three-row dataset with an empty string, across all five character columns.</li>
</ul>    </div>  </div></div><div id="codeAccordion" class="mb-4"><div class="card mb-2 code-card lang-sas">  <div class="card-header p-2 d-flex justify-content-between align-items-center accordion-header lang-sas" data-toggle="collapse" data-target="#collapse0" style="cursor:pointer;" role="button" aria-expanded="false" aria-controls="collapse0">    <h6 class="mb-0"><span class="badge badge-primary mr-2">SAS</span> (Base SAS)</h6>    <div class="d-flex align-items-center">      <button type="button" class="btn btn-light btn-sm copy-code-btn mr-2" data-target-code="code-block-collapse0">Copy</button>      <span class="toggle-indicator" data-target="collapse0">+</span>    </div>  </div>  <div id="collapse0" class="collapse">    <div class="card-body">      <div class="variant-code" id="code-block-collapse0"><pre><code class="language-sas-mini">data CHARDATA;
 infile datalines dlm=&#039;|&#039; dsd missover;
input var1 : $10. var2 : $10. var3 : $10. var4 : $10. var5 : $10.;
label ;
 format ;
 datalines4;
_missing_|text1|text2|_missing_|text3
text4|text5|_missing_|text6|text7
text8|_missing_|text9|text10|text11
;;;;
 run;

data chardata01;
     set chardata;

    array xchar[*] _character_;

    do i=1 to dim(xchar);
         if lowcase(xchar[i])=&quot;_missing_&quot; then xchar[i]=&quot;&quot;;
    end;

    drop i;
 run;</code></pre>      </div><div class="variant-description mt-2"><ul>
<li>In SAS, <code>_character_</code> is a reserved keyword that stands for "every character variable in the current dataset".</li>
<li><code>array xchar[*] _character_;</code> builds an array pointing at every character column &mdash; no need to list them by name.</li>
<li><code>do i = 1 to dim(xchar);</code> loops over every element in that array; <code>dim()</code> returns the count automatically.</li>
<li><code>if lowcase(xchar[i]) = "_missing_" then xchar[i] = "";</code> compares the lower-cased value to the sentinel and, when it matches, writes an empty string back into the column.</li>
<li>Using <code>lowcase()</code> on the comparison makes the match case-insensitive, so <code>"_MISSING_"</code> and <code>"_Missing_"</code> are caught too.</li>
<li><code>drop i;</code> removes the loop index from the output so it does not clutter the final dataset.</li>
<li>We run and confirm every <code>"_missing_"</code> in CHARDATA has been replaced with an empty value in CHARDATA01.</li>
</ul></div>    </div>  </div></div><div class="card mb-2 code-card lang-r-tidyverse">  <div class="card-header p-2 d-flex justify-content-between align-items-center accordion-header lang-r-tidyverse" data-toggle="collapse" data-target="#collapse1" style="cursor:pointer;" role="button" aria-expanded="false" aria-controls="collapse1">    <h6 class="mb-0"><span class="badge badge-success mr-2">R</span> (tidyverse)</h6>    <div class="d-flex align-items-center">      <button type="button" class="btn btn-light btn-sm copy-code-btn mr-2" data-target-code="code-block-collapse1">Copy</button>      <span class="toggle-indicator" data-target="collapse1">+</span>    </div>  </div>  <div id="collapse1" class="collapse">    <div class="card-body">      <div class="variant-code" id="code-block-collapse1"><pre><code class="language-r">library(tidyverse)


chardata&lt;-tribble(
~var1,~var2,~var3,~var4,~var5,
&quot;_missing_&quot;,&quot;text1&quot;,&quot;text2&quot;,&quot;_missing_&quot;,&quot;text3&quot;,
&quot;text4&quot;,&quot;text5&quot;,&quot;_missing_&quot;,&quot;text6&quot;,&quot;text7&quot;,
&quot;text8&quot;,&quot;_missing_&quot;,&quot;text9&quot;,&quot;text10&quot;,&quot;text11&quot;,
)

 

chardata01 &lt;- chardata %&gt;%
  mutate(across(where(is.character), ~ifelse(tolower(.) == &quot;_missing_&quot;, &quot;&quot;, .)))</code></pre>      </div><div class="variant-description mt-2"><ul>
<li>In tidyverse, <code>across()</code> combined with <code>where()</code> gives us "apply this to every column that passes a type check" &mdash; the direct analogue of SAS's <code>_character_</code> shortcut.</li>
<li><code>mutate(across(where(is.character), ~ if_else(tolower(.) == "_missing_", "", .)))</code> targets every character column and replaces the sentinel.</li>
<li><code>where(is.character)</code> passes each column through <code>is.character()</code> and keeps only those that return TRUE.</li>
<li>The <code>~</code> introduces an anonymous function; <code>.</code> is the placeholder for the current column's values.</li>
<li><code>tolower()</code> makes the comparison case-insensitive, consistent with the SAS <code>lowcase()</code> call.</li>
<li><code>if_else(condition, "", .)</code> replaces matching values with an empty string and leaves non-matches unchanged.</li>
<li>We run and confirm the resulting CHARDATA01 has <code>"_missing_"</code> cleared across every character column.</li>
</ul></div>    </div>  </div></div><div class="card mb-2 code-card lang-r-base">  <div class="card-header p-2 d-flex justify-content-between align-items-center accordion-header lang-r-base" data-toggle="collapse" data-target="#collapse2" style="cursor:pointer;" role="button" aria-expanded="false" aria-controls="collapse2">    <h6 class="mb-0"><span class="badge badge-success mr-2">R</span> (base)</h6>    <div class="d-flex align-items-center">      <button type="button" class="btn btn-light btn-sm copy-code-btn mr-2" data-target-code="code-block-collapse2">Copy</button>      <span class="toggle-indicator" data-target="collapse2">+</span>    </div>  </div>  <div id="collapse2" class="collapse">    <div class="card-body">      <div class="variant-code" id="code-block-collapse2"><pre><code class="language-r">chardata &lt;- data.frame(
  var1 = c(&quot;_missing_&quot;, &quot;text4&quot;, &quot;text8&quot;),
  var2 = c(&quot;text1&quot;, &quot;text5&quot;, &quot;_missing_&quot;),
  var3 = c(&quot;text2&quot;, &quot;_missing_&quot;, &quot;text9&quot;),
  var4 = c(&quot;_missing_&quot;, &quot;text6&quot;, &quot;text10&quot;),
  var5 = c(&quot;text3&quot;, &quot;text7&quot;, &quot;text11&quot;)
  , stringsAsFactors = FALSE
)

chardata01_tmp &lt;- chardata

chardata01_tmp$~ifelse(tolower(.) &lt;- = &quot;_missing_&quot;

chardata01 &lt;- chardata01_tmp</code></pre>      </div><div class="variant-description mt-2"><ul>
<li>In base R, we first identify the character columns with a logical mask: <code>char_cols &lt;- sapply(df, is.character)</code>.</li>
<li><code>sapply()</code> runs <code>is.character()</code> on every column and returns a named logical vector &mdash; TRUE for character columns, FALSE otherwise.</li>
<li>We then apply the replacement to just those columns: <code>df[char_cols] &lt;- lapply(df[char_cols], function(x) { x[tolower(x) == "_missing_"] &lt;- ""; x })</code>.</li>
<li>Inside the inner function, <code>x[tolower(x) == "_missing_"] &lt;- ""</code> uses logical subsetting to overwrite only the matching values with an empty string, then returns the updated vector.</li>
<li>Assigning the returned list back through <code>df[char_cols]</code> updates those columns in place.</li>
<li>We run and check the resulting data frame &mdash; every sentinel value across character columns should now be an empty string.</li>
</ul></div>    </div>  </div></div></div></div></div><script>
    const variants = [{"label":"SAS (Base SAS)","code":"data CHARDATA;\n infile datalines dlm='|' dsd missover;\ninput var1 : $10. var2 : $10. var3 : $10. var4 : $10. var5 : $10.;\nlabel ;\n format ;\n datalines4;\n_missing_|text1|text2|_missing_|text3\ntext4|text5|_missing_|text6|text7\ntext8|_missing_|text9|text10|text11\n;;;;\n run;\n\ndata chardata01;\n     set chardata;\n\n    array xchar[*] _character_;\n\n    do i=1 to dim(xchar);\n         if lowcase(xchar[i])=\"_missing_\" then xchar[i]=\"\";\n    end;\n\n    drop i;\n run;","language":"sas","html":"<pre><code class=\"language-sas-mini\">data CHARDATA;\n infile datalines dlm=&#039;|&#039; dsd missover;\ninput var1 : $10. var2 : $10. var3 : $10. var4 : $10. var5 : $10.;\nlabel ;\n format ;\n datalines4;\n_missing_|text1|text2|_missing_|text3\ntext4|text5|_missing_|text6|text7\ntext8|_missing_|text9|text10|text11\n;;;;\n run;\n\ndata chardata01;\n     set chardata;\n\n    array xchar[*] _character_;\n\n    do i=1 to dim(xchar);\n         if lowcase(xchar[i])=&quot;_missing_&quot; then xchar[i]=&quot;&quot;;\n    end;\n\n    drop i;\n run;<\/code><\/pre>"},{"label":"R (tidyverse)","code":"library(tidyverse)\r\n\r\n\r\nchardata<-tribble(\r\n~var1,~var2,~var3,~var4,~var5,\r\n\"_missing_\",\"text1\",\"text2\",\"_missing_\",\"text3\",\r\n\"text4\",\"text5\",\"_missing_\",\"text6\",\"text7\",\r\n\"text8\",\"_missing_\",\"text9\",\"text10\",\"text11\",\r\n)\r\n\r\n \r\n\r\nchardata01 <- chardata %>%\r\n  mutate(across(where(is.character), ~ifelse(tolower(.) == \"_missing_\", \"\", .)))","language":"r","html":"<pre><code class=\"language-r\">library(tidyverse)\r\n\r\n\r\nchardata&lt;-tribble(\r\n~var1,~var2,~var3,~var4,~var5,\r\n&quot;_missing_&quot;,&quot;text1&quot;,&quot;text2&quot;,&quot;_missing_&quot;,&quot;text3&quot;,\r\n&quot;text4&quot;,&quot;text5&quot;,&quot;_missing_&quot;,&quot;text6&quot;,&quot;text7&quot;,\r\n&quot;text8&quot;,&quot;_missing_&quot;,&quot;text9&quot;,&quot;text10&quot;,&quot;text11&quot;,\r\n)\r\n\r\n \r\n\r\nchardata01 &lt;- chardata %&gt;%\r\n  mutate(across(where(is.character), ~ifelse(tolower(.) == &quot;_missing_&quot;, &quot;&quot;, .)))<\/code><\/pre>"},{"label":"R (base)","code":"chardata <- data.frame(\r\n  var1 = c(\"_missing_\", \"text4\", \"text8\"),\r\n  var2 = c(\"text1\", \"text5\", \"_missing_\"),\r\n  var3 = c(\"text2\", \"_missing_\", \"text9\"),\r\n  var4 = c(\"_missing_\", \"text6\", \"text10\"),\r\n  var5 = c(\"text3\", \"text7\", \"text11\")\r\n  , stringsAsFactors = FALSE\r\n)\r\n\r\nchardata01_tmp <- chardata\r\n\r\nchardata01_tmp$~ifelse(tolower(.) <- = \"_missing_\"\r\n\r\nchardata01 <- chardata01_tmp","language":"r","html":"<pre><code class=\"language-r\">chardata &lt;- data.frame(\r\n  var1 = c(&quot;_missing_&quot;, &quot;text4&quot;, &quot;text8&quot;),\r\n  var2 = c(&quot;text1&quot;, &quot;text5&quot;, &quot;_missing_&quot;),\r\n  var3 = c(&quot;text2&quot;, &quot;_missing_&quot;, &quot;text9&quot;),\r\n  var4 = c(&quot;_missing_&quot;, &quot;text6&quot;, &quot;text10&quot;),\r\n  var5 = c(&quot;text3&quot;, &quot;text7&quot;, &quot;text11&quot;)\r\n  , stringsAsFactors = FALSE\r\n)\r\n\r\nchardata01_tmp &lt;- chardata\r\n\r\nchardata01_tmp$~ifelse(tolower(.) &lt;- = &quot;_missing_&quot;\r\n\r\nchardata01 &lt;- chardata01_tmp<\/code><\/pre>"}] || [];

    function populateSelect(selectEl) {
        if (!selectEl) return;
        selectEl.innerHTML = '';
        variants.forEach((v, idx) => {
            const opt = document.createElement('option');
            opt.value = idx;
            opt.textContent = v.label;
            selectEl.appendChild(opt);
        });
        if (selectEl.options.length) {
            selectEl.selectedIndex = 0;
        }
    }

    function renderCode(selectEl, paneEl) {
        if (!selectEl || !paneEl) return;
        const idx = selectEl.value;
        if (idx === undefined || idx === null || variants[idx] === undefined) return;
        const variant = variants[idx];
        const html = variant.html || '';
        const lang = variant.language || 'text';
        const langClass = (lang === 'sas') ? 'sas-mini' : lang;

        // Prefer provided HTML (keeps colors); otherwise wrap plaintext.
        if (html.trim().length) {
            paneEl.innerHTML = html;
        } else {
            paneEl.innerHTML = '<pre><code class="language-' + langClass + '"></code></pre>';
            const codeEl = paneEl.querySelector('code');
            codeEl.textContent = variant.code || '';
        }
        // SAS blocks go through the shared mini-highlighter; others through highlight.js.
        if (window.SasMiniHighlight) {
            window.SasMiniHighlight.applyAll(paneEl);
        }
        if (window.hljs) {
            paneEl.querySelectorAll('pre code:not(.language-sas-mini)').forEach(block => hljs.highlightElement(block));
        }
    }

    function sanitizeCopiedText(text) {
        if (!text) return '';
        return text
            .replace(/[\u00A0\u2000-\u200B\u202F\u205F\u3000\uFEFF]/g, ' ')
            .replace(/[\u200B-\u200D\u2060]/g, '');
    }

    function initCompareModal() {
        const leftSelect = document.getElementById('leftSelect');
        const rightSelect = document.getElementById('rightSelect');
        const leftPane = document.getElementById('leftPane');
        const rightPane = document.getElementById('rightPane');
        const swapBtn = document.getElementById('swapBtn');
        if (!leftSelect || !rightSelect || !leftPane || !rightPane || !swapBtn) return;
        if (!variants.length) return;

        populateSelect(leftSelect);
        populateSelect(rightSelect);

        const tidyverseIdx = variants.findIndex(v => (v.label || '').toLowerCase().includes('r (tidyverse)'));
        const baseIdx = variants.findIndex(v => (v.label || '').toLowerCase().includes('r (base)'));
        const defaultLeft = tidyverseIdx >= 0 ? tidyverseIdx : 0;
        const defaultRight = baseIdx >= 0 ? baseIdx : (variants.length > 1 ? 1 : 0);

        leftSelect.value = defaultLeft;
        rightSelect.value = defaultRight;
        renderCode(leftSelect, leftPane);
        renderCode(rightSelect, rightPane);
        leftSelect.onchange = () => renderCode(leftSelect, leftPane);
        rightSelect.onchange = () => renderCode(rightSelect, rightPane);
        swapBtn.onclick = () => {
            const tmp = leftSelect.value;
            leftSelect.value = rightSelect.value;
            rightSelect.value = tmp;
            renderCode(leftSelect, leftPane);
            renderCode(rightSelect, rightPane);
        };

        // Copy buttons
        document.querySelectorAll('.copy-btn').forEach(btn => {
            btn.onclick = () => {
                const targetId = btn.getAttribute('data-target-pane');
                const pane = document.getElementById(targetId);
                if (!pane) return;
                const text = sanitizeCopiedText(pane.innerText || '');
                if (navigator.clipboard && navigator.clipboard.writeText) {
                    navigator.clipboard.writeText(text);
                } else {
                    const ta = document.createElement('textarea');
                    ta.value = text;
                    document.body.appendChild(ta);
                    ta.select();
                    document.execCommand('copy');
                    document.body.removeChild(ta);
                }
            };
        });
    }

    // Toggle indicators and header click
    document.addEventListener('DOMContentLoaded', () => {
        // Apply the shared SAS mini-highlighter to every language-sas-mini block on the page.
        if (window.SasMiniHighlight) {
            window.SasMiniHighlight.applyAll();
        }

        document.querySelectorAll('.accordion-header').forEach(header => {
            header.addEventListener('click', function(e) {
                if (e.target && e.target.closest('.copy-code-btn')) {
                    return;
                }
                const targetId = this.getAttribute('data-target').replace('#','');
                const el = document.getElementById(targetId);
                if (el) {
                    if (el.classList.contains('show')) {
                        $(el).collapse('hide');
                    } else {
                        $(el).collapse('show');
                    }
                }
            });
        });

        // Copy buttons on lesson display cards
        document.querySelectorAll('.copy-code-btn').forEach(btn => {
            btn.addEventListener('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                const targetId = btn.getAttribute('data-target-code');
                const block = document.getElementById(targetId);
                if (!block) return;
                const text = sanitizeCopiedText(block.innerText || '');
                if (navigator.clipboard && navigator.clipboard.writeText) {
                    navigator.clipboard.writeText(text);
                } else {
                    const ta = document.createElement('textarea');
                    ta.value = text;
                    document.body.appendChild(ta);
                    ta.select();
                    document.execCommand('copy');
                    document.body.removeChild(ta);
                }
            });
        });

        $('#codeAccordion').on('shown.bs.collapse hidden.bs.collapse', function (e) {
            const targetId = e.target.id;
            const indicator = document.querySelector('.toggle-indicator[data-target="' + targetId + '"]');
            const headerEl = document.querySelector('.accordion-header[data-target="#' + targetId + '"]');
            if (indicator) {
                indicator.textContent = e.type === 'shown' ? '-' : '+';
            }
            if (headerEl) {
                headerEl.setAttribute('aria-expanded', e.type === 'shown' ? 'true' : 'false');
            }
        });

        // Initialize compare modal (admin only; modal exists only then)
        if (document.getElementById('compareModal')) {
            initCompareModal(); // populate immediately
            $('#compareModal').on('shown.bs.modal', function () {
                initCompareModal();
            });
        }

        const toggleAllBtn = document.getElementById('toggleAllBtn');
        if (toggleAllBtn) {
            const panels = document.querySelectorAll('#codeAccordion .collapse');
            panels.forEach(panel => {
                panel.classList.add('show');
            });
            toggleAllBtn.addEventListener('click', function() {
                if (!panels.length) return;
                const state = toggleAllBtn.getAttribute('data-state') || 'show';
                const showAll = state === 'show';
                panels.forEach(panel => {
                    if (showAll) {
                        panel.classList.add('show');
                    } else {
                        panel.classList.remove('show');
                    }
                });
                toggleAllBtn.textContent = showAll ? 'Collapse all' : 'Show all';
                toggleAllBtn.setAttribute('data-state', showAll ? 'collapse' : 'show');
            });
        }
    });
    </script>

<script>
    $(document).ready(function() {
        $("img").addClass("img-fluid").css({
            "max-width": "100%",
            "height": "auto"
        });
    });
</script>
<div class='container-fluid page-footer-container p-0 m-0' id='pagefooter' style="position: fixed; bottom: 0; width: 100%;">
    <!-- Footer -->
    <footer class="text-center text-lg-start bg-light text-muted">

        <!-- Section: Links -->
        
        <!-- Copyright -->
        <div class="text-center p-2" style="background-color: rgba(0, 0, 0, 0.05);">
            &copy; 2014&ndash;2026 Copyright:
            <a class="text-reset fw-bold" href="https://mycsg.in">www.mycsg.in</a>
        </div>
        <!-- Copyright -->
        
    </footer>
    <!-- Footer -->
</div>
