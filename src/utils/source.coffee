module.exports =

	shouldHarvest: (creep, lowThreshold = 0.1, fullThreshold = 1.0) ->
		creep.memory.lowEnergy = false if creep.carry.energy >= (creep.carryCapacity * fullThreshold)

		if creep.carry.energy < (creep.carryCapacity * lowThreshold)
			creep.memory.lowEnergy = true			
		return creep.memory.lowEnergy

	moveToSource: (creep) ->

		allTargets = []

		targets = creep.room.find FIND_DROPPED_RESOURCES
		if targets.length
			allTargets = allTargets.concat targets

		targets = creep.room.find FIND_STRUCTURES, {
			filter: (s) => s.structureType is STRUCTURE_CONTAINER and s.store[RESOURCE_ENERGY] > 0 
		}

		if targets.length
			allTargets = allTargets.concat targets	

		targets = creep.room.find FIND_SOURCES, {
			filter: (s) => s.energy > 0 
		}	

		if targets.length
			allTargets = allTargets.concat targets

		target = creep.pos.findClosestByPath allTargets
		if target 
			creep.moveTo target
			if target.amount # dropped resource
				creep.say "pickup"
				creep.pickup target 
			else if target.energy # source
				creep.say "harvest"
				creep.harvest target
			else if target.store
				creep.say "withdraw"
				creep.withdraw target, RESOURCE_ENERGY
			else
				console.log "Unknown sourec to pick up energy from!"
		else
			console.log "No source targets"