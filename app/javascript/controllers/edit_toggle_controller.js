import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // 複数行・複数ボタン対応（既存ページとも互換）
  static targets = ["field", "submit", "tags"]

  toggle(e) {
    const on = e.target.checked

    // 入力欄: すべて一括で有効/無効
    this.fieldTargets.forEach(el => el.toggleAttribute("disabled", !on))

    // 送信/操作ボタン群: すべて一括で表示/非表示（invisibleでレイアウト崩れ防止）
    if (this.hasSubmitTarget) {
      this.submitTargets.forEach(el => el.classList.toggle("invisible", !on))
    }

    // 追加オプション領域（例: まとめ操作）: 複数対応
    if (this.hasTagsTarget) {
      this.tagsTargets.forEach(el => el.classList.toggle("invisible", !on))
    }
  }
  // ユーザー詳細用
  enable() {
  this.fieldTargets.forEach(el => el.toggleAttribute("disabled", false))
  if (this.hasSubmitTarget) {
    this.submitTargets.forEach(el => el.classList.remove("invisible"))
    }
  }
    disable() {
      this.fieldTargets.forEach(el => el.toggleAttribute("disabled", true))
      if (this.hasSubmitTarget) {
        this.submitTargets.forEach(el => el.classList.add("invisible"))
    }
  }
}
