#!/usr/bin/env node

'use strict';

var rename  = require('fs').renameSync
var readdir = require('fs').readdirSync
var join    = require('path').join
var format  = require('util').format

var args = process.argv.slice(2).map(function(v) { return v.trim() })
if (args[0] === '--help' || args[0] === '-h' || args.length < 3) {
  console.log('usage: raname-node <dir-path> <regexp> <frmstr> [mode]')
  console.log('       rename-node . "-(\\d+)/(\\d+).*\\.(.+)" "MLP_S%sE%s.%s" debug')
  console.log('modes: debug|move (default - \u001b[96mdebug\u001b[39m)')
  process.reallyExit(0)
}

var dir       = args[0]
var oldPrefix = new RegExp(args[1])
var newPrefix = args[2]
var isDebug   = args[3] !== 'move'

var skiped = []
var renamedOld = []
var renamedNew = []

readdir(dir).forEach(function(name) {
    var oldFull = join(dir, name)
    if (!oldPrefix.test(name)) {
      skiped.push(name)
      return
    }

    var parts = name.match(oldPrefix).slice(1)
    var newName = format.apply(null, [ newPrefix].concat(parts))
    var newFull = join(dir, newName)

    renamedOld.push(oldFull)
    renamedNew.push(newFull)
    if (!isDebug) rename(oldFull, newFull)
})

if (skiped.length) {
  skiped.forEach(function(skip) {
    console.log('skip - \u001b[33m%s\u001b[39m', skip)
  })
  console.log()
}

if (renamedOld.length) {
  var newColor = isDebug ? '\u001b[96m' : '\u001b[92m'
  var oldMaxLength = getMaxLength(renamedOld)

  console.log('mode - %s%s\u001b[39m', newColor, isDebug ? 'debug' : 'move')
  console.log()

  renamedOld.forEach(function(oldFull, index) {
    var newFull = renamedNew[index]
    console.log('move - \u001b[95m%s\u001b[39m -> %s%s\u001b[39m', padRight(oldFull, oldMaxLength), newColor, newFull)
  })
}

function getMaxLength(arr) {
  return arr
    .map(function(v) { return v.length })
    .sort(function(a, b) { return b - a })
    [0]
}

function padRight(raw, length, str) {
  str = str || ' ';
  return raw.length >= length
    ? raw
    : raw + (new Array(Math.ceil((length - raw.length) / str.length) + 1).join(str)).substr(0, (length - raw.length))
}
