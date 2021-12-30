/obj/item/organ/tendon/l_leg
	name = "left cruciate ligament"
	zone = BODY_ZONE_L_LEG

/obj/item/organ/tendon/l_leg/robot
	name = "cyborg left cruciate ligament"
	icon_state = "tendon-c"
	base_icon_state = "tendon-c"
	status = ORGAN_ROBOTIC
	organ_flags = ORGAN_SYNTHETIC|ORGAN_LIMB_SUPPORTER|ORGAN_INDESTRUCTIBLE|ORGAN_NO_VIOLENT_DAMAGE

/obj/item/organ/tendon/l_leg/robot/get_wound_resistance(wounding_type = WOUND_BLUNT)
	if(wounding_type == WOUND_TENDON)
		return -5
