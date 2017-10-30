const Document = require('@lsg/document/document')
const Config = require('@lsg/document/config')
const Prism = require('prismjs')
const languages = require('prism-languages')

module.exports = class AllIncDocument extends Document {
  constructor (source, config = new Config()) {
    super(source, config)
    'marker showmore preview links'
      .split(' ')
      .forEach((plugin) => config.use(require(`@lsg/${plugin}-plugin`)))
    config.highlight = (source, lang) => {
      return languages[lang] ? Prism.highlight(source, languages[lang]) : source
    }
    config.addFile('css', __dirname, 'node_modules', 'prismjs', 'themes', 'prism-solarizedlight.css')
  }
}
