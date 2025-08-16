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
  end

  # POST /tasks or /tasks.json
  def create
    @task = @user.tasks.build(task_params)
    @task.due_at = Time.current # Valor padrão temporário para teste

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
        # format.html { redirect_to @task, notice: "Task was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @task }
        format.turbo_stream
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
      format.html { redirect_to tasks_path, notice: "Task was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    def set_user
      @user = Current.user
    end

    def set_todo_tasks
      @todo_tasks = @user.tasks.where(concluded: false)
    end

    def set_concluded_tasks
      @concluded_tasks = @user.tasks.where(concluded: true)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.expect(task: [ :title, :description, :concluded, :concluded_at ])
    end
end
