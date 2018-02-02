const expect = require('chai').expect
const Code = require('../code')

describe('parsing of filename and language', () => {
  it('should parse the language', () => {
    const code = new Code('', 'html')
    expect(code.lang).to.equal('html')
    expect(code.filename).to.be.undefined
  })

  it('should return undefined when no language is given', () => {
    const code1 = new Code('', '')
    expect(code1.lang).to.be.undefined
    expect(code1.filename).to.be.undefined
    const code2 = new Code('')
    expect(code2.lang).to.be.undefined
    expect(code2.filename).to.be.undefined
  })

  it('should parse the language from a file suffix', () => {
    const code = new Code('', '_my-file.sass')
    expect(code.lang).to.equal('sass')
    expect(code.filename).to.equal('_my-file.sass')
  })
})
