/mob
	plane = GAME_PLANE_FOV_HIDDEN

/mob/Initialize(mapload)
	. = ..()
	set_hydration(rand(HYDRATION_LEVEL_START_MIN, HYDRATION_LEVEL_START_MAX))
	// If we have an attribute holder, lets get that W
	if(ispath(attributes))
		AttributeInitialize()

/mob/return_screentip(mob/user, params)
	if(flags_1 & NO_SCREENTIPS_1)
		return ""
	return SCREENTIP_MOB(uppertext(name))

/mob/verb/examinate(atom/examinify as mob|obj|turf in view())
	set name = "Examine"
	set category = "IC"

	if(isturf(examinify) && !(sight & SEE_TURFS) && !(examinify in fov_view(client ? client.view : world.view, src)))
		return

	if(is_blind() && !blind_examine_check(examinify)) //blind people see things differently (through touch)
		return

	face_atom(examinify)
	var/flags = SEND_SIGNAL(src, COMSIG_MOB_EXAMINATE, examinify)
	if(flags & COMPONENT_DENY_EXAMINATE)
		return
	else if(flags & COMPONENT_EXAMINATE_BLIND)
		to_chat(src, "<span class='warning'>Something is there but you can't see it!</span>")
		return
	var/list/result
	if(client)
		LAZYINITLIST(client.recent_examines)
		var/ref_to_atom = ref(examinify)
		var/examine_time = LAZYACCESS(client.recent_examines, ref_to_atom)
		if(examine_time && (world.time - examine_time < EXAMINE_MORE_WINDOW))
			result = examinify.examine_more(src)
			if(!LAZYLEN(result))
				result = list(span_notice("<i>I examine [examinify] closer, but find nothing of interest...</i>"))
			handle_eye_contact(examinify)
		else
			result = examinify.examine(src)
			client.recent_examines[ref_to_atom] = world.time // set the value to when the examine cooldown ends
			addtimer(CALLBACK(src, .proc/clear_from_recent_examines, ref_to_atom), RECENT_EXAMINE_MAX_WINDOW)
			handle_eye_contact(examinify)
	else
		result = examinify.examine(src) // if a tree is examined but no client is there to see it, did the tree ever really exist?

	if(result)
		to_chat(src, "<span class='infoplain'><div class='infobox'>[result.Join("\n")]</div></span>")

///Attributes
/mob/proc/AttributeInitialize()
	attributes = new attributes(src)

///Adjust the hydration of a mob
/mob/proc/adjust_hydration(change)
	hydration = max(0, hydration + change)

///Force set the mob hydration
/mob/proc/set_hydration(change)
	hydration = max(0, change)
