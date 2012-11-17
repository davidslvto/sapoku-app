class HomeController < ApplicationController
	def index
		redirect_to apps_path if user_signed_in?
	end
end