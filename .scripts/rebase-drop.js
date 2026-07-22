#! /usr/bin/env node

'use strict'

const {
  readFileSync,
  writeFileSync } = require('fs')

const filePath = process.argv[2]
const rawText = readFileSync(filePath).toString().replace(/^#.*$/gm, '').trim()
const rawLines = rawText.split('\n')
const lines = rawLines.filter((rawLine) => rawLine.length).map(rawLine => {
  const match = /^(\w+)\s+(\w+)\s+#\s+(.+?)(\s+#\s+empty)?$/.exec(rawLine)
  const marker = /^update-ref.+$/.test(rawLine)

  if (marker) {
    return {
      marker: true,
      raw: rawLine
    }
  } else {
    return {
      cmd: match[1],
      hash: match[2],
      msg: match[3],
      raw: rawLine
    }
  }
})

lines.forEach(({ marker, cmd, hash, msg, raw }) => {
  if (!marker && cmd !== 'pick') {
    console.error(`[${raw}] contain unexpected [cmd=${cmd}]`)
    process.exit(1)
  }
})

const commits = process.env.COMMITS.split(/\s+/)
const hashes = lines.map(({ hash }) => hash)
commits.sort((a, b) => hashes.indexOf(a) - hashes.indexOf(b))

commits.forEach(commit => {
  if (hashes.indexOf(commit) === -1) {
    console.error(`[${commit}] is not contains in [${hashes}]`)
    process.exit(1)
  }
})

const output = lines.map(({ marker, cmd, hash, msg, raw }) => {
  if (marker) {
    return raw
  } else if (commits.includes(hash)) {
    return `d ${hash} # ${msg}`
  } else {
    return raw
  }
}).join('\n')

console.log(output)
writeFileSync(filePath, output)
