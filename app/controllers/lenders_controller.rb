class LendersController < ApplicationController
	def create
		l = Lender.new(lender_params)
		if l.save
			flash[:success] = "Lender account successfully created!"
			redirect_to "/online_lending/login"
		else
			flash[:errors] = l.errors.full_messages
			redirect_to :back
		end
	end

	def lend
		user = Lender.find(session[:user_id])
		borrower = Borrower.find(params[:borrower_id])
		lend = params[:lend_money].to_f
		if user.money >= lend
			hist = History.new(amount: lend, lender_id: user.id, borrower_id: borrower.id)
			if hist.save
				new_money = user.money - lend
				user.update(money: new_money)
				new_raised = borrower.raised + lend
				borrower.update(raised: new_raised)
			else
			flash[:errors] = ["Was unable to lend money"]
			end
		else
			flash[:errors] = ["Insufficient funds"]
		end
		redirect_to :back
	end

	def show
		if session[:user_id] 
			@user = Lender.find(session[:user_id])
			@borrowers = Borrower.all
			@borrowed = @user.histories.joins(:borrower).select("*")
			render :show
		else
			flash[:errors] = ["Must be logged in to view your page"]
			redirect_to "/online_lending/login"
		end
	end

	private
		def lender_params
			params.require(:lender).permit(:first_name, :last_name, :email, :password, :money)
		end
end
