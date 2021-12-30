/obj/item/ammo_box/magazine/m9mm
	name = "pistol magazine (9mm)"
	icon = 'modular_septic/icons/obj/items/ammo/pistol.dmi'
	icon_state = "ruger9mm"
	base_icon_state = "ruger9mm"

/obj/item/ammo_box/magazine/m9mm_aps
	name = "pernetta 69r magazine (9mm)"
	icon = 'modular_septic/icons/obj/items/ammo/pistol.dmi'
	icon_state = "beretta9mm"
	base_icon_state = "beretta9mm"
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/ammo_box/magazine/m45
	name = "pistol magazine (.45)"
	icon = 'modular_septic/icons/obj/items/ammo/pistol.dmi'
	icon_state = "pistol45"
	base_icon_state = "pistol45"
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/ammo_box/magazine/m45/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]-[min(round(ammo_count(), 2), 8)]"

/obj/item/ammo_box/magazine/combatmaster9mm
	name = "frag master magazine (9mm)"
	icon = 'modular_septic/icons/obj/items/ammo/pistol.dmi'
	icon_state = "combatmaster9mm"
	base_icon_state = "combatmaster9mm"
	ammo_type = /obj/item/ammo_casing/c9mm
	caliber = CALIBER_9MM
	max_ammo = 20
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/ammo_box/magazine/glock9mm
	name = "gunk-17 magazine (9mm)"
	icon = 'modular_septic/icons/obj/items/ammo/pistol.dmi'
	icon_state = "pistol9mm"
	base_icon_state = "pistol9mm"
	ammo_type = /obj/item/ammo_casing/c9mm
	caliber = CALIBER_9MM
	max_ammo = 16
	multiple_sprites = AMMO_BOX_ONE_SPRITE

/obj/item/ammo_box/magazine/glock9mm/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]-[min(round(ammo_count(), 2), 16)]"

/obj/item/ammo_box/magazine/glock9mm/dick
	name = "gunk-17 DICK magazine (9mm)"
	icon = 'modular_septic/icons/obj/items/ammo/pistol.dmi'
	icon_state = "pistoldick9mm"
	base_icon_state = "pistoldick9mm"
	ammo_type = /obj/item/ammo_casing/c9mm
	caliber = CALIBER_9MM
	max_ammo = 33
	multiple_sprites = AMMO_BOX_ONE_SPRITE

/obj/item/ammo_box/magazine/glock9mm/dick/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]-[min(round(ammo_count(), 3), 33)]"

/obj/item/ammo_box/magazine/glock10mm
	name = "gunk-20 magazine (10mm)"
	icon = 'modular_septic/icons/obj/items/ammo/pistol.dmi'
	icon_state = "pistol10mm"
	base_icon_state = "pistol10mm"
	ammo_type = /obj/item/ammo_casing/c10mm
	caliber = CALIBER_10MM
	max_ammo = 8
	multiple_sprites = AMMO_BOX_ONE_SPRITE

/obj/item/ammo_box/magazine/glock10mm/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]-[min(round(ammo_count(), 2), 8)]"

/obj/item/ammo_box/magazine/ppk22lr
	name = "walter FT magazine (.22lr)"
	icon = 'modular_septic/icons/obj/items/ammo/pistol.dmi'
	icon_state = "ppk22lr"
	base_icon_state = "ppk22lr"
	ammo_type = /obj/item/ammo_casing/c22lr
	caliber = CALIBER_22LR
	max_ammo = 9
	multiple_sprites = AMMO_BOX_ONE_SPRITE

/obj/item/ammo_box/magazine/ppk22lr/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]-[min(round(ammo_count()), 9)]"
