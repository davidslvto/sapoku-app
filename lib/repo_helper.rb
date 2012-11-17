require 'gitolite'


class RepoHelper

  # Constants

  DEFAULT_REPO_PATH = "/home/sapoku/gitolite-admin"


  private
  attr_reader :admin_repo
  public


  # Creation

  def initialize(options = {})
    repo_path = options.fetch :repo_path, DEFAULT_REPO_PATH

    # The admin repo
    @admin_repo = Gitolite::GitoliteAdmin.new(repo_path)
  end


  # Static helpers

  def self.execute(repo_path = DEFAULT_REPO_PATH)
    helper = self.new repo_path: repo_path
    helper.prepare
    yield(helper) if block_given?
    helper.apply
  end


  # Interface

  # Calling prepare first ensures that all local changes are discarded (reset --hard), which is a good idea.
  def prepare
    admin_repo.update
    true
  end

  def apply
    admin_repo.save_and_apply
    puts "Added, commited & pushed"
    true
  end

  # For debug only
  def save
    admin_repo.save
  end

  # -- Key management

  def add_user_key(user_id, key_blob)
    key = Gitolite::SSHKey.new("ssh-rsa", key_blob, "user_#{user_id}")
    admin_repo.add_key key
    true
  end

  def del_user_key(user_id, key_blob)
    key = Gitolite::SSHKey.new("ssh-rsa", key_blob, "user_#{user_id}")
    admin_repo.rm_key key
    true
  end

  # -- Repo management

  def create_new_repo(app_name, owner_id = nil)
    if admin_repo.config.has_repo? app_name
      puts "Repo for app '#{app_name}' already exists"
      return false
    end

    repo = Gitolite::Config::Repo.new(app_name)
    admin_repo.config.add_repo repo
    set_permissions(app_name, owner_id) unless owner_id.nil?
    true
  end

  def delete_repo(app_name)
    unless admin_repo.config.has_repo? app_name
      puts "Repo for app '#{app_name}' doesn't exists"
      return false
    end

    repo = Gitolite::Config::Repo.new(app_name)
    admin_repo.config.rm_repo repo
    true
  end

  def set_permissions(app_name, *users)
    repo = admin_repo.config.get_repo app_name
    if repo.nil?
      puts "Repo for app '#{app_name}' doesn't exist"
      return false
    end

    repo.clean_permissions
    repo.add_permission "RW+", "", *(users.map { |u| "user_#{u}" })
    repo.add_permission "R", "", "tadpole"
    true
  end
end
