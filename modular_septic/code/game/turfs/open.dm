//Consider making all of these behaviours a smart component/element? Something that's only applied wherever it needs to be
//Could probably have the variables on the turf level, and the behaviours being activated/deactived on the component level as the vars are updated
/turf/open/CanPass(atom/movable/mover, border_dir)
	if(isliving(mover))
		var/turf/mover_turf = get_turf(mover)
		if(turf_height - mover_turf?.turf_height >= TURF_HEIGHT_BLOCK_THRESHOLD)
			return FALSE
	return ..()

/turf/open/Exit(atom/movable/leaving, direction)
	. = ..()
	if(. && isliving(leaving) && leaving.has_gravity())
		var/mob/living/living_mover = leaving
		var/turf/new_turf = get_step(leaving, direction)
		if(!istype(new_turf))
			return
		if(turf_height - new_turf?.turf_height >= TURF_HEIGHT_BLOCK_THRESHOLD)
			living_mover.on_fall()
			living_mover.onZImpact(new_turf, 1)

/turf/open/MouseDrop_T(atom/movable/dropping, mob/living/user)
	. = ..()
	if(!isliving(dropping) || !isliving(user) || !dropping.has_gravity() || !Adjacent(user) || !dropping.Adjacent(user) || (user.stat > CONSCIOUS) || user.body_position == LYING_DOWN)
		return
	if(!dropping.has_gravity())
		return
	var/turf/dropping_turf = get_turf(dropping)
	if(!dropping_turf)
		return
	if(dropping_turf.turf_height - turf_height >= TURF_HEIGHT_BLOCK_THRESHOLD)
		//Climb down
		if(user == dropping)
			dropping.visible_message(span_notice("<b>[user]</b> is descending down to [src]"), \
								span_notice("I start lowering myself to [src]."))
		else
			dropping.visible_message(span_warning("<b>[user]</b> is lowering <b>[dropping]</b> down to [src]"), \
								span_notice("I start lowering <b>[dropping]</b> down to [src]."))
		if(do_mob(user, dropping, 2 SECONDS))
			dropping.forceMove(src)
		return
	else if(turf_height - dropping_turf.turf_height >= TURF_HEIGHT_BLOCK_THRESHOLD)
		//Climb up
		if(user == dropping)
			dropping.visible_message(span_notice("<b>[user]</b> is climbing onto [src]"), \
								span_notice("I start climbing onto [src]."))
		else
			dropping.visible_message(span_warning("<b>[user]</b> is pulling <b>[dropping]</b> onto [src]"), \
								span_notice("I start pulling <b>[dropping]</b> onto <b>[src]</b>."))
		if(do_mob(user, dropping, 2 SECONDS))
			dropping.forceMove(src)
		return
