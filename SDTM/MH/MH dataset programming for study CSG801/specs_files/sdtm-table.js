(function(window, $) {
  function calcNavOffset() {
    var nav = $('.navbar, .navbar-fixed-top, .navbar-expand-lg').first();
    return nav.length ? nav.outerHeight() : 0;
  }

  function findInputForCol(col) {
    var sel = '.sdtm-filter-input[data-col="' + col + '"]';
    return document.querySelector('.fixedHeader-floating ' + sel) ||
           document.querySelector('.dtfh-floating ' + sel) ||
           document.querySelector(sel);
  }

  function copyValuesToClipboard(text, onDone) {
    var fallback = function() {
      var ta = document.createElement('textarea');
      ta.value = text;
      document.body.appendChild(ta);
      ta.select();
      try { document.execCommand('copy'); onDone(); }
      catch (e) { alert('Copy failed'); }
      document.body.removeChild(ta);
    };
    if (navigator.clipboard && navigator.clipboard.writeText) {
      navigator.clipboard.writeText(text).then(onDone).catch(fallback);
    } else {
      fallback();
    }
  }

  function normalizeCellText(text) {
    var value = (text || '').replace(/\s+/g, ' ').trim();
    if (!value) {
      return '';
    }
    if (/[<>]/.test(value) || /(?:href|class|target|rel)=/i.test(value)) {
      var tmp = document.createElement('div');
      tmp.innerHTML = value;
      var decoded = ((tmp.textContent || tmp.innerText || '') + '').replace(/\s+/g, ' ').trim();
      if (decoded) {
        value = decoded;
      }
    }
    return value;
  }

  function getCellFilterValue(td) {
    if (!td) {
      return '';
    }

    var explicit = normalizeCellText(td.getAttribute('data-filter-value') || '');
    if (explicit) {
      return explicit;
    }

    var controls = Array.from(td.querySelectorAll('a, button, .btn'))
      .map(function(el) { return normalizeCellText(el.textContent || ''); })
      .filter(Boolean);
    if (controls.length) {
      return controls.join(' | ');
    }

    return normalizeCellText(td.textContent || '');
  }

  function initSdtmTable(opts) {
    var tableEl = $(opts.tableSelector || '#sashtmltable');
    if (!tableEl.length) return;

    var columnWidths = opts.columnWidths || {};
    tableEl.addClass('table table-sm table-striped sdtm-table');
    tableEl.find('thead tr:first-child th').each(function() {
        var dataName = ($(this).data('name') || '').toString().toLowerCase();
        if (columnWidths.hasOwnProperty(dataName)) {
            $(this).css('width', columnWidths[dataName]);
        }
    });

    var navOffset = calcNavOffset();
    var fixedHeaderOpt = (opts.enableFixedHeader === false)
      ? false
      : { header: true, footer: false, headerOffset: navOffset };

    var domLayout = opts.domLayout;
    if (!domLayout) {
        if (opts.showTopControls) {
            domLayout = '<"sdtm-top d-flex justify-content-between align-items-center"lip>t<"sdtm-bottom d-flex justify-content-between align-items-center"ip>';
        } else {
            domLayout = 't<"sdtm-bottom d-flex justify-content-between align-items-center"ip>';
        }
    }

    var lengthMenu = opts.lengthMenu;
    if (!lengthMenu) {
        lengthMenu = [[25, 50, 100, 200, 300, 500], [25, 50, 100, 200, 300, 500]];
    }

    var table = tableEl.DataTable({
        pageLength: opts.pageLength || 100,
        fixedHeader: fixedHeaderOpt,
        ordering: true,
        lengthChange: opts.lengthChange !== false,
        lengthMenu: lengthMenu,
        dom: domLayout
    });

    var totalCols = table.columns().count();
    var columnFilters = new Array(totalCols).fill('');
    var filterInputs = [];
    var multiState = new Array(totalCols).fill(null).map(function() { return { mode: '__all', values: new Set() }; });
    var openDropdown = null;
    var openDropdownCol = null;
    var rowTextMatrix = [];
    var selectedCols = new Set();
    var persistKey = opts.persistKey || null;
    var persistLoad = function() {
        if (!persistKey || !window.localStorage) return;
        try {
            var raw = localStorage.getItem(persistKey);
            if (!raw) return;
            var data = JSON.parse(raw);
            if (Array.isArray(data.columnFilters)) {
                columnFilters = data.columnFilters.map(function(v) { return (v || '').toString(); });
            }
            if (Array.isArray(data.multiState)) {
                multiState = data.multiState.map(function(s) {
                    var mode = (s && s.mode) ? s.mode : '__all';
                    var vals = Array.isArray(s && s.values) ? s.values : [];
                    return { mode: mode, values: new Set(vals) };
                });
            }
            if (typeof data.search === 'string') {
                table.search(data.search);
            }
            if (data.pageLength && typeof data.pageLength === 'number') {
                table.page.len(data.pageLength);
            }
        } catch (e) {}
    };

    var persistSave = function() {
        if (!persistKey || !window.localStorage) return;
        var data = {
            columnFilters: columnFilters.map(function(v) { return v || ''; }),
            multiState: multiState.map(function(s) {
                return { mode: s.mode || '__all', values: Array.from(s.values || []) };
            }),
            search: table.search() || '',
            pageLength: table.page.len()
        };
        try { localStorage.setItem(persistKey, JSON.stringify(data)); } catch (e) {}
    };

    var rebuildMatrix = function() {
        rowTextMatrix = [];
        table.rows().every(function() {
            var idx = this.index();
            var rowNode = this.node();
            var cells = rowNode ? rowNode.querySelectorAll('td') : [];
            rowTextMatrix[idx] = Array.from(cells).map(function(td) {
                return getCellFilterValue(td);
            });
        });
    };
    rebuildMatrix();

    var normalizeVal = function(val) { return (val || '').trim(); };

    var rowPasses = function(rowVals, skipCol) {
        for (var c = 0; c < totalCols; c++) {
            if (c === skipCol) { continue; }
            var cell = normalizeVal(rowVals[c] || '');
            var textVal = columnFilters[c];
            if (textVal && cell.toLowerCase().indexOf(textVal) === -1) { return false; }
            var state = multiState[c];
            if (!state) { continue; }
            if (state.mode === '__blank' && cell !== '') { return false; }
            if (state.mode === '__nonblank' && cell === '') { return false; }
            if (state.values && state.values.size > 0 && !state.values.has(cell)) { return false; }
        }
        return true;
    };

    var filterFn = function(settings, searchData, dataIndex) {
        if (settings.nTable !== tableEl.get(0)) { return true; }
        var rowVals = rowTextMatrix[dataIndex] || searchData || [];
        return rowPasses(rowVals, null);
    };
    $.fn.dataTable.ext.search.push(filterFn);

    var updateButtonLabel = function(col) {
        var state = multiState[col];
        var btn = document.querySelector('.sdtm-filter-btn[data-col="' + col + '"]');
        if (!btn) { return; }
        if (state.mode === '__blank') {
            btn.textContent = 'Blanks';
        } else if (state.mode === '__nonblank') {
            btn.textContent = 'Non-blank';
        } else if (state.values && state.values.size > 0) {
            btn.textContent = state.values.size + ' selected';
        } else {
            btn.textContent = 'All values';
        }
    };

    var closeDropdown = function() {
        if (openDropdown && openDropdown.parentNode) {
            openDropdown.parentNode.removeChild(openDropdown);
        }
        openDropdown = null;
        openDropdownCol = null;
    };

    $(document).on('click', function() { closeDropdown(); });

    var getOptions = function(col) {
        var values = new Set();
        table.rows({ search: 'applied' }).indexes().each(function(idx) {
            var rowVals = rowTextMatrix[idx] || [];
            values.add(normalizeVal(rowVals[col] || ''));
        });
        return Array.from(values).sort(function(a, b) { return a.localeCompare(b); }).slice(0, 500);
    };

    var toggleDropdown = function(col, anchor) {
        if (openDropdown && openDropdownCol === col) {
            closeDropdown();
            return;
        }
        closeDropdown();
        var dropdown = document.createElement('div');
        dropdown.className = 'sdtm-filter-dropdown';
        dropdown.addEventListener('click', function(e) { e.stopPropagation(); });

        var state = multiState[col];
        var optionsWrap = document.createElement('div');
        optionsWrap.className = 'sdtm-filter-options';

        var makeChk = function(label, value, checked) {
            var wrap = document.createElement('label');
            wrap.className = 'sdtm-filter-option';
            var cb = document.createElement('input');
            cb.type = 'checkbox';
            cb.value = value;
            cb.checked = checked;
            wrap.appendChild(cb);
            wrap.appendChild(document.createTextNode(' ' + label));
            return wrap;
        };

        optionsWrap.appendChild(makeChk('All values', '__all', state.mode === '__all' && (!state.values || state.values.size === 0)));
        optionsWrap.appendChild(makeChk('Non-blank', '__nonblank', state.mode === '__nonblank'));

        getOptions(col).forEach(function(val) {
            var label = val === '' ? '(blank)' : val;
            var checked = state.mode === '__all' && state.values && state.values.has(val);
            optionsWrap.appendChild(makeChk(label, val, checked));
        });
        dropdown.appendChild(optionsWrap);
        if (!opts.disableOptionScroll) {
            optionsWrap.style.maxHeight = '240px';
            optionsWrap.style.overflowY = 'auto';
        }

        var applyBtn = document.createElement('button');
        applyBtn.type = 'button';
        applyBtn.className = 'btn btn-primary btn-sm w-100';
        applyBtn.style.marginTop = '6px';
        applyBtn.textContent = 'Apply';
        applyBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            var checks = dropdown.querySelectorAll('input[type="checkbox"]');
            var selected = [];
            var chooseAll = false;
            var chooseNonBlank = false;

            checks.forEach(function(cb) {
                if (!cb.checked) { return; }
                if (cb.value === '__all') { chooseAll = true; }
                else if (cb.value === '__nonblank') { chooseNonBlank = true; }
                else { selected.push(cb.value); }
            });

            if (chooseNonBlank) {
                multiState[col] = { mode: '__nonblank', values: new Set() };
            } else if (chooseAll && selected.length === 0) {
                multiState[col] = { mode: '__all', values: new Set() };
            } else if (selected.length > 0) {
                multiState[col] = { mode: '__all', values: new Set(selected) };
            } else {
                multiState[col] = { mode: '__all', values: new Set() };
            }
            updateButtonLabel(col);
            table.draw(false);
            persistSave();
            closeDropdown();
        });
        dropdown.appendChild(applyBtn);

        anchor.parentNode.appendChild(dropdown);
        openDropdown = dropdown;
        openDropdownCol = col;
    };

    var copyColumn = function(col) {
        if (!opts.enableCopySingle) return;
        var data = table.column(col, { search: 'applied' }).data().toArray().map(function(v) {
            return (v == null ? '' : v.toString().trim());
        });
        var text = data.join('\n');
        copyValuesToClipboard(text, function() { alert('Copied ' + data.length + ' values'); });
    };

    var copySelectedColumns = function() {
        if (!opts.enableCopyMulti) return;
        if (selectedCols.size === 0) {
            alert('Select columns using the small checkbox in each header.');
            return;
        }
        var cols = Array.from(selectedCols).sort(function(a, b) { return a - b; });
        var getHeadingText = function(colIdx) {
            var th = tableEl.find('thead tr:first-child th').eq(colIdx).clone();
            th.find('button, input').remove();
            return th.text().trim();
        };
        var headerLine = cols.map(getHeadingText).join('\t');
        var lines = [headerLine];
        table.rows({ search: 'applied' }).indexes().each(function(idx) {
            var rowVals = rowTextMatrix[idx] || [];
            lines.push(cols.map(function(c) { return rowVals[c] || ''; }).join('\t'));
        });
        var text = lines.join('\n');
        copyValuesToClipboard(text, function() {
            alert('Copied ' + (lines.length - 1) + ' rows across ' + cols.length + ' columns');
        });
    };

    var buildFilterRow = function() {
        var filterRow = $('<tr class="sdtm-filter-row"></tr>');
        tableEl.find('thead').append(filterRow);
        for (let col = 0; col < totalCols; col++) {
            var th = $('<th></th>');
            var headingCell = tableEl.find('thead tr:first-child th').eq(col);
            if (opts.enableCopySingle) {
                var copyBtn = $('<button type="button" class="sdtm-copy-col" title="Copy visible column">Copy</button>');
                copyBtn.on('click', function(e) {
                    e.stopPropagation();
                    copyColumn(col);
                });
                headingCell.append(copyBtn);
            }
            if (opts.enableCopyMulti) {
                var sel = $('<input type="checkbox" class="sdtm-copy-toggle" data-col="' + col + '" title="Add to multi-column copy">');
                sel.on('click', function(e) {
                    e.stopPropagation();
                    if (this.checked) { selectedCols.add(col); }
                    else { selectedCols.delete(col); }
                });
                headingCell.append(sel);
            }

            var btn = $('<button type="button" class="btn btn-light btn-sm sdtm-filter-btn" data-col="' + col + '">All values</button>');
            btn.on('click', function(e) {
                e.stopPropagation();
                toggleDropdown(col, this);
            });

            var input = $('<input type="text" class="form-control form-control-sm sdtm-filter-input" placeholder="Type to filter" data-col="' + col + '">');
            input.on('input', function() {
                var pos = this.selectionStart;
                columnFilters[col] = this.value.trim().toLowerCase();
                table.draw(false);
                persistSave();
                setTimeout(function() {
                    var target = findInputForCol(col);
                    if (target) {
                        target.focus();
                        if (pos != null && target.setSelectionRange) {
                            target.setSelectionRange(pos, pos);
                        }
                    }
                }, 0);
            });

            filterInputs[col] = input;
            th.append(btn).append(input);
            filterRow.append(th);
            updateButtonLabel(col);
        }
    };

    buildFilterRow();

    if (!opts.disableFilterSticky) {
        tableEl.addClass('sdtm-filter-sticky');
    }

    var updateStickyOffsets = function() {
        if (opts.disableFilterSticky) return;
        var headerRow = tableEl.find('thead tr:first-child');
        var h = headerRow.length ? headerRow.outerHeight() : 34;
        if (tableEl.length) {
            tableEl.get(0).style.setProperty('--sdtm-header-height', h + 'px');
            tableEl.get(0).style.setProperty('--sdtm-nav-height', navOffset + 'px');
        }
    };
    updateStickyOffsets();

    if (opts.quickSearchSelector) {
        $(opts.quickSearchSelector).on('keyup change', function() {
            table.search(this.value).draw(false);
            persistSave();
        });
    }

    if (opts.clearSelector) {
        $(opts.clearSelector).on('click', function() {
            table.search('').draw(false);
            if (opts.quickSearchSelector) {
                $(opts.quickSearchSelector).val('');
            }
            for (var c = 0; c < totalCols; c++) {
                columnFilters[c] = '';
                multiState[c] = { mode: '__all', values: new Set() };
                updateButtonLabel(c);
                if (filterInputs[c]) { filterInputs[c].val(''); }
            }
            table.draw(false);
            persistSave();
        });
    }

    if (opts.lengthChange !== false) {
        table.on('length.dt', function() {
            persistSave();
        });
    }

    if (opts.enableCopyMulti && opts.multiCopyButtonSelector) {
        $(opts.multiCopyButtonSelector).on('click', function() {
            copySelectedColumns();
        });
    }

    table.on('draw.dt', function() {
        rebuildMatrix();
        updateStickyOffsets();
        if (table.fixedHeader) {
            table.fixedHeader.adjust();
        }
    });

    persistLoad();
    for (var c = 0; c < totalCols; c++) {
        if (filterInputs[c]) { filterInputs[c].val(columnFilters[c]); }
        updateButtonLabel(c);
    }
    if (opts.quickSearchSelector) {
        $(opts.quickSearchSelector).val(table.search());
    }
    table.draw(false);

    if (table.fixedHeader) {
        table.fixedHeader.adjust();
        $(window).on('resize', function() {
            var newOffset = calcNavOffset();
            table.fixedHeader.headerOffset(newOffset);
            table.fixedHeader.adjust();
            updateStickyOffsets();
        });
    }
  }

  window.SDTMTable = { init: initSdtmTable };
})(window, jQuery);
