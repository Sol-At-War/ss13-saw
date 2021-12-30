/obj/item/organ/tendon/head
	name = "frontalis muscle"
	zone = BODY_ZONE_HEAD

/obj/item/organ/tendon/head/robot
	name = "cyborg frontalis muscle"
	icon_state = "tendon-c"
	base_icon_state = "tendon-c"
	status = ORGAN_ROBOTIC
	organ_flags = ORGAN_SYNTHETIC|ORGAN_LIMB_SUPPORTER|ORGAN_INDESTRUCTIBLE|ORGAN_NO_VIOLENT_DAMAGE

/obj/item/organ/tendon/head/robot/get_wound_resistance(wounding_type = WOUND_BLUNT)
	if(wounding_type == WOUND_TENDON)
		return -5
