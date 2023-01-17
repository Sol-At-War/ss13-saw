/obj/machinery/door
	/// Should we auto align on initialization?
	var/auto_align = TRUE
	/// Key cooldown
	COOLDOWN_DECLARE(key_cooldown)
	// Key cooldown duration
	var/key_cooldown_duration = 1 SECONDS
	/// Key worthy
	var/key_worthy = FALSE

/obj/machinery/door/examine(mob/user)
	. = ..()
	. += span_notice("[p_their(TRUE)] maintenance panel is <b>screwed</b> in place.")

// Machinery always returns INITIALIZE_HINT_LATELOAD
/obj/machinery/door/LateInitialize(mapload = FALSE)
	. = ..()
	if(LAZYLEN(req_access) || LAZYLEN(req_one_access) || LAZYLEN(text2access(req_access_txt)) || LAZYLEN(text2access(req_one_access_txt)))
		lock()
	if(auto_align && mapload)
		auto_align()

/obj/machinery/door/attackby(obj/item/I, mob/living/user, params)
	if(!COOLDOWN_FINISHED(src, key_cooldown))
		to_chat(user, span_warning("I need to calm down."))
		return
	if(istype(I, /obj/item/key) && key_worthy)
		if(I?.allowed(user, I)) //I...?
			var/lock_status = "unlock"
			if(!locked)
				lock_status = "lock"
			to_chat(user, span_notice("I [lock_status] the [src] with the [I]."))
			playsound(src, 'modular_septic/sound/effects/keys_use.wav', 75, FALSE)
			try_door_unlock(user)
		else
			to_chat(user, span_warning("Wrong key."))
			playsound(src, 'modular_septic/sound/effects/keys_remove.ogg', 75, FALSE)
		add_fingerprint(user)
		sound_hint()
		COOLDOWN_START(src, key_cooldown, key_cooldown_duration)
		return TRUE
	return ..()

/obj/machinery/door/allowed(mob/M, obj/item/key/key)
	if(key?.door_allowed(src))
		return TRUE
	return ..()

/obj/machinery/door/proc/try_door_unlock(user)
	if(allowed(user))
		if(locked)
			unlock()
		else
			lock()
	else if(density)
		do_animate("deny")
	return TRUE
