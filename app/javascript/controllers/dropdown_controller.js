import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  // menuのクラスリストをクリックで表示 / 非表示切り替え
  toggle(event) {
    const hiddenNow = this.menuTarget.classList.toggle("hidden") 
  }
  // 要素以外の場所がクリックされた場合、メニューを閉じる
  outside(event) {
    if (!this.element.contains(event.target)) this.close()
  }
  // Escapeを押した場合、メニューを閉じる
  closeOnEscape(event) {
    if (event.key === "Escape") this.close()
  }
  // 閉じた場合、hiddenを付与してメニューを隠す
  close() {
    this.menuTarget.classList.add("hidden")
  }
}
