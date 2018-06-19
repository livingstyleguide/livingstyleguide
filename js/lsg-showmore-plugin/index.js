let counter = 0

module.exports = function (config) {
  config.command('showmore', (code) => {
    // Block:
    code.preHighlighter.rule(/^( *)(\[…|\[\.{3,})\n/, function (match, _, matches) {
      counter++
      var className = `lsg-hidden-code-${counter}`
      var indent = matches[0].match(/^ +$/) ? matches[0] : ''
      return `<div class="lsg-show-hidden-code-wrapper">${indent}` +
             '<button type="button" class="lsg-show-hidden-code"' +
             ` data-target=".${className}"></button></div>` +
             `<div class="lsg-hidden-code ${className}">`
    })
    code.preHighlighter.rule(/^ *(…\]|\.{3,}\])\n/, function () {
      return '</div>'
    })

    // Inline:
    code.preHighlighter.rule(/\[…|\[\.{3,}/, function (match, _, matches) {
      counter++
      var className = `lsg-hidden-code-${counter}`
      return '<span><button type="button" class="lsg-show-hidden-code"' +
             ` data-target=".${className}"></button></span>` +
             `<strong class="lsg-hidden-code ${className}">`
    })
    code.preHighlighter.rule(/…\]|\.{3,}\]/, function () {
      return '</strong>'
    })
  })
  config.addFile('css', __dirname, 'browser.css')
  config.addFile('javascript-after', __dirname, 'browser.js')
}
