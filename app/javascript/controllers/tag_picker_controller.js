import { Controller } from "@hotwired/stimulus"

// data-controller="tag-picker"
// - Keeps checked tags at the top
// - Filters labels by partial match (case-insensitive)
export default class extends Controller {
  static targets = ["search", "list"]

  connect() {
    // Initial sort: put checked tags first when the dialog opens
    this.sortSelectedOnTop()
  }

  filter() {
    if (!this.hasListTarget) return

    const keyword = ((this.hasSearchTarget ? this.searchTarget.value : "") || "")
      .toLowerCase()
      .trim()

    const labels = this.listTarget.querySelectorAll("label")

    if (!keyword) {
      labels.forEach(l => (l.style.display = ""))
      // クリア時も選択済みを上へ
      this.sortSelectedOnTop()
      return
    }

    labels.forEach(label => {
      const text = (label.innerText || "").toLowerCase()
      label.style.display = text.includes(keyword) ? "" : "none"
    })

    // フィルタ後も選択済みを先頭に維持
    this.sortSelectedOnTop()
  }

  sortSelectedOnTop() {
    if (!this.hasListTarget) return

    // 再取得（チェック状態は都度変わるため）
    const grid = this.listTarget.querySelector(".grid") || this.listTarget
    const labels = Array.from(grid.querySelectorAll("label"))

    // 安定ソート：1) checked が先、2) 名前の昇順（日本語考慮）
    labels.sort((a, b) => {
      const aChecked = a.querySelector('input[type="checkbox"]')?.checked ? 0 : 1
      const bChecked = b.querySelector('input[type="checkbox"]')?.checked ? 0 : 1
      if (aChecked !== bChecked) return aChecked - bChecked
      const aText = (a.innerText || "").trim().toLowerCase()
      const bText = (b.innerText || "").trim().toLowerCase()
      return aText.localeCompare(bText, "ja")
    })

    const frag = document.createDocumentFragment()
    labels.forEach(l => frag.appendChild(l))
    grid.appendChild(frag)
  }

    // 検索クリア
    clear() {
    if (this.hasSearchTarget) {
      this.searchTarget.value = ""
      this.filter()
      try { this.searchTarget.focus() } catch(_) {}
    }
  }
}
