#! /usr/bin/env node

const program = require('commander')
const globby = require('globby')
const fs = require('fs')
const path = require('path')
const Document = require('@lsg/document')
const Config = require('@lsg/document/config')
const allinc = require('@lsg/allinc')

program
  .version('3.0.0')
  .option('--readme', 'Renames folder/README.md to folder.html')
  .arguments('[files...]')
  .action((files) => {
    const config = new Config()
    config.use(allinc)
    globby(files).then((paths) => {
      Promise.all(paths.map((file) => {
        return new Promise((resolve, reject) => {
          fs.readFile(file, (err, data) => {
            if (err) {
              return reject(err)
            }
            const doc = new Document(data.toString(), config)
            let outputFile = file.replace(/(\.html)?\.(md|lsg)$/, '.html')
            if (program.readme) {
              outputFile = outputFile.replace(/([^/]+)\/README.html/i, '$1.html')
            }
            const outputDir = path.dirname(outputFile)
            if (!fs.existsSync(outputDir)) {
              fs.mkdirSync(outputDir)
            }
            doc.render().then((html) => {
              fs.writeFile(outputFile, html, (err) => {
                if (err) {
                  return reject(err)
                }
                console.log(`Wrote ${file} to ${outputFile}.`)
                return resolve()
              })
            })
          })
        })
      }))
    })
  })
  .parse(process.argv)
