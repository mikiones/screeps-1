module.exports = 

	run: (tower) ->
		return if not tower 

		target = tower.pos.findClosestByRange FIND_STRUCTURES, {
			filter: (s) -> return s.hits < 1000000 && s.structureType == STRUCTURE_WALL
		}

		if target 
			tower.repair(target)
