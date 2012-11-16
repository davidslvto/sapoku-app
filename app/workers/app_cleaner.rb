class AppCleaner
  include Sidekiq::Worker

  def perform(app)
    puts "Deleting Git repository for '#{app}'..."

    RepoHelper.execute REPO_PATH do |helper|
      helper.delete_repo app
    end

    # TODO tadpole extermination
    tadpole = Tadpole.find app
    if tadpole.nil?
      puts "Weird... couldn't find a tadpole for '#{app}'..."
    else
      puts "Destroying tadpole for '#{app}'..."
      #tadpole.destroy
    end
  end
end
