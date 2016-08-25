memory = require 'memory'
spawner = require 'spawner'
roleHarverster = require 'harvester'
module.exports.loop = ->
	memory.clear
	spawner.spawn 'harvester', 'harverester1', [WORK,WORK,WORK,MOVE,MOVE,MOVE,MOVE,CARRY,CARRY]

	for name,creep of Game.creeps	
		roleHarverster.run(creep) if creep.memory.role is 'harvester'
