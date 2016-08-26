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

	curRoom = Game.rooms['E26S52']

	body = [WORK,MOVE,CARRY]
	if curRoom.energyCapacityAvailable > 400
		body = [WORK,WORK,MOVE,MOVE,CARRY,CARRY]
	if curRoom.energyCapacityAvailable > 500
		body = [WORK,WORK,WORK,MOVE,MOVE,CARRY,CARRY]
	if curRoom.energyCapacityAvailable > 600
		body = [WORK,WORK,WORK,MOVE,MOVE,MOVE,CARRY,CARRY,CARRY]


	optimalRoad = roads.getOptimalRoadPlacement curRoom

	if optimalRoad and optimalRoad.value > 40
		curRoom.createConstructionSite optimalRoad.x, optimalRoad.y, STRUCTURE_ROAD

	info.roomEnergy()
	info.activeCreep ['harverester1','upgrader1','builder1','repairer1']
	memory.clear()
	spawner.clear()

	spawner.setMax 14

	spawner.spawn 'harvester', 'harverester1', 4, body #[WORK,WORK,WORK,MOVE,MOVE,MOVE,MOVE,MOVE,MOVE,CARRY,CARRY,CARRY,CARRY]
	spawner.spawn 'upgrader', 'upgrader1', 4 ,body # [WORK,WORK,WORK,MOVE,MOVE,MOVE,MOVE,MOVE,MOVE,CARRY,CARRY,CARRY,CARRY]
	spawner.spawn 'builder', 'builder1', 4 ,body # [WORK,WORK,WORK,MOVE,MOVE,MOVE,MOVE,MOVE,MOVE,CARRY,CARRY,CARRY,CARRY]
	spawner.spawn 'repairer', 'repairer1', 2 ,body # [WORK,WORK,WORK,MOVE,MOVE,MOVE,MOVE,MOVE,MOVE,CARRY,CARRY,CARRY,CARRY]

	for name,creep of Game.creeps		
		roles[creep.memory.role]?(creep)

	#towerer.run Game.getObjectById '57bcdc0b4cf378880210e747'