import { Controller } from "@hotwired/stimulus"
import Chart from "chart.js/auto"

export default class extends Controller {
  static values = { config: Object }

  connect() {
    this.chart = new Chart(this.element, this.configValue)
  }

  disconnect() {
    this.chart?.destroy()
  }
}
