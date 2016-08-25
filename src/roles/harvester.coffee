module.exports =
	
	run: (creep) ->
		creep.memory.lowEnergy = creep.carry.energy < creep.carryCapacity / 10.0

		if creep.memory.lowEnergy
			creep say "Hungry!"
			target = creep.pos.findClosestByPath FIND_SOURCES, {
					filter: (s) => s.energy > 0
				}			
			if target and creep.harvest(target) is ERR_NOT_IN_RANGE
				creep.moveTo target
		else
			target = creep.pos.findClosestByPath FIND_STRUCTURES, {
					filter: (s) -> return s.structureType in [STRUCTURE_SPAWN, STRUCTURE_EXTENSION] and s.energy < s.energyCapacity
				}
			if target and creep.transfer(target) is ERR_NOT_IN_RANGE
				creep.moveTo target		
