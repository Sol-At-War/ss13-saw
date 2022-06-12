/obj/item/storage/box/slugshot
	name = "box of lethal shotgun slugs"
	desc = "A box full of lethal slugs, designed for riot shotguns."
	icon_state = "lethalshot_box"
	illustration = null

/obj/item/storage/box/slugshot/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/ammo_casing/shotgun(src)

/obj/item/storage/box/a357
	name = "boxed .375 ammunition"
	desc = "According to the label on the side, this box contains 36 total rounds of .357"
	icon = 'icons/obj/storage.dmi'
	icon_state = "secbox"
	illustration = null

/obj/item/storage/box/a357/PopulateContents()
	var/static/items_inside = list(
		/obj/item/ammo_box/magazine/ammo_stack/a357/loaded,
		/obj/item/ammo_box/magazine/ammo_stack/a357/loaded,
		/obj/item/ammo_box/magazine/ammo_stack/a357/loaded)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/a9mm
	name = "boxed 9mm ammunition"
	desc = "According to the label on the side, this box contains 36 total rounds of 9mm"
	icon = 'icons/obj/storage.dmi'
	icon_state = "secbox"
	illustration = null

/obj/item/storage/box/a9mm/PopulateContents()
	var/static/items_inside = list(
		/obj/item/ammo_box/magazine/ammo_stack/c9mm/loaded,
		/obj/item/ammo_box/magazine/ammo_stack/c9mm/loaded,
		/obj/item/ammo_box/magazine/ammo_stack/c9mm/loaded)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/a38
	name = "boxed .38 ammunition"
	desc = "According to the label on the side, this box contains 36 total rounds of .38"
	icon = 'icons/obj/storage.dmi'
	icon_state = "secbox"
	illustration = null

/obj/item/storage/box/a38/PopulateContents()
	var/static/items_inside = list(
		/obj/item/ammo_box/magazine/ammo_stack/c38/loaded,
		/obj/item/ammo_box/magazine/ammo_stack/c38/loaded,
		/obj/item/ammo_box/magazine/ammo_stack/c38/loaded)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/a500
	name = "boxed .500 ammunition"
	desc = "According to the label on the side, this box contains 36 total rounds of .500"
	icon = 'icons/obj/storage.dmi'
	icon_state = "secbox"
	illustration = null

/obj/item/storage/box/a500/PopulateContents()
	var/static/items_inside = list(
		/obj/item/ammo_box/magazine/ammo_stack/a500/loaded,
		/obj/item/ammo_box/magazine/ammo_stack/a500/loaded,
		/obj/item/ammo_box/magazine/ammo_stack/a500/loaded)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/a38/pluspee
	name = "boxed .38 +P ammunition"
	desc = "According to the label on the side, this box contains 36 total rounds of .38 +P"
	icon = 'icons/obj/storage.dmi'
	icon_state = "secbox"
	illustration = null

/obj/item/storage/box/a38/pluspee/PopulateContents()
	var/static/items_inside = list(
		/obj/item/ammo_box/magazine/ammo_stack/c38/pluspee/loaded,
		/obj/item/ammo_box/magazine/ammo_stack/c38/pluspee/loaded,
		/obj/item/ammo_box/magazine/ammo_stack/c38/pluspee/loaded)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/a45
	name = "boxed .45 ammunition"
	desc = "According to the label on the side, this box contains 36 total rounds of .45"
	icon = 'icons/obj/storage.dmi'
	icon_state = "secbox"
	illustration = null

/obj/item/storage/box/a45/PopulateContents()
	var/static/items_inside = list(
		/obj/item/ammo_box/magazine/ammo_stack/c45/loaded,
		/obj/item/ammo_box/magazine/ammo_stack/c45/loaded,
		/obj/item/ammo_box/magazine/ammo_stack/c45/loaded)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/c545
	name = "boxed 5.45 ammunition"
	desc = "According to the label on the side, this box contains 64 total rounds of 5.45"
	icon = 'icons/obj/storage.dmi'
	icon_state = "secbox"
	illustration = null

/obj/item/storage/box/c545/PopulateContents()
	var/static/items_inside = list(
		/obj/item/ammo_box/magazine/ammo_stack/a545/loaded,
		/obj/item/ammo_box/magazine/ammo_stack/a545/loaded,
		/obj/item/ammo_box/magazine/ammo_stack/a545/loaded,
		/obj/item/ammo_box/magazine/ammo_stack/a545/loaded,
		/obj/item/ammo_box/magazine/ammo_stack/a545/loaded,
		/obj/item/ammo_box/magazine/ammo_stack/a545/loaded,
		/obj/item/ammo_box/magazine/ammo_stack/a545/loaded,
		/obj/item/ammo_box/magazine/ammo_stack/a545/loaded)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/c762
	name = "boxed 7.62 ammunition"
	desc = "According to the label on the side, this box contains 64 total rounds of 7.62"
	icon = 'icons/obj/storage.dmi'
	icon_state = "secbox"
	illustration = null

/obj/item/storage/box/c762/PopulateContents()
	var/static/items_inside = list(
		/obj/item/ammo_box/magazine/ammo_stack/a762/loaded,
		/obj/item/ammo_box/magazine/ammo_stack/a762/loaded,
		/obj/item/ammo_box/magazine/ammo_stack/a762/loaded,
		/obj/item/ammo_box/magazine/ammo_stack/a762/loaded,
		/obj/item/ammo_box/magazine/ammo_stack/a762/loaded,
		/obj/item/ammo_box/magazine/ammo_stack/a762/loaded,
		/obj/item/ammo_box/magazine/ammo_stack/a762/loaded,
		/obj/item/ammo_box/magazine/ammo_stack/a762/loaded)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/c762x54
	name = "boxed 7.62x54R ammunition"
	desc = "According to the label on the side, this box contains 64 total rounds of 7.62x54R"
	icon = 'icons/obj/storage.dmi'
	icon_state = "secbox"
	illustration = null

/obj/item/storage/box/c762x54/PopulateContents()
	var/static/items_inside = list(
		/obj/item/ammo_box/magazine/ammo_stack/a762svd/loaded,
		/obj/item/ammo_box/magazine/ammo_stack/a762svd/loaded,
		/obj/item/ammo_box/magazine/ammo_stack/a762svd/loaded,
		/obj/item/ammo_box/magazine/ammo_stack/a762svd/loaded,
		/obj/item/ammo_box/magazine/ammo_stack/a762svd/loaded,
		/obj/item/ammo_box/magazine/ammo_stack/a762svd/loaded,
		/obj/item/ammo_box/magazine/ammo_stack/a762svd/loaded,
		/obj/item/ammo_box/magazine/ammo_stack/a762svd/loaded)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/c276
	name = "boxed .276 Federson ammunition"
	desc = "According to the label on the side, this box contains 64 total rounds of .276 Federson"
	icon = 'icons/obj/storage.dmi'
	icon_state = "secbox"
	illustration = null

/obj/item/storage/box/c276/PopulateContents()
	var/static/items_inside = list(
		/obj/item/ammo_box/magazine/ammo_stack/a276/loaded,
		/obj/item/ammo_box/magazine/ammo_stack/a276/loaded,
		/obj/item/ammo_box/magazine/ammo_stack/a276/loaded,
		/obj/item/ammo_box/magazine/ammo_stack/a276/loaded,
		/obj/item/ammo_box/magazine/ammo_stack/a276/loaded,
		/obj/item/ammo_box/magazine/ammo_stack/a276/loaded,
		/obj/item/ammo_box/magazine/ammo_stack/a276/loaded,
		/obj/item/ammo_box/magazine/ammo_stack/a276/loaded)
	generate_items_inside(items_inside,src)
