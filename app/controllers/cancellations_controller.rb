class CancellationsController < ApplicationController
    #before_action :set_cancellation, only: [:show, :edit, :update, :destroy]
    before_action :authenticate_user!, except: [:show]
    
    
    def show
        @log = Log.find(params[:id])
        @cancellation = @log.cancellations.find(params[:log_id])
    end
    
    def new
        @log = Log.find(params[:log_id])
        @cancellation = @log.cancellations.build
        @trainers = User.all
    end
    
    def create
        @log = Log.find(params[:log_id])
        @cancellation = @log.cancellations.build(cancellation_params)
        if @cancellation.save
            create_event("created", "#{@cancellation.stage} cancellation for #{@cancellation.member} from #{@cancellation.company}")
            redirect_to @log
        else
            render 'new'
        end
    end
    
    def edit
        @log = Log.find(params[:id])
        @cancellation = @log.cancellations.find(params[:log_id])
        @trainers = User.all
    end
    
    def update
        @log = Log.find(params[:log_id])
        @cancellation = @log.cancellations.find(params[:id]) 
        if @cancellation.update(cancellation_params)
            create_event("updated", "#{@cancellation.status} cancellation for #{@cancellation.member} from #{@cancellation.company}")
            redirect_to @log
        else
            render 'edit'
        end
    end
    
    def destroy
        @log = Log.find(params[:id])
        @cancellation = @log.cancellations.find(params[:log_id])
        create_event("destroyed", "#{@cancellation.status} cancellation for #{@cancellation.member} from #{@cancellation.company}")
        @cancellation.destroy 
        redirect_to @log
    end
    
    private
    
        def cancellation_params
           params.require(:cancellation).permit(:member, :company, :trainer, :stage, :notes, :status, :log_id) 
        end
        
        def set_cancellation
            @log = Log.find(params[:id])
            @cancellation = @log.cancellations.find(params[:log_id]) 
        end
end
