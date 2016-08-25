memory = require 'memory'
spawner = require 'spawner'
info = require 'info'
towerer = require('towerer')
roads = require('roads')

roles =
	harvester: require('harvester').run
	upgrader: require('upgrader').run
	builder: require('builder').run
	repairer: require('repairer').run

module.exports.loop = ->

	roads.gatherInfo()

	curRoom = Game.rooms['W52S47']

	optimalRoad = roads.getOptimalRoadPlacement curRoom

	if optimalRoad.value > 30
		curRoom.createConstructionSite optimalRoad.x, optimalRoad.y, STRUCTURE_ROAD

	info.roomEnergy()
	info.activeCreep ['harverester2','upgrader1','builder1','repairer1']
	memory.clear()
	spawner.clear()

	spawner.setMax 13

	spawner.spawn 'harvester', 'harverester2', 4, [WORK,WORK,WORK,MOVE,MOVE,MOVE,MOVE,MOVE,MOVE,CARRY,CARRY,CARRY,CARRY]
	spawner.spawn 'upgrader', 'upgrader1', 3, [WORK,WORK,WORK,MOVE,MOVE,MOVE,MOVE,MOVE,MOVE,CARRY,CARRY,CARRY,CARRY]
	spawner.spawn 'builder', 'builder1', 3, [WORK,WORK,WORK,MOVE,MOVE,MOVE,MOVE,MOVE,MOVE,CARRY,CARRY,CARRY,CARRY]
	spawner.spawn 'repairer', 'repairer1', 3, [WORK,WORK,WORK,MOVE,MOVE,MOVE,MOVE,MOVE,MOVE,CARRY,CARRY,CARRY,CARRY]

	for name,creep of Game.creeps		
		roles[creep.memory.role]?(creep)

	towerer.run Game.getObjectById '57bcdc0b4cf378880210e747'