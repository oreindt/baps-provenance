require 'crunsh'

cr = Crunsh.new "testsim"

cr.set 'bla', 3

cr.par 'v1', 1, 2, 3, 4
cr.par 'v2', 1.5, 1.7, 4
cr.par ['p1', 'p2'], [1, 2], [2, 4], [3, 5]

cr.create
