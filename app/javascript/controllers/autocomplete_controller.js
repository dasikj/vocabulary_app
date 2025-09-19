import { Controller } from "@hotwired/stimulus"

// data-controller="autocomplete"
// data-autocomplete-url-value="/autocomplete/vocabularies"
// data-autocomplete-target="input list"
// <ul data-autocomplete-target="list"></ul>
export default class extends Controller {
  static targets = ["input", "list"]
  static values = { url: String }
  #aborter = null
  #selectedIndex = -1

  connect() {
    this.close()
  }

  async search() {
    const q = (this.inputTarget.value || "").trim()
    if (!this.urlValue) return
    if (this.#aborter) this.#aborter.abort()
    this.#aborter = new AbortController()

    if (q.length === 0) { this.close(); return }
    try {
      const res = await fetch(`${this.urlValue}?term=${encodeURIComponent(q)}`, { signal: this.#aborter.signal })
      if (!res.ok) return
      const items = await res.json()
      this.render(items)
    } catch (_) { /* noop */ }
  }

  render(items) {
    this.listTarget.innerHTML = ""
    if (!items || items.length === 0) { this.close(); return }
    items.forEach(({ id, label }, i) => {
      const li = document.createElement("li")
      li.className = "px-3 py-2 cursor-pointer hover:bg-gray-100"
      li.textContent = label
      li.dataset.index = i
      li.addEventListener("mousedown", (e) => { // mousedownで選択（blur前に拾う）
        e.preventDefault()
        this.choose(label)
      })
      this.listTarget.appendChild(li)
    })
    this.open()
    this.#selectedIndex = -1
  }

  choose(text) {
    this.inputTarget.value = text
    this.close()
    // 変更通知（Ransackのsubmitボタン使うなら不要）
    this.inputTarget.dispatchEvent(new Event("change"))
  }

  keydown(event) {
    if (this.listTarget.classList.contains("hidden")) return
    const items = Array.from(this.listTarget.children)
    if (event.key === "ArrowDown") {
      event.preventDefault()
      this.#selectedIndex = Math.min(items.length - 1, this.#selectedIndex + 1)
      this.highlight(items)
    } else if (event.key === "ArrowUp") {
      event.preventDefault()
      this.#selectedIndex = Math.max(0, this.#selectedIndex - 1)
      this.highlight(items)
    } else if (event.key === "Enter") {
      if (this.#selectedIndex >= 0) {
        event.preventDefault()
        this.choose(items[this.#selectedIndex].textContent)
      }
    } else if (event.key === "Escape") {
      this.close()
    }
  }

  highlight(items) {
    items.forEach((el, i) => el.classList.toggle("bg-gray-100", i === this.#selectedIndex))
    if (this.#selectedIndex >= 0) items[this.#selectedIndex].scrollIntoView({ block: "nearest" })
  }

  open()  { this.listTarget.classList.remove("hidden") }
  close() { this.listTarget.classList.add("hidden"); this.listTarget.innerHTML = "" }
}
