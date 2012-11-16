class App < ActiveRecord::Base
  # attr_accessible :title, :body

  validates_uniqueness_of :name

  after_destroy :delete_repo

  belongs_to :user

  def to_param
    self.name
  end

  def is_bootstrap_done?
    self.bootstraped == 2
  end

  def delete_repo
    RepoHelper.execute REPO_PATH do |helper|
      helper.delete_repo self.name
    end
  end
end
