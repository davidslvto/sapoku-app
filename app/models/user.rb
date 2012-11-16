class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :apps

  validates_uniqueness_of :ssh_public_key

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :ssh_public_key
  # attr_accessible :title, :body

  after_create :add_key_to_master_repo

  def add_key_to_master_repo
    RepoHelper.execute REPO_PATH do |helper|
      helper.add_user_key self.id, self.ssh_public_key.split(" ")[1]
    end
  end
end
