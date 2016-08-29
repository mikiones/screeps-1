TASK_BUILD = 	1
TASK_REPAIR = 	2

module.exports = self = 

	initialize: () ->			

		# stores pending tasks that are order by most important to least
		Memory.pendingTaskQueue = []

		Memory.taskIdCounter = Game.time


	cleanTasks: () ->
		self.initialize() if not Memory.pendingTaskQueue	

		# clean up pending tasks
		newPendingTasks = []
		for task in Memory.pendingTaskQueue
			continue if task.completed # don't copy tasks that are completed
			if task.active # make sure it is really active still, no deaths
				creep = Game.getObjectById(task.creepId)
				if not creep # the creep is no more, so mark the task as not active
					task.active = false
				else if creep.activeTaskID # make sure the assigned creep is still actively working on this task
					task.active = task.id is creep.activeTaskID	
			newPendingTasks.push task

		Memory.pendingTaskQueue = newPendingTasks

	createTask: () ->
		task = 
			prio: 1
			targetid: null
			id: Memory.taskIdCounter++ # unique
			type: null
			finishCond: null
			completed: false
			active: false

		return task

	pushTask: (task) ->	 	
		console.log "Adding task: #{task}"
		Memory.pendingTaskQueue.push (task)
		Memory.pendingTaskQueue.sort (taskA,taskB) ->	
			return taskA.prio - taskB.prio			

	getTaskById: (id) ->
		return null if not id
		for task in Memory.pendingTaskQueue
			if task.id is id
				return task
		return null

	run: (creep) ->		
		task = self.getTaskById(creep.memory.activeTaskID)
		return if not task

		completed = false

		switch task.type
			when TASK_REPAIR
				creep.say "Repair Task"
				target = Game.getObjectById(task.targetid)
				ret = require('repairer').repair creep, target
				if ret
					if not task.finishCond or target.hits > task.finishCond
						completed = true

		if completed
			creep.say "Done!"
			creep.memory.activeTaskID = false # this creep is done
			task.completed = true		
			task.active = false	

	assignTask: (task, creep) ->
		console.log "=============Matched #{creep} to #{task.id}================"
		creep.memory.activeTaskID = task.id
		task.active = true
		task.creepId = creep.id	

	matchTasks: (creeps) ->	
		return if Memory.pendingTaskQueue.length == 0
		
		total = 0
		active = 0
		completed = 0

		for task in Memory.pendingTaskQueue		
			total++
			if task.active
				active++
				continue
			if task.completed
				completed++
				continue		
			for name,creep of creeps				
				continue if creep.memory.activeTaskID
				if creep.memory.role is 'repairer'
					self.assignTask task, creep
					break
					
		console.log "Active Tasks #{active} / #{total}"



