import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["distance"]

  syncDistance(event) {
    this.distanceTargets.forEach(input => { input.value = event.target.value })
  }
}
