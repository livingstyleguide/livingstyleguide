module.exports = function (config) {
  config.command('links', (code) => {
    code.preHighlighter.rule(/\[(?=([\w\d\-_]+?)\]\((.+?)\))/, function (match, _, matches) {
      return `<a href="${matches[1]}">`
    })
    code.preHighlighter.rule(/\]\((.+?)\)/, function () {
      return '</a>'
    })
  })
  config.addFile('css', __dirname, 'browser.css')
}
