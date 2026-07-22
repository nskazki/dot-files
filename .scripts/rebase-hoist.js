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

const commandLines = lines.filter(({ marker }) => {
  return !marker
})

if (commandLines.length <= 1) {
  console.error(`unexpected number of lines=${lines.length}`)
  console.error('nothing to do!')
  process.exit(2)
}

lines.forEach(({ marker, cmd, hash, msg, raw }) => {
  if (!marker && cmd !== 'pick') {
    console.error(`[${raw}] contain unexpected [cmd=${cmd}]`)
    process.exit(1)
  }
})

const commits = process.env.COMMITS.split(/\s+/)
const hashes = commandLines.map(({ hash }) => {
  return hash
})

commits.sort((a, b) => {
  return hashes.indexOf(a) - hashes.indexOf(b)
})

commits.forEach(commit => {
  if (hashes.indexOf(commit) === -1) {
    console.error(`[${commit}] is not contains in [${hashes}]`)
    process.exit(1)
  }
})

const keptLines = lines.filter(({ marker, hash }) => {
  return marker || !commits.includes(hash)
})

const hoistedLines = commits.map((commit) => {
  return commandLines.find(({ hash }) => {
    return hash === commit
  })
})

const output = [
  ...keptLines,
  ...hoistedLines
]

const commandOutput = output.filter(({ marker }) => {
  return !marker
})

const sameOutput = commandOutput.every(({ hash }, index) => {
  return hashes.indexOf(hash) === index
})

if (sameOutput) {
  console.error('output equal to input')
  console.error('nothing to do!')
  process.exit(2)
}

const rawOutput = output.map(({ raw }) => {
  return raw
}).join('\n')

console.log(rawOutput)
writeFileSync(filePath, rawOutput)
