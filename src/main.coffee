memory = require 'memory'
spawner = require 'spawner'

roles =
	harvester: require('harvester').run
	upgrader: require('upgrader').run
	builder: require('builder').run
	repairer: require('repairer').run

module.exports.loop = ->
	memory.clear

	spawner.setMax 10

	spawner.spawn 'harvester', 'harverester2', 4, [WORK,WORK,WORK,MOVE,MOVE,MOVE,MOVE,CARRY,CARRY]
	spawner.spawn 'upgrader', 'upgrader1', 1, [WORK,WORK,WORK,MOVE,MOVE,MOVE,MOVE,CARRY,CARRY]
	spawner.spawn 'builder', 'builder1', 2, [WORK,WORK,WORK,MOVE,MOVE,MOVE,MOVE,CARRY,CARRY]
	spawner.spawn 'repairer', 'repairer1', 3, [WORK,WORK,WORK,MOVE,MOVE,MOVE,MOVE,CARRY,CARRY]

	for name,creep of Game.creeps	
		roles[creep.memory.role]?(creep)
