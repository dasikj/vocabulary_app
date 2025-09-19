

import { Controller } from "@hotwired/stimulus"

// data-controller="search-toggle"
// data-search-toggle-target="tab panel"
// data-search-toggle-default-value="sentence" | "vocabulary"
export default class extends Controller {
  static targets = ["tab", "panel"]
  static values = { default: { type: String, default: "sentence" } }

  connect() {
    const params = new URLSearchParams(window.location.search)
    const urlTab = params.get("tab")
    const initial = urlTab || this.defaultValue
    this.show(initial)
  }

  select(event) {
    const kind = event.currentTarget.dataset.kind
    this.show(kind)
  }

  show(kind) {
    // tabs
    this.tabTargets.forEach(el => {
      const active = el.dataset.kind === kind
      el.classList.toggle("bg-gray-100", active)
      el.classList.toggle("text-gray-900", active)
      el.classList.toggle("text-gray-600", !active)
    })
    // panels
    this.panelTargets.forEach(el => {
      el.classList.toggle("hidden", el.dataset.kind !== kind)
    })
  }
}