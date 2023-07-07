//This is where pistols, revolvers, and other miscellaneous personal defense weapons are stored.
//These guns inherit code from existing Nevado items temporarily while we set up our own bullet types, magazines, et cetera

/obj/item/gun/ballistic/automatic/pistol/saw
	name = "\improper Pistol template"
	desc = "A small, easily concealable handgun. Has a threaded barrel for suppressors."
	icon = 'modular_septic/icons/obj/items/guns/pistol.dmi' //temporary
	icon_state = "ruger" //temporary
	base_icon_state = "ruger" //temporary
	pickup_sound = 'modular_septic/sound/weapons/guns/pistol/pistol_draw.wav'
	lock_back_sound = 'modular_septic/sound/weapons/guns/pistol/pistol_lockback.wav'
	bolt_drop_sound = 'modular_septic/sound/weapons/guns/pistol/pistol_lockin.wav'
	eject_sound = 'modular_septic/sound/weapons/guns/pistol/pistol_magout.wav'
	eject_empty_sound = 'modular_septic/sound/weapons/guns/pistol/pistol_magout.wav'
	eject_sound_vary = FALSE
	rack_sound_vary = FALSE
	load_sound = 'modular_septic/sound/weapons/guns/pistol/pistol_magin.wav'
	load_empty_sound = 'modular_septic/sound/weapons/guns/pistol/pistol_magin.wav'
	rack_sound = 'modular_septic/sound/weapons/guns/pistol/pistol_rack.wav'
	gunshot_animation_information = list(
		"pixel_x" = 15, \
		"pixel_y" = 1, \
		"inactive_wben_suppressed" = TRUE, \
	)
	recoil_animation_information = list(
		"recoil_angle_upper" = -15, \
		"recoil_angle_lower" = -30, \
	)
	suppressor_x_offset = 10
	w_class = WEIGHT_CLASS_NORMAL
	carry_weight = 1 KILOGRAMS

          //INTERSOL MARINE CORPS

//BERETTA T-3
/obj/item/gun/ballistic/automatic/pistol/saw/beretta
	name = "\improper Beretta T-3 Accensus"
  desc = "A reliable Solarian high-capacity machine pistol able to deliver brutal blows. It's the standard sidearm of the ISMC. \
		  Printed on the side is ''Fabbrica d'Armi Pietro Beretta, 2697 - 7×33MM'' and ''Farita In Mercurio''."
	icon = 'modular_septic/icons/obj/items/guns/pistol.dmi' //temporary
	icon_state = "ruger" //temporary
	base_icon_state = "ruger" //temporary
  can_suppress = FALSE

/obj/item/gun/ballistic/automatic/pistol/saw/beretta/prestige
  name = "\improper Beretta T-3 Rex"
  desc = "A modified T-3 machine pistol with a heavy barrel and fully automatic fire. \
		  Printed on the side is ''Fabbrica d'Armi Pietro Beretta, 2701 - 7×33MM'' and ''Farita In Mercurio''."

        //CIVILIAN, POLICE, REBEL
/obj/item/gun/ballistic/automatic/pistol/saw/plutonian
	name = "\improper Yacuíba Personal Defense"
	desc = "A small, easily concealable handgun. Has a threaded barrel for suppressors."

/obj/item/gun/ballistic/automatic/pistol/saw/chengkastiryev
	name = "\improper Cheng-Kastiryev Cal. CDLX"
	desc = "A small, easily concealable handgun. Has a threaded barrel for suppressors."

/obj/item/gun/ballistic/automatic/pistol/saw/police
	name = "\improper Yacuíba Service"
	desc = "A small, easily concealable handgun. Has a threaded barrel for suppressors."
