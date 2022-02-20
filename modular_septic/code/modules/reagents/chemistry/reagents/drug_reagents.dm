/datum/reagent/drug/lean
	name = "lean"
	description = "I LOVE LEAN."
	reagent_state = SOLID
	taste_description = "purple"
	color = "#7E3990"
	overdose_threshold = 35
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	ph = 3
	addiction_types = list(/datum/addiction/maintenance_drugs = 20)

/datum/reagent/drug/lean/on_mob_life(mob/living/carbon/lean_monster, delta_time, times_fired)
	. = ..()


/datum/reagent/drug/lean/on_mob_metabolize(mob/living/lean_monster)
	. = ..()
/*	lean_monster.playsound_local(lean_monster, 'modular_septic/sound/insanity/lean.ogg', 60) */
	to_chat(lean_monster, span_horny(span_big("Lean...I LOVE LEAAAANNNNNNN!!!")))
	ADD_TRAIT(lean_monster, TRAIT_LEAN, name)
	SSdroning.area_entered(get_area(lean_monster), lean_monster?.client)
	addtimer(CALLBACK(src, .proc/make_monster_lean, lean_monster), 1 SECONDS) //For making him lean
	if(!lean_monster.hud_used)
		return

	var/atom/movable/plane_master_controller/game_plane_master_controller = lean_monster.hud_used.plane_master_controllers[PLANE_MASTERS_GAME]

	var/list/col_filter_full = list(1,0,0,0, 0,1.00,0,0, 0,0,1,0, 0,0,0,1, 0,0,0,0)
	var/list/col_filter_twothird = list(1,0,0,0, 0,0.68,0,0, 0,0,1,0, 0,0,0,1, 0,0,0,0)
	var/list/col_filter_half = list(1,0,0,0, 0,0.42,0,0, 0,0,1,0, 0,0,0,1, 0,0,0,0)
	var/list/col_filter_empty = list(1,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,0,1, 0,0,0,0)

	game_plane_master_controller.add_filter("lean_filter", 10, color_matrix_filter(col_filter_twothird, FILTER_COLOR_HCY))

	for(var/filter in game_plane_master_controller.get_filters("lean_filter"))
		animate(filter, loop = -1, color = col_filter_full, time = 4 SECONDS, easing = CIRCULAR_EASING|EASE_IN, flags = ANIMATION_PARALLEL)
		animate(color = col_filter_twothird, time = 6 SECONDS, easing = LINEAR_EASING)
		animate(color = col_filter_half, time = 3 SECONDS, easing = LINEAR_EASING)
		animate(color = col_filter_empty, time = 2 SECONDS, easing = CIRCULAR_EASING|EASE_OUT)
		animate(color = col_filter_half, time = 24 SECONDS, easing = CIRCULAR_EASING|EASE_IN)
		animate(color = col_filter_twothird, time = 12 SECONDS, easing = LINEAR_EASING)

	game_plane_master_controller.add_filter("lean_blur", 1, list("type" = "radial_blur", "size" = 0))

	for(var/filter in game_plane_master_controller.get_filters("lean_blur"))
		animate(filter, loop = -1, size = 0.04, time = 2 SECONDS, easing = ELASTIC_EASING|EASE_OUT, flags = ANIMATION_PARALLEL)
		animate(size = 0, time = 6 SECONDS, easing = CIRCULAR_EASING|EASE_IN)

/datum/reagent/drug/lean/on_mob_end_metabolize(mob/living/lean_monster)
	. = ..()
	to_chat(lean_monster, span_horny(span_big("I...LOVE...LEAN...I...NEED...MORE...LEAN...")))
	REMOVE_TRAIT(lean_monster, TRAIT_LEAN, name)
	SSdroning.play_area_sound(get_area(lean_monster), lean_monster?.client)

	if(!lean_monster.hud_used)
		return

		var/atom/movable/plane_master_controller/game_plane_master_controller = lean_monster.hud_used.plane_master_controllers[PLANE_MASTERS_GAME]
		game_plane_master_controller.remove_filter("lean_filter")
		game_plane_master_controller.remove_filter("lean_blur")

/datum/reagent/drug/lean/proc/make_monster_lean(mob/living/carbon/lean_monster)
	. = ..()

