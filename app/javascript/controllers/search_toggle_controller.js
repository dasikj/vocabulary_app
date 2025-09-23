

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel"]

  connect() {
    // 常に「文章」から始める（URLや値は使わない）
    this.show("sentence")
  }

  select(event) {
    const kind = event.currentTarget.dataset.kind
    this.show(kind)
  }

  show(kind) {
    // タブの見た目切り替え
    this.tabTargets.forEach(el => {
      const active = el.dataset.kind === kind
      el.classList.toggle("bg-gray-100", active)
      el.classList.toggle("text-gray-900", active)
      el.classList.toggle("text-gray-600", !active)
    })
    // パネルの表示/非表示
    this.panelTargets.forEach(el => {
      el.classList.toggle("hidden", el.dataset.kind !== kind)
    })
  }
}