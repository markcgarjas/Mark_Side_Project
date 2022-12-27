import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["coins"]

  betMinus() {
    let coins = this.coinsTarget.value
    let count = parseInt(coins) - 1
    count = count < 1 ? 1 : count
    this.coinsTarget.value = count
  }

  betPlus(event) {
    const value = event.target.dataset.value
    let coins = this.coinsTarget.value
    let count = parseInt(coins) + parseInt(value)
    this.coinsTarget.value = count
  }
}