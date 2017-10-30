const marked = require('marked')
const Config = require('./config')
const Code = require('./code')

module.exports = class Document {
  constructor (source, config) {
    this.config = config || new Config()
    this.config.templatingEngines.lsg = (source) => new Document(source, this.config).renderContent()
    this.source = source
    this.title = null
    this.tokenize()
  }

  tokenize () {
    this.tokens = []

    const lexer = new marked.Lexer({})
    lexer.rules.fences = /^ *(`{3,}|~{3,})[ .]*(\S+ ?.+?)? *\n([\s\S]*?)\s*\1 *(?:\n+|$)/

    lexer.lex(this.source).forEach((token) => {
      if (token.type === 'heading') {
        if (!this.title && token.depth === 1) {
          this.title = token.text
        }
        this.tokens.push(token)
      } else {
        this.tokens.push(token)
      }
    })

    this.tokens.links = []
  }

  renderContent () {
    const renderer = new marked.Renderer()

    renderer.code = (source, lang) => {
      const code = new Code(source, lang, this.config)
      return code.render()
    }
    renderer.heading = (text, level, raw) => {
      const id = raw.toLowerCase().replace(/[^\w]+/g, '-')

      return (
        `<h${level} class="${this.config.classNames['h' + level]}">` +
        `<a class="lsg-anchor" href="#${id}" id="${id}"></a>` +
        `${text}` +
        `</h${level}>\n`
      )
    }
    renderer.paragraph = (text) => {
      return `<p class="${this.config.classNames.p}">${text}</p>\n`
    }
    renderer.listitem = (text) => {
      return `<li class="${this.config.classNames.li}">${text}</li>\n`
    }

    let markedOptions = {
      renderer: renderer,
    }
    Object.assign(markedOptions, this.config.markedOptions)

    let html = marked.parser(this.tokens, markedOptions)
    return `<div class="${this.config.classNames.root}">\n${html}\n</div>`
  }

  render () {
    let html = this.renderContent()

    return this.config.get('css').then((css) => {
      if (css) {
        html = `<style>${css}</style>` + html
      }
      return html
    }).then(() => {
      return this.config.get('javascript-before').then((js) => {
        if (js) {
          html = `<script>${js}</script>` + html
        }
        return html
      })
    }).then(() => {
      return this.config.get('javascript-after').then((js) => {
        if (js) {
          html += `<script>${js}</script>`
        }
        return html
      })
    }).catch(console.log.bind(console))
  }
}
