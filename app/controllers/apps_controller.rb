class AppsController < ApplicationController
	before_filter :authenticate_user!

	def new
		@app = App.new
	end

	def create
		@app = App.new
		@app.user = current_user
		@app.name = params[:app][:name].downcase.gsub(' ','_')
		if @app.save
			redirect_to @app
		end
	end

	def show
		@app = App.find_by_name params[:id]
	end

	def destroy
		@app = App.find_by_name params[:id]
		@app.destroy

		redirect_to '/'
	end
end