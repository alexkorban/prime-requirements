class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :http_authenticatable, :token_authenticatable, :lockable, :timeoutable and :activatable
  devise :registerable, :database_authenticatable, :confirmable, :recoverable,
         :rememberable, :trackable, :validatable, :invitable, :timeoutable, :timeout_in => 20.minutes
  # use devise_invitable for email invitations

  belongs_to :account

  has_and_belongs_to_many :roles

  normalize_attribute :name

  validates_presence_of :name

  before_validation(:on => :create) { |user| user.name = user.email.split("@").first; true }

  def role?(role)
    !!roles.find_by_name(role.to_s)
  end

  def add_role(role)
    self.roles << Role.find_by_name(role.to_s) if !role?(role)
  end

  def remove_role(role)
    roles.delete(Role.find_by_name(role.to_s))
  end
end
