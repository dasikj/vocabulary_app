import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["field", "submit", "tags"]

  toggle(e) {
    const on = e.target.checked
    this.fieldTargets.forEach(el => el.disabled = !on)

    // invisibleで見えなくする → 枠は縮まない
    if (this.hasSubmitTarget) {
      this.submitTarget.classList.toggle("invisible", !on)
    }
    if (this.hasTagsTarget) {
      this.tagsTarget.classList.toggle("invisible", !on)
    }
  }
}
