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
  if (!marker && (cmd !== 'pick' || !/^\d+$/.test(msg))) {
    console.error(`[${raw}] contains unexpected [cmd=${cmd}]`)
    process.exit(1)
  }
})

const firstCommandLine = commandLines[0]

const output = lines.map(({ marker, cmd, hash, msg, raw }) => {
  if (marker) {
    return raw
  } else if (hash === firstCommandLine.hash) {
    return raw
  } else {
    return `f ${hash} # ${msg}`
  }
}).join('\n')

console.log(output)

writeFileSync(filePath, output)
