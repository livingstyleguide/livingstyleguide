module.exports = class Config {
  constructor () {
    this.markedOptions = {
      gfm: true,
      tables: true,
      breaks: false,
      pedantic: false,
      sanitize: false,
      sanitizer: null,
      mangle: true,
      smartLists: false,
      silent: false,
      highlight: false,
      langPrefix: 'lang-',
      smartypants: false,
      headerPrefix: '',
      xhtml: false
    }
  }
}
