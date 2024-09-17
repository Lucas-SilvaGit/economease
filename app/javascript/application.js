// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import $ from 'jquery';
import "chartkick/chart.js"
window.$ = window.jQuery = $;
