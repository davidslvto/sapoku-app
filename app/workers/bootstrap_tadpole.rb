class BootstrapTadpole
	include Sidekiq::Worker

	def perform(app_id)
		app = App.find app_id

    	t = Tadpole.new app.name
    	t.userid = app.user_id
    	t.save
    	t.bootstrap

		app.increment! :bootstraped
	end
end