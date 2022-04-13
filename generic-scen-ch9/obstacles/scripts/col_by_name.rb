#!/usr/bin/ruby


names = $stdin.readline.split

puts names.index(ARGV[0]) + (names[0] == "#" ? 0 : 1)

