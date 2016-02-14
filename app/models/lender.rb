class Lender < ActiveRecord::Base
	has_many :histories
	has_many :borrowers, through: :histories

	validates :first_name, :last_name, :email, :password, :money, presence: true
end
