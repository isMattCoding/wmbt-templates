import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["toggle"];

  connect() {
    this.updateTheme();
  }

  toggle() {
    const newTheme = this.currentTheme() === "dark" ? "light" : "dark";
    document.cookie = `theme=${newTheme}; path=/`;
    this.updateTheme();
  }

  updateTheme() {
    const theme = this.currentTheme();
    document.documentElement.setAttribute("data-theme", theme);
  }

  currentTheme() {
    const matches = document.cookie.match(/theme=([^;]+)/);
    return matches ? matches[1] : "dark";
  }
}
