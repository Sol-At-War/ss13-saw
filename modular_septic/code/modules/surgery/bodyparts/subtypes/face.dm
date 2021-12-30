/obj/item/bodypart/face
	name = "face"
	desc = "You're face, to face, with the man who sold the world."
	icon = 'modular_septic/icons/obj/items/surgery.dmi'
	icon_state = "face"
	base_icon_state = "face"
	worn_icon = 'modular_septic/icons/mob/clothing/unsorted.dmi'
	worn_icon_state = "blank"
	max_damage = 30
	max_stamina_damage = 30
	parent_body_zone = BODY_ZONE_HEAD
	body_zone = BODY_ZONE_PRECISE_FACE
	body_part = FACE
	w_class = WEIGHT_CLASS_SMALL // Basically a flap of skin
	px_x = 0
	px_y = -8
	stam_damage_coeff = 1
	maxdam_wound_penalty = 10 // too easy to hit max damage
	limb_flags = (BODYPART_EDIBLE|BODYPART_NO_STUMP)

	max_cavity_item_size = WEIGHT_CLASS_SMALL
	max_cavity_volume = 1

	hit_modifier = -2
	hit_zone_modifier = -1

	amputation_point_name = "head"

	throw_range = 2 //not very aerodynamic
	dismemberment_sounds = list('modular_septic/sound/gore/severed.ogg')
	scars_covered_by_clothes = FALSE

	flags_inv = HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	body_parts_covered = HEAD|FACE|JAW
	slot_flags = ITEM_SLOT_MASK

	deflect_zone = BODY_ZONE_HEAD
	deflect_chance = 50

	// ~limb appearance info
	/// Replacement name
	var/real_name = ""
	/// Left eye
	var/obj/item/bodypart/l_eyesocket/left_eye
	/// Right eye
	var/obj/item/bodypart/r_eyesocket/right_eye
	/// Jaw
	var/obj/item/bodypart/mouth/jaw

/obj/item/bodypart/face/update_icon_dropped()
	icon_state = base_icon_state
	cut_overlays()

/obj/item/bodypart/face/get_limb_icon(dropped)
	return

/obj/item/bodypart/face/get_shock(painkiller_included, nerve_included)
	nerve_included = FALSE
	return ..()

/obj/item/bodypart/face/transfer_to_limb(obj/item/bodypart/new_limb, mob/living/carbon/phantom_owner)
	. = ..()
	if(istype(new_limb, /obj/item/bodypart/head))
		var/obj/item/bodypart/head/head = new_limb
		head.face = src

/obj/item/bodypart/face/receive_damage(brute = 0, \
									burn = 0, \
									stamina = 0, \
									blocked = 0, \
									updating_health = TRUE, \
									required_status = null, \
									wound_bonus = 0, \
									bare_wound_bonus = 0, \
									sharpness = NONE, \
									organ_bonus = 0, \
									bare_organ_bonus = 0)
	. = ..()
	if(owner)
		if((burn_dam + burn >= max_damage) && !HAS_TRAIT_FROM(owner, TRAIT_DISFIGURED, BURN))
			owner.visible_message(span_danger("<b>[owner]'s face turns into an unrecognizable, burnt mess!</b>"), \
								span_userdanger("<b>MY FACE MELTS AWAY!</b>"))
			ADD_TRAIT(owner, TRAIT_DISFIGURED, BURN)
			ADD_TRAIT(src, TRAIT_DISFIGURED, BURN)
		if((brute_dam + brute >= max_damage) && !HAS_TRAIT_FROM(owner, TRAIT_DISFIGURED, BRUTE))
			owner.visible_message(span_danger("<b>[owner]'s face turns into an unrecognizable, swollen mess!</b>"), \
								span_userdanger("<b>MY FACE IS MANGLED!</b>"))
			ADD_TRAIT(owner, TRAIT_DISFIGURED, BRUTE)
			ADD_TRAIT(src, TRAIT_DISFIGURED, BRUTE)

/obj/item/bodypart/face/on_rotten_trait_gain(obj/item/bodypart/source)
	. = ..()
	if(owner)
		ADD_TRAIT(owner, TRAIT_DISFIGURED, GERM_LEVEL)
	ADD_TRAIT(src, TRAIT_DISFIGURED, GERM_LEVEL)

/obj/item/bodypart/face/on_rotten_trait_loss(obj/item/bodypart/source)
	. = ..()
	if(owner)
		REMOVE_TRAIT(owner, TRAIT_DISFIGURED, GERM_LEVEL)
	REMOVE_TRAIT(src, TRAIT_DISFIGURED, GERM_LEVEL)

/obj/item/bodypart/face/attach_limb(mob/living/carbon/new_owner, special = FALSE, ignore_parent = FALSE)
	// These are stored before calling super- This is so that if the head is from a different body, it persists its appearance.
	var/real_name = src.real_name

	. = ..()
	if(!.)
		return

	if(real_name)
		new_owner.real_name = real_name

	real_name = ""
	name = initial(name)

	//Add disfigured trait as needed
	if(HAS_TRAIT_FROM(src, TRAIT_DISFIGURED, BRUTE))
		ADD_TRAIT(new_owner, TRAIT_DISFIGURED, BRUTE)
	if(HAS_TRAIT_FROM(src, TRAIT_DISFIGURED, BURN))
		ADD_TRAIT(new_owner, TRAIT_DISFIGURED, BURN)
	if(HAS_TRAIT_FROM(src, TRAIT_DISFIGURED, GERM_LEVEL))
		ADD_TRAIT(new_owner, TRAIT_DISFIGURED, GERM_LEVEL)

	if(!(new_owner.status_flags & BUILDING_ORGANS))
		new_owner.updatehealth()
		new_owner.update_body()
		new_owner.update_hair()
		new_owner.update_damage_overlays()
		new_owner.update_name()

/obj/item/bodypart/face/dismember(dam_type = BRUTE, silent = TRUE, destroy = FALSE, wounding_type = WOUND_SLASH)
	var/obj/item/bodypart/head = owner?.get_bodypart(parent_body_zone)
	if(head)
		return head.dismember(dam_type, silent, destroy, wounding_type)
	else
		return ..()

/obj/item/bodypart/face/drop_limb(special, dismembered, ignore_children, destroyed, wounding_type = WOUND_SLASH)
	var/mob/old_owner = owner
	if(!special)
		//Drop all worn face items
		for(var/X in list(owner.wear_mask))
			var/obj/item/item = X
			owner.dropItemToGround(item, force = TRUE)
		//Remove disfigured trait, update_name() checks for having no face lol
		REMOVE_TRAIT(owner, TRAIT_DISFIGURED, BRUTE)
		REMOVE_TRAIT(owner, TRAIT_DISFIGURED, BURN)
		REMOVE_TRAIT(owner, TRAIT_DISFIGURED, GERM_LEVEL)
	. = ..()
	if(!(old_owner.status_flags & BUILDING_ORGANS))
		old_owner.update_name()

/obj/item/bodypart/face/update_limb(dropping_limb, mob/living/carbon/source)
	. = ..()
	if(!owner)
		name = initial(name)
		if(real_name)
			name = "[real_name]'s face"
	else
		name = initial(name)

	if(istype(loc, /obj/item/bodypart/head))
		var/obj/item/bodypart/head/head = loc
		head.update_limb(dropping_limb, source)

	if(no_update)
		return

	var/mob/living/carbon/carbon
	if(source)
		carbon = source
	else
		carbon = owner

	real_name = carbon?.real_name
	if( (carbon && (HAS_TRAIT(carbon, TRAIT_HUSK) || HAS_TRAIT(carbon, TRAIT_DISFIGURED)) ) || HAS_TRAIT(src, TRAIT_HUSK) || HAS_TRAIT(src, TRAIT_DISFIGURED))
		real_name = "Unknown"

/obj/item/bodypart/face/worn_overlays(mutable_appearance/standing, isinhands, icon_file)
	if(!isinhands)
		return get_worn_limb_icon()
	else
		return ..()

/obj/item/bodypart/face/equipped(mob/user, slot, initial)
	. = ..()
	user.update_name()

/obj/item/bodypart/face/dropped(mob/user, silent)
	. = ..()
	user.update_name()

/obj/item/bodypart/face/damage_integrity(wounding_type, wounding_dmg, wound_bonus, bare_wound_bonus)
	return FALSE

/obj/item/bodypart/face/proc/get_worn_limb_icon()
	. = list()

	var/image/limb = image(layer = -render_layer)
	var/image/aux
	. += limb

	if(animal_origin)
		if(is_organic_limb())
			limb.icon = DEFAULT_BODYPART_ICON_ANIMAL
			if(species_id == "husk")
				limb.icon_state = "[animal_origin]_husk_[body_zone]"
			else
				limb.icon_state = "[animal_origin]_[body_zone]"
		else
			limb.icon = DEFAULT_BODYPART_ICON_ROBOTIC
			limb.icon_state = "[animal_origin]_[body_zone]"
		return

	var/icon_gender = (body_gender == FEMALE) ? "f" : "m" //gender of the icon, if applicable

	if(!gender_rendering)
		should_draw_gender = FALSE

	if(advanced_rendering)
		if(should_draw_greyscale)
			limb.icon = render_icon || DEFAULT_BODYPART_ICON_ORGANIC
			if(should_draw_gender)
				limb.icon_state = "[species_id]_[body_zone]_[icon_gender]"
			else if(use_digitigrade)
				limb.icon_state = "digitigrade_[use_digitigrade]_[body_zone]"
			else
				limb.icon_state = "[species_id]_[body_zone]"
		else
			limb.icon = render_icon || DEFAULT_BODYPART_ICON
			if(should_draw_gender)
				limb.icon_state = "[species_id]_[body_zone]_[icon_gender]"
			else
				limb.icon_state = "[species_id]_[body_zone]"
	else
		limb.icon = icon
		limb.icon_state = "[BODY_ZONE_HEAD]" //Inorganic limbs are agender
		return

	if(should_draw_greyscale)
		var/draw_color = mutation_color || species_color || skintone2hex(skin_tone)
		if(draw_color)
			limb.color = sanitize_hexcolor(draw_color, 6, TRUE)
			if(aux)
				aux.color = limb.color

	if (!owner || is_pseudopart || is_stump() || HAS_TRAIT(src, TRAIT_ROTTEN) || !ishuman(owner))
		return

	var/mob/living/carbon/human/human = owner
	//set specific alpha before setting the markings alpha
	if(alpha != 255)
		for(var/ov in .)
			var/image/overlay = ov
			overlay.alpha = alpha

	if(!LAZYLEN(body_markings))
		return

	//Markings!
	var/override_color
	if(HAS_TRAIT(human, TRAIT_HUSK) || HAS_TRAIT(src, TRAIT_HUSK))
		override_color = "888888"

	for(var/name in body_markings["[BODY_ZONE_HEAD]"])
		var/datum/body_marking/marking = GLOB.body_markings[name]
		var/render_limb_string = BODY_ZONE_HEAD
		if(use_digitigrade)
			render_limb_string = "digitigrade_[use_digitigrade]_[render_limb_string]"

		if(marking.gendered && gender_rendering)
			var/marking_gender = (human.body_type == FEMALE) ? "f" : "m"
			render_limb_string = "[render_limb_string]_[marking_gender]"

		var/mutable_appearance/accessory_overlay = mutable_appearance(marking.icon, "[marking.icon_state]_[render_limb_string]", -BODY_ADJ_LAYER)
		if(body_zone in list(BODY_ZONE_PRECISE_R_HAND, BODY_ZONE_PRECISE_L_HAND))
			accessory_overlay.layer = -HANDS_ADJ_LAYER
		if(override_color)
			accessory_overlay.color = sanitize_hexcolor(override_color, 6, TRUE)
		else
			accessory_overlay.color = sanitize_hexcolor(body_markings[body_zone][name], 6, TRUE)
		accessory_overlay.alpha = markings_alpha
		. += accessory_overlay
