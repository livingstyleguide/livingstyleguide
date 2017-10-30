const Prism = require('prismjs')
const languages = require('prism-languages')
const escape = require('@lsg/document/escape')

module.exports = function (config) {
  'marker showmore preview links'
    .split(' ')
    .forEach((plugin) => config.use(require(`@lsg/${plugin}-plugin`)))
  config.highlight = (source, lang) => {
    if (lang === 'lsg') {
      lang = 'markdown'
    }
    return languages[lang] ? Prism.highlight(source, languages[lang]) : escape(source)
  }
  // config.addFile("css", __dirname, "node_modules", "prismjs", "themes", "prism-solarizedlight.css")
}
