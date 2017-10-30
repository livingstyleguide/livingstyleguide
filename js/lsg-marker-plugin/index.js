module.exports = function (config) {
  config.command('marker', (code) => {
    code.preHighlighter.rule('***', function (match, opening) {
      return opening ? '<strong class="lsg-code-highlight">' : '</strong>'
    })
    code.preHighlighter.rule('___', function (match, opening) {
      return opening ? '<strong class="lsg-code-highlight">' : '</strong>'
    })
    code.preHighlighter.rule('~~~', function (match, opening) {
      return opening ? '<s>' : '</s>'
    })
  })
  config.addFile('css', __dirname, 'browser.css')
}
