class BootstrapGit
	include Sidekiq::Worker

	def perform(app_id)
		app = App.find app_id

		RepoHelper.execute REPO_PATH do |helper|
      		helper.create_new_repo app.name, app.user_id
    	end

		app.increment! :bootstraped
	end
end