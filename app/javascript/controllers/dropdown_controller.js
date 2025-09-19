import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  toggle(event) {
    event.preventDefault()
    const hiddenNow = this.menuTarget.classList.toggle("hidden") // true = 隠れた
    const expanded = !hiddenNow
    // ボタンの aria-expanded を同期
    try {
      const btn = event.currentTarget
      if (btn?.setAttribute) btn.setAttribute("aria-expanded", String(expanded))
    } catch (_) {}
  }

  outside(event) {
    if (!this.element.contains(event.target)) this.close()
  }

  closeOnEscape(event) {
    if (event.key === "Escape") this.close()
  }

  close() {
    this.menuTarget.classList.add("hidden")
    const btn = this.element.querySelector("button[aria-haspopup='menu']")
    if (btn) btn.setAttribute("aria-expanded", "false")
  }
}
