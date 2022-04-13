$: << "./crunsh/"


require 'crunsh'

Crunsh.new "JULIA_LOAD_PATH=$JULIA_LOAD_PATH:../rgct_data julia ../rgct_data/run.jl ../params.jl --scenario-dir .. -t 350 %ARGS% </dev/null >out 2>err", dirPrefix: 'x_', mode: (ARGV.size > 0 ? ARGV[0] : "create") do

    par ['scenario', 'rate-dep'], {
      'depXobst'  =>  [['departure', 'obstacle'], 5.0], 
      'obst'      =>  ['obstacle', 20.0]}

    par ['risk-scale', 'path-penalty-risk'], {
      'riskeff-1-lo' => [10.0, 5],
      'riskeff-2-hi' => [20.0, 10]}

    par ['p-know-city', 'p-know-link', 'p-know-target'], {
      'know-1-lo' => [0.1, 0.1, 0.1],
      'know-2-hi' => [0.5, 0.5, 0.5] }

    par ['p-info-contacts', 'p-transfer-info'], {
      'comm-1-lo' => [0.1, 0.1],
      'comm-2-hi' => [0.3, 0.3] }

    par 'rand-seed-sim', 111, 112, 113, 114, 115, 116, 117, 118, 119, 120
end
