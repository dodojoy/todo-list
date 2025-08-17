class TasksController < ApplicationController
  before_action :set_user
  before_action :set_task, only: %i[ show edit update destroy ]
  before_action :set_concluded_tasks, only: %i[ index ]
  before_action :set_todo_tasks, only: %i[ index ]
  # GET /tasks or /tasks.json
  def index
    @tasks = @user.tasks.all
    @task = Task.new
  end

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
    @task = Task.find(params[:id])
    
    respond_to do |format|
      format.html do
        if request.xhr?
          render partial: "tasks/edit_form", locals: { task: @task }
        else
          render :edit
        end
      end
      format.json { render json: @task }
    end
  end

  # POST /tasks or /tasks.json
  def create
    @task = @user.tasks.build(task_params)
    if @task.due_at.blank?
      estimated_hours = OpenaiService.estimate_task_time(@task.title, @task.description)
      
      if estimated_hours
        if @task.concluded
          @task.due_at = nil
        else
          @task.due_at = Time.current.advance(hours: estimated_hours)
        end
      else
        @task.due_at = nil
      end
    end

    respond_to do |format|
      if @task.save
        format.html { redirect_to tasks_path }
        format.json { render :show, status: :created, location: @tasks_path }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.json { render :show, status: :ok, location: @task }
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.remove(@task), 

            turbo_stream.replace(
              "tasks",
              partial: "tasks/list",
              locals: { tasks: @user.tasks.where(concluded: false).order(updated_at: :asc), list_id: "tasks", empty_message: "No tasks found." }
            ),

            turbo_stream.replace(
              "concluded-tasks",
              partial: "tasks/list",
              locals: { tasks: @user.tasks.where(concluded: true).order(updated_at: :asc), list_id: "concluded-tasks", empty_message: "No concluded tasks found." }
            ),

            turbo_stream.append_all("#edit_task_dialog", "<script>document.querySelector('#edit_task_dialog').close();</script>")
          ]
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy!

    respond_to do |format|
      format.html { redirect_to tasks_path }
      format.json { head :no_content }
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove(@task),
          turbo_stream.replace("tasks", partial: "tasks/list", locals: { tasks: @user.tasks.where(concluded: false).order(updated_at: :asc), list_id: "tasks", empty_message: "No tasks found." }),
          turbo_stream.replace("concluded-tasks", partial: "tasks/list", locals: { tasks: @user.tasks.where(concluded: true).order(updated_at: :asc), list_id: "concluded-tasks", empty_message: "No concluded tasks found." }),
          turbo_stream.append_all("#delete_task_dialog", "<script>document.querySelector('#delete_task_dialog').close();</script>")
        ]
      end
    end
  end

  private
    def set_user
      @user = Current.user
    end

    def set_todo_tasks
      @todo_tasks = @user.tasks.where(concluded: false).order(updated_at: :asc)
    end

    def set_concluded_tasks
      @concluded_tasks = @user.tasks.where(concluded: true).order(updated_at: :asc)
    end

    def set_task
      @task = Task.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:title, :description, :concluded, :concluded_at, :due_at)
    end
end
