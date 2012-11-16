class BootstrapTadpole
	STACK_TYPES = {0 => 'ruby', 1 => 'node', 2 => 'html'}

	include Sidekiq::Worker

	def perform(app_id, stack_type=0)
		app = App.find app_id

    	t = Tadpole.new app.name, STACK_TYPES[stack_type]
    	t.userid = app.user_id
    	t.save
    	t.bootstrap

		App.connection.execute "update apps set bootstraped = bootstraped + 1 where id = #{app.id}"
	end
end