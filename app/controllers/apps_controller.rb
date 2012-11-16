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
			
			BootstrapTadpole.perform_async(@app.id)

			if params[:type].to_i != 2
				#dont bootstrap git if we're creating an html stack
				BootstrapGit.perform_async(@app.id)
			end
			
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