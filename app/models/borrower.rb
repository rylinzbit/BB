class Borrower < ActiveRecord::Base
	has_many :histories
	has_many :lenders, through: :histories

	validates :first_name, :last_name, :email, :password, :purpose, :description, :money, presence: true 
end
