/obj/item/grenade
	drop_sound = 'modular_septic/sound/weapons/grenade.wav'
	pickup_sound = 'modular_septic/sound/weapons/grenade_draw.wav'
	item_flags = NO_PIXEL_RANDOM_DROP
	tetris_width = 32
	tetris_height = 32
	var/pin_sound = 'modular_septic/sound/weapons/grenade_pin.wav'
	var/obj/item/pin/Pin

/obj/item/pin
	name = "grenade pin"
	desc = "The detonation pin of a grenade, usually found on a grenade before It's armed."
	icon = 'modular_septic/icons/obj/items/grenade.dmi'
	icon_state = "pin"
	w_class = WEIGHT_CLASS_TINY

/obj/item/grenade/Initialize(mapload)
	. = .()
	Pin = new /obj/item/pin(src)

/obj/item/grenade/MouseDrop(atom/over, src_location, over_location, src_control, over_control, params)
	. = ..()
	if(!isliving(usr) || !usr.Adjacent(src) || usr.incapacitated())
		return
	var/mob/living/user = usr
	if(istype(over, /atom/movable/screen/inventory/hand))
		if(!active)
			if(Pin in src)
				usr.put_in_hands(Pin)
				arm_grenade(usr)

/obj/item/grenade/attack_self(mob/user)
	if(HAS_TRAIT(src, TRAIT_NODROP))
		to_chat(user, span_notice("You try prying [src] off your hand..."))
		if(do_after(user, 7 SECONDS, target=src))
			to_chat(user, span_notice("You manage to remove [src] from your hand."))
			REMOVE_TRAIT(src, TRAIT_NODROP, STICKY_NODROP)
		return

//This is purely to change the pin sound for ALL grenades.
/obj/item/grenade/arm_grenade(mob/user, delayoverride, msg = TRUE, volume = 60)
	log_grenade(user)
	if(user)
		add_fingerprint(user)
		if(msg)
			to_chat(user, span_warning("I prime [src]! [capitalize(DisplayTimeText(det_time))]!"))
	if(shrapnel_type && shrapnel_radius)
		shrapnel_initialized = TRUE
		AddComponent(/datum/component/pellet_cloud, projectile_type=shrapnel_type, magnitude=shrapnel_radius)
	playsound(src, pin_sound, volume, TRUE)
	if(istype(user))
		user.mind?.add_memory(MEMORY_BOMB_PRIMED, list(DETAIL_BOMB_TYPE = src), story_value = STORY_VALUE_OKAY)
	active = TRUE
	icon_state = "[initial(icon_state)]_active"
	SEND_SIGNAL(src, COMSIG_GRENADE_ARMED, det_time, delayoverride)
	addtimer(CALLBACK(src, .proc/detonate), isnull(delayoverride)? det_time : delayoverride)
