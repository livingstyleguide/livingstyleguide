const REGEXP_TEST = /^\/.+\/$/

module.exports = class PreHighlighter {
  constructor () {
    this.rules = {}
    this.code = null
    this.replacements = []
  }

  rule (pattern, callback) {
    this.rules[pattern] = callback
  }

  findRule (match) {
    for (var pattern in this.rules) {
      const rule = this.rules[pattern]
      if (pattern.match(REGEXP_TEST) &&
          match.match(new RegExp(pattern.slice(1, -1).replace(/\(\?=.+/, ''))) ||
          pattern === match) {
        return rule
      }
    }
    return () => ''
  }

  regexp () {
    const patterns = Object.keys(this.rules).map((pattern) => {
      if (pattern.match(REGEXP_TEST)) {
        return pattern.slice(1, -1)
      } else {
        return pattern.replace(/[-/\\^$*+?.()|[\]{}]/g, '\\$&')
      }
    })
    return new RegExp(patterns.join('|'), 'gm')
  }

  preProcess () {
    const replacements = this.replacements
    const openings = {}
    const findRule = (match) => this.findRule(match)
    let removedCharacters = 0
    this.code = this.code.replace(this.regexp(), function (...args) {
      const match = args[0]
      const offset = args[arguments.length - 2]
      const matches = Array.prototype.slice.call(args, 1, -2).filter(Boolean)
      const opening = openings[match] = !openings[match]
      replacements.push({
        offset: offset - removedCharacters,
        html: findRule(match)(match, opening, matches, offset),
      })
      removedCharacters += match.length
      return ''
    })
  }

  postProcess () {
    let codeWithHighlights = ''
    let offset = 0
    let nextPosition = this.replacements.shift()
    let insideCharacter = false
    let insideHtml = false
    for (let i = 0; i <= this.code.length; i++) {
      const character = this.code[i] || ''
      if (character === '<') {
        insideHtml = true
        if (nextPosition && offset == nextPosition.offset) {
          codeWithHighlights += nextPosition.html
          nextPosition.html = ''
        }
      } else if (insideHtml && character === '>') {
        insideHtml = false
      } else if (!insideHtml) {
        if (nextPosition && offset === nextPosition.offset) {
          codeWithHighlights += nextPosition.html
          nextPosition = this.replacements.shift()
        }
        if (character === '&') {
          insideCharacter = true
          if (nextPosition && offset == nextPosition.offset) {
            codeWithHighlights += nextPosition.html
            nextPosition.html = ''
          }
        } else if (insideCharacter && character === ';') {
          insideCharacter = false
          offset++
        } else if (!insideCharacter) {
          offset++
        }
      }
      codeWithHighlights += character
    }
    this.code = codeWithHighlights
  }

  plain (code) {
    return code.replace(this.regexp(), '')
  }

  process (code, lang, highlight) {
    this.code = code
    this.preProcess()
    this.code = highlight(this.code, lang)
    this.postProcess()
    return this.code
  }
}
