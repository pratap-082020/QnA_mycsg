function resizeIframe(obj) {
  obj.style.height = obj.contentWindow.document.body.scrollHeight + 'px';
}

function copyLessonCode(button) {
  const targetId = button.getAttribute('data-copy-target');
  if (!targetId) return;

  const textarea = document.getElementById(targetId);
  if (!textarea) return;

  const text = textarea.value;
  const originalLabel = button.textContent;

  const markCopied = () => {
    button.textContent = 'Copied';
    button.classList.add('is-copied');
    window.setTimeout(() => {
      button.textContent = originalLabel;
      button.classList.remove('is-copied');
    }, 1400);
  };

  if (navigator.clipboard && navigator.clipboard.writeText) {
    navigator.clipboard.writeText(text).then(markCopied).catch(() => {
      textarea.focus();
      textarea.select();
      document.execCommand('copy');
      textarea.setSelectionRange(0, 0);
      markCopied();
    });
    return;
  }

  textarea.focus();
  textarea.select();
  document.execCommand('copy');
  textarea.setSelectionRange(0, 0);
  markCopied();
}

function escapeLessonCodeHtml(text) {
  return text
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;');
}

function highlightSasCode(source) {
  const placeholders = [];
  const keep = (html) => `@@LESSON_TOKEN_${placeholders.push(html) - 1}@@`;
  const keywordPattern = /\b(data|set|merge|update|modify|proc|run|quit|by|var|class|tables|table|where|if|then|else|do|end|to|until|while|select|when|otherwise|output|keep|drop|rename|length|label|format|informat|retain|array|attrib|infile|input|file|cards|cards4|datalines|datalines4|libname|options|ods|title|footnote|create|insert|delete|from|group|order|having|sum|mean|min|max|n|nmiss|distinct|as|into|on|and|or|not|in|is|like|desc|descending)\b/gi;

  let html = escapeLessonCodeHtml(source.replace(/\r\n?/g, '\n'));

  html = html.replace(/\/\*[\s\S]*?\*\//g, (match) => keep(`<span class="sas-comment">${match}</span>`));
  html = html.replace(/^\s*\*[^;\n]*;/gm, (match) => keep(`<span class="sas-comment">${match}</span>`));
  html = html.replace(/"[^"\n]*"|'[^'\n]*'/g, (match) => keep(`<span class="sas-string">${match}</span>`));
  html = html.replace(/(%[a-z_][a-z0-9_]*)/gi, (match) => keep(`<span class="sas-macro">${match}</span>`));
  html = html.replace(/&amp;([a-z_][a-z0-9_]*)/gi, (_, name) => keep(`<span class="sas-macro-var">&amp;${name}</span>`));
  html = html.replace(keywordPattern, '<span class="sas-keyword">$1</span>');

  return html.replace(/@@LESSON_TOKEN_(\d+)@@/g, (_, index) => placeholders[Number(index)]);
}

function ensureLessonCodeButtons() {
  const codeAreas = document.querySelectorAll('textarea.codetextarea');
  let autoId = 1;

  codeAreas.forEach((textarea) => {
    if (!textarea.id) {
      textarea.id = `lessonCodeAuto${autoId}`;
      autoId += 1;
    }

    let wrapper = textarea.parentElement;
    if (!wrapper || !wrapper.classList.contains('lesson-code-wrap')) {
      wrapper = document.createElement('div');
      wrapper.className = 'lesson-code-wrap';
      textarea.parentNode.insertBefore(wrapper, textarea);
      wrapper.appendChild(textarea);
    }

    let copyButton = wrapper.querySelector('.btn-copy');
    if (!copyButton) {
      const nextSibling = wrapper.nextElementSibling;
      if (nextSibling && nextSibling.classList && nextSibling.classList.contains('btn-copy')) {
        copyButton = nextSibling;
        wrapper.appendChild(copyButton);
      } else {
        copyButton = document.createElement('button');
        copyButton.type = 'button';
        copyButton.className = 'btn-copy lesson-code-copy';
        copyButton.textContent = 'Copy Code';
        wrapper.appendChild(copyButton);
      }
    }

    copyButton.setAttribute('data-copy-target', textarea.id);
    copyButton.setAttribute('onclick', 'copyLessonCode(this)');
    copyButton.classList.add('lesson-code-copy');

    let display = wrapper.querySelector('.lesson-code-display');
    if (!display) {
      display = document.createElement('pre');
      display.className = 'lesson-code-display';
      display.setAttribute('aria-hidden', 'true');
      const code = document.createElement('code');
      code.className = 'lesson-code-syntax';
      display.appendChild(code);
      wrapper.insertBefore(display, copyButton);
    }

    const codeNode = display.querySelector('.lesson-code-syntax');
    codeNode.innerHTML = highlightSasCode(textarea.value);
  });
}

document.addEventListener('DOMContentLoaded', ensureLessonCodeButtons);
