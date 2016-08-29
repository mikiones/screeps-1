total = 4

queue = require 'priorityqueue'

roles = [
	{
		role: "harvester"
		body: [WORK,WORK,MOVE,CARRY,CARRY] # [WORK,WORK,WORK,MOVE,CARRY,MOVE,CARRY,MOVE]
		prio: 1
		min: 2
		max: 3
	}
	{
		role: "upgrader"
		body: [WORK,WORK,WORK,MOVE,CARRY,MOVE,CARRY,MOVE]
		prio: 3
		min: 1
		max: 2
	}
	{
		role: "builder"
		body: [WORK,WORK,WORK,MOVE,CARRY,MOVE,CARRY,MOVE]
		prio: 2
		min: 1
		max: 3
	}
	{
		role: "repairer"
		body: [WORK,WORK,WORK,MOVE,CARRY,MOVE,CARRY,MOVE]
		prio: 4
		min: 1		
		max: 2
	}
	{
		role: "defender"
		body: [TOUGH,TOUGH,ATTACK,TOUGH,TOUGH,ATTACK,MOVE,MOVE,TOUGH,TOUGH,TOUGH,TOUGH,TOUGH] #[WORK,WORK,WORK,MOVE,CARRY,MOVE,CARRY,MOVE]
		prio: 4
		min: 2		
		max: 2
	}
	{
		role: "healer"
		body: [HEAL,HEAL,MOVE]
		prio: 4
		min: 2		
		max: 2
	}
	{
		role: "transporter"
		body: [WORK,WORK,WORK,WORK,MOVE,CARRY,CARRY]
		prio: 1
		min: 1		
		max: 1
	}
	]

module.exports = self =
	
	setMax: (max) -> total = max

	evaluateSpawn: ->
		self.spawnImportant()

	spawnImportant: ->
		qTargets = new queue (a,b) ->	
			return b.prio - a.prio

		for role in roles
			qTargets.enq role

		bestRole = qTargets.deq()
		while bestRole and not self.spawn bestRole.role, bestRole.role, bestRole.max, bestRole.body
			break if qTargets.isEmpty()
			bestRole = qTargets.deq()

		if bestRole and not qTargets.isEmpty()
			console.log "Trying to spawn #{bestRole.role}"
		else
			console.log "Unabled to spawn anything"

		return		

	spawn: (role, type, max, body = [WORK, CARRY, MOVE, CARRY, MOVE], location = 'Spawn1') ->
		
		count = Object.keys(Game.creeps).length 
		if count > total
			console.log "Too many creep #{count} > #{total}"
			return false 

		members = _.filter Game.creeps, (creep) -> creep.memory.type is type	
	
		if not members or members.length < max			
			spawn = Game.spawns[location].createCreep body, undefined, {
				role: role
				type: type
			}

			if spawn < 0		
				#console.log "Failed to spawn #{role}, error = #{spawn}"				
			else
				#console.log "Spawning #{role}"		
				return true
				
		return false
