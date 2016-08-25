memory = require 'memory'
spawner = require 'spawner'
info = require 'info'
towerer = require('towerer')

roles =
	harvester: require('harvester').run
	upgrader: require('upgrader').run
	builder: require('builder').run
	repairer: require('repairer').run

module.exports.loop = ->

	info.roomEnergy()
	info.activeCreep ['harverester2','upgrader1','builder1','repairer1']
	memory.clear()
	spawner.clear()

	spawner.setMax 10

	spawner.spawn 'harvester', 'harverester2', 4, [WORK,WORK,MOVE,MOVE,MOVE,MOVE,CARRY,CARRY]
	spawner.spawn 'upgrader', 'upgrader1', 1, [WORK,WORK,MOVE,MOVE,MOVE,MOVE,CARRY,CARRY]
	spawner.spawn 'builder', 'builder1', 2, [WORK,WORK,MOVE,MOVE,MOVE,MOVE,CARRY,CARRY]
	spawner.spawn 'repairer', 'repairer1', 3, [WORK,WORK,MOVE,MOVE,MOVE,MOVE,CARRY,CARRY]

	for name,creep of Game.creeps		
		roles[creep.memory.role]?(creep)

	towerer.run Game.getObjectById '57bcdc0b4cf378880210e747'