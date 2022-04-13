using Parameters

@with_kw struct Params
	rand_seed_sim	::	Int64	= 60139
	rand_seed_world	::	Int64	= 96514
	n_cities	::	Int64	= 0
	link_thresh	::	Float64	= 0.0
	rate_dep	::	Float64	= 20.0
	dep_warmup	::	Float64	= 1.0
	n_exits	::	Int64	= 0
	n_entries	::	Int64	= 5
	exit_dist	::	Float64	= 1.0
	entry_dist	::	Float64	= 0.0
	n_nearest_entry	::	Int64	= 3
	n_nearest_exit	::	Int64	= 0
	qual_entry	::	Float64	= 0.0
	res_entry	::	Float64	= 0.0
	qual_exit	::	Float64	= 1.0
	res_exit	::	Float64	= 1.0
	obstacle	::	Array{Float64,1}	= [0.0, 0.0, 0.0, 0.0]
	dist_scale	::	Array{Float64,1}	= [1.0, 10.0]
	frict_range	::	Float64	= 0.5
	risk_normal	::	Float64	= 0.0
	risk_high	::	Float64	= 0.0
	risk_exp	::	Float64	= 0.01
	risk_scale	::	Float64	= 8.023104403610127
	n_ini_contacts	::	Int64	= 10
	ini_capital	::	Float64	= 0.0
	p_unknown_city	::	Float64	= 0.0
	p_unknown_link	::	Float64	= 0.0
	p_know_target	::	Float64	= 0.0
	p_know_city	::	Float64	= 0.1
	p_know_link	::	Float64	= 0.1
	speed_expl_ini	::	Float64	= 1.0
	risk_i	::	Float64	= -7.64
	risk_s	::	Float64	= 0.16
	risk_sd_i	::	Float64	= 4.68
	risk_sd_s	::	Float64	= 0.08
	risk_cov_i_s	::	Float64	= -0.337
	rate_plan	::	Float64	= 100.0
	res_exp	::	Float64	= 0.5
	qual_exp	::	Float64	= 0.5
	frict_exp	::	Array{Float64,1}	= [1.25, 12.5]
	p_find_links	::	Float64	= 0.5
	trust_found_links	::	Float64	= 0.5
	p_find_dests	::	Float64	= 0.3
	trust_travelled	::	Float64	= 0.8
	speed_expl_stay	::	Float64	= 1.0
	speed_expl_move	::	Float64	= 1.0
	rate_explore_stay	::	Float64	= 1.0
	p_notice_death_c	::	Float64	= 0.3
	p_notice_death_o	::	Float64	= 0.1
	speed_risk_indir	::	Float64	= 0.1
	speed_risk_obs	::	Float64	= 0.1
	speed_expl_risk	::	Float64	= 1.0
	rate_costs_stay	::	Float64	= 1.0
	costs_stay	::	Float64	= 1.0
	ben_resources	::	Float64	= 5.0
	costs_move	::	Float64	= 2.0
	save_thresh	::	Float64	= 100.0
	save_income	::	Float64	= 1.0
	move_speed	::	Float64	= 0.038910505836575876
	move_rate	::	Float64	= 0.0
	ret_traffic	::	Float64	= 0.8
	weight_traffic	::	Float64	= 0.001
	qual_weight_x	::	Float64	= 0.0
	qual_weight_res	::	Float64	= 0.1
	qual_tol_frict	::	Float64	= 2.0
	qual_bias	::	Float64	= 1.0
	path_penalty_loc	::	Float64	= 1.0
	path_penalty_risk	::	Float64	= 0.7349805108660794
	p_keep_contact	::	Float64	= 0.1
	p_drop_contact	::	Float64	= 0.5693460805601102
	p_info_contacts	::	Float64	= 0.8700472637098883
	p_transfer_info	::	Float64	= 0.6492595660760874
	n_contacts_max	::	Int64	= 50
	arr_learn	::	Float64	= 0.0
	convince	::	Float64	= 0.5
	convert	::	Float64	= 0.1
	confuse	::	Float64	= 0.3
	error	::	Float64	= 0.1
	error_risk	::	Float64	= 0.01
	error_frict	::	Float64	= 0.5
	weight_arr	::	Float64	= 1.0
end
