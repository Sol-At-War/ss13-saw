/datum/controller/subsystem/economy
	var/list/department_values = list(
		ACCOUNT_MASTER = 500 DOLLARS,
		ACCOUNT_CAR = 200 DOLLARS,
	)
	department_accounts = list(
		ACCOUNT_MASTER = ACCOUNT_MASTER_NAME,
		ACCOUNT_CAR = ACCOUNT_CAR_NAME,
	)
	mail_blocked = TRUE

/datum/controller/subsystem/economy/Initialize(timeofday)
	if(time2text(world.timeofday, "DDD") == SUNDAY)
		mail_blocked = TRUE
	for(var/account in department_accounts)
		new /datum/bank_account/department(account, department_values[account])
	return ..()
