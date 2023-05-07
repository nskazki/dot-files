#! /usr/bin/env node

'use strict'

const { readFileSync, writeFileSync } = require('fs')

const path = process.argv[2]
const withPrefix = readFileSync(process.argv[2]).toString()
const withoutPrefix = withPrefix.replace(/^\[([0-9]+|[A-Za-z]+-[0-9]+)\]\s+/, '')
writeFileSync(path, withoutPrefix) // the post-commit hook will handle the rest
