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
    expect(html).to.match(/^\s*<div>\s*<\/div>\s*$/m)
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
