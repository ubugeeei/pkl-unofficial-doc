const button = document.querySelector(".menu-button");
const shell = document.querySelector("#site-shell");
const search = document.querySelector(".search-box input");
const links = Array.from(document.querySelectorAll(".nav-link"));
const copyButtons = Array.from(document.querySelectorAll(".copy-code-button"));

const copyTextWithSelection = (text) => {
  const textarea = document.createElement("textarea");
  textarea.value = text;
  textarea.setAttribute("readonly", "");
  textarea.style.position = "fixed";
  textarea.style.top = "0";
  textarea.style.left = "0";
  textarea.style.width = "1px";
  textarea.style.height = "1px";
  textarea.style.opacity = "0";
  document.body.appendChild(textarea);
  textarea.focus();
  textarea.select();
  textarea.setSelectionRange(0, textarea.value.length);
  try {
    return document.execCommand("copy");
  } finally {
    textarea.remove();
  }
};

const copyText = async (text) => {
  if (copyTextWithSelection(text)) return true;
  try {
    if (navigator.clipboard) {
      await navigator.clipboard.writeText(text);
      return true;
    }
  } catch {}
  return false;
};

const selectCode = (code) => {
  const selection = window.getSelection();
  if (!selection) return false;
  const range = document.createRange();
  range.selectNodeContents(code);
  selection.removeAllRanges();
  selection.addRange(range);
  return true;
};

if (button && shell) {
  button.addEventListener("click", () => {
    const expanded = button.getAttribute("aria-expanded") === "true";
    button.setAttribute("aria-expanded", expanded ? "false" : "true");
    shell.classList.toggle("is-open", !expanded);
  });
}

if (search) {
  search.addEventListener("input", () => {
    const query = search.value.trim().toLowerCase();
    for (const link of links) {
      link.hidden = query.length > 0 && !link.textContent.toLowerCase().includes(query);
    }
  });
}

for (const copyButton of copyButtons) {
  copyButton.addEventListener("click", async () => {
    const block = copyButton.closest(".code-block");
    const code = block ? block.querySelector("pre code") : null;
    if (!code) return;
    const lines = Array.from(code.querySelectorAll(".line"));
    const text = lines.length > 0 ? lines.map((line) => line.textContent).join("\n") : code.textContent.replace(/\n$/, "");
    const previousText = copyButton.textContent;
    const previousState = copyButton.dataset.state || "";
    try {
      const copied = await copyText(text);
      if (!copied) throw new Error("Clipboard unavailable");
      copyButton.textContent = "Copied";
      copyButton.dataset.state = "copied";
    } catch {
      selectCode(code);
      copyButton.textContent = "Selected";
      copyButton.dataset.state = "selected";
    }
    window.setTimeout(() => {
      copyButton.textContent = previousText || "Copy";
      copyButton.dataset.state = previousState;
    }, 1400);
  });
}

for (const group of document.querySelectorAll("[data-tabs]")) {
  const tabButtons = Array.from(group.querySelectorAll('[role="tab"]'));
  const panels = Array.from(group.querySelectorAll('[role="tabpanel"]'));
  const activate = (selected) => {
    for (const tabButton of tabButtons) {
      const active = tabButton === selected;
      tabButton.setAttribute("aria-selected", active ? "true" : "false");
      tabButton.tabIndex = active ? 0 : -1;
    }
    for (const panel of panels) {
      panel.hidden = panel.id !== selected.getAttribute("aria-controls");
    }
  };
  for (const tabButton of tabButtons) {
    tabButton.addEventListener("click", () => activate(tabButton));
    tabButton.addEventListener("keydown", (event) => {
      const current = tabButtons.indexOf(tabButton);
      const next = event.key === "ArrowRight" ? current + 1 : event.key === "ArrowLeft" ? current - 1 : current;
      if (next === current) return;
      event.preventDefault();
      const wrapped = (next + tabButtons.length) % tabButtons.length;
      tabButtons[wrapped].focus();
      activate(tabButtons[wrapped]);
    });
  }
}