{ /* Function to resize iframe present in content page */ }

function resizeIframe(obj) {
    obj.style.height = math.max(obj.contentWindow.document.body.scrollHeight, 540)
}

/* ===========================================================
   Deep-link to tabs + optional iframe loader (Bootstrap 4)
   Works across tasks.php, adam.php, sdtm.php, etc.
   =========================================================== */

window.MyCSG = window.MyCSG || {};

(function() {
    // Helper: read URL params and hash
    function getParams() {
        try {
            return new URLSearchParams(window.location.search);
        } catch (e) {
            return new URLSearchParams('');
        }
    }

    function getHashKey() {
        // expect #nav-KEY
        var h = (window.location.hash || '').trim();
        return h.startsWith('#nav-') ? h.replace('#nav-', '').toUpperCase() : '';
    }

    // Find all tab nav containers on the page
    function findAllTabNavs() {
        // Any .nav-tabs that contains <a data-toggle="tab">
        return Array.prototype.slice.call(
            document.querySelectorAll('.nav.nav-tabs, .nav-tabs')
        ).filter(function(el) {
            return el.querySelector('a[data-toggle="tab"]');
        });
    }

    // Given a tab container and a KEY (e.g., "SASPROG"), find the anchor
    function findTabLinkByKey(tabContainer, key) {
        var sel = 'a.nav-link[href="#nav-' + key + '"]';
        return tabContainer.querySelector(sel);
    }

    // Update iframe src inside a given pane by KEY, if present
    function updateIframeForKey(key, opts) {
        var paneId = 'nav-' + key;
        var pane = document.getElementById(paneId);
        if (!pane) return;

        var iframe = pane.querySelector('iframe');
        if (!iframe) return; // Nothing to do for non-iframe tabs

        // Priority for lesson id:
        // 1) data-lesson on pane or nav container
        // 2) lesson=... from URL
        // 3) opts.lesson override (rare)
        var params = getParams();
        var lessonFromUrl = params.get('lesson') || '';
        var lesson =
            (pane.getAttribute('data-lesson') || '') ||
            (opts && opts.lesson) ||
            lessonFromUrl;

        // Build src
        // If the pane has data-src-template, use it.
        // Use {KEY} and {LESSON} placeholders.
        // Else fall back to your default load_lesson_info.php pattern.
        var tpl = pane.getAttribute('data-src-template');
        var src = '';
        if (tpl && (lesson || tpl.indexOf('{LESSON}') === -1)) {
            src = tpl.replace(/\{KEY\}/g, key).replace(/\{LESSON\}/g, lesson);
        } else {
            // Default (safe even if lesson is empty)
            var base = './load_lesson_info.php';
            var q = '?type=' + encodeURIComponent(key);
            if (lesson) q += '&lesson=' + encodeURIComponent(lesson);
            src = base + q;
        }

        // Only set if empty or different (avoids reload flicker)
        if (!iframe.getAttribute('src') || iframe.getAttribute('src') !== src) {
            iframe.setAttribute('src', src);
        }
    }

    // Activate a tab (Bootstrap 4) and optionally update the iframe
    function showTab($anchor, key, opts) {
        if (!$anchor || !$anchor.length) return;

        // Activate via Bootstrap JS
        $anchor.tab('show');

        // Update hash (don’t change query params)
        try {
            var newUrl = window.location.pathname + window.location.search + '#nav-' + key;
            window.history.replaceState(null, '', newUrl);
        } catch (e) {}

        // Update iframe inside this pane (if any)
        updateIframeForKey(key, opts);
    }

    // Public init: call once per page (you can place in header.php)
    // options:
    //   defaultKey: fallback key if none found (string) e.g., "SASPROG"
    //   lesson: override lesson id (optional; usually auto from ?lesson=...)
    //   selector: limit to a specific nav container (optional)
    window.MyCSG.initTabDeepLinking = function(options) {
        options = options || {};
        var defaultKey = (options.defaultKey || '').toUpperCase();
        var containerSelector = options.selector || null;

        var tabNavs = containerSelector ?
            Array.prototype.slice.call(document.querySelectorAll(containerSelector)) :
            findAllTabNavs();

        if (!tabNavs.length) return;

        var params = getParams();
        var typeParam = (params.get('type') || '').toUpperCase();
        var hashKey = getHashKey();

        tabNavs.forEach(function(tabNav) {
            var $tabNav = window.jQuery ? window.jQuery(tabNav) : null;
            if (!$tabNav) return; // requires jQuery + Bootstrap tab plugin already loaded

            // Determine initial key for THIS tab group
            var initialKey = typeParam || hashKey || '';

            // If none, try current active tab in this group
            if (!initialKey) {
                var active = tabNav.querySelector('a.nav-link.active');
                if (active) {
                    var href = active.getAttribute('href') || '';
                    if (href.startsWith('#nav-')) initialKey = href.replace('#nav-', '').toUpperCase();
                }
            }

            // If still none, use provided defaultKey (if given)
            if (!initialKey && defaultKey) {
                initialKey = defaultKey.toUpperCase();
            }

            // If we have a key and a matching link, show it
            if (initialKey) {
                var anchor = findTabLinkByKey(tabNav, initialKey);
                if (anchor) {
                    showTab(window.jQuery(anchor), initialKey, options);
                }
            }

            // When user switches tabs, keep URL hash synced and set iframe
            $tabNav.find('a[data-toggle="tab"]').on('shown.bs.tab', function(e) {
                var href = e.target.getAttribute('href') || '';
                if (href.startsWith('#nav-')) {
                    var key = href.replace('#nav-', '').toUpperCase();
                    // Update hash + iframe
                    try {
                        var newUrl = window.location.pathname + window.location.search + '#nav-' + key;
                        window.history.replaceState(null, '', newUrl);
                    } catch (err) {}
                    updateIframeForKey(key, options);
                }
            });
        });
    };
})();