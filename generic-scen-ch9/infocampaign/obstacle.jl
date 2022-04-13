mutable struct Scenario_obst
	done :: Bool
end

Scenario_obst() = Scenario_obst(false)

setup_scenario_obst(sim::Simulation, args) = Scenario_obst()

function scenario_obst!(scen, sim::Simulation, t)
	if t > 200 && ! scen.done
		println("scenario_obst: increasing mortality")
		set_obstacle!(sim.model.world, sim.par.obstacle..., 0.02)
		scen.done = true
	end
end

(setup_scenario_obst, scenario_obst!)
