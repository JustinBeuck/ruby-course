require 'singleton'

# made a singleton verion of ProjectList

class TM::ProjectList
  attr_reader :projects

  def initialize
    @projects = []
  end

  @@instance = TM::ProjectList.new

  def self.instance
    return @@instance
  end

  def create_project(title)
    proj = TM::Project.new(title)

    @projects << proj

    proj
  end



  # if don't add more to this,
  # will be unnecessary to test since it's simple
  # def list_projects
  #   @projects
  # end

  def show_proj_tasks_remaining(pid)
    # ensure id is an integer
    pid = pid.to_i

    proj = @projects.find { |project| project.id == pid }

    proj.list_incomplete_tasks
  end

  def show_proj_tasks_complete(pid)
    # ensure id is an integer
    pid = pid.to_i

    proj = @projects.find { |project| project.id == pid }

    proj.list_completed_tasks
  end

  def add_task_to_proj(pid, desc, priority)
    # ensure id and priority are integers
    pid = pid.to_i
    priority = priority.to_i

    proj = @projects.find { |project| project.id == pid }

    added_task = proj.add_task(desc, priority)
  end

  def mark_task_as_complete(tid)
    # ensure id is an integer
    tid = tid.to_i

    project = nil

    @projects.each do |proj|
      if proj.include_task?(tid)
        proj.mark_as_complete(tid)

        # set project variable to point to the project
        # that has the task we are looking for
        project = proj
      end
    end

    # return the task with id = tid
    marked_task = project.tasks.find { |task| task.id == tid }
  end

  private_class_method :new

end