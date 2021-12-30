/obj/item/organ/tendon/r_arm
	name = "right distal biceps tendon"
	zone = BODY_ZONE_R_ARM

/obj/item/organ/tendon/r_arm/robot
	name = "cyborg left distal biceps tendon"
	icon_state = "tendon-c"
	base_icon_state = "tendon-c"
	status = ORGAN_ROBOTIC
	organ_flags = ORGAN_SYNTHETIC|ORGAN_LIMB_SUPPORTER|ORGAN_INDESTRUCTIBLE|ORGAN_NO_VIOLENT_DAMAGE

/obj/item/organ/tendon/r_arm/robot/get_wound_resistance(wounding_type = WOUND_BLUNT)
	if(wounding_type == WOUND_TENDON)
		return -5
