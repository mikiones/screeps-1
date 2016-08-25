total = 4
module.exports =
	
	setMax: (max) -> total = max

	spawn: (role, type, max, body = [WORK, CARRY, MOVE], location = 'Spawn1') ->

		count = Object.keys(Game.creeps).length 
		return false if count > total

		count =  Object.keys(creep for creep in Game.creeps when creep.memory.type is type).length 
		return false if count > max

		spawn = Game.spawns[location].createCreep body, undefined, {
			role: role
			type: type
		}
		return true if spawn is OK	
