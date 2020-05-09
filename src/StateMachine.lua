StateMachine = Class{}

--enter, exit, render, update

function StateMachine:init(states)
	self.empty = {
		enter = function() end,
		exit = function() end,
		render = function() end,
		update = function() end,
	}
	self.current = self.empty
	self.states = states or {}
end

function StateMachine:change(state, enterParams)
	assert(self.states[state])
	self.current:exit()
	self.current = self.states[state]()
	self.current:enter(enterParams)
end

function StateMachine:render()
	self.current:render()
end

function StateMachine:update(dt)
	self.current:update(dt)
end