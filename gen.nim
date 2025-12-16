#! /bin/env -S nim c -r --hints:off
import os
import std/random
import std/strformat
import std/strutils


let args: seq[string] = commandLineParams()
if args.high() != 1:
    echo "usage: gen.nim <x> <y>"
    quit(1)

let x = parseInt(args[0])
let y = parseInt(args[1])

var playfield = newSeq[seq[bool]](y)

randomize()

for i in 0..y-1:
    var row = newSeq[bool](x)
    for j in 0..x-1:
        row[j] = rand(10) == 0;
    playfield[i] = row

echo """
<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg"
     xmlns:xlink="http://www.w3.org/1999/xlink"
     version="1.1" baseProfile="full">
    <title>SVG-sweeper</title>
    <desc>A minesweeper-clone implemented in a single SVG. No JavaScript!</desc>

    <style>
        table {
            border-collapse: collapse;
            border: 2px solid lightgray;
            background-color: darkgray;
        }
        td {
            border: 2px solid lightgray;
            font-size: large;
        }
        label {
            width: 2em;
            height: 2em;
            display: inline-block;
            text-align: center;
        }
        label:after {
            content: '☐';
            color: darkgray
        }
        input {
            display: none;
            pointer-events: none;
        }
        input:checked+label {
            pointer-events: none;
            background-color: lightgray;
            color: black;
        }
        input:checked+label:after {
            color: black;
        }
        .f0:checked+label:after {
            content: '☐';
            color: lightgray
        }
        .f1:checked+label:after {
            content: '1';
        }
        .f2:checked+label:after {
            content: '2';
        }
        .f3:checked+label:after {
            content: '3';
        }
        .f4:checked+label:after {
            content: '4';
        }
        .f5:checked+label:after {
            content: '5';
        }
        .f6:checked+label:after {
            content: '6';
        }
        .f7:checked+label:after {
            content: '7';
        }
        .f8:checked+label:after {
            content: '8';
        }
        .fbomb:checked+label {
            background-color: red;
        }
        .fbomb:checked+label:after {
            content: '💣';
        }
    </style>

    <foreignObject x="0" y="0" width="100%" height="100%">
        <table xmlns="http://www.w3.org/1999/xhtml">
            <tbody xmlns="http://www.w3.org/1999/xhtml">
"""
var globalminecount = 0
for i in 0..y-1:
    echo "                <tr xmlns=\"http://www.w3.org/1999/xhtml\">"
    for j in 0..x-1:
        var fieldcontent: string
        if playfield[i][j]:
            fieldcontent = "bomb"
            inc globalminecount
        else:
            var neighbouringminecount = 0
            for a in -1..1:
                for b in -1..1:
                    if (i+a >= 0) and (j+b >= 0) and (i+a < y) and (j+b < x) and playfield[i+a][j+b]:
                        inc neighbouringminecount
                    fieldcontent = $neighbouringminecount
        echo &"                    <td xmlns=\"http://www.w3.org/1999/xhtml\">\n                        <input autocomplete=\"off\" type=\"checkbox\" id=\"field{i}-{j}\" class=\"f{fieldcontent}\" xmlns=\"http://www.w3.org/1999/xhtml\" />\n                        <label for=\"field{i}-{j}\" xmlns=\"http://www.w3.org/1999/xhtml\"></label>\n                    </td>"
    echo "                </tr>"

echo """
        </tbody>
    </table>
    <p xmlns="http://www.w3.org/1999/xhtml"> Mine count: """ & $globalminecount & """</p>
    </foreignObject>

</svg>
"""