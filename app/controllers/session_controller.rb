class SessionController < ApplicationController
	def index
		render :index
	end

	def create
		lender = Lender.find_by(email: params[:email])
		borrower = Borrower.find_by(email: params[:email])
		if lender && lender.password == params[:password]
			session[:user_id] = lender.id
			redirect_to "/online_lending/lender/#{lender.id}"
		elsif borrower && borrower.password == params[:password]
			session[:user_id] = borrower.id
			redirect_to "/online_lending/borrower/#{borrower.id}"
		else
			flash[:errors] = ["Invalid Login"]
			redirect_to :back
		end
	end

	def logout
		session[:user_id] = nil
		flash[:success] = "Logout successful!"
		redirect_to "/online_lending/login"
	end
end
