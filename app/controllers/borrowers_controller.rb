class BorrowersController < ApplicationController
	def create
		b = Borrower.new(borrower_params)
		if b.save
			b = Borrower.find(b.id)
			b.update(raised: 0)
			flash[:success] = "Borrower account successfully created!"
			redirect_to "/online_lending/login"
		else
			flash[:errors] = b.errors.full_messages
			redirect_to :back
		end
	end

	def show
		if session[:user_id] 
			@user = Borrower.find(session[:user_id])
			@lenders = @user.histories.joins(:lender).select("*")
			render :show
		else
			flash[:errors] = ["Must be logged in to view your page"]
			redirect_to "/online_lending/login"
		end
	end

	private
		def borrower_params
			params.require(:borrower).permit(:first_name, :last_name, :email, :password, :purpose, :description, :money)
		end
end
