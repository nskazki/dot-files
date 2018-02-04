#! /usr/bin/env node

'use strict'

const {
  readFileSync,
  writeFileSync } = require('fs')

const filePath = process.argv[2]
const rawText = readFileSync(filePath).toString().replace(/^#.*$/gm, '').trim()
const rawLines = rawText.split('\n')
const lines = rawLines.map(rawLine => {
  const match = /^(\w+)\s+(\w+)\s+(.+)\s*$/.exec(rawLine)
  return {
    cmd: match[1],
    hash: match[2],
    msg: match[3],
    raw: rawLine
  }
})

if (lines.length <= 1) {
  console.error(`unexpected number of lines=${lines.length}`)
  process.exit(1)
}

lines.forEach(({ cmd, hash, msg, raw }) => {
  if (cmd !== 'pick') {
    console.error(`[${raw}] contain unexpected [cmd=${cmd}]`)
    process.exit(1)
  } else if (!/^\d+$/.test(msg)) {
    console.error(`[${raw}] contain unexpected [msg=${msg}]`)
    process.exit(1)
  }
})

const output = [lines[0], ...lines.slice(1).map(({ hash, msg }) => ({ cmd: 'f', hash, msg }))]
const rawOutput = output.map(({ cmd, hash, msg }) => `${cmd} ${hash} ${msg}`).join('\n')
console.log(rawOutput)
writeFileSync(filePath, rawOutput)
