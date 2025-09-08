import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
  static targets = ["field", "submit", "tags"]
  toggle(e) {
    const on = e.target.checked
    this.fieldTargets.forEach(el => el.disabled = !on)
    this.submitTarget.classList.toggle("hidden", !on)
    if (this.hasTagsTarget) this.tagsTarget.classList.toggle("hidden", !on)
  }
}
