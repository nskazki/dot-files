#! /usr/bin/env node

'use strict'

const {
  readFileSync,
  writeFileSync } = require('fs')

const filePath = process.argv[2]
const rawText = readFileSync(filePath).toString().replace(/^#.*$/gm, '').trim()
const rawLines = rawText.split('\n')
const lines = rawLines.map(rawLine => {
  const match = /^(\w+)\s+(\w+)\s+(.+?)\s*(#.*)?$/.exec(rawLine)
  return {
    cmd: match[1],
    hash: match[2],
    msg: match[3],
    raw: rawLine
  }
})

if (lines.length <= 1) {
  console.error(`unexpected number of lines=${lines.length}`)
  console.error('nothing to do!')
  process.exit(2)
}

lines.forEach(({ cmd, hash, msg, raw }) => {
  if (cmd !== 'pick') {
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

const output = [
  ...lines.filter(({ hash }) => !commits.includes(hash)),
  ...commits.map(commit => ({ cmd: 'p', hash: commit, msg: lines.find(({ hash }) => hash === commit).msg }))
]

const sameOutput = output.every(({ hash }, index) => hashes.indexOf(hash) === index)
if (sameOutput) {
  console.error('output equal to input')
  console.error('nothing to do!')
  process.exit(2)
}

const rawOutput = output.map(({ cmd, hash, msg }) => `${cmd} ${hash} ${msg}`).join('\n')
console.log(rawOutput)
writeFileSync(filePath, rawOutput)
