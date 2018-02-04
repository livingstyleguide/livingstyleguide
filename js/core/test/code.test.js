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

describe('custom ID and classes', () => {
  it('should use a custom ID', () => {
    const code1 = new Code('', '#my-id')
    expect(code1.render()).to.match(/id="my-id"/)
    const code2 = new Code('', 'html #my-id')
    expect(code2.render()).to.match(/id="my-id"/)
  })

  it('should add a custom class', () => {
    const code1 = new Code('', '.my-class')
    expect(code1.render()).to.match(/class="[^"]*my-class[^"]*"/)
    const code2 = new Code('', '.my-class .another-class')
    expect(code2.render()).to.match(/class="[^"]*another-class[^"]+my-class[^"]*"/)
    const code3 = new Code('', 'html .my-class')
    expect(code3.render()).to.match(/class="[^"]*my-class[^"]*"/)
    const code4 = new Code('', 'html .my-class .another-class')
    expect(code4.render()).to.match(/class="[^"]*another-class[^"]+my-class[^"]*"/)
  })

  it('should sort custom classes alphabetically just for the beauty of it', () => {
    const code1 = new Code('', '.b .a .f .c .e .d')
    expect(code1.render()).to.match(/class="[^"]*a[^"]+b[^"]+c[^"]+d[^"]+e[^"]+f[^"]*"/)
  })
})
