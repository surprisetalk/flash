defmodule FlashWeb.TaskView do
  use FlashWeb, :view
  alias FlashWeb.TaskView

  def render("index.json", %{tasks: tasks}) do
    %{data: render_many(tasks, TaskView, "task.json")}
  end

  def render("show.json", %{task: task}) do
    %{data: render_one(task, TaskView, "task.json")}
  end

  def render("task.json", %{task: task}) do
    %{id: task.id,
      body: task.body,
      priority: task.priority,
      is_completed: task.is_completed}
  end
end
