total = 4
Memory.canMake = true
module.exports =
	
	setMax: (max) -> total = max

	clear: -> canMake = true

	spawn: (role, type, max, body = [WORK, CARRY, MOVE], location = 'Spawn1') ->

		return false if not Memory.canMake

		count = Object.keys(Game.creeps).length 
		return false if count > total

		members = _.filter Game.creeps, (creep) -> creep.memory.type is type	
		
		if not members or members.length < max			
			spawn = Game.spawns[location].createCreep body, undefined, {
				role: role
				type: type
			}

			if spawn is OK
				Memory.canMake = false
				return true
		return false
