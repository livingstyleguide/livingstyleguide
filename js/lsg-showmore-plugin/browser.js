window.lsg = window.lsg || {}
window.lsg.initializers = window.lsg.initializers || {}

window.lsg.initializers.showmore = function () {
  var showHiddenCode = function (event) {
    var el = event.currentTarget
    el.parentNode.style.display = 'none'
    var targets = document.querySelectorAll(el.dataset.target)
    for (var i = 0; i < targets.length; i++) {
      targets[i].style.display = targets[i].tagName === 'DIV' ? 'block' : 'inline'
    }
  }
  var buttons = document.querySelectorAll('.lsg-show-hidden-code')
  for (var i = 0; i < buttons.length; i++) {
    buttons[i].addEventListener('click', showHiddenCode)
  }
}

document.addEventListener('DOMContentLoaded', window.lsg.initializers.showmore)
