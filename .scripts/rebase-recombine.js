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

lines.forEach(({ cmd, raw }) => {
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

const firstCommit = commits[0]
const firstRcLine = lines.find(({ hash }) => hash === firstCommit)

const firstRcIndex = lines.indexOf(firstRcLine)
const firstOutLines = lines.slice(0, firstRcIndex)

const otherCommits = commits.slice(1)
const otherRcLines = lines.filter(({ hash }) => otherCommits.indexOf(hash) !== -1)

const lastOutLines = lines.slice(firstRcIndex).filter(({ hash }) => commits.indexOf(hash) === -1)

const output = [
  ...firstOutLines,
  { cmd: 'p', hash: firstRcLine.hash, msg: firstRcLine.msg },
  ...otherRcLines.map(({ hash, msg }) => ({ cmd: 'f', hash, msg })),
  ...lastOutLines
]

const rawOutput = output.map(({ cmd, hash, msg }) => `${cmd} ${hash} ${msg}`).join('\n')
console.log(rawOutput)
writeFileSync(filePath, rawOutput)
