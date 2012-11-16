class App < ActiveRecord::Base
  # attr_accessible :title, :body

  validates_uniqueness_of :name

  belongs_to :user

  def to_param
    self.name
  end

  def is_bootstrap_done?
    self.bootstraped == 2
  end
end
