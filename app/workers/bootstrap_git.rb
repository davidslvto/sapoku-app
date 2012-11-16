class BootstrapGit
	include Sidekiq::Worker

	def perform(app_id)
		app = App.find app_id

		RepoHelper.execute REPO_PATH do |helper|
      		helper.create_new_repo app.name, app.user_id
    	end

    	App.connection.execute "update apps set bootstraped = bootstraped + 1 where id = #{app.id}"
	end
end