#!/usr/bin/env node

'use strict'

var processName = process.argv[2]
if (!processName) process.exit(1)
if (!/node --perf-basic-prof/.test(processName)) {
  processName = 'node --perf-basic-prof ' + processName.trim()
}

//ps axu | grep -e '\w*:\w*\snode /home'

var spawn = require('child_process').spawn
var ls = spawn('ls', ['-lh', '/usr'])

var spawn = require('child_process').spawn
var ps = spawn('ps', ['axu'])
var grep = spawn('grep', ['-P', '[0-9]+:[0-9]+\\s*' + processName])

ps.stdout.on('data', function(data) { grep.stdin.write(data) })
ps.on('close', function(code) { grep.stdin.end() })

var grepResult = ''
var regExp = /^\w+?\s+?(\d+)\s+/

grep.stdout.on('data', function(data) { grepResult += data })
grep.on('close', function(code) {
	console.log(grepResult.match(regExp)[1])
})
