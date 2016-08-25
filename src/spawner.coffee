module.exports =
	
	spawn: (role, type, body = [WORK, CARRY, MOVE]) ->

		spawn = Game.spawns['Spawn1'].createCreep body, undefined, 
			{
				role: role
				type: type
			}
		return true if spawn is OK

