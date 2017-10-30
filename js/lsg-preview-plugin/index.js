module.exports = function (config) {
  config.command('preview', (code) => {
    code.parts.unshift('preview')
  })

  config.renderer('preview', (code) => `<div class="lsg-preview">${code.html()}</div>`)
}
