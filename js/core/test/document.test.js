var expect = require('chai').expect
var Config = require('../config')
var Document = require('../document')

function unindent (string) {
  const allIndents = string.match(/^ */gm)
  const shortestIndent = allIndents.sort()[0]
  return string.replace(new RegExp(`^${shortestIndent}`, 'gm'), '')
}

function newDoc (source, config) {
  return new Document(unindent(source).trim(), config)
}

describe('rendering of a simple document', () => {
  it('should render an empty div', () => {
    const html = newDoc('').render()
    expect(html).to.match(/^\s*<div class="lsg">\s*<\/div>\s*$/m)
  })

  it('should render a headline', () => {
    const html = newDoc(`
      # Hello
    `).render()
    expect(html).to.match(/<h1[^>]*>Hello<\/h1>/m)
  })

  it('should use the first headline as the title', () => {
    const doc = newDoc(`
      # Hello

      # World
    `)
    doc.render()
    expect(doc.title).to.equal('Hello')
  })

  it('should not have a title when no headline is used', () => {
    const doc = new Document(`
      Hello

      World
    `)
    doc.render()
    expect(doc.title).to.be.null
  })
})

describe('the use of the configuration object', () => {
  it('should use a default', () => {
    const config = new Config()
    const html = newDoc(`
      ---
    `, config).render()
    expect(html).to.match(/<hr>/)
  })

  it('should use markedOptions', () => {
    const config = new Config()
    config.markedOptions.xhtml = true
    const html = newDoc(`
      ---
    `, config).render()
    expect(html).to.match(/<hr\/>/)
  })
})

describe('custom class names', () => {
  const tests = [
    ['# ', 'h1', 'lsg-pagetitle'],
    ['## ', 'h2', 'lsg-headline'],
    ['### ', 'h3', 'lsg-sub-headline'],
    ['#### ', 'h4', 'lsg-sub-sub-headline'],
    ['', 'p', 'lsg-paragraph'],
    ['* ', 'li', 'lsg-list-item'],
    ['1. ', 'li', 'lsg-list-item']
  ]

  it('should use default class names', () => {
    tests.forEach((test) => {
      const html = newDoc(`${test[0]}Text`).render()
      const regexp = `<${test[1]}[^>]+class="[^"]*${test[2]}[^"]*"[^>]*>\\s*Text`
      expect(html).to.match(new RegExp(regexp))
    })
  })

  it('should use custom class names when defined', () => {
    tests.forEach((test) => {
      const config = new Config()
      config.classNames[test[1]] = 'my-custom-class-name'
      const html = newDoc(`${test[0]}Text`, config).render()
      const regexp = `<${test[1]}[^>]+class="[^"]*my-custom-class-name[^"]*"[^>]*>\\s*Text`
      expect(html).to.match(new RegExp(regexp))
    })
  })
})
